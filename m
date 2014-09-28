Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751404AbaI1EKd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 00:10:33 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:17493 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbaI1EKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 00:10:31 -0400
Message-ID: <542789E5.7090805@oracle.com>
Date: Sun, 28 Sep 2014 00:09:09 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Cong Wang <cwang@twopensource.com>,
        Vince Weaver <vincent.weaver@maine.edu>
CC: Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: perf: perf_fuzzer triggers instant reboot
References: <alpine.DEB.2.11.1409081343270.29974@vincent-weaver-1.umelst.maine.edu>	<20140908185115.GI6758@twins.programming.kicks-ass.net>	<alpine.DEB.2.11.1409091203500.14857@vincent-weaver-1.umelst.maine.edu>	<alpine.DEB.2.11.1409091317550.15651@vincent-weaver-1.umelst.maine.edu>	<alpine.DEB.2.11.1409091352260.15874@vincent-weaver-1.umelst.maine.edu>	<20140910083136.GP6758@twins.programming.kicks-ass.net>	<alpine.DEB.2.11.1409100914410.8981@vincent-weaver-1.umelst.maine.edu>	<541059C9.1040200@oracle.com>	<alpine.DEB.2.11.1409101027250.8981@vincent-weaver-1.umelst.maine.edu>	<20140910143306.GD4783@worktop.ger.corp.intel.com>	<alpine.DEB.2.11.1409110926120.11483@vincent-weaver-1.umelst.maine.edu>	<alpine.DEB.2.11.1409250052480.26664@vincent-weaver-1.umelst.maine.edu> <CAHA+R7Nu_2KORkf9uP1_HktRA+MLy6TS4vXCPS9Q_JzrcH2SYg@mail.gmail.com>
In-Reply-To: <CAHA+R7Nu_2KORkf9uP1_HktRA+MLy6TS4vXCPS9Q_JzrcH2SYg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2014 12:38 PM, Cong Wang wrote:
> On Wed, Sep 24, 2014 at 9:59 PM, Vince Weaver <vincent.weaver@maine.edu> wrote:
>> >
>> > So I noticed Cong Wang's patch (3577af70a2ce4853d58e57d832e687d739281479)
>> >         perf: Fix a race condition in perf_remove_from_context()
>> >
>> > and that sounds a lot like the weird fork()/memory-corruption bug that the
>> > fuzzer has been triggering.
>> >
>> > So I applied that patch alone on top of the 3.17-rc4 kernel that I could
>> > reproducibly reboot... and with the patch I can't trigger the problem
>> > anymore.
>> >
>> > Now that just might mean the patch pushed the code around enough so my
>> > test doesn't trigger, but there is hope that maybe this fixes things.
> I read this as it fixes your crash as well?

Cong, I *suspect* that that commit also triggers the following lockdep warning.

I haven't confirmed that, but hopefully it'll help:

