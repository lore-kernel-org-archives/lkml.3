Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305AbaC0PMg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 11:12:36 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:36943 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124AbaC0PMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 11:12:35 -0400
Message-ID: <53343FA5.2080100@oracle.com>
Date: Thu, 27 Mar 2014 11:11:33 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
CC: acme@ghostprotocols.net, paulus@samba.org,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: sched: possible deadlock between fair sched and perf
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While fuzzing with trinity inside a KVM tools guest running latest -next
kernel I've stumbled on the following:

[ 2248.545285] ======================================================
[ 2248.546809] [ INFO: possible circular locking dependency detected ]
[ 2248.548540] 3.14.0-rc8-next-20140326-sasha-00018-gffbc974-dirty #285 Not tainted
[ 2248.550180] -------------------------------------------------------
[ 2248.550180] trinity-c47/15728 is trying to acquire lock:
[ 2248.550180]  (&rq->lock){-.-.-.}, at: unregister_fair_sched_group (kernel/sched/fair.c:7536)
[ 2248.550180]
[ 2248.550180] but task is already holding lock:
[ 2248.550180]  (&ctx->lock){-.-...}, at: perf_event_exit_task (kernel/events/core.c:7415 kernel/events/core.c:7492)
[ 2248.550180]
[ 2248.550180] which lock already depends on the new lock.
[ 2248.550180]
[ 2248.550180]
[ 2248.550180] the existing dependency chain (in reverse order) is:
[ 2248.550180]
-> #1 (&ctx->lock){-.-...}:
[ 2248.550180]        lock_acquire (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
[ 2248.550180]        _raw_spin_lock (include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:151)
[ 2248.550180]        __perf_event_task_sched_out (kernel/events/core.c:2340 kernel/events/core.c:2366)
[ 2248.550180]        perf_event_task_sched_out (include/linux/perf_event.h:689)
[ 2248.550180]        __schedule (kernel/sched/core.c:2064 kernel/sched/core.c:2102 kernel/sched/core.c:2226 kernel/sched/core.c:2713)
[ 2248.550180]        preempt_schedule_irq (arch/x86/include/asm/paravirt.h:814 kernel/sched/core.c:2829)
[ 2248.550180]        retint_kernel (arch/x86/kernel/entry_64.S:1111)
[ 2248.550180]        syscall_trace_leave (arch/x86/kernel/ptrace.c:1535)
[ 2248.550180]        int_check_syscall_exit_work (arch/x86/kernel/entry_64.S:797)
[ 2248.550180]
-> #0 (&rq->lock){-.-.-.}:
[ 2248.550180]        __lock_acquire (kernel/locking/lockdep.c:1840 kernel/locking/lockdep.c:1945 kernel/locking/lockdep.c:2131 kernel/locking/lockdep.c:3182)
[ 2248.550180]        lock_acquire (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
[ 2248.550180]        _raw_spin_lock_irqsave (include/linux/spinlock_api_smp.h:117 kernel/locking/spinlock.c:159)
[ 2248.550180]        unregister_fair_sched_group (kernel/sched/fair.c:7536)
[ 2248.550180]        sched_offline_group (include/linux/cpumask.h:173 kernel/sched/core.c:7203)
[ 2248.550180]        sched_autogroup_exit (kernel/sched/auto_group.c:39 include/linux/kref.h:74 include/linux/kref.h:99 kernel/sched/auto_group.c:44 kernel/sched/auto_group.c:186)
[ 2248.550180]        __put_task_struct (kernel/fork.c:228 kernel/fork.c:234 kernel/fork.c:247)
[ 2248.550180]        put_ctx (include/linux/sched.h:1807 kernel/events/core.c:896)
[ 2248.550180]        perf_event_exit_task (kernel/events/core.c:905 kernel/events/core.c:7422 kernel/events/core.c:7492)
[ 2248.550180]        do_exit (kernel/exit.c:801)
[ 2248.550180]        do_group_exit (kernel/exit.c:919)
[ 2248.550180]        SyS_exit_group (kernel/exit.c:930)
[ 2248.550180]        tracesys (arch/x86/kernel/entry_64.S:749)
[ 2248.550180]
[ 2248.550180] other info that might help us debug this:
[ 2248.550180]
[ 2248.550180]  Possible unsafe locking scenario:
[ 2248.550180]
[ 2248.550180]        CPU0                    CPU1
[ 2248.550180]        ----                    ----
[ 2248.550180]   lock(&ctx->lock);
[ 2248.550180]                                lock(&rq->lock);
[ 2248.550180]                                lock(&ctx->lock);
[ 2248.550180]   lock(&rq->lock);
[ 2248.550180]
[ 2248.550180]  *** DEADLOCK ***
[ 2248.550180]
[ 2248.550180] 1 lock held by trinity-c47/15728:
[ 2248.550180]  #0:  (&ctx->lock){-.-...}, at: perf_event_exit_task (kernel/events/core.c:7415 kernel/events/core.c:7492)
[ 2248.550180]
[ 2248.550180] stack backtrace:
[ 2248.550180] CPU: 31 PID: 15728 Comm: trinity-c47 Not tainted 3.14.0-rc8-next-20140326-sasha-00018-gffbc974-dirty #285
[ 2248.550180]  ffffffffb19711d0 ffff88056563bb78 ffffffffae4b5057 0000000000000000
[ 2248.550180]  ffffffffb19711d0 ffff88056563bbc8 ffffffffae4a7b57 0000000000000001
[ 2248.550180]  ffff88056563bc58 ffff88056563bbc8 ffff880553f20cf0 ffff880553f20d28
[ 2248.550180] Call Trace:
[ 2248.550180]  dump_stack (lib/dump_stack.c:52)
[ 2248.550180]  print_circular_bug (kernel/locking/lockdep.c:1216)
[ 2248.550180]  __lock_acquire (kernel/locking/lockdep.c:1840 kernel/locking/lockdep.c:1945 kernel/locking/lockdep.c:2131 kernel/locking/lockdep.c:3182)
[ 2248.550180]  ? sched_clock (arch/x86/include/asm/paravirt.h:192 arch/x86/kernel/tsc.c:305)
[ 2248.550180]  ? sched_clock_local (kernel/sched/clock.c:214)
[ 2248.550180]  ? __slab_free (include/linux/spinlock.h:358 mm/slub.c:2632)
[ 2248.550180]  ? debug_smp_processor_id (lib/smp_processor_id.c:57)
[ 2248.550180]  lock_acquire (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
[ 2248.550180]  ? unregister_fair_sched_group (kernel/sched/fair.c:7536)
[ 2248.550180]  ? _raw_spin_lock_irqsave (include/linux/spinlock_api_smp.h:109 kernel/locking/spinlock.c:159)
[ 2248.550180]  _raw_spin_lock_irqsave (include/linux/spinlock_api_smp.h:117 kernel/locking/spinlock.c:159)
[ 2248.550180]  ? unregister_fair_sched_group (kernel/sched/fair.c:7536)
[ 2248.550180]  unregister_fair_sched_group (kernel/sched/fair.c:7536)
[ 2248.550180]  sched_offline_group (include/linux/cpumask.h:173 kernel/sched/core.c:7203)
[ 2248.550180]  sched_autogroup_exit (kernel/sched/auto_group.c:39 include/linux/kref.h:74 include/linux/kref.h:99 kernel/sched/auto_group.c:44 kernel/sched/auto_group.c:186)
[ 2248.550180]  __put_task_struct (kernel/fork.c:228 kernel/fork.c:234 kernel/fork.c:247)
[ 2248.550180]  put_ctx (include/linux/sched.h:1807 kernel/events/core.c:896)
[ 2248.550180]  perf_event_exit_task (kernel/events/core.c:905 kernel/events/core.c:7422 kernel/events/core.c:7492)
[ 2248.550180]  do_exit (kernel/exit.c:801)
[ 2248.550180]  do_group_exit (kernel/exit.c:919)
[ 2248.550180]  SyS_exit_group (kernel/exit.c:930)
[ 2248.550180]  tracesys (arch/x86/kernel/entry_64.S:749)


Thanks,
Sasha
