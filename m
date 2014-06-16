Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504AbaFPO0D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 10:26:03 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:31603 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbaFPO0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 10:26:01 -0400
Message-ID: <539EFE3A.7020700@oracle.com>
Date: Mon, 16 Jun 2014 10:24:58 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        acme@ghostprotocols.net, paulus@samba.org, Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: perf/workqueue: lockdep warning on process exit
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While fuzzing with trinity inside a KVM tools guest running the latest -next
kernel I've stumbled on the following spew:

[  430.429005] ======================================================
[  430.429005] [ INFO: possible circular locking dependency detected ]
[  430.429005] 3.15.0-next-20140613-sasha-00026-g6dd125d-dirty #654 Not tainted
[  430.429005] -------------------------------------------------------
[  430.429005] trinity-c578/9725 is trying to acquire lock:
[  430.429005] (&(&pool->lock)->rlock){-.-...}, at: __queue_work (kernel/workqueue.c:1346)
[  430.429005]
[  430.429005] but task is already holding lock:
[  430.429005] (&ctx->lock){-.....}, at: perf_event_exit_task (kernel/events/core.c:7471 kernel/events/core.c:7533)
[  430.439509]
[  430.439509] which lock already depends on the new lock.
[  430.439509]
[  430.439509]
[  430.439509] the existing dependency chain (in reverse order) is:
[  430.439509]
-> #3 (&ctx->lock){-.....}:
[  430.439509] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
[  430.439509] _raw_spin_lock (include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:151)
[  430.439509] __perf_event_task_sched_out (kernel/events/core.c:2358 kernel/events/core.c:2384)
[  430.450111] perf_event_task_sched_out (include/linux/perf_event.h:702)
[  430.450111] __schedule (kernel/sched/core.c:2138 kernel/sched/core.c:2176 kernel/sched/core.c:2300 kernel/sched/core.c:2795)
[  430.450111] preempt_schedule_irq (./arch/x86/include/asm/paravirt.h:814 kernel/sched/core.c:2912)
[  430.450111] retint_kernel (arch/x86/kernel/entry_64.S:936)
[  430.450111] syscall_trace_leave (arch/x86/kernel/ptrace.c:1531)
[  430.450111] int_check_syscall_exit_work (arch/x86/kernel/entry_64.S:590)
[  430.450111]
-> #2 (&rq->lock){-.-.-.}:
[  430.450111] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
[  430.450111] _raw_spin_lock (include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:151)
[  430.450111] wake_up_new_task (include/linux/sched.h:2889 kernel/sched/core.c:329 kernel/sched/core.c:2088)
[  430.450111] do_fork (kernel/fork.c:1628)
[  430.450111] kernel_thread (kernel/fork.c:1650)
[  430.450111] rest_init (init/main.c:405)
[  430.450111] start_kernel (init/main.c:680)
[  430.450111] x86_64_start_reservations (arch/x86/kernel/head64.c:194)
[  430.450111] x86_64_start_kernel (arch/x86/kernel/head64.c:183)
[  430.450111]
-> #1 (&p->pi_lock){-.-.-.}:
[  430.450111] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
[  430.450111] _raw_spin_lock_irqsave (include/linux/spinlock_api_smp.h:117 kernel/locking/spinlock.c:159)
[  430.450111] try_to_wake_up (kernel/sched/core.c:1666)
[  430.450111] wake_up_process (kernel/sched/core.c:1762 (discriminator 2))
[  430.450111] create_and_start_worker (include/linux/spinlock.h:353 kernel/workqueue.c:1768)
[  430.450111] init_workqueues (kernel/workqueue.c:4938)
[  430.450111] do_one_initcall (init/main.c:790)
[  430.450111] kernel_init_freeable (init/main.c:891 init/main.c:998)
[  430.450111] kernel_init (init/main.c:936)
[  430.450111] ret_from_fork (arch/x86/kernel/entry_64.S:349)
[  430.450111]
-> #0 (&(&pool->lock)->rlock){-.-...}:
[  430.450111] __lock_acquire (kernel/locking/lockdep.c:1840 kernel/locking/lockdep.c:1945 kernel/locking/lockdep.c:2131 kernel/locking/lockdep.c:3182)
[  430.450111] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
[  430.450111] _raw_spin_lock (include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:151)
[  430.450111] __queue_work (kernel/workqueue.c:1346)
[  430.450111] queue_work_on (kernel/workqueue.c:1424)
[  430.450111] free_object (lib/debugobjects.c:209)
[  430.450111] __debug_check_no_obj_freed (lib/debugobjects.c:715)
[  430.450111] debug_check_no_obj_freed (lib/debugobjects.c:727)
[  430.450111] kmem_cache_free (mm/slub.c:2683 mm/slub.c:2711)
[  430.450111] free_task (kernel/fork.c:221)
[  430.450111] __put_task_struct (kernel/fork.c:250)
[  430.450111] put_ctx (include/linux/sched.h:1855 kernel/events/core.c:898)
[  430.450111] perf_event_exit_task (kernel/events/core.c:907 kernel/events/core.c:7478 kernel/events/core.c:7533)
[  430.450111] do_exit (kernel/exit.c:766)
[  430.450111] do_group_exit (kernel/exit.c:884)
[  430.450111] get_signal_to_deliver (kernel/signal.c:2347)
[  430.450111] do_signal (arch/x86/kernel/signal.c:698)
[  430.450111] do_notify_resume (arch/x86/kernel/signal.c:751)
[  430.450111] int_signal (arch/x86/kernel/entry_64.S:600)
[  430.450111]
[  430.450111] other info that might help us debug this:
[  430.450111]
[  430.450111] Chain exists of:
&(&pool->lock)->rlock --> &rq->lock --> &ctx->lock

