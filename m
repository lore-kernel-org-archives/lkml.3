Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055AbaFYVS4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 17:18:56 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:44280 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181AbaFYVSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 17:18:55 -0400
Message-ID: <53AB3C7C.5040605@oracle.com>
Date: Wed, 25 Jun 2014 17:17:48 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, acme@ghostprotocols.net, paulus@samba.org,
        Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: perf/workqueue: lockdep warning on process exit
References: <539EFE3A.7020700@oracle.com> <20140623141242.GB19860@laptop.programming.kicks-ass.net>
In-Reply-To: <20140623141242.GB19860@laptop.programming.kicks-ass.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2014 10:12 AM, Peter Zijlstra wrote:
> On Mon, Jun 16, 2014 at 10:24:58AM -0400, Sasha Levin wrote:
>> Hi all,
>>
>> While fuzzing with trinity inside a KVM tools guest running the latest -next
>> kernel I've stumbled on the following spew:
>>
>> [  430.429005] ======================================================
>> [  430.429005] [ INFO: possible circular locking dependency detected ]
>> [  430.429005] 3.15.0-next-20140613-sasha-00026-g6dd125d-dirty #654 Not tainted
>> [  430.429005] -------------------------------------------------------
>> [  430.429005] trinity-c578/9725 is trying to acquire lock:
>> [  430.429005] (&(&pool->lock)->rlock){-.-...}, at: __queue_work (kernel/workqueue.c:1346)
>> [  430.429005]
>> [  430.429005] but task is already holding lock:
>> [  430.429005] (&ctx->lock){-.....}, at: perf_event_exit_task (kernel/events/core.c:7471 kernel/events/core.c:7533)
>> [  430.439509]
>> [  430.439509] which lock already depends on the new lock.
> 
> 
>> [  430.450111] 1 lock held by trinity-c578/9725:
>> [  430.450111] #0: (&ctx->lock){-.....}, at: perf_event_exit_task (kernel/events/core.c:7471 kernel/events/core.c:7533)
>> [  430.450111]
>> [  430.450111] stack backtrace:
>> [  430.450111] CPU: 6 PID: 9725 Comm: trinity-c578 Not tainted 3.15.0-next-20140613-sasha-00026-g6dd125d-dirty #654
>> [  430.450111]  ffffffffadb45840 ffff880101787848 ffffffffaa511b1c 0000000000000003
>> [  430.450111]  ffffffffadb8a4c0 ffff880101787898 ffffffffaa5044e2 0000000000000001
>> [  430.450111]  ffff880101787928 ffff880101787898 ffff8800aed98cf8 ffff8800aed98000
>> [  430.450111] Call Trace:
>> [  430.450111] dump_stack (lib/dump_stack.c:52)
>> [  430.450111] print_circular_bug (kernel/locking/lockdep.c:1216)
>> [  430.450111] __lock_acquire (kernel/locking/lockdep.c:1840 kernel/locking/lockdep.c:1945 kernel/locking/lockdep.c:2131 kernel/locking/lockdep.c:3182)
>> [  430.450111] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
>> [  430.450111] _raw_spin_lock (include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:151)
>> [  430.450111] __queue_work (kernel/workqueue.c:1346)
>> [  430.450111] queue_work_on (kernel/workqueue.c:1424)
>> [  430.450111] free_object (lib/debugobjects.c:209)
>> [  430.450111] __debug_check_no_obj_freed (lib/debugobjects.c:715)
>> [  430.450111] debug_check_no_obj_freed (lib/debugobjects.c:727)
>> [  430.450111] kmem_cache_free (mm/slub.c:2683 mm/slub.c:2711)
>> [  430.450111] free_task (kernel/fork.c:221)
>> [  430.450111] __put_task_struct (kernel/fork.c:250)
>> [  430.450111] put_ctx (include/linux/sched.h:1855 kernel/events/core.c:898)
>> [  430.450111] perf_event_exit_task (kernel/events/core.c:907 kernel/events/core.c:7478 kernel/events/core.c:7533)
>> [  430.450111] do_exit (kernel/exit.c:766)
>> [  430.450111] do_group_exit (kernel/exit.c:884)
>> [  430.450111] get_signal_to_deliver (kernel/signal.c:2347)
>> [  430.450111] do_signal (arch/x86/kernel/signal.c:698)
>> [  430.450111] do_notify_resume (arch/x86/kernel/signal.c:751)
>> [  430.450111] int_signal (arch/x86/kernel/entry_64.S:600)
> 
> 
> Urgh.. so the only way I can make that happen is through:
> 
>   perf_event_exit_task_context()
>     raw_spin_lock(&child_ctx->lock);
>     unclone_ctx(child_ctx)
>       put_ctx(ctx->parent_ctx);
>     raw_spin_unlock_irqrestore(&child_ctx->lock);
> 
> And we can avoid this by doing something like..
> 
> I can't immediately see how this changed recently, but given that you
> say its easy to reproduce, can you give this a spin?

With the patch I've observed the following, which seems to be related.


