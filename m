Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759994Ab3HNP4x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 11:56:53 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:37112 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161Ab3HNP4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 11:56:51 -0400
Date: Wed, 14 Aug 2013 17:56:47 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Kevin Hilman <khilman@linaro.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Alex Shi <alex.shi@intel.com>, Paul Turner <pjt@google.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: Re: [GIT PULL] timers/nohz updates for 3.12
Message-ID: <20130814155638.GA4506@somewhere>
References: <1375729264-19845-1-git-send-email-fweisbec@gmail.com>
 <20130812184428.GA19785@gmail.com>
 <20130813000355.GD27436@somewhere>
 <20130813145730.GA4485@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130813145730.GA4485@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 04:57:30PM +0200, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > > >  19 files changed, 534 insertions(+), 326 deletions(-)
> > > 
> > > When merged to -tip it causes this build error:
> > > 
> > >  kernel/time/tick-sched.c:186:3: error: 'have_nohz_full_mask' undeclared (first use in this function)
> > >  kernel/time/tick-sched.c:345:2: error: 'cpu' undeclared (first use in this function)
> > > 
> > > config attached.
> > > 
> > > I did what looked like to be an obvious conflict resolution to 
> > > tick-sched.c (attached), please double check that too.
> > > 
> > > While at it, mind rebasing your changes to tip:timers/urgent, which has a 
> > > few nohz fixes pending as well?
> > 
> > Ok I did the rebase on top of tip:timers/urgent and handled the 
> > conflicts along. The new branch is "timers/nohz-v2".
> > 
> > Tell me if anything goes wrong with it.
> 
> it produces this splat on bootup with the attached config, on a dual-core 
> Athlon64 box:
> 
> calling  context_tracking_init+0x0/0x3a @ 1
> initcall context_tracking_init+0x0/0x3a returned 0 after 0 usecs
> calling  dynamic_debug_init+0x0/0x239 @ 1
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 1 at kernel/sched/cputime.c:639 get_vtime_delta+0x49/0x5f()
> CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.11.0-rc5-01689-g7830cba-dirty #226899
> Hardware name: System manufacturer System Product Name/A8N-E, BIOS ASUS A8N-E ACPI BIOS Revision 1008 08/22/2005
>  0000000000000009 ffff88003fa03ea8 ffffffff81f83f30 0000000000000b63
>  0000000000000000 ffff88003fa03ee8 ffffffff810996a4 0000000000000000
>  ffffffff810bcfb5 ffff88003e33a000 0000000015752a00 0000000000000000
> Call Trace:
>  <IRQ>  [<ffffffff81f83f30>] dump_stack+0x46/0x58
>  [<ffffffff810996a4>] warn_slowpath_common+0x72/0x8c
>  [<ffffffff810bcfb5>] ? get_vtime_delta+0x49/0x5f
>  [<ffffffff8109976c>] warn_slowpath_null+0x15/0x19
>  [<ffffffff810bcfb5>] get_vtime_delta+0x49/0x5f
>  [<ffffffff810bd213>] __vtime_account_system+0xf/0x37
>  [<ffffffff810bd426>] vtime_account_system+0x21/0x2e
>  [<ffffffff810bd5bf>] vtime_common_account_irq_enter+0x41/0x43
>  [<ffffffff8109ce4a>] irq_enter+0x65/0x7c
>  [<ffffffff810434e2>] smp_apic_timer_interrupt+0x23/0x40
>  [<ffffffff81f9435d>] apic_timer_interrupt+0x6d/0x80
>  <EOI>  [<ffffffff810c42d5>] ? arch_local_irq_restore+0x12/0x19
>  [<ffffffff810c5acb>] vprintk_emit+0x3e2/0x40a
>  [<ffffffff81099995>] ? cpu_maps_update_begin+0x12/0x14
>  [<ffffffff832e9244>] ? ddebug_setup_query+0x4d/0x4d
>  [<ffffffff81f80ddd>] printk+0x5c/0x5e
>  [<ffffffff8135caff>] __dynamic_pr_debug+0x79/0x7b
>  [<ffffffff810c764d>] ? timekeeping_get_ns.constprop.10+0x12/0x38
>  [<ffffffff832db12b>] ? init_hw_breakpoint+0xf7/0xf7
>  [<ffffffff810c7bbb>] ? ktime_get+0x65/0x74
>  [<ffffffff832db12b>] ? init_hw_breakpoint+0xf7/0xf7
>  [<ffffffff832e9244>] ? ddebug_setup_query+0x4d/0x4d
>  [<ffffffff832c4d9d>] do_one_initcall+0x5b/0x12a
>  [<ffffffff832d09a5>] ? native_smp_prepare_cpus+0x300/0x341
>  [<ffffffff832c4ed6>] kernel_init_freeable+0x6a/0x195
>  [<ffffffff81f7c075>] ? rest_init+0xb9/0xb9
>  [<ffffffff81f7c07e>] kernel_init+0x9/0xd1
>  [<ffffffff81f9357c>] ret_from_fork+0x7c/0xb0
>  [<ffffffff81f7c075>] ? rest_init+0xb9/0xb9
> ---[ end trace 268f4433da36e82f ]---
> initcall dynamic_debug_init+0x0/0x239 returned 0 after 0 usecs
> 
> Thanks,
> 
> 	Ingo

