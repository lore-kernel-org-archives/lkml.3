Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643Ab3H3NWv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 09:22:51 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:53364 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756621Ab3H3NWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 09:22:48 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [RFC PATCH v3 16/35] mm: Enable per-memory-region fragmentation stats
 in pagetypeinfo
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
Date: Fri, 30 Aug 2013 18:48:46 +0530
Message-ID: <20130830131844.4947.32263.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130830131221.4947.99764.stgit@srivatsabhat.in.ibm.com>
References: <20130830131221.4947.99764.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13083013-1542-0000-0000-000000FD6C2A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pagetypeinfo is invaluable in observing the fragmentation of memory
into different migratetypes. Modify this code to also print out the
fragmentation statistics at a per-zone-memory-region granularity
(along with the existing per-zone reporting).

This helps us observe the effects of influencing memory allocation
decisions at the page-allocator level and understand the extent to
which they help in consolidation.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 mm/vmstat.c |   86 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 84 insertions(+), 2 deletions(-)

diff --git a/mm/vmstat.c b/mm/vmstat.c
index 4cba0da..924babc 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -887,6 +887,35 @@ static void pagetypeinfo_showfree_print(struct seq_file *m,
 	}
 }
 
+static void pagetypeinfo_showfree_region_print(struct seq_file *m,
+					       pg_data_t *pgdat,
+					       struct zone *zone)
+{
+	int order, mtype, i;
+
+	for (mtype = 0; mtype < MIGRATE_TYPES; mtype++) {
+
+		for (i = 0; i < zone->nr_zone_regions; i++) {
+			seq_printf(m, "Node %4d, zone %8s, R%3d %12s ",
+						pgdat->node_id,
+						zone->name,
+						i,
+						migratetype_names[mtype]);
+
+			for (order = 0; order < MAX_ORDER; ++order) {
+				struct free_area *area;
+
+				area = &(zone->free_area[order]);
+
+				seq_printf(m, "%6lu ",
+				   area->free_list[mtype].mr_list[i].nr_free);
+			}
+			seq_putc(m, '\n');
+		}
+
+	}
+}
+
 /* Print out the free pages at each order for each migatetype */
 static int pagetypeinfo_showfree(struct seq_file *m, void *arg)
 {
@@ -901,6 +930,11 @@ static int pagetypeinfo_showfree(struct seq_file *m, void *arg)
 
 	walk_zones_in_node(m, pgdat, pagetypeinfo_showfree_print);
 
+	seq_putc(m, '\n');
+
+	/* Print the free pages at each migratetype, per memory region */
+	walk_zones_in_node(m, pgdat, pagetypeinfo_showfree_region_print);
+
 	return 0;
 }
 
@@ -932,24 +966,72 @@ static void pagetypeinfo_showblockcount_print(struct seq_file *m,
 	}
 
 	/* Print counts */
-	seq_printf(m, "Node %d, zone %8s ", pgdat->node_id, zone->name);
+	seq_printf(m, "Node %d, zone %8s      ", pgdat->node_id, zone->name);
 	for (mtype = 0; mtype < MIGRATE_TYPES; mtype++)
 		seq_printf(m, "%12lu ", count[mtype]);
 	seq_putc(m, '\n');
 }
 
+static void pagetypeinfo_showblockcount_region_print(struct seq_file *m,
+					pg_data_t *pgdat, struct zone *zone)
+{
+	int mtype, i;
+	unsigned long pfn;
+	unsigned long start_pfn, end_pfn;
+	unsigned long count[MIGRATE_TYPES] = { 0, };
+
+	for (i = 0; i < zone->nr_zone_regions; i++) {
+		start_pfn = zone->zone_regions[i].start_pfn;
+		end_pfn = zone->zone_regions[i].end_pfn;
+
+		for (pfn = start_pfn; pfn < end_pfn;
+						pfn += pageblock_nr_pages) {
+			struct page *page;
+
+			if (!pfn_valid(pfn))
+				continue;
+
+			page = pfn_to_page(pfn);
+
+			/* Watch for unexpected holes punched in the memmap */
+			if (!memmap_valid_within(pfn, page, zone))
+				continue;
+
+			mtype = get_pageblock_migratetype(page);
+
+			if (mtype < MIGRATE_TYPES)
+				count[mtype]++;
+		}
+
+		/* Print counts */
+		seq_printf(m, "Node %d, zone %8s R%3d ", pgdat->node_id,
+			   zone->name, i);
+		for (mtype = 0; mtype < MIGRATE_TYPES; mtype++)
+			seq_printf(m, "%12lu ", count[mtype]);
+		seq_putc(m, '\n');
+
+		/* Reset the counters */
+		for (mtype = 0; mtype < MIGRATE_TYPES; mtype++)
+			count[mtype] = 0;
+	}
+}
+
 /* Print out the free pages at each order for each migratetype */
 static int pagetypeinfo_showblockcount(struct seq_file *m, void *arg)
 {
 	int mtype;
 	pg_data_t *pgdat = (pg_data_t *)arg;
 
-	seq_printf(m, "\n%-23s", "Number of blocks type ");
+	seq_printf(m, "\n%-23s", "Number of blocks type      ");
 	for (mtype = 0; mtype < MIGRATE_TYPES; mtype++)
 		seq_printf(m, "%12s ", migratetype_names[mtype]);
 	seq_putc(m, '\n');
 	walk_zones_in_node(m, pgdat, pagetypeinfo_showblockcount_print);
 
+	/* Print out the pageblock info for per memory region */
+	seq_putc(m, '\n');
+	walk_zones_in_node(m, pgdat, pagetypeinfo_showblockcount_region_print);
+
 	return 0;
 }
 

