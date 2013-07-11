Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932333Ab3GKLIG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 07:08:06 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:46867 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932283Ab3GKLIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 07:08:00 -0400
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: viro@ZenIV.linux.org.uk
Cc: linuxram@us.ibm.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Li Zhong <zhong@linux.vnet.ibm.com>
Subject: [PATCH 2/2] proc: covert procfs to use the general revoke implementation
Date: Thu, 11 Jul 2013 19:07:21 +0800
Message-Id: <1373540841-30807-3-git-send-email-zhong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373540841-30807-1-git-send-email-zhong@linux.vnet.ibm.com>
References: <1373540841-30807-1-git-send-email-zhong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071110-2000-0000-0000-00000CD95309
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch tries to replace the current revoke logic in procfs with the
implementation suggested by Al Viro in
https://lkml.org/lkml/2013/4/5/15

Below is the replacement guideline copied from that mail:

procfs would have struct revokable embedded into proc_dir_entry, with freeing
of those guys RCUd.  It would set ->f_op to ->proc_fops and call
make_revokable(file, &pde->revokable) in proc_reg_open(); no wrappers for other
methods needed anymore.  All file_operations instances fed to
proc_create() et.al. would lose ->owner - it's already not needed for those,
actually.  remove_proc_entry()/remove_proc_subtree() would call revoke_it()
on everything we are removing.

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
---
 fs/compat_ioctl.c  |    8 +-
 fs/eventpoll.c     |   10 ++-
 fs/file_table.c    |   13 ++-
 fs/ioctl.c         |    7 +-
 fs/proc/generic.c  |   12 +--
 fs/proc/inode.c    |  229 +++++-----------------------------------------------
 fs/proc/internal.h |    9 +--
 fs/read_write.c    |   30 +++++--
 fs/select.c        |   11 ++-
 mm/mmap.c          |    8 +-
 mm/nommu.c         |   16 +++-
 11 files changed, 111 insertions(+), 242 deletions(-)

diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 5d19acf..48da3bf 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -110,6 +110,7 @@
 #include <linux/dvb/video.h>
 
 #include <linux/sort.h>
+#include <linux/revoke.h>
 
 #ifdef CONFIG_SPARC
 #include <asm/fbio.h>
