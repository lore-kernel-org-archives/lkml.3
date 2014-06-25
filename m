Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995AbaFYKTZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 06:19:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:57608 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755904AbaFYKTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 06:19:22 -0400
Date: Wed, 25 Jun 2014 12:19:15 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Subject: Re: [PATCH 2/6] irq_work: Implement remote queueing
Message-ID: <20140625101915.GO19860@laptop.programming.kicks-ass.net>
References: <1402413309-3415-1-git-send-email-fweisbec@gmail.com>
 <1402413309-3415-3-git-send-email-fweisbec@gmail.com>
 <53A9E0A5.5040402@wwwdotorg.org>
 <20140625051234.GD6758@twins.programming.kicks-ass.net>
 <20140625051721.GG3588@twins.programming.kicks-ass.net>
 <53AA6E11.1000404@linux.vnet.ibm.com>
 <20140625093657.GN19860@laptop.programming.kicks-ass.net>
 <20140625093944.GV16155@laptop.programming.kicks-ass.net>
 <53AA9B68.4050104@linux.vnet.ibm.com>
 <53AA9C43.3020903@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53AA9C43.3020903@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 03:24:11PM +0530, Srivatsa S. Bhat wrote:
> Wait, that was a stupid idea. hotplug_cfd() already invokes irq_work_run
> indirectly via flush_smp_call_function_queue(). So irq_work_cpu_notify()
> doesn't need to invoke it again, AFAIU. So perhaps we can get rid of
> irq_work_cpu_notify() altogether?

Just so...

getting up at 6am and sitting in an airport terminal doesn't seem to
agree with me; any more silly fail here?

---
Subject: irq_work: Remove BUG_ON in irq_work_run()
From: Peter Zijlstra <peterz@infradead.org>
Date: Wed Jun 25 07:13:07 CEST 2014

Because of a collision with 8d056c48e486 ("CPU hotplug, smp: flush any
pending IPI callbacks before CPU offline"), which ends up calling
hotplug_cfd()->flush_smp_call_function_queue()->irq_work_run(), which
is not from IRQ context.

And since that already calls irq_work_run() from the hotplug path,
remove our entire hotplug handling.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Reported-by: Stephen Warren <swarren@wwwdotorg.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-busatzs2gvz4v62258agipuf@git.kernel.org
---
 kernel/irq_work.c |   48 +++++-------------------------------------------
 1 file changed, 5 insertions(+), 43 deletions(-)

Index: linux-2.6/kernel/irq_work.c
===================================================================
--- linux-2.6.orig/kernel/irq_work.c
+++ linux-2.6/kernel/irq_work.c
@@ -160,20 +160,14 @@ static void irq_work_run_list(struct lli
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
+ *  hotplug_cfs() -> flush_smp_call_function_queue()
  */
-void irq_work_run(void)
+static void irq_work_run(void)
 {
-	BUG_ON(!in_irq());
-	__irq_work_run();
+	irq_work_run_list(&__get_cpu_var(raised_list));
+	irq_work_run_list(&__get_cpu_var(lazy_list));
 }
 EXPORT_SYMBOL_GPL(irq_work_run);
 
@@ -189,35 +183,3 @@ void irq_work_sync(struct irq_work *work
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
