Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933253AbaFSPV6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 11:21:58 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:30404 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757533AbaFSPVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 11:21:30 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-c8-53a2fff78eca
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com,
        Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH v1 2/3] ima: introduce multi-page collect buffers
Date: Thu, 19 Jun 2014 18:20:39 +0300
Message-id: <38a79345ecd25dfafda02fa4265fef265a6902f5.1403191191.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <cover.1403191191.git.d.kasatkin@samsung.com>
References: <cover.1403191191.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1403191191.git.d.kasatkin@samsung.com>
References: <cover.1403191191.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupiluLIzCtJLcpLzFFi42I5/e/4Nd3v/xcFG9xabWBx6+9eZosvS+ss
	7t/7yWTxcsY8dovLu+awWXzoecRm8WnFJGYHdo+ds+6yezw4tJnFY/eCz0wefVtWMXp83iQX
	wBrFZZOSmpNZllqkb5fAlbHp+Ur2gofqFTO/dLA1ME5Q6GLk4JAQMJG4vjC5i5ETyBSTuHBv
	PVsXIxeHkMBSRolv32+ygiSEBDqZJC5dMAKx2QT0JDY0/2AHsUUEuhglLj5TBrGZBdIlPk3q
	BYsLCzhKNG5vZwOxWQRUJaZ3vWAH2cUrECex71MdxC45iZPHJoON5xSwkrg09wYjxCpLif2T
	djLiEp/AyL+AkWEVo2hqaXJBcVJ6rqFecWJucWleul5yfu4mRkj4fdnBuPiY1SFGAQ5GJR7e
	D28XBAuxJpYVV+YeYpTgYFYS4d39dVGwEG9KYmVValF+fFFpTmrxIUYmDk6pBkbzZ5su10/9
	U7drkcMp6dS7q3VuHQutPhp91PZwdG7Xt0KfbobfGo27Y/znZLqti0wsWy34JFrC5YNwUun+
	Jqc880TvR16yEU67/82P9n9dESY19yjfc3+NuJ6jZS/0pb+xHm/zXjxLw05/5VaZWXwaO9jL
	bbX/5uUulvFdMucXw8x+7nvXWJVYijMSDbWYi4oTAS678/MdAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use of multiple-page collect buffers reduces:
1) the number of block IO requests
2) the number of asynchronous hash update requests

Second is important for HW accelerated hashing, because significant
amount of time is spent for preparation of hash update operation,
which includes configuring acceleration HW, DMA engine, etc...
Thus, HW accelerators are more efficient when working on large
chunks of data.

This patch introduces usage of multi-page collect buffers which
can be controlled with 'ima_ahash_bufsize' kernel parameter.
By default, one page of 4096 bytes is used as a collect buffer.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 Documentation/kernel-parameters.txt |  3 ++
 security/integrity/ima/ima_crypto.c | 81 +++++++++++++++++++++++++++++++++++--
 2 files changed, 81 insertions(+), 3 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index f8efb01..608eba0 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1289,6 +1289,9 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	ima_ahash_size=size [IMA]
 			Set the minimal file size when use ahash API.
 
+	ima_ahash_bufsize=size [IMA]
+			Set hashing buffer size for ahash API.
+
 	ima_appraise=	[IMA] appraise integrity measurements
 			Format: { "off" | "enforce" | "fix" }
 			default: "enforce"
diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
index b7a8650..9e9414e 100644
--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -25,7 +25,6 @@
 #include <crypto/hash_info.h>
 #include "ima.h"
 
-
 struct ahash_completion {
 	struct completion completion;
 	int err;
@@ -45,6 +44,20 @@ static int __init ima_ahash_setup(char *str)
 }
 __setup("ima_ahash_size=", ima_ahash_setup);
 
+/* default is 0 - 1 page. */
+static int ima_max_order;
+
+static int __init ima_bufsize_setup(char *str)
+{
+	long max_size, rc = kstrtol(str, 10, &max_size);
+	if (!rc)
+		ima_max_order = get_order(max_size);
+	pr_info("ima_ahash_bufsize: %ld, order = %d\n",
+		max_size, ima_max_order);
+	return !rc;
+}
+__setup("ima_ahash_bufsize=", ima_bufsize_setup);
+
 /**
  * ima_kernel_read - read file content
  *
@@ -169,6 +182,63 @@ static int ahash_wait(int err, struct ahash_completion *res)
 	return err;
 }
 
+/**
+ * ima_alloc_pages() - Allocated contiguous pages.
+ * @max_size:       Maximum amount of memory to allocate.
+ * @allocated_size: Returned size of actual allocation.
+ * @last_warn:      Should the min_size allocation warn or not.
+ *
+ * Tries to do opportunistic allocation for memory first trying to allocate
+ * max_size amount of memory and then splitting that until zero order is
+ * reached. Allocation is tried without generating allocation warnings unless
+ * last_warn is set. Last_warn set affects only last allocation of zero order.
+ *
+ * Return pointer to allocated memory, or NULL on failure.
+ */
+static void *ima_alloc_pages(loff_t max_size, size_t *allocated_size,
+			     int last_warn)
+{
+	void *ptr;
+	gfp_t gfp_mask = __GFP_NOWARN | __GFP_WAIT | __GFP_NORETRY;
+	unsigned int order = min(get_order(max_size), ima_max_order);
+
+	for (; order; order--) {
+		ptr = (void *)__get_free_pages(gfp_mask, order);
+		if (ptr) {
+			*allocated_size = PAGE_SIZE << order;
+			return ptr;
+		}
+	}
+
+	/* order is zero - one page */
+
+	gfp_mask = GFP_KERNEL;
+
+	if (!last_warn)
+		gfp_mask |= __GFP_NOWARN;
+
+	ptr = (void *)__get_free_pages(gfp_mask, 0);
+	if (ptr) {
+		*allocated_size = PAGE_SIZE;
+		return ptr;
+	}
+
+	*allocated_size = 0;
+	return NULL;
+}
+
+/**
+ * ima_free_pages() - Free pages allocated by ima_alloc_pages().
+ * @ptr:  Pointer to allocated pages.
+ * @size: Size of allocated buffer.
+ */
+static void ima_free_pages(void *ptr, size_t size)
+{
+	if (!ptr)
+		return;
+	free_pages((unsigned long)ptr, get_order(size));
+}
+
 static int ima_calc_file_hash_atfm(struct file *file,
 				   struct ima_digest_data *hash,
 				   struct crypto_ahash *tfm)
@@ -179,6 +249,7 @@ static int ima_calc_file_hash_atfm(struct file *file,
 	struct ahash_request *req;
 	struct scatterlist sg[1];
 	struct ahash_completion res;
+	size_t rbuf_size;
 
 	hash->length = crypto_ahash_digestsize(tfm);
 
@@ -200,7 +271,11 @@ static int ima_calc_file_hash_atfm(struct file *file,
 	if (i_size == 0)
 		goto out2;
 
-	rbuf = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	/*
+	 * Try to allocate maximum size of memory, fail if not even single
+	 * page cannot be allocated.
+	 */
+	rbuf = ima_alloc_pages(i_size, &rbuf_size, 1);
 	if (!rbuf) {
 		rc = -ENOMEM;
 		goto out1;
@@ -229,7 +304,7 @@ static int ima_calc_file_hash_atfm(struct file *file,
 	}
 	if (read)
 		file->f_mode &= ~FMODE_READ;
-	kfree(rbuf);
+	ima_free_pages(rbuf, rbuf_size);
 out2:
 	if (!rc) {
 		ahash_request_set_crypt(req, NULL, hash->digest, 0);
-- 
1.9.1

