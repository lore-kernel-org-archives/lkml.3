Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbaHAOiD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 10:38:03 -0400
Received: from mga11.intel.com ([192.55.52.93]:20982 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303AbaHAOiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 10:38:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,780,1400050800"; 
   d="scan'208";a="570487414"
Date: Fri, 1 Aug 2014 22:37:54 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [printk] INFO: possible circular locking dependency detected
Message-ID: <20140801143754.GA9071@localhost>
References: <20140801012638.GB8729@localhost>
 <20140801103451.GC27281@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140801103451.GC27281@quack.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,

On Fri, Aug 01, 2014 at 12:34:51PM +0200, Jan Kara wrote:
>   Hello,
> 
> On Fri 01-08-14 09:26:38, Wu Fengguang wrote:
> > git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> > commit 939f04bec1a4ef6ba4370b0f34b01decc844b1b1
> > Author:     Jan Kara <jack@suse.cz>
> > AuthorDate: Wed Jun 4 16:11:37 2014 -0700
> > Commit:     Linus Torvalds <torvalds@linux-foundation.org>
> > CommitDate: Wed Jun 4 16:54:17 2014 -0700
> > 
> >     printk: enable interrupts before calling console_trylock_for_printk()
> >     
> >     We need interrupts disabled when calling console_trylock_for_printk()
> >     only so that cpu id we pass to can_use_console() remains valid (for
> >     other things console_sem provides all the exclusion we need and
> >     deadlocks on console_sem due to interrupts are impossible because we use
> >     down_trylock()).  However if we are rescheduled, we are guaranteed to
> >     run on an online cpu so we can easily just get the cpu id in
> >     can_use_console().
> >     
> >     We can lose a bit of performance when we enable interrupts in
> >     vprintk_emit() and then disable them again in console_unlock() but OTOH
> >     it can somewhat reduce interrupt latency caused by console_unlock()
> >     especially since later in the patch series we will want to spin on
> >     console_sem in console_trylock_for_printk().
> >     
> >     Signed-off-by: Jan Kara <jack@suse.cz>
> >     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> >     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
>   Thanks for report! Two notes here:
> 1) This commit has been reverted from upstream already because machines
>    with lockdep enabled were unable to boot in some cases (lockdep decided
>    to report problem and hung the machine while doing it).
> 2) This patch just makes the problem visible.
> 
>   In this particular case I think the problem is in
> clockevents_increase_min_delta(). It is calling printk() from under
> hrtimer_bases.lock and that is causing lock inversion with some scheduler
> locks.
> 
> The attached patch should fix the problem. Can you please test it (but you
> cannot use latest Linus' kernel as that has
> 939f04bec1a4ef6ba4370b0f34b01decc844b1b1 reverted)? 

I applied it immediately immediately before Linus reverting that
commit. :)

And it does the work, the circular dependency warning disappeared:

        +----------------------------------------------------+------------+------------+
        |                                                    | e84f1ab33c | 957267fe81 |
        +----------------------------------------------------+------------+------------+
        | boot_successes                                     | 175        | 256        |
        | boot_failures                                      | 25         | 44         |
        | INFO:possible_circular_locking_dependency_detected | 4          |            |
        | backtrace:SYSC_perf_event_open                     | 4          |            |
        | backtrace:SyS_perf_event_open                      | 4          |            |
        | backtrace:do_fork                                  | 4          |            |
        | backtrace:vfs_write                                | 4          |            |
        | backtrace:SyS_write                                | 4          |            |
        | BUG:kernel_boot_hang                               | 21         | 44         |
        | backtrace:event_create_dir                         | 1          |            |
        | backtrace:event_trace_init                         | 1          |            |
        | backtrace:kernel_init_freeable                     | 1          |            |
        +----------------------------------------------------+------------+------------+

Tested-by: Fengguang Wu <fengguang.wu@intel.com>

Thanks,
Fengguang

