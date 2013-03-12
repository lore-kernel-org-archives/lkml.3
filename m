Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932612Ab3CLTn6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 15:43:58 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34416 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103Ab3CLTn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 15:43:56 -0400
Date: Tue, 12 Mar 2013 19:43:53 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: pipe_release oops.
Message-ID: <20130312194353.GI21522@ZenIV.linux.org.uk>
References: <20130307223610.GA2494@redhat.com>
 <CA+55aFzdPaFQROzFhz-v1Qn=3aDP=4uGTiOJxR26cR91uJHxyg@mail.gmail.com>
 <20130308145306.GA24085@redhat.com>
 <CA+55aFzwOnRnp2B09fKjt8hd9tOCv44H482z1QpCnYc2mywnpA@mail.gmail.com>
 <20130310221047.GA21522@ZenIV.linux.org.uk>
 <20130311003530.GE21522@ZenIV.linux.org.uk>
 <CA+55aFx+TAg+z9eWVm3EeAHQga3ai6YRFEb7rVQ++iNTn4NhGQ@mail.gmail.com>
 <20130311180543.GF21522@ZenIV.linux.org.uk>
 <20130312130614.GA32237@ZenIV.linux.org.uk>
 <CA+55aFyPUYiFoiLrMCzeHpbAgAignCe_awU7SbvPh+T6eHeqng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyPUYiFoiLrMCzeHpbAgAignCe_awU7SbvPh+T6eHeqng@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 08:31:50AM -0700, Linus Torvalds wrote:

> Probably not missing anything subtle. I think all of this code is very
> old, and related to previous /proc/<pid>/fd/<n> escapades. And the
> semantics for those files were in flux some time long long ago (the
> whole "dup vs new struct file" issue), it's all just duct-tape, I
> think.

Umm...  How about the following, then?  I think it makes the whole thing
simpler and saner...  NOTE: this got only a light beating and we'd
just seen an example of long-standing breakage in that area; I'd really
like to see it tortured by Dave's scripts before it gets merged into
mainline.

unify pipe and fifo file_operations

merge all variants of file_operations for pipes and fifos together,
get rid of modifying ->f_op in fifo_open(), fold remains of fifo.c
into pipe.c, kill dead code.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/fs/Makefile b/fs/Makefile
index 9d53192..b691a96 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -7,7 +7,7 @@
 
 obj-y :=	open.o read_write.o file_table.o super.o \
 		char_dev.o stat.o exec.o pipe.o namei.o fcntl.o \
-		ioctl.o readdir.o select.o fifo.o dcache.o inode.o \
+		ioctl.o readdir.o select.o dcache.o inode.o \
 		attr.o bad_inode.o file.o filesystems.o namespace.o \
 		seq_file.o xattr.o libfs.o fs-writeback.o \
 		pnode.o drop_caches.o splice.o sync.o utimes.o \
