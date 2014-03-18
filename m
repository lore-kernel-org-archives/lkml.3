Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017AbaCRAGB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 20:06:01 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:53829 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841AbaCRAF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 20:05:59 -0400
From: minyard@acm.org
To: linux-kernel@vger.kernel.org
Cc: Corey Minyard <cminyard@mvista.com>
Subject: [PATCH] sched: Initialize rq->age_stamp on processor start
Date: Mon, 17 Mar 2014 19:05:49 -0500
Message-Id: <1395101149-10097-1-git-send-email-minyard@acm.org>
X-Mailer: git-send-email 1.8.3.1
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
index b46131e..5be3d4a 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5037,11 +5037,20 @@ static struct notifier_block migration_notifier = {
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
@@ -6922,6 +6931,7 @@ void __init sched_init(void)
 	init_sched_fair_class();
 
 	scheduler_running = 1;
+	set_cpu_rq_start_time();
 }
 
 #ifdef CONFIG_DEBUG_ATOMIC_SLEEP
-- 
1.8.3.1

