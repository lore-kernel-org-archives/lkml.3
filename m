Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607AbbAFTnZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 14:43:25 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:47938 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239AbbAFTnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 14:43:23 -0500
Date: Tue, 6 Jan 2015 11:43:17 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Stoidner, Christoph" <c.stoidner@arvero.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Question concerning RCU
Message-ID: <20150106194317.GG5280@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <94921a144a97457385ae95b838c3c6fa@EX132MBOX1A.de2.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <94921a144a97457385ae95b838c3c6fa@EX132MBOX1A.de2.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010619-0033-0000-0000-00000339C21A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 06:16:27PM +0000, Stoidner, Christoph wrote:
> 
> Hi Paul,
> 
> sorry for contacting you directly. I have a question concerning linux's RCU handling. In kernels MAINTAINERS I could not find any accordingly mailing list. Is there some list anyway that I have overlooked?

RCU uses LKML, which I have added on CC.

> However below you can find my question and I would be very glad if you could give me some hint, or tell me some other person/list where to forward.
> 
> Question:
> 
> After some some minutes or some hours my kernel (version 3.10.18) freezes on my ARM9 (Freescale i.MX28). Using JTAG hardware debugging I have identified that it ends-up in an endless loop in rcu_print_task_stall() in rcutree_plugin.h. Here the macro list_for_each_entry_continue() never ends since rcu_node_entry.next seems to point to it-self but not to rnp->blkd_tasks. Below you can find GDB's backtrace picked from that situation. 
> 
> >From my point of view there are two curious things:
> 
> 1) What is the reason for endless-loop in rcu_print_task_stall() ?

First I have seen this.  Were you doing lots of CPU-hotplug operations?

> 2) For what reason does the stalled state occur?

If the list of tasks blocking the current grace period was sufficiently
mangled, RCU could easily be confused into thinking that the grace period
had never ended.

> Do you have any idea how I can figure out what's happening here? Note that I am using Preempt_rt (with full preemption) and also merged with Xenomai/I-ipipe. So maybe the problem is concerned with that.

Well, if you somehow had two tasks sharing the same task_struct, this sort
of thing could happen.  And much else as well.  The same could happen if
some code mistakenly stomped on the wrong task_struct.

I cannot speak for Xenomai/I-ipipe.  I haven't heard of anything like this
happening on -rt.

If you have more CPUs than the value of CONFIG_RCU_FANOUT (which
defaults to 16), and if your workload offlined a full block of CPUs (full
blocks being CPUs 0-15, 16-31, 32-47, and so on for the default value
of CONFIG_RCU_FANOUT), then there is a theoretical issue that -might-
cause the problem that you are seeing.  However, it is quite hard to
trigger, so I would be surprised if it is your problem.  Plus it showed
up as a too-short RCU grace period, not as a hang.

Nevertheless, feel free to backport the fixes for that problem, which
may be found at:

	git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git

The first commit you need is:

8a01e93af556 (rcu: Note quiescent state when CPU goes offline)

And the last commit you need is:

8b0a2ad434fd (rcu: Protect rcu_boost() lockless accesses with ACCESS_ONCE())

Thirteen commits in all.

							Thanx, Paul

