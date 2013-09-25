Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756467Ab3IYX0q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 19:26:46 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:45118 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756444Ab3IYX0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 19:26:44 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [RFC PATCH v4 38/40] mm: Add a mechanism to queue work to the
 kmempowerd kthread
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
Date: Thu, 26 Sep 2013 04:52:26 +0530
Message-ID: <20130925232224.26184.9597.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130925231250.26184.31438.stgit@srivatsabhat.in.ibm.com>
References: <20130925231250.26184.31438.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092523-5140-0000-0000-000003E4193E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have a dedicated kthread in place to perform targeted region
evacuation, add and export a mechanism to queue work to the kthread.

Adding work to kmempowerd is very simple: just set the bits corresponding
to the region numbers that we want to evacuate, and queue the work item
to the kthread.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 mm/compaction.c |   26 ++++++++++++++++++++++++++
 mm/internal.h   |    3 +++
 2 files changed, 29 insertions(+)

diff --git a/mm/compaction.c b/mm/compaction.c
index 0511eae..b56be89 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1271,6 +1271,32 @@ int evacuate_mem_region(struct zone *z, struct zone_mem_region *zmr)
 #define nr_zone_region_bits	MAX_NR_ZONE_REGIONS
 static DECLARE_BITMAP(mpwork_mask, nr_zone_region_bits);
 
+void queue_mempower_work(struct pglist_data *pgdat, struct zone *zone,
+			 int region_id)
+{
+	struct mempower_work *mpwork;
+	unsigned long flags;
+
+	mpwork = &zone->mempower_work;
+	spin_lock_irqsave(&mpwork->lock, flags);
+	set_bit(region_id, mpwork->mempower_mask);
+	spin_unlock_irqrestore(&mpwork->lock, flags);
+
+	/*
+	 * The kmempowerd kthread will never miss the work we assign it,
+	 * due to the way queue_kthread_work() and kthread_worker_fn()
+	 * synchronize with each other. If the work is currently executing,
+	 * it gets requeued; but if it is pending, the kthread will naturally
+	 * process it in the future. Eitherway, it will notice and process
+	 * all the work submitted to it, and won't prematurely go to sleep.
+	 *
+	 * Note: The bits set in the mempower_mask represent the actual
+	 * "work" for the kthread. The work-struct is just a container used
+	 * to communicate that work to the kthread.
+	 */
+	queue_kthread_work(&pgdat->mempower_worker, &mpwork->work);
+}
+
 static void kmempowerd(struct kthread_work *work)
 {
 	struct mempower_work *mpwork;
diff --git a/mm/internal.h b/mm/internal.h
index acb50f8..3fbc9f6 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -181,6 +181,9 @@ int compact_range(struct compact_control *cc, struct aggression_control *ac,
 		  struct free_page_control *fc, unsigned long start,
 		  unsigned long end);
 
+void queue_mempower_work(struct pglist_data *pgdat, struct zone *zone,
+			 int region_id);
+
 #endif
 
 /*

