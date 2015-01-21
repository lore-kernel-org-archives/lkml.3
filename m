Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807AbbAUGRr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 01:17:47 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:38700 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754139AbbAUGOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 01:14:36 -0500
X-Original-SENDERIP: 10.177.222.143
X-Original-MAILFROM: minchan@kernel.org
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Dan Streetman <ddstreet@ieee.org>,
        Seth Jennings <sjennings@variantweb.net>,
        Nitin Gupta <ngupta@vflare.org>, Juneho Choi <juno.choi@lge.com>,
        Gunho Lee <gunho.lee@lge.com>, Luigi Semenzato <semenzato@google.com>,
        Jerome Marchand <jmarchan@redhat.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCH v1 05/10] zsmalloc: add status bit
Date: Wed, 21 Jan 2015 15:14:21 +0900
Message-Id: <1421820866-26521-6-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1421820866-26521-1-git-send-email-minchan@kernel.org>
References: <1421820866-26521-1-git-send-email-minchan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For migration, we need to identify which object in zspage is
allocated so that we could migrate allocated(ie, used) object.
We could know it by iterating of freed objects in a zspage
but it's inefficient. Instead, this patch adds a tag(ie,
OBJ_ALLOCATED_TAG) in the head of each object(ie, handle) so
we could check the object is allocated or not efficiently
during migration. Mixing the tag into handle kept in the memory
is okay because handle is allocated by slab so least two bit
is free to use it.

Another status bit this patch is adding is HANDLE_PIN_TAG.
During migration, it cannot move the object user are using
by zs_map_object due to data coherency between old object and
new object. Migration will check it to skip the object in
later patch.

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 mm/zsmalloc.c | 64 ++++++++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 48 insertions(+), 16 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index e52b1b6..99555da 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -135,7 +135,24 @@
 #endif
 #endif
 #define _PFN_BITS		(MAX_PHYSMEM_BITS - PAGE_SHIFT)
-#define OBJ_INDEX_BITS	(BITS_PER_LONG - _PFN_BITS)
+
+/*
+ * Memory for allocating handle keeps object position by
+ * encoding <page, obj_idx> and the encoded value has a room
+ * in the least bit(ie, look at obj_to_location).
+ * We use the bit to indicate the object is accessed by client
+ * via zs_map_object so the migraion can skip the object.
+ */
+#define HANDLE_PIN_TAG	1
+
+/*
+ * Head in allocated object should have OBJ_ALLOCATED_TAG.
+ * It's okay to keep the handle valid because handle is 4byte-aligned
+ * address so we have room for two bit.
+ */
+#define OBJ_ALLOCATED_TAG 1
+#define OBJ_TAG_BITS 1
+#define OBJ_INDEX_BITS	(BITS_PER_LONG - _PFN_BITS - OBJ_TAG_BITS)
 #define OBJ_INDEX_MASK	((_AC(1, UL) << OBJ_INDEX_BITS) - 1)
 
 #define MAX(a, b) ((a) >= (b) ? (a) : (b))
@@ -610,35 +627,35 @@ static struct page *get_next_page(struct page *page)
 
 /*
  * Encode <page, obj_idx> as a single handle value.
- * On hardware platforms with physical memory starting at 0x0 the pfn
- * could be 0 so we ensure that the handle will never be 0 by adjusting the
- * encoded obj_idx value before encoding.
+ * We use the least bit of handle for tagging.
  */
-static void *obj_location_to_handle(struct page *page, unsigned long obj_idx)
+static void *location_to_obj(struct page *page, unsigned long obj_idx)
 {
-	unsigned long handle;
+	unsigned long obj;
 
 	if (!page) {
 		BUG_ON(obj_idx);
 		return NULL;
 	}
 
-	handle = page_to_pfn(page) << OBJ_INDEX_BITS;
-	handle |= ((obj_idx + 1) & OBJ_INDEX_MASK);
+	obj = page_to_pfn(page) << OBJ_INDEX_BITS;
+	obj |= ((obj_idx) & OBJ_INDEX_MASK);
+	obj <<= OBJ_TAG_BITS;
 
-	return (void *)handle;
+	return (void *)obj;
 }
 
 /*
  * Decode <page, obj_idx> pair from the given object handle. We adjust the
  * decoded obj_idx back to its original value since it was adjusted in
- * obj_location_to_handle().
+ * location_to_obj().
  */
