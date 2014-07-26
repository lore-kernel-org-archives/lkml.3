Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423AbaGZCfF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 22:35:05 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:33167 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbaGZCfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 22:35:02 -0400
Message-ID: <53D313A3.2090201@oracle.com>
Date: Fri, 25 Jul 2014 22:34:11 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, acme@ghostprotocols.net,
        Peter Zijlstra <peterz@infradead.org>
CC: Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf: invalid memory access in perf_swevent_del
References: <536EB79C.2080308@oracle.com>
In-Reply-To: <536EB79C.2080308@oracle.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2014 07:34 PM, Sasha Levin wrote:
> Hi all,
> 
> While fuzzing with trinity inside a KVM tools guest running the latest -next
> kernel I've stumbled on the following spew:

Ping? I'm still seeing corruption on perf_swevent_del and perf_swevent_init:

[  488.092839] AddressSanitizer: use after free in perf_swevent_del+0x33/0x70 at addr ffff8805f430ea48
[  488.094444] page:ffffea0017d0c380 count:0 mapcount:0 mapping:          (null) index:0x0
[  488.095681] page flags: 0x6fffff80008000(tail)
[  488.096407] page dumped because: kasan error
[  488.097116] CPU: 17 PID: 9306 Comm: trinity-main Not tainted 3.16.0-rc6-next-20140725-sasha-00048-ga713fc0-dirty #937
[  488.098736]  00000000000000fb 0000000000000000 ffffea0017d0c380 ffff8805f444b740
[  488.099933]  ffffffffb6dc96f3 ffff8805f444b810 ffff8805f444b800 ffffffffb242d17c
[  488.100020]  ffff880be215f448 ffff880be215f45d ffff8805ff7e2dc0 ffff8805ff7e2dd0
[  488.100020] Call Trace:
[  488.100020] dump_stack (lib/dump_stack.c:52)
[  488.100020] kasan_report_error (mm/kasan/report.c:98 mm/kasan/report.c:166)
[  488.100020] ? kvm_clock_read (./arch/x86/include/asm/preempt.h:90 arch/x86/kernel/kvmclock.c:86)
[  488.100020] ? sched_clock (./arch/x86/include/asm/paravirt.h:192 arch/x86/kernel/tsc.c:304)
[  488.100020] ? sched_clock_local (kernel/sched/clock.c:214)
[  488.100020] __asan_store8 (mm/kasan/kasan.c:400)
[  488.100020] ? perf_swevent_del (include/linux/list.h:618 include/linux/rculist.h:345 kernel/events/core.c:5758)
[  488.100020] perf_swevent_del (include/linux/list.h:618 include/linux/rculist.h:345 kernel/events/core.c:5758)
[  488.100020] event_sched_out.isra.49 (kernel/events/core.c:1416)
[  488.100020] group_sched_out (kernel/events/core.c:1442)
[  488.100020] ctx_sched_out (kernel/events/core.c:2185 (discriminator 3))
[  488.100020] __perf_event_task_sched_out (kernel/events/core.c:2360 kernel/events/core.c:2385)
[  488.100020] ? __perf_event_task_sched_out (include/linux/rcupdate.h:806 kernel/events/core.c:2314 kernel/events/core.c:2385)
[  488.100020] ? update_stats_wait_end (kernel/sched/fair.c:760)
[  488.100020] perf_event_task_sched_out (include/linux/perf_event.h:702)
[  488.100020] ? __schedule (kernel/sched/core.c:2773)
[  488.100020] ? __schedule (kernel/sched/core.c:2773)
[  488.100020] __schedule (kernel/sched/core.c:2146 kernel/sched/core.c:2184 kernel/sched/core.c:2308 kernel/sched/core.c:2810)
[  488.100020] preempt_schedule_irq (./arch/x86/include/asm/paravirt.h:814 kernel/sched/core.c:2927)
[  488.100020] retint_kernel (arch/x86/kernel/entry_64.S:935)
[  488.100020] ? __asan_load4 (mm/kasan/kasan.c:358)
[  488.100020] ? debug_lockdep_rcu_enabled (kernel/rcu/update.c:134)
[  488.100020] __fget_light (include/linux/fdtable.h:77 fs/file.c:684)
[  488.100020] __fdget_raw (fs/file.c:704)
[  488.100020] path_init (include/linux/file.h:60 fs/namei.c:1873)
[  488.100020] ? path_lookupat (fs/namei.c:1937)
[  488.100020] ? trace_hardirqs_on (kernel/locking/lockdep.c:2607)
[  488.100020] path_lookupat (fs/namei.c:1937)
[  488.100020] ? poison_shadow (mm/kasan/kasan.c:76)
[  488.100020] ? unpoison_shadow (mm/kasan/kasan.c:82)
[  488.100020] ? kasan_slab_alloc (mm/kasan/kasan.c:206)
[  488.100020] ? strncpy_from_user (./arch/x86/include/asm/word-at-a-time.h:48 lib/strncpy_from_user.c:44 lib/strncpy_from_user.c:109)
[  488.100020] filename_lookup (fs/namei.c:1984)
[  488.100020] user_path_at_empty (fs/namei.c:2135)
[  488.100020] ? check_chain_key (kernel/locking/lockdep.c:2188)
[  488.100020] ? put_lock_stats.isra.13 (./arch/x86/include/asm/preempt.h:98 kernel/locking/lockdep.c:254)
[  488.100020] ? get_parent_ip (kernel/sched/core.c:2561)
[  488.100020] user_path_at (fs/namei.c:2146)
[  488.100020] vfs_fstatat (fs/stat.c:107)
[  488.100020] ? trace_hardirqs_on_caller (kernel/locking/lockdep.c:2600)
[  488.100020] SYSC_newfstatat (fs/stat.c:298)
[  488.100020] ? syscall_trace_enter (arch/x86/kernel/ptrace.c:1500 (discriminator 2))
[  488.100020] ? trace_hardirqs_on_caller (kernel/locking/lockdep.c:2600)
[  488.100020] ? tracesys (arch/x86/kernel/entry_64.S:530)
[  488.100020] SyS_newfstatat (fs/stat.c:291)
[  488.100020] tracesys (arch/x86/kernel/entry_64.S:541)
[  488.100020] Write of size 8 by thread T9306:
[  488.100020] Memory state around the buggy address:
[  488.100020]  ffff8805f430e780: fc fc fc fc fc fc fb fb fb fb fb fb fb fb fb fb
[  488.100020]  ffff8805f430e800: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  488.100020]  ffff8805f430e880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  488.100020]  ffff8805f430e900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  488.100020]  ffff8805f430e980: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  488.100020] >ffff8805f430ea00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  488.100020]                                               ^
[  488.100020]  ffff8805f430ea80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  488.100020]  ffff8805f430eb00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  488.100020]  ffff8805f430eb80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  488.100020]  ffff8805f430ec00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  488.100020]  ffff8805f430ec80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb

