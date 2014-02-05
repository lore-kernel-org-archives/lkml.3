Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994AbaBEAW5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 19:22:57 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:65135 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbaBEAWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 19:22:55 -0500
Date: Tue, 4 Feb 2014 16:22:53 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>,
        Holger Kiehl <Holger.Kiehl@dwd.de>
cc: Christoph Lameter <cl@linux.com>, Rafael Aquini <aquini@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [patch v2] mm, page_alloc: make first_page visible before PageTail
In-Reply-To: <alpine.DEB.2.02.1402041613450.14962@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.02.1402041621350.14962@chino.kir.corp.google.com>
References: <alpine.LRH.2.02.1401312037340.6630@diagnostix.dwd.de> <20140203122052.GC2495@dhcp22.suse.cz> <alpine.LRH.2.02.1402031426510.13382@diagnostix.dwd.de> <20140203162036.GJ2495@dhcp22.suse.cz> <52EFC93D.3030106@suse.cz>
 <alpine.DEB.2.02.1402031602060.10778@chino.kir.corp.google.com> <alpine.LRH.2.02.1402040713220.13901@diagnostix.dwd.de> <alpine.DEB.2.02.1402041557380.10140@chino.kir.corp.google.com> <20140204160641.8f5d369eeb2d0318618d6d5f@linux-foundation.org>
 <alpine.DEB.2.02.1402041613450.14962@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit bf6bddf1924e ("mm: introduce compaction and migration for ballooned
pages") introduces page_count(page) into memory compaction which
dereferences page->first_page if PageTail(page).

Introduce a store memory barrier to ensure page->first_page is properly
initialized so that code that does page_count(page) on pages off the lru
always have a valid p->first_page.

Reported-by: Holger Kiehl <Holger.Kiehl@dwd.de>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 v2: with commentary, per checkpatch

 mm/page_alloc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -369,9 +369,11 @@ void prep_compound_page(struct page *page, unsigned long order)
 	__SetPageHead(page);
 	for (i = 1; i < nr_pages; i++) {
 		struct page *p = page + i;
-		__SetPageTail(p);
 		set_page_count(p, 0);
 		p->first_page = page;
+		/* Make sure p->first_page is always valid for PageTail() */
+		smp_wmb();
+		__SetPageTail(p);
 	}
 }
 
