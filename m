Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583AbaDUKCN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 06:02:13 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:42314 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbaDUJ4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 05:56:06 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linaro-networking@linaro.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 07/19] tick: initialize variables during their definitions
Date: Mon, 21 Apr 2014 15:25:03 +0530
Message-Id: <a3975b7cca0d349235f0947684b02816abdd12b0.1398072824.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1398072824.git.viresh.kumar@linaro.org>
References: <cover.1398072824.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1398072824.git.viresh.kumar@linaro.org>
References: <cover.1398072824.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't have to assign values to variables in separate lines when we can do
that during their initialization. Move assignments of few variables to their
definitions. This makes code smaller and more readable.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/time/tick-broadcast.c | 20 ++++++--------------
 kernel/time/tick-common.c    | 10 +++-------
 kernel/time/tick-sched.c     |  6 ++----
 3 files changed, 11 insertions(+), 25 deletions(-)

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index bf289cd..7802020 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -329,16 +329,12 @@ unlock:
  */
 static void tick_do_broadcast_on_off(unsigned long *reason)
 {
-	struct clock_event_device *bc, *dev;
-	struct tick_device *td;
+	struct tick_device *td = tick_get_cpu_device();
+	struct clock_event_device *bc, *dev = td->evtdev;
+	int cpu = smp_processor_id(), bc_stopped;
 	unsigned long flags;
-	int cpu, bc_stopped;
 
 	raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
-
-	cpu = smp_processor_id();
-	td = tick_get_cpu_device();
-	dev = td->evtdev;
 	bc = tick_broadcast_device.evtdev;
 
 	/*
@@ -682,11 +678,11 @@ static void broadcast_move_bc(int deadcpu)
  */
 int tick_broadcast_oneshot_control(unsigned long reason)
 {
-	struct clock_event_device *bc, *dev;
-	struct tick_device *td;
+	struct tick_device *td = tick_get_cpu_device();
+	struct clock_event_device *bc, *dev = td->evtdev;
+	int cpu = smp_processor_id(), ret = 0;
 	unsigned long flags;
 	ktime_t now;
-	int cpu, ret = 0;
 
 	/*
 	 * Periodic mode does not care about the enter/exit of power
@@ -699,10 +695,6 @@ int tick_broadcast_oneshot_control(unsigned long reason)
 	 * We are called with preemtion disabled from the depth of the
 	 * idle code, so we can't be moved away.
 	 */
-	cpu = smp_processor_id();
-	td = tick_get_cpu_device();
-	dev = td->evtdev;
-
 	if (!(dev->features & CLOCK_EVT_FEAT_C3STOP))
 		return 0;
 
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 1e2c96e..4d45e08 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -283,17 +283,13 @@ bool tick_check_replacement(struct clock_event_device *curdev,
  */
 void tick_check_new_device(struct clock_event_device *newdev)
 {
-	struct clock_event_device *curdev;
-	struct tick_device *td;
-	int cpu;
+	struct tick_device *td = tick_get_cpu_device();
+	struct clock_event_device *curdev = td->evtdev;
+	int cpu = smp_processor_id();
 
-	cpu = smp_processor_id();
 	if (!cpumask_test_cpu(cpu, newdev->cpumask))
 		goto out_bc;
 
-	td = tick_get_cpu_device();
-	curdev = td->evtdev;
-
 	/* cpu local device ? */
 	if (!tick_check_percpu(curdev, newdev, cpu))
 		goto out_bc;
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 5f27c71..71f64ee 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -277,7 +277,7 @@ out:
 /* Parse the boot-time nohz CPU list from the kernel parameters. */
 static int __init tick_nohz_full_setup(char *str)
 {
-	int cpu;
+	int cpu = smp_processor_id();
 
 	alloc_bootmem_cpumask_var(&tick_nohz_full_mask);
 	if (cpulist_parse(str, tick_nohz_full_mask) < 0) {
@@ -285,7 +285,6 @@ static int __init tick_nohz_full_setup(char *str)
 		return 1;
 	}
 
-	cpu = smp_processor_id();
 	if (cpumask_test_cpu(cpu, tick_nohz_full_mask)) {
 		pr_warning("NO_HZ: Clearing %d from nohz_full range for timekeeping\n",
 			   cpu);
@@ -790,7 +789,7 @@ static void __tick_nohz_idle_enter(struct tick_sched *ts)
  */
 void tick_nohz_idle_enter(void)
 {
-	struct tick_sched *ts;
+	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
 
 	WARN_ON_ONCE(irqs_disabled());
 
@@ -804,7 +803,6 @@ void tick_nohz_idle_enter(void)
 
 	local_irq_disable();
 
-	ts = &__get_cpu_var(tick_cpu_sched);
 	ts->inidle = 1;
 	__tick_nohz_idle_enter(ts);
 
-- 
1.7.12.rc2.18.g61b472e

