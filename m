Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854AbaJJOKv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 10:10:51 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:59794 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754608AbaJJOKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 10:10:02 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-7b-5437e8b6be7f
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, viro@zeniv.linux.org.uk,
        akpm@linux-foundation.org, linux-security-module@vger.kernel.org,
        linux-ima-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com,
        Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH v3 6/6] VFS: refactor vfs_read()
Date: Fri, 10 Oct 2014 17:09:33 +0300
Message-id: <a375f4a82ebe59912e81ae0704121c8d503adb55.1412950047.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <cover.1412950047.git.d.kasatkin@samsung.com>
References: <cover.1412950047.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1412950047.git.d.kasatkin@samsung.com>
References: <cover.1412950047.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDLMWRmVeSWpSXmKPExsVy+t/xy7rbXpiHGOz+bW0xZ/0aNotbf/cy
	W3xZWmfxcsY8dovLu+awWXzoecRmcf7vcVaLTysmMTtweOycdZfd48SM3yweDw5tZvHYveAz
	k0ffllWMHp83yXlsevKWKYA9issmJTUnsyy1SN8ugStj8rqD7AX9khWPDqxlbGBcIdLFyMkh
	IWAicfxBNxuELSZx4d56MFtIYCmjxNF9xV2MXEB2J5PEmaU7mUASbAJ6Ehuaf7CDJEQEFjFK
	PF52kRUkwSyQLvFpUi87iC0sYCDROecPC4jNIqAqcfHWQjCbVyBOou9nM9Q2OYmTxyaD9XIK
	WEl8e/WLCWKzpcT39y0suMQnMPIvYGRYxSiaWppcUJyUnmuoV5yYW1yal66XnJ+7iRESol92
	MC4+ZnWIUYCDUYmH94KMeYgQa2JZcWXuIUYJDmYlEd5bN4FCvCmJlVWpRfnxRaU5qcWHGJk4
	OKUaGLcseF25orfivVFq/vWS7pxe1pScSwd1fnj06j/6s6H4c7ho6A7F7C4FXhOBCKu7PBMX
	bJo6fc4LrYfOCz5PzGTrqlSb+kWH95ndp8lvyisnhESqbtmn18t6N72B5Uux+6KZUjd3P4j1
	r7u6jlv2YUfjx59HO5gP+OgcuMsfHvyLVZnzZt5VRiWW4oxEQy3mouJEAPzQMUwvAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

integrity_kernel_read() duplicates the file read operations code
in vfs_read(). This patch refactors vfs_read() code creating a
helper function __vfs_read(). It is used by both vfs_read() and
integrity_kernel_read().

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 fs/read_write.c           | 24 ++++++++++++++++++------
 include/linux/fs.h        |  1 +
 security/integrity/iint.c | 10 +++-------
 3 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 009d854..f45b2ae 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -412,6 +412,23 @@ ssize_t new_sync_read(struct file *filp, char __user *buf, size_t len, loff_t *p
 
 EXPORT_SYMBOL(new_sync_read);
 
+ssize_t __vfs_read(struct file *file, char __user *buf, size_t count,
+		   loff_t *pos)
+{
+	ssize_t ret;
+
+	if (file->f_op->read)
+		ret = file->f_op->read(file, buf, count, pos);
+	else if (file->f_op->aio_read)
+		ret = do_sync_read(file, buf, count, pos);
+	else if (file->f_op->read_iter)
+		ret = new_sync_read(file, buf, count, pos);
+	else
+		ret = -EINVAL;
+
+	return ret;
+}
+
 ssize_t vfs_read(struct file *file, char __user *buf, size_t count, loff_t *pos)
 {
 	ssize_t ret;
@@ -426,12 +443,7 @@ ssize_t vfs_read(struct file *file, char __user *buf, size_t count, loff_t *pos)
 	ret = rw_verify_area(READ, file, pos, count);
 	if (ret >= 0) {
 		count = ret;
-		if (file->f_op->read)
-			ret = file->f_op->read(file, buf, count, pos);
-		else if (file->f_op->aio_read)
-			ret = do_sync_read(file, buf, count, pos);
-		else
-			ret = new_sync_read(file, buf, count, pos);
+		ret = __vfs_read(file, buf, count, pos);
 		if (ret > 0) {
 			fsnotify_access(file);
 			add_rchar(current, ret);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index e11d60c..ac3a36e 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1527,6 +1527,7 @@ ssize_t rw_copy_check_uvector(int type, const struct iovec __user * uvector,
 			      struct iovec *fast_pointer,
 			      struct iovec **ret_pointer);
 
+extern ssize_t __vfs_read(struct file *, char __user *, size_t, loff_t *);
 extern ssize_t vfs_read(struct file *, char __user *, size_t, loff_t *);
 extern ssize_t vfs_write(struct file *, const char __user *, size_t, loff_t *);
 extern ssize_t vfs_readv(struct file *, const struct iovec __user *,
diff --git a/security/integrity/iint.c b/security/integrity/iint.c
index a1f5cd1..e359477 100644
--- a/security/integrity/iint.c
+++ b/security/integrity/iint.c
@@ -184,20 +184,16 @@ int integrity_kernel_read(struct file *file, loff_t offset,
 {
 	mm_segment_t old_fs;
 	char __user *buf = addr;
-	ssize_t ret = -EINVAL;
+	ssize_t ret;
 
 	if (!(file->f_mode & FMODE_READ))
 		return -EBADF;
 
 	old_fs = get_fs();
 	set_fs(get_ds());
-	if (file->f_op->read)
-		ret = file->f_op->read(file, buf, count, &offset);
-	else if (file->f_op->aio_read)
-		ret = do_sync_read(file, buf, count, &offset);
-	else if (file->f_op->read_iter)
-		ret = new_sync_read(file, buf, count, &offset);
+	ret = __vfs_read(file, buf, count, &offset);
 	set_fs(old_fs);
+
 	return ret;
 }
 
-- 
1.9.1

