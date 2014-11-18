Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098AbaKRRbK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 12:31:10 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:30142 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754416AbaKRRbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 12:31:07 -0500
Message-ID: <546B8237.5000107@oracle.com>
Date: Tue, 18 Nov 2014 12:30:31 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Kirill Tkhai <ktkhai@parallels.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Kirill Tkhai <tkhai@yandex.ru>
Subject: Re: [PATCH v4] sched/numa: fix unsafe get_task_struct() in task_numa_assign()
References: <1413962231.19914.130.camel@tkhai> <545D928B.2070508@oracle.com> <20141110160320.GA10501@worktop.programming.kicks-ass.net> <5466BCAF.4020706@oracle.com>
In-Reply-To: <5466BCAF.4020706@oracle.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2014 09:38 PM, Sasha Levin wrote:
> On 11/10/2014 11:03 AM, Peter Zijlstra wrote:
>> > On Fri, Nov 07, 2014 at 10:48:27PM -0500, Sasha Levin wrote:
>>>> >> > [  829.539183] BUG: spinlock recursion on CPU#10, trinity-c594/11067
>>>> >> > [  829.539203]  lock: 0xffff880631dd6b80, .magic: dead4ead, .owner: trinity-c594/11067, .owner_cpu: 13
>> > Ooh, look at that. CPU#10 vs .owner_cpu: 13 on the _same_ task.
>> > 
>> > One of those again :/
> This actually reproduces pretty easily. The stack trace seems to be different
> but the end result is the same as above. Anything we can do to debug it? I'm
> really not sure how just the owner_cpu can be different here.

I've added saving stack traces on raw spinlock lock/unlock. Had to keep it at
8 entries, but it's enough to get the gist of it. The trace I'm seeing is:

