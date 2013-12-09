Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187Ab3LIDgw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 22:36:52 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:50392 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932150Ab3LIDgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 22:36:51 -0500
Message-ID: <52A53ACF.6010409@linaro.org>
Date: Sun, 08 Dec 2013 19:36:47 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, tglx@linutronix.de
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: sched/timekeeping: lockdep spew
References: <52A50490.4080705@oracle.com>
In-Reply-To: <52A50490.4080705@oracle.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2013 03:45 PM, Sasha Levin wrote:
> Hi all,
>
> I've stumbled on this spew inside a KVM tools guest running latest
> -next kernel:
>
>
> [  251.100221] ======================================================
> [  251.100221] [ INFO: possible circular locking dependency detected ]
> [  251.100221] 3.13.0-rc2-next-20131206-sasha-00005-g8be2375-dirty
> #4053 Not tainted
> [  251.101967] -------------------------------------------------------
> [  251.101967] kworker/10:1/4506 is trying to acquire lock:
> [  251.101967]  (timekeeper_seq){----..}, at: [<ffffffff81160e96>]
> retrigger_next_event+0x56/0x70
> [  251.101967]
> [  251.101967] but task is already holding lock:
> [  251.101967]  (hrtimer_bases.lock#11){-.-...}, at:
> [<ffffffff81160e7c>] retrigger_next_event+0x3c/0x70
> [  251.101967]
> [  251.101967] which lock already depends on the new lock.
> [  251.101967]
> [  251.101967]
> [  251.101967] the existing dependency chain (in reverse order) is:
> [  251.101967]
> -> #5 (hrtimer_bases.lock#11){-.-...}:
> [  251.101967]        [<ffffffff81194803>] validate_chain+0x6c3/0x7b0
> [  251.101967]        [<ffffffff81194d9d>] __lock_acquire+0x4ad/0x580
> [  251.101967]        [<ffffffff81194ff2>] lock_acquire+0x182/0x1d0
> [  251.101967]        [<ffffffff84398500>] _raw_spin_lock+0x40/0x80
> [  251.101967]        [<ffffffff81161828>]
> __hrtimer_start_range_ns+0x208/0x4c0
> [  251.101967]        [<ffffffff8116a910>]
> start_bandwidth_timer+0x50/0x60
> [  251.101967]        [<ffffffff8118430e>]
> __enqueue_rt_entity+0x23e/0x290
> [  251.101967]        [<ffffffff811846db>] enqueue_rt_entity+0x6b/0x80
> [  251.101967]        [<ffffffff81184726>] enqueue_task_rt+0x36/0xb0
> [  251.101967]        [<ffffffff8116af42>] enqueue_task+0x52/0x60
> [  251.101967]        [<ffffffff8116af72>] activate_task+0x22/0x30
> [  251.101967]        [<ffffffff8116afa1>] ttwu_activate+0x21/0x50
> [  251.101967]        [<ffffffff8116b00c>] T.2138+0x3c/0x60
> [  251.101967]        [<ffffffff8116b0e6>] ttwu_queue+0xb6/0xe0
> [  251.101967]        [<ffffffff81172b34>] try_to_wake_up+0x264/0x2a0
> [  251.101967]        [<ffffffff81172bef>] wake_up_process+0x3f/0x50
> [  251.101967]        [<ffffffff81202cac>] watchdog_timer_fn+0x4c/0x1b0
> [  251.101967]        [<ffffffff81161d16>] __run_hrtimer+0x1f6/0x310
> [  251.101967]        [<ffffffff81161fc6>] hrtimer_run_queues+0x196/0x1d0
> [  251.101967]        [<ffffffff811402de>] run_local_timers+0xe/0x20
> [  251.101967]        [<ffffffff8114032d>] update_process_times+0x3d/0x80
> [  251.101967]        [<ffffffff811cbddb>] tick_periodic+0xab/0xc0
> [  251.101967]        [<ffffffff811cbe14>] tick_handle_periodic+0x24/0x80
> [  251.101967]        [<ffffffff810a760d>]
> local_apic_timer_interrupt+0x5d/0x70
> [  251.101967]        [<ffffffff843a4de5>]
> smp_apic_timer_interrupt+0x45/0x60
> [  251.101967]        [<ffffffff843a3732>] apic_timer_interrupt+0x72/0x80
> [  251.101967]        [<ffffffff81077ecd>] default_idle+0x11d/0x260
> [  251.101967]        [<ffffffff81077398>] arch_cpu_idle+0x18/0x50
> [  251.101967]        [<ffffffff811a9211>] cpu_idle_loop+0x351/0x460
> [  251.101967]        [<ffffffff811a9390>] cpu_startup_entry+0x70/0x80
> [  251.101967]        [<ffffffff810a5263>] start_secondary+0xf3/0x100
> [  251.101967]
> -> #4 (&rt_b->rt_runtime_lock){-.-...}:
> [  251.101967]        [<ffffffff81194803>] validate_chain+0x6c3/0x7b0
> [  251.101967]        [<ffffffff81194d9d>] __lock_acquire+0x4ad/0x580
> [  251.101967]        [<ffffffff81194ff2>] lock_acquire+0x182/0x1d0
> [  251.101967]        [<ffffffff84398500>] _raw_spin_lock+0x40/0x80
> [  251.101967]        [<ffffffff811842f9>]
> __enqueue_rt_entity+0x229/0x290
> [  251.101967]        [<ffffffff811846db>] enqueue_rt_entity+0x6b/0x80
> [  251.101967]        [<ffffffff81184726>] enqueue_task_rt+0x36/0xb0
> [  251.101967]        [<ffffffff8116af42>] enqueue_task+0x52/0x60
> [  251.101967]        [<ffffffff81171ebb>]
> __sched_setscheduler+0x33b/0x3f0
> [  251.101967]        [<ffffffff81171f80>]
> sched_setscheduler_nocheck+0x10/0x20
> [  251.101967]        [<ffffffff811b5e2b>]
> rcu_cpu_kthread_setup+0x2b/0x30
> [  251.101967]        [<ffffffff81166efd>] smpboot_thread_fn+0x1ed/0x2c0
> [  251.101967]        [<ffffffff8115d9e5>] kthread+0x105/0x110
> [  251.101967]        [<ffffffff843a297c>] ret_from_fork+0x7c/0xb0
> [  251.101967]
> -> #3 (&rq->lock){-.-.-.}:
> [  251.101967]        [<ffffffff81194803>] validate_chain+0x6c3/0x7b0
> [  251.101967]        [<ffffffff81194d9d>] __lock_acquire+0x4ad/0x580
> [  251.101967]        [<ffffffff81194ff2>] lock_acquire+0x182/0x1d0
> [  251.101967]        [<ffffffff84398500>] _raw_spin_lock+0x40/0x80
> [  251.101967]        [<ffffffff8116f489>] wake_up_new_task+0x149/0x270
> [  251.101967]        [<ffffffff8113002a>] do_fork+0x1ba/0x270
> [  251.101967]        [<ffffffff81130166>] kernel_thread+0x26/0x30
> [  251.101967]        [<ffffffff84387c16>] rest_init+0x26/0x150
> [  251.101967]        [<ffffffff87068377>] start_kernel+0x3b9/0x3c0
> [  251.101967]        [<ffffffff870673d9>]
> x86_64_start_reservations+0x2a/0x2c
> [  251.101967]        [<ffffffff870675ae>]
> x86_64_start_kernel+0x186/0x195
> [  251.101967]
> -> #2 (&p->pi_lock){-.-.-.}:
> [  251.101967]        [<ffffffff81194803>] validate_chain+0x6c3/0x7b0
> [  251.101967]        [<ffffffff81194d9d>] __lock_acquire+0x4ad/0x580
> [  251.101967]        [<ffffffff81194ff2>] lock_acquire+0x182/0x1d0
> [  251.101967]        [<ffffffff843986b1>]
> _raw_spin_lock_irqsave+0x91/0xd0
> [  251.101967]        [<ffffffff81172909>] try_to_wake_up+0x39/0x2a0
> [  251.101967]        [<ffffffff81172bef>] wake_up_process+0x3f/0x50
> [  251.101967]        [<ffffffff811507da>] start_worker+0x2a/0x40
> [  251.101967]        [<ffffffff81156a9d>]
> create_and_start_worker+0x4d/0x90
> [  251.101967]        [<ffffffff8708ecec>] init_workqueues+0x192/0x3cb
> [  251.101967]        [<ffffffff810020ca>] do_one_initcall+0xca/0x1e0
> [  251.101967]        [<ffffffff87067cf1>]
> kernel_init_freeable+0x2b4/0x354
> [  251.101967]        [<ffffffff84387d4e>] kernel_init+0xe/0x130
> [  251.101967]        [<ffffffff843a297c>] ret_from_fork+0x7c/0xb0
> [  251.101967]
> -> #1 (&(&pool->lock)->rlock){-.-...}:
> [  251.101967]        [<ffffffff81194803>] validate_chain+0x6c3/0x7b0
> [  251.101967]        [<ffffffff81194d9d>] __lock_acquire+0x4ad/0x580
> [  251.101967]        [<ffffffff81194ff2>] lock_acquire+0x182/0x1d0
> [  251.101967]        [<ffffffff84398500>] _raw_spin_lock+0x40/0x80
> [  251.101967]        [<ffffffff81153e69>] __queue_work+0x1a9/0x3f0
> [  251.101967]        [<ffffffff81154168>] queue_work_on+0x98/0x120
> [  251.101967]        [<ffffffff81161351>]
> clock_was_set_delayed+0x21/0x30
> [  251.101967]        [<ffffffff811c4bd1>] do_adjtimex+0x111/0x160
> [  251.101967]        [<ffffffff811e2711>] compat_sys_adjtimex+0x41/0x70
> [  251.101967]        [<ffffffff843a4b49>] ia32_sysret+0x0/0x5
> [  251.101967]

Hrm... So it looks like the clock_was_set_delayed() is no longer safe to
call while holding the timekeeper lock. Which is problematic, since
clock_was_set_delayed() was introduced to avoid exactly this sort of
problem (timekeeper->hrtimer hrtimer->timekeeper circular deadlock). But
at least yay for lockdep catching these sorts of things.

Not sure if this is really new in -next or just preexisting and hard to
trigger?

I'll have to look more closely at it tomorrow after I've had some coffee.

thanks
-john
