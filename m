Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755685AbaBUVN5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 16:13:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58994 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755639AbaBUVNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 16:13:54 -0500
Date: Fri, 21 Feb 2014 13:13:25 -0800
From: tip-bot for Stephane Eranian <tipbot@zytor.com>
Message-ID: <tip-001e413f7e7a4a68dc1c3231f72b5be173939c8f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1392132015-14521-6-git-send-email-eranian@google.com>
References: <1392132015-14521-6-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86/uncore: move uncore_event_to_box()
  and uncore_pmu_to_box()
Git-Commit-ID: 001e413f7e7a4a68dc1c3231f72b5be173939c8f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  001e413f7e7a4a68dc1c3231f72b5be173939c8f
Gitweb:     http://git.kernel.org/tip/001e413f7e7a4a68dc1c3231f72b5be173939c8f
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Tue, 11 Feb 2014 16:20:11 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 21 Feb 2014 21:49:07 +0100

perf/x86/uncore: move uncore_event_to_box() and uncore_pmu_to_box()

Move a couple of functions around to avoid forward declarations
when we add code later on.

Cc: mingo@elte.hu
Cc: acme@redhat.com
Cc: ak@linux.intel.com
Cc: zheng.z.yan@intel.com
Cc: peterz@infradead.org
Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1392132015-14521-6-git-send-email-eranian@google.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 72 +++++++++++++--------------
 1 file changed, 36 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index ea823b8..acbbdde 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -66,6 +66,42 @@ DEFINE_UNCORE_FORMAT_ATTR(mask_vnw, mask_vnw, "config2:3-4");
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
+	/*
+	 * perf core schedules event on the basis of cpu, uncore events are
+	 * collected by one of the cpus inside a physical package.
+	 */
+	return uncore_pmu_to_box(uncore_event_to_pmu(event), smp_processor_id());
+}
+
 static u64 uncore_msr_read_counter(struct intel_uncore_box *box, struct perf_event *event)
 {
 	u64 count;
@@ -2845,42 +2881,6 @@ static struct intel_uncore_box *uncore_alloc_box(struct intel_uncore_type *type,
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
