Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527AbaDFTSc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 15:18:32 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:46089 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340AbaDFTSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 15:18:30 -0400
Message-ID: <5341A84C.4050902@oracle.com>
Date: Sun, 06 Apr 2014 15:17:32 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        bitbucket@online.de, mgorman@suse.com, akpm@linux-foundation.org,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
CC: Dave Jones <davej@redhat.com>
Subject: Re: [tip:sched/core] sched/numa: Move task_numa_free() to __put_task_struct()
References: <1393568591.6018.27.camel@marge.simpson.net> <tip-156654f491dd8d52687a5fbe1637f472a52ce75b@git.kernel.org>
In-Reply-To: <tip-156654f491dd8d52687a5fbe1637f472a52ce75b@git.kernel.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2014 08:40 AM, tip-bot for Mike Galbraith wrote:
> Commit-ID:  156654f491dd8d52687a5fbe1637f472a52ce75b
> Gitweb:     http://git.kernel.org/tip/156654f491dd8d52687a5fbe1637f472a52ce75b
> Author:     Mike Galbraith <bitbucket@online.de>
> AuthorDate: Fri, 28 Feb 2014 07:23:11 +0100
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Tue, 11 Mar 2014 12:05:43 +0100
> 
> sched/numa: Move task_numa_free() to __put_task_struct()
> 
> Bad idea on -rt:
> 
> [  908.026136]  [<ffffffff8150ad6a>] rt_spin_lock_slowlock+0xaa/0x2c0
> [  908.026145]  [<ffffffff8108f701>] task_numa_free+0x31/0x130
> [  908.026151]  [<ffffffff8108121e>] finish_task_switch+0xce/0x100
> [  908.026156]  [<ffffffff81509c0a>] thread_return+0x48/0x4ae
> [  908.026160]  [<ffffffff8150a095>] schedule+0x25/0xa0
> [  908.026163]  [<ffffffff8150ad95>] rt_spin_lock_slowlock+0xd5/0x2c0
> [  908.026170]  [<ffffffff810658cf>] get_signal_to_deliver+0xaf/0x680
> [  908.026175]  [<ffffffff8100242d>] do_signal+0x3d/0x5b0
> [  908.026179]  [<ffffffff81002a30>] do_notify_resume+0x90/0xe0
> [  908.026186]  [<ffffffff81513176>] int_signal+0x12/0x17
> [  908.026193]  [<00007ff2a388b1d0>] 0x7ff2a388b1cf
> 
> and since upstream does not mind where we do this, be a bit nicer ...
> 
> Signed-off-by: Mike Galbraith <bitbucket@online.de>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> Cc: Mel Gorman <mgorman@suse.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Link: http://lkml.kernel.org/r/1393568591.6018.27.camel@marge.simpson.net
> Signed-off-by: Ingo Molnar <mingo@kernel.org>

As it seems, upstream does mind:

