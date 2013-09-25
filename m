Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756431Ab3IYX0c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 19:26:32 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:45100 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756411Ab3IYX01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 19:26:27 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [RFC PATCH v4 37/40] mm: Add a kthread to perform targeted compaction
 for memory power management
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
Date: Thu, 26 Sep 2013 04:52:10 +0530
Message-ID: <20130925232208.26184.58122.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130925231250.26184.31438.stgit@srivatsabhat.in.ibm.com>
References: <20130925231250.26184.31438.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092523-5140-0000-0000-000003E41930
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To further increase the opportunities for memory power savings, we can perform
targeted compaction to evacuate lightly-filled memory regions. For this
purpose, introduce a dedicated per-node kthread to perform the targeted
compaction work.

Our "kmempowerd" kthread uses the generic kthread-worker framework to do most
of the usual work all kthreads need to do. On top of that, this kthread has the
following infrastructure in place, to perform the region evacuation.

A work item is instantiated for every zone. Accessible to this work item is a
spin-lock protected bitmask, which helps us indicate which regions have to be
evacuated. The bits set in the bitmask represent the zone-memory-region number
within that zone that would benefit from evacuation.

The operation of the "kmempowerd" kthread is quite straight-forward: it makes a
local copy of the bitmask (which represents the work it is supposed to do), and
performs targeted region evacuation for each of the regions represented in
that bitmask. When its done, it updates the original bitmask by clearing those
bits, to indicate that the requested work was completed. While the kthread is
going about doing its duty, the original bitmask can be updated to indicate the
arrival of more work. So once the kthread finishes one round of processing, it
re-examines the original bitmask to see if any new work had arrived in the
meantime, and does the corresponding work if required. This process continues
until the original bitmask becomes empty (no bits set, so no more work to do).

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 include/linux/mmzone.h |   10 ++++++
 mm/compaction.c        |   80 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 90 insertions(+)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 49c8926..257afdf 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -10,6 +10,7 @@
 #include <linux/bitops.h>
 #include <linux/cache.h>
 #include <linux/threads.h>
+#include <linux/kthread-work.h>
 #include <linux/numa.h>
 #include <linux/init.h>
 #include <linux/seqlock.h>
@@ -128,6 +129,13 @@ struct region_allocator {
 	DECLARE_BITMAP(ralloc_mask, MAX_NR_ZONE_REGIONS);
 };
 
+struct mempower_work {
+	spinlock_t		lock;
+	DECLARE_BITMAP(mempower_mask, MAX_NR_ZONE_REGIONS);
+
+	struct kthread_work	work;
+};
+
 struct pglist_data;
 
 /*
@@ -460,6 +468,7 @@ struct zone {
 	 */
 	unsigned int inactive_ratio;
 
+	struct mempower_work	mempower_work;
 
 	ZONE_PADDING(_pad2_)
 	/* Rarely used or read-mostly fields */
@@ -830,6 +839,7 @@ typedef struct pglist_data {
 	struct task_struct *kswapd;	/* Protected by lock_memory_hotplug() */
 	int kswapd_max_order;
 	enum zone_type classzone_idx;
+	struct kthread_worker mempower_worker;
 #ifdef CONFIG_NUMA_BALANCING
 	/*
 	 * Lock serializing the per destination node AutoNUMA memory
diff --git a/mm/compaction.c b/mm/compaction.c
index 9449b7f..0511eae 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -16,6 +16,7 @@
 #include <linux/sysfs.h>
 #include <linux/balloon_compaction.h>
 #include <linux/page-isolation.h>
+#include <linux/kthread.h>
 #include "internal.h"
 
 #ifdef CONFIG_COMPACTION
@@ -1267,6 +1268,85 @@ int evacuate_mem_region(struct zone *z, struct zone_mem_region *zmr)
 	return compact_range(&cc, &ac, &fc, start_pfn, end_pfn);
 }
 
+#define nr_zone_region_bits	MAX_NR_ZONE_REGIONS
+static DECLARE_BITMAP(mpwork_mask, nr_zone_region_bits);
+
+static void kmempowerd(struct kthread_work *work)
+{
+	struct mempower_work *mpwork;
+	struct zone *zone;
+	unsigned long flags;
+	int region_id;
+
+	mpwork = container_of(work, struct mempower_work, work);
+	zone = container_of(mpwork, struct zone, mempower_work);
+
+	spin_lock_irqsave(&mpwork->lock, flags);
+repeat:
+	bitmap_copy(mpwork_mask, mpwork->mempower_mask, nr_zone_region_bits);
+	spin_unlock_irqrestore(&mpwork->lock, flags);
+
+	if (bitmap_empty(mpwork_mask, nr_zone_region_bits))
+		return;
+
+	for_each_set_bit(region_id, mpwork_mask, nr_zone_region_bits)
+		evacuate_mem_region(zone, &zone->zone_regions[region_id]);
+
+	spin_lock_irqsave(&mpwork->lock, flags);
+
+	bitmap_andnot(mpwork->mempower_mask, mpwork->mempower_mask, mpwork_mask,
+		      nr_zone_region_bits);
+	if (!bitmap_empty(mpwork->mempower_mask, nr_zone_region_bits))
+		goto repeat; /* More work got added in the meanwhile */
+
+	spin_unlock_irqrestore(&mpwork->lock, flags);
+
+}
+
+static void kmempowerd_run(int nid)
+{
+	struct kthread_worker *worker;
+	struct mempower_work *mpwork;
+	struct pglist_data *pgdat;
+	struct task_struct *task;
+	unsigned long flags;
+	int i;
+
+	pgdat = NODE_DATA(nid);
+	worker = &pgdat->mempower_worker;
+
+	init_kthread_worker(worker);
+
+	task = kthread_create_on_node(kthread_worker_fn, worker, nid,
+				      "kmempowerd/%d", nid);
+	if (IS_ERR(task))
+		return;
+
+	for (i = 0; i < pgdat->nr_zones; i++) {
+		mpwork = &pgdat->node_zones[i].mempower_work;
+		init_kthread_work(&mpwork->work, kmempowerd);
+
+		spin_lock_init(&mpwork->lock);
+
+		/* Initialize bitmap to zero to indicate no-pending-work */
+		spin_lock_irqsave(&mpwork->lock, flags);
+		bitmap_zero(mpwork->mempower_mask, nr_zone_region_bits);
+		spin_unlock_irqrestore(&mpwork->lock, flags);
+	}
+
+	wake_up_process(task);
+}
+
+int kmempowerd_init(void)
+{
+	int nid;
+
+	for_each_node_state(nid, N_MEMORY)
+		kmempowerd_run(nid);
+
+	return 0;
+}
+module_init(kmempowerd_init);
 
 /* Compact all zones within a node */
 static void __compact_pgdat(pg_data_t *pgdat, struct compact_control *cc)

