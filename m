Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129AbaKGQ3P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 11:29:15 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48325 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752627AbaKGQ1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 11:27:33 -0500
From: Mark Rutland <mark.rutland@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will.deacon@arm.com,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 04/11] arm: perf: filter unschedulable events
Date: Fri,  7 Nov 2014 16:25:29 +0000
Message-Id: <1415377536-12841-5-git-send-email-mark.rutland@arm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415377536-12841-1-git-send-email-mark.rutland@arm.com>
References: <1415377536-12841-1-git-send-email-mark.rutland@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Different CPU microarchitectures implement different PMU events, and
thus events which can be scheduled on one microarchitecture cannot be
scheduled on another, and vice-versa. Some archicted events behave
differently across microarchitectures, and thus cannot be meaningfully
summed. Due to this, we reject the scheduling of an event on a CPU of a
different microarchitecture to that the event targets.

When the core perf code is scheduling events and encounters an event
which cannot be scheduled, it stops attempting to schedule events. As
the perf core periodically rotates the list of events, for some
proportion of the time events which are unschedulable will block events
which are schedulable, resulting in low utilisation of the hardware
counters.

This patch implements a pmu::filter_match callback such that we can
detect and skip such events while scheduling early, before they can
block the schedulable events. This prevents the low HW counter
utilisation issue.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
---
 arch/arm/kernel/perf_event.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index 9ad21ab..b00f6aa 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -509,6 +509,18 @@ static void armpmu_disable(struct pmu *pmu)
 	armpmu->stop(armpmu);
 }
 
+/*
+ * In heterogeneous systems, events are specific to a particular
+ * microarchitecture, and aren't suitable for another. Thus, only match CPUs of
+ * the same microarchitecture.
+ */
+static int armpmu_filter_match(struct perf_event *event)
+{
+	struct arm_pmu *armpmu = to_arm_pmu(event->pmu);
+	unsigned int cpu = smp_processor_id();
+	return cpumask_test_cpu(cpu, &armpmu->supported_cpus);
+}
+
 #ifdef CONFIG_PM_RUNTIME
 static int armpmu_runtime_resume(struct device *dev)
 {
@@ -549,6 +561,7 @@ static void armpmu_init(struct arm_pmu *armpmu)
 		.start		= armpmu_start,
 		.stop		= armpmu_stop,
 		.read		= armpmu_read,
+		.filter_match	= armpmu_filter_match,
 	};
 }
 
-- 
1.9.1

