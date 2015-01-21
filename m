Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbbAUGSB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 01:18:01 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:38677 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132AbbAUGOg (ORCPT
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
Subject: [PATCH v1 04/10] zsmalloc: factor out obj_[malloc|free]
Date: Wed, 21 Jan 2015 15:14:20 +0900
Message-Id: <1421820866-26521-5-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1421820866-26521-1-git-send-email-minchan@kernel.org>
References: <1421820866-26521-1-git-send-email-minchan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In later patch, migration needs a part of function in zs_[malloc|free].
So, this patch factor out them.

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 mm/zsmalloc.c | 99 ++++++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 61 insertions(+), 38 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 2df2f1b..e52b1b6 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -525,11 +525,10 @@ static void remove_zspage(struct page *page, struct size_class *class,
  * page from the freelist of the old fullness group to that of the new
  * fullness group.
  */
-static enum fullness_group fix_fullness_group(struct zs_pool *pool,
+static enum fullness_group fix_fullness_group(struct size_class *class,
 						struct page *page)
 {
 	int class_idx;
-	struct size_class *class;
 	enum fullness_group currfg, newfg;
 
 	BUG_ON(!is_first_page(page));
@@ -539,7 +538,6 @@ static enum fullness_group fix_fullness_group(struct zs_pool *pool,
 	if (newfg == currfg)
 		goto out;
 
-	class = pool->size_class[class_idx];
 	remove_zspage(page, class, currfg);
 	insert_zspage(page, class, newfg);
 	set_zspage_mapping(page, class_idx, newfg);
@@ -1281,6 +1279,33 @@ void zs_unmap_object(struct zs_pool *pool, unsigned long handle)
 }
 EXPORT_SYMBOL_GPL(zs_unmap_object);
 
+static unsigned long obj_malloc(struct page *first_page,
+		struct size_class *class, unsigned long handle)
+{
+	unsigned long obj;
+	struct link_free *link;
+
+	struct page *m_page;
+	unsigned long m_objidx, m_offset;
+	void *vaddr;
+
+	obj = (unsigned long)first_page->freelist;
+	obj_to_location(obj, &m_page, &m_objidx);
+	m_offset = obj_idx_to_offset(m_page, m_objidx, class->size);
+
+	vaddr = kmap_atomic(m_page);
+	link = (struct link_free *)vaddr + m_offset / sizeof(*link);
+	first_page->freelist = link->next;
+	/* record handle in the header of allocated chunk */
+	link->handle = handle;
+	kunmap_atomic(vaddr);
+	first_page->inuse++;
+	zs_stat_inc(class, OBJ_USED, 1);
+
+	return obj;
+}
+
+
 /**
  * zs_malloc - Allocate block of given size from pool.
  * @pool: pool to allocate from
@@ -1293,12 +1318,8 @@ EXPORT_SYMBOL_GPL(zs_unmap_object);
 unsigned long zs_malloc(struct zs_pool *pool, size_t size)
 {
 	unsigned long handle, obj;
-	struct link_free *link;
 	struct size_class *class;
-	void *vaddr;
-
-	struct page *first_page, *m_page;
-	unsigned long m_objidx, m_offset;
+	struct page *first_page;
 
 	if (unlikely(!size || (size + ZS_HANDLE_SIZE) > ZS_MAX_ALLOC_SIZE))
 		return 0;
@@ -1331,22 +1352,9 @@ unsigned long zs_malloc(struct zs_pool *pool, size_t size)
 				class->size, class->pages_per_zspage));
 	}
 
-	obj = (unsigned long)first_page->freelist;
-	obj_to_location(obj, &m_page, &m_objidx);
-	m_offset = obj_idx_to_offset(m_page, m_objidx, class->size);
-
-	vaddr = kmap_atomic(m_page);
-	link = (struct link_free *)vaddr + m_offset / sizeof(*link);
-	first_page->freelist = link->next;
-
-	/* record handle in the header of allocated chunk */
-	link->handle = handle;
-	kunmap_atomic(vaddr);
-
-	first_page->inuse++;
-	zs_stat_inc(class, OBJ_USED, 1);
+	obj = obj_malloc(first_page, class, handle);
 	/* Now move the zspage to another fullness group, if required */
-	fix_fullness_group(pool, first_page);
+	fix_fullness_group(class, first_page);
 	record_obj(handle, obj);
 	spin_unlock(&class->lock);
 
@@ -1354,46 +1362,61 @@ unsigned long zs_malloc(struct zs_pool *pool, size_t size)
 }
 EXPORT_SYMBOL_GPL(zs_malloc);
 
-void zs_free(struct zs_pool *pool, unsigned long handle)
+static void obj_free(struct zs_pool *pool, struct size_class *class,
+			unsigned long obj)
 {
 	struct link_free *link;
 	struct page *first_page, *f_page;
-	unsigned long obj, f_objidx, f_offset;
+	unsigned long f_objidx, f_offset;
 	void *vaddr;
-
 	int class_idx;
-	struct size_class *class;
 	enum fullness_group fullness;
 
-	if (unlikely(!handle))
-		return;
+	BUG_ON(!obj);
 
-	obj = handle_to_obj(handle);
-	free_handle(pool, handle);
 	obj_to_location(obj, &f_page, &f_objidx);
 	first_page = get_first_page(f_page);
 
 	get_zspage_mapping(first_page, &class_idx, &fullness);
-	class = pool->size_class[class_idx];
 	f_offset = obj_idx_to_offset(f_page, f_objidx, class->size);
 
-	spin_lock(&class->lock);
+	vaddr = kmap_atomic(f_page);
 
 	/* Insert this object in containing zspage's freelist */
-	vaddr = kmap_atomic(f_page);
 	link = (struct link_free *)(vaddr + f_offset);
 	link->next = first_page->freelist;
 	kunmap_atomic(vaddr);
 	first_page->freelist = (void *)obj;
-
 	first_page->inuse--;
-	fullness = fix_fullness_group(pool, first_page);
-
 	zs_stat_dec(class, OBJ_USED, 1);
+}
+
+void zs_free(struct zs_pool *pool, unsigned long handle)
+{
+	struct page *first_page, *f_page;
+	unsigned long obj, f_objidx;
+
+	int class_idx;
+	struct size_class *class;
+	enum fullness_group fullness;
+
+	if (unlikely(!handle))
+		return;
+
+	obj = handle_to_obj(handle);
+	free_handle(pool, handle);
+	obj_to_location(obj, &f_page, &f_objidx);
+	first_page = get_first_page(f_page);
+
+	get_zspage_mapping(first_page, &class_idx, &fullness);
+	class = pool->size_class[class_idx];
+
+	spin_lock(&class->lock);
+	obj_free(pool, class, obj);
+	fullness = fix_fullness_group(class, first_page);
 	if (fullness == ZS_EMPTY)
 		zs_stat_dec(class, OBJ_ALLOCATED, get_maxobj_per_zspage(
 				class->size, class->pages_per_zspage));
-
 	spin_unlock(&class->lock);
 
 	if (fullness == ZS_EMPTY) {
-- 
1.9.3

