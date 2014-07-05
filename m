Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965172AbaGEKoH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 06:44:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57922 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932549AbaGEKnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 06:43:49 -0400
Date: Sat, 5 Jul 2014 03:43:03 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-busatzs2gvz4v62258agipuf@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, swarren@wwwdotorg.org, hpa@zytor.com,
        mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org,
        srivatsa.bhat@linux.vnet.ibm.com, fweisbec@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, swarren@wwwdotorg.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        fweisbec@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] irq_work: Remove BUG_ON in irq_work_run()
Git-Commit-ID: a77353e5eb56b6c6098bfce59aff1f449451b0b7
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

Commit-ID:  a77353e5eb56b6c6098bfce59aff1f449451b0b7
Gitweb:     http://git.kernel.org/tip/a77353e5eb56b6c6098bfce59aff1f449451b0b7
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 25 Jun 2014 07:13:07 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 5 Jul 2014 11:17:26 +0200

irq_work: Remove BUG_ON in irq_work_run()

Because of a collision with 8d056c48e486 ("CPU hotplug, smp: flush any
pending IPI callbacks before CPU offline"), which ends up calling
hotplug_cfd()->flush_smp_call_function_queue()->irq_work_run(), which
is not from IRQ context.

And since that already calls irq_work_run() from the hotplug path,
remove our entire hotplug handling.

Reported-by: Stephen Warren <swarren@wwwdotorg.org>
Tested-by: Stephen Warren <swarren@wwwdotorg.org>
Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-busatzs2gvz4v62258agipuf@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/irq_work.c | 46 ++++------------------------------------------
 1 file changed, 4 insertions(+), 42 deletions(-)

diff --git a/kernel/irq_work.c b/kernel/irq_work.c
index 4b0a890..e6bcbe7 100644
--- a/kernel/irq_work.c
+++ b/kernel/irq_work.c
@@ -160,20 +160,14 @@ static void irq_work_run_list(struct llist_head *list)
 	}
 }
 
-static void __irq_work_run(void)
-{
-	irq_work_run_list(&__get_cpu_var(raised_list));
-	irq_work_run_list(&__get_cpu_var(lazy_list));
-}
-
 /*
- * Run the irq_work entries on this cpu. Requires to be ran from hardirq
- * context with local IRQs disabled.
+ * hotplug calls this through:
+ *  hotplug_cfd() -> flush_smp_call_function_queue()
  */
 void irq_work_run(void)
 {
-	BUG_ON(!in_irq());
-	__irq_work_run();
+	irq_work_run_list(&__get_cpu_var(raised_list));
+	irq_work_run_list(&__get_cpu_var(lazy_list));
 }
 EXPORT_SYMBOL_GPL(irq_work_run);
 
@@ -189,35 +183,3 @@ void irq_work_sync(struct irq_work *work)
 		cpu_relax();
 }
 EXPORT_SYMBOL_GPL(irq_work_sync);
-
-#ifdef CONFIG_HOTPLUG_CPU
-static int irq_work_cpu_notify(struct notifier_block *self,
-			       unsigned long action, void *hcpu)
-{
-	long cpu = (long)hcpu;
-
-	switch (action) {
-	case CPU_DYING:
-		/* Called from stop_machine */
-		if (WARN_ON_ONCE(cpu != smp_processor_id()))
-			break;
-		__irq_work_run();
-		break;
-	default:
-		break;
-	}
-	return NOTIFY_OK;
-}
-
-static struct notifier_block cpu_notify;
-
-static __init int irq_work_init_cpu_notifier(void)
-{
-	cpu_notify.notifier_call = irq_work_cpu_notify;
-	cpu_notify.priority = 0;
-	register_cpu_notifier(&cpu_notify);
-	return 0;
-}
-device_initcall(irq_work_init_cpu_notifier);
-
-#endif /* CONFIG_HOTPLUG_CPU */
