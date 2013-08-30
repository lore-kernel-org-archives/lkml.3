Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894Ab3H3N1Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 09:27:24 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:52418 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756530Ab3H3N1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 09:27:21 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [RFC PATCH v3 29/35] mm: Update the freepage migratetype of pages
 during region allocation
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
Date: Fri, 30 Aug 2013 18:53:13 +0530
Message-ID: <20130830132311.4947.93530.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130830131221.4947.99764.stgit@srivatsabhat.in.ibm.com>
References: <20130830131221.4947.99764.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13083013-9332-0000-0000-00000141D914
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The freepage migratetype is used to determine which freelist a given
page should be added to, upon getting freed. To ensure that the page
goes to the right freelist, set the freepage migratetype of all
the pages of a region, when allocating freepages from the region allocator.

This helps ensure that upon freeing the pages or during buddy expansion,
the pages are added back to the freelists of the migratetype for which
the pages were originally requested from the region allocator.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 mm/page_alloc.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 3749e2a..a62730b 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1022,6 +1022,9 @@ static int del_from_region_allocator(struct zone *zone, unsigned int order,
 	reg_area = &reg_alloc->region[next_region].region_area[order];
 	ralloc_list = &reg_area->list;
 
+	list_for_each_entry(page, ralloc_list, lru)
+		set_freepage_migratetype(page, migratetype);
+
 	free_list = &zone->free_area[order].free_list[migratetype];
 
 	nr_pages = add_to_freelist_bulk(ralloc_list, free_list, order,