[ 2590.260734] ======================================================
[ 2590.261695] [ INFO: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected ]
[ 2590.262748] 3.14.0-next-20140403-sasha-00022-g10224c0 #377 Tainted: G        W
[ 2590.263846] ------------------------------------------------------
[ 2590.264730] trinity-c244/1210 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
[ 2590.265783] (&(&grp->lock)->rlock){+.+...}, at: task_numa_free (kernel/sched/fair.c:1714)
[ 2590.267179]
[ 2590.267179] and this task is already holding:
[ 2590.267996] (&(&new_timer->it_lock)->rlock){-.....}, at: exit_itimers (kernel/posix-timers.c:971 kernel/posix-timers.c:998)
[ 2590.269381] which would create a new lock dependency:
[ 2590.270067]  (&(&new_timer->it_lock)->rlock){-.....} -> (&(&grp->lock)->rlock){+.+...}
[ 2590.270067]
[ 2590.270067] but this new dependency connects a HARDIRQ-irq-safe lock:
[ 2590.270067]  (&(&new_timer->it_lock)->rlock){-.....}
... which became HARDIRQ-irq-safe at:
[ 2590.270067] __lock_acquire (kernel/locking/lockdep.c:2783 kernel/locking/lockdep.c:3138)
[ 2590.270067] lock_acquire (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
[ 2590.270067] _raw_spin_lock_irqsave (include/linux/spinlock_api_smp.h:117 kernel/locking/spinlock.c:159)
[ 2590.270067] posix_timer_fn (kernel/posix-timers.c:437)
[ 2590.270067] __run_hrtimer (kernel/hrtimer.c:1245 (discriminator 2))
[ 2590.270067] hrtimer_interrupt (kernel/hrtimer.c:1892)
[ 2590.270067] local_apic_timer_interrupt (arch/x86/kernel/apic/apic.c:921)
[ 2590.270067] smp_apic_timer_interrupt (arch/x86/include/asm/apic.h:696 arch/x86/kernel/apic/apic.c:945)
[ 2590.270067] apic_timer_interrupt (arch/x86/kernel/entry_64.S:1164)
[ 2590.270067] default_idle (arch/x86/include/asm/paravirt.h:111 arch/x86/kernel/process.c:310)
[ 2590.270067] arch_cpu_idle (arch/x86/kernel/process.c:302)
[ 2590.270067] cpu_idle_loop (kernel/sched/idle.c:179 kernel/sched/idle.c:226)
[ 2590.270067] cpu_startup_entry (??:?)
[ 2590.270067] start_secondary (arch/x86/kernel/smpboot.c:267)
[ 2590.270067]
[ 2590.270067] to a HARDIRQ-irq-unsafe lock:
[ 2590.270067]  (&(&grp->lock)->rlock){+.+...}
... which became HARDIRQ-irq-unsafe at:
[ 2590.270067] ... __lock_acquire (kernel/locking/lockdep.c:2800 kernel/locking/lockdep.c:3138)
[ 2590.270067] lock_acquire (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
[ 2590.270067] _raw_spin_lock (include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:151)
[ 2590.270067] task_numa_placement (include/linux/nodemask.h:248 kernel/sched/fair.c:1504)
[ 2590.270067] task_numa_fault (kernel/sched/fair.c:1794)
[ 2590.270067] __handle_mm_fault (mm/memory.c:3796 mm/memory.c:3796 mm/memory.c:3909)
[ 2590.270067] handle_mm_fault (include/linux/memcontrol.h:148 mm/memory.c:3935)
[ 2590.270067] __do_page_fault (arch/x86/mm/fault.c:1220)
[ 2590.270067] do_page_fault (arch/x86/mm/fault.c:1272 include/linux/jump_label.h:105 include/linux/context_tracking_state.h:27 include/linux/context_tracking.h:45 arch/x86/mm/fault.c:1273)
[ 2590.270067] do_async_page_fault (arch/x86/kernel/kvm.c:263)
[ 2590.270067] async_page_fault (arch/x86/kernel/entry_64.S:1496)
[ 2590.270067]
[ 2590.270067] other info that might help us debug this:
[ 2590.270067]
[ 2590.270067]  Possible interrupt unsafe locking scenario:
[ 2590.270067]
[ 2590.270067]        CPU0                    CPU1
[ 2590.270067]        ----                    ----
[ 2590.270067]   lock(&(&grp->lock)->rlock);
[ 2590.270067]                                local_irq_disable();
[ 2590.270067]                                lock(&(&new_timer->it_lock)->rlock);
[ 2590.270067]                                lock(&(&grp->lock)->rlock);
[ 2590.270067]   <Interrupt>
[ 2590.270067]     lock(&(&new_timer->it_lock)->rlock);
[ 2590.270067]
[ 2590.270067]  *** DEADLOCK ***
[ 2590.270067]
[ 2590.270067] 1 lock held by trinity-c244/1210:
[ 2590.270067] #0: (&(&new_timer->it_lock)->rlock){-.....}, at: exit_itimers (kernel/posix-timers.c:971 kernel/posix-timers.c:998)
[ 2590.270067]
the dependencies between HARDIRQ-irq-safe lock and the holding lock:
[ 2590.270067] -> (&(&new_timer->it_lock)->rlock){-.....} ops: 361 {
[ 2590.270067]    IN-HARDIRQ-W at:
[ 2590.270067] __lock_acquire (kernel/locking/lockdep.c:2783 kernel/locking/lockdep.c:3138)
[ 2590.270067] lock_acquire (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
[ 2590.270067] _raw_spin_lock_irqsave (include/linux/spinlock_api_smp.h:117 kernel/locking/spinlock.c:159)
[ 2590.270067] posix_timer_fn (kernel/posix-timers.c:437)
[ 2590.270067] __run_hrtimer (kernel/hrtimer.c:1245 (discriminator 2))
[ 2590.270067] hrtimer_interrupt (kernel/hrtimer.c:1892)
[ 2590.270067] local_apic_timer_interrupt (arch/x86/kernel/apic/apic.c:921)
[ 2590.270067] smp_apic_timer_interrupt (arch/x86/include/asm/apic.h:696 arch/x86/kernel/apic/apic.c:945)
[ 2590.270067] apic_timer_interrupt (arch/x86/kernel/entry_64.S:1164)
[ 2590.270067] default_idle (arch/x86/include/asm/paravirt.h:111 arch/x86/kernel/process.c:310)
[ 2590.270067] arch_cpu_idle (arch/x86/kernel/process.c:302)
[ 2590.270067] cpu_idle_loop (kernel/sched/idle.c:179 kernel/sched/idle.c:226)
[ 2590.270067] cpu_startup_entry (??:?)
[ 2590.270067] start_secondary (arch/x86/kernel/smpboot.c:267)
[ 2590.270067]    INITIAL USE at:
[ 2590.270067] __lock_acquire (kernel/locking/lockdep.c:3142)
[ 2590.270067] lock_acquire (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
[ 2590.270067] _raw_spin_lock_irqsave (include/linux/spinlock_api_smp.h:117 kernel/locking/spinlock.c:159)
[ 2590.270067] exit_itimers (kernel/posix-timers.c:971 kernel/posix-timers.c:998)
[ 2590.270067] do_exit (kernel/exit.c:766)
[ 2590.270067] do_group_exit (kernel/exit.c:919)
[ 2590.270067] SyS_exit_group (kernel/exit.c:930)
[ 2590.270067] tracesys (arch/x86/kernel/entry_64.S:749)
[ 2590.270067]  }
[ 2590.270067] ... key at: __key.33130 (??:?)
[ 2590.270067]  ... acquired at:
[ 2590.270067] check_irq_usage (kernel/locking/lockdep.c:1638)
[ 2590.270067] __lock_acquire (kernel/locking/lockdep_states.h:7 kernel/locking/lockdep.c:1844 kernel/locking/lockdep.c:1945 kernel/locking/lockdep.c:2131 kernel/locking/lockdep.c:3182)
[ 2590.270067] lock_acquire (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
[ 2590.270067] _raw_spin_lock (include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:151)
[ 2590.270067] task_numa_free (kernel/sched/fair.c:1714)
[ 2590.270067] __put_task_struct (kernel/fork.c:244 (discriminator 2))
[ 2590.270067] posix_cpu_timer_del (include/linux/sched.h:1807 kernel/posix-cpu-timers.c:409)
[ 2590.270067] exit_itimers (kernel/posix-timers.c:973 kernel/posix-timers.c:998)
[ 2590.270067] do_exit (kernel/exit.c:766)
[ 2590.270067] do_group_exit (kernel/exit.c:919)
[ 2590.270067] SyS_exit_group (kernel/exit.c:930)
[ 2590.270067] tracesys (arch/x86/kernel/entry_64.S:749)
[ 2590.270067]
[ 2590.270067]
the dependencies between the lock to be acquired and HARDIRQ-irq-unsafe lock:
[ 2590.270067] -> (&(&grp->lock)->rlock){+.+...} ops: 91 {
[ 2590.270067]    HARDIRQ-ON-W at:
[ 2590.270067] __lock_acquire (kernel/locking/lockdep.c:2800 kernel/locking/lockdep.c:3138)
[ 2590.270067] lock_acquire (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
[ 2590.270067] _raw_spin_lock (include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:151)
[ 2590.270067] task_numa_placement (include/linux/nodemask.h:248 kernel/sched/fair.c:1504)
[ 2590.270067] task_numa_fault (kernel/sched/fair.c:1794)
[ 2590.270067] __handle_mm_fault (mm/memory.c:3796 mm/memory.c:3796 mm/memory.c:3909)
[ 2590.270067] handle_mm_fault (include/linux/memcontrol.h:148 mm/memory.c:3935)
[ 2590.270067] __do_page_fault (arch/x86/mm/fault.c:1220)
[ 2590.270067] do_page_fault (arch/x86/mm/fault.c:1272 include/linux/jump_label.h:105 include/linux/context_tracking_state.h:27 include/linux/context_tracking.h:45 arch/x86/mm/fault.c:1273)
[ 2590.270067] do_async_page_fault (arch/x86/kernel/kvm.c:263)
[ 2590.270067] async_page_fault (arch/x86/kernel/entry_64.S:1496)
[ 2590.270067]    SOFTIRQ-ON-W at:
[ 2590.270067] __lock_acquire (kernel/locking/lockdep.c:2804 kernel/locking/lockdep.c:3138)
[ 2590.270067] lock_acquire (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
[ 2590.270067] _raw_spin_lock (include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:151)
[ 2590.270067] task_numa_placement (include/linux/nodemask.h:248 kernel/sched/fair.c:1504)
[ 2590.270067] task_numa_fault (kernel/sched/fair.c:1794)
[ 2590.270067] __handle_mm_fault (mm/memory.c:3796 mm/memory.c:3796 mm/memory.c:3909)
[ 2590.270067] handle_mm_fault (include/linux/memcontrol.h:148 mm/memory.c:3935)
[ 2590.270067] __do_page_fault (arch/x86/mm/fault.c:1220)
[ 2590.270067] do_page_fault (arch/x86/mm/fault.c:1272 include/linux/jump_label.h:105 include/linux/context_tracking_state.h:27 include/linux/context_tracking.h:45 arch/x86/mm/fault.c:1273)
[ 2590.270067] do_async_page_fault (arch/x86/kernel/kvm.c:263)
[ 2590.270067] async_page_fault (arch/x86/kernel/entry_64.S:1496)
[ 2590.270067]    INITIAL USE at:
[ 2590.270067] __lock_acquire (kernel/locking/lockdep.c:3142)
[ 2590.270067] lock_acquire (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
[ 2590.270067] _raw_spin_lock (include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:151)
[ 2590.270067] task_numa_placement (include/linux/nodemask.h:248 kernel/sched/fair.c:1504)
[ 2590.270067] task_numa_fault (kernel/sched/fair.c:1794)
[ 2590.270067] __handle_mm_fault (mm/memory.c:3796 mm/memory.c:3796 mm/memory.c:3909)
[ 2590.270067] handle_mm_fault (include/linux/memcontrol.h:148 mm/memory.c:3935)
[ 2590.270067] __do_page_fault (arch/x86/mm/fault.c:1220)
[ 2590.270067] do_page_fault (arch/x86/mm/fault.c:1272 include/linux/jump_label.h:105 include/linux/context_tracking_state.h:27 include/linux/context_tracking.h:45 arch/x86/mm/fault.c:1273)
[ 2590.270067] do_async_page_fault (arch/x86/kernel/kvm.c:263)
[ 2590.270067] async_page_fault (arch/x86/kernel/entry_64.S:1496)
[ 2590.270067]  }
[ 2590.270067] ... key at: __key.32449 (??:?)
[ 2590.270067]  ... acquired at:
[ 2590.270067] check_irq_usage (kernel/locking/lockdep.c:1638)
[ 2590.270067] __lock_acquire (kernel/locking/lockdep_states.h:7 kernel/locking/lockdep.c:1844 kernel/locking/lockdep.c:1945 kernel/locking/lockdep.c:2131 kernel/locking/lockdep.c:3182)
[ 2590.270067] lock_acquire (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
[ 2590.270067] _raw_spin_lock (include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:151)
[ 2590.270067] task_numa_free (kernel/sched/fair.c:1714)
[ 2590.270067] __put_task_struct (kernel/fork.c:244 (discriminator 2))
[ 2590.270067] posix_cpu_timer_del (include/linux/sched.h:1807 kernel/posix-cpu-timers.c:409)
[ 2590.270067] exit_itimers (kernel/posix-timers.c:973 kernel/posix-timers.c:998)
[ 2590.270067] do_exit (kernel/exit.c:766)
[ 2590.270067] do_group_exit (kernel/exit.c:919)
[ 2590.270067] SyS_exit_group (kernel/exit.c:930)
[ 2590.270067] tracesys (arch/x86/kernel/entry_64.S:749)
[ 2590.270067]
[ 2590.270067]
[ 2590.270067] stack backtrace:
[ 2590.270067] CPU: 3 PID: 1210 Comm: trinity-c244 Tainted: G        W     3.14.0-next-20140403-sasha-00022-g10224c0 #377
[ 2590.270067]  ffffffff87a83b60 ffff880081695ad8 ffffffff844bfb3f 0000000000000000
[ 2590.270067]  ffff880081698cf0 ffff880081695be8 ffffffff811c0d05 0000000000000000
[ 2590.270067]  ffffffff00000000 ffff880000000001 ffffffff8107aac5 ffff880081695b38
[ 2590.270067] Call Trace:
[ 2590.270067] dump_stack (lib/dump_stack.c:52)
[ 2590.270067] check_usage (kernel/locking/lockdep.c:1549 kernel/locking/lockdep.c:1580)
[ 2590.270067] ? sched_clock (arch/x86/include/asm/paravirt.h:192 arch/x86/kernel/tsc.c:305)
[ 2590.270067] ? sched_clock_cpu (kernel/sched/clock.c:311)
[ 2590.270067] check_irq_usage (kernel/locking/lockdep.c:1638)
[ 2590.270067] __lock_acquire (kernel/locking/lockdep_states.h:7 kernel/locking/lockdep.c:1844 kernel/locking/lockdep.c:1945 kernel/locking/lockdep.c:2131 kernel/locking/lockdep.c:3182)
[ 2590.270067] ? __lock_acquire (kernel/locking/lockdep.c:3189)
[ 2590.270067] lock_acquire (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
[ 2590.270067] ? task_numa_free (kernel/sched/fair.c:1714)
[ 2590.270067] _raw_spin_lock (include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:151)
[ 2590.270067] ? task_numa_free (kernel/sched/fair.c:1714)
[ 2590.270067] ? trace_hardirqs_off_caller (kernel/locking/lockdep.c:2638 (discriminator 2))
[ 2590.270067] task_numa_free (kernel/sched/fair.c:1714)
[ 2590.270067] __put_task_struct (kernel/fork.c:244 (discriminator 2))
[ 2590.270067] posix_cpu_timer_del (include/linux/sched.h:1807 kernel/posix-cpu-timers.c:409)
[ 2590.270067] exit_itimers (kernel/posix-timers.c:973 kernel/posix-timers.c:998)
[ 2590.270067] do_exit (kernel/exit.c:766)
[ 2590.270067] ? __this_cpu_preempt_check (lib/smp_processor_id.c:63)
[ 2590.270067] ? trace_hardirqs_on_caller (kernel/locking/lockdep.c:2557 kernel/locking/lockdep.c:2599)
[ 2590.270067] ? trace_hardirqs_on (kernel/locking/lockdep.c:2607)
[ 2590.270067] do_group_exit (kernel/exit.c:919)
[ 2590.270067] SyS_exit_group (kernel/exit.c:930)
[ 2590.270067] tracesys (arch/x86/kernel/entry_64.S:749)


Thanks,
Sasha