[  430.450111]  Possible unsafe locking scenario:
[  430.450111]
[  430.450111]        CPU0                    CPU1
[  430.450111]        ----                    ----
[  430.450111]   lock(&ctx->lock);
[  430.450111]                                lock(&rq->lock);
[  430.450111]                                lock(&ctx->lock);
[  430.450111]   lock(&(&pool->lock)->rlock);
[  430.450111]
[  430.450111]  *** DEADLOCK ***
[  430.450111]
[  430.450111] 1 lock held by trinity-c578/9725:
[  430.450111] #0: (&ctx->lock){-.....}, at: perf_event_exit_task (kernel/events/core.c:7471 kernel/events/core.c:7533)
[  430.450111]
[  430.450111] stack backtrace:
[  430.450111] CPU: 6 PID: 9725 Comm: trinity-c578 Not tainted 3.15.0-next-20140613-sasha-00026-g6dd125d-dirty #654
[  430.450111]  ffffffffadb45840 ffff880101787848 ffffffffaa511b1c 0000000000000003
[  430.450111]  ffffffffadb8a4c0 ffff880101787898 ffffffffaa5044e2 0000000000000001
[  430.450111]  ffff880101787928 ffff880101787898 ffff8800aed98cf8 ffff8800aed98000
[  430.450111] Call Trace:
[  430.450111] dump_stack (lib/dump_stack.c:52)
[  430.450111] print_circular_bug (kernel/locking/lockdep.c:1216)
[  430.450111] __lock_acquire (kernel/locking/lockdep.c:1840 kernel/locking/lockdep.c:1945 kernel/locking/lockdep.c:2131 kernel/locking/lockdep.c:3182)
[  430.450111] ? kvm_clock_read (./arch/x86/include/asm/preempt.h:90 arch/x86/kernel/kvmclock.c:86)
[  430.450111] ? sched_clock (./arch/x86/include/asm/paravirt.h:192 arch/x86/kernel/tsc.c:305)
[  430.450111] ? put_lock_stats.isra.12 (./arch/x86/include/asm/preempt.h:98 kernel/locking/lockdep.c:254)
[  430.450111] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
[  430.450111] ? __queue_work (kernel/workqueue.c:1346)
[  430.450111] ? __lock_is_held (kernel/locking/lockdep.c:3516)
[  430.450111] _raw_spin_lock (include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:151)
[  430.450111] ? __queue_work (kernel/workqueue.c:1346)
[  430.450111] __queue_work (kernel/workqueue.c:1346)
[  430.450111] queue_work_on (kernel/workqueue.c:1424)
[  430.450111] free_object (lib/debugobjects.c:209)
[  430.450111] __debug_check_no_obj_freed (lib/debugobjects.c:715)
[  430.450111] ? __this_cpu_preempt_check (lib/smp_processor_id.c:63)
[  430.450111] debug_check_no_obj_freed (lib/debugobjects.c:727)
[  430.450111] kmem_cache_free (mm/slub.c:2683 mm/slub.c:2711)
[  430.450111] ? free_task (kernel/fork.c:221)
[  430.450111] free_task (kernel/fork.c:221)
[  430.450111] __put_task_struct (kernel/fork.c:250)
[  430.450111] put_ctx (include/linux/sched.h:1855 kernel/events/core.c:898)
[  430.450111] perf_event_exit_task (kernel/events/core.c:907 kernel/events/core.c:7478 kernel/events/core.c:7533)
[  430.450111] ? preempt_count_sub (kernel/sched/core.c:2602)
[  430.450111] do_exit (kernel/exit.c:766)
[  430.450111] ? debug_smp_processor_id (lib/smp_processor_id.c:57)
[  430.450111] ? put_lock_stats.isra.12 (./arch/x86/include/asm/preempt.h:98 kernel/locking/lockdep.c:254)
[  430.450111] ? _raw_spin_unlock_irq (./arch/x86/include/asm/paravirt.h:819 include/linux/spinlock_api_smp.h:168 kernel/locking/spinlock.c:199)
[  430.450111] do_group_exit (kernel/exit.c:884)
[  430.450111] get_signal_to_deliver (kernel/signal.c:2347)
[  430.450111] ? vtime_account_user (kernel/sched/cputime.c:687)
[  430.450111] do_signal (arch/x86/kernel/signal.c:698)
[  430.450111] ? vtime_account_user (kernel/sched/cputime.c:687)
[  430.450111] ? preempt_count_sub (kernel/sched/core.c:2602)
[  430.450111] ? context_tracking_user_exit (./arch/x86/include/asm/paravirt.h:809 (discriminator 2) kernel/context_tracking.c:182 (discriminator 2))
[  430.450111] ? __this_cpu_preempt_check (lib/smp_processor_id.c:63)
[  430.450111] ? trace_hardirqs_on_caller (kernel/locking/lockdep.c:2557 kernel/locking/lockdep.c:2599)
[  430.450111] do_notify_resume (arch/x86/kernel/signal.c:751)
[  430.450111] int_signal (arch/x86/kernel/entry_64.S:600)


Thanks,
Sasha