[ 1239.788220] BUG: spinlock recursion on CPU#0, trinity-c767/32076
[ 1239.788270] irq event stamp: 9135954
[ 1239.788455] hardirqs last enabled at (9135953): free_pages_prepare (mm/page_alloc.c:770)
[ 1239.788573] hardirqs last disabled at (9135954): _raw_spin_lock_irqsave (include/linux/spinlock_api_smp.h:109 kernel/locking/spinlock.c:159)
[ 1239.788687] softirqs last enabled at (9134166): __do_softirq (./arch/x86/include/asm/preempt.h:22 kernel/softirq.c:296)
[ 1239.788796] softirqs last disabled at (9134161): irq_exit (kernel/softirq.c:346 kernel/softirq.c:387)
[ 1239.791152]  lock: 0xffff8805c3dd9100, .magic: dead4ead, .owner: trinity-c767/32076, .owner_cpu: -1
[ 1239.791152] lock trace:
[ 1239.791152] save_stack_trace (arch/x86/kernel/stacktrace.c:64)
[ 1239.791152] do_raw_spin_trylock (kernel/locking/spinlock_debug.c:171)
[ 1239.791152] _raw_spin_lock_irq (include/linux/spinlock_api_smp.h:129 kernel/locking/spinlock.c:167)
[ 1239.791152] __schedule (kernel/sched/core.c:2803)
[ 1239.791152] schedule (kernel/sched/core.c:2870)
[ 1239.791152] p9_client_rpc (net/9p/client.c:756 (discriminator 13))
[ 1239.791152] p9_client_read (net/9p/client.c:1582)
[ 1239.791152] v9fs_fid_readn (fs/9p/vfs_file.c:386)
[ 1239.791152] unlock trace:
[ 1239.791152] save_stack_trace (arch/x86/kernel/stacktrace.c:64)
[ 1239.791152] do_raw_spin_unlock (kernel/locking/spinlock_debug.c:120 include/linux/jump_label.h:114 ./arch/x86/include/asm/spinlock.h:149 kernel/locking/spinlock_debug.c:176)
[ 1239.791152] _raw_spin_unlock_irq (include/linux/spinlock_api_smp.h:168 kernel/locking/spinlock.c:199)
[ 1239.791152] finish_task_switch (./arch/x86/include/asm/current.h:14 kernel/sched/core.c:2251)
[ 1239.791152] __schedule (kernel/sched/core.c:2358 kernel/sched/core.c:2840)
[ 1239.791152] schedule_preempt_disabled (kernel/sched/core.c:2897)
[ 1239.791152] cpu_startup_entry (kernel/sched/idle.c:252 kernel/sched/idle.c:274)
[ 1239.791152] start_secondary (arch/x86/kernel/smpboot.c:238)
[ 1239.791152] CPU: 0 PID: 32076 Comm: trinity-c767 Not tainted 3.18.0-rc4-next-20141117-sasha-00046-g481e3e8-dirty #1471
[ 1239.791152]  0000000000000000 0000000000000000 ffff88089a90b000 ffff880867223728
[ 1239.791152]  ffffffff920d1ec1 0000000000000030 ffff8805c3dd9100 ffff880867223768
[ 1239.791152]  ffffffff815d0617 ffffffff9eec7730 ffff88089a90bf58 ffff8805c3dd9100
[ 1239.791152] Call Trace:
[ 1239.791152] dump_stack (lib/dump_stack.c:52)
[ 1239.791152] spin_dump (kernel/locking/spinlock_debug.c:81 (discriminator 8))
[ 1239.791152] spin_bug (kernel/locking/spinlock_debug.c:89)
[ 1239.791152] do_raw_spin_lock (kernel/locking/spinlock_debug.c:97 kernel/locking/spinlock_debug.c:152)
[ 1239.791152] ? load_balance (kernel/sched/fair.c:5582 kernel/sched/fair.c:6884)
[ 1239.791152] _raw_spin_lock_irqsave (include/linux/spinlock_api_smp.h:117 kernel/locking/spinlock.c:159)
[ 1239.791152] ? load_balance (kernel/sched/fair.c:5582 kernel/sched/fair.c:6884)
[ 1239.791152] load_balance (kernel/sched/fair.c:5582 kernel/sched/fair.c:6884)
[ 1239.791152] pick_next_task_fair (kernel/sched/fair.c:7154 kernel/sched/fair.c:5093)
[ 1239.791152] ? pick_next_task_fair (kernel/sched/fair.c:7131 kernel/sched/fair.c:5093)
[ 1239.791152] __schedule (kernel/sched/core.c:2716 kernel/sched/core.c:2830)
[ 1239.791152] ? preempt_count_sub (kernel/sched/core.c:2644)
[ 1239.791152] schedule (kernel/sched/core.c:2870)
[ 1239.791152] p9_client_rpc (net/9p/client.c:756 (discriminator 13))
[ 1239.791152] ? __init_waitqueue_head (kernel/sched/wait.c:292)
[ 1239.791152] ? p9_idpool_put (net/9p/util.c:127)
[ 1239.791152] p9_client_read (net/9p/client.c:1582)
[ 1239.791152] ? p9_free_req (net/9p/client.c:410)
[ 1239.791152] ? might_fault (./arch/x86/include/asm/current.h:14 mm/memory.c:3734)
[ 1239.791152] ? might_fault (mm/memory.c:3734)
[ 1239.791152] v9fs_fid_readn (fs/9p/vfs_file.c:386)
[ 1239.791152] v9fs_file_read (fs/9p/vfs_file.c:447)
[ 1239.791152] do_loop_readv_writev (fs/read_write.c:724)
[ 1239.791152] ? v9fs_fid_readn (fs/9p/vfs_file.c:433)
[ 1239.791152] ? v9fs_fid_readn (fs/9p/vfs_file.c:433)
[ 1239.791152] do_readv_writev (fs/read_write.c:856)
[ 1239.791152] ? save_stack_trace (arch/x86/kernel/stacktrace.c:64)
[ 1239.791152] vfs_readv (fs/read_write.c:882)
[ 1239.791152] SyS_readv (fs/read_write.c:908 fs/read_write.c:899)
[ 1239.791152] tracesys_phase2 (arch/x86/kernel/entry_64.S:529)

So I still can't explain why owner_cpu is "-1" rather than something that makes sense,
but the trace *kinda* makes sense.

We locked the rq once in __schedule(), proceeded to finding the same rq as the busiest
one in load_balance() and locking it yet again.

The odd thing here is that load_balance() has a check just for that:

	BUG_ON(busiest == env.dst_rq);

But that doesn't get hit, although we lock it only a bit later:

	more_balance:
                raw_spin_lock_irqsave(&busiest->lock, flags);

And there's no check before the actual lock there, so I've added another BUG_ON
there and will update with results.


Thanks,
Sasha
