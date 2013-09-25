Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218Ab3IYXYT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 19:24:19 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:47697 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756205Ab3IYXYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 19:24:15 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [RFC PATCH v4 28/40] mm: Provide a mechanism to check if a given page
 is in the region allocator
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
Date: Thu, 26 Sep 2013 04:50:04 +0530
Message-ID: <20130925232002.26184.73188.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130925231250.26184.31438.stgit@srivatsabhat.in.ibm.com>
References: <20130925231250.26184.31438.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092523-9574-0000-0000-000009CD0C51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the introduction of the region allocator, a freepage can be either
in one of the buddy freelists or in the region allocator. In cases where we
want to move freepages to a given migratetype's freelists, we will need to
know where they were originally located. So provide a helper to distinguish
whether the freepage resides in the region allocator or the buddy freelists.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 mm/page_alloc.c |   31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ca7b959..ac04b45 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1048,6 +1048,37 @@ static int del_from_region_allocator(struct zone *zone, unsigned int order,
 }
 
 /*
+ * Return 1 if the page is in the region allocator, else return 0
+ * (which usually means that the page is in the buddy freelists).
+ */
+static int page_in_region_allocator(struct page *page)
+{
+	struct region_allocator *reg_alloc;
+	struct free_area_region *reg_area;
+	int order, region_id;
+
+	/* We keep only MAX_ORDER-1 pages in the region allocator */
+	order = page_order(page);
+	if (order != MAX_ORDER-1)
+		return 0;
+
+	/*
+	 * It is sufficient to check if (any of) the pages belonging to
+	 * that region are in the region allocator, because a page resides
+	 * in the region allocator if and only if all the pages of that
+	 * region are also in the region allocator.
+	 */
+	region_id = page_zone_region_id(page);
+	reg_alloc = &page_zone(page)->region_allocator;
+	reg_area = &reg_alloc->region[region_id].region_area[order];
+
+	if (reg_area->nr_free)
+		return 1;
+
+	return 0;
+}
+
+/*
  * Freeing function for a buddy system allocator.
  *
  * The concept of a buddy system is to maintain direct-mapped table

