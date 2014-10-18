Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751718AbaJRPYh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 11:24:37 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:10183 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673AbaJRPYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 11:24:34 -0400
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, hch@infradead.org,
        Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/4] fs: fcntl add set_flags wrapper -v2
Date: Sat, 18 Oct 2014 19:21:25 +0400
Message-Id: <1413645688-13524-2-git-send-email-dmonakhov@openvz.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1413645688-13524-1-git-send-email-dmonakhov@openvz.org>
References: <1413645688-13524-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fcntl(F_SETFL) performs direct f_flags manipulation which may be not be suitable
for some filesytems (mostly stack-fs like ecryptfs, unionfs, etc)
For example O_DIRECT toggling may require some actions (page cache flush)
Let's introduce new ->set_flags() callback for that purpose. This callback
is responsible for flags check so ->check_flags() no longer needed.

changes from v1:
 - add generic_file_set_flags helper

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/bad_inode.c     |    4 ++--
 fs/fcntl.c         |   14 ++++----------
 fs/nfs/dir.c       |    5 ++---
 fs/nfs/file.c      |   12 ++++++++----
 fs/nfs/internal.h  |    2 +-
 fs/nfs/nfs4file.c  |    2 +-
 include/linux/fs.h |   10 +++++++++-
 7 files changed, 27 insertions(+), 22 deletions(-)

diff --git a/fs/bad_inode.c b/fs/bad_inode.c
index afd2b44..1977f10 100644
--- a/fs/bad_inode.c
+++ b/fs/bad_inode.c
@@ -121,7 +121,7 @@ static unsigned long bad_file_get_unmapped_area(struct file *file,
 	return -EIO;
 }
 
-static int bad_file_check_flags(int flags)
+static int bad_file_set_flags(struct file *file, int flags)
 {
 	return -EIO;
 }
@@ -166,7 +166,7 @@ static const struct file_operations bad_file_ops =
 	.lock		= bad_file_lock,
 	.sendpage	= bad_file_sendpage,
 	.get_unmapped_area = bad_file_get_unmapped_area,
-	.check_flags	= bad_file_check_flags,
+	.set_flags	= bad_file_set_flags,
 	.flock		= bad_file_flock,
 	.splice_write	= bad_file_splice_write,
 	.splice_read	= bad_file_splice_read,
diff --git a/fs/fcntl.c b/fs/fcntl.c
index 22d1c3d..2c1b3d7 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -27,8 +27,6 @@
 #include <asm/siginfo.h>
 #include <asm/uaccess.h>
 
-#define SETFL_MASK (O_APPEND | O_NONBLOCK | O_NDELAY | O_DIRECT | O_NOATIME)
-
 static int setfl(int fd, struct file * filp, unsigned long arg)
 {
 	struct inode * inode = file_inode(filp);
@@ -57,11 +55,6 @@ static int setfl(int fd, struct file * filp, unsigned long arg)
 				return -EINVAL;
 	}
 
-	if (filp->f_op->check_flags)
-		error = filp->f_op->check_flags(arg);
-	if (error)
-		return error;
-
 	/*
 	 * ->fasync() is responsible for setting the FASYNC bit.
 	 */
@@ -72,10 +65,11 @@ static int setfl(int fd, struct file * filp, unsigned long arg)
 		if (error > 0)
 			error = 0;
 	}
-	spin_lock(&filp->f_lock);
-	filp->f_flags = (arg & SETFL_MASK) | (filp->f_flags & ~SETFL_MASK);
-	spin_unlock(&filp->f_lock);
 
