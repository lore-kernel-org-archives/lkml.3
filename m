Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327AbaBNUUX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 15:20:23 -0500
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:40276 "EHLO
	qmta05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753237AbaBNUUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 15:20:14 -0500
Message-Id: <20140214201907.125542389@linux.com>
Date: Fri, 14 Feb 2014 14:19:11 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH 30/48] x86: Change __get_cpu_var calls introduced in 3.14
References: <20140214201841.826179349@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=fix_rapl
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

More were added recently.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: x86@kernel.org
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/arch/x86/kernel/cpu/perf_event_intel_rapl.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/perf_event_intel_rapl.c	2014-02-03 13:36:13.429026651 -0600
+++ linux/arch/x86/kernel/cpu/perf_event_intel_rapl.c	2014-02-03 13:36:13.429026651 -0600
@@ -129,7 +129,7 @@
 	 * or use ldexp(count, -32).
 	 * Watts = Joules/Time delta
 	 */
-	return v << (32 - __get_cpu_var(rapl_pmu)->hw_unit);
+	return v << (32 - __this_cpu_read(rapl_pmu->hw_unit));
 }
 
 static u64 rapl_event_update(struct perf_event *event)
@@ -181,7 +181,7 @@
 
 static enum hrtimer_restart rapl_hrtimer_handle(struct hrtimer *hrtimer)
 {
-	struct rapl_pmu *pmu = __get_cpu_var(rapl_pmu);
+	struct rapl_pmu *pmu = __this_cpu_read(rapl_pmu);
 	struct perf_event *event;
 	unsigned long flags;
 
@@ -228,7 +228,7 @@
 
 static void rapl_pmu_event_start(struct perf_event *event, int mode)
 {
-	struct rapl_pmu *pmu = __get_cpu_var(rapl_pmu);
+	struct rapl_pmu *pmu = __this_cpu_read(rapl_pmu);
 	unsigned long flags;
 
 	spin_lock_irqsave(&pmu->lock, flags);
@@ -238,7 +238,7 @@
 
 static void rapl_pmu_event_stop(struct perf_event *event, int mode)
 {
-	struct rapl_pmu *pmu = __get_cpu_var(rapl_pmu);
+	struct rapl_pmu *pmu = __this_cpu_read(rapl_pmu);
 	struct hw_perf_event *hwc = &event->hw;
 	unsigned long flags;
 
@@ -272,7 +272,7 @@
 
 static int rapl_pmu_event_add(struct perf_event *event, int mode)
 {
-	struct rapl_pmu *pmu = __get_cpu_var(rapl_pmu);
+	struct rapl_pmu *pmu = __this_cpu_read(rapl_pmu);
 	struct hw_perf_event *hwc = &event->hw;
 	unsigned long flags;
 
@@ -662,7 +662,7 @@
 		return -1;
 	}
 
-	pmu = __get_cpu_var(rapl_pmu);
+	pmu = __this_cpu_read(rapl_pmu);
 
 	pr_info("RAPL PMU detected, hw unit 2^-%d Joules,"
 		" API unit is 2^-32 Joules,"
Index: linux/kernel/sched/deadline.c
===================================================================
--- linux.orig/kernel/sched/deadline.c	2014-02-03 13:36:13.429026651 -0600
+++ linux/kernel/sched/deadline.c	2014-02-03 13:36:13.429026651 -0600
@@ -1115,7 +1115,7 @@
 static int find_later_rq(struct task_struct *task)
 {
 	struct sched_domain *sd;
-	struct cpumask *later_mask = __get_cpu_var(local_cpu_mask_dl);
+	struct cpumask *later_mask = this_cpu_ptr(local_cpu_mask_dl);
 	int this_cpu = smp_processor_id();
 	int best_cpu, cpu = task_cpu(task);
 
Index: linux/kernel/time/tick-broadcast.c
===================================================================
--- linux.orig/kernel/time/tick-broadcast.c	2014-02-03 13:36:13.429026651 -0600
+++ linux/kernel/time/tick-broadcast.c	2014-02-03 13:36:13.429026651 -0600
@@ -541,7 +541,7 @@
 void tick_check_oneshot_broadcast_this_cpu(void)
 {
 	if (cpumask_test_cpu(smp_processor_id(), tick_broadcast_oneshot_mask)) {
-		struct tick_device *td = &__get_cpu_var(tick_cpu_device);
+		struct tick_device *td = this_cpu_ptr(&tick_cpu_device);
 
 		/*
 		 * We might be in the middle of switching over from