@@ -1584,7 +1585,12 @@ asmlinkage long compat_sys_ioctl(unsigned int fd, unsigned int cmd,
 
 	default:
 		if (f.file->f_op && f.file->f_op->compat_ioctl) {
-			error = f.file->f_op->compat_ioctl(f.file, cmd, arg);
+			if (likely(start_using(f.file))) {
+				error = f.file->f_op->compat_ioctl(f.file,
+								cmd, arg);
+				stop_using(f.file);
+			} else
+				error = -ENOTTY;
 			if (error != -ENOIOCTLCMD)
 				goto out_fput;
 		}
diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 9ad17b15..c73e8af 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -42,6 +42,7 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/compat.h>
+#include <linux/revoke.h>
 
 /*
  * LOCKING:
@@ -776,9 +777,16 @@ static int ep_eventpoll_release(struct inode *inode, struct file *file)
 
 static inline unsigned int ep_item_poll(struct epitem *epi, poll_table *pt)
 {
+	unsigned int rv = DEFAULT_POLLMASK;
 	pt->_key = epi->event.events;
 
-	return epi->ffd.file->f_op->poll(epi->ffd.file, pt) & epi->event.events;
+	if (likely(start_using(epi->ffd.file))) {
+		rv = epi->ffd.file->f_op->poll(epi->ffd.file, pt)
+					& epi->event.events;
+		stop_using(epi->ffd.file);
+	}
+
+	return rv;
 }
 
 static int ep_read_events_proc(struct eventpoll *ep, struct list_head *head,
diff --git a/fs/file_table.c b/fs/file_table.c
index 08e719b..b3d55e0 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -26,6 +26,7 @@
 #include <linux/hardirq.h>
 #include <linux/task_work.h>
 #include <linux/ima.h>
+#include <linux/revoke.h>
 
 #include <linux/atomic.h>
 
@@ -244,14 +245,20 @@ static void __fput(struct file *file)
 			file->f_op->fasync(-1, file, 0);
 	}
 	ima_file_free(file);
-	if (file->f_op && file->f_op->release)
-		file->f_op->release(inode, file);
+	if (file->f_op && file->f_op->release) {
+		if (likely(!(file->f_revoke)))
+			file->f_op->release(inode, file);
+		else
+			release_revoke(file->f_revoke);
+	}
 	security_file_free(file);
 	if (unlikely(S_ISCHR(inode->i_mode) && inode->i_cdev != NULL &&
 		     !(file->f_mode & FMODE_PATH))) {
 		cdev_put(inode->i_cdev);
 	}
-	fops_put(file->f_op);
+	if (likely(!(file->f_revoke)))
+		fops_put(file->f_op);
+
 	put_pid(file->f_owner.pid);
 	if ((file->f_mode & (FMODE_READ | FMODE_WRITE)) == FMODE_READ)
 		i_readcount_dec(inode);
diff --git a/fs/ioctl.c b/fs/ioctl.c
index fd507fb..7610377 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -15,6 +15,7 @@
 #include <linux/writeback.h>
 #include <linux/buffer_head.h>
 #include <linux/falloc.h>
+#include <linux/revoke.h>
 
 #include <asm/ioctls.h>
 
@@ -40,7 +41,11 @@ static long vfs_ioctl(struct file *filp, unsigned int cmd,
 	if (!filp->f_op || !filp->f_op->unlocked_ioctl)
 		goto out;
 
-	error = filp->f_op->unlocked_ioctl(filp, cmd, arg);
+	if (likely(start_using(filp))) {
+		error = filp->f_op->unlocked_ioctl(filp, cmd, arg);
+		stop_using(filp);
+	}
+
 	if (error == -ENOIOCTLCMD)
 		error = -ENOTTY;
  out:
diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 94441a4..3119937 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -23,6 +23,7 @@
 #include <linux/bitops.h>
 #include <linux/spinlock.h>
 #include <linux/completion.h>
+#include <linux/revoke.h>
 #include <asm/uaccess.h>
 
 #include "internal.h"
@@ -367,13 +368,14 @@ static struct proc_dir_entry *__proc_create(struct proc_dir_entry **parent,
 	if (!ent)
 		goto out;
 
+	spin_lock_init(&ent->revokable.lock);
+	INIT_HLIST_HEAD(&ent->revokable.list);
+
 	memcpy(ent->name, fn, len + 1);
 	ent->namelen = len;
 	ent->mode = mode;
 	ent->nlink = nlink;
 	atomic_set(&ent->count, 1);
-	spin_lock_init(&ent->pde_unload_lock);
-	INIT_LIST_HEAD(&ent->pde_openers);
 out:
 	return ent;
 }
@@ -488,7 +490,7 @@ static void free_proc_entry(struct proc_dir_entry *de)
 
 	if (S_ISLNK(de->mode))
 		kfree(de->data);
-	kfree(de);
+	kfree_rcu(de, rcu);
 }
 
 void pde_put(struct proc_dir_entry *pde)
@@ -528,7 +530,7 @@ void remove_proc_entry(const char *name, struct proc_dir_entry *parent)
 		return;
 	}
 
-	proc_entry_rundown(de);
+	revoke_it(&de->revokable);
 
 	if (S_ISDIR(de->mode))
 		parent->nlink--;
@@ -577,7 +579,7 @@ int remove_proc_subtree(const char *name, struct proc_dir_entry *parent)
 		}
 		spin_unlock(&proc_subdir_lock);
 
-		proc_entry_rundown(de);
+		revoke_it(&de->revokable);
 		next = de->parent;
 		if (S_ISDIR(de->mode))
 			next->nlink--;
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 073aea6..17c0a66 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -12,7 +12,6 @@
 #include <linux/string.h>
 #include <linux/stat.h>
 #include <linux/completion.h>
-#include <linux/poll.h>
 #include <linux/printk.h>
 #include <linux/file.h>
 #include <linux/limits.h>
@@ -23,6 +22,7 @@
 #include <linux/slab.h>
 #include <linux/mount.h>
 #include <linux/magic.h>
+#include <linux/revoke.h>
 
 #include <asm/uaccess.h>
 
@@ -130,168 +130,20 @@ static const struct super_operations proc_sops = {
 	.show_options	= proc_show_options,
 };
 
-enum {BIAS = -1U<<31};
-
-static inline int use_pde(struct proc_dir_entry *pde)
-{
-	return atomic_inc_unless_negative(&pde->in_use);
-}
-
-static void unuse_pde(struct proc_dir_entry *pde)
-{
-	if (atomic_dec_return(&pde->in_use) == BIAS)
-		complete(pde->pde_unload_completion);
-}
-
-/* pde is locked */
-static void close_pdeo(struct proc_dir_entry *pde, struct pde_opener *pdeo)
-{
-	if (pdeo->closing) {
-		/* somebody else is doing that, just wait */
-		DECLARE_COMPLETION_ONSTACK(c);
-		pdeo->c = &c;
-		spin_unlock(&pde->pde_unload_lock);
-		wait_for_completion(&c);
-		spin_lock(&pde->pde_unload_lock);
-	} else {
-		struct file *file;
-		pdeo->closing = 1;
-		spin_unlock(&pde->pde_unload_lock);
-		file = pdeo->file;
-		pde->proc_fops->release(file_inode(file), file);
-		spin_lock(&pde->pde_unload_lock);
-		list_del_init(&pdeo->lh);
-		if (pdeo->c)
-			complete(pdeo->c);
-		kfree(pdeo);
-	}
-}
-
-void proc_entry_rundown(struct proc_dir_entry *de)
-{
-	DECLARE_COMPLETION_ONSTACK(c);
-	/* Wait until all existing callers into module are done. */
-	de->pde_unload_completion = &c;
-	if (atomic_add_return(BIAS, &de->in_use) != BIAS)
-		wait_for_completion(&c);
-
-	spin_lock(&de->pde_unload_lock);
-	while (!list_empty(&de->pde_openers)) {
-		struct pde_opener *pdeo;
-		pdeo = list_first_entry(&de->pde_openers, struct pde_opener, lh);
-		close_pdeo(de, pdeo);
-	}
-	spin_unlock(&de->pde_unload_lock);
-}
-
-static loff_t proc_reg_llseek(struct file *file, loff_t offset, int whence)
-{
-	struct proc_dir_entry *pde = PDE(file_inode(file));
-	loff_t rv = -EINVAL;
-	if (use_pde(pde)) {
-		loff_t (*llseek)(struct file *, loff_t, int);
-		llseek = pde->proc_fops->llseek;
-		if (!llseek)
-			llseek = default_llseek;
-		rv = llseek(file, offset, whence);
-		unuse_pde(pde);
-	}
-	return rv;
-}
-
-static ssize_t proc_reg_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
-{
-	ssize_t (*read)(struct file *, char __user *, size_t, loff_t *);
-	struct proc_dir_entry *pde = PDE(file_inode(file));
-	ssize_t rv = -EIO;
-	if (use_pde(pde)) {
-		read = pde->proc_fops->read;
-		if (read)
-			rv = read(file, buf, count, ppos);
-		unuse_pde(pde);
-	}
-	return rv;
-}
-
-static ssize_t proc_reg_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
-{
-	ssize_t (*write)(struct file *, const char __user *, size_t, loff_t *);
-	struct proc_dir_entry *pde = PDE(file_inode(file));
-	ssize_t rv = -EIO;
-	if (use_pde(pde)) {
-		write = pde->proc_fops->write;
-		if (write)
-			rv = write(file, buf, count, ppos);
-		unuse_pde(pde);
-	}
-	return rv;
-}
-
-static unsigned int proc_reg_poll(struct file *file, struct poll_table_struct *pts)
-{
-	struct proc_dir_entry *pde = PDE(file_inode(file));
-	unsigned int rv = DEFAULT_POLLMASK;
-	unsigned int (*poll)(struct file *, struct poll_table_struct *);
-	if (use_pde(pde)) {
-		poll = pde->proc_fops->poll;
-		if (poll)
-			rv = poll(file, pts);
-		unuse_pde(pde);
-	}
-	return rv;
-}
-
-static long proc_reg_unlocked_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
-{
-	struct proc_dir_entry *pde = PDE(file_inode(file));
-	long rv = -ENOTTY;
-	long (*ioctl)(struct file *, unsigned int, unsigned long);
-	if (use_pde(pde)) {
-		ioctl = pde->proc_fops->unlocked_ioctl;
-		if (ioctl)
-			rv = ioctl(file, cmd, arg);
-		unuse_pde(pde);
-	}
-	return rv;
-}
-
-#ifdef CONFIG_COMPAT
-static long proc_reg_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
-{
-	struct proc_dir_entry *pde = PDE(file_inode(file));
-	long rv = -ENOTTY;
-	long (*compat_ioctl)(struct file *, unsigned int, unsigned long);
-	if (use_pde(pde)) {
-		compat_ioctl = pde->proc_fops->compat_ioctl;
-		if (compat_ioctl)
-			rv = compat_ioctl(file, cmd, arg);
-		unuse_pde(pde);
-	}
-	return rv;
-}
-#endif
-
-static int proc_reg_mmap(struct file *file, struct vm_area_struct *vma)
-{
-	struct proc_dir_entry *pde = PDE(file_inode(file));
-	int rv = -EIO;
-	int (*mmap)(struct file *, struct vm_area_struct *);
-	if (use_pde(pde)) {
-		mmap = pde->proc_fops->mmap;
-		if (mmap)
-			rv = mmap(file, vma);
-		unuse_pde(pde);
-	}
-	return rv;
-}
-
 static int proc_reg_open(struct inode *inode, struct file *file)
 {
 	struct proc_dir_entry *pde = PDE(inode);
 	int rv = 0;
 	int (*open)(struct inode *, struct file *);
 	int (*release)(struct inode *, struct file *);
-	struct pde_opener *pdeo;
+	const struct file_operations *old_fop = file->f_op;
+
+	open = pde->proc_fops->open;
+	release = pde->proc_fops->release;
+
+	file->f_op = pde->proc_fops;
+	if (open)
+		rv = open(inode, file);
 
 	/*
 	 * What for, you ask? Well, we can have open, rmmod, remove_proc_entry
@@ -303,73 +155,28 @@ static int proc_reg_open(struct inode *inode, struct file *file)
 	 * by hand in remove_proc_entry(). For this, save opener's credentials
 	 * for later.
 	 */
-	pdeo = kzalloc(sizeof(struct pde_opener), GFP_KERNEL);
-	if (!pdeo)
-		return -ENOMEM;
-
-	if (!use_pde(pde)) {
-		kfree(pdeo);
-		return -ENOENT;
-	}
-	open = pde->proc_fops->open;
-	release = pde->proc_fops->release;
 
-	if (open)
-		rv = open(inode, file);
+	if (!rv) {
+		rv = make_revokable(file, &pde->revokable);
 
-	if (rv == 0 && release) {
-		/* To know what to release. */
-		pdeo->file = file;
-		/* Strictly for "too late" ->release in proc_reg_release(). */
-		spin_lock(&pde->pde_unload_lock);
-		list_add(&pdeo->lh, &pde->pde_openers);
-		spin_unlock(&pde->pde_unload_lock);
-	} else
-		kfree(pdeo);
-
-	unuse_pde(pde);
-	return rv;
-}
-
-static int proc_reg_release(struct inode *inode, struct file *file)
-{
-	struct proc_dir_entry *pde = PDE(inode);
-	struct pde_opener *pdeo;
-	spin_lock(&pde->pde_unload_lock);
-	list_for_each_entry(pdeo, &pde->pde_openers, lh) {
-		if (pdeo->file == file) {
-			close_pdeo(pde, pdeo);
-			break;
+		if (rv) {
+			/* temporarily for ->owner issue */
+			file->f_op = old_fop;
+			if (release)
+				release(inode, file);
 		}
 	}
-	spin_unlock(&pde->pde_unload_lock);
-	return 0;
+
+	return rv;
 }
 
 static const struct file_operations proc_reg_file_ops = {
-	.llseek		= proc_reg_llseek,
-	.read		= proc_reg_read,
-	.write		= proc_reg_write,
-	.poll		= proc_reg_poll,
-	.unlocked_ioctl	= proc_reg_unlocked_ioctl,
-#ifdef CONFIG_COMPAT
-	.compat_ioctl	= proc_reg_compat_ioctl,
-#endif
-	.mmap		= proc_reg_mmap,
 	.open		= proc_reg_open,
-	.release	= proc_reg_release,
 };
 
 #ifdef CONFIG_COMPAT
 static const struct file_operations proc_reg_file_ops_no_compat = {
-	.llseek		= proc_reg_llseek,
-	.read		= proc_reg_read,
-	.write		= proc_reg_write,
-	.poll		= proc_reg_poll,
-	.unlocked_ioctl	= proc_reg_unlocked_ioctl,
-	.mmap		= proc_reg_mmap,
 	.open		= proc_reg_open,
-	.release	= proc_reg_release,
 };
 #endif
 
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 651d09a..6c6c0c9 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -14,6 +14,7 @@
 #include <linux/spinlock.h>
 #include <linux/atomic.h>
 #include <linux/binfmts.h>
+#include <linux/revoke.h>
 
 struct ctl_table_header;
 struct mempolicy;
@@ -41,11 +42,8 @@ struct proc_dir_entry {
 	struct proc_dir_entry *next, *parent, *subdir;
 	void *data;
 	atomic_t count;		/* use count */
-	atomic_t in_use;	/* number of callers into module in progress; */
-			/* negative -> it's going away RSN */
-	struct completion *pde_unload_completion;
-	struct list_head pde_openers;	/* who did ->open, but not ->release */
-	spinlock_t pde_unload_lock; /* proc_fops checks and pde_users bumps */
+	struct revokable revokable;
+	struct rcu_head rcu;
 	u8 namelen;
 	char name[];
 };
@@ -208,7 +206,6 @@ extern const struct inode_operations proc_pid_link_inode_operations;
 extern void proc_init_inodecache(void);
 extern struct inode *proc_get_inode(struct super_block *, struct proc_dir_entry *);
 extern int proc_fill_super(struct super_block *);
-extern void proc_entry_rundown(struct proc_dir_entry *);
 
 /*
  * proc_devtree.c
diff --git a/fs/read_write.c b/fs/read_write.c
index 122a384..b9ed1fd 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -17,6 +17,7 @@
 #include <linux/pagemap.h>
 #include <linux/splice.h>
 #include <linux/compat.h>
+#include <linux/revoke.h>
 #include "internal.h"
 
 #include <asm/uaccess.h>
@@ -254,13 +255,20 @@ EXPORT_SYMBOL(default_llseek);
 loff_t vfs_llseek(struct file *file, loff_t offset, int whence)
 {
 	loff_t (*fn)(struct file *, loff_t, int);
+	loff_t rv = -EINVAL;
 
 	fn = no_llseek;
 	if (file->f_mode & FMODE_LSEEK) {
 		if (file->f_op && file->f_op->llseek)
 			fn = file->f_op->llseek;
 	}
-	return fn(file, offset, whence);
+
+	if (likely(start_using(file))) {
+		rv = fn(file, offset, whence);
+		stop_using(file);
+	}
+
+	return rv;
 }
 EXPORT_SYMBOL(vfs_llseek);
 
@@ -393,9 +401,13 @@ ssize_t vfs_read(struct file *file, char __user *buf, size_t count, loff_t *pos)
 	ret = rw_verify_area(READ, file, pos, count);
 	if (ret >= 0) {
 		count = ret;
-		if (file->f_op->read)
-			ret = file->f_op->read(file, buf, count, pos);
-		else
+		if (file->f_op->read) {
+			if (likely(start_using(file))) {
+				ret = file->f_op->read(file, buf, count, pos);
+				stop_using(file);
+			} else
+				ret = -EIO;
+		} else
 			ret = do_sync_read(file, buf, count, pos);
 		if (ret > 0) {
 			fsnotify_access(file);
@@ -471,9 +483,13 @@ ssize_t vfs_write(struct file *file, const char __user *buf, size_t count, loff_
 	if (ret >= 0) {
 		count = ret;
 		file_start_write(file);
-		if (file->f_op->write)
-			ret = file->f_op->write(file, buf, count, pos);
-		else
+		if (file->f_op->write) {
+			if (likely(start_using(file))) {
+				ret = file->f_op->write(file, buf, count, pos);
+				stop_using(file);
+			} else
+				ret = -EIO;
+		} else
 			ret = do_sync_write(file, buf, count, pos);
 		if (ret > 0) {
 			fsnotify_modify(file);
diff --git a/fs/select.c b/fs/select.c
index 6b14dc7..16e1e37 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -28,6 +28,7 @@
 #include <linux/hrtimer.h>
 #include <linux/sched/rt.h>
 #include <linux/freezer.h>
+#include <linux/revoke.h>
 
 #include <asm/uaccess.h>
 
@@ -452,7 +453,10 @@ int do_select(int n, fd_set_bits *fds, struct timespec *end_time)
 					mask = DEFAULT_POLLMASK;
 					if (f_op && f_op->poll) {
 						wait_key_set(wait, in, out, bit);
-						mask = (*f_op->poll)(f.file, wait);
+						if (likely(start_using(f.file))) {
+							mask = (*f_op->poll)(f.file, wait);
+							stop_using(f.file);
+						}
 					}
 					fdput(f);
 					if ((mask & POLLIN_SET) && (in & bit)) {
@@ -733,7 +737,10 @@ static inline unsigned int do_pollfd(struct pollfd *pollfd, poll_table *pwait)
 			mask = DEFAULT_POLLMASK;
 			if (f.file->f_op && f.file->f_op->poll) {
 				pwait->_key = pollfd->events|POLLERR|POLLHUP;
-				mask = f.file->f_op->poll(f.file, pwait);
+				if (likely(start_using(f.file))) {
+					mask = f.file->f_op->poll(f.file, pwait);
+					stop_using(f.file);
+				}
 			}
 			/* Mask out unneeded events. */
 			mask &= pollfd->events | POLLERR | POLLHUP;
diff --git a/mm/mmap.c b/mm/mmap.c
index 8468ffd..5988ebe 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -36,6 +36,7 @@
 #include <linux/sched/sysctl.h>
 #include <linux/notifier.h>
 #include <linux/memory.h>
+#include <linux/revoke.h>
 
 #include <asm/uaccess.h>
 #include <asm/cacheflush.h>
@@ -1554,7 +1555,12 @@ munmap_back:
 			correct_wcount = 1;
 		}
 		vma->vm_file = get_file(file);
-		error = file->f_op->mmap(file, vma);
+		if (likely(start_using(file))) {
+			error = file->f_op->mmap(file, vma);
+			stop_using(file);
+		} else
+			error = -EIO;
+
 		if (error)
 			goto unmap_and_free_vma;
 
diff --git a/mm/nommu.c b/mm/nommu.c
index e44e6e0..0853fe2 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -30,6 +30,7 @@
 #include <linux/syscalls.h>
 #include <linux/audit.h>
 #include <linux/sched/sysctl.h>
+#include <linux/revoke.h>
 
 #include <asm/uaccess.h>
 #include <asm/tlb.h>
@@ -1116,9 +1117,13 @@ static unsigned long determine_vm_flags(struct file *file,
  */
 static int do_mmap_shared_file(struct vm_area_struct *vma)
 {
-	int ret;
+	int ret = -EIO;
+
+	if (likely(start_using(vma->vm_file))) {
+		ret = vma->vm_file->f_op->mmap(vma->vm_file, vma);
+		stop_using(vma->vm_file);
+	}
 
-	ret = vma->vm_file->f_op->mmap(vma->vm_file, vma);
 	if (ret == 0) {
 		vma->vm_region->vm_top = vma->vm_region->vm_end;
 		return 0;
@@ -1143,14 +1148,17 @@ static int do_mmap_private(struct vm_area_struct *vma,
 	struct page *pages;
 	unsigned long total, point, n;
 	void *base;
-	int ret, order;
+	int ret = -EIO, order;
 
 	/* invoke the file's mapping function so that it can keep track of
 	 * shared mappings on devices or memory
 	 * - VM_MAYSHARE will be set if it may attempt to share
 	 */
 	if (capabilities & BDI_CAP_MAP_DIRECT) {
-		ret = vma->vm_file->f_op->mmap(vma->vm_file, vma);
+		if (likely(start_using(vma->vm_file))) {
+			ret = vma->vm_file->f_op->mmap(vma->vm_file, vma);
+			stop_using(vma->vm_file);
+		}
 		if (ret == 0) {
 			/* shouldn't return success if we're not sharing */
 			BUG_ON(!(vma->vm_flags & VM_MAYSHARE));
-- 
1.7.9.5

