Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410AbbATQ4W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 11:56:22 -0500
Received: from mga01.intel.com ([192.55.52.88]:27662 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754206AbbATQ4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 11:56:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,435,1418112000"; 
   d="scan'208";a="672897824"
From: kan.liang@intel.com
To: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org
Cc: ak@linux.intel.com, Kan Liang <kan.liang@intel.com>
Subject: [PATCH 1/1] perf/x86/intel/uncore: Move uncore_box_init out of  driver initialization
Date: Tue, 20 Jan 2015 04:54:25 +0000
Message-Id: <1421729665-5912-1-git-send-email-kan.liang@intel.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kan Liang <kan.liang@intel.com>

There were some issues about the uncore driver tried to access
non-existing boxes, which caused boot crashes. These issues have been
all fixed. But we should avoid boot failures if that ever happens again.

This patch intends to prevent this kind of potential issues. It moves
uncore_box_init out of driver initialization. The box will be
initialized when it's first enabled.

Signed-off-by: Kan Liang <kan.liang@intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |  9 ++-------
 arch/x86/kernel/cpu/perf_event_intel_uncore.h | 18 ++++++++++--------
 2 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 10b8d3e..c635b8b 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -840,7 +840,6 @@ static int uncore_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id
 	box->phys_id = phys_id;
 	box->pci_dev = pdev;
 	box->pmu = pmu;
-	uncore_box_init(box);
 	pci_set_drvdata(pdev, box);
 
 	raw_spin_lock(&uncore_box_lock);
@@ -1004,10 +1003,8 @@ static int uncore_cpu_starting(int cpu)
 			pmu = &type->pmus[j];
 			box = *per_cpu_ptr(pmu->box, cpu);
 			/* called by uncore_cpu_init? */
-			if (box && box->phys_id >= 0) {
-				uncore_box_init(box);
+			if (box && box->phys_id >= 0)
 				continue;
-			}
 
 			for_each_online_cpu(k) {
 				exist = *per_cpu_ptr(pmu->box, k);
@@ -1023,10 +1020,8 @@ static int uncore_cpu_starting(int cpu)
 				}
 			}
 
-			if (box) {
+			if (box)
 				box->phys_id = phys_id;
-				uncore_box_init(box);
-			}
 		}
 	}
 	return 0;
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.h b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
index 863d9b0..6c8c1e7 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.h
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
@@ -257,6 +257,14 @@ static inline int uncore_num_counters(struct intel_uncore_box *box)
 	return box->pmu->type->num_counters;
 }
 
+static inline void uncore_box_init(struct intel_uncore_box *box)
+{
+	if (!test_and_set_bit(UNCORE_BOX_FLAG_INITIATED, &box->flags)) {
+		if (box->pmu->type->ops->init_box)
+			box->pmu->type->ops->init_box(box);
+	}
+}
+
 static inline void uncore_disable_box(struct intel_uncore_box *box)
 {
 	if (box->pmu->type->ops->disable_box)
@@ -265,6 +273,8 @@ static inline void uncore_disable_box(struct intel_uncore_box *box)
 
 static inline void uncore_enable_box(struct intel_uncore_box *box)
 {
+	uncore_box_init(box);
+
 	if (box->pmu->type->ops->enable_box)
 		box->pmu->type->ops->enable_box(box);
 }
@@ -287,14 +297,6 @@ static inline u64 uncore_read_counter(struct intel_uncore_box *box,
 	return box->pmu->type->ops->read_counter(box, event);
 }
 
-static inline void uncore_box_init(struct intel_uncore_box *box)
-{
-	if (!test_and_set_bit(UNCORE_BOX_FLAG_INITIATED, &box->flags)) {
-		if (box->pmu->type->ops->init_box)
-			box->pmu->type->ops->init_box(box);
-	}
-}
-
 static inline bool uncore_box_is_fake(struct intel_uncore_box *box)
 {
 	return (box->phys_id < 0);
-- 
1.7.11.7

