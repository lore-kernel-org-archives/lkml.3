Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533AbaJRPYF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 11:24:05 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:36758 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054AbaJRPYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 11:24:01 -0400
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, hch@infradead.org,
        Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 2/4] fs: add fadvise file_operation
Date: Sat, 18 Oct 2014 19:21:26 +0400
Message-Id: <1413645688-13524-3-git-send-email-dmonakhov@openvz.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1413645688-13524-1-git-send-email-dmonakhov@openvz.org>
References: <1413645688-13524-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sys_fadvise result in direct f_mode modification, which  may be not
suitable for some unusual filesytems where file mode invariant is more
complex. In order to support such filesystems we have to delegate fadvise
logic to filesystem layer.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 include/linux/fs.h |    4 ++
 mm/fadvise.c       |   81 ++++++++++++++++++++++++++++++++-------------------
 2 files changed, 55 insertions(+), 30 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 4ce1414..0fe06f5 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1518,6 +1518,7 @@ struct file_operations {
 	long (*fallocate)(struct file *file, int mode, loff_t offset,
 			  loff_t len);
 	int (*show_fdinfo)(struct seq_file *m, struct file *f);
+	int (*fadvise)(struct file *file, loff_t off, loff_t len, int advice);
 };
 
 struct inode_operations {
@@ -2081,6 +2082,9 @@ extern int finish_open(struct file *file, struct dentry *dentry,
 			int *opened);
 extern int finish_no_open(struct file *file, struct dentry *dentry);
 
+/* fs/fadvise.c */
+extern int generic_fadvise(struct file *file, loff_t off, loff_t len, int adv);
+
 /* fs/ioctl.c */
 
 extern int ioctl_preallocate(struct file *filp, void __user *argp);
diff --git a/mm/fadvise.c b/mm/fadvise.c
index 3bcfd81..a568ba6 100644
--- a/mm/fadvise.c
+++ b/mm/fadvise.c
@@ -7,6 +7,7 @@
  *		Initial version.
  */
 
+#include <linux/export.h>
 #include <linux/kernel.h>
 #include <linux/file.h>
 #include <linux/fs.h>
@@ -25,10 +26,9 @@
  * POSIX_FADV_WILLNEED could set PG_Referenced, and POSIX_FADV_NOREUSE could
  * deactivate the pages and clear PG_Referenced.
  */
-SYSCALL_DEFINE4(fadvise64_64, int, fd, loff_t, offset, loff_t, len, int, advice)
+int generic_fadvise(struct file *file, loff_t offset, loff_t len, int advice)
 {
-	struct fd f = fdget(fd);
-	struct address_space *mapping;
+	struct address_space *mapping = file->f_mapping;
 	struct backing_dev_info *bdi;
 	loff_t endbyte;			/* inclusive */
 	pgoff_t start_index;
@@ -36,20 +36,6 @@ SYSCALL_DEFINE4(fadvise64_64, int, fd, loff_t, offset, loff_t, len, int, advice)
 	unsigned long nrpages;
 	int ret = 0;
 
-	if (!f.file)
-		return -EBADF;
-
-	if (S_ISFIFO(file_inode(f.file)->i_mode)) {
-		ret = -ESPIPE;
-		goto out;
-	}
-
-	mapping = f.file->f_mapping;
-	if (!mapping || len < 0) {
-		ret = -EINVAL;
-		goto out;
-	}
-
 	if (mapping->a_ops->get_xip_mem) {
 		switch (advice) {
 		case POSIX_FADV_NORMAL:
@@ -77,21 +63,21 @@ SYSCALL_DEFINE4(fadvise64_64, int, fd, loff_t, offset, loff_t, len, int, advice)
 
 	switch (advice) {
 	case POSIX_FADV_NORMAL:
-		f.file->f_ra.ra_pages = bdi->ra_pages;
-		spin_lock(&f.file->f_lock);
-		f.file->f_mode &= ~FMODE_RANDOM;
-		spin_unlock(&f.file->f_lock);
+		file->f_ra.ra_pages = bdi->ra_pages;
+		spin_lock(&file->f_lock);
+		file->f_mode &= ~FMODE_RANDOM;
+		spin_unlock(&file->f_lock);
 		break;
 	case POSIX_FADV_RANDOM:
-		spin_lock(&f.file->f_lock);
-		f.file->f_mode |= FMODE_RANDOM;
-		spin_unlock(&f.file->f_lock);
+		spin_lock(&file->f_lock);
+		file->f_mode |= FMODE_RANDOM;
+		spin_unlock(&file->f_lock);
 		break;
 	case POSIX_FADV_SEQUENTIAL:
-		f.file->f_ra.ra_pages = bdi->ra_pages * 2;
-		spin_lock(&f.file->f_lock);
-		f.file->f_mode &= ~FMODE_RANDOM;
-		spin_unlock(&f.file->f_lock);
+		file->f_ra.ra_pages = bdi->ra_pages * 2;
+		spin_lock(&file->f_lock);
+		file->f_mode &= ~FMODE_RANDOM;
+		spin_unlock(&file->f_lock);
 		break;
 	case POSIX_FADV_WILLNEED:
 		/* First and last PARTIAL page! */
@@ -107,7 +93,7 @@ SYSCALL_DEFINE4(fadvise64_64, int, fd, loff_t, offset, loff_t, len, int, advice)
 		 * Ignore return value because fadvise() shall return
 		 * success even if filesystem can't retrieve a hint,
 		 */
-		force_page_cache_readahead(mapping, f.file, start_index,
+		force_page_cache_readahead(mapping, file, start_index,
 					   nrpages);
 		break;
 	case POSIX_FADV_NOREUSE:
@@ -142,15 +128,50 @@ SYSCALL_DEFINE4(fadvise64_64, int, fd, loff_t, offset, loff_t, len, int, advice)
 		ret = -EINVAL;
 	}
 out:
+	return ret;
+}
+EXPORT_SYMBOL(generic_fadvise);
+
+static int do_fadvise(int fd, loff_t offset, loff_t len, int advice)
+{
+	struct fd f = fdget(fd);
+	int (*fadvise)(struct file *, loff_t, loff_t, int) = generic_fadvise;
+	int ret = 0;
+
+	if (!f.file)
+		return -EBADF;
+
+	if (S_ISFIFO(file_inode(f.file)->i_mode)) {
+		ret = -ESPIPE;
+		goto out;
+	}
+	if (!f.file->f_mapping || len < 0) {
+		ret = -EINVAL;
+		goto out;
+	}
+	if (!f.file->f_mapping || len < 0) {
+		ret = -EINVAL;
+		goto out;
+	}
+	if (f.file->f_op && f.file->f_op->fadvise)
+		fadvise = f.file->f_op->fadvise;
+
+	ret = fadvise(f.file, offset, len, advice);
+out:
 	fdput(f);
 	return ret;
 }
 
+SYSCALL_DEFINE4(fadvise64_64, int, fd, loff_t, offset, loff_t, len, int, advice)
+{
+	return do_fadvise(fd, offset, len, advice);
+}
+
 #ifdef __ARCH_WANT_SYS_FADVISE64
 
 SYSCALL_DEFINE4(fadvise64, int, fd, loff_t, offset, size_t, len, int, advice)
 {
-	return sys_fadvise64_64(fd, offset, len, advice);
+	return do_fadvise(fd, offset, len, advice);
 }
 
 #endif
-- 
1.7.1