diff --git a/fs/fifo.c b/fs/fifo.c
deleted file mode 100644
index cf6f434..0000000
--- a/fs/fifo.c
+++ /dev/null
@@ -1,153 +0,0 @@
-/*
- *  linux/fs/fifo.c
- *
- *  written by Paul H. Hargrove
- *
- *  Fixes:
- *	10-06-1999, AV: fixed OOM handling in fifo_open(), moved
- *			initialization there, switched to external
- *			allocation of pipe_inode_info.
- */
-
-#include <linux/mm.h>
-#include <linux/fs.h>
-#include <linux/sched.h>
-#include <linux/pipe_fs_i.h>
-
-static int wait_for_partner(struct inode* inode, unsigned int *cnt)
-{
-	int cur = *cnt;	
-
-	while (cur == *cnt) {
-		pipe_wait(inode->i_pipe);
-		if (signal_pending(current))
-			break;
-	}
-	return cur == *cnt ? -ERESTARTSYS : 0;
-}
-
-static void wake_up_partner(struct inode* inode)
-{
-	wake_up_interruptible(&inode->i_pipe->wait);
-}
-
-static int fifo_open(struct inode *inode, struct file *filp)
-{
-	struct pipe_inode_info *pipe;
-	int ret;
-
-	mutex_lock(&inode->i_mutex);
-	pipe = inode->i_pipe;
-	if (!pipe) {
-		ret = -ENOMEM;
-		pipe = alloc_pipe_info(inode);
-		if (!pipe)
-			goto err_nocleanup;
-		inode->i_pipe = pipe;
-	}
-	filp->f_version = 0;
-
-	/* We can only do regular read/write on fifos */
-	filp->f_mode &= (FMODE_READ | FMODE_WRITE);
-
-	switch (filp->f_mode) {
-	case FMODE_READ:
-	/*
-	 *  O_RDONLY
-	 *  POSIX.1 says that O_NONBLOCK means return with the FIFO
-	 *  opened, even when there is no process writing the FIFO.
-	 */
-		filp->f_op = &read_pipefifo_fops;
-		pipe->r_counter++;
-		if (pipe->readers++ == 0)
-			wake_up_partner(inode);
-
-		if (!pipe->writers) {
-			if ((filp->f_flags & O_NONBLOCK)) {
-				/* suppress POLLHUP until we have
-				 * seen a writer */
-				filp->f_version = pipe->w_counter;
-			} else {
-				if (wait_for_partner(inode, &pipe->w_counter))
-					goto err_rd;
-			}
-		}
-		break;
-	
-	case FMODE_WRITE:
-	/*
-	 *  O_WRONLY
-	 *  POSIX.1 says that O_NONBLOCK means return -1 with
-	 *  errno=ENXIO when there is no process reading the FIFO.
-	 */
-		ret = -ENXIO;
-		if ((filp->f_flags & O_NONBLOCK) && !pipe->readers)
-			goto err;
-
-		filp->f_op = &write_pipefifo_fops;
-		pipe->w_counter++;
-		if (!pipe->writers++)
-			wake_up_partner(inode);
-
-		if (!pipe->readers) {
-			if (wait_for_partner(inode, &pipe->r_counter))
-				goto err_wr;
-		}
-		break;
-	
-	case FMODE_READ | FMODE_WRITE:
-	/*
-	 *  O_RDWR
-	 *  POSIX.1 leaves this case "undefined" when O_NONBLOCK is set.
-	 *  This implementation will NEVER block on a O_RDWR open, since
-	 *  the process can at least talk to itself.
-	 */
-		filp->f_op = &rdwr_pipefifo_fops;
-
-		pipe->readers++;
-		pipe->writers++;
-		pipe->r_counter++;
-		pipe->w_counter++;
-		if (pipe->readers == 1 || pipe->writers == 1)
-			wake_up_partner(inode);
-		break;
-
-	default:
-		ret = -EINVAL;
-		goto err;
-	}
-
-	/* Ok! */
-	mutex_unlock(&inode->i_mutex);
-	return 0;
-
-err_rd:
-	if (!--pipe->readers)
-		wake_up_interruptible(&pipe->wait);
-	ret = -ERESTARTSYS;
-	goto err;
-
-err_wr:
-	if (!--pipe->writers)
-		wake_up_interruptible(&pipe->wait);
-	ret = -ERESTARTSYS;
-	goto err;
-
-err:
-	if (!pipe->readers && !pipe->writers)
-		free_pipe_info(inode);
-
-err_nocleanup:
-	mutex_unlock(&inode->i_mutex);
-	return ret;
-}
-
-/*
- * Dummy default file-operations: the only thing this does
- * is contain the open that then fills in the correct operations
- * depending on the access mode of the file...
- */
-const struct file_operations def_fifo_fops = {
-	.open		= fifo_open,	/* will set read_ or write_pipefifo_fops */
-	.llseek		= noop_llseek,
-};
diff --git a/fs/inode.c b/fs/inode.c
index f5f7c06..5b76d9b 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1803,7 +1803,7 @@ void init_special_inode(struct inode *inode, umode_t mode, dev_t rdev)
 		inode->i_fop = &def_blk_fops;
 		inode->i_rdev = rdev;
 	} else if (S_ISFIFO(mode))
-		inode->i_fop = &def_fifo_fops;
+		inode->i_fop = &pipefifo_fops;
 	else if (S_ISSOCK(mode))
 		inode->i_fop = &bad_sock_fops;
 	else
diff --git a/fs/internal.h b/fs/internal.h
index 507141f..3af89c3 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -125,3 +125,8 @@ extern int invalidate_inodes(struct super_block *, bool);
  * dcache.c
  */
 extern struct dentry *__d_alloc(struct super_block *, const struct qstr *);
+
+/*
+ * pipe.c
+ */
+extern const struct file_operations pipefifo_fops;
diff --git a/fs/pipe.c b/fs/pipe.c
index 2234f3f..79f9f38 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -25,6 +25,8 @@
 #include <asm/uaccess.h>
 #include <asm/ioctls.h>
 
