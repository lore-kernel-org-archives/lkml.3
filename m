Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007Ab3JaEY6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 00:24:58 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:58069 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762Ab3JaEY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 00:24:57 -0400
From: kosaki.motohiro@gmail.com
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, akpm@linux-foundation.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH] mm: __rmqueue_fallback() should respect pageblock type
Date: Thu, 31 Oct 2013 00:24:49 -0400
Message-Id: <1383193489-27331-1-git-send-email-kosaki.motohiro@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

When __rmqueue_fallback() don't find out a free block with the same size
of required, it splits a larger page and puts back rest peiece of the page
to free list.

But it has one serious mistake. When putting back, __rmqueue_fallback()
always use start_migratetype if type is not CMA. However, __rmqueue_fallback()
is only called when all of start_migratetype queue are empty. That said,
__rmqueue_fallback always put back memory to wrong queue except
try_to_steal_freepages() changed pageblock type (i.e. requested size is
smaller than half of page block). Finally, antifragmentation framework
increase fragmenation instead of decrease.

Mel's original anti fragmentation do the right thing. But commit 47118af076
(mm: mmzone: MIGRATE_CMA migration type added) broke it.

This patch restores sane and old behavior.

Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/page_alloc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index dd886fa..ea7bb9a 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1101,7 +1101,7 @@ __rmqueue_fallback(struct zone *zone, int order, int start_migratetype)
 			 */
 			expand(zone, page, order, current_order, area,
 			       is_migrate_cma(migratetype)
-			     ? migratetype : start_migratetype);
+			     ? migratetype : new_type);
 
 			trace_mm_page_alloc_extfrag(page, order,
 				current_order, start_migratetype, migratetype,
-- 
1.7.1