> GDB backtrace:
> 
> #0  0xc0064bac in rcu_print_task_stall (rnp=0xc0546f00 <rcu_preempt_state>) at kernel/rcutree_plugin.h:529
> #1  0xc0066d44 in print_other_cpu_stall (rsp=0xc0546f00 <rcu_preempt_state>) at kernel/rcutree.c:885
> #2  check_cpu_stall (rdp=0x0 <__vectors_start>, rsp=0xc0546f00 <rcu_preempt_state>) at kernel/rcutree.c:977
> #3  __rcu_pending (rdp=0x0 <__vectors_start>, rsp=0xc0546f00 <rcu_preempt_state>) at kernel/rcutree.c:2750
> #4  rcu_pending (cpu=<optimized out>) at kernel/rcutree.c:2800
> #5  rcu_check_callbacks (cpu=<optimized out>, user=<optimized out>) at kernel/rcutree.c:2179
> #6  0xc0028e90 in update_process_times (user_tick=0) at kernel/timer.c:1427
> #7  0xc0052024 in tick_sched_timer (timer=<optimized out>) at kernel/time/tick-sched.c:1095
> #8  0xc003d5ac in __run_hrtimer (timer=0xc05466e0 <tick_cpu_sched>, now=<optimized out>) at kernel/hrtimer.c:1363
> #9  0xc003dfdc in hrtimer_interrupt (dev=<optimized out>) at kernel/hrtimer.c:1582
> #10 0xc032609c in mxs_timer_interrupt (irq=<optimized out>, dev_id=0xc056a180 <mxs_clockevent_device>) at drivers/clocksource/mxs_timer.c:145
> #11 0xc005f7e8 in handle_irq_event_percpu (desc=0xc780b000, action=0xc056a200 <mxs_timer_irq>) at kernel/irq/handle.c:144
> #12 0xc005f9b4 in handle_irq_event (desc=<optimized out>) at kernel/irq/handle.c:197
> #13 0xc00620d4 in handle_level_irq (irq=<optimized out>, desc=0xc780b000) at kernel/irq/chip.c:419
> #14 0xc005f1e8 in generic_handle_irq_desc (desc=<optimized out>, irq=16) at include/linux/irqdesc.h:121
> #15 generic_handle_irq (irq=16) at kernel/irq/irqdesc.c:316
> #16 0xc000f82c in handle_IRQ (irq=16, regs=<optimized out>) at arch/arm/kernel/irq.c:80
> #17 0xc006a140 in __ipipe_do_sync_stage () at kernel/ipipe/core.c:1434
> #18 0xc006a900 in __ipipe_sync_stage () at include/linux/ipipe_base.h:165
> #19 ipipe_unstall_root () at kernel/ipipe/core.c:410
> #20 0xc03ff594 in __raw_spin_unlock_irq (lock=0xc0545828 <runqueues>) at include/linux/spinlock_api_smp.h:171
> #21 _raw_spin_unlock_irq (lock=0xc0545828 <runqueues>) at kernel/spinlock.c:190
> #22 0xc004387c in finish_lock_switch (rq=0xc0545828 <runqueues>, prev=<optimized out>) at kernel/sched/sched.h:848
> #23 finish_task_switch (prev=0xc7198980, rq=0xc0545828 <runqueues>) at kernel/sched/core.c:1949
> #24 0xc03fd7b4 in context_switch (next=0xc7874c00, prev=0xc7198980, rq=0xc0545828 <runqueues>) at kernel/sched/core.c:2090
> #25 __schedule () at kernel/sched/core.c:3213
> #26 0xc03fda10 in schedule () at kernel/sched/core.c:3268
> #27 0xc0086040 in gatekeeper_thread (data=<optimized out>) at kernel/xenomai/nucleus/shadow.c:894
> #28 0xc0039e78 in kthread (_create=0xc783de88) at kernel/kthread.c:200
> #29 0xc000ea00 in ret_from_fork () at arch/arm/kernel/entry-common.S:97
> #30 0xc000ea00 in ret_from_fork () at arch/arm/kernel/entry-common.S:97
> Backtrace stopped: previous frame identical to this frame (corrupt stack?)
> 
> 
> Best Regards and thanks in advance,
> Christoph
> 
> --
> 
> arvero GmbH
> Christoph Stoidner
> Dipl. Informatiker (FH)
> 
> Winchesterstr. 2
> D-35394 Gießen
> 
> Phone : +49 641 948 37 814
> Fax   : +49 641 948 37 816
> Mobile: +49 171 41 49 059
> Email : c.stoidner@arvero.de
> 
> Rechtsform: GmbH - Sitz: D-35394 Gießen, Winchesterstr. 2
> Registergericht: Amtsgericht Gießen, HRB 8277
> St.Nr.: DE 020 228 40804
> Geschäftsführung: Christoph Stoidner
> 
> 

