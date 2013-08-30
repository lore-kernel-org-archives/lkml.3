Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436Ab3H3NV1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 09:21:27 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:35353 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756405Ab3H3NVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 09:21:24 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [RFC PATCH v3 10/35] mm: Use the correct migratetype during buddy
 merging
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
Date: Fri, 30 Aug 2013 18:46:56 +0530
Message-ID: <20130830131654.4947.85409.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130830131221.4947.99764.stgit@srivatsabhat.in.ibm.com>
References: <20130830131221.4947.99764.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13083013-5806-0000-0000-000022964B7B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While merging buddy free pages of a given order to make a higher order page,
the buddy allocator might coalesce pages belonging to *two* *different*
migratetypes of that order!

So, don't assume that both the buddies come from the same freelist;
instead, explicitly find out the migratetype info of the buddy page and use
it while merging the buddies.

Also, set the freepage migratetype of the buddy to the new one.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 mm/page_alloc.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b4b1275..07ac019 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -681,10 +681,14 @@ static inline void __free_one_page(struct page *page,
 			__mod_zone_freepage_state(zone, 1 << order,
 						  migratetype);
 		} else {
+			int mt;
+
 			area = &zone->free_area[order];
-			del_from_freelist(buddy, &area->free_list[migratetype]);
+			mt = get_freepage_migratetype(buddy);
+			del_from_freelist(buddy, &area->free_list[mt]);
 			area->nr_free--;
 			rmv_page_order(buddy);
+			set_freepage_migratetype(buddy, migratetype);
 		}
 		combined_idx = buddy_idx & page_idx;
 		page = page + (combined_idx - page_idx);