[ 1853.792414] ======================================================
[ 1853.794073] [ INFO: possible circular locking dependency detected ]
[ 1853.795636] 3.16.0-rc2-next-20140625-sasha-00023-g9bc0cd4-dirty #727 Tainted: G        W
[ 1853.797760] -------------------------------------------------------
[ 1853.799353] trinity-c3/29876 is trying to acquire lock:
[ 1853.800172] (&(&pool->lock)->rlock){-.-.-.}, at: __queue_work (kernel/workqueue.c:1339)
[ 1853.800172]
[ 1853.800172] but task is already holding lock:
[ 1853.800172] (&ctx->lock){-.-...}, at: perf_lock_task_context (kernel/events/core.c:983)
[ 1853.800172]
[ 1853.800172] which lock already depends on the new lock.
[ 1853.800172]
[ 1853.800172]
[ 1853.800172] the existing dependency chain (in reverse order) is:
[ 1853.800172]
-> #3 (&ctx->lock){-.-...}:
[ 1853.800172] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
[ 1853.800172] _raw_spin_lock (include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:151)
[ 1853.816396] __perf_event_task_sched_out (kernel/events/core.c:2359 kernel/events/core.c:2385)
[ 1853.817250] perf_event_task_sched_out (include/linux/perf_event.h:702)
[ 1853.817250] __schedule (kernel/sched/core.c:2142 kernel/sched/core.c:2180 kernel/sched/core.c:2304 kernel/sched/core.c:2799)
[ 1853.817250] schedule (kernel/sched/core.c:2836)
[ 1853.817250] p9_client_rpc (net/9p/client.c:756 (discriminator 9))
[ 1853.817250] p9_client_getattr_dotl (net/9p/client.c:1754)
[ 1853.817250] v9fs_vfs_getattr_dotl (fs/9p/vfs_inode_dotl.c:496)
[ 1853.817250] vfs_getattr_nosec (fs/stat.c:57)
[ 1853.817250] vfs_getattr (fs/stat.c:73)
[ 1853.817250] vfs_fstatat (fs/stat.c:111)
[ 1853.817250] vfs_lstat (fs/stat.c:130)
[ 1853.817250] SYSC_newlstat (fs/stat.c:284)
[ 1853.817250] SyS_newlstat (fs/stat.c:278)
[ 1853.817250] tracesys (arch/x86/kernel/entry_64.S:542)
[ 1853.817250]
-> #2 (&rq->lock){-.-.-.}:
[ 1853.817250] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
[ 1853.817250] _raw_spin_lock (include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:151)
[ 1853.817250] wake_up_new_task (include/linux/sched.h:2891 kernel/sched/core.c:329 kernel/sched/core.c:2092)
[ 1853.817250] do_fork (kernel/fork.c:1630)
[ 1853.817250] kernel_thread (kernel/fork.c:1652)
[ 1853.817250] rest_init (init/main.c:404)
[ 1853.817250] start_kernel (init/main.c:681)
[ 1853.817250] x86_64_start_reservations (arch/x86/kernel/head64.c:194)
[ 1853.817250] x86_64_start_kernel (arch/x86/kernel/head64.c:183)
[ 1853.817250]
-> #1 (&p->pi_lock){-.-.-.}:
[ 1853.817250] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
[ 1853.817250] _raw_spin_lock_irqsave (include/linux/spinlock_api_smp.h:117 kernel/locking/spinlock.c:159)
[ 1853.817250] try_to_wake_up (kernel/sched/core.c:1670)
[ 1853.817250] wake_up_process (kernel/sched/core.c:1766 (discriminator 2))
[ 1853.817250] create_and_start_worker (include/linux/spinlock.h:353 kernel/workqueue.c:1764)
[ 1853.817250] init_workqueues (kernel/workqueue.c:4923)
[ 1853.817250] do_one_initcall (init/main.c:791)
[ 1853.817250] kernel_init_freeable (init/main.c:892 init/main.c:999)
[ 1853.817250] kernel_init (init/main.c:937)
[ 1853.817250] ret_from_fork (arch/x86/kernel/entry_64.S:349)
[ 1853.817250]
-> #0 (&(&pool->lock)->rlock){-.-.-.}:
[ 1853.817250] __lock_acquire (kernel/locking/lockdep.c:1840 kernel/locking/lockdep.c:1945 kernel/locking/lockdep.c:2131 kernel/locking/lockdep.c:3182)
[ 1853.817250] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
[ 1853.817250] _raw_spin_lock (include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:151)
[ 1853.817250] __queue_work (kernel/workqueue.c:1339)
[ 1853.817250] queue_work_on (kernel/workqueue.c:1417)
[ 1853.817250] free_object (lib/debugobjects.c:209)
[ 1853.817250] __debug_check_no_obj_freed (lib/debugobjects.c:715)
[ 1853.817250] debug_check_no_obj_freed (lib/debugobjects.c:727)
[ 1853.817250] kmem_cache_free (mm/slub.c:2657 mm/slub.c:2686)
[ 1853.817250] free_task (kernel/fork.c:221)
[ 1853.817250] __put_task_struct (kernel/fork.c:250)
[ 1853.817250] put_ctx (include/linux/sched.h:1857 kernel/events/core.c:899)
[ 1853.817250] find_get_context (kernel/events/core.c:908 kernel/events/core.c:3161)
[ 1853.817250] SYSC_perf_event_open (kernel/events/core.c:7200)
[ 1853.817250] SyS_perf_event_open (kernel/events/core.c:7064)
[ 1853.817250] tracesys (arch/x86/kernel/entry_64.S:542)
[ 1853.817250]
[ 1853.817250] other info that might help us debug this:
[ 1853.817250]
[ 1853.817250] Chain exists of:
&(&pool->lock)->rlock --> &rq->lock --> &ctx->lock