+	if (filp->f_op && filp->f_op->set_flags)
+		error = filp->f_op->set_flags(filp, arg);
+	else
+		generic_file_set_flags(filp, arg);
  out:
 	return error;
 }
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 06e8cfc..8b5d9dc 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1480,9 +1480,8 @@ int nfs_atomic_open(struct inode *dir, struct dentry *dentry,
 	dfprintk(VFS, "NFS: atomic_open(%s/%lu), %pd\n",
 			dir->i_sb->s_id, dir->i_ino, dentry);
 
-	err = nfs_check_flags(open_flags);
-	if (err)
-		return err;
+	if ((open_flags & (O_APPEND | O_DIRECT)) == (O_APPEND | O_DIRECT))
+		return -EINVAL;
 
 	/* NFS only supports OPEN on regular files */
 	if ((open_flags & O_DIRECTORY)) {
diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index 524dd80..b68d272 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -48,14 +48,18 @@ static const struct vm_operations_struct nfs_file_vm_ops;
 # define IS_SWAPFILE(inode)	(0)
 #endif
 
-int nfs_check_flags(int flags)
+#define NFS_FL_MASK (O_NONBLOCK | O_NDELAY | O_NOATIME)
+int nfs_set_flags(struct file *filp, int flags)
 {
 	if ((flags & (O_APPEND | O_DIRECT)) == (O_APPEND | O_DIRECT))
 		return -EINVAL;
 
+	spin_lock(&filp->f_lock);
+	filp->f_flags = (flags & NFS_FL_MASK) | (filp->f_flags & ~NFS_FL_MASK);
+	spin_unlock(&filp->f_lock);
 	return 0;
 }
-EXPORT_SYMBOL_GPL(nfs_check_flags);
+EXPORT_SYMBOL_GPL(nfs_set_flags);
 
 /*
  * Open file
@@ -68,7 +72,7 @@ nfs_file_open(struct inode *inode, struct file *filp)
 	dprintk("NFS: open file(%pD2)\n", filp);
 
 	nfs_inc_stats(inode, NFSIOS_VFSOPEN);
-	res = nfs_check_flags(filp->f_flags);
+	res = nfs_set_flags(filp, filp->f_flags);
 	if (res)
 		return res;
 
@@ -917,7 +921,7 @@ const struct file_operations nfs_file_operations = {
 	.flock		= nfs_flock,
 	.splice_read	= nfs_file_splice_read,
 	.splice_write	= iter_file_splice_write,
-	.check_flags	= nfs_check_flags,
+	.set_flags	= nfs_set_flags,
 	.setlease	= nfs_setlease,
 };
 EXPORT_SYMBOL_GPL(nfs_file_operations);
diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
index 9056622..00cf588 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -345,7 +345,7 @@ ssize_t nfs_file_write(struct kiocb *, struct iov_iter *);
 int nfs_file_release(struct inode *, struct file *);
 int nfs_lock(struct file *, int, struct file_lock *);
 int nfs_flock(struct file *, int, struct file_lock *);
-int nfs_check_flags(int);
+int nfs_set_flags(struct file *file, int flags);
 int nfs_setlease(struct file *, long, struct file_lock **);
 
 /* inode.c */
diff --git a/fs/nfs/nfs4file.c b/fs/nfs/nfs4file.c
index a816f06..cc192f4 100644
--- a/fs/nfs/nfs4file.c
+++ b/fs/nfs/nfs4file.c
@@ -130,6 +130,6 @@ const struct file_operations nfs4_file_operations = {
 	.flock		= nfs_flock,
 	.splice_read	= nfs_file_splice_read,
 	.splice_write	= iter_file_splice_write,
-	.check_flags	= nfs_check_flags,
+	.set_flags	= nfs_set_flags,
 	.setlease	= nfs_setlease,
 };
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 9214836..4ce1414 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -944,6 +944,14 @@ struct file_lock {
 #endif
 
 #include <linux/fcntl.h>
+#define SETFL_MASK (O_APPEND | O_NONBLOCK | O_NDELAY | O_DIRECT | O_NOATIME)
+
+static inline void generic_file_set_flags(struct file *filp, unsigned arg)
+{
+	spin_lock(&filp->f_lock);
+	filp->f_flags = (arg & SETFL_MASK) | (filp->f_flags & ~SETFL_MASK);
+	spin_unlock(&filp->f_lock);
+}
 
 extern void send_sigio(struct fown_struct *fown, int fd, int band);
 
@@ -1502,7 +1510,7 @@ struct file_operations {
 	int (*lock) (struct file *, int, struct file_lock *);
 	ssize_t (*sendpage) (struct file *, struct page *, int, size_t, loff_t *, int);
 	unsigned long (*get_unmapped_area)(struct file *, unsigned long, unsigned long, unsigned long, unsigned long);
-	int (*check_flags)(int);
+	int (*set_flags)(struct file *, unsigned);
 	int (*flock) (struct file *, int, struct file_lock *);
 	ssize_t (*splice_write)(struct pipe_inode_info *, struct file *, loff_t *, size_t, unsigned int);
 	ssize_t (*splice_read)(struct file *, loff_t *, struct pipe_inode_info *, size_t, unsigned int);
-- 
1.7.1

