Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825AbaESNLJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 09:11:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59460 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754670AbaESNLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 09:11:06 -0400
Date: Mon, 19 May 2014 06:10:02 -0700
From: tip-bot for Corey Minyard <tipbot@zytor.com>
Message-ID: <tip-6cfa0c323ca96b7f619932725bfc0de1e4a484fc@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de,
        cminyard@mvista.com
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de,
        cminyard@mvista.com
In-Reply-To: <1399574859-11714-1-git-send-email-minyard@acm.org>
References: <1399574859-11714-1-git-send-email-minyard@acm.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Initialize rq->
 age_stamp on processor start
Git-Commit-ID: 6cfa0c323ca96b7f619932725bfc0de1e4a484fc
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

Commit-ID:  6cfa0c323ca96b7f619932725bfc0de1e4a484fc
Gitweb:     http://git.kernel.org/tip/6cfa0c323ca96b7f619932725bfc0de1e4a484fc
Author:     Corey Minyard <cminyard@mvista.com>
AuthorDate: Thu, 8 May 2014 13:47:39 -0500
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 19 May 2014 22:02:41 +0900

sched: Initialize rq->age_stamp on processor start

If the sched_clock time starts at a large value, the kernel will spin
in sched_avg_update for a long time while rq->age_stamp catches up
with rq->clock.

The comment in kernel/sched/clock.c says that there is no strict promise
that it starts at zero.  So initialize rq->age_stamp when a cpu starts up
to avoid this.

I was seeing long delays on a simulator that didn't start the clock at
zero.  This might also be an issue on reboots on processors that don't
re-initialize the timer to zero on reset, and when using kexec.

Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1399574859-11714-1-git-send-email-minyard@acm.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched/core.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 10d9b50..c134eb0 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5089,10 +5089,20 @@ static struct notifier_block migration_notifier = {
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
+	case CPU_STARTING:
+		set_cpu_rq_start_time();
+		return NOTIFY_OK;
 	case CPU_DOWN_FAILED:
 		set_cpu_active((long)hcpu, true);
 		return NOTIFY_OK;
@@ -6970,6 +6980,7 @@ void __init sched_init(void)
 	if (cpu_isolated_map == NULL)
 		zalloc_cpumask_var(&cpu_isolated_map, GFP_NOWAIT);
 	idle_thread_set_boot_cpu();
+	set_cpu_rq_start_time();
 #endif
 	init_sched_fair_class();
 
