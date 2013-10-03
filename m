Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209Ab3JCT6p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 15:58:45 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:60966 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087Ab3JCT6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 15:58:43 -0400
Date: Thu, 3 Oct 2013 12:58:32 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        gregkh@linuxfoundation.org, peter@hurleysoftware.com
Subject: Re: tty^Wrcu/perf lockdep trace.
Message-ID: <20131003195832.GU5790@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131003190830.GA18672@redhat.com>
 <20131003194226.GO28601@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131003194226.GO28601@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100319-7164-0000-0000-000002256C40
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 09:42:26PM +0200, Peter Zijlstra wrote:
> 
> That's not tty; that's RCU..
> 
> On Thu, Oct 03, 2013 at 03:08:30PM -0400, Dave Jones wrote:
> >  ======================================================
> >  [ INFO: possible circular locking dependency detected ]
> >  3.12.0-rc3+ #92 Not tainted
> >  -------------------------------------------------------
> >  trinity-child2/15191 is trying to acquire lock:
> >   (&rdp->nocb_wq){......}, at: [<ffffffff8108ff43>] __wake_up+0x23/0x50
> >  
> > but task is already holding lock:
> >   (&ctx->lock){-.-...}, at: [<ffffffff81154c19>] perf_event_exit_task+0x109/0x230
> > 
> > which lock already depends on the new lock.
> > 
> > 
> > the existing dependency chain (in reverse order) is:
> > 
> > -> #3 (&ctx->lock){-.-...}:
> >         [<ffffffff810cc243>] lock_acquire+0x93/0x200
> >         [<ffffffff81733f90>] _raw_spin_lock+0x40/0x80
> >         [<ffffffff811500ff>] __perf_event_task_sched_out+0x2df/0x5e0
> >         [<ffffffff81091b83>] perf_event_task_sched_out+0x93/0xa0
> >         [<ffffffff81732052>] __schedule+0x1d2/0xa20
> >         [<ffffffff81732f30>] preempt_schedule_irq+0x50/0xb0
> >         [<ffffffff817352b6>] retint_kernel+0x26/0x30
> >         [<ffffffff813eed04>] tty_flip_buffer_push+0x34/0x50
> >         [<ffffffff813f0504>] pty_write+0x54/0x60
> >         [<ffffffff813e900d>] n_tty_write+0x32d/0x4e0
> >         [<ffffffff813e5838>] tty_write+0x158/0x2d0
> >         [<ffffffff811c4850>] vfs_write+0xc0/0x1f0
> >         [<ffffffff811c52cc>] SyS_write+0x4c/0xa0
> >         [<ffffffff8173d4e4>] tracesys+0xdd/0xe2
> >  
> > -> #2 (&rq->lock){-.-.-.}:
> >         [<ffffffff810cc243>] lock_acquire+0x93/0x200
> >         [<ffffffff81733f90>] _raw_spin_lock+0x40/0x80
> >         [<ffffffff810980b2>] wake_up_new_task+0xc2/0x2e0
> >         [<ffffffff81054336>] do_fork+0x126/0x460
> >         [<ffffffff81054696>] kernel_thread+0x26/0x30
> >         [<ffffffff8171ff93>] rest_init+0x23/0x140
> >         [<ffffffff81ee1e4b>] start_kernel+0x3f6/0x403
> >         [<ffffffff81ee1571>] x86_64_start_reservations+0x2a/0x2c
> >         [<ffffffff81ee1664>] x86_64_start_kernel+0xf1/0xf4
> >  
> > -> #1 (&p->pi_lock){-.-.-.}:
> >         [<ffffffff810cc243>] lock_acquire+0x93/0x200
> >         [<ffffffff8173419b>] _raw_spin_lock_irqsave+0x4b/0x90
> >         [<ffffffff810979d1>] try_to_wake_up+0x31/0x350
> >         [<ffffffff81097d62>] default_wake_function+0x12/0x20
> >         [<ffffffff81084af8>] autoremove_wake_function+0x18/0x40
> >         [<ffffffff8108ea38>] __wake_up_common+0x58/0x90
> >         [<ffffffff8108ff59>] __wake_up+0x39/0x50
> >         [<ffffffff8110d4f8>] __call_rcu_nocb_enqueue+0xa8/0xc0
> >         [<ffffffff81111450>] __call_rcu+0x140/0x820
> >         [<ffffffff81111b8d>] call_rcu+0x1d/0x20
> >         [<ffffffff81093697>] cpu_attach_domain+0x287/0x360
> >         [<ffffffff81099d7e>] build_sched_domains+0xe5e/0x10a0
> >         [<ffffffff81efa7fc>] sched_init_smp+0x3b7/0x47a
> >         [<ffffffff81ee1f4e>] kernel_init_freeable+0xf6/0x202
> >         [<ffffffff817200be>] kernel_init+0xe/0x190
> >         [<ffffffff8173d22c>] ret_from_fork+0x7c/0xb0
> >  
> > -> #0 (&rdp->nocb_wq){......}:
> >         [<ffffffff810cb7ca>] __lock_acquire+0x191a/0x1be0
> >         [<ffffffff810cc243>] lock_acquire+0x93/0x200
> >         [<ffffffff8173419b>] _raw_spin_lock_irqsave+0x4b/0x90
> >         [<ffffffff8108ff43>] __wake_up+0x23/0x50
> >         [<ffffffff8110d4f8>] __call_rcu_nocb_enqueue+0xa8/0xc0
> >         [<ffffffff81111450>] __call_rcu+0x140/0x820
> >         [<ffffffff81111bb0>] kfree_call_rcu+0x20/0x30
> >         [<ffffffff81149abf>] put_ctx+0x4f/0x70
> >         [<ffffffff81154c3e>] perf_event_exit_task+0x12e/0x230
> >         [<ffffffff81056b8d>] do_exit+0x30d/0xcc0
> >         [<ffffffff8105893c>] do_group_exit+0x4c/0xc0
> >         [<ffffffff810589c4>] SyS_exit_group+0x14/0x20
> >         [<ffffffff8173d4e4>] tracesys+0xdd/0xe2

