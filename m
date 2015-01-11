Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964AbbAKU0O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 15:26:14 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:37077 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbbAKU0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 15:26:13 -0500
Date: Sun, 11 Jan 2015 12:26:04 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Stoidner, Christoph" <c.stoidner@arvero.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Question concerning RCU
Message-ID: <20150111202604.GC8063@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <94921a144a97457385ae95b838c3c6fa@EX132MBOX1A.de2.local>
 <20150106194317.GG5280@linux.vnet.ibm.com>
 <81b94fc89c774b71a967fc93823e9c63@EX132MBOX1A.de2.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81b94fc89c774b71a967fc93823e9c63@EX132MBOX1A.de2.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15011120-0029-0000-0000-0000071F4799
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2015 at 11:59:45AM +0000, Stoidner, Christoph wrote:
> 
> Hi Paul,
> 
> many thanks for your fast answer!
> 
> Now I have changed my application in that way, that it does not require 
> Xenomai/I-Pipe anymore. That means my kernel is build now from 
> mainline source, with preempt_rt only and no Xenomai or I-Pipe. 
> However the problem is exact the same. After some runtime (minutes 
> or hours) the kernel freezes and JTAG debugging shows that it ends-up 
> in an endless loop in rcu_print_task_stall (as described before). 
> 
> > First I have seen this.  Were you doing lots of CPU-hotplug operations?
> 
> My system has only one core. So I think there should not be any 
> CPU-hotplugging.

OK, so no point in providing you that set of patches, then.

> > If you have more CPUs than the value of CONFIG_RCU_FANOUT (which
> > defaults to 16), and if your workload offlined a full block of CPUs (full
> > blocks being CPUs 0-15, 16-31, 32-47, and so on for the default value
> > of CONFIG_RCU_FANOUT), then there is a theoretical issue that -might-
> > cause the problem that you are seeing.
> 
> Also this could not only happen on a single core system. Am I right?

Yep, no way this can happen without a lot of CPUs and a lot of CPU
hotplugging.

> I have no idea how to find the problem. Do you have any more hints or ideas?

You got stack traces with the stall warnings, correct?  If so, please look
at them and at Documentation/RCU/stallwarn.txt and see if the kernel is
looping somewhere inappropriate.

I am not familiar with the low-level ARM kernel code, but the stack below
leads me to suspect that your kernel is interrupting itself to death or
is improperly handling interrupts.

							Thanx, Paul

> Here is a backtrace when the problem has occurred on the system without Xenomai/I-Pipe:
> 
> #0  rcu_print_task_stall (rnp=0xc0498dc8 <rcu_preempt_state>) at kernel/rcutree_plugin.h:528
> #1  0xc005cabc in print_other_cpu_stall (rsp=0xc0498dc8 <rcu_preempt_state>) at kernel/rcutree.c:885
> #2  check_cpu_stall (rdp=0x80000093, rsp=0xc0498dc8 <rcu_preempt_state>) at kernel/rcutree.c:977
> #3  __rcu_pending (rdp=0x80000093, rsp=0xc0498dc8 <rcu_preempt_state>) at kernel/rcutree.c:2750
> #4  rcu_pending (cpu=<optimized out>) at kernel/rcutree.c:2800
> #5  rcu_check_callbacks (cpu=<optimized out>, user=<optimized out>) at kernel/rcutree.c:2179
> #6  0xc0027648 in update_process_times (user_tick=0) at kernel/timer.c:1427
> #7  0xc004e840 in tick_sched_timer (timer=0xc0498860 <tick_cpu_sched>) at kernel/time/tick-sched.c:1095
> #8  0xc003a0dc in __run_hrtimer (timer=0xc0498860 <tick_cpu_sched>, now=<optimized out>) at kernel/hrtimer.c:1363
> #9  0xc003ab4c in hrtimer_interrupt (dev=<optimized out>) at kernel/hrtimer.c:1582
> #10 0xc02bf7bc in mxs_timer_interrupt (irq=<optimized out>, dev_id=<optimized out>) at drivers/clocksource/mxs_timer.c:132
> #11 0xc0055154 in handle_irq_event_percpu (desc=0xc7804c00, action=0xc04b0520 <mxs_timer_irq>) at kernel/irq/handle.c:144
> #12 0xc0055320 in handle_irq_event (desc=0xc7804c00) at kernel/irq/handle.c:197
> #13 0xc00578b8 in handle_level_irq (irq=<optimized out>, desc=0xc7804c00) at kernel/irq/chip.c:406
> #14 0xc0054aec in generic_handle_irq_desc (desc=<optimized out>, irq=16) at include/linux/irqdesc.h:115
> #15 generic_handle_irq (irq=16) at kernel/irq/irqdesc.c:314
> #16 0xc000f58c in handle_IRQ (irq=16, regs=<optimized out>) at arch/arm/kernel/irq.c:80
> #17 0xc000e360 in __irq_svc () at arch/arm/kernel/entry-armv.S:202
> #18 0xc000e360 in __irq_svc () at arch/arm/kernel/entry-armv.S:202
> #19 0xc000e360 in __irq_svc () at arch/arm/kernel/entry-armv.S:202
> #20 0xc000e360 in __irq_svc () at arch/arm/kernel/entry-armv.S:202
> ...
> 
> Thanks and regards,
> Christoph
> 

