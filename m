Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644AbaDVKPy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 06:15:54 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:28416 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755403AbaDVKPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 06:15:04 -0400
X-IronPort-AV: E=Sophos;i="4.97,900,1389715200"; 
   d="scan'208";a="29566566"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Jiri Kosina <jkosina@suse.cz>, Jeff Layton <jlayton@redhat.com>,
        Andreas Gruenbacher <agruen@linbit.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jean Delvare <jdelvare@suse.de>,
        Monam Agarwal <monamagarwal123@gmail.com>
Subject: [PATCH 3/4] ida: in-place ida allocation
Date: Tue, 22 Apr 2014 18:16:20 +0800
Message-ID: <1398161781-12105-4-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1398161781-12105-1-git-send-email-laijs@cn.fujitsu.com>
References: <1398161781-12105-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two stages of ida allocation/free, idr_layers and ida_bitmap.
They add unneeded foot print and memory waste.

When a single ID is first allocated from an ida, this ida requires
two big chunks of memory. One idr_layer and one ida_bitmap.

To reduce the foot print and memory, we reduce the ida_bitmap
to a single "unsigned long" and place it in its own idr-slot
and avoid to allocate the ida_bitmap.

It also means ida bitmap is located on its coresponding idr-slot
which size is the same as "unsigned long".
Each ida bitmap(idr-slot) contains BITS_PER_LONG ida-slots.

The struct ida_bitmap is not needed any more, we use "unsigned long"
directly and remove all the code of alloc/free struct ida_bitmap.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 include/linux/idr.h |   15 +--------
 lib/idr.c           |   85 +++++++++++++-------------------------------------
 2 files changed, 23 insertions(+), 77 deletions(-)

diff --git a/include/linux/idr.h b/include/linux/idr.h
index 6af3400..3a77b33 100644
--- a/include/linux/idr.h
+++ b/include/linux/idr.h
@@ -135,25 +135,12 @@ static inline void *idr_find(struct idr *idr, int id)
 /*
  * IDA - IDR based id allocator, use when translation from id to
  * pointer isn't necessary.
- *
- * IDA_BITMAP_LONGS is calculated to be one less to accommodate
- * ida_bitmap->nr_busy so that the whole struct fits in 128 bytes.
  */
-#define IDA_CHUNK_SIZE		128	/* 128 bytes per chunk */
-#define IDA_BITMAP_LONGS	(IDA_CHUNK_SIZE / sizeof(long) - 1)
-#define IDA_BITMAP_BITS 	(IDA_BITMAP_LONGS * sizeof(long) * 8)
-
-struct ida_bitmap {
-	long			nr_busy;
-	unsigned long		bitmap[IDA_BITMAP_LONGS];
-};
-
 struct ida {
 	struct idr		idr;
-	struct ida_bitmap	*free_bitmap;
 };
 
-#define IDA_INIT(name)		{ .idr = IDR_INIT((name).idr), .free_bitmap = NULL, }
+#define IDA_INIT(name)		{ .idr = IDR_INIT((name).idr), }
 #define DEFINE_IDA(name)	struct ida name = IDA_INIT(name)
 
 int ida_pre_get(struct ida *ida, gfp_t gfp_mask);
diff --git a/lib/idr.c b/lib/idr.c
index 871991b..69f8d78 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -859,27 +859,15 @@ EXPORT_SYMBOL(idr_is_empty);
  *
  * This is id allocator without id -> pointer translation.  Memory
  * usage is much lower than full blown idr because each id only
- * occupies a bit.  ida uses a custom leaf node which contains
- * IDA_BITMAP_BITS slots.
+ * occupies a bit.  ida uses the leaf idr-slot which contains
+ * IDA_BITMAP_BITS(BITS_PER_LONG) ida-slots.
  *
  * 2007-04-25  written by Tejun Heo <htejun@gmail.com>
  */
 
-static void free_bitmap(struct ida *ida, struct ida_bitmap *bitmap)
-{
-	unsigned long flags;
-
-	if (!ida->free_bitmap) {
-		spin_lock_irqsave(&ida->idr.lock, flags);
-		if (!ida->free_bitmap) {
-			ida->free_bitmap = bitmap;
-			bitmap = NULL;
-		}
-		spin_unlock_irqrestore(&ida->idr.lock, flags);
-	}
-
-	kfree(bitmap);
-}
+#define IDA_BITMAP_BITS 	BITS_PER_LONG
+#define IDA_BITMAP_EMPTY	0UL
+#define IDA_BITMAP_FULL		(~0UL)
 
 /**
  * ida_pre_get - reserve resources for ida allocation
@@ -896,21 +884,7 @@ static void free_bitmap(struct ida *ida, struct ida_bitmap *bitmap)
 int ida_pre_get(struct ida *ida, gfp_t gfp_mask)
 {
 	/* allocate idr_layers */
-	if (!__idr_pre_get(&ida->idr, gfp_mask))
-		return 0;
-
-	/* allocate free_bitmap */
-	if (!ida->free_bitmap) {
-		struct ida_bitmap *bitmap;
-
-		bitmap = kmalloc(sizeof(struct ida_bitmap), gfp_mask);
-		if (!bitmap)
-			return 0;
-
-		free_bitmap(ida, bitmap);
-	}
-
-	return 1;
+	return __idr_pre_get(&ida->idr, gfp_mask);
 }
 EXPORT_SYMBOL(ida_pre_get);
 
