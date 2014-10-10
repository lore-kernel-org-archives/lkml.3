Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbaJJOKJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 10:10:09 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:26329 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754474AbaJJOJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 10:09:57 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-3b-5437e8b2856d
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, viro@zeniv.linux.org.uk,
        akpm@linux-foundation.org, linux-security-module@vger.kernel.org,
        linux-ima-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com,
        Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH v3 1/6] integrity: provide integrity_read_file()
Date: Fri, 10 Oct 2014 17:09:28 +0300
Message-id: <5b2c79f5e02f5c4972909189d03fd99a48006e16.1412950047.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <cover.1412950047.git.d.kasatkin@samsung.com>
References: <cover.1412950047.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1412950047.git.d.kasatkin@samsung.com>
References: <cover.1412950047.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDLMWRmVeSWpSXmKPExsVy+t/xy7qbXpiHGJzo5rSYs34Nm8Wtv3uZ
	Lb4srbN4OWMeu8XlXXPYLD70PGKzOP/3OKvFpxWTmB04PHbOusvucWLGbxaPB4c2s3jsXvCZ
	yaNvyypGj8+b5Dw2PXnLFMAexWWTkpqTWZZapG+XwJXxYPJ/xoIN2hWzb/5jbGDsVe5i5OSQ
	EDCReHbpAyuELSZx4d56ti5GLg4hgaWMEusvz2CCcDqZJNomtrCDVLEJ6ElsaP7BDpIQEVjE
	KPF42UWwdmaBdIlPk3qBEhwcwgIOEhcexoOEWQRUJX69nQ9WwisQJ9HR08QOsU1O4uSxyWBx
	TgEriW+vfjGB2EIClhLf37ew4BKfwMi/gJFhFaNoamlyQXFSeq6RXnFibnFpXrpecn7uJkZI
	iH7dwbj0mNUhRgEORiUe3gsy5iFCrIllxZW5hxglOJiVRHi/PQcK8aYkVlalFuXHF5XmpBYf
	YmTi4JRqYDSVeXrS42AAd8fMTD4h3TdvFJ9odKbt37e0R4Hp7FbuGr6oewx3yvaH5KbyMu09
	vKX6Whx38jeW2QXLdhz/aeTv6Mzx6V4cU7+wBE/Ehs2miy+yfdui9/KZivSaw3Fe959KPH7X
	vcS4pN355vtYjqX+H1633dy18f1buXyPvs1bpyX4lky1jlZiKc5INNRiLipOBAAZvdAELwIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides function to read file into the allocated
buffer. In order to use internal version of kernel_read to read
file without security checks, it also moves and renames
ima_kernel_read as integrity_kernel_read.

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

