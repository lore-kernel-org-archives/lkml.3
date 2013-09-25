Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996Ab3IYXWp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 19:22:45 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:41998 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228Ab3IYXWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 19:22:43 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [RFC PATCH v4 20/40] mm: Provide a mechanism to request free memory
 from the region allocator
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
Date: Thu, 26 Sep 2013 04:48:29 +0530
Message-ID: <20130925231828.26184.18736.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130925231250.26184.31438.stgit@srivatsabhat.in.ibm.com>
References: <20130925231250.26184.31438.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092523-2000-0000-0000-00000DDDF069
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement helper functions to request freepages from the region allocator
in order to add them to the buddy freelists.

For simplicity, all operations related to the region allocator are performed
at the granularity of entire memory regions. That is, when the buddy
allocator requests freepages from the region allocator, the latter picks a
free region and always allocates all the freepages belonging to that entire
region.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 mm/page_alloc.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c727bba..d71d671 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -939,6 +939,29 @@ static void add_to_region_allocator(struct zone *z, struct free_list *free_list,
 	del_from_freelist_bulk(ralloc_list, free_list, order, region_id);
 }
 
+/* Delete freepages from the region allocator and add them to buddy freelists */
+static int del_from_region_allocator(struct zone *zone, unsigned int order,
+				     int migratetype)
+{
+	struct region_allocator *reg_alloc;
+	struct list_head *ralloc_list;
+	struct free_list *free_list;
+	int next_region;
+
+	reg_alloc = &zone->region_allocator;
+
+	next_region = reg_alloc->next_region;
+	if (next_region < 0)
+		return -ENOMEM;
+
+	ralloc_list = &reg_alloc->region[next_region].region_area[order].list;
+	free_list = &zone->free_area[order].free_list[migratetype];
+
+	add_to_freelist_bulk(ralloc_list, free_list, order, next_region);
+
+	return 0;
+}
+
 /*
  * Freeing function for a buddy system allocator.
  *