I suppose I could defer the ->nocb_wq wakeup until the next context switch
or transition to idle/userspace, but it might be simpler for put_ctx()
to maintain a per-CPU chain of callbacks which are kfree_rcu()ed when
ctx->lock is dropped.  Also easier on the kernel/user and kernel/idle
transition overhead/latency...

Other thoughts?

							Thanx, Paul

> > other info that might help us debug this:
> > 
> > Chain exists of:
> >   &rdp->nocb_wq --> &rq->lock --> &ctx->lock
> > 
> >   Possible unsafe locking scenario:
> > 
> >         CPU0                    CPU1
> >         ----                    ----
> >    lock(&ctx->lock);
> >                                 lock(&rq->lock);
> >                                 lock(&ctx->lock);
> >    lock(&rdp->nocb_wq);
> >  
> >  *** DEADLOCK ***
> > 
> > 1 lock held by trinity-child2/15191:
> >  #0:  (&ctx->lock){-.-...}, at: [<ffffffff81154c19>] perf_event_exit_task+0x109/0x230
> > 
> > stack backtrace:
> > CPU: 2 PID: 15191 Comm: trinity-child2 Not tainted 3.12.0-rc3+ #92 
> >  ffffffff82565b70 ffff880070c2dbf8 ffffffff8172a363 ffffffff824edf40
> >  ffff880070c2dc38 ffffffff81726741 ffff880070c2dc90 ffff88022383b1c0
> >  ffff88022383aac0 0000000000000000 ffff88022383b188 ffff88022383b1c0
> > Call Trace:
> >  [<ffffffff8172a363>] dump_stack+0x4e/0x82
> >  [<ffffffff81726741>] print_circular_bug+0x200/0x20f
> >  [<ffffffff810cb7ca>] __lock_acquire+0x191a/0x1be0
> >  [<ffffffff810c6439>] ? get_lock_stats+0x19/0x60
> >  [<ffffffff8100b2f4>] ? native_sched_clock+0x24/0x80
> >  [<ffffffff810cc243>] lock_acquire+0x93/0x200
> >  [<ffffffff8108ff43>] ? __wake_up+0x23/0x50
> >  [<ffffffff8173419b>] _raw_spin_lock_irqsave+0x4b/0x90
> >  [<ffffffff8108ff43>] ? __wake_up+0x23/0x50
> >  [<ffffffff8108ff43>] __wake_up+0x23/0x50
> >  [<ffffffff8110d4f8>] __call_rcu_nocb_enqueue+0xa8/0xc0
> >  [<ffffffff81111450>] __call_rcu+0x140/0x820
> >  [<ffffffff8109bc8f>] ? local_clock+0x3f/0x50
> >  [<ffffffff81111bb0>] kfree_call_rcu+0x20/0x30
> >  [<ffffffff81149abf>] put_ctx+0x4f/0x70
> >  [<ffffffff81154c3e>] perf_event_exit_task+0x12e/0x230
> >  [<ffffffff81056b8d>] do_exit+0x30d/0xcc0
> >  [<ffffffff810c9af5>] ? trace_hardirqs_on_caller+0x115/0x1e0
> >  [<ffffffff810c9bcd>] ? trace_hardirqs_on+0xd/0x10
> >  [<ffffffff8105893c>] do_group_exit+0x4c/0xc0
> >  [<ffffffff810589c4>] SyS_exit_group+0x14/0x20
> >  [<ffffffff8173d4e4>] tracesys+0xdd/0xe2
> > 
> 

