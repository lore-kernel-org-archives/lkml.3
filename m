Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139AbaFKXaP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 19:30:15 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:44032 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671AbaFKXaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 19:30:14 -0400
MIME-Version: 1.0
In-Reply-To: <5398E07C.6030107@oracle.com>
References: <5398E07C.6030107@oracle.com>
Date: Wed, 11 Jun 2014 16:30:12 -0700
Message-ID: <CALAqxLWa-ZrL48ZooecxqHRg91mPc4ju-5k5b3cQqqHdJp+ptA@mail.gmail.com>
Subject: Re: timekeeping: exiting task with held timekeeping locks
From: John Stultz <john.stultz@linaro.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Dave Jones <davej@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 4:04 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
> Hi all,
>
> While fuzzing with trinity inside a KVM tools guest running the latest -next
> kernel I've stumbled on the following spew:
>
> [ 3460.136058] =====================================
> [ 3460.138017] [ BUG: trinity-c70/27193 still has locks held! ]
> [ 3460.141491] 3.15.0-next-20140611-sasha-00022-g9466d2f-dirty #638 Not tainted
> [ 3460.143219] -------------------------------------
> [ 3460.167979] 2 locks held by trinity-c70/27193:
> [ 3460.169172] #0: (tick_broadcast_lock){-.-.-.}, at: tick_handle_periodic_broadcast (kernel/time/tick-broadcast.c:301)
> [ 3460.468004] #1: (timekeeper_lock){-.-.-.}, at: update_wall_time (kernel/time/timekeeping.c:1371)
> [ 3460.920025]
> [ 3460.920025] stack backtrace:
> [ 3460.928146] CPU: 0 PID: 27193 Comm: trinity-c70 Not tainted 3.15.0-next-20140611-sasha-00022-g9466d2f-dirty #638
> [ 3460.928648] can: request_module (can-proto-3) failed.
> [ 3460.943111]  ffff8800576ef4c8 ffff8800576efc88 ffffffffa551093c 0000000000000001
> [ 3460.962511]  ffff880056f9b000 ffff8800576efca8 ffffffffa21c6a43 ffff880056f9bbe8
> [ 3461.007184]  ffff880056f9bbe8 ffff8800576efd48
> [ 3461.017661] can: request_module (can-proto-0) failed.
> [ 3461.045536]  ffffffffa21636ea ffff8800576efcc8
> [ 3461.170992] Call Trace:
> [ 3461.174122] dump_stack (lib/dump_stack.c:52)
> [ 3461.558864] debug_check_no_locks_held (kernel/locking/lockdep.c:4107 kernel/locking/lockdep.c:4113)
> [ 3461.577066] do_exit (kernel/exit.c:796)
> [ 3461.592523] ? debug_smp_processor_id (lib/smp_processor_id.c:57)
> [ 3461.629067] ? _raw_spin_unlock_irq (./arch/x86/include/asm/paravirt.h:819 include/linux/spinlock_api_smp.h:168 kernel/locking/spinlock.c:199)
> [ 3461.671525] do_group_exit (kernel/exit.c:884)
> [ 3461.717091] get_signal_to_deliver (kernel/signal.c:2347)
> [ 3461.724142] ? vtime_account_user (kernel/sched/cputime.c:687)
> [ 3461.800505] do_signal (arch/x86/kernel/signal.c:698)
> [ 3461.808792] ? vtime_account_user (kernel/sched/cputime.c:687)
> [ 3461.812780] ? preempt_count_sub (kernel/sched/core.c:2602)
> [ 3461.824601] ? context_tracking_user_exit (./arch/x86/include/asm/paravirt.h:809 (discriminator 2) kernel/context_tracking.c:182 (discriminator 2))
> [ 3461.827619] ? __this_cpu_preempt_check (lib/smp_processor_id.c:63)
> [ 3461.831486] ? trace_hardirqs_on_caller (kernel/locking/lockdep.c:2557 kernel/locking/lockdep.c:2599)
> [ 3461.841516] do_notify_resume (arch/x86/kernel/signal.c:751)
> [ 3461.847056] retint_signal (arch/x86/kernel/entry_64.S:921)


Huh.. Got me.. I don't see how the task can get out of
update_wall_time() w/o releasing the timekeeper_lock. Same with the
tick_broadcast_lock.  Does this happen all the time or was this a
one-off?

Peter/Ingo: Am I misinterpreting what this warning is saying?

thanks
-john
