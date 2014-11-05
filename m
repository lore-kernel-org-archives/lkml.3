Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911AbaKEPEt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 10:04:49 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:43135 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755445AbaKEPCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 10:02:45 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-c0-545a3c12c519
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, viro@zeniv.linux.org.uk,
        akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com,
        Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH v4 1/6] integrity: define a new function integrity_read_file()
Date: Wed, 05 Nov 2014 17:01:12 +0200
Message-id: <35eb73a6857df72b823c39991c0f017bf5f93390.1415197743.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <cover.1415197743.git.d.kasatkin@samsung.com>
References: <cover.1415197743.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1415197743.git.d.kasatkin@samsung.com>
References: <cover.1415197743.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLLMWRmVeSWpSXmKPExsVy+t/xK7pCNlEhBi0/dS3mrF/DZnHr715m
	iy9L6yxezpjHbnF51xw2iw89j9gszv89zmrxacUkZgcOj52z7rJ7nJjxm8XjwaHNLB67F3xm
	8ujbsorR4/MmOY9NT94yBbBHcdmkpOZklqUW6dslcGXcXnKCseC2TsXczT1sDYwzVboYOTkk
	BEwk9v/fxgJhi0lcuLeerYuRi0NIYCmjxOb909ghnE4mic8ft7KCVLEJ6ElsaP4BlhARWMQo
	senrRbB2ZoF0iU+TetlBbGEBP4nW7oNgDSwCqhI3Vt0Eq+EViJP4f76ZFWKdnMTJY5PBbE4B
	K4kJTy6ygdhCApYSCx81MeISn8DIv4CRYRWjaGppckFxUnquoV5xYm5xaV66XnJ+7iZGSJB+
	2cG4+JjVIUYBDkYlHl6PpsgQIdbEsuLK3EOMEhzMSiK81yyjQoR4UxIrq1KL8uOLSnNSiw8x
	MnFwSjUwTp6Uu3/ihcv/7hesOnHuYpTcj9TmRrb9kz584hPUMVv2dqbd7oCEmYazps+/Us69
	xer2m7OH+18lcdZs3P8k7VNm0e/L50/Yr2R5f+tiYGvi6WVKteW31t6Y6F2348AkDkujEjnL
	Rv/mo/FnO+5/YKm0qE/K/RfoWBV4ePktg+e7+fwtt389oaDEUpyRaKjFXFScCADfrmOFMAIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch defines a new function called integrity_read_file()
to read file from the kernel into a buffer. Subsequent patches
will read a file containing the public keys and load them onto
the IMA keyring.

This patch moves and renames ima_kernel_read(), the non-security
checking version of kernel_read(), to integrity_kernel_read().

Changes in v3:
* Patch descriptions improved (Mimi)

Changes in v2:
* configuration option removed
* function declared as '__init'

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/iint.c           | 78 +++++++++++++++++++++++++++++++++++++
 security/integrity/ima/ima_crypto.c | 35 ++---------------
 security/integrity/integrity.h      |  4 ++
 3 files changed, 85 insertions(+), 32 deletions(-)

diff --git a/security/integrity/iint.c b/security/integrity/iint.c
index cc3eb4d..0a76686 100644
--- a/security/integrity/iint.c
+++ b/security/integrity/iint.c
@@ -19,6 +19,8 @@
 #include <linux/module.h>
 #include <linux/spinlock.h>
 #include <linux/rbtree.h>
+#include <linux/file.h>
+#include <linux/uaccess.h>
 #include "integrity.h"
 
 static struct rb_root integrity_iint_tree = RB_ROOT;
@@ -167,3 +169,79 @@ static int __init integrity_iintcache_init(void)
 	return 0;
 }
 security_initcall(integrity_iintcache_init);
