Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbaIDXIn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 19:08:43 -0400
Received: from mga14.intel.com ([192.55.52.115]:36754 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793AbaIDXIm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 19:08:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="381653674"
From: Andi Kleen <andi@firstfloor.org>
To: peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, eranian@google.com,
        tglx@linutronix.de, "Yan, Zheng" <zheng.z.yan@intel.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 3/5] perf, x86, uncore: Register the PMU only if the uncore pci device exists
Date: Thu,  4 Sep 2014 16:08:27 -0700
Message-Id: <1409872109-31645-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409872109-31645-1-git-send-email-andi@firstfloor.org>
References: <1409872109-31645-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yan, Zheng" <zheng.z.yan@intel.com>

Current code registers PMUs for all possible uncore pci devices.
This is not good because, on some machines, one or more uncore pci
devices can be missing. The missing pci device make corresponding
PMU unusable. Register the PMU only if the uncore device exists.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 2b0fa02..42d00e5 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -793,6 +793,7 @@ static int uncore_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id
 	struct intel_uncore_box *box;
 	struct intel_uncore_type *type;
 	int phys_id;
+	bool first_box = false;
 
 	phys_id = uncore_pcibus_to_physid[pdev->bus->number];
 	if (phys_id < 0)
@@ -827,9 +828,13 @@ static int uncore_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id
 	pci_set_drvdata(pdev, box);
 
 	raw_spin_lock(&uncore_box_lock);
+	if (list_empty(&pmu->box_list))
+		first_box = true;
 	list_add_tail(&box->list, &pmu->box_list);
 	raw_spin_unlock(&uncore_box_lock);
 
+	if (first_box)
+		uncore_pmu_register(pmu);
 	return 0;
 }
 
@@ -838,6 +843,7 @@ static void uncore_pci_remove(struct pci_dev *pdev)
 	struct intel_uncore_box *box = pci_get_drvdata(pdev);
 	struct intel_uncore_pmu *pmu;
 	int i, cpu, phys_id = uncore_pcibus_to_physid[pdev->bus->number];
+	bool last_box = false;
 
 	box = pci_get_drvdata(pdev);
 	if (!box) {
@@ -859,6 +865,8 @@ static void uncore_pci_remove(struct pci_dev *pdev)
 
 	raw_spin_lock(&uncore_box_lock);
 	list_del(&box->list);
+	if (list_empty(&pmu->box_list))
+		last_box = true;
 	raw_spin_unlock(&uncore_box_lock);
 
 	for_each_possible_cpu(cpu) {
@@ -870,6 +878,9 @@ static void uncore_pci_remove(struct pci_dev *pdev)
 
 	WARN_ON_ONCE(atomic_read(&box->refcnt) != 1);
 	kfree(box);
+
+	if (last_box)
+		perf_pmu_unregister(&pmu->pmu);
 }
 
 static int __init uncore_pci_init(void)
@@ -1221,14 +1232,6 @@ static int __init uncore_pmus_register(void)
 		}
 	}
 
-	for (i = 0; uncore_pci_uncores[i]; i++) {
-		type = uncore_pci_uncores[i];
-		for (j = 0; j < type->num_boxes; j++) {
-			pmu = &type->pmus[j];
-			uncore_pmu_register(pmu);
-		}
-	}
-
 	return 0;
 }
 
-- 
1.9.3

