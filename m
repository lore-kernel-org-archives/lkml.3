Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204Ab3LBIsX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 03:48:23 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:52774 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655Ab3LBIrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 03:47:25 -0500
X-AuditID: 9c930179-b7b6eae000007f2a-58-529c491afab4
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v3 3/5] slab: restrict the number of objects in a slab
Date: Mon,  2 Dec 2013 17:49:41 +0900
Message-Id: <1385974183-31423-4-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385974183-31423-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1385974183-31423-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To prepare to implement byte sized index for managing the freelist
of a slab, we should restrict the number of objects in a slab to be less
or equal to 256, since byte only represent 256 different values.
Setting the size of object to value equal or more than newly introduced
SLAB_OBJ_MIN_SIZE ensures that the number of objects in a slab is less or
equal to 256 for a slab with 1 page.

If page size is rather larger than 4096, above assumption would be wrong.
In this case, we would fall back on 2 bytes sized index.

If minimum size of kmalloc is less than 16, we use it as minimum object
size and give up this optimization.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/include/linux/slab.h b/include/linux/slab.h
index c2bba24..23e1fa1 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -201,6 +201,17 @@ struct kmem_cache {
 #ifndef KMALLOC_SHIFT_LOW
 #define KMALLOC_SHIFT_LOW	5
 #endif
+
+/*
+ * This restriction comes from byte sized index implementation.
+ * Page size is normally 2^12 bytes and, in this case, if we want to use
+ * byte sized index which can represent 2^8 entries, the size of the object
+ * should be equal or greater to 2^12 / 2^8 = 2^4 = 16.
+ * If minimum size of kmalloc is less than 16, we use it as minimum object
+ * size and give up to use byte sized index.
+ */
+#define SLAB_OBJ_MIN_SIZE	(KMALLOC_SHIFT_LOW < 4 ? \
+				(1 << KMALLOC_SHIFT_LOW) : 16)
 #endif
 
 #ifdef CONFIG_SLUB
diff --git a/mm/slab.c b/mm/slab.c
index 77f9eae..7c3c132 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -157,6 +157,17 @@
 #define ARCH_KMALLOC_FLAGS SLAB_HWCACHE_ALIGN
 #endif
 
+#define FREELIST_BYTE_INDEX (((PAGE_SIZE >> BITS_PER_BYTE) \
+				<= SLAB_OBJ_MIN_SIZE) ? 1 : 0)
+
+#if FREELIST_BYTE_INDEX
+typedef unsigned char freelist_idx_t;
+#else
+typedef unsigned short freelist_idx_t;
+#endif
+
+#define SLAB_OBJ_MAX_NUM (1 << sizeof(freelist_idx_t) * BITS_PER_BYTE)
+
 /*
  * true if a page was allocated from pfmemalloc reserves for network-based
  * swap
@@ -2016,6 +2027,10 @@ static size_t calculate_slab_order(struct kmem_cache *cachep,
 		if (!num)
 			continue;
 
+		/* Can't handle number of objects more than SLAB_OBJ_MAX_NUM */
+		if (num > SLAB_OBJ_MAX_NUM)
+			break;
+
 		if (flags & CFLGS_OFF_SLAB) {
 			/*
 			 * Max number of objs-per-slab for caches which
@@ -2258,6 +2273,12 @@ __kmem_cache_create (struct kmem_cache *cachep, unsigned long flags)
 		flags |= CFLGS_OFF_SLAB;
 
 	size = ALIGN(size, cachep->align);
+	/*
+	 * We should restrict the number of objects in a slab to implement
+	 * byte sized index. Refer comment on SLAB_OBJ_MIN_SIZE definition.
+	 */
+	if (FREELIST_BYTE_INDEX && size < SLAB_OBJ_MIN_SIZE)
+		size = ALIGN(SLAB_OBJ_MIN_SIZE, cachep->align);
 
 	left_over = calculate_slab_order(cachep, size, cachep->align, flags);
 
-- 
1.7.9.5

