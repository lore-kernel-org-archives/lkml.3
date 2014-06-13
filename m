Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598AbaFMUeR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 16:34:17 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60619 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456AbaFMUeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 16:34:16 -0400
Date: Fri, 13 Jun 2014 21:34:13 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: faster /proc/$PID lookup
Message-ID: <20140613203413.GI18016@ZenIV.linux.org.uk>
References: <20140613200338.GA2149@p183.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140613200338.GA2149@p183.telecom.by>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 11:03:38PM +0300, Alexey Dobriyan wrote:
>  static struct dentry *proc_root_lookup(struct inode * dir, struct dentry * dentry, unsigned int flags)
>  {
> -	if (!proc_lookup(dir, dentry, flags))
> -		return NULL;
> -	
> -	return proc_pid_lookup(dir, dentry, flags);
> +	const char c = dentry->d_name.name[0];
> +	struct dentry *rv;
> +
> +	if ('0' <= c && c <= '9') {
> +		rv = proc_pid_lookup(dir, dentry, flags);
> +		if (rv)
> +			rv = proc_lookup(dir, dentry, flags);
> +	} else {
> +		rv = proc_lookup(dir, dentry, flags);
> +	}
> +	return rv;
>  }

<digs in old stashes>

OK...  First of all, proc_pid_lookup() will return NULL on anything that
isn't a valid number.  So you really want to change that (e.g. make it
return ERR_PTR(-ENOENT) on failure).  But then you don't need that
opencoded isdigit(c) - proc_pid_lookup() will bugger off very quickly on
any names that are not numbers, so your first branch will serve just fine
in both cases.

Another thing missing is that you really want to prevent __proc_create() in
root with name looking like a number.  I ended up making name_to_int()
qstr->unsigned (instead of dentry->unsigned); it probably could've been
switched to something less opencoded at the same time.

Anyway, diff below is old, probably won't apply and might be completely
broken - I don't remember why it didn't go anywhere.  Hell knows, might
turn out to be useful...

commit 893028f538560b4d687c1685d7b1a2b4a396277c
Merge: e8cd816 28d55bd
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Tue Mar 26 20:33:14 2013 -0400

    WIP on for-linus: e8cd816 vt: synchronize_rcu() under spinlock is not nice...

diff --cc fs/proc/base.c
index 69078c7,69078c7..02b07c7
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@@ -2727,12 -2727,12 +2727,12 @@@ out
  
  struct dentry *proc_pid_lookup(struct inode *dir, struct dentry * dentry, unsigned int flags)
  {
--	struct dentry *result = NULL;
++	struct dentry *result = ERR_PTR(-ENOENT);
  	struct task_struct *task;
  	unsigned tgid;
  	struct pid_namespace *ns;
  
--	tgid = name_to_int(dentry);
++	tgid = name_to_int(&dentry->d_name);
  	if (tgid == ~0U)
  		goto out;
  
@@@ -2990,7 -2990,7 +2990,7 @@@ static struct dentry *proc_task_lookup(
  	if (!leader)
  		goto out_no_task;
  
--	tid = name_to_int(dentry);
++	tid = name_to_int(&dentry->d_name);
  	if (tid == ~0U)
  		goto out;
  
diff --cc fs/proc/fd.c
index d7a4a28,d7a4a28..5f4286c
--- a/fs/proc/fd.c
+++ b/fs/proc/fd.c
@@@ -205,7 -205,7 +205,7 @@@ static struct dentry *proc_lookupfd_com
  {
  	struct task_struct *task = get_proc_task(dir);
  	struct dentry *result = ERR_PTR(-ENOENT);
--	unsigned fd = name_to_int(dentry);
++	unsigned fd = name_to_int(&dentry->d_name);
  
  	if (!task)
  		goto out_no_task;
diff --cc fs/proc/generic.c
index 4b3b3ff,4b3b3ff..e13d2da
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@@ -580,7 -580,7 +580,7 @@@ static struct proc_dir_entry *__proc_cr
  {
  	struct proc_dir_entry *ent = NULL;
  	const char *fn = name;
--	unsigned int len;
++	struct qstr q;
  
  	/* make sure name is valid */
  	if (!name || !strlen(name))
@@@ -593,14 -593,14 +593,17 @@@
  	if (strchr(fn, '/'))
  		goto out;
  
--	len = strlen(fn);
++	q.name = fn;
++	q.len = strlen(fn);
++	if (*parent == &proc_root && name_to_int(&q) != ~0U)
++		return NULL;
  
--	ent = kzalloc(sizeof(struct proc_dir_entry) + len + 1, GFP_KERNEL);
++	ent = kzalloc(sizeof(struct proc_dir_entry) + q.len + 1, GFP_KERNEL);
  	if (!ent)
  		goto out;
  
--	memcpy(ent->name, fn, len + 1);
--	ent->namelen = len;
++	memcpy(ent->name, q.name, q.len + 1);
++	ent->namelen = q.len;
  	ent->mode = mode;
  	ent->nlink = nlink;
  	atomic_set(&ent->count, 1);
diff --cc fs/proc/internal.h
index 85ff3a4,85ff3a4..fba6da2
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@@ -123,10 -123,10 +123,10 @@@ static inline int pid_delete_dentry(con
  	return !proc_pid(dentry->d_inode)->tasks[PIDTYPE_PID].first;
  }
  
--static inline unsigned name_to_int(struct dentry *dentry)
++static inline unsigned name_to_int(struct qstr *qstr)
  {
--	const char *name = dentry->d_name.name;
--	int len = dentry->d_name.len;
++	const char *name = qstr->name;
++	int len = qstr->len;
  	unsigned n = 0;
  
  	if (len > 1 && *name == '0')
diff --cc fs/proc/root.c
index c6e9fac,c6e9fac..67c9dc4
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@@ -190,10 -190,10 +190,10 @@@ static int proc_root_getattr(struct vfs
  
  static struct dentry *proc_root_lookup(struct inode * dir, struct dentry * dentry, unsigned int flags)
  {
--	if (!proc_lookup(dir, dentry, flags))
++	if (!proc_pid_lookup(dir, dentry, flags))
  		return NULL;
  	
--	return proc_pid_lookup(dir, dentry, flags);
++	return proc_lookup(dir, dentry, flags);
  }
  
  static int proc_root_readdir(struct file * filp,
