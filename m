Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199AbaIITZB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 15:25:01 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:34417 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbaIITY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 15:24:59 -0400
Message-ID: <540F53C9.6040800@oracle.com>
Date: Tue, 09 Sep 2014 15:23:53 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, paulus@samba.org,
        Ingo Molnar <mingo@kernel.org>, acme@ghostprotocols.net
CC: LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: perf: NULL ptr deref in perf_event_context_sched_in
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While fuzzing with trinity inside a KVM tools guest running the latest -next
kernel, I've stumbled on the following spew:

[ 1181.492212] BUG: unable to handle kernel NULL pointer dereference at 0000000000000040
[ 1181.500717] IP: perf_event_context_sched_in (kernel/events/core.c:333 kernel/events/core.c:2575)
[ 1181.500717] PGD 4b0d10067 PUD 4bcd66067 PMD 0
[ 1181.500717] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[ 1181.506884] Dumping ftrace buffer:
[ 1181.506884]    (ftrace buffer empty)
[ 1181.506884] Modules linked in:
[ 1181.506884] CPU: 19 PID: 15980 Comm: trinity-c577 Not tainted 3.17.0-rc4-next-20140909-sasha-00032-gc16d47b-dirty #1132
[ 1181.506884] task: ffff8803a2b4b000 ti: ffff88049e4a4000 task.ti: ffff88049e4a4000
[ 1181.506884] RIP: perf_event_context_sched_in (kernel/events/core.c:333 kernel/events/core.c:2575)
[ 1181.516705] RSP: 0018:ffff88049e4a7a08  EFLAGS: 00010082
[ 1181.516705] RAX: 0000000000000000 RBX: ffff8809585d7b80 RCX: 00000113166c1a41
[ 1181.516705] RDX: 0000000000000003 RSI: ffff8803a2b4b000 RDI: ffff8803dd8069a0
[ 1181.516705] RBP: ffff88049e4a7a28 R08: 000000000007ce22 R09: 0000000000000000
[ 1181.516705] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8803dd8069a0
[ 1181.516705] R13: ffff8803a2b4b000 R14: 0000000000000002 R15: ffff8803f3943000
[ 1181.516705] FS:  00007ff20a25d700(0000) GS:ffff880958400000(0000) knlGS:0000000000000000
[ 1181.516705] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1181.516705] CR2: 0000000000000040 CR3: 000000041017a000 CR4: 00000000000006a0
[ 1181.516705] Stack:
[ 1181.516705]  0000000000000002 ffff8809585d7b80 ffff8803a2b4b000 ffff8803f3943000
[ 1181.516705]  ffff88049e4a7a78 ffffffffb52901f5 00000000001d4340 ffff8803f3943000
[ 1181.516705]  ffff8803f3943000 0000000000000000 ffff8809585d7b80 ffff8803f3943000
[ 1181.516705] Call Trace:
[ 1181.516705] __perf_event_task_sched_in (kernel/events/core.c:2683)
[ 1181.516705] finish_task_switch (include/linux/perf_event.h:704 kernel/sched/core.c:2224)
[ 1181.516705] __schedule (kernel/sched/core.c:2834)
[ 1181.516705] ? __delayacct_blkio_start (kernel/delayacct.c:67)
[ 1181.516705] ? out_of_line_wait_on_bit (kernel/sched/wait.c:516)
[ 1181.516705] schedule (kernel/sched/core.c:2864)
[ 1181.516705] io_schedule (kernel/sched/core.c:4352)
[ 1181.516705] bit_wait_io (kernel/sched/wait.c:520)
[ 1181.516705] __wait_on_bit (kernel/sched/wait.c:329)
[ 1181.516705] ? put_lock_stats.isra.12 (./arch/x86/include/asm/preempt.h:98 kernel/locking/lockdep.c:254)
[ 1181.516705] wait_on_page_bit (mm/filemap.c:692)
[ 1181.516705] ? wake_atomic_t_function (kernel/sched/wait.c:301)
[ 1181.516705] __migration_entry_wait.isra.26 (include/linux/pagemap.h:507 mm/migrate.c:257)
[ 1181.516705] migration_entry_wait (mm/migrate.c:270)
[ 1181.516705] do_swap_page.isra.39 (mm/memory.c:2426)
[ 1181.516705] ? kvm_clock_read (./arch/x86/include/asm/preempt.h:90 arch/x86/kernel/kvmclock.c:86)
[ 1181.516705] ? sched_clock (./arch/x86/include/asm/paravirt.h:192 arch/x86/kernel/tsc.c:304)
[ 1181.516705] ? sched_clock_local (kernel/sched/clock.c:214)
[ 1181.516705] ? get_parent_ip (kernel/sched/core.c:2578)
[ 1181.516705] ? preempt_count_sub (kernel/sched/core.c:2634)
[ 1181.516705] __handle_mm_fault (mm/memory.c:3223 mm/memory.c:3341)
[ 1181.516705] handle_mm_fault (include/linux/memcontrol.h:120 mm/memory.c:3373)
[ 1181.516705] __do_page_fault (arch/x86/mm/fault.c:1231)
[ 1181.516705] ? vtime_account_user (kernel/sched/cputime.c:681)
[ 1181.516705] ? get_parent_ip (kernel/sched/core.c:2578)
[ 1181.516705] ? context_tracking_user_exit (include/linux/vtime.h:89 include/linux/jump_label.h:114 include/trace/events/context_tracking.h:47 kernel/context_tracking.c:180)
[ 1181.516705] ? preempt_count_sub (kernel/sched/core.c:2634)
[ 1181.516705] ? context_tracking_user_exit (kernel/context_tracking.c:184)
[ 1181.516705] ? __this_cpu_preempt_check (lib/smp_processor_id.c:63)
[ 1181.516705] ? trace_hardirqs_off_caller (kernel/locking/lockdep.c:2640 (discriminator 2))
[ 1181.516705] trace_do_page_fault (arch/x86/mm/fault.c:1314 include/linux/jump_label.h:114 include/linux/context_tracking_state.h:27 include/linux/context_tracking.h:45 arch/x86/mm/fault.c:1315)
[ 1181.516705] do_async_page_fault (arch/x86/kernel/kvm.c:265)
[ 1181.516705] async_page_fault (arch/x86/kernel/entry_64.S:1314)
[ 1181.516705] Code: 7d f8 c9 c3 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 48 83 ec 20 4c 89 65 f0 49 89 fc 4c 89 6d f8 49 89 f5 48 89 5d e8 48 8b 07 <48> 8b 58 40 e8 ca ee 8d 00 89 c0 48 03 1c c5 c0 7e 2b bb 4c 39
All code
========
   0:	7d f8                	jge    0xfffffffffffffffa
   2:	c9                   	leaveq
   3:	c3                   	retq
   4:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
   b:	00 00 00
   e:	55                   	push   %rbp
   f:	48 89 e5             	mov    %rsp,%rbp
  12:	48 83 ec 20          	sub    $0x20,%rsp
  16:	4c 89 65 f0          	mov    %r12,-0x10(%rbp)
  1a:	49 89 fc             	mov    %rdi,%r12
  1d:	4c 89 6d f8          	mov    %r13,-0x8(%rbp)
  21:	49 89 f5             	mov    %rsi,%r13
  24:	48 89 5d e8          	mov    %rbx,-0x18(%rbp)
  28:	48 8b 07             	mov    (%rdi),%rax
  2b:*	48 8b 58 40          	mov    0x40(%rax),%rbx		<-- trapping instruction
  2f:	e8 ca ee 8d 00       	callq  0x8deefe
  34:	89 c0                	mov    %eax,%eax
  36:	48 03 1c c5 c0 7e 2b 	add    -0x44d48140(,%rax,8),%rbx
  3d:	bb
  3e:	4c 39 00             	cmp    %r8,(%rax)

Code starting with the faulting instruction
===========================================
   0:	48 8b 58 40          	mov    0x40(%rax),%rbx
   4:	e8 ca ee 8d 00       	callq  0x8deed3
   9:	89 c0                	mov    %eax,%eax
   b:	48 03 1c c5 c0 7e 2b 	add    -0x44d48140(,%rax,8),%rbx
  12:	bb
  13:	4c 39 00             	cmp    %r8,(%rax)
[ 1181.516705] RIP perf_event_context_sched_in (kernel/events/core.c:333 kernel/events/core.c:2575)
[ 1181.516705]  RSP <ffff88049e4a7a08>
[ 1181.516705] CR2: 0000000000000040


Thanks,
Sasha
