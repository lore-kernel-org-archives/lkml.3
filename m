Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbaHUOxI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 10:53:08 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:49403 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbaHUOxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 10:53:04 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Catalin Iacob <iacobcatalin@gmail.com>, Dave Jones <davej@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC PATCH 1/9] nohz: Restore NMI safe local irq work for local nohz kick
Date: Thu, 21 Aug 2014 16:52:49 +0200
Message-Id: <1408632777-3348-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1408632777-3348-1-git-send-email-fweisbec@gmail.com>
References: <1408632777-3348-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The local nohz kick is currently used by perf which needs it to be
NMI-safe. Recent commit though (7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9)
changed its implementation to fire the local kick using the remote kick
API. It was convenient to make the code more generic but the remote kick
isn't NMI-safe.

As a result:

	WARNING: CPU: 3 PID: 18062 at kernel/irq_work.c:72 irq_work_queue_on+0x11e/0x140()
	CPU: 3 PID: 18062 Comm: trinity-subchil Not tainted 3.16.0+ #34
	0000000000000009 00000000903774d1 ffff880244e06c00 ffffffff9a7f1e37
	0000000000000000 ffff880244e06c38 ffffffff9a0791dd ffff880244fce180
	0000000000000003 ffff880244e06d58 ffff880244e06ef8 0000000000000000
	Call Trace:
	<NMI>  [<ffffffff9a7f1e37>] dump_stack+0x4e/0x7a
	[<ffffffff9a0791dd>] warn_slowpath_common+0x7d/0xa0
	[<ffffffff9a07930a>] warn_slowpath_null+0x1a/0x20
	[<ffffffff9a17ca1e>] irq_work_queue_on+0x11e/0x140
	[<ffffffff9a10a2c7>] tick_nohz_full_kick_cpu+0x57/0x90
	[<ffffffff9a186cd5>] __perf_event_overflow+0x275/0x350
	[<ffffffff9a184f80>] ? perf_event_task_disable+0xa0/0xa0
	[<ffffffff9a01a4cf>] ? x86_perf_event_set_period+0xbf/0x150
	[<ffffffff9a187934>] perf_event_overflow+0x14/0x20
	[<ffffffff9a020386>] intel_pmu_handle_irq+0x206/0x410
	[<ffffffff9a0b54d3>] ? arch_vtime_task_switch+0x63/0x130
	[<ffffffff9a01937b>] perf_event_nmi_handler+0x2b/0x50
	[<ffffffff9a007b72>] nmi_handle+0xd2/0x390
	[<ffffffff9a007aa5>] ? nmi_handle+0x5/0x390
	[<ffffffff9a0d131b>] ? lock_release+0xab/0x330
	[<ffffffff9a008062>] default_do_nmi+0x72/0x1c0
	[<ffffffff9a0c925f>] ? cpuacct_account_field+0xcf/0x200
	[<ffffffff9a008268>] do_nmi+0xb8/0x100

Lets fix this by restoring the use of local irq work for the nohz local
kick.

Reported-by: Dave Jones <davej@redhat.com>
Cc: Catalin Iacob <iacobcatalin@gmail.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/tick.h     |  7 +------
 kernel/time/tick-sched.c | 14 ++++++++++++++
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index 0590523..9a82c7d 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -183,13 +183,8 @@ static inline bool tick_nohz_full_cpu(int cpu)
 
 extern void tick_nohz_init(void);
 extern void __tick_nohz_full_check(void);
+extern void tick_nohz_full_kick(void);
 extern void tick_nohz_full_kick_cpu(int cpu);
-
-static inline void tick_nohz_full_kick(void)
-{
-	tick_nohz_full_kick_cpu(smp_processor_id());
-}
-
 extern void tick_nohz_full_kick_all(void);
 extern void __tick_nohz_task_switch(struct task_struct *tsk);
 #else
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 99aa6ee..f654a8a 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -225,6 +225,20 @@ static DEFINE_PER_CPU(struct irq_work, nohz_full_kick_work) = {
 };
 
 /*
+ * Kick this CPU if it's full dynticks in order to force it to
+ * re-evaluate its dependency on the tick and restart it if necessary.
+ * This kick, unlike tick_nohz_full_kick_cpu() and tick_nohz_full_kick_all(),
+ * is NMI safe.
+ */
+void tick_nohz_full_kick(void)
+{
+	if (!tick_nohz_full_cpu(smp_processor_id()))
+		return;
+
+	irq_work_queue(&__get_cpu_var(nohz_full_kick_work));
+}
+
+/*
  * Kick the CPU if it's full dynticks in order to force it to
  * re-evaluate its dependency on the tick and restart it if necessary.
  */
-- 
1.8.3.1

