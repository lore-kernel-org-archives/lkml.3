Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032Ab3FQHmR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 03:42:17 -0400
Received: from ozlabs.org ([203.10.76.45]:50903 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753465Ab3FQHmQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 03:42:16 -0400
Date: Mon, 17 Jun 2013 17:42:13 +1000
From: Michael Ellerman <michael@ellerman.id.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        paulmck@linux.vnet.ibm.com, Rojhalat Ibrahim <imr@rtschenk.de>,
        linux-kernel@vger.kernel.org
Subject: Re: Regression in RCU subsystem in latest mainline kernel
Message-ID: <20130617074213.GA3589@concordia>
References: <1626500.7WAVXjfS9F@pcimr>
 <20130614122800.GL5146@linux.vnet.ibm.com>
 <1645938.As0LR1yeVd@pcimr>
 <1371243967.9844.338.camel@gandalf.local.home>
 <1371261741.21896.20.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371261741.21896.20.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 15, 2013 at 12:02:21PM +1000, Benjamin Herrenschmidt wrote:
> On Fri, 2013-06-14 at 17:06 -0400, Steven Rostedt wrote:
> > I was pretty much able to reproduce this on my PA Semi PPC box. Funny
> > thing is, when I type on the console, it makes progress. Anyway, it
> > seems that powerpc has an issue with irq_work(). I'll try to get some
> > time either tonight or next week to figure it out.
> 
> Does this help ?
> 
> diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
> index 5cbcf4d..ea185e0 100644
> --- a/arch/powerpc/kernel/irq.c
> +++ b/arch/powerpc/kernel/irq.c
> @@ -162,7 +162,7 @@ notrace unsigned int __check_irq_replay(void)
>  	 * in case we also had a rollover while hard disabled
>  	 */
>  	local_paca->irq_happened &= ~PACA_IRQ_DEC;
> -	if (decrementer_check_overflow())
> +	if ((happened & PACA_IRQ_DEC) || decrementer_check_overflow())
>  		return 0x900;
>  
>  	/* Finally check if an external interrupt happened */
> 

This seems to help, but doesn't elminate the RCU stall warnings I am
seeing. I now see them less often, but not never.

Stack trace is something like:

  INFO: rcu_sched detected stalls on CPUs/tasks: { 32} (detected by 12, t=21372 jiffies, g=18446744073709551503, c=18446744073709551502, q=1018)
  Task dump for CPU 32:
  power8-events   R  running task     4960  2009   1988 0x00000004
  Call Trace:
  [c000000fb0e3f910] [c000000fb0e3f9d0] 0xc000000fb0e3f9d0 (unreliable)
  
  [c000000fb0e3edc0] [c0000000000b2894] .__run_hrtimer+0xa4/0x2a0
  [c000000fb0e3ee70] [c0000000000b36d8] .hrtimer_interrupt+0x148/0x320
  [c000000fb0e3ef80] [c00000000001c754] .timer_interrupt+0x134/0x320
  [c000000fb0e3f040] [c00000000000a4f4] restore_check_irq_replay+0x68/0xa8
  --- Exception: 901 at .arch_local_irq_restore+0x24/0x90
      LR = .__do_softirq+0x100/0x3a0
  [c000000fb0e3f330] [c0000000000c4784] .vtime_account_irq_enter+0x34/0x70 (unreliable)
  [c000000fb0e3f3a0] [c000000000089680] .__do_softirq+0x100/0x3a0
  [c000000fb0e3f4c0] [c000000000089b38] .irq_exit+0xc8/0x110
  [c000000fb0e3f540] [c00000000001c788] .timer_interrupt+0x168/0x320
  [c000000fb0e3f600] [c0000000000025cc] decrementer_common+0x14c/0x180
  --- Exception: 901 at .arch_local_irq_restore+0x74/0x90
      LR = .arch_local_irq_restore+0x74/0x90
  [c000000fb0e3f8f0] [c000000fb0e3f970] 0xc000000fb0e3f970 (unreliable)
  [c000000fb0e3f960] [c0000000000e4ae0] .smp_call_function_single+0x1d0/0x1e0
  [c000000fb0e3fa10] [c000000000147aa4] .task_function_call+0x54/0x70
  [c000000fb0e3fab0] [c000000000147bc4] .perf_event_enable+0x104/0x1c0
  [c000000fb0e3fb60] [c000000000146800] .perf_event_for_each_child+0x60/0x110
  [c000000fb0e3fbf0] [c00000000014a528] .perf_ioctl+0x108/0x3f0
  [c000000fb0e3fca0] [c0000000001d7138] .do_vfs_ioctl+0xb8/0x730
  [c000000fb0e3fd80] [c0000000001d780c] .SyS_ioctl+0x5c/0xb0
  [c000000fb0e3fe30] [c000000000009d54] syscall_exit+0x0/0x98


cheers
