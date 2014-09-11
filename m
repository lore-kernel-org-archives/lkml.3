Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282AbaIKUzB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 16:55:01 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:42364 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932264AbaIKUy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 16:54:57 -0400
From: Dan Streetman <ddstreet@ieee.org>
To: Minchan Kim <minchan@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjennings@variantweb.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Streetman <ddstreet@ieee.org>
Subject: [PATCH 04/10] zsmalloc: move zspage obj freeing to separate function
Date: Thu, 11 Sep 2014 16:53:55 -0400
Message-Id: <1410468841-320-5-git-send-email-ddstreet@ieee.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1410468841-320-1-git-send-email-ddstreet@ieee.org>
References: <1410468841-320-1-git-send-email-ddstreet@ieee.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the code that frees a zspage object out of the zs_free()
function and into its own obj_free() function.

This is required by zsmalloc shrinking, which will also need to
free objects during zspage reclaiming.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
Cc: Minchan Kim <minchan@kernel.org>
---
 mm/zsmalloc.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 51db622..cff8935 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -584,6 +584,21 @@ static unsigned long obj_idx_to_offset(struct page *page,
 	return off + obj_idx * class_size;
 }
 
+static void obj_free(unsigned long obj, struct page *page, unsigned long offset)
+{
+	struct page *first_page = get_first_page(page);
+	struct link_free *link;
+
+	/* Insert this object in containing zspage's freelist */
+	link = (struct link_free *)((unsigned char *)kmap_atomic(page)
+							+ offset);
+	link->next = first_page->freelist;
+	kunmap_atomic(link);
+	first_page->freelist = (void *)obj;
+
+	first_page->inuse--;
+}
+
 static void reset_page(struct page *page)
 {
 	clear_bit(PG_private, &page->flags);
@@ -1049,7 +1064,6 @@ EXPORT_SYMBOL_GPL(zs_malloc);
 
 void zs_free(struct zs_pool *pool, unsigned long obj)
 {
-	struct link_free *link;
 	struct page *first_page, *f_page;
 	unsigned long f_objidx, f_offset;
 
@@ -1069,14 +1083,8 @@ void zs_free(struct zs_pool *pool, unsigned long obj)
 
 	spin_lock(&class->lock);
 
-	/* Insert this object in containing zspage's freelist */
-	link = (struct link_free *)((unsigned char *)kmap_atomic(f_page)
-							+ f_offset);
-	link->next = first_page->freelist;
-	kunmap_atomic(link);
-	first_page->freelist = (void *)obj;
+	obj_free(obj, f_page, f_offset);
 
-	first_page->inuse--;
 	fullness = fix_fullness_group(pool, first_page);
 	spin_unlock(&class->lock);
 
-- 
1.8.3.1