[  517.616094] =============================================================================
[  517.619549] BUG kmalloc-4096 (Not tainted): Poison overwritten
[  517.621321] -----------------------------------------------------------------------------
[  517.621321]
[  517.621321] Disabling lock debugging due to kernel taint
[  517.621321] INFO: 0xffff8805f430ea48-0xffff8805f430eb77. First byte 0x0 instead of 0x6b
[  517.621321] INFO: Allocated in perf_swevent_init+0x29f/0x440 age=14082 cpu=17 pid=9306
[  517.621321]  __slab_alloc+0x65e/0x740
[  517.621321]  kmem_cache_alloc_trace+0x17c/0x3a0
[  517.621321]  perf_swevent_init+0x29f/0x440
[  517.621321]  perf_init_event+0x293/0x340
[  517.621321]  perf_event_alloc+0x5b8/0x6e0
[  517.621321]  SYSC_perf_event_open+0x39b/0xf50
[  517.621321]  SyS_perf_event_open+0x9/0x10
[  517.621321]  tracesys+0xe1/0xe6
[  517.621321] INFO: Freed in rcu_nocb_kthread+0x911/0x13f0 age=2958 cpu=3 pid=25
[  517.621321]  __slab_free+0x276/0x3e0
[  517.621321]  kfree+0x31a/0x390
[  517.621321]  rcu_nocb_kthread+0x911/0x13f0
[  517.621321]  kthread+0x144/0x170
[  517.621321]  ret_from_fork+0x7c/0xb0
[  517.621321] INFO: Slab 0xffffea0017d0c200 objects=7 used=7 fp=0x          (null) flags=0x6fffff80004080
[  517.621321] INFO: Object 0xffff8805f430e7b0 @offset=26544 fp=0xffff8805f4308000
[...]


Thanks,
Sasha
