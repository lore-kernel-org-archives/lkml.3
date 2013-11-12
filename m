Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab3KLIHe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 03:07:34 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:54953 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671Ab3KLIHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 03:07:22 -0500
Message-ID: <1384243595.15180.63.camel@marge.simpson.net>
Subject: Re: CONFIG_NO_HZ_FULL + CONFIG_PREEMPT_RT_FULL = nogo
From: Mike Galbraith <bitbucket@online.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Tue, 12 Nov 2013 09:06:35 +0100
In-Reply-To: <alpine.DEB.2.02.1311071402380.23353@ionos.tec.linutronix.de>
References: <1383228427.5272.36.camel@marge.simpson.net>
	 <alpine.DEB.2.02.1311061842160.23353@ionos.tec.linutronix.de>
	 <1383794799.5441.16.camel@marge.simpson.net>
	 <1383798668.5441.25.camel@marge.simpson.net>
	 <alpine.DEB.2.02.1311071158350.23353@ionos.tec.linutronix.de>
	 <20131107125923.GB24644@localhost.localdomain>
	 <alpine.DEB.2.02.1311071402380.23353@ionos.tec.linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:VYIb3X+PVuJoLJQbiaqympBykYuRy2Jqgdj50LGS+Zz
 7XKbO8ASKhgozIMFWku1rmn2HBvJpGgKRENUDIC2k46D8hthHz
 F1VbO+e1Qeh8IbjNQOM0On1PtJ9ZMHlTDLcFnH2vk7YqyxqoNV
 MtZf3XSavQzdI0JL/rwpw/61WIj3Ig38rSIwp5MeZZGex4AxvE
 4DxSDjmTNm1/GEklK2q5SigxuIvm+lLeQmeDVDAMkD6sMPZrH6
 5+GF0asfI8OarXMUACTr3xFyuI8RzDg59clYKhNNYayKwPqtqk
 LFEU3KQlyqlz+gPv1hpA8UxRSdLCHXI1UZSI696mgXewUE5XqI
 3SzkWkJEPuQoX4lsrhyI6NO8Z7/GLaXGWrs8QnzrVuzSya5g9p
 +M5plwecAqzGQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-11-07 at 14:13 +0100, Thomas Gleixner wrote: 
> On Thu, 7 Nov 2013, Frederic Weisbecker wrote:
> > On Thu, Nov 07, 2013 at 12:21:11PM +0100, Thomas Gleixner wrote:
> > > Though it's not a full solution. It needs some thought versus the
> > > softirq code of timers. Assume we have only one timer queued 1000
> > > ticks into the future. So this change will cause the timer softirq not
> > > to be called until that timer expires and then the timer softirq is
> > > going to do 1000 loops until it catches up with jiffies. That's
> > > anything but pretty ...
> > 
> > I see, so the problem is that we raise the timer softirq unconditionally
> > from the tick?
> 
> Right.
>  
> > Ok we definetly don't want to keep that behaviour, even if softirqs are not
> > threaded, that's an overhead. So I'm looking at that loop in __run_timers()
> > and I guess you mean the "base->timer_jiffies" incrementation?
> >
> > That's indeed not pretty. How do we handle exit from long dynticks
> > idle periods? Are we doing that loop until we catch up with the new
> > jiffies?
> 
> Right. I realized that right after I hit send :)
>  
> > Then it relies on the timer cascade stuff which is very obscure code to me...
> 
> It's not that bad, really. I have an idea how to fix that. Needs some
> rewriting though.

FYI, shiny new (and virgin) 3.12.0-rt1 nohz_full config is deadlock
prone.  I was measuring fastpath cost yesterday with pinned pipe-test.. 

x3550 M3 E5620 (bloatware config)
CONFIG_NO_HZ_IDLE - CPU3
2.957012 usecs/loop -- avg 2.957012 676.4 KHz     1.000

CONFIG_NO_HZ_FULL - CPU1 != nohz_full
3.735279 usecs/loop -- avg 3.735279 535.4 KHz      .791

CONFIG_NO_HZ_FULL - CPU3 == nohz_full
5.922986 usecs/loop -- avg 5.922986 337.7 KHz      .499

