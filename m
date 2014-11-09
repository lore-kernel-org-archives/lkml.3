Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961AbaKIOHK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 09:07:10 -0500
Received: from relay.parallels.com ([195.214.232.42]:53613 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbaKIOHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 09:07:08 -0500
Message-ID: <1415542020.474.22.camel@tkhai>
Subject: Re: [PATCH v4] sched/numa: fix unsafe get_task_struct() in
 task_numa_assign()
From: Kirill Tkhai <ktkhai@parallels.com>
To: Sasha Levin <sasha.levin@oracle.com>
CC: <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "Vladimir Davydov" <vdavydov@parallels.com>,
        Kirill Tkhai <tkhai@yandex.ru>
Date: Sun, 9 Nov 2014 17:07:00 +0300
In-Reply-To: <545D928B.2070508@oracle.com>
References: <1413962231.19914.130.camel@tkhai> <545D928B.2070508@oracle.com>
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

В Пт, 07/11/2014 в 22:48 -0500, Sasha Levin пишет:
> On 10/22/2014 03:17 AM, Kirill Tkhai wrote:
> > Unlocked access to dst_rq->curr in task_numa_compare() is racy.
> > If curr task is exiting this may be a reason of use-after-free:
> [...]
> 
> I've complained about an unrelated issue in that part of the code
> a while back (https://lkml.org/lkml/2014/5/12/508) which PeterZ
> ended up fixing (https://lkml.org/lkml/2014/5/21/428) but it seems
> that both of us forgot to follow up on that and the fix never got
> upstream.
> 
> Ever since this patch made it upstream, Peter's patch which I was
> carrying in my tree stopped applying and I've started seeing:
> 
> [  829.539183] BUG: spinlock recursion on CPU#10, trinity-c594/11067
> [  829.539203]  lock: 0xffff880631dd6b80, .magic: dead4ead, .owner: trinity-c594/11067, .owner_cpu: 13
> [  829.539212] CPU: 10 PID: 11067 Comm: trinity-c594 Not tainted 3.18.0-rc3-next-20141106-sasha-00054-g09b7ccf-dirty #1448
> [  829.539226]  0000000000000000 0000000000000000 ffff880053acb000 ffff88032b71f828
> [  829.539235]  ffffffffa009fb5a 0000000000000057 ffff880631dd6b80 ffff88032b71f868
> [  829.539243]  ffffffff963f0c57 ffff880053acbd80 ffff880053acbdb0 ffff88032b71f858
> [  829.539246] Call Trace:
> [  829.539265] dump_stack (lib/dump_stack.c:52)
> [  829.539277] spin_dump (kernel/locking/spinlock_debug.c:68 (discriminator 8))
> [  829.539282] spin_bug (kernel/locking/spinlock_debug.c:76)
> [  829.539288] do_raw_spin_lock (kernel/locking/spinlock_debug.c:84 kernel/locking/spinlock_debug.c:135)
> [  829.539304] ? __schedule (kernel/sched/core.c:2803)
> [  829.539313] _raw_spin_lock_irq (include/linux/spinlock_api_smp.h:129 kernel/locking/spinlock.c:167)
> [  829.539321] ? task_numa_find_cpu (kernel/sched/fair.c:1258 kernel/sched/fair.c:1385)
> [  829.539330] ? rcu_is_watching (./arch/x86/include/asm/preempt.h:95 kernel/rcu/tree.c:827)
> [  829.539336] task_numa_find_cpu (kernel/sched/fair.c:1258 kernel/sched/fair.c:1385)
> [  829.539342] ? task_numa_find_cpu (kernel/sched/fair.c:1253 kernel/sched/fair.c:1385)
> [  829.539352] ? preempt_count_sub (kernel/sched/core.c:2644)
> [  829.539358] task_numa_migrate (kernel/sched/fair.c:1452)
> [  829.539364] ? task_numa_migrate (kernel/sched/fair.c:1391)
> [  829.539376] ? kvm_clock_read (./arch/x86/include/asm/preempt.h:87 arch/x86/kernel/kvmclock.c:85)
> [  829.539386] ? sched_clock (./arch/x86/include/asm/paravirt.h:192 arch/x86/kernel/tsc.c:304)
> [  829.539392] ? sched_clock_local (kernel/sched/clock.c:202)
> [  829.539399] numa_migrate_preferred (kernel/sched/fair.c:1539)
> [  829.539404] ? sched_clock_local (kernel/sched/clock.c:202)
> [  829.539411] task_numa_fault (kernel/sched/fair.c:2073)
> [  829.539417] ? sched_clock_cpu (kernel/sched/clock.c:311)
> [  829.539429] ? debug_smp_processor_id (lib/smp_processor_id.c:57)
> [  829.539438] ? get_lock_stats (kernel/locking/lockdep.c:249)
> [  829.539446] ? get_parent_ip (kernel/sched/core.c:2588)
> [  829.539461] handle_mm_fault (mm/memory.c:3187 mm/memory.c:3233 mm/memory.c:3346 mm/memory.c:3375)
> [  829.539466] ? find_vma (mm/mmap.c:2048)
> [  829.539477] __do_page_fault (arch/x86/mm/fault.c:1246)
> [  829.539485] ? context_tracking_user_exit (kernel/context_tracking.c:144)
> [  829.539491] ? __this_cpu_preempt_check (lib/smp_processor_id.c:63)
> [  829.539498] ? trace_hardirqs_off_caller (kernel/locking/lockdep.c:2640 (discriminator 8))
> [  829.539505] trace_do_page_fault (arch/x86/mm/fault.c:1329 include/linux/jump_label.h:114 include/linux/context_tracking_state.h:27 include/linux/context_tracking.h:45 arch/x86/mm/fault.c:1330)
> [  829.539510] do_async_page_fault (arch/x86/kernel/kvm.c:280)
> [  829.539516] async_page_fault (arch/x86/kernel/entry_64.S:1301)

The bellow is equal to the patch suggested by Peter.

The only thing, I'm doubt, is about the comparison of cpus instead of nids.
Should task_numa_compare() be able to be called with src_nid == dst_nid
like this may happens now?! Maybe better, we should change task_numa_migrate()
and check for env.dst_nid != env.src.nid.


diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 826fdf3..c18129e 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1380,6 +1380,8 @@ static void task_numa_find_cpu(struct task_numa_env *env,
 		/* Skip this CPU if the source task cannot migrate */
 		if (!cpumask_test_cpu(cpu, tsk_cpus_allowed(env->p)))
 			continue;
+		if (cpu == env->src_cpu)
+			continue;
 
 		env->dst_cpu = cpu;
 		task_numa_compare(env, taskimp, groupimp);