[ 1853.817250]  Possible unsafe locking scenario:
[ 1853.817250]
[ 1853.817250]        CPU0                    CPU1
[ 1853.817250]        ----                    ----
[ 1853.817250]   lock(&ctx->lock);
[ 1853.817250]                                lock(&rq->lock);
[ 1853.817250]                                lock(&ctx->lock);
[ 1853.817250]   lock(&(&pool->lock)->rlock);
[ 1853.817250]
[ 1853.817250]  *** DEADLOCK ***
[ 1853.817250]
[ 1853.817250] 2 locks held by trinity-c3/29876:
[ 1853.817250]  #0:  ([watchdog] 4141316 iterations. [F:3363768 S:777188 HI:15026]
cpu_hotplug.lock){++++++}, at: get_online_cpus (kernel/cpu.c:90)
[ 1853.924037] #1: (&ctx->lock){-.-...}, at: perf_lock_task_context (kernel/events/core.c:983)
[ 1853.924037]
[ 1853.924037] stack backtrace:
[ 1853.924037] CPU: 3 PID: 29876 Comm: trinity-c3 Tainted: G        W     3.16.0-rc2-next-20140625-sasha-00023-g9bc0cd4-dirty #727
[ 1853.924037]  ffffffffa1b4a790 ffff880219dcfa28 ffffffff9e524b4b 0000000000000003
[ 1853.924037]  ffffffffa1b8f410 ffff880219dcfa78 ffffffff9e5176e0 0000000000000002
[ 1853.924037]  ffff880219dcfb08 ffff880219dcfa78 ffff880206b73d40 ffff880206b73000
[ 1853.924037] Call Trace:
[ 1853.924037] dump_stack (lib/dump_stack.c:52)
[ 1853.924037] print_circular_bug (kernel/locking/lockdep.c:1216)
[ 1853.924037] __lock_acquire (kernel/locking/lockdep.c:1840 kernel/locking/lockdep.c:1945 kernel/locking/lockdep.c:2131 kernel/locking/lockdep.c:3182)
[ 1853.924037] ? kvm_clock_read (./arch/x86/include/asm/preempt.h:90 arch/x86/kernel/kvmclock.c:86)
[ 1853.924037] ? sched_clock (./arch/x86/include/asm/paravirt.h:192 arch/x86/kernel/tsc.c:305)
[ 1853.924037] ? put_lock_stats.isra.12 (./arch/x86/include/asm/preempt.h:98 kernel/locking/lockdep.c:254)
[ 1853.924037] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
[ 1853.924037] ? __queue_work (kernel/workqueue.c:1339)
[ 1853.924037] ? __lock_is_held (kernel/locking/lockdep.c:3516)
[ 1853.924037] _raw_spin_lock (include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:151)
[ 1853.924037] ? __queue_work (kernel/workqueue.c:1339)
[ 1853.924037] __queue_work (kernel/workqueue.c:1339)
[ 1853.924037] queue_work_on (kernel/workqueue.c:1417)
[ 1853.924037] free_object (lib/debugobjects.c:209)
[ 1853.924037] __debug_check_no_obj_freed (lib/debugobjects.c:715)
[ 1853.924037] ? __this_cpu_preempt_check (lib/smp_processor_id.c:63)
[ 1853.924037] ? free_task (kernel/fork.c:221)
[ 1853.924037] debug_check_no_obj_freed (lib/debugobjects.c:727)
[ 1853.924037] kmem_cache_free (mm/slub.c:2657 mm/slub.c:2686)
[ 1853.924037] free_task (kernel/fork.c:221)
[ 1853.924037] __put_task_struct (kernel/fork.c:250)
[ 1853.924037] put_ctx (include/linux/sched.h:1857 kernel/events/core.c:899)
[ 1853.924037] find_get_context (kernel/events/core.c:908 kernel/events/core.c:3161)
[ 1853.924037] SYSC_perf_event_open (kernel/events/core.c:7200)
[ 1853.924037] ? preempt_count_sub (kernel/sched/core.c:2606)
[ 1853.924037] ? context_tracking_user_exit (./arch/x86/include/asm/paravirt.h:809 (discriminator 2) kernel/context_tracking.c:184 (discriminator 2))
[ 1853.924037] SyS_perf_event_open (kernel/events/core.c:7064)


Thanks,
Sasha
