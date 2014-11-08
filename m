Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402AbaKHDtN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 22:49:13 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:29928 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287AbaKHDtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 22:49:12 -0500
Message-ID: <545D928B.2070508@oracle.com>
Date: Fri, 07 Nov 2014 22:48:27 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Kirill Tkhai <ktkhai@parallels.com>, linux-kernel@vger.kernel.org
CC: Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Kirill Tkhai <tkhai@yandex.ru>
Subject: Re: [PATCH v4] sched/numa: fix unsafe get_task_struct() in task_numa_assign()
References: <1413962231.19914.130.camel@tkhai>
In-Reply-To: <1413962231.19914.130.camel@tkhai>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2014 03:17 AM, Kirill Tkhai wrote:
> Unlocked access to dst_rq->curr in task_numa_compare() is racy.
> If curr task is exiting this may be a reason of use-after-free:
[...]

I've complained about an unrelated issue in that part of the code
a while back (https://lkml.org/lkml/2014/5/12/508) which PeterZ
ended up fixing (https://lkml.org/lkml/2014/5/21/428) but it seems
that both of us forgot to follow up on that and the fix never got
upstream.

Ever since this patch made it upstream, Peter's patch which I was
carrying in my tree stopped applying and I've started seeing:

[  829.539183] BUG: spinlock recursion on CPU#10, trinity-c594/11067
[  829.539203]  lock: 0xffff880631dd6b80, .magic: dead4ead, .owner: trinity-c594/11067, .owner_cpu: 13
[  829.539212] CPU: 10 PID: 11067 Comm: trinity-c594 Not tainted 3.18.0-rc3-next-20141106-sasha-00054-g09b7ccf-dirty #1448
[  829.539226]  0000000000000000 0000000000000000 ffff880053acb000 ffff88032b71f828
[  829.539235]  ffffffffa009fb5a 0000000000000057 ffff880631dd6b80 ffff88032b71f868
[  829.539243]  ffffffff963f0c57 ffff880053acbd80 ffff880053acbdb0 ffff88032b71f858
[  829.539246] Call Trace:
[  829.539265] dump_stack (lib/dump_stack.c:52)
[  829.539277] spin_dump (kernel/locking/spinlock_debug.c:68 (discriminator 8))
[  829.539282] spin_bug (kernel/locking/spinlock_debug.c:76)
[  829.539288] do_raw_spin_lock (kernel/locking/spinlock_debug.c:84 kernel/locking/spinlock_debug.c:135)
[  829.539304] ? __schedule (kernel/sched/core.c:2803)
[  829.539313] _raw_spin_lock_irq (include/linux/spinlock_api_smp.h:129 kernel/locking/spinlock.c:167)
[  829.539321] ? task_numa_find_cpu (kernel/sched/fair.c:1258 kernel/sched/fair.c:1385)
[  829.539330] ? rcu_is_watching (./arch/x86/include/asm/preempt.h:95 kernel/rcu/tree.c:827)
[  829.539336] task_numa_find_cpu (kernel/sched/fair.c:1258 kernel/sched/fair.c:1385)
[  829.539342] ? task_numa_find_cpu (kernel/sched/fair.c:1253 kernel/sched/fair.c:1385)
[  829.539352] ? preempt_count_sub (kernel/sched/core.c:2644)
[  829.539358] task_numa_migrate (kernel/sched/fair.c:1452)
[  829.539364] ? task_numa_migrate (kernel/sched/fair.c:1391)
[  829.539376] ? kvm_clock_read (./arch/x86/include/asm/preempt.h:87 arch/x86/kernel/kvmclock.c:85)
[  829.539386] ? sched_clock (./arch/x86/include/asm/paravirt.h:192 arch/x86/kernel/tsc.c:304)
[  829.539392] ? sched_clock_local (kernel/sched/clock.c:202)
[  829.539399] numa_migrate_preferred (kernel/sched/fair.c:1539)
[  829.539404] ? sched_clock_local (kernel/sched/clock.c:202)
[  829.539411] task_numa_fault (kernel/sched/fair.c:2073)
[  829.539417] ? sched_clock_cpu (kernel/sched/clock.c:311)
[  829.539429] ? debug_smp_processor_id (lib/smp_processor_id.c:57)
[  829.539438] ? get_lock_stats (kernel/locking/lockdep.c:249)
[  829.539446] ? get_parent_ip (kernel/sched/core.c:2588)
[  829.539461] handle_mm_fault (mm/memory.c:3187 mm/memory.c:3233 mm/memory.c:3346 mm/memory.c:3375)
[  829.539466] ? find_vma (mm/mmap.c:2048)
[  829.539477] __do_page_fault (arch/x86/mm/fault.c:1246)
[  829.539485] ? context_tracking_user_exit (kernel/context_tracking.c:144)
[  829.539491] ? __this_cpu_preempt_check (lib/smp_processor_id.c:63)
[  829.539498] ? trace_hardirqs_off_caller (kernel/locking/lockdep.c:2640 (discriminator 8))
[  829.539505] trace_do_page_fault (arch/x86/mm/fault.c:1329 include/linux/jump_label.h:114 include/linux/context_tracking_state.h:27 include/linux/context_tracking.h:45 arch/x86/mm/fault.c:1330)
[  829.539510] do_async_page_fault (arch/x86/kernel/kvm.c:280)
[  829.539516] async_page_fault (arch/x86/kernel/entry_64.S:1301)



Thanks,
Sasha
