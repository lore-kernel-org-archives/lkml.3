Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800Ab3IYXVF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 19:21:05 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:42004 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755200Ab3IYXVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 19:21:02 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [RFC PATCH v4 13/40] mm: Print memory region statistics to understand
 the buddy allocator behavior
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
Date: Thu, 26 Sep 2013 04:46:44 +0530
Message-ID: <20130925231642.26184.60271.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130925231250.26184.31438.stgit@srivatsabhat.in.ibm.com>
References: <20130925231250.26184.31438.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092523-1618-0000-0000-000004B0A15A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to observe the behavior of the region-aware buddy allocator, modify
vmstat.c to also print memory region related statistics. In particular, enable
memory region-related info in /proc/zoneinfo and /proc/buddyinfo, since they
would help us to atleast (roughly) observe how the new buddy allocator is
behaving.

For now, the region statistics correspond to the zone memory regions and not
the (absolute) node memory regions, and some of the statistics (especially the
no. of present pages) might not be very accurate. But since we account for
and print the free page statistics for every zone memory region accurately, we
should be able to observe the new page allocator behavior to a reasonable
degree of accuracy.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 mm/vmstat.c |   34 ++++++++++++++++++++++++++++++----
 1 file changed, 30 insertions(+), 4 deletions(-)

diff --git a/mm/vmstat.c b/mm/vmstat.c
index c967043..8e8c8bd 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -866,11 +866,28 @@ const char * const vmstat_text[] = {
 static void frag_show_print(struct seq_file *m, pg_data_t *pgdat,
 						struct zone *zone)
 {
-	int order;
+	int i, order, t;
+	struct free_area *area;
 
-	seq_printf(m, "Node %d, zone %8s ", pgdat->node_id, zone->name);
-	for (order = 0; order < MAX_ORDER; ++order)
-		seq_printf(m, "%6lu ", zone->free_area[order].nr_free);
+	seq_printf(m, "Node %d, zone %8s \n", pgdat->node_id, zone->name);
+
+	for (i = 0; i < zone->nr_zone_regions; i++) {
+
+		seq_printf(m, "\t\t Region %6d ", i);
+
+		for (order = 0; order < MAX_ORDER; ++order) {
+			unsigned long nr_free = 0;
+
+			area = &zone->free_area[order];
+
+			for (t = 0; t < MIGRATE_TYPES; t++) {
+				nr_free +=
+					area->free_list[t].mr_list[i].nr_free;
+			}
+			seq_printf(m, "%6lu ", nr_free);
+		}
+		seq_putc(m, '\n');
+	}
 	seq_putc(m, '\n');
 }
 
@@ -1057,6 +1074,15 @@ static void zoneinfo_show_print(struct seq_file *m, pg_data_t *pgdat,
 		   zone->present_pages,
 		   zone->managed_pages);
 
+	seq_printf(m, "\n\nPer-region page stats\t present\t free\n\n");
+	for (i = 0; i < zone->nr_zone_regions; i++) {
+		struct zone_mem_region *region;
+
+		region = &zone->zone_regions[i];
+		seq_printf(m, "\tRegion %6d \t %6lu \t %6lu\n", i,
+				region->present_pages, region->nr_free);
+	}
+
 	for (i = 0; i < NR_VM_ZONE_STAT_ITEMS; i++)
 		seq_printf(m, "\n    %-12s %lu", vmstat_text[i],
 				zone_page_state(zone, i));