Sorry about that, I missed it. This is because context tracking initialization
when CONFIG_CONTEXT_TRACKING_FORCE=y is done too late. As a result, the user init
task can run with context tracking disabled when it is scheduled for the first
time and then later run with context tracking enabled due to the late initialization.
And this finally messes up the state of context tracking internal on CPU 0.

Anyway I fixed this by moving the context tracking initialization earlier, before
irqs are enabled and the user init task is created.

Please check out the branch "timers/nohz-v3".

Only commit "context_tracking: Ground setup for static key use"
which is now 65f382fd0c8fa483713c0971de9f1dfb4cf1ad9c has changed to integrate the
fix.

And following is the diff against the previous branch.

Thanks!

diff --git a/include/linux/context_tracking.h b/include/linux/context_tracking.h
index 655356a..1581587 100644
--- a/include/linux/context_tracking.h
+++ b/include/linux/context_tracking.h
@@ -63,6 +63,14 @@ static inline void context_tracking_task_switch(struct task_struct *prev,
 						struct task_struct *next) { }
 #endif /* !CONFIG_CONTEXT_TRACKING */
 
+
+#ifdef CONFIG_CONTEXT_TRACKING_FORCE
+extern void context_tracking_init(void);
+#else
+static inline void context_tracking_init(void) { }
+#endif /* CONFIG_CONTEXT_TRACKING_FORCE */
+
+
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
 static inline void guest_enter(void)
 {
diff --git a/init/main.c b/init/main.c
index d03d2ec..af310af 100644
--- a/init/main.c
+++ b/init/main.c
@@ -75,6 +75,7 @@
 #include <linux/blkdev.h>
 #include <linux/elevator.h>
 #include <linux/sched_clock.h>
+#include <linux/context_tracking.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -545,6 +546,7 @@ asmlinkage void __init start_kernel(void)
 	idr_init_cache();
 	rcu_init();
 	tick_nohz_init();
+	context_tracking_init();
 	radix_tree_init();
 	/* init some links before init_ISA_irqs() */
 	early_irq_init();
diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
index 688efe4..247091b 100644
--- a/kernel/context_tracking.c
+++ b/kernel/context_tracking.c
@@ -191,14 +191,11 @@ void __context_tracking_task_switch(struct task_struct *prev,
 }
 
 #ifdef CONFIG_CONTEXT_TRACKING_FORCE
-static int __init context_tracking_init(void)
+void __init context_tracking_init(void)
 {
 	int cpu;
 
 	for_each_possible_cpu(cpu)
 		context_tracking_cpu_set(cpu);
-
-	return 0;
 }
-early_initcall(context_tracking_init);
 #endif
