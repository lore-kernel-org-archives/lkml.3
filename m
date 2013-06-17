Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269Ab3FQWGe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 18:06:34 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:33076 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171Ab3FQWGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 18:06:32 -0400
Message-ID: <51BF8860.7010909@gmail.com>
Date: Tue, 18 Jun 2013 06:06:24 +0800
From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Rientjes <rientjes@google.com>, Linux MM <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] mm: Remove unlikely from the current_order test
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

In __rmqueue_fallback(), current_order loops down from MAX_ORDER - 1
to the order passed. MAX_ORDER is typically 11 and pageblock_order
is typically 9 on x86. Integer division truncates, so pageblock_order / 2
is 4.  For the first eight iterations, it's guaranteed that
current_order >= pageblock_order / 2 if it even gets that far!

So just remove the unlikely(), it's completely bogus.

Suggested-by: David Rientjes <rientjes@google.com>
Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 mm/page_alloc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c3edb62..7b4f367 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1050,7 +1050,7 @@ __rmqueue_fallback(struct zone *zone, int order, int start_migratetype)
 			 * MIGRATE_CMA areas.
 			 */
 			if (!is_migrate_cma(migratetype) &&
-			    (unlikely(current_order >= pageblock_order / 2) ||
+			    (current_order >= pageblock_order / 2 ||
 			     start_migratetype == MIGRATE_RECLAIMABLE ||
 			     page_group_by_mobility_disabled)) {
 				int pages;
-- 
1.7.1
