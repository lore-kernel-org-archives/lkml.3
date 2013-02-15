Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751232Ab3BOUtI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 15:49:08 -0500
Received: from relay2.sgi.com ([192.48.179.30]:39813 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750755Ab3BOUtG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 15:49:06 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
To: viro@zeniv.linux.org.uk, eric.dumazet@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Nathan Zimmer <nzimmer@sgi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH v3 resend] procfs: Improve Scaling in proc
Date: Fri, 15 Feb 2013 14:47:54 -0600
Message-Id: <1360961274-24652-1-git-send-email-nzimmer@sgi.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am currently tracking a hotlock reported by a customer on a large system,
512 cores.  I am currently running 3.8-rc7 but the issue looks like it has been
this way for a very long time.
The offending lock is proc_dir_entry->pde_unload_lock.

This patch converts the replaces the lock with the rcu. However the pde_openers
list still is controlled by a spin lock. I tested on a 4096 machine and the lock
doesn't seem hot at least according to perf.

This is a refresh/resend of what was orignally suggested by Eric Dumazet some 
time ago.  

Supporting numbers, lower is better, they are from the test I posted earlier.
cpuinfo baseline        Rcu
tasks   read-sec        read-sec
1       0.0141          0.0141
2       0.0140          0.0142
4       0.0140          0.0141
8       0.0145          0.0140
16      0.0553          0.0168
32      0.1688          0.0549
64      0.5017          0.1690
128     1.7005          0.5038
256     5.2513          2.0804
512     8.0529          3.0162

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com> 
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
---
 fs/proc/generic.c       |  58 +++++++++---------
 fs/proc/inode.c         | 156 ++++++++++++++++++++++++++----------------------
 include/linux/proc_fs.h |   6 +-
 3 files changed, 118 insertions(+), 102 deletions(-)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 76ddae8..6896a70 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -191,13 +191,16 @@ proc_file_read(struct file *file, char __user *buf, size_t nbytes,
 	struct proc_dir_entry *pde = PDE(file->f_path.dentry->d_inode);
 	ssize_t rv = -EIO;
 
-	spin_lock(&pde->pde_unload_lock);
-	if (!pde->proc_fops) {
-		spin_unlock(&pde->pde_unload_lock);
+	const struct file_operations *fops;
+
+	rcu_read_lock();
+	fops = rcu_dereference(pde->proc_fops);
+	if (!fops) {
+		rcu_read_unlock();
 		return rv;
 	}
-	pde->pde_users++;
-	spin_unlock(&pde->pde_unload_lock);
+	atomic_inc(&pde->pde_users);
+	rcu_read_unlock();
 
 	rv = __proc_file_read(file, buf, nbytes, ppos);
 
@@ -213,13 +216,16 @@ proc_file_write(struct file *file, const char __user *buffer,
 	ssize_t rv = -EIO;
 
 	if (pde->write_proc) {
-		spin_lock(&pde->pde_unload_lock);
-		if (!pde->proc_fops) {
-			spin_unlock(&pde->pde_unload_lock);
+		const struct file_operations *fops;
+
+		rcu_read_lock();
+		fops = rcu_dereference(pde->proc_fops);
+		if (!fops) {
+			rcu_read_unlock();
 			return rv;
 		}
-		pde->pde_users++;
-		spin_unlock(&pde->pde_unload_lock);
+		atomic_inc(&pde->pde_users);
+		rcu_read_unlock();
 
 		/* FIXME: does this routine need ppos?  probably... */
 		rv = pde->write_proc(file, buffer, count, pde->data);
@@ -558,7 +564,7 @@ static int proc_register(struct proc_dir_entry * dir, struct proc_dir_entry * dp
 
 	if (S_ISDIR(dp->mode)) {
 		if (dp->proc_iops == NULL) {
-			dp->proc_fops = &proc_dir_operations;
+			RCU_INIT_POINTER(dp->proc_fops, &proc_dir_operations);
 			dp->proc_iops = &proc_dir_inode_operations;
 		}
 		dir->nlink++;
@@ -567,7 +573,7 @@ static int proc_register(struct proc_dir_entry * dir, struct proc_dir_entry * dp
 			dp->proc_iops = &proc_link_inode_operations;
 	} else if (S_ISREG(dp->mode)) {
 		if (dp->proc_fops == NULL)
-			dp->proc_fops = &proc_file_operations;
+			RCU_INIT_POINTER(dp->proc_fops, &proc_file_operations);
 		if (dp->proc_iops == NULL)
 			dp->proc_iops = &proc_file_inode_operations;
 	}
@@ -620,7 +626,8 @@ static struct proc_dir_entry *__proc_create(struct proc_dir_entry **parent,
 	ent->mode = mode;
 	ent->nlink = nlink;
 	atomic_set(&ent->count, 1);
-	spin_lock_init(&ent->pde_unload_lock);
+	atomic_set(&ent->pde_users, 1);
+	spin_lock_init(&ent->pde_openers_lock);
 	INIT_LIST_HEAD(&ent->pde_openers);
 out:
 	return ent;
@@ -744,7 +751,7 @@ struct proc_dir_entry *proc_create_data(const char *name, umode_t mode,
 	pde = __proc_create(&parent, name, mode, nlink);
 	if (!pde)
 		goto out;
-	pde->proc_fops = proc_fops;
+	rcu_assign_pointer(pde->proc_fops, proc_fops);
 	pde->data = data;
 	if (proc_register(parent, pde) < 0)
 		goto out_free;
@@ -802,37 +809,30 @@ void remove_proc_entry(const char *name, struct proc_dir_entry *parent)
 		return;
 	}
 
-	spin_lock(&de->pde_unload_lock);
 	/*
 	 * Stop accepting new callers into module. If you're
 	 * dynamically allocating ->proc_fops, save a pointer somewhere.
 	 */
-	de->proc_fops = NULL;
-	/* Wait until all existing callers into module are done. */
-	if (de->pde_users > 0) {
-		DECLARE_COMPLETION_ONSTACK(c);
-
-		if (!de->pde_unload_completion)
-			de->pde_unload_completion = &c;
 
-		spin_unlock(&de->pde_unload_lock);
+	rcu_assign_pointer(de->proc_fops, NULL);
+	synchronize_rcu();
+	/* Wait until all existing callers into module are done. */
 
+	DECLARE_COMPLETION_ONSTACK(c);
+	de->pde_unload_completion = &c;
+	if (!atomic_dec_and_test(&de->pde_users))
 		wait_for_completion(de->pde_unload_completion);
 
-		spin_lock(&de->pde_unload_lock);
-	}
-
+	spin_lock(&de->pde_openers_lock);
 	while (!list_empty(&de->pde_openers)) {
 		struct pde_opener *pdeo;
 
 		pdeo = list_first_entry(&de->pde_openers, struct pde_opener, lh);
 		list_del(&pdeo->lh);
-		spin_unlock(&de->pde_unload_lock);
 		pdeo->release(pdeo->inode, pdeo->file);
 		kfree(pdeo);
-		spin_lock(&de->pde_unload_lock);
 	}
-	spin_unlock(&de->pde_unload_lock);
+	spin_unlock(&de->pde_openers_lock);
 
 	if (S_ISDIR(de->mode))
 		parent->nlink--;
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 439ae688..031af27 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -128,46 +128,40 @@ static const struct super_operations proc_sops = {
 	.show_options	= proc_show_options,
 };
 
-static void __pde_users_dec(struct proc_dir_entry *pde)
-{
-	pde->pde_users--;
-	if (pde->pde_unload_completion && pde->pde_users == 0)
-		complete(pde->pde_unload_completion);
-}
-
 void pde_users_dec(struct proc_dir_entry *pde)
 {
-	spin_lock(&pde->pde_unload_lock);
-	__pde_users_dec(pde);
-	spin_unlock(&pde->pde_unload_lock);
+	if (atomic_dec_and_test(&pde->pde_users) && pde->pde_unload_completion)
+		complete(pde->pde_unload_completion);
 }
 
 static loff_t proc_reg_llseek(struct file *file, loff_t offset, int whence)
 {
+	const struct file_operations *fops;
 	struct proc_dir_entry *pde = PDE(file->f_path.dentry->d_inode);
 	loff_t rv = -EINVAL;
 	loff_t (*llseek)(struct file *, loff_t, int);
 
-	spin_lock(&pde->pde_unload_lock);
+	rcu_read_lock();
+	fops = rcu_dereference(pde->proc_fops);
 	/*
 	 * remove_proc_entry() is going to delete PDE (as part of module
 	 * cleanup sequence). No new callers into module allowed.
 	 */
-	if (!pde->proc_fops) {
-		spin_unlock(&pde->pde_unload_lock);
+	if (!fops) {
+		rcu_read_unlock();
 		return rv;
 	}
 	/*
 	 * Bump refcount so that remove_proc_entry will wail for ->llseek to
 	 * complete.
 	 */
-	pde->pde_users++;
+	atomic_inc(&pde->pde_users);
 	/*
 	 * Save function pointer under lock, to protect against ->proc_fops
 	 * NULL'ifying right after ->pde_unload_lock is dropped.
 	 */
-	llseek = pde->proc_fops->llseek;
-	spin_unlock(&pde->pde_unload_lock);
+	llseek = fops->llseek;
+	rcu_read_unlock();
 
 	if (!llseek)
 		llseek = default_llseek;
@@ -182,15 +176,17 @@ static ssize_t proc_reg_read(struct file *file, char __user *buf, size_t count,
 	struct proc_dir_entry *pde = PDE(file->f_path.dentry->d_inode);
 	ssize_t rv = -EIO;
 	ssize_t (*read)(struct file *, char __user *, size_t, loff_t *);
+	const struct file_operations *fops;
 
-	spin_lock(&pde->pde_unload_lock);
-	if (!pde->proc_fops) {
-		spin_unlock(&pde->pde_unload_lock);
+	rcu_read_lock();
+	fops = rcu_dereference(pde->proc_fops);
+	if (!fops) {
+		rcu_read_unlock();
 		return rv;
 	}
-	pde->pde_users++;
-	read = pde->proc_fops->read;
-	spin_unlock(&pde->pde_unload_lock);
+	atomic_inc(&pde->pde_users);
+	read = fops->read;
+	rcu_read_unlock();
 
 	if (read)
 		rv = read(file, buf, count, ppos);
@@ -204,15 +200,17 @@ static ssize_t proc_reg_write(struct file *file, const char __user *buf, size_t
 	struct proc_dir_entry *pde = PDE(file->f_path.dentry->d_inode);
 	ssize_t rv = -EIO;
 	ssize_t (*write)(struct file *, const char __user *, size_t, loff_t *);
+	const struct file_operations *fops;
 
-	spin_lock(&pde->pde_unload_lock);
-	if (!pde->proc_fops) {
-		spin_unlock(&pde->pde_unload_lock);
+	rcu_read_lock();
+	fops = rcu_dereference(pde->proc_fops);
+	if (!fops) {
+		rcu_read_unlock();
 		return rv;
 	}
-	pde->pde_users++;
-	write = pde->proc_fops->write;
-	spin_unlock(&pde->pde_unload_lock);
+	atomic_inc(&pde->pde_users);
+	write = fops->write;
+	rcu_read_unlock();
 
 	if (write)
 		rv = write(file, buf, count, ppos);
@@ -226,15 +224,17 @@ static unsigned int proc_reg_poll(struct file *file, struct poll_table_struct *p
 	struct proc_dir_entry *pde = PDE(file->f_path.dentry->d_inode);
 	unsigned int rv = DEFAULT_POLLMASK;
 	unsigned int (*poll)(struct file *, struct poll_table_struct *);
+	const struct file_operations *fops;
 
-	spin_lock(&pde->pde_unload_lock);
-	if (!pde->proc_fops) {
-		spin_unlock(&pde->pde_unload_lock);
+	rcu_read_lock();
+	fops = rcu_dereference(pde->proc_fops);
+	if (!fops) {
+		rcu_read_unlock();
 		return rv;
 	}
-	pde->pde_users++;
-	poll = pde->proc_fops->poll;
-	spin_unlock(&pde->pde_unload_lock);
+	atomic_inc(&pde->pde_users);
+	poll = fops->poll;
+	rcu_read_unlock();
 
 	if (poll)
 		rv = poll(file, pts);
@@ -248,15 +248,17 @@ static long proc_reg_unlocked_ioctl(struct file *file, unsigned int cmd, unsigne
 	struct proc_dir_entry *pde = PDE(file->f_path.dentry->d_inode);
 	long rv = -ENOTTY;
 	long (*ioctl)(struct file *, unsigned int, unsigned long);
+	const struct file_operations *fops;
 
-	spin_lock(&pde->pde_unload_lock);
-	if (!pde->proc_fops) {
-		spin_unlock(&pde->pde_unload_lock);
+	rcu_read_lock();
+	fops = rcu_dereference(pde->proc_fops);
+	if (!fops) {
+		rcu_read_unlock();
 		return rv;
 	}
-	pde->pde_users++;
-	ioctl = pde->proc_fops->unlocked_ioctl;
-	spin_unlock(&pde->pde_unload_lock);
+	atomic_inc(&pde->pde_users);
+	ioctl = fops->unlocked_ioctl;
+	rcu_read_unlock();
 
 	if (ioctl)
 		rv = ioctl(file, cmd, arg);
@@ -271,15 +273,17 @@ static long proc_reg_compat_ioctl(struct file *file, unsigned int cmd, unsigned
 	struct proc_dir_entry *pde = PDE(file->f_path.dentry->d_inode);
 	long rv = -ENOTTY;
 	long (*compat_ioctl)(struct file *, unsigned int, unsigned long);
+	const struct file_operations *fops;
 
-	spin_lock(&pde->pde_unload_lock);
-	if (!pde->proc_fops) {
-		spin_unlock(&pde->pde_unload_lock);
+	rcu_read_lock();
+	fops = rcu_dereference(pde->proc_fops);
+	if (!fops) {
+		rcu_read_unlock();
 		return rv;
 	}
-	pde->pde_users++;
+	atomic_inc(&pde->pde_users);
 	compat_ioctl = pde->proc_fops->compat_ioctl;
-	spin_unlock(&pde->pde_unload_lock);
+	rcu_read_unlock();
 
 	if (compat_ioctl)
 		rv = compat_ioctl(file, cmd, arg);
@@ -294,15 +298,17 @@ static int proc_reg_mmap(struct file *file, struct vm_area_struct *vma)
 	struct proc_dir_entry *pde = PDE(file->f_path.dentry->d_inode);
 	int rv = -EIO;
 	int (*mmap)(struct file *, struct vm_area_struct *);
+	const struct file_operations *fops;
 
-	spin_lock(&pde->pde_unload_lock);
-	if (!pde->proc_fops) {
-		spin_unlock(&pde->pde_unload_lock);
+	rcu_read_lock();
+	fops = rcu_dereference(pde->proc_fops);
+	if (!fops) {
+		rcu_read_unlock();
 		return rv;
 	}
-	pde->pde_users++;
+	atomic_inc(&pde->pde_users);
 	mmap = pde->proc_fops->mmap;
-	spin_unlock(&pde->pde_unload_lock);
+	rcu_read_unlock();
 
 	if (mmap)
 		rv = mmap(file, vma);
@@ -318,6 +324,7 @@ static int proc_reg_open(struct inode *inode, struct file *file)
 	int (*open)(struct inode *, struct file *);
 	int (*release)(struct inode *, struct file *);
 	struct pde_opener *pdeo;
+	const struct file_operations *fops;
 
 	/*
 	 * What for, you ask? Well, we can have open, rmmod, remove_proc_entry
@@ -333,32 +340,33 @@ static int proc_reg_open(struct inode *inode, struct file *file)
 	if (!pdeo)
 		return -ENOMEM;
 
-	spin_lock(&pde->pde_unload_lock);
-	if (!pde->proc_fops) {
-		spin_unlock(&pde->pde_unload_lock);
+	rcu_read_lock();
+	fops = rcu_dereference(pde->proc_fops);
+	if (!fops) {
+		rcu_read_unlock();
 		kfree(pdeo);
 		return -ENOENT;
 	}
-	pde->pde_users++;
-	open = pde->proc_fops->open;
-	release = pde->proc_fops->release;
-	spin_unlock(&pde->pde_unload_lock);
+	atomic_inc(&pde->pde_users);
+	open = fops->open;
+	release = fops->release;
+	rcu_read_lock();
 
 	if (open)
 		rv = open(inode, file);
 
-	spin_lock(&pde->pde_unload_lock);
 	if (rv == 0 && release) {
 		/* To know what to release. */
 		pdeo->inode = inode;
 		pdeo->file = file;
 		/* Strictly for "too late" ->release in proc_reg_release(). */
 		pdeo->release = release;
+		spin_lock(&pde->pde_openers_lock);
 		list_add(&pdeo->lh, &pde->pde_openers);
+		spin_unlock(&pde->pde_openers_lock);
 	} else
 		kfree(pdeo);
-	__pde_users_dec(pde);
-	spin_unlock(&pde->pde_unload_lock);
+	pde_users_dec(pde);
 	return rv;
 }
 
@@ -367,10 +375,14 @@ static struct pde_opener *find_pde_opener(struct proc_dir_entry *pde,
 {
 	struct pde_opener *pdeo;
 
+	spin_lock(&pde->pde_openers_lock);
 	list_for_each_entry(pdeo, &pde->pde_openers, lh) {
-		if (pdeo->inode == inode && pdeo->file == file)
+		if (pdeo->inode == inode && pdeo->file == file) {
+			spin_unlock(&pde->pde_openers_lock);
 			return pdeo;
+		}
 	}
+	spin_unlock(&pde->pde_openers_lock);
 	return NULL;
 }
 
@@ -380,10 +392,12 @@ static int proc_reg_release(struct inode *inode, struct file *file)
 	int rv = 0;
 	int (*release)(struct inode *, struct file *);
 	struct pde_opener *pdeo;
+	const struct file_operations *fops;
 
-	spin_lock(&pde->pde_unload_lock);
 	pdeo = find_pde_opener(pde, inode, file);
-	if (!pde->proc_fops) {
+	rcu_read_lock();
+	fops = rcu_dereference(pde->proc_fops);
+	if (!fops) {
 		/*
 		 * Can't simply exit, __fput() will think that everything is OK,
 		 * and move on to freeing struct file. remove_proc_entry() will
@@ -393,21 +407,23 @@ static int proc_reg_release(struct inode *inode, struct file *file)
 		 * But if opener is removed from list, who will ->release it?
 		 */
 		if (pdeo) {
+			spin_lock(&pde->pde_openers_lock);
 			list_del(&pdeo->lh);
-			spin_unlock(&pde->pde_unload_lock);
+			spin_unlock(&pde->pde_openers_lock);
 			rv = pdeo->release(inode, file);
 			kfree(pdeo);
-		} else
-			spin_unlock(&pde->pde_unload_lock);
+		}
 		return rv;
 	}
-	pde->pde_users++;
-	release = pde->proc_fops->release;
+	atomic_inc(&pde->pde_users);
+	release = fops->release;
+	rcu_read_unlock();
 	if (pdeo) {
+		spin_lock(&pde->pde_openers_lock);
 		list_del(&pdeo->lh);
-		kfree(pdeo);
+		spin_unlock(&pde->pde_openers_lock);
 	}
-	spin_unlock(&pde->pde_unload_lock);
+	kfree(pdeo);
 
 	if (release)
 		rv = release(inode, file);
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 32676b3..82628d9 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -68,16 +68,16 @@ struct proc_dir_entry {
 	 * If you're allocating ->proc_fops dynamically, save a pointer
 	 * somewhere.
 	 */
-	const struct file_operations *proc_fops;
+	const struct file_operations __rcu *proc_fops;
 	struct proc_dir_entry *next, *parent, *subdir;
 	void *data;
 	read_proc_t *read_proc;
 	write_proc_t *write_proc;
 	atomic_t count;		/* use count */
-	int pde_users;	/* number of callers into module in progress */
+	atomic_t pde_users;	/* number of callers into module in progress */
 	struct completion *pde_unload_completion;
+	spinlock_t pde_openers_lock;
 	struct list_head pde_openers;	/* who did ->open, but not ->release */
-	spinlock_t pde_unload_lock; /* proc_fops checks and pde_users bumps */
 	u8 namelen;
 	char name[];
 };
-- 
1.8.1.2

