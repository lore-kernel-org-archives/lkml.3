Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757911AbbA0Jbx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 04:31:53 -0500
Received: from casper.infradead.org ([85.118.1.10]:37212 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729AbbA0Jbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 04:31:50 -0500
Date: Tue, 27 Jan 2015 10:31:43 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Kirill Tkhai <ktkhai@parallels.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Burke Libbey <burke.libbey@shopify.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Kirill Tkhai <tkhai@yandex.ru>, Thomas Gleixner <tglx@linutronix.de>,
        jolsa@redhat.com
Subject: Re: [PATCH] sched: Fix race between task_group and sched_task_group
Message-ID: <20150127093143.GP2896@worktop.programming.kicks-ass.net>
References: <1414405105.19914.169.camel@tkhai>
 <54C6D1C4.4070802@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C6D1C4.4070802@oracle.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 06:46:12PM -0500, Sasha Levin wrote:
> This seems to cause the following lockdep warning:

Yeah, so this one in particular seems caused by:

  fadfe7be6e50 ("perf: Add queued work to remove orphaned child events")

But I'm not sure why it wasn't already true for hrtimers, we should have
the exact same problem there.

> [ 3517.958378] ======================================================
> [ 3517.959661] [ INFO: possible circular locking dependency detected ]
> [ 3517.960172] 3.19.0-rc5-next-20150123-sasha-00063-gf82b1d7 #1824 Not tainted
> [ 3517.960172] -------------------------------------------------------
> [ 3517.960172] trinity-c7/29839 is trying to acquire lock:
> [ 3517.960172] (&(&base->lock)->rlock){-.-.-.}, at: lock_timer_base.isra.19 (kernel/time/timer.c:751)
> [ 3517.960172]
> [ 3517.960172] but task is already holding lock:
> [ 3517.960172] (&ctx->lock){-.-.-.}, at: perf_event_context_sched_in (kernel/events/core.c:2600)
> [ 3517.960172]
> [ 3517.960172] which lock already depends on the new lock.
> [ 3517.960172]
> [ 3517.960172]
> [ 3517.960172] the existing dependency chain (in reverse order) is:
> [ 3517.960172]
> -> #5 (&ctx->lock){-.-.-.}:
> [ 3517.960172] lock_acquire (kernel/locking/lockdep.c:3604)
> [ 3517.960172] _raw_spin_lock (include/linux/spinlock_api_smp.h:145 kernel/locking/spinlock.c:151)
> [ 3517.960172] __perf_event_task_sched_out (kernel/events/core.c:2434 kernel/events/core.c:2460)
> [ 3517.960172] __schedule (include/linux/perf_event.h:730 kernel/sched/core.c:2209 kernel/sched/core.c:2333 kernel/sched/core.c:2823)
> [ 3517.960172] schedule (kernel/sched/core.c:2853)
> [ 3517.960172] p9_client_rpc (net/9p/client.c:756 (discriminator 13))
> [ 3517.960172] p9_client_read (net/9p/client.c:1582)
> [ 3517.960172] v9fs_fid_readn (fs/9p/vfs_file.c:386)
> [ 3517.960172] v9fs_fid_readpage (fs/9p/vfs_addr.c:71)
> [ 3517.960172] v9fs_vfs_readpage (fs/9p/vfs_addr.c:105)
> [ 3517.960172] filemap_fault (mm/filemap.c:1763 mm/filemap.c:1944)
> [ 3517.960172] __do_fault (mm/memory.c:2654)
> [ 3517.960172] handle_mm_fault (mm/memory.c:2842 mm/memory.c:3143 mm/memory.c:3267 mm/memory.c:3296)
> [ 3517.960172] __do_page_fault (arch/x86/mm/fault.c:1233)
> [ 3517.960172] trace_do_page_fault (arch/x86/mm/fault.c:1325 include/linux/jump_label.h:114 include/linux/context_tracking_state.h:27 include/linux/context_tracking.h:45 arch/x86/mm/fault.c:1326)
> [ 3517.960172] do_async_page_fault (arch/x86/kernel/kvm.c:280)
> [ 3517.960172] async_page_fault (arch/x86/kernel/entry_64.S:1286)
> [ 3517.960172]
> -> #4 (&rq->lock){-.-.-.}:
> [ 3517.960172] lock_acquire (kernel/locking/lockdep.c:3604)
> [ 3517.960172] _raw_spin_lock (include/linux/spinlock_api_smp.h:145 kernel/locking/spinlock.c:151)
> [ 3517.960172] task_rq_lock (kernel/sched/core.c:344)
> [ 3517.960172] sched_move_task (kernel/sched/core.c:7556)
> [ 3517.960172] cpu_cgroup_fork (kernel/sched/core.c:8003)
> [ 3517.960172] cgroup_post_fork (kernel/cgroup.c:5239 (discriminator 2))
> [ 3517.960172] copy_process (kernel/fork.c:1544)
> [ 3517.960172] do_fork (kernel/fork.c:1653)
> [ 3517.960172] kernel_thread (kernel/fork.c:1702)
> [ 3517.960172] rest_init (init/main.c:406)
> [ 3517.960172] start_kernel (init/main.c:503)
> [ 3517.960172] x86_64_start_reservations (arch/x86/kernel/head64.c:199)
> [ 3517.960172] x86_64_start_kernel (arch/x86/kernel/head64.c:188)
> [ 3517.960172]
> -> #3 (&p->pi_lock){-.-.-.}:
> [ 3517.960172] lock_acquire (kernel/locking/lockdep.c:3604)
> [ 3517.960172] _raw_spin_lock_irqsave (include/linux/spinlock_api_smp.h:119 kernel/locking/spinlock.c:159)
> [ 3517.960172] try_to_wake_up (kernel/sched/core.c:1704)
> [ 3517.960172] default_wake_function (kernel/sched/core.c:2995)
> [ 3517.960172] autoremove_wake_function (kernel/sched/wait.c:295)
> [ 3517.960172] __wake_up_common (kernel/sched/wait.c:73)
> [ 3517.960172] __wake_up (include/linux/spinlock.h:372 kernel/sched/wait.c:96)
> [ 3517.960172] wakeup_kswapd (mm/vmscan.c:3519)
> [ 3517.960172] __alloc_pages_nodemask (mm/page_alloc.c:2530 mm/page_alloc.c:2628 mm/page_alloc.c:2849)
> [ 3517.960172] new_page_node (mm/migrate.c:1180)
> [ 3517.960172] migrate_pages (mm/migrate.c:913 mm/migrate.c:1112)
> [ 3517.960172] SYSC_move_pages (mm/migrate.c:1265 mm/migrate.c:1340 mm/migrate.c:1495)
> [ 3517.960172] SyS_move_pages (mm/migrate.c:1440)
> [ 3517.960172] tracesys_phase2 (arch/x86/kernel/entry_64.S:530)
> [ 3517.960172]
> -> #2 (&pgdat->kswapd_wait){..-.-.}:
> [ 3517.960172] lock_acquire (kernel/locking/lockdep.c:3604)
> [ 3517.960172] _raw_spin_lock_irqsave (include/linux/spinlock_api_smp.h:119 kernel/locking/spinlock.c:159)
> [ 3517.960172] __wake_up (kernel/sched/wait.c:95)
> [ 3517.960172] wakeup_kswapd (mm/vmscan.c:3519)
> [ 3517.960172] __alloc_pages_nodemask (mm/page_alloc.c:2530 mm/page_alloc.c:2628 mm/page_alloc.c:2849)
> [ 3517.960172] alloc_pages_current (mm/mempolicy.c:2147)
> [ 3517.960172] __get_free_pages (mm/page_alloc.c:2885)
> [ 3517.960172] alloc_loc_track (mm/slub.c:3963)
> [ 3517.960172] process_slab (mm/slub.c:4029 mm/slub.c:4063)
> [ 3517.960172] list_locations (mm/slub.c:4095 (discriminator 3))
> [ 3517.960172] alloc_calls_show (mm/slub.c:4700)
> [ 3517.960172] slab_attr_show (mm/slub.c:4950)
> [ 3517.960172] sysfs_kf_seq_show (fs/sysfs/file.c:64)
> [ 3517.960172] kernfs_seq_show (fs/kernfs/file.c:169)
> [ 3517.960172] seq_read (fs/seq_file.c:228)
> [ 3517.960172] kernfs_fop_read (fs/kernfs/file.c:251)
> [ 3517.960172] __vfs_read (fs/read_write.c:430)
> [ 3517.960172] vfs_read (fs/read_write.c:446)
> [ 3517.960172] kernel_read (fs/exec.c:819)
> [ 3517.960172] copy_module_from_fd.isra.28 (kernel/module.c:2547)
> [ 3517.960172] SyS_finit_module (kernel/module.c:3429 kernel/module.c:3413)
> [ 3517.960172] tracesys_phase2 (arch/x86/kernel/entry_64.S:530)
> [ 3517.960172]
> -> #1 (&(&n->list_lock)->rlock){-.-.-.}:
> [ 3517.960172] lock_acquire (kernel/locking/lockdep.c:3604)
> [ 3517.960172] _raw_spin_lock (include/linux/spinlock_api_smp.h:145 kernel/locking/spinlock.c:151)
> [ 3517.960172] get_partial_node.isra.35 (mm/slub.c:1630)
> [ 3517.960172] __slab_alloc (mm/slub.c:1737 mm/slub.c:2207 mm/slub.c:2378)
> [ 3517.960172] kmem_cache_alloc (mm/slub.c:2459 mm/slub.c:2506)
> [ 3517.960172] __debug_object_init (include/linux/slab.h:572 lib/debugobjects.c:99 lib/debugobjects.c:312)
> [ 3517.960172] debug_object_init (lib/debugobjects.c:365)
> [ 3517.960172] timer_fixup_activate (kernel/time/timer.c:512)
> [ 3517.960172] debug_object_activate (lib/debugobjects.c:280 lib/debugobjects.c:439)
> [ 3517.960172] mod_timer (kernel/time/timer.c:589 include/linux/jump_label.h:114 include/trace/events/timer.h:44 kernel/time/timer.c:641 kernel/time/timer.c:778 kernel/time/timer.c:897)
> [ 3517.960172] isicom_init (drivers/tty/isicom.c:1708)
> [ 3517.960172] do_one_initcall (init/main.c:798)
> [ 3517.960172] kernel_init_freeable (init/main.c:863 init/main.c:871 init/main.c:890 init/main.c:1011)
> [ 3517.960172] kernel_init (init/main.c:943)
> [ 3517.960172] ret_from_fork (arch/x86/kernel/entry_64.S:349)
> [ 3517.960172]
> -> #0 (&(&base->lock)->rlock){-.-.-.}:
> [ 3517.960172] __lock_acquire (kernel/locking/lockdep.c:1842 kernel/locking/lockdep.c:1947 kernel/locking/lockdep.c:2133 kernel/locking/lockdep.c:3184)
> [ 3517.960172] lock_acquire (kernel/locking/lockdep.c:3604)
> [ 3517.960172] _raw_spin_lock_irqsave (include/linux/spinlock_api_smp.h:119 kernel/locking/spinlock.c:159)
> [ 3517.960172] lock_timer_base.isra.19 (kernel/time/timer.c:751)
> [ 3517.960172] mod_timer (kernel/time/timer.c:774 kernel/time/timer.c:897)
> [ 3517.960172] add_timer (kernel/time/timer.c:947)
> [ 3517.960172] __queue_delayed_work (kernel/workqueue.c:1452)
> [ 3517.960172] queue_delayed_work_on (kernel/workqueue.c:1480)
> [ 3517.960172] schedule_orphans_remove (kernel/events/core.c:1416)
> [ 3517.960172] event_sched_in.isra.47 (kernel/events/core.c:1793)
> [ 3517.960172] group_sched_in (kernel/events/core.c:1816)
> [ 3517.960172] ctx_sched_in (kernel/events/core.c:2547 kernel/events/core.c:2578)
> [ 3517.960172] perf_event_sched_in (kernel/events/core.c:1930)
> [ 3517.960172] perf_event_context_sched_in (kernel/events/core.c:2613)
> [ 3517.960172] __perf_event_task_sched_in (kernel/events/core.c:2703)
> [ 3517.960172] finish_task_switch (include/linux/perf_event.h:721 kernel/sched/core.c:2257)
> [ 3517.960172] __schedule (kernel/sched/core.c:2368 kernel/sched/core.c:2823)
> [ 3517.960172] schedule_user (kernel/sched/core.c:2852 include/linux/jump_label.h:114 include/linux/context_tracking_state.h:27 include/linux/context_tracking.h:45 kernel/sched/core.c:2871)
> [ 3517.960172] retint_careful (arch/x86/kernel/entry_64.S:905)
> [ 3517.960172]
> [ 3517.960172] other info that might help us debug this:
> [ 3517.960172]
> [ 3517.960172] Chain exists of:
> &(&base->lock)->rlock --> &rq->lock --> &ctx->lock
> 
> [ 3517.960172]  Possible unsafe locking scenario:
> [ 3517.960172]
> [ 3517.960172]        CPU0                    CPU1
> [ 3517.960172]        ----                    ----
> [ 3517.960172]   lock(&ctx->lock);
> [ 3517.960172]                                lock(&rq->lock);
> [ 3517.960172]                                lock(&ctx->lock);
> [ 3517.960172]   lock(&(&base->lock)->rlock);
> [ 3517.960172]
> [ 3517.960172]  *** DEADLOCK ***
> [ 3517.960172]
> [ 3517.960172] 2 locks held by trinity-c7/29839:
> [ 3517.960172] #0: (&cpuctx_lock){-.-.-.}, at: perf_event_context_sched_in (kernel/events/core.c:340 kernel/events/core.c:2599)
> [ 3517.960172] #1: (&ctx->lock){-.-.-.}, at: perf_event_context_sched_in (kernel/events/core.c:2600)
> [ 3517.960172]
> [ 3517.960172] stack backtrace:
> [ 3517.960172] CPU: 7 PID: 29839 Comm: trinity-c7 Not tainted 3.19.0-rc5-next-20150123-sasha-00063-gf82b1d7 #1824
> [ 3517.960172]  ffffffffa67fa820 00000000167dc919 ffff880353a8f700 ffffffffa0a859d2
> [ 3517.960172]  0000000000000000 ffffffffa67fcef0 ffff880353a8f760 ffffffff96407cd9
> [ 3517.960172]  ffff88017c680138 ffffffffa6879cf0 0000000000000000 ffff880353a90000
> [ 3517.960172] Call Trace:
> [ 3517.960172] dump_stack (lib/dump_stack.c:52)
> [ 3517.960172] print_circular_bug (kernel/locking/lockdep.c:1217)
> [ 3517.960172] __lock_acquire (kernel/locking/lockdep.c:1842 kernel/locking/lockdep.c:1947 kernel/locking/lockdep.c:2133 kernel/locking/lockdep.c:3184)
> [ 3517.960172] ? debug_check_no_locks_freed (kernel/locking/lockdep.c:3051)
> [ 3517.960172] ? __lock_acquire (kernel/locking/lockdep.c:3144)
> [ 3517.960172] lock_acquire (kernel/locking/lockdep.c:3604)
> [ 3517.960172] ? lock_timer_base.isra.19 (kernel/time/timer.c:751)
> [ 3517.960172] _raw_spin_lock_irqsave (include/linux/spinlock_api_smp.h:119 kernel/locking/spinlock.c:159)
> [ 3517.960172] ? lock_timer_base.isra.19 (kernel/time/timer.c:751)
> [ 3517.960172] lock_timer_base.isra.19 (kernel/time/timer.c:751)
> [ 3517.960172] mod_timer (kernel/time/timer.c:774 kernel/time/timer.c:897)
> [ 3517.960172] ? x86_pmu_start_txn (arch/x86/kernel/cpu/perf_event.c:1024)
> [ 3517.960172] ? msleep (kernel/time/timer.c:886)
> [ 3517.960172] add_timer (kernel/time/timer.c:947)
> [ 3517.960172] __queue_delayed_work (kernel/workqueue.c:1452)
> [ 3517.960172] queue_delayed_work_on (kernel/workqueue.c:1480)
> [ 3517.960172] schedule_orphans_remove (kernel/events/core.c:1416)
> [ 3517.960172] event_sched_in.isra.47 (kernel/events/core.c:1793)
> [ 3517.960172] ? sched_clock (./arch/x86/include/asm/paravirt.h:192 arch/x86/kernel/tsc.c:304)
> [ 3517.960172] group_sched_in (kernel/events/core.c:1816)
> [ 3517.960172] ? sched_clock_cpu (kernel/sched/clock.c:311)
> [ 3517.960172] ctx_sched_in (kernel/events/core.c:2547 kernel/events/core.c:2578)
> [ 3517.960172] ? perf_event_context_sched_in (kernel/events/core.c:2600)
> [ 3517.960172] perf_event_sched_in (kernel/events/core.c:1930)
> [ 3517.960172] perf_event_context_sched_in (kernel/events/core.c:2613)
> [ 3517.960172] __perf_event_task_sched_in (kernel/events/core.c:2703)
> [ 3517.960172] ? perf_pmu_enable (kernel/events/core.c:2694)
> [ 3517.960172] finish_task_switch (include/linux/perf_event.h:721 kernel/sched/core.c:2257)
> [ 3517.960172] __schedule (kernel/sched/core.c:2368 kernel/sched/core.c:2823)
> [ 3517.960172] ? trace_hardirqs_on_caller (kernel/locking/lockdep.c:2554 kernel/locking/lockdep.c:2601)
> [ 3517.960172] schedule_user (kernel/sched/core.c:2852 include/linux/jump_label.h:114 include/linux/context_tracking_state.h:27 include/linux/context_tracking.h:45 kernel/sched/core.c:2871)
> [ 3517.960172] retint_careful (arch/x86/kernel/entry_64.S:905)
