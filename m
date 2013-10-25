Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566Ab3JYSJt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 14:09:49 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:53488 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123Ab3JYSJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 14:09:48 -0400
From: kosaki.motohiro@gmail.com
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, akpm@linux-foundation.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH] Fix page_group_by_mobility_disabled breakage
Date: Fri, 25 Oct 2013 14:09:35 -0400
Message-Id: <1382724575-8450-1-git-send-email-kosaki.motohiro@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Currently, set_pageblock_migratetype screw up MIGRATE_CMA and
MIGRATE_ISOLATE if page_group_by_mobility_disabled is true. It
rewrite the argument to MIGRATE_UNMOVABLE and we lost these attribute.

The problem was introduced commit 49255c619f (page allocator: move
check for disabled anti-fragmentation out of fastpath). So, 4 years
lived issue may mean that nobody uses page_group_by_mobility_disabled.

But anyway, this patch fixes the problem.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>
---
 mm/page_alloc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index dd886fa..ef44d95 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -234,8 +234,8 @@ int page_group_by_mobility_disabled __read_mostly;
 
 void set_pageblock_migratetype(struct page *page, int migratetype)
 {
-
-	if (unlikely(page_group_by_mobility_disabled))
+	if (unlikely(page_group_by_mobility_disabled &&
+		     migratetype < MIGRATE_PCPTYPES))
 		migratetype = MIGRATE_UNMOVABLE;
 
 	set_pageblock_flags_group(page, (unsigned long)migratetype,
-- 
1.7.1

