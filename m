Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837Ab3BOWMn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 17:12:43 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49023 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab3BOWMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 17:12:41 -0500
Date: Fri, 15 Feb 2013 14:12:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nathan Zimmer <nzimmer@sgi.com>
Cc: viro@zeniv.linux.org.uk, eric.dumazet@gmail.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 resend] procfs: Improve Scaling in proc
Message-Id: <20130215141239.99a3bccc.akpm@linux-foundation.org>
In-Reply-To: <1360961274-24652-1-git-send-email-nzimmer@sgi.com>
References: <1360961274-24652-1-git-send-email-nzimmer@sgi.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Feb 2013 14:47:54 -0600
Nathan Zimmer <nzimmer@sgi.com> wrote:

> I am currently tracking a hotlock reported by a customer on a large system,
> 512 cores.  I am currently running 3.8-rc7 but the issue looks like it has been
> this way for a very long time.
> The offending lock is proc_dir_entry->pde_unload_lock.
> 
> This patch converts the replaces the lock with the rcu. However the pde_openers
> list still is controlled by a spin lock. I tested on a 4096 machine and the lock
> doesn't seem hot at least according to perf.
> 
> This is a refresh/resend of what was orignally suggested by Eric Dumazet some 
> time ago.  
> 
> Supporting numbers, lower is better, they are from the test I posted earlier.
> cpuinfo baseline        Rcu
> tasks   read-sec        read-sec
> 1       0.0141          0.0141
> 2       0.0140          0.0142
> 4       0.0140          0.0141
> 8       0.0145          0.0140
> 16      0.0553          0.0168
> 32      0.1688          0.0549
> 64      0.5017          0.1690
> 128     1.7005          0.5038
> 256     5.2513          2.0804
> 512     8.0529          3.0162
>
> ...
> 
> diff --git a/fs/proc/generic.c b/fs/proc/generic.c
> index 76ddae8..6896a70 100644
> --- a/fs/proc/generic.c
> +++ b/fs/proc/generic.c
> @@ -191,13 +191,16 @@ proc_file_read(struct file *file, char __user *buf, size_t nbytes,
>  	struct proc_dir_entry *pde = PDE(file->f_path.dentry->d_inode);
>  	ssize_t rv = -EIO;
>  
> -	spin_lock(&pde->pde_unload_lock);
> -	if (!pde->proc_fops) {
> -		spin_unlock(&pde->pde_unload_lock);
> +	const struct file_operations *fops;

There's now a stray newline in the definitions section.

> +	rcu_read_lock();
> +	fops = rcu_dereference(pde->proc_fops);
> +	if (!fops) {
> +		rcu_read_unlock();
>  		return rv;
>  	}
> -	pde->pde_users++;
> -	spin_unlock(&pde->pde_unload_lock);
> +	atomic_inc(&pde->pde_users);
> +	rcu_read_unlock();

So what's up with pde_users?  Seems that it's atomic_t *and* uses a
form of RCU protection.  We can't make it a plain old integer because
it's modified under rcu_read_lock() and we can't move the atomic_inc()
outside rcu_read_lock() because of the synchronization games in
remove_proc_entry()?

>  	rv = __proc_file_read(file, buf, nbytes, ppos);
>  
>
> ...
>
> @@ -802,37 +809,30 @@ void remove_proc_entry(const char *name, struct proc_dir_entry *parent)
>  		return;
>  	}
>  
> -	spin_lock(&de->pde_unload_lock);
>  	/*
>  	 * Stop accepting new callers into module. If you're
>  	 * dynamically allocating ->proc_fops, save a pointer somewhere.
>  	 */
> -	de->proc_fops = NULL;
> -	/* Wait until all existing callers into module are done. */
> -	if (de->pde_users > 0) {
> -		DECLARE_COMPLETION_ONSTACK(c);
> -
> -		if (!de->pde_unload_completion)
> -			de->pde_unload_completion = &c;
>  
> -		spin_unlock(&de->pde_unload_lock);
> +	rcu_assign_pointer(de->proc_fops, NULL);
> +	synchronize_rcu();
> +	/* Wait until all existing callers into module are done. */
>  
> +	DECLARE_COMPLETION_ONSTACK(c);

This should have generated a c99-style definition warning.  Did your
compiler version not do this?

> +	de->pde_unload_completion = &c;
> +	if (!atomic_dec_and_test(&de->pde_users))
>  		wait_for_completion(de->pde_unload_completion);
>  
> -		spin_lock(&de->pde_unload_lock);
> -	}
> -
> +	spin_lock(&de->pde_openers_lock);
>  	while (!list_empty(&de->pde_openers)) {
>  		struct pde_opener *pdeo;
>  
>  		pdeo = list_first_entry(&de->pde_openers, struct pde_opener, lh);
>  		list_del(&pdeo->lh);
> -		spin_unlock(&de->pde_unload_lock);
>  		pdeo->release(pdeo->inode, pdeo->file);
>  		kfree(pdeo);
> -		spin_lock(&de->pde_unload_lock);
>  	}
> -	spin_unlock(&de->pde_unload_lock);
> +	spin_unlock(&de->pde_openers_lock);
>  
>  	if (S_ISDIR(de->mode))
>  		parent->nlink--;
>
> ...
>
>  static loff_t proc_reg_llseek(struct file *file, loff_t offset, int whence)
>  {
> +	const struct file_operations *fops;
>  	struct proc_dir_entry *pde = PDE(file->f_path.dentry->d_inode);
>  	loff_t rv = -EINVAL;
>  	loff_t (*llseek)(struct file *, loff_t, int);
>  
> -	spin_lock(&pde->pde_unload_lock);
> +	rcu_read_lock();
> +	fops = rcu_dereference(pde->proc_fops);
>  	/*
>  	 * remove_proc_entry() is going to delete PDE (as part of module
>  	 * cleanup sequence). No new callers into module allowed.
>  	 */
> -	if (!pde->proc_fops) {
> -		spin_unlock(&pde->pde_unload_lock);
> +	if (!fops) {
> +		rcu_read_unlock();
>  		return rv;
>  	}
>  	/*
>  	 * Bump refcount so that remove_proc_entry will wail for ->llseek to
>  	 * complete.
>  	 */
> -	pde->pde_users++;
> +	atomic_inc(&pde->pde_users);
>  	/*
>  	 * Save function pointer under lock, to protect against ->proc_fops
>  	 * NULL'ifying right after ->pde_unload_lock is dropped.
>  	 */

This comment needs updating.

However, it doesn't appear to be true any more.  With this patch we no
longer set ->fops to NULL in remove_proc_entry().  (What replaced that
logic?)

So are all these games with local variable `llseek' still needed? 
afaict the increment of pde_users will stabilize ->fops?


> -	llseek = pde->proc_fops->llseek;
> -	spin_unlock(&pde->pde_unload_lock);
> +	llseek = fops->llseek;
> +	rcu_read_unlock();
>  
>  	if (!llseek)
>  		llseek = default_llseek;
> @@ -182,15 +176,17 @@ static ssize_t proc_reg_read(struct file *file, char __user *buf, size_t count,
>  	struct proc_dir_entry *pde = PDE(file->f_path.dentry->d_inode);
>  	ssize_t rv = -EIO;
>  	ssize_t (*read)(struct file *, char __user *, size_t, loff_t *);
> +	const struct file_operations *fops;
>  
> -	spin_lock(&pde->pde_unload_lock);
> -	if (!pde->proc_fops) {
> -		spin_unlock(&pde->pde_unload_lock);
> +	rcu_read_lock();
> +	fops = rcu_dereference(pde->proc_fops);
> +	if (!fops) {
> +		rcu_read_unlock();
>  		return rv;
>  	}
> -	pde->pde_users++;
> -	read = pde->proc_fops->read;
> -	spin_unlock(&pde->pde_unload_lock);
> +	atomic_inc(&pde->pde_users);
> +	read = fops->read;
> +	rcu_read_unlock();

Many dittoes.

>  	if (read)
>  		rv = read(file, buf, count, ppos);
> @@ -204,15 +200,17 @@ static ssize_t proc_reg_write(struct file *file, const char __user *buf, size_t
>  	struct proc_dir_entry *pde = PDE(file->f_path.dentry->d_inode);
>  	ssize_t rv = -EIO;
>  	ssize_t (*write)(struct file *, const char __user *, size_t, loff_t *);
> +	const struct file_operations *fops;
>  
> -	spin_lock(&pde->pde_unload_lock);
> -	if (!pde->proc_fops) {
> -		spin_unlock(&pde->pde_unload_lock);
> +	rcu_read_lock();
> +	fops = rcu_dereference(pde->proc_fops);
> +	if (!fops) {
> +		rcu_read_unlock();
>  		return rv;
>  	}
> -	pde->pde_users++;
> -	write = pde->proc_fops->write;
> -	spin_unlock(&pde->pde_unload_lock);
> +	atomic_inc(&pde->pde_users);
> +	write = fops->write;
> +	rcu_read_unlock();
>
> ...
>
