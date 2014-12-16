Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751213AbaLPSo7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 13:44:59 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:54564 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbaLPSo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 13:44:57 -0500
Date: Tue, 16 Dec 2014 10:42:51 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Miroslav Benes <mbenes@suse.cz>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: rcu_sched stall detected, but no state dump
Message-ID: <20141216184251.GO5310@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.LNX.2.00.1412101334380.22639@pobox.suse.cz>
 <20141210162823.GT25340@linux.vnet.ibm.com>
 <alpine.LNX.2.00.1412111024010.17929@pobox.suse.cz>
 <20141211165010.GI25340@linux.vnet.ibm.com>
 <20141211190957.GA28172@linux.vnet.ibm.com>
 <alpine.LNX.2.00.1412121431450.6587@pobox.suse.cz>
 <20141212165829.GQ25340@linux.vnet.ibm.com>
 <alpine.LNX.2.00.1412151400090.17292@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1412151400090.17292@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121618-0033-0000-0000-0000030A1BF9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 02:26:30PM +0100, Miroslav Benes wrote:
> On Fri, 12 Dec 2014, Paul E. McKenney wrote:
> 
> > On Fri, Dec 12, 2014 at 03:06:20PM +0100, Miroslav Benes wrote:
> > > On Thu, 11 Dec 2014, Paul E. McKenney wrote:
> > > 
> > > > On Thu, Dec 11, 2014 at 08:50:10AM -0800, Paul E. McKenney wrote:
> > > > > On Thu, Dec 11, 2014 at 10:35:15AM +0100, Miroslav Benes wrote:
> > > > > > On Wed, 10 Dec 2014, Paul E. McKenney wrote:
> > > > > > 
> > > > > > > On Wed, Dec 10, 2014 at 01:52:02PM +0100, Miroslav Benes wrote:
> > > > > > > > 
> > > > > > > > Hi,
> > > > > > > > 
> > > > > > > > today I came across RCU stall which was correctly detected, but there is 
> > > > > > > > no state dump. This is a bit suspicious, I think. 
> > > > > > > > 
> > > > > > > > This is the output in serial console:
> > > > > > > > 
> > > > > > > > [  105.727003] INFO: rcu_sched detected stalls on CPUs/tasks:
> > > > > > > > [  105.727003]  (detected by 0, t=21002 jiffies, g=3269, c=3268, q=138)
> > > > > > > > [  105.727003] INFO: Stall ended before state dump start
> > > > > > > > [  168.732006] INFO: rcu_sched detected stalls on CPUs/tasks:
> > > > > > > > [  168.732006]  (detected by 0, t=84007 jiffies, g=3269, c=3268, q=270)
> > > > > > > > [  168.732006] INFO: Stall ended before state dump start
> > > > > > > > [  231.737003] INFO: rcu_sched detected stalls on CPUs/tasks:
> > > > > > > > [  231.737003]  (detected by 0, t=147012 jiffies, g=3269, c=3268, q=388)
> > > > > > > > [  231.737003] INFO: Stall ended before state dump start
> > > > > > > > [  294.742003] INFO: rcu_sched detected stalls on CPUs/tasks:
> > > > > > > > [  294.742003]  (detected by 0, t=210017 jiffies, g=3269, c=3268, q=539)
> > > > > > > > [  294.742003] INFO: Stall ended before state dump start
> > > > > > > > [  357.747003] INFO: rcu_sched detected stalls on CPUs/tasks:
> > > > > > > > [  357.747003]  (detected by 0, t=273022 jiffies, g=3269, c=3268, q=693)
> > > > > > > > [  357.747003] INFO: Stall ended before state dump start
> > > > > > > > [  420.752003] INFO: rcu_sched detected stalls on CPUs/tasks:
> > > > > > > > [  420.752003]  (detected by 0, t=336027 jiffies, g=3269, c=3268, q=806)
> > > > > > > > [  420.752003] INFO: Stall ended before state dump start
> > > > > > > > ...
> > > > > > > > 
> > > > > > > > It can be reproduced by trivial code attached to this mail (infinite 
> > > > > > > > loop in kernel thread created in kernel module). I have CONFIG_PREEMPT=n. 
> > > > > > > > The kernel thread is scheduled on the same CPU which causes soft lockup 
> > > > > > > > (reliably detected when lockup detector is on). There is certainly RCU 
> > > > > > > > stall, but I would expect a state dump. Is this an expected behaviour? 
> > > > > > > > Maybe I overlooked some config option, don't know.
> > > > > > > 
> > > > > > > Definitely not expected behavior!  Unless you have only one CPU, but in
> > > > > > > that case you should be running tiny RCU, not tree RCU.
> > > > > > 
> > > > > > So indeed I messed up my configs somehow and run the code on uniprocessor 
> > > > > > with SMP=y and tree RCU. With more processors RCU stall is detected and 
> > > > > > correct state is dumped. On uniprocessor with SMP=n and tiny RCU 
> > > > > > softlockup is detected, but no RCU stall in the log (is this correct?). So 
> > > > > > I'm really sorry for the noise.
> > > > > > 
> > > > > > Anyway I still think that running SMP kernel with tree RCU on 
> > > > > > uniprocessor is possible option (albeit suboptimal and maybe improbable). 
> > > > > > Should I proceed with your patch below and bisection or am I mistaken 
> > > > > > completely and we can leave it because there is no problem?
> > > > > 
> > > > > Not a problem, there have been some interesting RCU CPU stall warnings
> > > > > recently, and your data did add some insight.
> > > > > 
> > > > > So the combination SMP=n PREEMPT=y can happen straightforwardly via
> > > > > kbuild.  The combination SMP=n PREEMPT=n can happen (somewhat less)
> > > > > straightforwardly by running an SMP=y PREEMPT=n kernel on a single-CPU
> > > > > system.  In both cases, what can happen is that RCU's grace-period
> > > > > kthreads are starved, which can result in those reports.
> > > > > 
> > > > > And these reports are confusing.  I am considering attempting to improve
> > > > > the diagnostics.  If I do, would you be willing to test the resulting
> > > > > patches?
> > > > 
> > > > Like this one, for example.  ;-)
> > > 
> > > Ok, with next-20141212, where this patch is included, and SMP=y PREEMPT=n 
> > > I get the following
> > > 
> > > ...
> > > [  206.949003] INFO: rcu_sched detected stalls on CPUs/tasks:
> > > [  206.949003]  (detected by 0, t=21002 jiffies, g=3384, c=3383, q=247)
> > > [  206.949003] All QSes seen, last rcu_sched kthread activity 4294853243/4294874245, jiffies_till_next_fqs=3
> > > [  269.954004] INFO: rcu_sched detected stalls on CPUs/tasks:
> > > [  269.954004]  (detected by 0, t=84007 jiffies, g=3384, c=3383, q=449)
> > > [  269.954004] All QSes seen, last rcu_sched kthread activity 4294853243/4294937250, jiffies_till_next_fqs=3
> > > [  332.959004] INFO: rcu_sched detected stalls on CPUs/tasks:
> > > [  332.959004]  (detected by 0, t=147012 jiffies, g=3384, c=3383, q=651)
> > > [  332.959004] All QSes seen, last rcu_sched kthread activity 4294853243/4295000255, jiffies_till_next_fqs=3
> > > [  395.964003] INFO: rcu_sched detected stalls on CPUs/tasks:
> > > [  395.964003]  (detected by 0, t=210017 jiffies, g=3384, c=3383, q=858)
> > > [  395.964003] All QSes seen, last rcu_sched kthread activity 4294853243/4295063260, jiffies_till_next_fqs=3
> > > ...
> > > 
> > > So it seems to work and it is not confusing anymore. Would it be possible 
> > > to dump the stack also in this case? The stall is there, the condition is 
> > > correctly detected, so I guess it could be possible. It would give the 
> > > information what caused the stall. 
> > 
> > Ah, good point!  In this case, the stall is self-detected, but RCU
> > incorrectly includes that it is some other CPU's fault because RCU is
> > not waiting on the current CPU.  Please see below for updated patch.
> > 
> > > In SMP=n PREEMPT=y case there is no stall with my test. I guess it is 
> > > because module inclusion does not disable preemption. However it is 
> > > possible in other cases as you wrote above.
> > 
> > OK, that matches expected behavior.
> > 
> > > One last thing. Is there a reason that there is not any similar INFO in 
> > > the console for tiny implementation? I enabled RCU_TRACE and still got 
> > > nothing. I have only shallow knowledge of RCU, though.
> > 
> > It is supposed to work given CONFIG_RCU_TRACE=y, and it looks like
> > it should, at least as long as scheduling-clock interrupts are being
> > delivered.  One thing to try for diagnosis is to have every (say) 1000th
> > call to check_cpu_stall() (in kernel/rcu/tiny_plugin.h) do a printk()
> > and same for rcu_check_callbacks() (in kernel/rcu/tiny.c).
> 
> Unfortunately nothing is there. I'll look into it when I have more time 
> later this week and let you know.
> 
> > 
> > > I'll test more patches if you have some...
> > 
> > Please see below for update that should print current CPU's stack for
> > the "All QSes seen" case.  This replaces the earlier patch.
> 
> This gives
> 
> ...
> [  149.320003] INFO: rcu_sched detected stalls on CPUs/tasks:
> [  149.320003]  (detected by 0, t=21002 jiffies, g=2823, c=2822, q=209)
> [  149.320003] All QSes seen, last rcu_sched kthread activity 21002 (4294816616-4294795614), jiffies_till_next_fqs=3
> [  149.320003] test_thread     R  running task    14832  4015      2 0x00000008
> [  149.320003]  00000000000039f0 ffff88013fc03da8 ffffffff8107874c ffffffff810786b2
> [  149.320003]  ffffffff81e391c0 000000000000520a ffff88013fdcc4a0 ffffffff81e38cc0
> [  149.320003]  ffffffff81e38cc0 ffff88013fc03e28 ffffffff810b1049 0000000000000002
> [  149.320003] Call Trace:
> [  149.320003]  <IRQ>  [<ffffffff8107874c>] sched_show_task+0x11c/0x190
> [  149.320003]  [<ffffffff810786b2>] ? sched_show_task+0x82/0x190
> [  149.320003]  [<ffffffff810b1049>] rcu_check_callbacks+0x839/0x850
> [  149.320003]  [<ffffffff810b627b>] update_process_times+0x4b/0x80
> [  149.320003]  [<ffffffff810c6865>] ? tick_sched_do_timer+0x35/0x40
> [  149.320003]  [<ffffffff810c60d6>] tick_sched_handle.isra.19+0x36/0x50
> [  149.320003]  [<ffffffff810c68b5>] tick_sched_timer+0x45/0x80
> [  149.320003]  [<ffffffff810b7022>] __run_hrtimer+0xb2/0x250
> [  149.320003]  [<ffffffff810b73cc>] ? hrtimer_interrupt+0x7c/0x250
> [  149.320003]  [<ffffffff810c6870>] ? tick_sched_do_timer+0x40/0x40
> [  149.320003]  [<ffffffff810b7447>] hrtimer_interrupt+0xf7/0x250
> [  149.320003]  [<ffffffffa0000000>] ? 0xffffffffa0000000
> [  149.320003]  [<ffffffff810356eb>] local_apic_timer_interrupt+0x3b/0x70
> [  149.320003]  [<ffffffff818a9845>] smp_apic_timer_interrupt+0x45/0x60
> [  149.320003]  [<ffffffff818a7c2f>] apic_timer_interrupt+0x6f/0x80
> [  149.320003]  <EOI>  [<ffffffff818a7960>] ? retint_restore_args+0xe/0xe
> [  149.320003]  [<ffffffff8106d004>] ? kthread_should_stop+0x24/0x30
> [  149.320003]  [<ffffffffa0000015>] ? test_thread_fn+0x15/0x20 [kthread_mod]
> [  149.320003]  [<ffffffff8106d460>] kthread+0xf0/0x110
> [  149.320003]  [<ffffffff8106d370>] ? kthread_create_on_node+0x240/0x240
> [  149.320003]  [<ffffffff818a6cec>] ret_from_fork+0x7c/0xb0
> [  149.320003]  [<ffffffff8106d370>] ? kthread_create_on_node+0x240/0x240
> ...
> 
> So it works as expected which is great. You can add my Tested-by if you 
> feel it is worth it.

Got it, thank you!

							Thanx, Paul