+
+
+/*
+ * integrity_kernel_read - read data from the file
+ *
+ * This is a function for reading file content instead of kernel_read().
+ * It does not perform locking checks to ensure it cannot be blocked.
+ * It does not perform security checks because it is irrelevant for IMA.
+ *
+ */
+int integrity_kernel_read(struct file *file, loff_t offset,
+			  char *addr, unsigned long count)
+{
+	mm_segment_t old_fs;
+	char __user *buf = addr;
+	ssize_t ret = -EINVAL;
+
+	if (!(file->f_mode & FMODE_READ))
+		return -EBADF;
+
+	old_fs = get_fs();
+	set_fs(get_ds());
+	if (file->f_op->read)
+		ret = file->f_op->read(file, buf, count, &offset);
+	else if (file->f_op->aio_read)
+		ret = do_sync_read(file, buf, count, &offset);
+	else if (file->f_op->read_iter)
+		ret = new_sync_read(file, buf, count, &offset);
+	set_fs(old_fs);
+	return ret;
+}
+
+/*
+ * integrity_read_file - read entire file content into the buffer
+ *
+ * This is function opens a file, allocates the buffer of required
+ * size, read entire file content to the buffer and closes the file
+ *
+ * It is used only by init code.
+ *
+ */
+int __init integrity_read_file(const char *path, char **data)
+{
+	struct file *file;
+	loff_t size;
+	char *buf;
+	int rc = -EINVAL;
+
+	file = filp_open(path, O_RDONLY, 0);
+	if (IS_ERR(file)) {
+		rc = PTR_ERR(file);
+		pr_err("Unable to open file: %s (%d)", path, rc);
+		return rc;
+	}
+
+	size = i_size_read(file_inode(file));
+	if (size <= 0)
+		goto out;
+
+	buf = kmalloc(size, GFP_KERNEL);
+	if (!buf) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	rc = integrity_kernel_read(file, 0, buf, size);
+	if (rc < 0)
+		kfree(buf);
+	else if (rc != size)
+		rc = -EIO;
+	else
+		*data = buf;
+out:
+	fput(file);
+	return rc;
+}
diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
index d34e7df..5df4d96 100644
--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -67,36 +67,6 @@ MODULE_PARM_DESC(ahash_bufsize, "Maximum ahash buffer size");
 static struct crypto_shash *ima_shash_tfm;
 static struct crypto_ahash *ima_ahash_tfm;
 
-/**
- * ima_kernel_read - read file content
- *
- * This is a function for reading file content instead of kernel_read().
- * It does not perform locking checks to ensure it cannot be blocked.
- * It does not perform security checks because it is irrelevant for IMA.
- *
- */
-static int ima_kernel_read(struct file *file, loff_t offset,
-			   char *addr, unsigned long count)
-{
-	mm_segment_t old_fs;
-	char __user *buf = addr;
-	ssize_t ret = -EINVAL;
-
-	if (!(file->f_mode & FMODE_READ))
-		return -EBADF;
-
-	old_fs = get_fs();
-	set_fs(get_ds());
-	if (file->f_op->read)
-		ret = file->f_op->read(file, buf, count, &offset);
-	else if (file->f_op->aio_read)
-		ret = do_sync_read(file, buf, count, &offset);
-	else if (file->f_op->read_iter)
-		ret = new_sync_read(file, buf, count, &offset);
-	set_fs(old_fs);
-	return ret;
-}
-
 int __init ima_init_crypto(void)
 {
 	long rc;
@@ -324,7 +294,8 @@ static int ima_calc_file_hash_atfm(struct file *file,
 		}
 		/* read buffer */
 		rbuf_len = min_t(loff_t, i_size - offset, rbuf_size[active]);
-		rc = ima_kernel_read(file, offset, rbuf[active], rbuf_len);
+		rc = integrity_kernel_read(file, offset, rbuf[active],
+					   rbuf_len);
 		if (rc != rbuf_len)
 			goto out3;
 
@@ -417,7 +388,7 @@ static int ima_calc_file_hash_tfm(struct file *file,
 	while (offset < i_size) {
 		int rbuf_len;
 
-		rbuf_len = ima_kernel_read(file, offset, rbuf, PAGE_SIZE);
+		rbuf_len = integrity_kernel_read(file, offset, rbuf, PAGE_SIZE);
 		if (rbuf_len < 0) {
 			rc = rbuf_len;
 			break;
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index f51ad65..20d2204 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -119,6 +119,10 @@ struct integrity_iint_cache {
  */
 struct integrity_iint_cache *integrity_iint_find(struct inode *inode);
 
+int integrity_kernel_read(struct file *file, loff_t offset,
+			  char *addr, unsigned long count);
+int __init integrity_read_file(const char *path, char **data);
+
 #define INTEGRITY_KEYRING_EVM		0
 #define INTEGRITY_KEYRING_MODULE	1
 #define INTEGRITY_KEYRING_IMA		2
-- 
1.9.1

