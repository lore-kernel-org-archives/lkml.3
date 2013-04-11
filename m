Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161569Ab3DKNbM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 09:31:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45570 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932980Ab3DKNbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 09:31:08 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 26/26] proc: Delete create_proc_read_entry() [RFC]
To: linux-kernel@vger.kernel.org
From: David Howells <dhowells@redhat.com>
Cc: viro@ZenIV.linux.org.uk
Date: Thu, 11 Apr 2013 14:31:06 +0100
Message-ID: <20130411133106.32763.5147.stgit@warthog.procyon.org.uk>
In-Reply-To: <20130411132739.32763.82609.stgit@warthog.procyon.org.uk>
References: <20130411132739.32763.82609.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delete create_proc_read_entry() as it no longer has any users.

Also delete read_proc_t, write_proc_t, the read_proc member of the
proc_dir_entry struct and the support functions that use them.  This saves a
pointer for every PDE allocated.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/proc/generic.c       |  168 -----------------------------------------------
 fs/proc/inode.c         |   35 ----------
 fs/proc/internal.h      |    2 -
 include/linux/proc_fs.h |   16 ----
 4 files changed, 1 insertion(+), 220 deletions(-)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index bec5832..1c07cad 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -36,141 +36,6 @@ static int proc_match(unsigned int len, const char *name, struct proc_dir_entry
 	return !memcmp(name, de->name, len);
 }
 
