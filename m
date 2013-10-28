Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab3J1LnQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 07:43:16 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:47497 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754908Ab3J1LnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 07:43:15 -0400
From: zhang.mingjun@linaro.org
To: minchan@kernel.org, m.szyprowski@samsung.com, akpm@linux-foundation.org,
        mgorman@suse.de, haojian.zhuang@linaro.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc: Mingjun Zhang <troy.zhangmingjun@linaro.org>
Subject: [PATCH] mm: cma: free cma page to buddy instead of being cpu hot  page
Date: Mon, 28 Oct 2013 19:42:49 +0800
Message-Id: <1382960569-6564-1-git-send-email-zhang.mingjun@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mingjun Zhang <troy.zhangmingjun@linaro.org>

free_contig_range frees cma pages one by one and MIGRATE_CMA pages will be
used as MIGRATE_MOVEABLE pages in the pcp list, it causes unnecessary
migration action when these pages reused by CMA.

Signed-off-by: Mingjun Zhang <troy.zhangmingjun@linaro.org>
---
 mm/page_alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 0ee638f..84b9d84 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1362,7 +1362,8 @@ void free_hot_cold_page(struct page *page, int cold)
 	 * excessively into the page allocator
 	 */
 	if (migratetype >= MIGRATE_PCPTYPES) {
-		if (unlikely(is_migrate_isolate(migratetype))) {
+		if (unlikely(is_migrate_isolate(migratetype))
+			|| is_migrate_cma(migratetype))
 			free_one_page(zone, page, 0, migratetype);
 			goto out;
 		}
-- 
1.7.9.5

