Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298AbaCLG6M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 02:58:12 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:63419 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755425AbaCLG6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 02:58:11 -0400
X-Original-SENDERIP: 10.186.119.203
X-Original-MAILFROM: jungsoo.son@lge.com
From: Jungsoo Son <jungsoo.son@lge.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Jungsoo Son <jungsoo.son@lge.com>, Minchan Kim <minchan@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH] page owners: correct page->order when to free page
Date: Wed, 12 Mar 2014 15:58:06 +0900
Message-Id: <1394607486-31493-1-git-send-email-jungsoo.son@lge.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I use PAGE_OWNER in mmotm tree, I found a problem that mismatches
the number of allocated pages. When I investigate, the problem is that
set_page_order is called for only a head page if freed page is merged to
a higher order page in the buddy allocator so tail pages of the higher
order page couldn't be reset to page->order = -1.

It means when we do 'cat /proc/page-owner', it could show wrong
information.

So page->order should be set to -1 for all the tail pages as well as the
first page before buddy allocator merges them.

This patch is for clearing page->order of all the tail pages in
free_pages_prepare() when to free page.

Signed-off-by: Jungsoo Son <jungsoo.son@lge.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 mm/page_alloc.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index dfbc967..9b946f0 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -741,6 +741,13 @@ static bool free_pages_prepare(struct page *page, unsigned int order)
 	if (bad)
 		return false;
 
+#ifdef CONFIG_PAGE_OWNER
+	for (i = 0; i < (1 << order); i++) {
+		struct page *p = (page + i);
+		p->order = -1;
+	}
+#endif
+
 	if (!PageHighMem(page)) {
 		debug_check_no_locks_freed(page_address(page),
 					   PAGE_SIZE << order);
-- 
1.7.9.5

