Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175Ab3IYXX5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 19:23:57 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:41651 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215Ab3IYXXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 19:23:55 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [RFC PATCH v4 26/40] mm: Connect Page Allocator(PA) to Region
 Allocator(RA); add PA <= RA flow
To: akpm@linux-foundation.org, mgorman@suse.de, dave@sr71.net,
        hannes@cmpxchg.org, tony.luck@intel.com, matthew.garrett@nebula.com,
        riel@redhat.com, arjan@linux.intel.com,
        srinivas.pandruvada@linux.intel.com, willy@linux.intel.com,
        kamezawa.hiroyu@jp.fujitsu.com, lenb@kernel.org, rjw@sisk.pl
Cc: gargankita@gmail.com, paulmck@linux.vnet.ibm.com,
        svaidy@linux.vnet.ibm.com, andi@firstfloor.org,
        isimatu.yasuaki@jp.fujitsu.com, santosh.shilimkar@ti.com,
        kosaki.motohiro@gmail.com, srivatsa.bhat@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Date: Thu, 26 Sep 2013 04:49:41 +0530
Message-ID: <20130925231939.26184.88534.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130925231250.26184.31438.stgit@srivatsabhat.in.ibm.com>
References: <20130925231250.26184.31438.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092523-8878-0000-0000-000008FD521F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have built up an infrastructure that forms a "Memory Region
Allocator", connect it with the page allocator. To entities requesting
memory, the page allocator will function as a front-end, whereas the
region allocator will act as a back-end to the page allocator.
(Analogy: page allocator is like free cash, whereas region allocator
is like a bank).

Implement the flow of freepages from the region allocator to the page
allocator. When __rmqueue_smallest() comes out empty handed, try to get
freepages from the region allocator. If that fails, only then fallback
to an allocation from a different migratetype. This helps significantly
in avoiding mixing of allocations of different migratetypes in a single
region. Thus it helps in keeping entire memory regions homogeneous with
respect to the type of allocations.

Simplification: We assume that the freepages of a memory region can be
completely represented by a set of MAX_ORDER-1 pages. That is, we only
need to consider the buddy freelists corresponding to MAX_ORDER-1, while
interacting with the region allocator. Furthermore, we assume that
pageblock_order == MAX_ORDER-1.

(These assumptions are used to ease the implementation, so that one can
quickly evaluate the benefits of the overall design without getting
bogged down by too many corner cases and constraints. Of course future
implementations will handle more scenarios and will have reduced dependence
on such simplifying assumptions.)

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 mm/page_alloc.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d08bc91..0d73134 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1703,10 +1703,18 @@ static struct page *__rmqueue(struct zone *zone, unsigned int order,
 {
 	struct page *page;
 
-retry_reserve:
+retry:
 	page = __rmqueue_smallest(zone, order, migratetype);
 
 	if (unlikely(!page) && migratetype != MIGRATE_RESERVE) {
+
+		/*
+		 * Try to get a region from the region allocator before falling
+		 * back to an allocation from a different migratetype.
+		 */
+		if (!del_from_region_allocator(zone, MAX_ORDER-1, migratetype))
+			goto retry;
+
 		page = __rmqueue_fallback(zone, order, migratetype);
 
 		/*
@@ -1716,7 +1724,7 @@ retry_reserve:
 		 */
 		if (!page) {
 			migratetype = MIGRATE_RESERVE;
-			goto retry_reserve;
+			goto retry;
 		}
 	}
 

