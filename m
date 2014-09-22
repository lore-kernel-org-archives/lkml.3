Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232AbaIVW1S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 18:27:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:12968 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755144AbaIVW1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 18:27:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,574,1406617200"; 
   d="scan'208";a="606818506"
From: Andi Kleen <andi@firstfloor.org>
To: peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, eranian@google.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] perf, x86, uncore: Fix minor race in box set up
Date: Mon, 22 Sep 2014 15:27:06 -0700
Message-Id: <1411424826-15629-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

I was looking for the trinity oops cause in the uncore driver.
(so far didn't found it)

However I found this tiny race: when a box is set up two threads on the
same CPU, they may be setting up the box in parallel (e.g. with kernel
preemption). This could lead to the reference count being increasing
too much. Always recheck there is no existing cpu reference inside the lock.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 812ec5d..76fa7e3 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -42,6 +42,9 @@ struct intel_uncore_box *uncore_pmu_to_box(struct intel_uncore_pmu *pmu, int cpu
 		return box;
 
 	raw_spin_lock(&uncore_box_lock);
+	/* Recheck in lock to handle races. */
+	if (*per_cpu_ptr(pmu->box, cpu))
+		goto out;
 	list_for_each_entry(box, &pmu->box_list, list) {
 		if (box->phys_id == topology_physical_package_id(cpu)) {
 			atomic_inc(&box->refcnt);
@@ -49,6 +52,7 @@ struct intel_uncore_box *uncore_pmu_to_box(struct intel_uncore_pmu *pmu, int cpu
 			break;
 		}
 	}
+out:
 	raw_spin_unlock(&uncore_box_lock);
 
 	return *per_cpu_ptr(pmu->box, cpu);
-- 
1.9.3