[  690.800861] ======================================================
[  690.800864] [ INFO: possible circular locking dependency detected ]
[  690.800877] 3.17.0-rc6-next-20140926-sasha-00051-g9253dff-dirty #1242 Not tainted
[  690.800881] -------------------------------------------------------
[  690.800887] trinity-c95/17888 is trying to acquire lock:
[  690.800925] (&(&pool->lock)->rlock){..-.-.}, at: __queue_work (kernel/workqueue.c:1325)
[  690.800929]
[  690.800929] but task is already holding lock:
[  690.800955] (&ctx->lock){-.-...}, at: perf_lock_task_context (kernel/events/core.c:988)
[  690.800958]
[  690.800958] which lock already depends on the new lock.
[  690.800958]
[  690.800960]
[  690.800960] the existing dependency chain (in reverse order) is:
[  690.800971]
[  690.800971] -> #3 (&ctx->lock){-.-...}:
[  690.800990] lock_acquire (kernel/locking/lockdep.c:3610)
[  690.801006] _raw_spin_lock (include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:151)
[  690.801023] __perf_event_task_sched_out (kernel/events/core.c:2419 kernel/events/core.c:2445)
[  690.801040] perf_event_task_sched_out (include/linux/perf_event.h:714)
[  690.801051] __schedule (kernel/sched/core.c:2178 kernel/sched/core.c:2216 kernel/sched/core.c:2336 kernel/sched/core.c:2858)
[  690.801061] preempt_schedule_irq (./arch/x86/include/asm/paravirt.h:814 kernel/sched/core.c:2975)
[  690.801075] retint_kernel (arch/x86/kernel/entry_64.S:920)
[  690.801086] perf_swevent_init (kernel/events/core.c:5963 kernel/events/core.c:5983 kernel/events/core.c:6043)
[  690.801100] perf_init_event (kernel/events/core.c:6841)
[  690.801110] perf_event_alloc (kernel/events/core.c:6996)
[  690.801124] SYSC_perf_event_open (kernel/events/core.c:7291)
[  690.801136] SyS_perf_event_open (kernel/events/core.c:7210)
[  690.801149] tracesys_phase2 (arch/x86/kernel/entry_64.S:529)
[  690.801163]
[  690.801163] -> #2 (&rq->lock){-.-.-.}:
[  690.801185] lock_acquire (kernel/locking/lockdep.c:3610)
[  690.801194] _raw_spin_lock (include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:151)
[  690.801206] wake_up_new_task (include/linux/sched.h:2932 kernel/sched/core.c:320 kernel/sched/core.c:2128)
[  690.801220] do_fork (kernel/fork.c:1690)
[  690.801233] kernel_thread (kernel/fork.c:1712)
[  690.801250] rest_init (init/main.c:404)
[  690.801265] start_kernel (init/main.c:682)
[  690.801280] x86_64_start_reservations (arch/x86/kernel/head64.c:199)
[  690.801297] x86_64_start_kernel (arch/x86/kernel/head64.c:188)
[  690.801315]
[  690.801315] -> #1 (&p->pi_lock){-.-.-.}:
[  690.801326] lock_acquire (kernel/locking/lockdep.c:3610)
[  690.801340] _raw_spin_lock_irqsave (include/linux/spinlock_api_smp.h:117 kernel/locking/spinlock.c:159)
[  690.801350] try_to_wake_up (kernel/sched/core.c:1692)
[  690.801364] wake_up_process (kernel/sched/core.c:1787 (discriminator 3))
[  690.801377] create_worker (include/linux/spinlock.h:359 kernel/workqueue.c:1713)
[  690.801401] init_workqueues (kernel/workqueue.c:4861)
[  690.801415] do_one_initcall (init/main.c:792)
[  690.801427] kernel_init_freeable (init/main.c:893 init/main.c:999)
[  690.801436] kernel_init (init/main.c:937)
[  690.801457] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[  690.801474]
[  690.801474] -> #0 (&(&pool->lock)->rlock){..-.-.}:
[  690.801488] __lock_acquire (kernel/locking/lockdep.c:1842 kernel/locking/lockdep.c:1947 kernel/locking/lockdep.c:2133 kernel/locking/lockdep.c:3184)
[  690.801499] lock_acquire (kernel/locking/lockdep.c:3610)
[  690.801507] _raw_spin_lock (include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:151)
[  690.801517] __queue_work (kernel/workqueue.c:1325)
[  690.801525] queue_work_on (kernel/workqueue.c:1403)
[  690.801542] free_object (lib/debugobjects.c:209)
[  690.801552] __debug_check_no_obj_freed (lib/debugobjects.c:718)
[  690.801561] debug_check_no_obj_freed (lib/debugobjects.c:727)
[  690.801574] kmem_cache_free (mm/slub.c:2687 mm/slub.c:2715)
[  690.801583] free_task (kernel/fork.c:221)
[  690.801594] __put_task_struct (kernel/fork.c:251)
[  690.801609] put_ctx (include/linux/sched.h:1864 kernel/events/core.c:904)
[  690.801619] find_get_context (kernel/events/core.c:913 kernel/events/core.c:3222)
[  690.801630] SYSC_perf_event_open (kernel/events/core.c:7347)
[  690.801638] SyS_perf_event_open (kernel/events/core.c:7210)
[  690.801650] tracesys_phase2 (arch/x86/kernel/entry_64.S:529)
[  690.801653]
[  690.801653] other info that might help us debug this:
[  690.801653]
[  690.801669] Chain exists of:
[  690.801669]   &(&pool->lock)->rlock --> &rq->lock --> &ctx->lock
[  690.801669]
[  690.801679]  Possible unsafe locking scenario:
[  690.801679]
[  690.801684]        CPU0                    CPU1
[  690.801686]        ----                    ----
[  690.801693]   lock(&ctx->lock);
[  690.801703]                                lock(&rq->lock);
[  690.801708]                                lock(&ctx->lock);
[  690.801714]   lock(&(&pool->lock)->rlock);
[  690.801717]
[  690.801717]  *** DEADLOCK ***
[  690.801717]
[  690.801720] 2 locks held by trinity-c95/17888:
[  690.801738] #0: (cpu_hotplug.lock){++++++}, at: get_online_cpus (kernel/cpu.c:92)
[  690.801754] #1: (&ctx->lock){-.-...}, at: perf_lock_task_context (kernel/events/core.c:988)
[  690.801758]
[  690.801758] stack backtrace:
[  690.801766] CPU: 21 PID: 17888 Comm: trinity-c95 Not tainted 3.17.0-rc6-next-20140926-sasha-00051-g9253dff-dirty #1242
[  690.801779]  ffffffff92b7f320 0000000000000000 ffffffff92afbee0 ffff8804078179c8
[  690.801798]  ffffffff8ef0070f 0000000000000011 ffffffff92ab6aa0 ffff880407817a18
[  690.801813]  ffffffff8a24ec2c ffff880407817aa8 ffff880409c00000 ffff880407817a18
[  690.801818] Call Trace:
[  690.801836] dump_stack (lib/dump_stack.c:52)
[  690.801845] print_circular_bug (kernel/locking/lockdep.c:1217)
[  690.801856] __lock_acquire (kernel/locking/lockdep.c:1842 kernel/locking/lockdep.c:1947 kernel/locking/lockdep.c:2133 kernel/locking/lockdep.c:3184)
[  690.801872] lock_acquire (kernel/locking/lockdep.c:3610)
[  690.801883] ? __queue_work (kernel/workqueue.c:1325)
[  690.801892] _raw_spin_lock (include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:151)
[  690.801902] ? __queue_work (kernel/workqueue.c:1325)
[  690.801912] ? get_work_pool (include/linux/idr.h:120 kernel/workqueue.c:674)
[  690.801921] __queue_work (kernel/workqueue.c:1325)
[  690.801932] ? __this_cpu_preempt_check (lib/smp_processor_id.c:63)
[  690.801943] queue_work_on (kernel/workqueue.c:1403)
[  690.801956] free_object (lib/debugobjects.c:209)
[  690.801967] __debug_check_no_obj_freed (lib/debugobjects.c:718)
[  690.801983] debug_check_no_obj_freed (lib/debugobjects.c:727)
[  690.801995] kmem_cache_free (mm/slub.c:2687 mm/slub.c:2715)
[  690.802005] ? free_task (kernel/fork.c:221)
[  690.802016] free_task (kernel/fork.c:221)
[  690.802026] __put_task_struct (kernel/fork.c:251)
[  690.802037] put_ctx (include/linux/sched.h:1864 kernel/events/core.c:904)
[  690.802049] find_get_context (kernel/events/core.c:913 kernel/events/core.c:3222)
[  690.802063] ? perf_event_alloc (kernel/events/core.c:7005)
[  690.802078] SYSC_perf_event_open (kernel/events/core.c:7347)
[  690.802087] ? __this_cpu_preempt_check (lib/smp_processor_id.c:63)
[  690.802097] ? trace_hardirqs_on_caller (kernel/locking/lockdep.c:2602)
[  690.802111] SyS_perf_event_open (kernel/events/core.c:7210)
[  690.802120] tracesys_phase2 (arch/x86/kernel/entry_64.S:529)


Thanks,
Sasha