-static void obj_to_location(unsigned long handle, struct page **page,
+static void obj_to_location(unsigned long obj, struct page **page,
 				unsigned long *obj_idx)
 {
-	*page = pfn_to_page(handle >> OBJ_INDEX_BITS);
-	*obj_idx = (handle & OBJ_INDEX_MASK) - 1;
+	obj >>= OBJ_TAG_BITS;
+	*page = pfn_to_page(obj >> OBJ_INDEX_BITS);
+	*obj_idx = (obj & OBJ_INDEX_MASK);
 }
 
 static unsigned long handle_to_obj(unsigned long handle)
@@ -657,6 +674,16 @@ static unsigned long obj_idx_to_offset(struct page *page,
 	return off + obj_idx * class_size;
 }
 
+static void pin_tag(unsigned long handle)
+{
+	record_obj(handle, *(unsigned long *)handle | HANDLE_PIN_TAG);
+}
+
+static void unpin_tag(unsigned long handle)
+{
+	record_obj(handle, *(unsigned long *)handle & ~HANDLE_PIN_TAG);
+}
+
 static void reset_page(struct page *page)
 {
 	clear_bit(PG_private, &page->flags);
@@ -718,7 +745,7 @@ static void init_zspage(struct page *first_page, struct size_class *class)
 		link = (struct link_free *)vaddr + off / sizeof(*link);
 
 		while ((off += class->size) < PAGE_SIZE) {
-			link->next = obj_location_to_handle(page, i++);
+			link->next = location_to_obj(page, i++);
 			link += class->size / sizeof(*link);
 		}
 
@@ -728,7 +755,7 @@ static void init_zspage(struct page *first_page, struct size_class *class)
 		 * page (if present)
 		 */
 		next_page = get_next_page(page);
-		link->next = obj_location_to_handle(next_page, 0);
+		link->next = location_to_obj(next_page, 0);
 		kunmap_atomic(vaddr);
 		page = next_page;
 		off %= PAGE_SIZE;
@@ -782,7 +809,7 @@ static struct page *alloc_zspage(struct size_class *class, gfp_t flags)
 
 	init_zspage(first_page, class);
 
-	first_page->freelist = obj_location_to_handle(first_page, 0);
+	first_page->freelist = location_to_obj(first_page, 0);
 	/* Maximum number of objects we can store in this zspage */
 	first_page->objects = class->pages_per_zspage * PAGE_SIZE / class->size;
 
@@ -1219,6 +1246,8 @@ void *zs_map_object(struct zs_pool *pool, unsigned long handle,
 	 */
 	BUG_ON(in_interrupt());
 
+	pin_tag(handle);
+
 	obj = handle_to_obj(handle);
 	obj_to_location(obj, &page, &obj_idx);
 	get_zspage_mapping(get_first_page(page), &class_idx, &fg);
@@ -1276,6 +1305,7 @@ void zs_unmap_object(struct zs_pool *pool, unsigned long handle)
 		__zs_unmap_object(area, pages, off, class->size);
 	}
 	put_cpu_var(zs_map_area);
+	unpin_tag(handle);
 }
 EXPORT_SYMBOL_GPL(zs_unmap_object);
 
@@ -1289,6 +1319,7 @@ static unsigned long obj_malloc(struct page *first_page,
 	unsigned long m_objidx, m_offset;
 	void *vaddr;
 
+	handle |= OBJ_ALLOCATED_TAG;
 	obj = (unsigned long)first_page->freelist;
 	obj_to_location(obj, &m_page, &m_objidx);
 	m_offset = obj_idx_to_offset(m_page, m_objidx, class->size);
@@ -1374,6 +1405,7 @@ static void obj_free(struct zs_pool *pool, struct size_class *class,
 
 	BUG_ON(!obj);
 
+	obj &= ~OBJ_ALLOCATED_TAG;
 	obj_to_location(obj, &f_page, &f_objidx);
 	first_page = get_first_page(f_page);
 
-- 
1.9.3

