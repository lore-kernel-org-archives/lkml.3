Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756317Ab3H3NU5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 09:20:57 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:42085 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756293Ab3H3NUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 09:20:54 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [RFC PATCH v3 09/35] mm: Track the freepage migratetype of pages
 accurately
To: akpm@linux-foundation.org, mgorman@suse.de, hannes@cmpxchg.org,
        tony.luck@intel.com, matthew.garrett@nebula.com, dave@sr71.net,
        riel@redhat.com, arjan@linux.intel.com,
        srinivas.pandruvada@linux.intel.com, willy@linux.intel.com,
        kamezawa.hiroyu@jp.fujitsu.com, lenb@kernel.org, rjw@sisk.pl
Cc: gargankita@gmail.com, paulmck@linux.vnet.ibm.com,
        svaidy@linux.vnet.ibm.com, andi@firstfloor.org,
        isimatu.yasuaki@jp.fujitsu.com, santosh.shilimkar@ti.com,
        kosaki.motohiro@gmail.com, srivatsa.bhat@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Date: Fri, 30 Aug 2013 18:46:38 +0530
Message-ID: <20130830131635.4947.81565.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130830131221.4947.99764.stgit@srivatsabhat.in.ibm.com>
References: <20130830131221.4947.99764.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13083013-1542-0000-0000-000000FD69D4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to the region-wise ordering of the pages in the buddy allocator's
free lists, whenever we want to delete a free pageblock from a free list
(for ex: when moving blocks of pages from one list to the other), we need
to be able to tell the buddy allocator exactly which migratetype it belongs
to. For that purpose, we can use the page's freepage migratetype (which is
maintained in the page's ->index field).

So, while splitting up higher order pages into smaller ones as part of buddy
operations, keep the new head pages updated with the correct freepage
migratetype information (because we depend on tracking this info accurately,
as outlined above).

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 mm/page_alloc.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 398b62c..b4b1275 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -947,6 +947,13 @@ static inline void expand(struct zone *zone, struct page *page,
 		add_to_freelist(&page[size], &area->free_list[migratetype]);
 		area->nr_free++;
 		set_page_order(&page[size], high);
+
+		/*
+		 * Freepage migratetype is tracked using the index field of the
+		 * first page of the block. So we need to update the new first
+		 * page, when changing the page order.
+		 */
+		set_freepage_migratetype(&page[size], migratetype);
 	}
 }
 

