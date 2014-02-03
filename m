Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959AbaBCM6L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 07:58:11 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:56271 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbaBCM4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 07:56:24 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, acme@redhat.com, ak@linux.intel.com,
        zheng.z.yan@intel.com
Subject: [PATCH v1 06/10] perf/x86/uncore: move uncore_event_to_box() and uncore_pmu_to_box()
Date: Mon,  3 Feb 2014 13:55:38 +0100
Message-Id: <1391432142-18723-7-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1391432142-18723-1-git-send-email-eranian@google.com>
References: <1391432142-18723-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move a couple of functions around to avoid forward declarations
when we add code later on.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |   73 +++++++++++++------------
 1 file changed, 37 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index ea823b8..2980994c 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -66,6 +66,43 @@ DEFINE_UNCORE_FORMAT_ATTR(mask_vnw, mask_vnw, "config2:3-4");
 DEFINE_UNCORE_FORMAT_ATTR(mask0, mask0, "config2:0-31");
 DEFINE_UNCORE_FORMAT_ATTR(mask1, mask1, "config2:32-63");
 
+static struct intel_uncore_pmu *uncore_event_to_pmu(struct perf_event *event)
+{
+	return container_of(event->pmu, struct intel_uncore_pmu, pmu);
+}
+
+static struct intel_uncore_box *
+uncore_pmu_to_box(struct intel_uncore_pmu *pmu, int cpu)
+{
+	struct intel_uncore_box *box;
+
+	box = *per_cpu_ptr(pmu->box, cpu);
+	if (box)
+		return box;
+
+	raw_spin_lock(&uncore_box_lock);
+	list_for_each_entry(box, &pmu->box_list, list) {
+		if (box->phys_id == topology_physical_package_id(cpu)) {
+			atomic_inc(&box->refcnt);
+			*per_cpu_ptr(pmu->box, cpu) = box;
+			break;
+		}
+	}
+	raw_spin_unlock(&uncore_box_lock);
+
+	return *per_cpu_ptr(pmu->box, cpu);
+}
+
+static struct intel_uncore_box *uncore_event_to_box(struct perf_event *event)
+{
+	int cpu = smp_processor_id();
+	/*
+	 * perf core schedules event on the basis of cpu, uncore events are
+	 * collected by one of the cpus inside a physical package.
+	 */
+	return uncore_pmu_to_box(uncore_event_to_pmu(event), cpu);
+}
+
 static u64 uncore_msr_read_counter(struct intel_uncore_box *box, struct perf_event *event)
 {
 	u64 count;
@@ -2845,42 +2882,6 @@ static struct intel_uncore_box *uncore_alloc_box(struct intel_uncore_type *type,
 	return box;
 }
 
-static struct intel_uncore_box *
-uncore_pmu_to_box(struct intel_uncore_pmu *pmu, int cpu)
-{
-	struct intel_uncore_box *box;
-
-	box = *per_cpu_ptr(pmu->box, cpu);
-	if (box)
-		return box;
-
-	raw_spin_lock(&uncore_box_lock);
-	list_for_each_entry(box, &pmu->box_list, list) {
-		if (box->phys_id == topology_physical_package_id(cpu)) {
-			atomic_inc(&box->refcnt);
-			*per_cpu_ptr(pmu->box, cpu) = box;
-			break;
-		}
-	}
-	raw_spin_unlock(&uncore_box_lock);
-
-	return *per_cpu_ptr(pmu->box, cpu);
-}
-
-static struct intel_uncore_pmu *uncore_event_to_pmu(struct perf_event *event)
-{
-	return container_of(event->pmu, struct intel_uncore_pmu, pmu);
-}
-
-static struct intel_uncore_box *uncore_event_to_box(struct perf_event *event)
-{
-	/*
-	 * perf core schedules event on the basis of cpu, uncore events are
-	 * collected by one of the cpus inside a physical package.
-	 */
-	return uncore_pmu_to_box(uncore_event_to_pmu(event), smp_processor_id());
-}
-
 static int
 uncore_collect_events(struct intel_uncore_box *box, struct perf_event *leader, bool dogrp)
 {
-- 
1.7.9.5