> > +----------------------------------------------------+------------+------------+------------+
> > |                                                    | bd8d7cf5b8 | 939f04bec1 | fb3ec67942 |
> > +----------------------------------------------------+------------+------------+------------+
> > | boot_successes                                     | 1159       | 280        | 41         |
> > | boot_failures                                      | 41         | 20         | 5          |
> > | BUG:kernel_boot_hang                               | 41         | 13         | 3          |
> > | INFO:possible_circular_locking_dependency_detected | 0          | 7          | 2          |
> > | backtrace:do_fork                                  | 0          | 7          | 2          |
> > | backtrace:vfs_write                                | 0          | 7          | 2          |
> > | backtrace:SyS_write                                | 0          | 7          | 2          |
> > | backtrace:event_create_dir                         | 0          | 2          | 1          |
> > | backtrace:event_trace_init                         | 0          | 2          | 1          |
> > | backtrace:kernel_init_freeable                     | 0          | 3          | 1          |
> > | backtrace:SYSC_perf_event_open                     | 0          | 7          | 2          |
> > | backtrace:SyS_perf_event_open                      | 0          | 7          | 2          |
> > | backtrace:trace_create_cpu_file                    | 0          | 1          |            |
> > | backtrace:init_tracer_debugfs                      | 0          | 1          |            |
> > | backtrace:tracer_init_debugfs                      | 0          | 1          |            |
> > +----------------------------------------------------+------------+------------+------------+
> > 
> > [   29.644027] CE: hpet increased min_delta_ns to 25312 nsec
> > [   29.644027] 
> > [   29.644027] ======================================================
> > [   29.644027] [ INFO: possible circular locking dependency detected ]
> > [   29.644027] 3.15.0-rc8-06195-g939f04b #2 Not tainted
> > [   29.644027] -------------------------------------------------------
> > [   29.644027] trinity-main/74 is trying to acquire lock:
> > [   29.644027]  (&port_lock_key){-.....}, at: [<811c60be>] serial8250_console_write+0x8c/0x10c
> > [   29.644027] 
> > [   29.644027] but task is already holding lock:
> > [   29.644027]  (hrtimer_bases.lock){-.-...}, at: [<8103caeb>] hrtimer_try_to_cancel+0x13/0x66
> > [   29.644027] 
> > [   29.644027] which lock already depends on the new lock.
> > [   29.644027] 
> > [   29.644027] 
> > [   29.644027] the existing dependency chain (in reverse order) is:
> > [   29.644027] 
> > [   29.644027] -> #5 (hrtimer_bases.lock){-.-...}:
> > [   29.644027]        [<8104a942>] lock_acquire+0x92/0x101
> > [   29.644027]        [<8142f11d>] _raw_spin_lock_irqsave+0x2e/0x3e
> > [   29.644027]        [<8103c918>] __hrtimer_start_range_ns+0x1c/0x197
> > [   29.644027]        [<8107ec20>] perf_swevent_start_hrtimer.part.41+0x7a/0x85
> > [   29.644027]        [<81080792>] task_clock_event_start+0x3a/0x3f
> > [   29.644027]        [<810807a4>] task_clock_event_add+0xd/0x14
> > [   29.644027]        [<8108259a>] event_sched_in+0xb6/0x17a
> > [   29.644027]        [<810826a2>] group_sched_in+0x44/0x122
> > [   29.644027]        [<81082885>] ctx_sched_in.isra.67+0x105/0x11f
> > [   29.644027]        [<810828e6>] perf_event_sched_in.isra.70+0x47/0x4b
> > [   29.644027]        [<81082bf6>] __perf_install_in_context+0x8b/0xa3
> > [   29.644027]        [<8107eb8e>] remote_function+0x12/0x2a
> > [   29.644027]        [<8105f5af>] smp_call_function_single+0x2d/0x53
> > [   29.644027]        [<8107e17d>] task_function_call+0x30/0x36
> > [   29.644027]        [<8107fb82>] perf_install_in_context+0x87/0xbb
> > [   29.644027]        [<810852c9>] SYSC_perf_event_open+0x5c6/0x701
> > [   29.644027]        [<810856f9>] SyS_perf_event_open+0x17/0x19
> > [   29.644027]        [<8142f8ee>] syscall_call+0x7/0xb
> > [   29.644027] 
> > [   29.644027] -> #4 (&ctx->lock){......}:
> > [   29.644027]        [<8104a942>] lock_acquire+0x92/0x101
> > [   29.644027]        [<8142f04c>] _raw_spin_lock+0x21/0x30
> > [   29.644027]        [<81081df3>] __perf_event_task_sched_out+0x1dc/0x34f
> > [   29.644027]        [<8142cacc>] __schedule+0x4c6/0x4cb
> > [   29.644027]        [<8142cae0>] schedule+0xf/0x11
> > [   29.644027]        [<8142f9a6>] work_resched+0x5/0x30
> > [   29.644027] 
> > [   29.644027] -> #3 (&rq->lock){-.-.-.}:
> > [   29.644027]        [<8104a942>] lock_acquire+0x92/0x101
> > [   29.644027]        [<8142f04c>] _raw_spin_lock+0x21/0x30
> > [   29.644027]        [<81040873>] __task_rq_lock+0x33/0x3a
> > [   29.644027]        [<8104184c>] wake_up_new_task+0x25/0xc2
> > [   29.644027]        [<8102474b>] do_fork+0x15c/0x2a0
> > [   29.644027]        [<810248a9>] kernel_thread+0x1a/0x1f
> > [   29.644027]        [<814232a2>] rest_init+0x1a/0x10e
> > [   29.644027]        [<817af949>] start_kernel+0x303/0x308
> > [   29.644027]        [<817af2ab>] i386_start_kernel+0x79/0x7d
> > [   29.644027] 
> > [   29.644027] -> #2 (&p->pi_lock){-.-...}:
> > [   29.644027]        [<8104a942>] lock_acquire+0x92/0x101
> > [   29.644027]        [<8142f11d>] _raw_spin_lock_irqsave+0x2e/0x3e
> > [   29.644027]        [<810413dd>] try_to_wake_up+0x1d/0xd6
> > [   29.644027]        [<810414cd>] default_wake_function+0xb/0xd
> > [   29.644027]        [<810461f3>] __wake_up_common+0x39/0x59
> > [   29.644027]        [<81046346>] __wake_up+0x29/0x3b
> > [   29.644027]        [<811b8733>] tty_wakeup+0x49/0x51
> > [   29.644027]        [<811c3568>] uart_write_wakeup+0x17/0x19
> > [   29.644027]        [<811c5dc1>] serial8250_tx_chars+0xbc/0xfb
> > [   29.644027]        [<811c5f28>] serial8250_handle_irq+0x54/0x6a
> > [   29.644027]        [<811c5f57>] serial8250_default_handle_irq+0x19/0x1c
> > [   29.644027]        [<811c56d8>] serial8250_interrupt+0x38/0x9e
> > [   29.644027]        [<810510e7>] handle_irq_event_percpu+0x5f/0x1e2
> > [   29.644027]        [<81051296>] handle_irq_event+0x2c/0x43
> > [   29.644027]        [<81052cee>] handle_level_irq+0x57/0x80
> > [   29.644027]        [<81002a72>] handle_irq+0x46/0x5c
> > [   29.644027]        [<810027df>] do_IRQ+0x32/0x89
> > [   29.644027]        [<8143036e>] common_interrupt+0x2e/0x33
> > [   29.644027]        [<8142f23c>] _raw_spin_unlock_irqrestore+0x3f/0x49
> > [   29.644027]        [<811c25a4>] uart_start+0x2d/0x32
> > [   29.644027]        [<811c2c04>] uart_write+0xc7/0xd6
> > [   29.644027]        [<811bc6f6>] n_tty_write+0xb8/0x35e
> > [   29.644027]        [<811b9beb>] tty_write+0x163/0x1e4
> > [   29.644027]        [<811b9cd9>] redirected_tty_write+0x6d/0x75
> > [   29.644027]        [<810b6ed6>] vfs_write+0x75/0xb0
> > [   29.644027]        [<810b7265>] SyS_write+0x44/0x77
> > [   29.644027]        [<8142f8ee>] syscall_call+0x7/0xb
> > [   29.644027] 
> > [   29.644027] -> #1 (&tty->write_wait){-.....}:
> > [   29.644027]        [<8104a942>] lock_acquire+0x92/0x101
> > [   29.644027]        [<8142f11d>] _raw_spin_lock_irqsave+0x2e/0x3e
> > [   29.644027]        [<81046332>] __wake_up+0x15/0x3b
> > [   29.644027]        [<811b8733>] tty_wakeup+0x49/0x51
> > [   29.644027]        [<811c3568>] uart_write_wakeup+0x17/0x19
> > [   29.644027]        [<811c5dc1>] serial8250_tx_chars+0xbc/0xfb
> > [   29.644027]        [<811c5f28>] serial8250_handle_irq+0x54/0x6a
> > [   29.644027]        [<811c5f57>] serial8250_default_handle_irq+0x19/0x1c
> > [   29.644027]        [<811c56d8>] serial8250_interrupt+0x38/0x9e
> > [   29.644027]        [<810510e7>] handle_irq_event_percpu+0x5f/0x1e2
> > [   29.644027]        [<81051296>] handle_irq_event+0x2c/0x43
> > [   29.644027]        [<81052cee>] handle_level_irq+0x57/0x80
> > [   29.644027]        [<81002a72>] handle_irq+0x46/0x5c
> > [   29.644027]        [<810027df>] do_IRQ+0x32/0x89
> > [   29.644027]        [<8143036e>] common_interrupt+0x2e/0x33
> > [   29.644027]        [<8142f23c>] _raw_spin_unlock_irqrestore+0x3f/0x49
> > [   29.644027]        [<811c25a4>] uart_start+0x2d/0x32
> > [   29.644027]        [<811c2c04>] uart_write+0xc7/0xd6
> > [   29.644027]        [<811bc6f6>] n_tty_write+0xb8/0x35e
> > [   29.644027]        [<811b9beb>] tty_write+0x163/0x1e4
> > [   29.644027]        [<811b9cd9>] redirected_tty_write+0x6d/0x75
> > [   29.644027]        [<810b6ed6>] vfs_write+0x75/0xb0
> > [   29.644027]        [<810b7265>] SyS_write+0x44/0x77
> > [   29.644027]        [<8142f8ee>] syscall_call+0x7/0xb
> > [   29.644027] 
> > [   29.644027] -> #0 (&port_lock_key){-.....}:
> > [   29.644027]        [<8104a62d>] __lock_acquire+0x9ea/0xc6d
> > [   29.644027]        [<8104a942>] lock_acquire+0x92/0x101
> > [   29.644027]        [<8142f11d>] _raw_spin_lock_irqsave+0x2e/0x3e
> > [   29.644027]        [<811c60be>] serial8250_console_write+0x8c/0x10c
> > [   29.644027]        [<8104e402>] call_console_drivers.constprop.31+0x87/0x118
> > [   29.644027]        [<8104f5d5>] console_unlock+0x1d7/0x398
> > [   29.644027]        [<8104fb70>] vprintk_emit+0x3da/0x3e4
> > [   29.644027]        [<81425f76>] printk+0x17/0x19
> > [   29.644027]        [<8105bfa0>] clockevents_program_min_delta+0x104/0x116
> > [   29.644027]        [<8105c548>] clockevents_program_event+0xe7/0xf3
> > [   29.644027]        [<8105cc1c>] tick_program_event+0x1e/0x23
> > [   29.644027]        [<8103c43c>] hrtimer_force_reprogram+0x88/0x8f
> > [   29.644027]        [<8103c49e>] __remove_hrtimer+0x5b/0x79
> > [   29.644027]        [<8103cb21>] hrtimer_try_to_cancel+0x49/0x66
> > [   29.644027]        [<8103cb4b>] hrtimer_cancel+0xd/0x18
> > [   29.644027]        [<8107f102>] perf_swevent_cancel_hrtimer.part.60+0x2b/0x30
> > [   29.644027]        [<81080705>] task_clock_event_stop+0x20/0x64
> > [   29.644027]        [<81080756>] task_clock_event_del+0xd/0xf
> > [   29.644027]        [<81081350>] event_sched_out+0xab/0x11e
> > [   29.644027]        [<810813e0>] group_sched_out+0x1d/0x66
> > [   29.644027]        [<81081682>] ctx_sched_out+0xaf/0xbf
> > [   29.644027]        [<81081e04>] __perf_event_task_sched_out+0x1ed/0x34f
> > [   29.644027]        [<8142cacc>] __schedule+0x4c6/0x4cb
> > [   29.644027]        [<8142cae0>] schedule+0xf/0x11
> > [   29.644027]        [<8142f9a6>] work_resched+0x5/0x30
> > [   29.644027] 
> > [   29.644027] other info that might help us debug this:
> > [   29.644027] 
> > [   29.644027] Chain exists of:
> > [   29.644027]   &port_lock_key --> &ctx->lock --> hrtimer_bases.lock
> > [   29.644027] 
> > [   29.644027]  Possible unsafe locking scenario:
> > [   29.644027] 
> > [   29.644027]        CPU0                    CPU1
> > [   29.644027]        ----                    ----
> > [   29.644027]   lock(hrtimer_bases.lock);
> > [   29.644027]                                lock(&ctx->lock);
> > [   29.644027]                                lock(hrtimer_bases.lock);
> > [   29.644027]   lock(&port_lock_key);
> > [   29.644027] 
> > [   29.644027]  *** DEADLOCK ***
> > [   29.644027] 
> > [   29.644027] 4 locks held by trinity-main/74:
> > [   29.644027]  #0:  (&rq->lock){-.-.-.}, at: [<8142c6f3>] __schedule+0xed/0x4cb
> > [   29.644027]  #1:  (&ctx->lock){......}, at: [<81081df3>] __perf_event_task_sched_out+0x1dc/0x34f
> > [   29.644027]  #2:  (hrtimer_bases.lock){-.-...}, at: [<8103caeb>] hrtimer_try_to_cancel+0x13/0x66
> > [   29.644027]  #3:  (console_lock){+.+...}, at: [<8104fb5d>] vprintk_emit+0x3c7/0x3e4
> > [   29.644027] 
> > [   29.644027] stack backtrace:
> > [   29.644027] CPU: 0 PID: 74 Comm: trinity-main Not tainted 3.15.0-rc8-06195-g939f04b #2
> > [   29.644027]  00000000 81c3a310 8b995c14 81426f69 8b995c44 81425a99 8161f671 8161f570
> > [   29.644027]  8161f538 8161f559 8161f538 8b995c78 8b142bb0 00000004 8b142fdc 8b142bb0
> > [   29.644027]  8b995ca8 8104a62d 8b142fac 000016f2 81c3a310 00000001 00000001 00000003
> > [   29.644027] Call Trace:
> > [   29.644027]  [<81426f69>] dump_stack+0x16/0x18
> > [   29.644027]  [<81425a99>] print_circular_bug+0x18f/0x19c
> > [   29.644027]  [<8104a62d>] __lock_acquire+0x9ea/0xc6d
> > [   29.644027]  [<8104a942>] lock_acquire+0x92/0x101
> > [   29.644027]  [<811c60be>] ? serial8250_console_write+0x8c/0x10c
> > [   29.644027]  [<811c6032>] ? wait_for_xmitr+0x76/0x76
> > [   29.644027]  [<8142f11d>] _raw_spin_lock_irqsave+0x2e/0x3e
> > [   29.644027]  [<811c60be>] ? serial8250_console_write+0x8c/0x10c
> > [   29.644027]  [<811c60be>] serial8250_console_write+0x8c/0x10c
> > [   29.644027]  [<8104af87>] ? lock_release+0x191/0x223
> > [   29.644027]  [<811c6032>] ? wait_for_xmitr+0x76/0x76
> > [   29.644027]  [<8104e402>] call_console_drivers.constprop.31+0x87/0x118
> > [   29.644027]  [<8104f5d5>] console_unlock+0x1d7/0x398
> > [   29.644027]  [<8104fb70>] vprintk_emit+0x3da/0x3e4
> > [   29.644027]  [<81425f76>] printk+0x17/0x19
> > [   29.644027]  [<8105bfa0>] clockevents_program_min_delta+0x104/0x116
> > [   29.644027]  [<8105c548>] clockevents_program_event+0xe7/0xf3
> > [   29.644027]  [<8105cc1c>] tick_program_event+0x1e/0x23
> > [   29.644027]  [<8103c43c>] hrtimer_force_reprogram+0x88/0x8f
> > [   29.644027]  [<8103c49e>] __remove_hrtimer+0x5b/0x79
> > [   29.644027]  [<8103cb21>] hrtimer_try_to_cancel+0x49/0x66
> > [   29.644027]  [<8103cb4b>] hrtimer_cancel+0xd/0x18
> > [   29.644027]  [<8107f102>] perf_swevent_cancel_hrtimer.part.60+0x2b/0x30
> > [   29.644027]  [<81080705>] task_clock_event_stop+0x20/0x64
> > [   29.644027]  [<81080756>] task_clock_event_del+0xd/0xf
> > [   29.644027]  [<81081350>] event_sched_out+0xab/0x11e
> > [   29.644027]  [<810813e0>] group_sched_out+0x1d/0x66
> > [   29.644027]  [<81081682>] ctx_sched_out+0xaf/0xbf
> > [   29.644027]  [<81081e04>] __perf_event_task_sched_out+0x1ed/0x34f
> > [   29.644027]  [<8104416d>] ? __dequeue_entity+0x23/0x27
> > [   29.644027]  [<81044505>] ? pick_next_task_fair+0xb1/0x120
> > [   29.644027]  [<8142cacc>] __schedule+0x4c6/0x4cb
> > [   29.644027]  [<81047574>] ? trace_hardirqs_off_caller+0xd7/0x108
> > [   29.644027]  [<810475b0>] ? trace_hardirqs_off+0xb/0xd
> > [   29.644027]  [<81056346>] ? rcu_irq_exit+0x64/0x77
> > 
> > git bisect start 9f6226a762c7ae02f6a23a3d4fc552dafa57ea23 v3.15 --
> > git bisect  bad 71998d1be4ae70e7d320cdd21595c1a02a29c61e  # 01:13     79-      5  Merge branch 'x86-irq-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> > git bisect  bad 9ee4d7a6538308a7681b638d2f35f2a301420355  # 01:24      3-      1  Merge branch 'akpm' (patches from Andrew Morton)
> > git bisect  bad 9894e6d9c020b754dd962960e9f7eac18282f69f  # 01:58    128-      5  Merge tag 'fbdev-omap-dt-3.16' of git://git.kernel.org/pub/scm/linux/kernel/git/tomba/linux
> > git bisect  bad 963649d735c8b6eb0f97e82c54f02426ff3f1f45  # 02:06     48-      3  Merge tag 'for-linus-3.16-merge-window' of git://git.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs
> > git bisect  bad b20dcab9d4589ef9918a13c888c5493945adfc13  # 02:13     35-      1  Merge tag 'llvmlinux-for-v3.16' of git://git.linuxfoundation.org/llvmlinux/kernel
> > git bisect  bad 3f17ea6dea8ba5668873afa54628a91aaa3fb1c0  # 02:19     58-      4  Merge branch 'next' (accumulated 3.16 merge window patches) into master
> > git bisect good 49eb7b0750d9483c74e9c14ae6ea1e9d62481c3c  # 02:35    300+      7  Merge tag 'tty-3.16-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty into next
> > git bisect good 15b588303155b22edd559672905db8e59a44ef9a  # 02:51    300+      0  Merge tag 'fbdev-omap-3.16' of git://git.kernel.org/pub/scm/linux/kernel/git/tomba/linux into next
> > git bisect good d09cc3659db494aca4b3bb2393c533fb4946b794  # 03:19    300+      1  Merge branch 'irq-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip into next
> > git bisect  bad cc07aabc53978ae09a1d539237189f7c9841060a  # 03:37     66-      2  Merge tag 'arm64-upstream' of git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux into next
> > git bisect  bad 8091b895b76f690aa2f6689b6ed602f07525a938  # 04:55    103-      1  fs/ncpfs/getopt.c: replace simple_strtoul by kstrtoul
> > git bisect good d53aea3d46d64e95da9952887969f7533b9ab25e  # 05:59    300+     19  mm, compaction: return failed migration target pages back to freelist
> > git bisect good 72d09633c9afa02bea317d65eb8b8a4ce7659a2a  # 06:31    300+     10  mm/zswap: NUMA aware allocation for zswap_dstmem
> > git bisect  bad 0046dd9fed0c9313cbb4fb860324476cd298dc9f  # 06:35     42-      1  lib/string.c: use the name "C-string" in comments
> > git bisect good 0a581694ab7a5bc083d710df8a552a6a055b005f  # 06:54    300+     15  printk: split code for making free space in the log buffer
> > git bisect  bad 939f04bec1a4ef6ba4370b0f34b01decc844b1b1  # 06:58     46-      2  printk: enable interrupts before calling console_trylock_for_printk()
> > git bisect good 034633ccb24d675850f99bf85c1c5880c831e4b6  # 07:16    300+     28  printk: return really stored message length
> > git bisect good 608873cacb9d0d2811586fcc79a38b64eabd6d32  # 07:29    300+     22  printk: release lockbuf_lock before calling console_trylock_for_printk()
> > git bisect good bd8d7cf5b8410fe98eba06a9aaa90efe88815d8a  # 07:42    300+      7  printk: fix lockdep instrumentation of console_sem
> > # first bad commit: [939f04bec1a4ef6ba4370b0f34b01decc844b1b1] printk: enable interrupts before calling console_trylock_for_printk()
> > git bisect good bd8d7cf5b8410fe98eba06a9aaa90efe88815d8a  # 08:21    900+     41  printk: fix lockdep instrumentation of console_sem
> > git bisect  bad fb3ec67942e92e5713e05b7691b277d0a0c0575d  # 08:21      0-      5  KVM: arm64: GICv3: mandate page-aligned GICV region
> > git bisect good 6f0928036bcbd8dd2ebee9201580da8bcc0a81af  # 08:49    900+     87  Merge tag 'pm+acpi-3.16-rc8' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm
> > 
> > 
> > This script may reproduce the error.
> > 
> > ----------------------------------------------------------------------------
> > #!/bin/bash
> > 
> > kernel=$1
> > initrd=quantal-core-i386.cgz
> > 
> > wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/raw/master/initrd/$initrd
> > 
> > kvm=(
> > 	qemu-system-x86_64
> > 	-enable-kvm
> > 	-cpu Haswell,+smep,+smap
> > 	-kernel $kernel
> > 	-initrd $initrd
> > 	-m 320
> > 	-smp 2
> > 	-net nic,vlan=1,model=e1000
> > 	-net user,vlan=1
> > 	-boot order=nc
> > 	-no-reboot
> > 	-watchdog i6300esb
> > 	-rtc base=localtime
> > 	-serial stdio
> > 	-display none
> > 	-monitor null 
> > )
> > 
> > append=(
> > 	hung_task_panic=1
> > 	earlyprintk=ttyS0,115200
> > 	debug
> > 	apic=debug
> > 	sysrq_always_enabled
> > 	rcupdate.rcu_cpu_stall_timeout=100
> > 	panic=10
> > 	softlockup_panic=1
> > 	nmi_watchdog=panic
> > 	prompt_ramdisk=0
> > 	console=ttyS0,115200
> > 	console=tty0
> > 	vga=normal
> > 	root=/dev/ram0
> > 	rw
> > 	drbd.minor_count=8
> > )
> > 
> > "${kvm[@]}" --append "${append[*]}"
> > ----------------------------------------------------------------------------
> 
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR

