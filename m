Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882AbaB1PJt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 10:09:49 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:23435 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285AbaB1PJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 10:09:14 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-f7-5310a699adb5
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: linux-security-module@vger.kernel.org, zohar@linux.vnet.ibm.com
Cc: jmorris@namei.org, linux-kernel@vger.kernel.org, casey.schaufler@intel.com,
        dmitry.kasatkin@gmail.com, Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [RFC 2/2] ima: provide double buffering for hash calculation
Date: Fri, 28 Feb 2014 17:07:10 +0200
Message-id: <df96963cbf056f4f29222a9f4837597b8224e2ab.1393599653.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-reply-to: <cover.1393599653.git.d.kasatkin@samsung.com>
References: <cover.1393599653.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1393599653.git.d.kasatkin@samsung.com>
References: <cover.1393599653.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprILMWRmVeSWpSXmKPExsVy+t/xy7ozlwkEG0w4JWhxY8UCJotbf/cy
	W3xZWmexbv1iJovLu+awWXzoecRm8WnFJGYHdo+ds+6yeyze85LJ48GhzSwePd+TPfq2rGL0
	+LxJLoAtissmJTUnsyy1SN8ugSvj7fzt7AVbNCuaG/waGHcrdDFyckgImEhM2ryCBcIWk7hw
	bz1bFyMXh5DAUkaJXdv/sEA4nUwSH5ZPZAOpYhPQk9jQ/IMdxBYRcJZYdKudFaSIWWAqo8Sr
	W9PARgkLuErsmtHECmKzCKhKtLy4AhbnFYiT2LHkBCvEOgWJZV/WMoPYnAJWEmvW32YEsYUE
	LCXuNL5gwiU+gZF/ASPDKkbR1NLkguKk9FxDveLE3OLSvHS95PzcTYyQYPyyg3HxMatDjAIc
	jEo8vBKLBIKFWBPLiitzDzFKcDArifBeWgwU4k1JrKxKLcqPLyrNSS0+xMjEwSnVwKjDe7RA
	2NJ4+9OGr7XOJ56sPXdvSneO/XY285S5RRf3ajxJsvx457OX8a7OwIdTP3cYnZIqKWh/Lqyx
	dlfjhfSs+3/WX5kmX72weO/5Xa9y6rYcadnU48HNVDopz+XRj1wx5fUlvzpW3b4faHDucsSp
	uAfm8k2Boqx/CsM/8V86XntecMKszDtKLMUZiYZazEXFiQCz9KJVJAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Asynchronous hash API allows initiate hash calculation and perform
other tasks while hash is calculated.

This patch introduces using of double buffering for simultenous hashing
and reading of the next chunk of data from storage.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/ima/ima_crypto.c | 121 +++++++++++++++++++++++++++++++-----
 1 file changed, 106 insertions(+), 15 deletions(-)

diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
index baf7a4d..9b4df5d 100644
--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -25,6 +25,8 @@
 #include <crypto/hash_info.h>
 #include "ima.h"
 
+/* Default buffer size before trying smaller ones. */
+#define IMA_MAX_ORDER	3
 
 struct ahash_completion {
 	struct completion completion;
@@ -138,16 +140,74 @@ static int ahash_wait(int err, struct ahash_completion *res)
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
+	unsigned int order = min(get_order(max_size), IMA_MAX_ORDER);
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
 {
 	loff_t i_size, offset;
-	char *rbuf;
-	int rc, read = 0, rbuf_len;
+	char *rbuf[2] = { NULL, };
+	int rc, read = 0, rbuf_len, active = 0, ahash_rc;
 	struct ahash_request *req;
 	struct scatterlist sg[1];
 	struct ahash_completion res;
+	size_t rbuf_size[2];
 
 	hash->length = crypto_ahash_digestsize(tfm);
 
@@ -169,36 +229,67 @@ static int ima_calc_file_hash_atfm(struct file *file,
 	if (i_size == 0)
 		goto out2;
 
-	rbuf = kzalloc(PAGE_SIZE, GFP_KERNEL);
-	if (!rbuf) {
+	/*
+	 * Try to allocate maximum size of memory, fail if not even single
+	 * page cannot be allocated.
+	 */
+	rbuf[0] = ima_alloc_pages(i_size, &rbuf_size[0], 1);
+	if (!rbuf[0]) {
 		rc = -ENOMEM;
 		goto out1;
 	}
 
+	/* Only allocate one buffer if that is enough. */
+	if (i_size > rbuf_size[0]) {
+		/*
+		 * Try to allocate secondary buffer if that fails fallback to
+		 * using single buffering. Use previous memory allocation size
+		 * as baseline for possible allocation size.
+		 */
+		rbuf[1] = ima_alloc_pages(i_size - rbuf_size[0],
+					  &rbuf_size[1], 0);
+	}
+
 	if (!(file->f_mode & FMODE_READ)) {
 		file->f_mode |= FMODE_READ;
 		read = 1;
 	}
 
 	for (offset = 0; offset < i_size; offset += rbuf_len) {
-		rbuf_len = kernel_read(file, offset, rbuf, PAGE_SIZE);
-		if (rbuf_len < 0) {
-			rc = rbuf_len;
-			break;
+		if (offset && !rbuf[1]) {
+			/* wait for completion of previous request */
+			rc = ahash_wait(ahash_rc, &res);
+			if (rc)
+				goto out3;
+		}
+		/* read buffer */
+		rbuf_len = min_t(loff_t, i_size - offset, rbuf_size[active]);
+		rc = kernel_read(file, offset, rbuf[active], rbuf_len);
+		if (rc != rbuf_len)
+			goto out3;
+
+		if (offset && rbuf[1]) {
+			/* wait for completion of previous request */
+			rc = ahash_wait(ahash_rc, &res);
+			if (rc)
+				goto out3;
 		}
-		if (rbuf_len == 0)
-			break;
 
-		sg_init_one(&sg[0], rbuf, rbuf_len);
+		sg_init_one(&sg[0], rbuf[active], rbuf_len);
 		ahash_request_set_crypt(req, sg, NULL, rbuf_len);
 
-		rc = ahash_wait(crypto_ahash_update(req), &res);
-		if (rc)
-			break;
+		ahash_rc = crypto_ahash_update(req);
+
+		if (rbuf[1])
+			active = !active; /* swap buffers. */
 	}
+	/* wait for the last request to complete */
+	rc = ahash_wait(ahash_rc, &res);
+out3:
 	if (read)
 		file->f_mode &= ~FMODE_READ;
-	kfree(rbuf);
+	ima_free_pages(rbuf[0], rbuf_size[0]);
+	ima_free_pages(rbuf[1], rbuf_size[1]);
 out2:
 	if (!rc) {
 		ahash_request_set_crypt(req, NULL, hash->digest, 0);
-- 
1.8.3.2

