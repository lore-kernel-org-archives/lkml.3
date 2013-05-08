Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758194Ab3EHQDS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 12:03:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37146 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757773Ab3EHQDL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 12:03:11 -0400
From: Mel Gorman <mgorman@suse.de>
To: Linux-MM <linux-mm@kvack.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Dave Hansen <dave@sr71.net>,
        Christoph Lameter <cl@linux.com>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 01/22] mm: page allocator: Lookup pageblock migratetype with IRQs enabled during free
Date: Wed,  8 May 2013 17:02:46 +0100
Message-Id: <1368028987-8369-2-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1368028987-8369-1-git-send-email-mgorman@suse.de>
References: <1368028987-8369-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_pageblock_migratetype() is called during free with IRQs disabled.
This is unnecessary and disables IRQs for longer than necessary.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/page_alloc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 8fcced7..277ecee 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -730,9 +730,10 @@ static void __free_pages_ok(struct page *page, unsigned int order)
 	if (!free_pages_prepare(page, order))
 		return;
 
+	migratetype = get_pageblock_migratetype(page);
+
 	local_irq_save(flags);
 	__count_vm_events(PGFREE, 1 << order);
-	migratetype = get_pageblock_migratetype(page);
 	set_freepage_migratetype(page, migratetype);
 	free_one_page(page_zone(page), page, order, migratetype);
 	local_irq_restore(flags);
-- 
1.8.1.4

