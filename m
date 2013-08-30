Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756950Ab3H3N2r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 09:28:47 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:43909 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756618Ab3H3N2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 09:28:45 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [RFC PATCH v3 34/35] mm: Set pageblock migratetype when allocating
 regions from region allocator
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
Date: Fri, 30 Aug 2013 18:54:40 +0530
Message-ID: <20130830132437.4947.12826.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130830131221.4947.99764.stgit@srivatsabhat.in.ibm.com>
References: <20130830131221.4947.99764.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13083013-9332-0000-0000-00000141DA64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We would like to maintain memory regions such that all memory pertaining to
given a memory region serves allocations of a single migratetype. IOW, we
don't want to permanently mix allocations of different migratetypes within
the same region.

So, when allocating a region from the region allocator to the page allocator,
set the pageblock migratetype of all that memory to the migratetype for which
the page allocator requested memory.

Note that this still allows temporary sharing of pages between different
migratetypes; it just ensures that there is no *permanent* mixing of
migratetypes within a given memory region.

An important advantage to be noted here is that the region allocator doesn't
have to manage memory in a granularity lesser than a memory region, in *any*
situation. This is because the freepage migratetype and the fallback mechanism
allows temporary sharing of free memory between different migratetypes when
the system is short on memory, but eventually all the memory gets freed to
the original migratetype (because we set the pageblock migratetype of all the
freepages appropriately when allocating regions).

This greatly simplifies the design of the region allocator, since it doesn't
have to keep track of memory in smaller chunks than a memory region.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 mm/page_alloc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e303351..1312546 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1016,8 +1016,10 @@ static void __del_from_region_allocator(struct zone *zone, unsigned int order,
 	reg_area = &reg_alloc->region[region_id].region_area[order];
 	ralloc_list = &reg_area->list;
 
-	list_for_each_entry(page, ralloc_list, lru)
+	list_for_each_entry(page, ralloc_list, lru) {
 		set_freepage_migratetype(page, migratetype);
+		set_pageblock_migratetype(page, migratetype);
+	}
 
 	free_list = &zone->free_area[order].free_list[migratetype];
 

