Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758551AbaGDMHr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 08:07:47 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:59121 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbaGDMGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 08:06:48 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-83-53b698d5cb3d
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        dmitry.kasatkin@gmail.com, Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH v3 2/3] ima: introduce multi-page collect buffers
Date: Fri, 04 Jul 2014 15:05:27 +0300
Message-id: <ccd18f0b0c7147090793d08ecc64c4f182b64e99.1404475462.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <cover.1404475462.git.d.kasatkin@samsung.com>
References: <cover.1404475462.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1404475462.git.d.kasatkin@samsung.com>
References: <cover.1404475462.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphluLIzCtJLcpLzFFi42I5/e/4Zd2rM7YFG/Te5La49Xcvs8WXpXUW
	9+/9ZLJ4OWMeu8XlXXPYLD70PGKz+LRiErMDu8fOWXfZPR4c2szisXvBZyaPvi2rGD0+b5IL
	YI3isklJzcksSy3St0vgyrj8+BtrwRbdin9v2tkbGL+pdDFyckgImEh0T5zNBGGLSVy4t56t
	i5GLQ0hgKaPEjldnWSCcTiaJvTuWsIBUsQnoSWxo/sEOYosI5EhMOnOBGaSIWaCVUeLAo+/M
	IAlhAUeJuS0PwGwWAVWJI5e6wGxegTiJpbPOsUGsk5M4eWwyK4jNKWAlsWDiW6AaDqBtlhKn
	H8fgEJ7AyL+AkWEVo2hqaXJBcVJ6rqFecWJucWleul5yfu4mRkgIftnBuPiY1SFGAQ5GJR7e
	xhUbgoVYE8uKK3MPMUpwMCuJ8B7o2xYsxJuSWFmVWpQfX1Sak1p8iJGJg1OqgVHSLk54nmxY
	v88bzo83Dp7hUlmbf9Cp/H09Y8YRwY/7tu++aPXwkW+46L5yob7n8pd0CyYtcRUM/y3x40jI
	m/4tq3TjDm5Wm+hS+vrcxJAVr/5M1tVYVVXoHB1b+tuo4ZSRld5mlbJVtmmehp9/nJJ9wLjY
	+UKCCnflhi35VqKe+dkrjwu0OyqxFGckGmoxFxUnAgA/AlsWHwIAAA==
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

This patch introduces usage of multi-page collect buffers. Buffer size
can be specified using 'ahash_bufsize' module parameter. Default buffer
size is 4096 bytes.

Changes in v3:
- kernel parameter replaced with module parameter

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 Documentation/kernel-parameters.txt |  8 +++
 security/integrity/ima/ima_crypto.c | 98 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 104 insertions(+), 2 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 03c8452..7d7c38d 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1327,6 +1327,14 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			different crypto accelerators. This option can be used
 			to achieve best performance for particular HW.
 
+	ima.ahash_bufsize= [IMA] Asynchronous hash buffer size
+			Format: <bufsize>
+			Set hashing buffer size. Default: 4k.
+
+			ahash performance varies for different chunk sizes on
+			different crypto accelerators. This option can be used
+			to achieve best performance for particular HW.
+
 	init=		[KNL]
 			Format: <full_path>
 			Run specified binary instead of /sbin/init as init
diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
index bc38160..2340238 100644
--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -37,6 +37,33 @@ static unsigned long ima_ahash_minsize;
 module_param_named(ahash_minsize, ima_ahash_minsize, ulong, 0644);
 MODULE_PARM_DESC(ahash_minsize, "Minimum file size for ahash use");
 
+/* default is 0 - 1 page. */
+static int ima_maxorder;
+static unsigned int ima_bufsize = PAGE_SIZE;
+
+static int param_set_bufsize(const char *val, const struct kernel_param *kp)
+{
+	unsigned long long size;
+	int order;
+
+	size = memparse(val, NULL);
+	order = get_order(size);
+	if (order >= MAX_ORDER)
+		return -EINVAL;
+	ima_maxorder = order;
+	ima_bufsize = PAGE_SIZE << order;
+	return 0;
+}
+
+static struct kernel_param_ops param_ops_bufsize = {
+	.set = param_set_bufsize,
+	.get = param_get_uint,
+};
+#define param_check_bufsize(name, p) __param_check(name, p, unsigned int)
+
+module_param_named(ahash_bufsize, ima_bufsize, bufsize, 0644);
+MODULE_PARM_DESC(ahash_bufsize, "Maximum ahash buffer size");
+
 static struct crypto_shash *ima_shash_tfm;
 static struct crypto_ahash *ima_ahash_tfm;
 
@@ -106,6 +133,68 @@ static void ima_free_tfm(struct crypto_shash *tfm)
 		crypto_free_shash(tfm);
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
+ * By default, ima_maxorder is 0 and it is equivalent to kmalloc(GFP_KERNEL)
+ *
+ * Return pointer to allocated memory, or NULL on failure.
+ */
+static void *ima_alloc_pages(loff_t max_size, size_t *allocated_size,
+			     int last_warn)
+{
+	void *ptr;
+	int order = ima_maxorder;
+	gfp_t gfp_mask = __GFP_WAIT | __GFP_NOWARN | __GFP_NORETRY;
+
+	if (order)
+		order = min(get_order(max_size), order);
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
 static struct crypto_ahash *ima_alloc_atfm(enum hash_algo algo)
 {
 	struct crypto_ahash *tfm = ima_ahash_tfm;
@@ -169,6 +258,7 @@ static int ima_calc_file_hash_atfm(struct file *file,
 	struct ahash_request *req;
 	struct scatterlist sg[1];
 	struct ahash_completion res;
+	size_t rbuf_size;
 
 	hash->length = crypto_ahash_digestsize(tfm);
 
@@ -190,7 +280,11 @@ static int ima_calc_file_hash_atfm(struct file *file,
 	if (i_size == 0)
 		goto out2;
 
-	rbuf = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	/*
+	 * Try to allocate maximum size of memory.
+	 * Fail if not even single page cannot be allocated.
+	 */
+	rbuf = ima_alloc_pages(i_size, &rbuf_size, 1);
 	if (!rbuf) {
 		rc = -ENOMEM;
 		goto out1;
@@ -219,7 +313,7 @@ static int ima_calc_file_hash_atfm(struct file *file,
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