@@ -932,8 +906,7 @@ EXPORT_SYMBOL(ida_pre_get);
 int ida_get_new_above(struct ida *ida, int starting_id, int *p_id)
 {
 	struct idr_layer *pa[MAX_IDR_LEVEL + 1];
-	struct ida_bitmap *bitmap;
-	unsigned long flags;
+	unsigned long *bitmap;
 	int idr_id = starting_id / IDA_BITMAP_BITS;
 	int offset = starting_id % IDA_BITMAP_BITS;
 	int t, id;
@@ -951,25 +924,11 @@ int ida_get_new_above(struct ida *ida, int starting_id, int *p_id)
 		offset = 0;
 	idr_id = t;
 
-	/* if bitmap isn't there, create a new one */
-	bitmap = (void *)pa[0]->ary[idr_id & IDR_MASK];
-	if (!bitmap) {
-		spin_lock_irqsave(&ida->idr.lock, flags);
-		bitmap = ida->free_bitmap;
-		ida->free_bitmap = NULL;
-		spin_unlock_irqrestore(&ida->idr.lock, flags);
-
-		if (!bitmap)
-			return -EAGAIN;
-
-		memset(bitmap, 0, sizeof(struct ida_bitmap));
-		rcu_assign_pointer(pa[0]->ary[idr_id & IDR_MASK],
-				(void *)bitmap);
-		pa[0]->count++;
-	}
+	/* the lelf idr-slot is the bitmap for ida slots */
+	bitmap = (void *)&pa[0]->ary[idr_id & IDR_MASK];
 
 	/* lookup for empty slot */
-	t = find_next_zero_bit(bitmap->bitmap, IDA_BITMAP_BITS, offset);
+	t = find_next_zero_bit(bitmap, IDA_BITMAP_BITS, offset);
 	if (t == IDA_BITMAP_BITS) {
 		/* no empty slot after offset, continue to the next chunk */
 		idr_id++;
@@ -981,18 +940,21 @@ int ida_get_new_above(struct ida *ida, int starting_id, int *p_id)
 	if (id >= MAX_IDR_BIT)
 		return -ENOSPC;
 
-	__set_bit(t, bitmap->bitmap);
-	if (++bitmap->nr_busy == IDA_BITMAP_BITS)
+	if (*bitmap == IDA_BITMAP_EMPTY)
+		pa[0]->count++;
+
+	__set_bit(t, bitmap);
+	if (*bitmap == IDA_BITMAP_FULL)
 		idr_mark_full(pa, idr_id);
 
 	*p_id = id;
 
-	/* Each leaf node can handle nearly a thousand slots and the
+	/* Each leaf idr_layer can handle nearly a thousand slots and the
 	 * whole idea of ida is to have small memory foot print.
 	 * Throw away extra resources one by one after each successful
 	 * allocation.
 	 */
-	if (ida->idr.id_free_cnt || ida->free_bitmap) {
+	if (ida->idr.id_free_cnt) {
 		struct idr_layer *p = get_from_free_list(&ida->idr);
 		if (p)
 			kmem_cache_free(idr_layer_cache, p);
@@ -1014,7 +976,7 @@ void ida_remove(struct ida *ida, int id)
 	int idr_id = id / IDA_BITMAP_BITS;
 	int offset = id % IDA_BITMAP_BITS;
 	int n;
-	struct ida_bitmap *bitmap;
+	unsigned long *bitmap;
 
 	if (id < 0 || idr_id > idr_max(ida->idr.layers))
 		goto err;
@@ -1033,16 +995,15 @@ void ida_remove(struct ida *ida, int id)
 	n = idr_id & IDR_MASK;
 	__clear_bit(n, p->bitmap);
 
-	bitmap = (void *)p->ary[n];
-	if (!bitmap || !test_bit(offset, bitmap->bitmap))
+	bitmap = (void *)&p->ary[n];
+	if (!test_bit(offset, bitmap))
 		goto err;
 
 	/* update bitmap and remove it if empty */
-	__clear_bit(offset, bitmap->bitmap);
-	if (--bitmap->nr_busy == 0) {
+	__clear_bit(offset, bitmap);
+	if (*bitmap == IDA_BITMAP_EMPTY) {
 		__set_bit(n, p->bitmap);	/* to please idr_remove() */
 		idr_remove(&ida->idr, idr_id);
-		free_bitmap(ida, bitmap);
 	}
 
 	return;
@@ -1059,7 +1020,6 @@ EXPORT_SYMBOL(ida_remove);
 void ida_destroy(struct ida *ida)
 {
 	idr_destroy(&ida->idr);
-	kfree(ida->free_bitmap);
 }
 EXPORT_SYMBOL(ida_destroy);
 
@@ -1142,7 +1102,6 @@ EXPORT_SYMBOL(ida_simple_remove);
  */
 void ida_init(struct ida *ida)
 {
-	memset(ida, 0, sizeof(struct ida));
 	idr_init(&ida->idr);
 
 }
-- 
1.7.4.4

