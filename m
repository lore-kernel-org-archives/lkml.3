Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630AbbAUGSW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 01:18:22 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:38670 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130AbbAUGOg (ORCPT
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
Subject: [PATCH v1 03/10] zsmalloc: implement reverse mapping
Date: Wed, 21 Jan 2015 15:14:19 +0900
Message-Id: <1421820866-26521-4-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1421820866-26521-1-git-send-email-minchan@kernel.org>
References: <1421820866-26521-1-git-send-email-minchan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch supports reverse mapping which gets handle from object.
For keeping handle per object, it allocates ZS_HANDLE_SIZE greater
than size user requested and stores handle in the extra space.
IOW, *(address mapped by zs_map_object - ZS_HANDLE_SIZE) == handle.

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 mm/zsmalloc.c | 38 ++++++++++++++++++++++++++++++--------
 1 file changed, 30 insertions(+), 8 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 9436ee8..2df2f1b 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -142,7 +142,8 @@
 /* ZS_MIN_ALLOC_SIZE must be multiple of ZS_ALIGN */
 #define ZS_MIN_ALLOC_SIZE \
 	MAX(32, (ZS_MAX_PAGES_PER_ZSPAGE << PAGE_SHIFT >> OBJ_INDEX_BITS))
-#define ZS_MAX_ALLOC_SIZE	PAGE_SIZE
+/* each chunk includes extra space to keep handle */
+#define ZS_MAX_ALLOC_SIZE	(PAGE_SIZE + ZS_HANDLE_SIZE)
 
 /*
  * On systems with 4K page size, this gives 255 size classes! There is a
@@ -235,8 +236,17 @@ struct size_class {
  * This must be power of 2 and less than or equal to ZS_ALIGN
  */
 struct link_free {
-	/* Handle of next free chunk (encodes <PFN, obj_idx>) */
-	void *next;
+	union {
+		/*
+		 * Position of next free chunk (encodes <PFN, obj_idx>)
+		 * It's valid for non-allocated object
+		 */
+		void *next;
+		/*
+		 * Handle of allocated object.
+		 */
+		unsigned long handle;
+	};
 };
 
 struct zs_pool {
@@ -896,12 +906,16 @@ static void __zs_unmap_object(struct mapping_area *area,
 {
 	int sizes[2];
 	void *addr;
-	char *buf = area->vm_buf;
+	char *buf;
 
 	/* no write fastpath */
 	if (area->vm_mm == ZS_MM_RO)
 		goto out;
 
+	buf = area->vm_buf + ZS_HANDLE_SIZE;
+	size -= ZS_HANDLE_SIZE;
+	off += ZS_HANDLE_SIZE;
+
 	sizes[0] = PAGE_SIZE - off;
 	sizes[1] = size - sizes[0];
 
@@ -1196,6 +1210,7 @@ void *zs_map_object(struct zs_pool *pool, unsigned long handle,
 	struct size_class *class;
 	struct mapping_area *area;
 	struct page *pages[2];
+	void *ret;
 
 	BUG_ON(!handle);
 
@@ -1217,7 +1232,8 @@ void *zs_map_object(struct zs_pool *pool, unsigned long handle,
 	if (off + class->size <= PAGE_SIZE) {
 		/* this object is contained entirely within a page */
 		area->vm_addr = kmap_atomic(page);
-		return area->vm_addr + off;
+		ret = area->vm_addr + off;
+		goto out;
 	}
 
 	/* this object spans two pages */
@@ -1225,7 +1241,9 @@ void *zs_map_object(struct zs_pool *pool, unsigned long handle,
 	pages[1] = get_next_page(page);
 	BUG_ON(!pages[1]);
 
-	return __zs_map_object(area, pages, off, class->size);
+	ret = __zs_map_object(area, pages, off, class->size);
+out:
+	return ret + ZS_HANDLE_SIZE;
 }
 EXPORT_SYMBOL_GPL(zs_map_object);
 
@@ -1282,13 +1300,15 @@ unsigned long zs_malloc(struct zs_pool *pool, size_t size)
 	struct page *first_page, *m_page;
 	unsigned long m_objidx, m_offset;
 
-	if (unlikely(!size || size > ZS_MAX_ALLOC_SIZE))
+	if (unlikely(!size || (size + ZS_HANDLE_SIZE) > ZS_MAX_ALLOC_SIZE))
 		return 0;
 
 	handle = alloc_handle(pool);
 	if (!handle)
 		return 0;
 
+	/* extra space in chunk to keep the handle */
+	size += ZS_HANDLE_SIZE;
 	class = pool->size_class[get_size_class_index(size)];
 
 	spin_lock(&class->lock);
@@ -1318,7 +1338,9 @@ unsigned long zs_malloc(struct zs_pool *pool, size_t size)
 	vaddr = kmap_atomic(m_page);
 	link = (struct link_free *)vaddr + m_offset / sizeof(*link);
 	first_page->freelist = link->next;
-	memset(link, POISON_INUSE, sizeof(*link));
+
+	/* record handle in the header of allocated chunk */
+	link->handle = handle;
 	kunmap_atomic(vaddr);
 
 	first_page->inuse++;
-- 
1.9.3

