Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758AbaC0PeG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 11:34:06 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:18991 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756516AbaC0PeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 11:34:03 -0400
Message-ID: <533444AF.2070402@oracle.com>
Date: Thu, 27 Mar 2014 11:33:03 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
CC: acme@ghostprotocols.net, paulus@samba.org,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: sched: possible deadlock between fair sched and perf
References: <53343FA5.2080100@oracle.com>
In-Reply-To: <53343FA5.2080100@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2014 11:11 AM, Sasha Levin wrote:
> Hi all,
>
> While fuzzing with trinity inside a KVM tools guest running latest -next
> kernel I've stumbled on the following:

And another similar trace from a different vm:

[ 2696.454601] ======================================================
[ 2696.455460] [ INFO: possible circular locking dependency detected ]
[ 2696.456327] 3.14.0-rc8-next-20140326-sasha-00018-gffbc974-dirty #285 Not tainted
[ 2696.457227] -------------------------------------------------------
[ 2696.457898] trinity-c31/26818 is trying to acquire lock:
[ 2696.458495]  (&(&pool->lock)->rlock){-.-.-.}, at: __queue_work (kernel/workqueue.c:1358)
[ 2696.459829]
[ 2696.459829] but task is already holding lock:
[ 2696.460315]  (&ctx->lock){-.-...}, at: perf_event_exit_task (kernel/events/core.c:7415 kernel/events/core.c:7492)
[ 2696.461706]
[ 2696.461706] which lock already depends on the new lock.
[ 2696.461706]
[ 2696.461706]
[ 2696.461706] the existing dependency chain (in reverse order) is:
[ 2696.461706]
-> #3 (&ctx->lock){-.-...}:
[ 2696.461706]        lock_acquire (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
[ 2696.461706]        _raw_spin_lock (include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:151)
[ 2696.461706]        __perf_event_task_sched_out (kernel/events/core.c:2340 kernel/events/core.c:2366)
[ 2696.461706]        perf_event_task_sched_out (include/linux/perf_event.h:689)
[ 2696.461706]        __schedule (kernel/sched/core.c:2064 kernel/sched/core.c:2102 kernel/sched/core.c:2226 kernel/sched/core.c:2713)
[ 2696.461706]        preempt_schedule (arch/x86/include/asm/preempt.h:80 kernel/sched/core.c:2798)
[ 2696.461706]        ___preempt_schedule (arch/x86/kernel/preempt.S:11)
[ 2696.461706]        text_poke_bp (arch/x86/kernel/alternative.c:655)
[ 2696.461706]        arch_jump_label_transform (arch/x86/kernel/jump_label.c:111)
[ 2696.461706]        __jump_label_update (kernel/jump_label.c:177)
[ 2696.461706]        jump_label_update (kernel/jump_label.c:458)
[ 2696.461706]        static_key_slow_inc (kernel/jump_label.c:68)
[ 2696.461706]        tracepoint_update_probe_range (kernel/tracepoint.c:278 kernel/tracepoint.c:319)
[ 2696.461706]        tracepoint_update_probes (kernel/tracepoint.c:354)
[ 2696.461706]        tracepoint_probe_register (kernel/tracepoint.c:407)
[ 2696.461706]        syscall_exit_register (kernel/trace/trace_syscalls.c:681 kernel/trace/trace_syscalls.c:750)
[ 2696.461706]        perf_trace_init (kernel/trace/trace_event_perf.c:108 kernel/trace/trace_event_perf.c:182 kernel/trace/trace_event_perf.c:206)
[ 2696.461706]        perf_tp_event_init (kernel/events/core.c:5937)
[ 2696.461706]        perf_init_event (kernel/events/core.c:6598)
[ 2696.461706]        perf_event_alloc (kernel/events/core.c:6754)
[ 2696.461706]        SYSC_perf_event_open (kernel/events/core.c:7062)
[ 2696.461706]        SyS_perf_event_open (kernel/events/core.c:6990)
[ 2696.461706]        tracesys (arch/x86/kernel/entry_64.S:749)
[ 2696.461706]
-> #2 (&rq->lock){-.-.-.}:
[ 2696.461706]        lock_acquire (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
[ 2696.461706]        _raw_spin_lock (include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:151)
[ 2696.461706]        wake_up_new_task (include/linux/sched.h:2884 kernel/sched/core.c:313 kernel/sched/core.c:2014)
[ 2696.461706]        do_fork (kernel/fork.c:1627)
[ 2696.461706]        kernel_thread (kernel/fork.c:1647)
[ 2696.461706]        rest_init (init/main.c:383)
[ 2696.461706]        start_kernel (init/main.c:653)
[ 2696.461706]        x86_64_start_reservations (arch/x86/kernel/head64.c:194)
[ 2696.461706]        x86_64_start_kernel (arch/x86/kernel/head64.c:183)
[ 2696.461706]
-> #1 (&p->pi_lock){-.-.-.}:
[ 2696.461706]        lock_acquire (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
[ 2696.461706]        _raw_spin_lock_irqsave (include/linux/spinlock_api_smp.h:117 kernel/locking/spinlock.c:159)
[ 2696.461706]        try_to_wake_up (kernel/sched/core.c:1592)
[ 2696.461706]        wake_up_process (kernel/sched/core.c:1688 (discriminator 2))
[ 2696.461706]        start_worker (kernel/workqueue.c:1800)
[ 2696.461706]        create_and_start_worker (include/linux/spinlock.h:353 kernel/workqueue.c:1820)
[ 2696.461706]        init_workqueues (kernel/workqueue.c:5061)
[ 2696.461706]        do_one_initcall (init/main.c:696)
[ 2696.461706]        kernel_init_freeable (init/main.c:797 init/main.c:904)
[ 2696.461706]        kernel_init (init/main.c:842)
[ 2696.461706]        ret_from_fork (arch/x86/kernel/entry_64.S:555)
[ 2696.461706]
-> #0 (&(&pool->lock)->rlock){-.-.-.}:
[ 2696.461706]        __lock_acquire (kernel/locking/lockdep.c:1840 kernel/locking/lockdep.c:1945 kernel/locking/lockdep.c:2131 kernel/locking/lockdep.c:3182)
[ 2696.461706]        lock_acquire (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
[ 2696.461706]        _raw_spin_lock (include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:151)
[ 2696.461706]        __queue_work (kernel/workqueue.c:1358)
[ 2696.461706]        queue_work_on (kernel/workqueue.c:1436)
[ 2696.461706]        free_object (lib/debugobjects.c:206)
[ 2696.461706]        __debug_check_no_obj_freed (lib/debugobjects.c:714)
[ 2696.461706]        debug_check_no_obj_freed (lib/debugobjects.c:726)
[ 2696.461706]        kmem_cache_free (mm/slub.c:2679 mm/slub.c:2707)
[ 2696.461706]        __put_task_struct (kernel/fork.c:249 (discriminator 2))
[ 2696.461706]        put_ctx (include/linux/sched.h:1807 kernel/events/core.c:896)
[ 2696.461706]        perf_event_exit_task (kernel/events/core.c:905 kernel/events/core.c:7422 kernel/events/core.c:7492)
[ 2696.461706]        do_exit (kernel/exit.c:801)
[ 2696.461706]        do_group_exit (kernel/exit.c:919)
[ 2696.461706]        SyS_exit_group (kernel/exit.c:930)
[ 2696.461706]        tracesys (arch/x86/kernel/entry_64.S:749)
[ 2696.461706]
[ 2696.461706] other info that might help us debug this:
[ 2696.461706]
[ 2696.461706] Chain exists of:
&(&pool->lock)->rlock --> &rq->lock --> &ctx->lock

[ 2696.461706]  Possible unsafe locking scenario:
[ 2696.461706]
[ 2696.461706]        CPU0                    CPU1
[ 2696.461706]        ----                    ----
[ 2696.461706]   lock(&ctx->lock);
[ 2696.461706]                                lock(&rq->lock);
[ 2696.461706]                                lock(&ctx->lock);
[ 2696.461706]   lock(&(&pool->lock)->rlock);
[ 2696.461706]
[ 2696.461706]  *** DEADLOCK ***
[ 2696.461706]
[ 2696.461706] 1 lock held by trinity-c31/26818:
[ 2696.461706]  #0:  (&ctx->lock){-.-...}, at: perf_event_exit_task (kernel/events/core.c:7415 kernel/events/core.c:7492)
[ 2696.461706]
[ 2696.461706] stack backtrace:
[ 2696.461706] CPU: 31 PID: 26818 Comm: trinity-c31 Not tainted 3.14.0-rc8-next-20140326-sasha-00018-gffbc974-dirty #285
[ 2696.461706]  ffffffffbb9711d0 ffff88024f7a1a78 ffffffffb84b5057 0000000000000000
[ 2696.461706]  ffffffffbb9b5c60 ffff88024f7a1ac8 ffffffffb84a7b57 0000000000000001
[ 2696.461706]  ffff88024f7a1b58 ffff88024f7a1ac8 ffff88022f643cf0 ffff88022f643d28
[ 2696.461706] Call Trace:
[ 2696.461706]  dump_stack (lib/dump_stack.c:52)
[ 2696.461706]  print_circular_bug (kernel/locking/lockdep.c:1216)
[ 2696.461706]  __lock_acquire (kernel/locking/lockdep.c:1840 kernel/locking/lockdep.c:1945 kernel/locking/lockdep.c:2131 kernel/locking/lockdep.c:3182)
[ 2696.461706]  ? kvm_clock_read (arch/x86/include/asm/preempt.h:90 arch/x86/kernel/kvmclock.c:86)
[ 2696.461706]  lock_acquire (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
[ 2696.461706]  ? __queue_work (kernel/workqueue.c:1358)
[ 2696.461706]  ? __lock_is_held (kernel/locking/lockdep.c:3516)
[ 2696.461706]  _raw_spin_lock (include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:151)
[ 2696.461706]  ? __queue_work (kernel/workqueue.c:1358)
[ 2696.461706]  __queue_work (kernel/workqueue.c:1358)
[ 2696.461706]  queue_work_on (kernel/workqueue.c:1436)
[ 2696.461706]  free_object (lib/debugobjects.c:206)
[ 2696.461706]  __debug_check_no_obj_freed (lib/debugobjects.c:714)
[ 2696.461706]  ? __this_cpu_preempt_check (lib/smp_processor_id.c:63)
[ 2696.461706]  debug_check_no_obj_freed (lib/debugobjects.c:726)
[ 2696.461706]  kmem_cache_free (mm/slub.c:2679 mm/slub.c:2707)
[ 2696.461706]  ? __put_task_struct (kernel/fork.c:249 (discriminator 2))
[ 2696.461706]  __put_task_struct (kernel/fork.c:249 (discriminator 2))
[ 2696.461706]  put_ctx (include/linux/sched.h:1807 kernel/events/core.c:896)
[ 2696.461706]  perf_event_exit_task (kernel/events/core.c:905 kernel/events/core.c:7422 kernel/events/core.c:7492)
[ 2696.461706]  do_exit (kernel/exit.c:801)
[ 2696.461706]  ? __this_cpu_preempt_check (lib/smp_processor_id.c:63)
[ 2696.461706]  ? trace_hardirqs_on_caller (kernel/locking/lockdep.c:2557 kernel/locking/lockdep.c:2599)
[ 2696.461706]  ? trace_hardirqs_on (kernel/locking/lockdep.c:2607)
[ 2696.461706]  do_group_exit (kernel/exit.c:919)
[ 2696.461706]  SyS_exit_group (kernel/exit.c:930)
[ 2696.461706]  tracesys (arch/x86/kernel/entry_64.S:749)

Thanks,
Sasha
