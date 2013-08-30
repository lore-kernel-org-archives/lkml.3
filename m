Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab3H3NYn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 09:24:43 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:59833 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755798Ab3H3NYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 09:24:40 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [RFC PATCH v3 21/35] mm: Provide a mechanism to release free memory
 to the region allocator
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
Date: Fri, 30 Aug 2013 18:50:27 +0530
Message-ID: <20130830132015.4947.83016.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130830131221.4947.99764.stgit@srivatsabhat.in.ibm.com>
References: <20130830131221.4947.99764.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13083013-0320-0000-0000-000000D85654
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement helper functions to release freepages from the buddy freelists to
the region allocator.

For simplicity, all operations related to the region allocator are performed
at the granularity of entire memory regions. That is, when we release freepages
to the region allocator, we free all the pages belonging to that region.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 mm/page_alloc.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 5227ac3..d407caf 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -918,6 +918,26 @@ static void move_page_freelist(struct page *page, struct free_list *old_list,
 	add_to_freelist(page, new_list, order);
 }
 
+/* Add pages from the given buddy freelist to the region allocator */
+static void add_to_region_allocator(struct zone *z, struct free_list *free_list,
+				    int region_id)
+{
+	struct region_allocator *reg_alloc;
+	struct list_head *ralloc_list;
+	int order;
+
+	if (WARN_ON(list_empty(&free_list->list)))
+		return;
+
+	order = page_order(list_first_entry(&free_list->list,
+					    struct page, lru));
+
+	reg_alloc = &z->region_allocator;
+	ralloc_list = &reg_alloc->region[region_id].region_area[order].list;
+
+	del_from_freelist_bulk(ralloc_list, free_list, order, region_id);
+}
+
 /*
  * Freeing function for a buddy system allocator.
  *

