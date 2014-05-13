Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768AbaEMP7l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 11:59:41 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:20724 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823AbaEMP7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 11:59:19 -0400
X-AuditID: cbfec7f5-b7fae6d000004d6d-be-5372415567ac
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: viro@zeniv.linux.org.uk, linux-security-module@vger.kernel.org,
        eparis@redhat.com, zohar@linux.vnet.ibm.com,
        linux-ima-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, hooanon05g@gmail.com, jmorris@namei.org,
        dmitry.kasatkin@gmail.com, Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH 2/2] ima: allocate user-space like memory for direct-io
Date: Tue, 13 May 2014 18:59:40 +0300
Message-id: <d1a4b04341a80cc7acd0ec1a466b60333a8b86ee.1399996667.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <cover.1399996667.git.d.kasatkin@samsung.com>
References: <cover.1399996667.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1399996667.git.d.kasatkin@samsung.com>
References: <cover.1399996667.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDLMWRmVeSWpSXmKPExsVy+t/xy7qhjkXBBt9PWFnc+ruX2eLL0jqL
	idvbWCzO97WyWaxbv5jJ4uWMeewWl3fNYbP40POIzeL83+OsFp9WTGJ24PLYOesuu8eDQ5tZ
	PHYv+Mzk0fM92eP9vqtsHn1bVjF6fN4k57HpyVumAI4oLpuU1JzMstQifbsEroyFffdYCjZL
	V7x58Za5gfG4aBcjJ4eEgInE9hXzmSFsMYkL99azdTFycQgJLGWUmPppGSuE08kksW7lHEaQ
	KjYBPYkNzT/YQRIiArMYJTq39TOBOMwCExglHmxvZAKpEhZwl3g5dyWYzSKgKrF6xwGwHbwC
	cRLbf7YzQeyTkzh5bDIriM0pYCWx8ckTsLiQgKXE3qVfGXGJT2DkX8DIsIpRNLU0uaA4KT3X
	SK84Mbe4NC9dLzk/dxMjJIS/7mBceszqEKMAB6MSD68Hc0GwEGtiWXFl7iFGCQ5mJRHez3pF
	wUK8KYmVValF+fFFpTmpxYcYmTg4pRoYu7gs05PvBracPbt/doVq/Y0bd7d/+JOb6eq/wXM6
	/y3maKMVqxZHV9ZGb+9nd3of37S7bGNGu7oCQ01uwa41bntaPuo7MJbwdh+Kq7/95rQuZ0/e
	5nMpbT//Sn5Zb33l3j2r+u96Jq0LqleVBNzf4ahfws7VnrqjuOaMh1y7am2tSNx9Zw8lluKM
	REMt5qLiRACy1XHxPwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For files opened with O_DIRECT flag, file I/O is done directly to/from
user-space pages. kmalloc or vmalloc allocated memory is not suitable
for direct IO and set_fs(get_ds()) trick does not work there.

This patch uses vm_mmap() call to allocated annonymous user-space like
memory from the kernel.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/ima/ima_crypto.c | 44 ++++++++++++++++++++++++++++++-------
 1 file changed, 36 insertions(+), 8 deletions(-)

diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
index de5b974..59efc0a 100644
--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -21,6 +21,7 @@
 #include <linux/scatterlist.h>
 #include <linux/err.h>
 #include <linux/slab.h>
+#include <linux/mman.h>
 #include <crypto/hash.h>
 #include <crypto/hash_info.h>
 #include "ima.h"
@@ -36,7 +37,7 @@ static struct crypto_shash *ima_shash_tfm;
  *
  */
 static int ima_kernel_read(struct file *file, loff_t offset,
-			   char *addr, unsigned long count)
+			   char *addr, unsigned long count, bool kmem)
 {
 	mm_segment_t old_fs;
 	char __user *buf = addr;
@@ -47,13 +48,16 @@ static int ima_kernel_read(struct file *file, loff_t offset,
 	if (!file->f_op->read && !file->f_op->aio_read)
 		return -EINVAL;
 
-	old_fs = get_fs();
-	set_fs(get_ds());
+	if (kmem) {
+		old_fs = get_fs();
+		set_fs(get_ds());
+	}
 	if (file->f_op->read)
 		ret = file->f_op->read(file, buf, count, &offset);
 	else
 		ret = do_sync_read(file, buf, count, &offset);
-	set_fs(old_fs);
+	if (kmem)
+		set_fs(old_fs);
 	return ret;
 }
 
@@ -102,6 +106,7 @@ static int ima_calc_file_hash_tfm(struct file *file,
 {
 	loff_t i_size, offset = 0;
 	char *rbuf;
+	unsigned long addr = 0;
 	int rc, read = 0;
 	struct {
 		struct shash_desc shash;
@@ -122,9 +127,22 @@ static int ima_calc_file_hash_tfm(struct file *file,
 	if (i_size == 0)
 		goto out;
 
-	rbuf = kzalloc(PAGE_SIZE, GFP_KERNEL);
-	if (!rbuf)
-		return -ENOMEM;
+	if (file->f_flags & O_DIRECT) {
+		/* direct-io code writes to user-space buffers
+		 * set_fs(get_ds()) trick does not work there
+		 */
+		addr = vm_mmap(NULL, 0, PAGE_SIZE,
+				PROT_READ | PROT_WRITE,
+				MAP_PRIVATE | MAP_ANONYMOUS, 0);
+		if (IS_ERR_VALUE(addr))
+			return addr;
+	}
+
+	rbuf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!rbuf) {
+		rc = -ENOMEM;
+		goto nomem;
+	}
 
 	if (!(file->f_mode & FMODE_READ)) {
 		file->f_mode |= FMODE_READ;
@@ -134,7 +152,9 @@ static int ima_calc_file_hash_tfm(struct file *file,
 	while (offset < i_size) {
 		int rbuf_len;
 
-		rbuf_len = ima_kernel_read(file, offset, rbuf, PAGE_SIZE);
+		rbuf_len = ima_kernel_read(file, offset,
+					   addr ? (char *)addr : rbuf,
+					   PAGE_SIZE, !addr);
 		if (rbuf_len < 0) {
 			rc = rbuf_len;
 			break;
@@ -143,6 +163,11 @@ static int ima_calc_file_hash_tfm(struct file *file,
 			break;
 		offset += rbuf_len;
 
+		if (addr && __copy_from_user(rbuf, (void __user *)addr,
+					     rbuf_len)) {
+			rc = -EFAULT;
+			break;
+		}
 		rc = crypto_shash_update(&desc.shash, rbuf, rbuf_len);
 		if (rc)
 			break;
@@ -150,6 +175,9 @@ static int ima_calc_file_hash_tfm(struct file *file,
 	if (read)
 		file->f_mode &= ~FMODE_READ;
 	kfree(rbuf);
+nomem:
+	if (addr)
+		vm_munmap(addr, PAGE_SIZE);
 out:
 	if (!rc)
 		rc = crypto_shash_final(&desc.shash, hash->digest);
-- 
1.9.1

