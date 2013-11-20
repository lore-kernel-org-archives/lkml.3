Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749Ab3KTRYf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 12:24:35 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48137 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424Ab3KTRYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 12:24:33 -0500
Date: Wed, 20 Nov 2013 18:24:24 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>, lenb@kernel.org,
        rjw@rjwysocki.net, Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        Chris Leech <christopher.leech@intel.com>,
        David Miller <davem@davemloft.net>, rui.zhang@intel.com,
        Mike Galbraith <bitbucket@online.de>, Ingo Molnar <mingo@kernel.org>,
        hpa@zytor.com, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH 0/7] Cure some vaux idle wrackage
Message-ID: <20131120172424.GV16796@laptop.programming.kicks-ass.net>
References: <20131120160450.072555619@infradead.org>
 <20131120163453.GS10022@twins.programming.kicks-ass.net>
 <20131120091921.2da67ff3@ultegra>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131120091921.2da67ff3@ultegra>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 09:19:21AM -0800, Jacob Pan wrote:
> Hi Peter,
> I cannot cleanly apply the patch set on upstream kernel. Failed on
> Subject: [PATCH 4/7] preempt, locking: Rework local_bh_{dis,en}able()
> 
> Can you tell me which commit id should I do git am?

Oh, I wrote them against tip/master. Although I don't suppose there's
much in tip/master that's not (yet) in Linus' tree, so I suppose the
conflict should be an easy one.

I suppose the patch giving you grief is the one below.

---
commit f1a83e652bedef88d6d77d3dc58250e08e7062bd
Author: Peter Zijlstra <peterz@infradead.org>
Date:   Tue Nov 19 16:42:47 2013 +0100

    lockdep: Correctly annotate hardirq context in irq_exit()
    
    There was a reported deadlock on -rt which lockdep didn't report.
    
    It turns out that in irq_exit() we tell lockdep that the hardirq
    context ends and then do all kinds of locking afterwards.
    
    To fix it, move trace_hardirq_exit() to the very end of irq_exit(), this
    ensures all locking in tick_irq_exit() and rcu_irq_exit() are properly
    recorded as happening from hardirq context.
    
    This however leads to the 'fun' little problem of running softirqs
    while in hardirq context. To cure this make the softirq code a little
    more complex (in the CONFIG_TRACE_IRQFLAGS case).
    
    Due to stack swizzling arch dependent trickery we cannot pass an
    argument to __do_softirq() to tell it if it was done from hardirq
    context or not; so use a side-band argument.
    
    When we do __do_softirq() from hardirq context, 'atomically' flip to
    softirq context and back, so that no locking goes without being in
    either hard- or soft-irq context.
    
    I didn't find any new problems in mainline using this patch, but it
    did show the -rt problem.
    
    Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    Cc: Frederic Weisbecker <fweisbec@gmail.com>
    Cc: Linus Torvalds <torvalds@linux-foundation.org>
    Cc: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Peter Zijlstra <peterz@infradead.org>
    Link: http://lkml.kernel.org/n/tip-dgwc5cdksbn0jk09vbmcc9sa@git.kernel.org
    Signed-off-by: Ingo Molnar <mingo@kernel.org>

diff --git a/kernel/softirq.c b/kernel/softirq.c
index b24988353458..eb0acf44b063 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -213,14 +213,52 @@ EXPORT_SYMBOL(local_bh_enable_ip);
 #define MAX_SOFTIRQ_TIME  msecs_to_jiffies(2)
 #define MAX_SOFTIRQ_RESTART 10
 
+#ifdef CONFIG_TRACE_IRQFLAGS
+/*
+ * Convoluted means of passing __do_softirq() a message through the various
+ * architecture execute_on_stack() bits.
+ *
+ * When we run softirqs from irq_exit() and thus on the hardirq stack we need
+ * to keep the lockdep irq context tracking as tight as possible in order to
+ * not miss-qualify lock contexts and miss possible deadlocks.
+ */
+static DEFINE_PER_CPU(int, softirq_from_hardirq);
+
+static inline void lockdep_softirq_from_hardirq(void)
+{
+	this_cpu_write(softirq_from_hardirq, 1);
+}
+
+static inline void lockdep_softirq_start(void)
+{
+	if (this_cpu_read(softirq_from_hardirq))
+		trace_hardirq_exit();
+	lockdep_softirq_enter();
+}
+
+static inline void lockdep_softirq_end(void)
+{
+	lockdep_softirq_exit();
+	if (this_cpu_read(softirq_from_hardirq)) {
+		this_cpu_write(softirq_from_hardirq, 0);
+		trace_hardirq_enter();
+	}
+}
+
+#else
+static inline void lockdep_softirq_from_hardirq(void) { }
+static inline void lockdep_softirq_start(void) { }
+static inline void lockdep_softirq_end(void) { }
+#endif
+
 asmlinkage void __do_softirq(void)
 {
-	struct softirq_action *h;
-	__u32 pending;
 	unsigned long end = jiffies + MAX_SOFTIRQ_TIME;
-	int cpu;
 	unsigned long old_flags = current->flags;
 	int max_restart = MAX_SOFTIRQ_RESTART;
+	struct softirq_action *h;
+	__u32 pending;
+	int cpu;
 
 	/*
 	 * Mask out PF_MEMALLOC s current task context is borrowed for the
@@ -233,7 +271,7 @@ asmlinkage void __do_softirq(void)
 	account_irq_enter_time(current);
 
 	__local_bh_disable(_RET_IP_, SOFTIRQ_OFFSET);
-	lockdep_softirq_enter();
+	lockdep_softirq_start();
 
 	cpu = smp_processor_id();
 restart:
@@ -280,16 +318,13 @@ asmlinkage void __do_softirq(void)
 		wakeup_softirqd();
 	}
 
-	lockdep_softirq_exit();
-
+	lockdep_softirq_end();
 	account_irq_exit_time(current);
 	__local_bh_enable(SOFTIRQ_OFFSET);
 	WARN_ON_ONCE(in_interrupt());
 	tsk_restore_flags(current, old_flags, PF_MEMALLOC);
 }
 
-
-
 asmlinkage void do_softirq(void)
 {
 	__u32 pending;
@@ -332,6 +367,7 @@ void irq_enter(void)
 static inline void invoke_softirq(void)
 {
 	if (!force_irqthreads) {
+		lockdep_softirq_from_hardirq();
 #ifdef CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK
 		/*
 		 * We can safely execute softirq on the current stack if
@@ -377,13 +413,13 @@ void irq_exit(void)
 #endif
 
 	account_irq_exit_time(current);
-	trace_hardirq_exit();
 	preempt_count_sub(HARDIRQ_OFFSET);
 	if (!in_interrupt() && local_softirq_pending())
 		invoke_softirq();
 
 	tick_irq_exit();
 	rcu_irq_exit();
+	trace_hardirq_exit(); /* must be last! */
 }
 
 /*
