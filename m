Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591AbaLSXPW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 18:15:22 -0500
Received: from www.linutronix.de ([62.245.132.108]:36163 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbaLSXPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 18:15:21 -0500
Date: Sat, 20 Dec 2014 00:14:56 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?ISO-8859-15?Q?D=E2niel_Fraga?= <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Suresh Siddha <sbsiddha@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Peter Anvin <hpa@linux.intel.com>
Subject: Re: frequent lockups in 3.18rc4
In-Reply-To: <CA+55aFychipT9e0DenUumsGJ-=9BUTOX-OmAmQ3azMCspUrUtw@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1412192201520.17382@nanos>
References: <CA+55aFyYYPgBfRdqtvqxdo==D_BOFSW3fvNULuVxPAr2vnq7Rg@mail.gmail.com> <CA+55aFz6KEKdz4Nxkx2fa-FH3PZ+Aa51iA_nXobsQ-dDW5PGEg@mail.gmail.com> <20141218051327.GA31988@redhat.com> <1418918059.17358.6@mail.thefacebook.com> <20141218161230.GA6042@redhat.com>
 <20141219024549.GB1671@redhat.com> <CA+55aFw7R+P+2xgXwUqG5uxNs=dLD59fL+6uHuhWHFtsAb1nSg@mail.gmail.com> <20141219035859.GA20022@redhat.com> <20141219040308.GB20022@redhat.com> <CA+55aFzg0WN1_SzRagwwEDGUkKou4t+-gBNMUd-W3KM7tC+-AA@mail.gmail.com>
 <20141219145528.GC13404@redhat.com> <CA+55aFychipT9e0DenUumsGJ-=9BUTOX-OmAmQ3azMCspUrUtw@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Dec 2014, Linus Torvalds wrote:
> Here's another pattern. In your latest thing, every single time that
> CPU1 is waiting for some other CPU to pick up the IPI, we have CPU0
> doing this:
> 
> [24998.060963] NMI backtrace for cpu 0
> [24998.061989] CPU: 0 PID: 2940 Comm: trinity-c150 Not tainted 3.18.0+ #108
> [24998.064073] task: ffff8801bf3536b0 ti: ffff880197e0c000 task.ti:
> ffff880197e0c000
> [24998.065137] RIP: 0010:[<ffffffff8103e006>]  [<ffffffff8103e006>]
> read_hpet+0x16/0x20
> [24998.083577]  [<ffffffff810e0d3e>] ktime_get+0x3e/0xa0
> [24998.084450]  [<ffffffff810e9cd3>] tick_sched_timer+0x23/0x160
> [24998.085315]  [<ffffffff810daf96>] __run_hrtimer+0x76/0x1f0
> [24998.086173]  [<ffffffff810e9cb0>] ? tick_init_highres+0x20/0x20
> [24998.087025]  [<ffffffff810db2e7>] hrtimer_interrupt+0x107/0x260
> [24998.087877]  [<ffffffff81031a4b>] local_apic_timer_interrupt+0x3b/0x70
> [24998.088732]  [<ffffffff8179bca5>] smp_apic_timer_interrupt+0x45/0x60
> [24998.089583]  [<ffffffff8179a0df>] apic_timer_interrupt+0x6f/0x80
> [24998.090435]  <EOI>
> [24998.091279]  [<ffffffff810da66e>] ? __remove_hrtimer+0x4e/0xa0
> [24998.092118]  [<ffffffff812c7c7a>] ? ipcget+0x8a/0x1e0
> [24998.092951]  [<ffffffff812c7c6c>] ? ipcget+0x7c/0x1e0
> [24998.093779]  [<ffffffff812c8d6d>] SyS_msgget+0x4d/0x70
> 
> and I think that's the smoking gun. The reason CPU0 isn't picking up
> any IPI's is because it is in some endless loop around read_hpet().
> 
> There is even time information in the register dump:
> 
>  RAX: 0000000061fece8a RBX: 0000000000510792 RCX: 0000000000000000
>  RAX: 0000000079e588fc RBX: 0000000000511d6e RCX: 0000000000000000
>  RAX: 0000000091ca7f65 RBX: 0000000000513346 RCX: 0000000000000000
>  RAX: 00000000a9afbd0d RBX: 000000000051491e RCX: 0000000000000000
>  RAX: 00000000cbd1340c RBX: 000000000051684a RCX: 0000000000000000
>  RAX: 00000000fb9d303f RBX: 00000000005193fc RCX: 0000000000000000
>  RAX: 000000002b67efe4 RBX: 000000000051c224 RCX: 0000000000000004
> 
> That RAX value is the value we just read from the HPET, and RBX seems
> to be monotonically increasing too, so it's likely the sequence
> counter in ktime_get().

Here is the full diff of the first and the second splat for CPU0

 task: ffff8801bf3536b0 ti: ffff880197e0c000 task.ti: ffff880197e0c000
 read_hpet+0x16/0x20
 RSP: 0018:ffff88024e203e38  EFLAGS: 00000046
-RAX: 0000000061fece8a RBX: 0000000000510792 RCX: 0000000000000000
+RAX: 0000000079e588fc RBX: 0000000000511d6e RCX: 0000000000000000

RAX: 
(0x0000000079e588fc - 0x0000000061fece8a) / 14.318180e6 ~= 28.0061

So HPET @14.3MHz progressed by 28 seconds, which matches the splat
delta between the first and the second one.

25026.001132 - 24998.017355 = 27.9838

RBX:
0x0000000000511d6e - 0x0000000000510792 = 5596 

The sequence counter increments by 2 per tick. So:

28 / (5596/2) ~= 0.0025 s

==> HZ = 400

The sequence counter is even, so ktime_get() will succeed.

 RDX: 0000000000000000 RSI: ffff88024e20c710 RDI: ffffffff81c26f40
 RBP: ffff88024e203e38 R08: 0000000000000000 R09: 000000000000000f
-R10: 0000000000000526 R11: 000000000000000f R12: 000016bf99600917
+R10: 0000000000000526 R11: 000000000000000f R12: 000016c61e4e2117

R12:
0x000016c61e4e2117 - 0x000016bf99600917 = 2.8e+10

That's the nanoseconds timestamp: 2.8e10/1e9 = 28

Now that all looks correct. So there is something else going on. After
staring some more at it, I think we are looking at it from the wrong
angle.

The watchdog always detects CPU1 as stuck and we got completely
fixated on the csd_wait() in the stack trace on CPU1. Now we have
stack traces which show a different picture, i.e. CPU1 makes progress
after a gazillion of seconds.

I think we really need to look at CPU1 itself.

AFAICT all these 'stuck' events happen in fully interruptible
context. So an undetected interrupt storm can cause that.

We only detect interrupt storms for unhandled interrupts, but for
those where the handler returns IRQ_HANDLED, we just count them.

For directly handled vectors we do not even have a detection mechanism
at all.

That also might explain the RT throttling. If that storm hits a high
prio task, the throttler will trigger.

Just a theory, but worth to explore, IMO.

So adding a dump of the total interrupt counts to the watchdog trace
might give us some insight.

Debug patch below.

Thanks,

	tglx
---
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 501baa9ac1be..2021662663c7 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -315,11 +315,21 @@ asmlinkage __visible void do_softirq(void)
 	local_irq_restore(flags);
 }
 
+static DEFINE_PER_CPU(unsigned long, irqcnt);
+
+void show_irqcnt(int cpu)
+{
+	pr_emerg("CPU#%d: IRQ %lu NMI %u\n", cpu, this_cpu_read(irqcnt),
+		 this_cpu_read(irq_stat.__nmi_count));
+}
+
 /*
  * Enter an interrupt context.
  */
 void irq_enter(void)
 {
+	this_cpu_inc(irqcnt);
+
 	rcu_irq_enter();
 	if (is_idle_task(current) && !in_interrupt()) {
 		/*
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 70bf11815f84..f505cc58d354 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -306,6 +306,8 @@ static void watchdog_interrupt_count(void)
 static int watchdog_nmi_enable(unsigned int cpu);
 static void watchdog_nmi_disable(unsigned int cpu);
 
+extern void show_irqcnt(int cpu);
+
 /* watchdog kicker functions */
 static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
 {
@@ -388,6 +390,7 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
 			smp_processor_id(), duration,
 			current->comm, task_pid_nr(current));
 		__this_cpu_write(softlockup_task_ptr_saved, current);
+		show_irqcnt(smp_processor_id());
 		print_modules();
 		print_irqtrace_events(current);
 		if (regs)