+#include "internal.h"
+
 /*
  * The max size that a non-root user is allowed to grow the pipe. Can
  * be set by root in /proc/sys/fs/pipe-max-size
@@ -662,19 +664,6 @@ out:
 	return ret;
 }
 
-static ssize_t
-bad_pipe_r(struct file *filp, char __user *buf, size_t count, loff_t *ppos)
-{
-	return -EBADF;
-}
-
-static ssize_t
-bad_pipe_w(struct file *filp, const char __user *buf, size_t count,
-	   loff_t *ppos)
-{
-	return -EBADF;
-}
-
 static long pipe_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	struct inode *inode = file_inode(filp);
@@ -734,14 +723,16 @@ pipe_poll(struct file *filp, poll_table *wait)
 }
 
 static int
-pipe_release(struct inode *inode, int decr, int decw)
+pipe_release(struct inode *inode, struct file *file)
 {
 	struct pipe_inode_info *pipe;
 
 	mutex_lock(&inode->i_mutex);
 	pipe = inode->i_pipe;
-	pipe->readers -= decr;
-	pipe->writers -= decw;
+	if (file->f_mode & FMODE_READ)
+		pipe->readers--;
+	if (file->f_mode & FMODE_WRITE)
+		pipe->writers--;
 
 	if (!pipe->readers && !pipe->writers) {
 		free_pipe_info(inode);
@@ -756,35 +747,7 @@ pipe_release(struct inode *inode, int decr, int decw)
 }
 
 static int
-pipe_read_fasync(int fd, struct file *filp, int on)
-{
-	struct inode *inode = file_inode(filp);
-	int retval;
-
-	mutex_lock(&inode->i_mutex);
-	retval = fasync_helper(fd, filp, on, &inode->i_pipe->fasync_readers);
-	mutex_unlock(&inode->i_mutex);
-
-	return retval;
-}
-
-
-static int
-pipe_write_fasync(int fd, struct file *filp, int on)
-{
-	struct inode *inode = file_inode(filp);
-	int retval;
-
-	mutex_lock(&inode->i_mutex);
-	retval = fasync_helper(fd, filp, on, &inode->i_pipe->fasync_writers);
-	mutex_unlock(&inode->i_mutex);
-
-	return retval;
-}
-
-
-static int
-pipe_rdwr_fasync(int fd, struct file *filp, int on)
+pipe_fasync(int fd, struct file *filp, int on)
 {
 	struct inode *inode = file_inode(filp);
 	struct pipe_inode_info *pipe = inode->i_pipe;
@@ -801,129 +764,6 @@ pipe_rdwr_fasync(int fd, struct file *filp, int on)
 	return retval;
 }
 
-
-static int
-pipe_read_release(struct inode *inode, struct file *filp)
-{
-	return pipe_release(inode, 1, 0);
-}
-
-static int
-pipe_write_release(struct inode *inode, struct file *filp)
-{
-	return pipe_release(inode, 0, 1);
-}
-
-static int
-pipe_rdwr_release(struct inode *inode, struct file *filp)
-{
-	int decr, decw;
-
-	decr = (filp->f_mode & FMODE_READ) != 0;
-	decw = (filp->f_mode & FMODE_WRITE) != 0;
-	return pipe_release(inode, decr, decw);
-}
-
-static int
-pipe_read_open(struct inode *inode, struct file *filp)
-{
-	int ret = -ENOENT;
-
-	mutex_lock(&inode->i_mutex);
-
-	if (inode->i_pipe) {
-		ret = 0;
-		inode->i_pipe->readers++;
-	}
-
-	mutex_unlock(&inode->i_mutex);
-
-	return ret;
-}
-
-static int
-pipe_write_open(struct inode *inode, struct file *filp)
-{
-	int ret = -ENOENT;
-
-	mutex_lock(&inode->i_mutex);
-
-	if (inode->i_pipe) {
-		ret = 0;
-		inode->i_pipe->writers++;
-	}
-
-	mutex_unlock(&inode->i_mutex);
-
-	return ret;
-}
-
-static int
-pipe_rdwr_open(struct inode *inode, struct file *filp)
-{
-	int ret = -ENOENT;
-
-	if (!(filp->f_mode & (FMODE_READ|FMODE_WRITE)))
-		return -EINVAL;
-
-	mutex_lock(&inode->i_mutex);
-
-	if (inode->i_pipe) {
-		ret = 0;
-		if (filp->f_mode & FMODE_READ)
-			inode->i_pipe->readers++;
-		if (filp->f_mode & FMODE_WRITE)
-			inode->i_pipe->writers++;
-	}
-
-	mutex_unlock(&inode->i_mutex);
-
-	return ret;
-}
-
-/*
- * The file_operations structs are not static because they
- * are also used in linux/fs/fifo.c to do operations on FIFOs.
- *
- * Pipes reuse fifos' file_operations structs.
- */
-const struct file_operations read_pipefifo_fops = {
-	.llseek		= no_llseek,
-	.read		= do_sync_read,
-	.aio_read	= pipe_read,
-	.write		= bad_pipe_w,
-	.poll		= pipe_poll,
-	.unlocked_ioctl	= pipe_ioctl,
-	.open		= pipe_read_open,
-	.release	= pipe_read_release,
-	.fasync		= pipe_read_fasync,
-};
-
-const struct file_operations write_pipefifo_fops = {
-	.llseek		= no_llseek,
-	.read		= bad_pipe_r,
-	.write		= do_sync_write,
-	.aio_write	= pipe_write,
-	.poll		= pipe_poll,
-	.unlocked_ioctl	= pipe_ioctl,
-	.open		= pipe_write_open,
-	.release	= pipe_write_release,
-	.fasync		= pipe_write_fasync,
-};
-
-const struct file_operations rdwr_pipefifo_fops = {
-	.llseek		= no_llseek,
-	.read		= do_sync_read,
-	.aio_read	= pipe_read,
-	.write		= do_sync_write,
-	.aio_write	= pipe_write,
-	.poll		= pipe_poll,
-	.unlocked_ioctl	= pipe_ioctl,
-	.open		= pipe_rdwr_open,
-	.release	= pipe_rdwr_release,
-	.fasync		= pipe_rdwr_fasync,
-};
-
 struct pipe_inode_info * alloc_pipe_info(struct inode *inode)
 {
 	struct pipe_inode_info *pipe;
@@ -996,7 +836,7 @@ static struct inode * get_pipe_inode(void)
 	inode->i_pipe = pipe;
 
 	pipe->readers = pipe->writers = 1;
-	inode->i_fop = &rdwr_pipefifo_fops;
+	inode->i_fop = &pipefifo_fops;
 
 	/*
 	 * Mark the inode dirty from the very beginning,
@@ -1039,13 +879,13 @@ int create_pipe_files(struct file **res, int flags)
 	d_instantiate(path.dentry, inode);
 
 	err = -ENFILE;
-	f = alloc_file(&path, FMODE_WRITE, &write_pipefifo_fops);
+	f = alloc_file(&path, FMODE_WRITE, &pipefifo_fops);
 	if (IS_ERR(f))
 		goto err_dentry;
 
 	f->f_flags = O_WRONLY | (flags & (O_NONBLOCK | O_DIRECT));
 
-	res[0] = alloc_file(&path, FMODE_READ, &read_pipefifo_fops);
+	res[0] = alloc_file(&path, FMODE_READ, &pipefifo_fops);
 	if (IS_ERR(res[0]))
 		goto err_file;
 
@@ -1144,6 +984,144 @@ SYSCALL_DEFINE1(pipe, int __user *, fildes)
 	return sys_pipe2(fildes, 0);
 }
 
+static int wait_for_partner(struct inode* inode, unsigned int *cnt)
+{
+	int cur = *cnt;	
+
+	while (cur == *cnt) {
+		pipe_wait(inode->i_pipe);
+		if (signal_pending(current))
+			break;
+	}
+	return cur == *cnt ? -ERESTARTSYS : 0;
+}
+
+static void wake_up_partner(struct inode* inode)
+{
+	wake_up_interruptible(&inode->i_pipe->wait);
+}
+
+static int fifo_open(struct inode *inode, struct file *filp)
+{
+	struct pipe_inode_info *pipe;
+	int ret;
+
+	mutex_lock(&inode->i_mutex);
+	pipe = inode->i_pipe;
+	if (!pipe) {
+		ret = -ENOMEM;
+		pipe = alloc_pipe_info(inode);
+		if (!pipe)
+			goto err_nocleanup;
+		inode->i_pipe = pipe;
+	}
+	filp->f_version = 0;
+
+	/* We can only do regular read/write on fifos */
+	filp->f_mode &= (FMODE_READ | FMODE_WRITE);
+
+	switch (filp->f_mode) {
+	case FMODE_READ:
+	/*
+	 *  O_RDONLY
+	 *  POSIX.1 says that O_NONBLOCK means return with the FIFO
+	 *  opened, even when there is no process writing the FIFO.
+	 */
+		pipe->r_counter++;
+		if (pipe->readers++ == 0)
+			wake_up_partner(inode);
+
+		if (!pipe->writers) {
+			if ((filp->f_flags & O_NONBLOCK)) {
+				/* suppress POLLHUP until we have
+				 * seen a writer */
+				filp->f_version = pipe->w_counter;
+			} else {
+				if (wait_for_partner(inode, &pipe->w_counter))
+					goto err_rd;
+			}
+		}
+		break;
+	
+	case FMODE_WRITE:
+	/*
+	 *  O_WRONLY
+	 *  POSIX.1 says that O_NONBLOCK means return -1 with
+	 *  errno=ENXIO when there is no process reading the FIFO.
+	 */
+		ret = -ENXIO;
+		if ((filp->f_flags & O_NONBLOCK) && !pipe->readers)
+			goto err;
+
+		pipe->w_counter++;
+		if (!pipe->writers++)
+			wake_up_partner(inode);
+
+		if (!pipe->readers) {
+			if (wait_for_partner(inode, &pipe->r_counter))
+				goto err_wr;
+		}
+		break;
+	
+	case FMODE_READ | FMODE_WRITE:
+	/*
+	 *  O_RDWR
+	 *  POSIX.1 leaves this case "undefined" when O_NONBLOCK is set.
+	 *  This implementation will NEVER block on a O_RDWR open, since
+	 *  the process can at least talk to itself.
+	 */
+
+		pipe->readers++;
+		pipe->writers++;
+		pipe->r_counter++;
+		pipe->w_counter++;
+		if (pipe->readers == 1 || pipe->writers == 1)
+			wake_up_partner(inode);
+		break;
+
+	default:
+		ret = -EINVAL;
+		goto err;
+	}
+
+	/* Ok! */
+	mutex_unlock(&inode->i_mutex);
+	return 0;
+
+err_rd:
+	if (!--pipe->readers)
+		wake_up_interruptible(&pipe->wait);
+	ret = -ERESTARTSYS;
+	goto err;
+
+err_wr:
+	if (!--pipe->writers)
+		wake_up_interruptible(&pipe->wait);
+	ret = -ERESTARTSYS;
+	goto err;
+
+err:
+	if (!pipe->readers && !pipe->writers)
+		free_pipe_info(inode);
+
+err_nocleanup:
+	mutex_unlock(&inode->i_mutex);
+	return ret;
+}
+
+const struct file_operations pipefifo_fops = {
+	.open		= fifo_open,
+	.llseek		= no_llseek,
+	.read		= do_sync_read,
+	.aio_read	= pipe_read,
+	.write		= do_sync_write,
+	.aio_write	= pipe_write,
+	.poll		= pipe_poll,
+	.unlocked_ioctl	= pipe_ioctl,
+	.release	= pipe_release,
+	.fasync		= pipe_fasync,
+};
+
 /*
  * Allocate a new array of pipe buffers and copy the info over. Returns the
  * pipe size if successful, or return -ERROR on error.
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 2c28271..bf9f500 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2080,7 +2080,6 @@ extern int sync_filesystem(struct super_block *);
 extern const struct file_operations def_blk_fops;
 extern const struct file_operations def_chr_fops;
 extern const struct file_operations bad_sock_fops;
-extern const struct file_operations def_fifo_fops;
 #ifdef CONFIG_BLOCK
 extern int ioctl_by_bdev(struct block_device *, unsigned, unsigned long);
 extern int blkdev_ioctl(struct block_device *, fmode_t, unsigned, unsigned long);
@@ -2152,10 +2151,6 @@ extern void init_special_inode(struct inode *, umode_t, dev_t);
 extern void make_bad_inode(struct inode *);
 extern int is_bad_inode(struct inode *);
 
-extern const struct file_operations read_pipefifo_fops;
-extern const struct file_operations write_pipefifo_fops;
-extern const struct file_operations rdwr_pipefifo_fops;
-
 #ifdef CONFIG_BLOCK
 /*
  * return READ, READA, or WRITE
