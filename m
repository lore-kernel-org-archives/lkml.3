Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881AbaKEPDJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 10:03:09 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:62695 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754962AbaKEPCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 10:02:50 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-dd-545a3c18bbed
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, viro@zeniv.linux.org.uk,
        akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com,
        Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH v4 6/6] VFS: refactor vfs_read()
Date: Wed, 05 Nov 2014 17:01:17 +0200
Message-id: <36f142f6946efc7f0dcde70cbc924f4de20ca2e0.1415197743.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <cover.1415197743.git.d.kasatkin@samsung.com>
References: <cover.1415197743.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1415197743.git.d.kasatkin@samsung.com>
References: <cover.1415197743.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLLMWRmVeSWpSXmKPExsVy+t/xK7oSNlEhBh1f5C3mrF/DZnHr715m
	iy9L6yxezpjHbnF51xw2iw89j9gszv89zmrxacUkZgcOj52z7rJ7nJjxm8XjwaHNLB67F3xm
	8ujbsorR4/MmOY9NT94yBbBHcdmkpOZklqUW6dslcGVMXneQvaBfsuLRgbWMDYwrRLoYOTkk
	BEwkXpyZxQhhi0lcuLeerYuRi0NIYCmjxLRj85ghnE4miV9HvzGDVLEJ6ElsaP7BDpIQEVjE
	KLHp60UWkASzQLrEp0m97CC2sICBxOf/y1hBbBYBVYkVm7aCreAViJP483ENM8Q6OYmTxyaD
	1XAKWElMeHKRDcQWErCUWPioiRGX+ARG/gWMDKsYRVNLkwuKk9JzDfWKE3OLS/PS9ZLzczcx
	QoL0yw7GxcesDjEKcDAq8fB6NEWGCLEmlhVX5h5ilOBgVhLhvWYZFSLEm5JYWZValB9fVJqT
	WnyIkYmDU6qB0Y/VULn4/Zemcypt+h9XveCbdPFd2uknwm78thHBi1x2BpjoOMzzu/bj/NHp
	k9JfO8wQr407ue1tfPSf3o0yZ/1bpm3wnC/RHHN6yUxZde05dYaTz369X3S8vVu5skLQq9rm
	QN49//rXIvo1OTNLpe/Mvz3z7hrJc0vnXmwxPX5D5/MOzhyNfCWW4oxEQy3mouJEACXmMTkw	AgAA
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

