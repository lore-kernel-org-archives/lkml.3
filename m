Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbaB0Lla (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 06:41:30 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:46165 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbaB0Ll1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 06:41:27 -0500
Date: Thu, 27 Feb 2014 17:02:27 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        josh@joshtriplett.org
Subject: [PATCH 07/46] kernel: Mark functions as static and remove unused
 function in events/core.c
Message-ID: <100ad46ac1a69a1604b0c810259c2a26cf79417d.1393493276.git.rashika.kheria@gmail.com>
References: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark functions as static in kernel/events/core.c because they are not
used outside this file. Also, remove unused function in
kernel/events/core.c.

This eliminates the following warning in kernel/events/core.c:
kernel/events/core.c:182:6: warning: no previous prototype for ‘update_perf_cpu_limits’ [-Wmissing-prototypes]
kernel/events/core.c:470:6: warning: no previous prototype for ‘perf_cgroup_switch’ [-Wmissing-prototypes]
kernel/events/core.c:781:6: warning: no previous prototype for ‘perf_cpu_hrtimer_cancel’ [-Wmissing-prototypes]
kernel/events/core.c:6574:13: warning: no previous prototype for ‘perf_init_event’ [-Wmissing-prototypes]
kernel/events/core.c:7707:5: warning: no previous prototype for ‘perf_event_init_context’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/events/core.c |   36 ++++--------------------------------
 1 file changed, 4 insertions(+), 32 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 56003c6..672e51f 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -179,7 +179,7 @@ static int perf_sample_period_ns __read_mostly	= DEFAULT_SAMPLE_PERIOD_NS;
 static int perf_sample_allowed_ns __read_mostly =
 	DEFAULT_SAMPLE_PERIOD_NS * DEFAULT_CPU_TIME_MAX_PERCENT / 100;
 
-void update_perf_cpu_limits(void)
+static void update_perf_cpu_limits(void)
 {
 	u64 tmp = perf_sample_period_ns;
 
@@ -467,7 +467,7 @@ perf_cgroup_set_timestamp(struct task_struct *task,
  * mode SWOUT : schedule out everything
  * mode SWIN : schedule in based on cgroup for next
  */
-void perf_cgroup_switch(struct task_struct *task, int mode)
+static void perf_cgroup_switch(struct task_struct *task, int mode)
 {
 	struct perf_cpu_context *cpuctx;
 	struct pmu *pmu;
@@ -777,34 +777,6 @@ static enum hrtimer_restart perf_cpu_hrtimer_handler(struct hrtimer *hr)
 	return ret;
 }
 
-/* CPU is going down */
-void perf_cpu_hrtimer_cancel(int cpu)
-{
-	struct perf_cpu_context *cpuctx;
-	struct pmu *pmu;
-	unsigned long flags;
-
-	if (WARN_ON(cpu != smp_processor_id()))
-		return;
-
-	local_irq_save(flags);
-
-	rcu_read_lock();
-
-	list_for_each_entry_rcu(pmu, &pmus, entry) {
-		cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
-
-		if (pmu->task_ctx_nr == perf_sw_context)
-			continue;
-
-		hrtimer_cancel(&cpuctx->hrtimer);
-	}
-
-	rcu_read_unlock();
-
-	local_irq_restore(flags);
-}
-
 static void __perf_cpu_hrtimer_init(struct perf_cpu_context *cpuctx, int cpu)
 {
 	struct hrtimer *hr = &cpuctx->hrtimer;
@@ -6571,7 +6543,7 @@ void perf_pmu_unregister(struct pmu *pmu)
 	free_pmu_context(pmu);
 }
 
-struct pmu *perf_init_event(struct perf_event *event)
+static struct pmu *perf_init_event(struct perf_event *event)
 {
 	struct pmu *pmu = NULL;
 	int idx;
@@ -7704,7 +7676,7 @@ inherit_task_group(struct perf_event *event, struct task_struct *parent,
 /*
  * Initialize the perf_event context in task_struct
  */
-int perf_event_init_context(struct task_struct *child, int ctxn)
+static int perf_event_init_context(struct task_struct *child, int ctxn)
 {
 	struct perf_event_context *child_ctx, *parent_ctx;
 	struct perf_event_context *cloned_ctx;
-- 
1.7.9.5