(ow)

..and noticed box eventually deadlocks, if it boots, which the instance
below didn't.

crash> bt
PID: 11     TASK: ffff88017a27d5a0  CPU: 2   COMMAND: "rcu_preempt"
 #0 [ffff88017b245ae0] machine_kexec at ffffffff810392f1
 #1 [ffff88017b245b40] crash_kexec at ffffffff810cd9d5
 #2 [ffff88017b245c10] panic at ffffffff815bea93
 #3 [ffff88017b245c90] watchdog_overflow_callback.part.3 at ffffffff810f4fd2
 #4 [ffff88017b245ca0] __perf_event_overflow at ffffffff8112715c
 #5 [ffff88017b245d10] intel_pmu_handle_irq at ffffffff8101f432
 #6 [ffff88017b245e00] perf_event_nmi_handler at ffffffff815d4732
 #7 [ffff88017b245e20] nmi_handle.isra.4 at ffffffff815d3dad
 #8 [ffff88017b245eb0] default_do_nmi at ffffffff815d4099
 #9 [ffff88017b245ee0] do_nmi at ffffffff815d42b8
#10 [ffff88017b245ef0] end_repeat_nmi at ffffffff815d31b1
    [exception RIP: _raw_spin_lock+38]
    RIP: ffffffff815d2596  RSP: ffff88017b243e90  RFLAGS: 00000093
    RAX: 0000000000000010  RBX: 0000000000000010  RCX: 0000000000000093
    RDX: ffff88017b243e90  RSI: 0000000000000018  RDI: 0000000000000001
    RBP: ffffffff815d2596   R8: ffffffff815d2596   R9: 0000000000000018
    R10: ffff88017b243e90  R11: 0000000000000093  R12: ffffffffffffffff
    R13: ffff880179ef8000  R14: 0000000000000001  R15: 0000000000000eb6
    ORIG_RAX: 0000000000000eb6  CS: 0010  SS: 0018
--- <RT exception stack> ---
#11 [ffff88017b243e90] _raw_spin_lock at ffffffff815d2596
#12 [ffff88017b243e90] rt_mutex_trylock at ffffffff815d15be
#13 [ffff88017b243eb0] get_next_timer_interrupt at ffffffff81063b42
#14 [ffff88017b243f00] tick_nohz_stop_sched_tick at ffffffff810bd1fd
#15 [ffff88017b243f70] tick_nohz_irq_exit at ffffffff810bd7d2
#16 [ffff88017b243f90] irq_exit at ffffffff8105b02d
#17 [ffff88017b243fb0] reschedule_interrupt at ffffffff815db3dd
--- <IRQ stack> ---
#18 [ffff88017a2a9bc8] reschedule_interrupt at ffffffff815db3dd
    [exception RIP: task_blocks_on_rt_mutex+51]
    RIP: ffffffff810c1ed3  RSP: ffff88017a2a9c78  RFLAGS: 00000296
    RAX: 0000000000080000  RBX: 0000000000000001  RCX: 0000000000000000
    RDX: ffff88017a27d5a0  RSI: ffff88017a2a9d00  RDI: ffff880179ef8000
    RBP: ffff880179ef8000   R8: ffff880179cfef50   R9: ffff880179ef8018
    R10: ffff880179cfef51  R11: 0000000000000002  R12: 0000000000000001
    R13: 0000000000000001  R14: 0000000100000000  R15: 0000000100000000
    ORIG_RAX: ffffffffffffff02  CS: 0010  SS: 0018
#19 [ffff88017a2a9ce0] rt_spin_lock_slowlock at ffffffff815d183c
#20 [ffff88017a2a9da0] lock_timer_base.isra.35 at ffffffff81061cbf
#21 [ffff88017a2a9dd0] schedule_timeout at ffffffff815cf1ce
#22 [ffff88017a2a9e50] rcu_gp_kthread at ffffffff810f9bbb
#23 [ffff88017a2a9ed0] kthread at ffffffff810796d5
#24 [ffff88017a2a9f50] ret_from_fork at ffffffff815da04c
crash>


