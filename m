Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340AbaH1ShO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:37:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32884 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753284AbaH1ShJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:37:09 -0400
From: Mel Gorman <mgorman@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linux-Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 79/97] mm: page_alloc: lookup pageblock migratetype with IRQs enabled during free
Date: Thu, 28 Aug 2014 19:35:27 +0100
Message-Id: <1409250945-30874-80-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1409250945-30874-1-git-send-email-mgorman@suse.de>
References: <1409250945-30874-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit cfc47a2803db42140167b92d991ef04018e162c7 upstream.

get_pageblock_migratetype() is called during free with IRQs disabled.
This is unnecessary and disables IRQs for longer than necessary.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Jan Kara <jack@suse.cz>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/page_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b1b1522..478fcfe 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -760,9 +760,9 @@ static void __free_pages_ok(struct page *page, unsigned int order)
 	if (!free_pages_prepare(page, order))
 		return;
 
+	migratetype = get_pfnblock_migratetype(page, pfn);
 	local_irq_save(flags);
 	__count_vm_events(PGFREE, 1 << order);
-	migratetype = get_pfnblock_migratetype(page, pfn);
 	set_freepage_migratetype(page, migratetype);
 	free_one_page(page_zone(page), page, pfn, order, migratetype);
 	local_irq_restore(flags);
-- 
1.8.4.5

