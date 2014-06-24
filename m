Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435AbaFXWap (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 18:30:45 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:51024 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbaFXWan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 18:30:43 -0400
Date: Tue, 24 Jun 2014 15:30:41 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [patch] mm, vmalloc: constify allocation mask
Message-ID: <alpine.DEB.2.02.1406241527030.29176@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tmp_mask in the __vmalloc_area_node() iteration never changes so it can be 
moved into function scope and marked with const.  This causes the movl and 
orl to only be done once per call rather than area->nr_pages times.

nested_gfp can also be marked const.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/vmalloc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1566,7 +1566,8 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 	const int order = 0;
 	struct page **pages;
 	unsigned int nr_pages, array_size, i;
-	gfp_t nested_gfp = (gfp_mask & GFP_RECLAIM_MASK) | __GFP_ZERO;
+	const gfp_t nested_gfp = (gfp_mask & GFP_RECLAIM_MASK) | __GFP_ZERO;
+	const gfp_t alloc_mask = gfp_mask | __GFP_NOWARN;
 
 	nr_pages = get_vm_area_size(area) >> PAGE_SHIFT;
 	array_size = (nr_pages * sizeof(struct page *));
@@ -1589,12 +1590,11 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 
 	for (i = 0; i < area->nr_pages; i++) {
 		struct page *page;
-		gfp_t tmp_mask = gfp_mask | __GFP_NOWARN;
 
 		if (node == NUMA_NO_NODE)
-			page = alloc_page(tmp_mask);
+			page = alloc_page(alloc_mask);
 		else
-			page = alloc_pages_node(node, tmp_mask, order);
+			page = alloc_pages_node(node, alloc_mask, order);
 
 		if (unlikely(!page)) {
 			/* Successfully allocated i pages, free them in __vunmap() */