> >From 3cf8a191b7c48ba10239892efbfe830ab189e93a Mon Sep 17 00:00:00 2001
> From: Jan Kara <jack@suse.cz>
> Date: Fri, 1 Aug 2014 12:20:02 +0200
> Subject: [PATCH] timer: Fix lock inversion between hrtimer_bases.lock and
>  scheduler locks
> 
> clockevents_increase_min_delta() calls printk() from under
> hrtimer_bases.lock. That causes lock inversion on scheduler locks because
> printk() can call into the scheduler. Lockdep puts it as:
> 
> ======================================================
> [ INFO: possible circular locking dependency detected ]
> 3.15.0-rc8-06195-g939f04b #2 Not tainted
> -------------------------------------------------------
> trinity-main/74 is trying to acquire lock:
>  (&port_lock_key){-.....}, at: [<811c60be>] serial8250_console_write+0x8c/0x10c
> 
> but task is already holding lock:
>  (hrtimer_bases.lock){-.-...}, at: [<8103caeb>] hrtimer_try_to_cancel+0x13/0x66
> 
> which lock already depends on the new lock.
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #5 (hrtimer_bases.lock){-.-...}:
>        [<8104a942>] lock_acquire+0x92/0x101
>        [<8142f11d>] _raw_spin_lock_irqsave+0x2e/0x3e
>        [<8103c918>] __hrtimer_start_range_ns+0x1c/0x197
>        [<8107ec20>] perf_swevent_start_hrtimer.part.41+0x7a/0x85
>        [<81080792>] task_clock_event_start+0x3a/0x3f
>        [<810807a4>] task_clock_event_add+0xd/0x14
>        [<8108259a>] event_sched_in+0xb6/0x17a
>        [<810826a2>] group_sched_in+0x44/0x122
>        [<81082885>] ctx_sched_in.isra.67+0x105/0x11f
>        [<810828e6>] perf_event_sched_in.isra.70+0x47/0x4b
>        [<81082bf6>] __perf_install_in_context+0x8b/0xa3
>        [<8107eb8e>] remote_function+0x12/0x2a
>        [<8105f5af>] smp_call_function_single+0x2d/0x53
>        [<8107e17d>] task_function_call+0x30/0x36
>        [<8107fb82>] perf_install_in_context+0x87/0xbb
>        [<810852c9>] SYSC_perf_event_open+0x5c6/0x701
>        [<810856f9>] SyS_perf_event_open+0x17/0x19
>        [<8142f8ee>] syscall_call+0x7/0xb
> 
> -> #4 (&ctx->lock){......}:
>        [<8104a942>] lock_acquire+0x92/0x101
>        [<8142f04c>] _raw_spin_lock+0x21/0x30
>        [<81081df3>] __perf_event_task_sched_out+0x1dc/0x34f
>        [<8142cacc>] __schedule+0x4c6/0x4cb
>        [<8142cae0>] schedule+0xf/0x11
>        [<8142f9a6>] work_resched+0x5/0x30
> 
> -> #3 (&rq->lock){-.-.-.}:
>        [<8104a942>] lock_acquire+0x92/0x101
>        [<8142f04c>] _raw_spin_lock+0x21/0x30
>        [<81040873>] __task_rq_lock+0x33/0x3a
>        [<8104184c>] wake_up_new_task+0x25/0xc2
>        [<8102474b>] do_fork+0x15c/0x2a0
>        [<810248a9>] kernel_thread+0x1a/0x1f
>        [<814232a2>] rest_init+0x1a/0x10e
>        [<817af949>] start_kernel+0x303/0x308
>        [<817af2ab>] i386_start_kernel+0x79/0x7d
> 
> -> #2 (&p->pi_lock){-.-...}:
>        [<8104a942>] lock_acquire+0x92/0x101
>        [<8142f11d>] _raw_spin_lock_irqsave+0x2e/0x3e
>        [<810413dd>] try_to_wake_up+0x1d/0xd6
>        [<810414cd>] default_wake_function+0xb/0xd
>        [<810461f3>] __wake_up_common+0x39/0x59
>        [<81046346>] __wake_up+0x29/0x3b
>        [<811b8733>] tty_wakeup+0x49/0x51
>        [<811c3568>] uart_write_wakeup+0x17/0x19
>        [<811c5dc1>] serial8250_tx_chars+0xbc/0xfb
>        [<811c5f28>] serial8250_handle_irq+0x54/0x6a
>        [<811c5f57>] serial8250_default_handle_irq+0x19/0x1c
>        [<811c56d8>] serial8250_interrupt+0x38/0x9e
>        [<810510e7>] handle_irq_event_percpu+0x5f/0x1e2
>        [<81051296>] handle_irq_event+0x2c/0x43
>        [<81052cee>] handle_level_irq+0x57/0x80
>        [<81002a72>] handle_irq+0x46/0x5c
>        [<810027df>] do_IRQ+0x32/0x89
>        [<8143036e>] common_interrupt+0x2e/0x33
>        [<8142f23c>] _raw_spin_unlock_irqrestore+0x3f/0x49
>        [<811c25a4>] uart_start+0x2d/0x32
>        [<811c2c04>] uart_write+0xc7/0xd6
>        [<811bc6f6>] n_tty_write+0xb8/0x35e
>        [<811b9beb>] tty_write+0x163/0x1e4
>        [<811b9cd9>] redirected_tty_write+0x6d/0x75
>        [<810b6ed6>] vfs_write+0x75/0xb0
>        [<810b7265>] SyS_write+0x44/0x77
>        [<8142f8ee>] syscall_call+0x7/0xb
> 
> -> #1 (&tty->write_wait){-.....}:
>        [<8104a942>] lock_acquire+0x92/0x101
>        [<8142f11d>] _raw_spin_lock_irqsave+0x2e/0x3e
>        [<81046332>] __wake_up+0x15/0x3b
>        [<811b8733>] tty_wakeup+0x49/0x51
>        [<811c3568>] uart_write_wakeup+0x17/0x19
>        [<811c5dc1>] serial8250_tx_chars+0xbc/0xfb
>        [<811c5f28>] serial8250_handle_irq+0x54/0x6a
>        [<811c5f57>] serial8250_default_handle_irq+0x19/0x1c
>        [<811c56d8>] serial8250_interrupt+0x38/0x9e
>        [<810510e7>] handle_irq_event_percpu+0x5f/0x1e2
>        [<81051296>] handle_irq_event+0x2c/0x43
>        [<81052cee>] handle_level_irq+0x57/0x80
>        [<81002a72>] handle_irq+0x46/0x5c
>        [<810027df>] do_IRQ+0x32/0x89
>        [<8143036e>] common_interrupt+0x2e/0x33
>        [<8142f23c>] _raw_spin_unlock_irqrestore+0x3f/0x49
>        [<811c25a4>] uart_start+0x2d/0x32
>        [<811c2c04>] uart_write+0xc7/0xd6
>        [<811bc6f6>] n_tty_write+0xb8/0x35e
>        [<811b9beb>] tty_write+0x163/0x1e4
>        [<811b9cd9>] redirected_tty_write+0x6d/0x75
>        [<810b6ed6>] vfs_write+0x75/0xb0
>        [<810b7265>] SyS_write+0x44/0x77
>        [<8142f8ee>] syscall_call+0x7/0xb
> 
> -> #0 (&port_lock_key){-.....}:
>        [<8104a62d>] __lock_acquire+0x9ea/0xc6d
>        [<8104a942>] lock_acquire+0x92/0x101
>        [<8142f11d>] _raw_spin_lock_irqsave+0x2e/0x3e
>        [<811c60be>] serial8250_console_write+0x8c/0x10c
>        [<8104e402>] call_console_drivers.constprop.31+0x87/0x118
>        [<8104f5d5>] console_unlock+0x1d7/0x398
>        [<8104fb70>] vprintk_emit+0x3da/0x3e4
>        [<81425f76>] printk+0x17/0x19
>        [<8105bfa0>] clockevents_program_min_delta+0x104/0x116
>        [<8105c548>] clockevents_program_event+0xe7/0xf3
>        [<8105cc1c>] tick_program_event+0x1e/0x23
>        [<8103c43c>] hrtimer_force_reprogram+0x88/0x8f
>        [<8103c49e>] __remove_hrtimer+0x5b/0x79
>        [<8103cb21>] hrtimer_try_to_cancel+0x49/0x66
>        [<8103cb4b>] hrtimer_cancel+0xd/0x18
>        [<8107f102>] perf_swevent_cancel_hrtimer.part.60+0x2b/0x30
>        [<81080705>] task_clock_event_stop+0x20/0x64
>        [<81080756>] task_clock_event_del+0xd/0xf
>        [<81081350>] event_sched_out+0xab/0x11e
>        [<810813e0>] group_sched_out+0x1d/0x66
>        [<81081682>] ctx_sched_out+0xaf/0xbf
>        [<81081e04>] __perf_event_task_sched_out+0x1ed/0x34f
>        [<8142cacc>] __schedule+0x4c6/0x4cb
>        [<8142cae0>] schedule+0xf/0x11
>        [<8142f9a6>] work_resched+0x5/0x30
> 
> other info that might help us debug this:
> 
> Chain exists of:
>   &port_lock_key --> &ctx->lock --> hrtimer_bases.lock
> 
>  Possible unsafe locking scenario:
> 
>        CPU0                    CPU1
>        ----                    ----
>   lock(hrtimer_bases.lock);
>                                lock(&ctx->lock);
>                                lock(hrtimer_bases.lock);
>   lock(&port_lock_key);
> 
>  *** DEADLOCK ***
> 
> 4 locks held by trinity-main/74:
>  #0:  (&rq->lock){-.-.-.}, at: [<8142c6f3>] __schedule+0xed/0x4cb
>  #1:  (&ctx->lock){......}, at: [<81081df3>] __perf_event_task_sched_out+0x1dc/0x34f
>  #2:  (hrtimer_bases.lock){-.-...}, at: [<8103caeb>] hrtimer_try_to_cancel+0x13/0x66
>  #3:  (console_lock){+.+...}, at: [<8104fb5d>] vprintk_emit+0x3c7/0x3e4
> 
> stack backtrace:
> CPU: 0 PID: 74 Comm: trinity-main Not tainted 3.15.0-rc8-06195-g939f04b #2
>  00000000 81c3a310 8b995c14 81426f69 8b995c44 81425a99 8161f671 8161f570
>  8161f538 8161f559 8161f538 8b995c78 8b142bb0 00000004 8b142fdc 8b142bb0
>  8b995ca8 8104a62d 8b142fac 000016f2 81c3a310 00000001 00000001 00000003
> Call Trace:
>  [<81426f69>] dump_stack+0x16/0x18
>  [<81425a99>] print_circular_bug+0x18f/0x19c
>  [<8104a62d>] __lock_acquire+0x9ea/0xc6d
>  [<8104a942>] lock_acquire+0x92/0x101
>  [<811c60be>] ? serial8250_console_write+0x8c/0x10c
>  [<811c6032>] ? wait_for_xmitr+0x76/0x76
>  [<8142f11d>] _raw_spin_lock_irqsave+0x2e/0x3e
>  [<811c60be>] ? serial8250_console_write+0x8c/0x10c
>  [<811c60be>] serial8250_console_write+0x8c/0x10c
>  [<8104af87>] ? lock_release+0x191/0x223
>  [<811c6032>] ? wait_for_xmitr+0x76/0x76
>  [<8104e402>] call_console_drivers.constprop.31+0x87/0x118
>  [<8104f5d5>] console_unlock+0x1d7/0x398
>  [<8104fb70>] vprintk_emit+0x3da/0x3e4
>  [<81425f76>] printk+0x17/0x19
>  [<8105bfa0>] clockevents_program_min_delta+0x104/0x116
>  [<8105cc1c>] tick_program_event+0x1e/0x23
>  [<8103c43c>] hrtimer_force_reprogram+0x88/0x8f
>  [<8103c49e>] __remove_hrtimer+0x5b/0x79
>  [<8103cb21>] hrtimer_try_to_cancel+0x49/0x66
>  [<8103cb4b>] hrtimer_cancel+0xd/0x18
>  [<8107f102>] perf_swevent_cancel_hrtimer.part.60+0x2b/0x30
>  [<81080705>] task_clock_event_stop+0x20/0x64
>  [<81080756>] task_clock_event_del+0xd/0xf
>  [<81081350>] event_sched_out+0xab/0x11e
>  [<810813e0>] group_sched_out+0x1d/0x66
>  [<81081682>] ctx_sched_out+0xaf/0xbf
>  [<81081e04>] __perf_event_task_sched_out+0x1ed/0x34f
>  [<8104416d>] ? __dequeue_entity+0x23/0x27
>  [<81044505>] ? pick_next_task_fair+0xb1/0x120
>  [<8142cacc>] __schedule+0x4c6/0x4cb
>  [<81047574>] ? trace_hardirqs_off_caller+0xd7/0x108
>  [<810475b0>] ? trace_hardirqs_off+0xb/0xd
>  [<81056346>] ? rcu_irq_exit+0x64/0x77
> 
> Fix the problem by using printk_deferred() which does not call into the
> scheduler.
> 
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  kernel/time/clockevents.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
> index ad362c260ef4..9c94c19f1305 100644
> --- a/kernel/time/clockevents.c
> +++ b/kernel/time/clockevents.c
> @@ -146,7 +146,8 @@ static int clockevents_increase_min_delta(struct clock_event_device *dev)
>  {
>  	/* Nothing to do if we already reached the limit */
>  	if (dev->min_delta_ns >= MIN_DELTA_LIMIT) {
> -		printk(KERN_WARNING "CE: Reprogramming failure. Giving up\n");
> +		printk_deferred(KERN_WARNING
> +				"CE: Reprogramming failure. Giving up\n");
>  		dev->next_event.tv64 = KTIME_MAX;
>  		return -ETIME;
>  	}
> @@ -159,9 +160,10 @@ static int clockevents_increase_min_delta(struct clock_event_device *dev)
>  	if (dev->min_delta_ns > MIN_DELTA_LIMIT)
>  		dev->min_delta_ns = MIN_DELTA_LIMIT;
>  
> -	printk(KERN_WARNING "CE: %s increased min_delta_ns to %llu nsec\n",
> -	       dev->name ? dev->name : "?",
> -	       (unsigned long long) dev->min_delta_ns);
> +	printk_deferred(KERN_WARNING
> +			"CE: %s increased min_delta_ns to %llu nsec\n",
> +			dev->name ? dev->name : "?",
> +			(unsigned long long) dev->min_delta_ns);
>  	return 0;
>  }
>  
> -- 
> 1.8.1.4
> 