-/* buffer size is one page but our output routines use some slack for overruns */
-#define PROC_BLOCK_SIZE	(PAGE_SIZE - 1024)
-
-ssize_t
-__proc_file_read(struct file *file, char __user *buf, size_t nbytes,
-	       loff_t *ppos)
-{
-	struct inode * inode = file_inode(file);
-	char 	*page;
-	ssize_t	retval=0;
-	int	eof=0;
-	ssize_t	n, count;
-	char	*start;
-	struct proc_dir_entry * dp;
-	unsigned long long pos;
-
-	/*
-	 * Gaah, please just use "seq_file" instead. The legacy /proc
-	 * interfaces cut loff_t down to off_t for reads, and ignore
-	 * the offset entirely for writes..
-	 */
-	pos = *ppos;
-	if (pos > MAX_NON_LFS)
-		return 0;
-	if (nbytes > MAX_NON_LFS - pos)
-		nbytes = MAX_NON_LFS - pos;
-
-	dp = PDE(inode);
-	if (!(page = (char*) __get_free_page(GFP_TEMPORARY)))
-		return -ENOMEM;
-
-	while ((nbytes > 0) && !eof) {
-		count = min_t(size_t, PROC_BLOCK_SIZE, nbytes);
-
-		start = NULL;
-		if (!dp->read_proc)
-			break;
-
-		/* How to be a proc read function
-		 * ------------------------------
-		 * Prototype:
-		 *    int f(char *buffer, char **start, off_t offset,
-		 *          int count, int *peof, void *dat)
-		 *
-		 * Assume that the buffer is "count" bytes in size.
-		 *
-		 * If you know you have supplied all the data you have, set
-		 * *peof.
-		 *
-		 * You have three ways to return data:
-		 *
-		 * 0) Leave *start = NULL.  (This is the default.)  Put the
-		 *    data of the requested offset at that offset within the
-		 *    buffer.  Return the number (n) of bytes there are from
-		 *    the beginning of the buffer up to the last byte of data.
-		 *    If the number of supplied bytes (= n - offset) is greater
-		 *    than zero and you didn't signal eof and the reader is
-		 *    prepared to take more data you will be called again with
-		 *    the requested offset advanced by the number of bytes
-		 *    absorbed.  This interface is useful for files no larger
-		 *    than the buffer.
-		 *
-		 * 1) Set *start = an unsigned long value less than the buffer
-		 *    address but greater than zero.  Put the data of the
-		 *    requested offset at the beginning of the buffer.  Return
-		 *    the number of bytes of data placed there.  If this number
-		 *    is greater than zero and you didn't signal eof and the
-		 *    reader is prepared to take more data you will be called
-		 *    again with the requested offset advanced by *start.  This
-		 *    interface is useful when you have a large file consisting
-		 *    of a series of blocks which you want to count and return
-		 *    as wholes.
-		 *    (Hack by Paul.Russell@rustcorp.com.au)
-		 *
-		 * 2) Set *start = an address within the buffer.  Put the data
-		 *    of the requested offset at *start.  Return the number of
-		 *    bytes of data placed there.  If this number is greater
-		 *    than zero and you didn't signal eof and the reader is
-		 *    prepared to take more data you will be called again with
-		 *    the requested offset advanced by the number of bytes
-		 *    absorbed.
-		 */
-		n = dp->read_proc(page, &start, *ppos, count, &eof, dp->data);
-
-		if (n == 0)   /* end of file */
-			break;
-		if (n < 0) {  /* error */
-			if (retval == 0)
-				retval = n;
-			break;
-		}
-
-		if (start == NULL) {
-			if (n > PAGE_SIZE)	/* Apparent buffer overflow */
-				n = PAGE_SIZE;
-			n -= *ppos;
-			if (n <= 0)
-				break;
-			if (n > count)
-				n = count;
-			start = page + *ppos;
-		} else if (start < page) {
-			if (n > PAGE_SIZE)	/* Apparent buffer overflow */
-				n = PAGE_SIZE;
-			if (n > count) {
-				/*
-				 * Don't reduce n because doing so might
-				 * cut off part of a data block.
-				 */
-				pr_warn("proc_file_read: count exceeded\n");
-			}
-		} else /* start >= page */ {
-			unsigned long startoff = (unsigned long)(start - page);
-			if (n > (PAGE_SIZE - startoff))	/* buffer overflow? */
-				n = PAGE_SIZE - startoff;
-			if (n > count)
-				n = count;
-		}
-		
- 		n -= copy_to_user(buf, start < page ? page : start, n);
-		if (n == 0) {
-			if (retval == 0)
-				retval = -EFAULT;
-			break;
-		}
-
-		*ppos += start < page ? (unsigned long)start : n;
-		nbytes -= n;
-		buf += n;
-		retval += n;
-	}
-	free_page((unsigned long) page);
-	return retval;
-}
-
 static int proc_notify_change(struct dentry *dentry, struct iattr *iattr)
 {
 	struct inode *inode = dentry->d_inode;
@@ -476,8 +341,7 @@ static int proc_register(struct proc_dir_entry * dir, struct proc_dir_entry * dp
 	} else if (S_ISLNK(dp->mode)) {
 		dp->proc_iops = &proc_link_inode_operations;
 	} else if (S_ISREG(dp->mode)) {
-		if (dp->proc_fops == NULL)
-			dp->proc_fops = &proc_file_operations;
+		BUG_ON(dp->proc_fops == NULL);
 		dp->proc_iops = &proc_file_inode_operations;
 	} else {
 		WARN_ON(1);
@@ -604,36 +468,6 @@ struct proc_dir_entry *proc_mkdir(const char *name,
 }
 EXPORT_SYMBOL(proc_mkdir);
 
-struct proc_dir_entry *create_proc_read_entry(
-	const char *name, umode_t mode, struct proc_dir_entry *parent, 
-	read_proc_t *read_proc, void *data)
-{
-	struct proc_dir_entry *ent;
-
-	if ((mode & S_IFMT) == 0)
-		mode |= S_IFREG;
-
-	if (!S_ISREG(mode)) {
-		WARN_ON(1);	/* use proc_mkdir(), damnit */
-		return NULL;
-	}
-
-	if ((mode & S_IALLUGO) == 0)
-		mode |= S_IRUGO;
-
-	ent = __proc_create(&parent, name, mode, 1);
-	if (ent) {
-		ent->read_proc = read_proc;
-		ent->data = data;
-		if (proc_register(parent, ent) < 0) {
-			kfree(ent);
-			ent = NULL;
-		}
-	}
-	return ent;
-}
-EXPORT_SYMBOL(create_proc_read_entry);
-
 struct proc_dir_entry *proc_create_data(const char *name, umode_t mode,
 					struct proc_dir_entry *parent,
 					const struct file_operations *proc_fops,
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 3b14a45..d50224c 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -183,41 +183,6 @@ void proc_entry_rundown(struct proc_dir_entry *de)
 	spin_unlock(&de->pde_unload_lock);
 }
 
-/* ->read_proc() users - legacy crap */
-static ssize_t
-proc_file_read(struct file *file, char __user *buf, size_t nbytes,
-	       loff_t *ppos)
-{
-	struct proc_dir_entry *pde = PDE(file_inode(file));
-	ssize_t rv = -EIO;
-	if (use_pde(pde)) {
-		rv = __proc_file_read(file, buf, nbytes, ppos);
-		unuse_pde(pde);
-	}
-	return rv;
-}
-
-static loff_t
-proc_file_lseek(struct file *file, loff_t offset, int orig)
-{
-	loff_t retval = -EINVAL;
-	switch (orig) {
-	case 1:
-		offset += file->f_pos;
-	/* fallthrough */
-	case 0:
-		if (offset < 0 || offset > MAX_NON_LFS)
-			break;
-		file->f_pos = retval = offset;
-	}
-	return retval;
-}
-
-const struct file_operations proc_file_operations = {
-	.llseek		= proc_file_lseek,
-	.read		= proc_file_read,
-};
-
 static loff_t proc_reg_llseek(struct file *file, loff_t offset, int whence)
 {
 	struct proc_dir_entry *pde = PDE(file_inode(file));
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 46a7e2a..4b13417 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -157,8 +157,6 @@ struct pde_opener {
 	struct completion *c;
 };
 
-ssize_t __proc_file_read(struct file *, char __user *, size_t, loff_t *);
-extern const struct file_operations proc_file_operations;
 void proc_entry_rundown(struct proc_dir_entry *);
 
 extern spinlock_t proc_subdir_lock;
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 8175b49..f5105f4 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -47,11 +47,6 @@ enum {
  * non-directory entries).
  */
 
-typedef	int (read_proc_t)(char *page, char **start, off_t off,
-			  int count, int *eof, void *data);
-typedef	int (write_proc_t)(struct file *file, const char __user *buffer,
-			   unsigned long count, void *data);
-
 struct proc_dir_entry {
 	unsigned int low_ino;
 	umode_t mode;
@@ -63,7 +58,6 @@ struct proc_dir_entry {
 	const struct file_operations *proc_fops;
 	struct proc_dir_entry *next, *parent, *subdir;
 	void *data;
-	read_proc_t *read_proc;
 	atomic_t count;		/* use count */
 	atomic_t in_use;	/* number of callers into module in progress; */
 			/* negative -> it's going away RSN */
@@ -154,11 +148,6 @@ static inline struct proc_dir_entry *proc_create(const char *name, umode_t mode,
 {
 	return proc_create_data(name, mode, parent, proc_fops, NULL);
 }
-
-extern __deprecated
-struct proc_dir_entry *create_proc_read_entry(const char *name,
-	umode_t mode, struct proc_dir_entry *base, 
-	read_proc_t *read_proc, void *data);
  
 extern struct proc_dir_entry *proc_net_mkdir(struct net *net, const char *name,
 	struct proc_dir_entry *parent);
@@ -192,11 +181,6 @@ static inline struct proc_dir_entry *proc_mkdir(const char *name,
 static inline struct proc_dir_entry *proc_mkdir_mode(const char *name,
 	umode_t mode, struct proc_dir_entry *parent) { return NULL; }
 
-static inline __deprecated
-struct proc_dir_entry *create_proc_read_entry(const char *name,
-	umode_t mode, struct proc_dir_entry *base, 
-	read_proc_t *read_proc, void * data) { return NULL; }
-
 struct tty_driver;
 static inline void proc_tty_register_driver(struct tty_driver *driver) {};
 static inline void proc_tty_unregister_driver(struct tty_driver *driver) {};

