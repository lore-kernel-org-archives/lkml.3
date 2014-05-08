Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488AbaEHSrv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 14:47:51 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:61820 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755467AbaEHSru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 14:47:50 -0400
From: minyard@acm.org
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Corey Minyard <cminyard@mvista.com>
Subject: [PATCH] sched: Initialize rq->age_stamp on processor start
Date: Thu,  8 May 2014 13:47:39 -0500
Message-Id: <1399574859-11714-1-git-send-email-minyard@acm.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20140508161337.GF30445@twins.programming.kicks-ass.net>
References: <20140508161337.GF30445@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Corey Minyard <cminyard@mvista.com>

If the sched_clock time starts at a large value, the kernel will spin
in sched_avg_update for a long time while rq->age_stamp catches up
with rq->clock.

The comment in kernel/sched/clock.c says that there is no strict promise
that it starts at zero.  So initialize rq->age_stamp when a cpu starts up
to avoid this.

I was seeing long delays on a simulator that didn't start the clock at
zero.  This might also be an issue on reboots on processors that don't
re-initialize the timer to zero on reset, and when using kexec.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
---
 kernel/sched/core.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 268a45e..80725c9 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5039,11 +5039,20 @@ static struct notifier_block migration_notifier = {
 	.priority = CPU_PRI_MIGRATION,
 };
 
+static void __cpuinit set_cpu_rq_start_time(void)
+{
+	int cpu = smp_processor_id();
+	struct rq *rq = cpu_rq(cpu);
+	rq->age_stamp = sched_clock_cpu(cpu);
+}
+
 static int sched_cpu_active(struct notifier_block *nfb,
 				      unsigned long action, void *hcpu)
 {
 	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_STARTING:
+		set_cpu_rq_start_time();
+		/* fall through */
 	case CPU_DOWN_FAILED:
 		set_cpu_active((long)hcpu, true);
 		return NOTIFY_OK;
@@ -6919,6 +6928,7 @@ void __init sched_init(void)
 	if (cpu_isolated_map == NULL)
 		zalloc_cpumask_var(&cpu_isolated_map, GFP_NOWAIT);
 	idle_thread_set_boot_cpu();
+	set_cpu_rq_start_time();
 #endif
 	init_sched_fair_class();
 
-- 
1.8.3.1

