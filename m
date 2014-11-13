Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900AbaKMAI1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 19:08:27 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:37643 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbaKMAIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 19:08:25 -0500
Message-ID: <5463F66D.7070300@oracle.com>
Date: Wed, 12 Nov 2014 19:08:13 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: miklos@szeredi.hu, Al Viro <viro@ZenIV.linux.org.uk>
CC: fuse-devel@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>
Subject: fuse: invalid memory dereference on fput
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I've seen two similar traces of fuse trying to lock a spinlock which is not located
on valid memory.

>From the first trace:

[  945.221982] general protection fault: 0000 [#1]
[  945.221982] irq event stamp: 381060
[  945.222011] hardirqs last enabled at (381059): __do_page_fault (./arch/x86/include/asm/paravirt.h:819 arch/x86/mm/fault.c:1149)
[  945.222028] hardirqs last disabled at (381060): context_tracking_user_enter (kernel/context_tracking.c:78)
[  945.222041] softirqs last enabled at (380804): __do_softirq (./arch/x86/include/asm/preempt.h:22 kernel/softirq.c:296)
[  945.222050] softirqs last disabled at (380801): irq_exit (kernel/softirq.c:346 kernel/softirq.c:387)
[  945.219713] PREEMPT SMP DEBUG_PAGEALLOC KASAN
[  945.219713] Dumping ftrace buffer:
[  945.219713]    (ftrace buffer empty)
[  945.219713] Modules linked in:
[  945.219713] CPU: 12 PID: 6988 Comm: trinity-c130 Tainted: G        W      3.18.0-rc3-next-20141110-sasha-00057-g3f1b7d0-dirty #1452
[  945.219713] task: ffff8804f2cc8000 ti: ffff8805109c4000 task.ti: ffff8805109c4000
[  945.219713] RIP: __bfs (kernel/locking/lockdep.c:965 kernel/locking/lockdep.c:1029)
[  945.219713] RSP: 0018:ffff8805109c7908  EFLAGS: 00010002
[  945.219713] RAX: 0000000000000002 RBX: ffffffff9fbddbd0 RCX: 0000000000000000
[  945.219713] RDX: 000000000180916e RSI: 0000000000000000 RDI: ffff8804f2ccaa4c
[  945.219713] RBP: ffff8805109c7978 R08: 0000000000000001 R09: 0000000000000010
[  945.219713] R10: 0000000000000003 R11: 2030376635353662 R12: ffff8805109c79c8
[  945.219713] R13: dfffe90000000000 R14: ffffffff815dad00 R15: 0000000000000000
[  945.219713] FS:  00007f8fb4489700(0000) GS:ffff8805c3c00000(0000) knlGS:0000000000000000
[  945.219713] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  945.219713] CR2: 00007f8fad813e40 CR3: 000000001482f000 CR4: 00000000000006a4
[  945.219713] Stack:
[  945.219713]  ffff8805109c7918 ffffffff811f5221 000000000180916e ffff8805109c79c0
[  945.219713]  000000006bd1d317 0000000000000000 ffff8805c3c03fc0 ffff8805109c79c8
[  945.219713]  0000000000000000 0000000000000000 ffff8805109c79c8 ffff8805109c79c0
[  945.219713] Call Trace:
[  945.219713] ? sched_clock (./arch/x86/include/asm/paravirt.h:192 arch/x86/kernel/tsc.c:304)
[  945.219713] find_usage_backwards (kernel/locking/lockdep.c:1367 (discriminator 8))
[  945.219713] check_usage_backwards (kernel/locking/lockdep.c:2380)
[  945.219713] ? save_stack_trace (arch/x86/kernel/stacktrace.c:64)
[  945.219713] mark_lock (kernel/locking/lockdep.c:2474 kernel/locking/lockdep.c:2922)
[  945.219713] ? sched_clock_cpu (kernel/sched/clock.c:311)
[  945.219713] ? check_usage_forwards (kernel/locking/lockdep.c:2373)
[  945.219713] __lock_acquire (kernel/locking/lockdep.c:2802 kernel/locking/lockdep.c:3140)
[  945.219713] ? kvm_clock_read (./arch/x86/include/asm/preempt.h:87 arch/x86/kernel/kvmclock.c:85)
[  945.219713] ? sched_clock (./arch/x86/include/asm/paravirt.h:192 arch/x86/kernel/tsc.c:304)
[  945.219713] ? sched_clock_local (kernel/sched/clock.c:202)
[  945.219713] ? get_parent_ip (kernel/sched/core.c:2588)
[  945.219713] ? preempt_count_sub (kernel/sched/core.c:2644)
[  945.219713] ? put_lock_stats.isra.4 (./arch/x86/include/asm/preempt.h:95 kernel/locking/lockdep.c:254)
[  945.219713] lock_acquire (kernel/locking/lockdep.c:3604)
[  945.219713] ? fuse_dev_release (fs/fuse/dev.c:2118)
[  945.219713] _raw_spin_lock (include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:151)
[  945.219713] ? fuse_dev_release (fs/fuse/dev.c:2118)
[  945.219713] fuse_dev_release (fs/fuse/dev.c:2118)
[  945.219713] __fput (fs/file_table.c:209)
[  945.219713] ____fput (fs/file_table.c:245)
[  945.219713] task_work_run (kernel/task_work.c:125 (discriminator 1))
[  945.219713] ? switch_task_namespaces (kernel/nsproxy.c:212)
[  945.219713] do_exit (kernel/exit.c:740)
[  945.219713] ? __audit_seccomp (kernel/auditsc.c:2492)
[  945.219713] seccomp_phase1 (kernel/seccomp.c:178 kernel/seccomp.c:699)
[  945.219713] ? __this_cpu_preempt_check (lib/smp_processor_id.c:63)
[  945.219713] ? trace_hardirqs_on_caller (kernel/locking/lockdep.c:2559 kernel/locking/lockdep.c:2601)
[  945.219713] ? trace_hardirqs_on (kernel/locking/lockdep.c:2609)
[  945.219713] syscall_trace_enter_phase1 (arch/x86/kernel/ptrace.c:1524)
[  945.219713] tracesys (arch/x86/kernel/entry_64.S:500)
[ 945.219713] Code: ee 7f ec 1d 48 89 c2 0f 83 05 02 00 00 4d 85 ff 0f 84 28 03 00 00 41 f6 c7 07 0f 85 1e 03 00 00 4d 8d 4f 10 4c 89 c8 48 c1 e8 03 <42> 80 3c 28 00 0f 85 70 04 00 00 49 8b 47 10 48 85 c0 0f 84 80
All code
========
   0:   ee                      out    %al,(%dx)
   1:   7f ec                   jg     0xffffffffffffffef
   3:   1d 48 89 c2 0f          sbb    $0xfc28948,%eax
   8:   83 05 02 00 00 4d 85    addl   $0xffffff85,0x4d000002(%rip)        # 0x4d000011
   f:   ff 0f                   decl   (%rdi)
  11:   84 28                   test   %ch,(%rax)
  13:   03 00                   add    (%rax),%eax
  15:   00 41 f6                add    %al,-0xa(%rcx)
  18:   c7 07 0f 85 1e 03       movl   $0x31e850f,(%rdi)
  1e:   00 00                   add    %al,(%rax)
  20:   4d 8d 4f 10             lea    0x10(%r15),%r9
  24:   4c 89 c8                mov    %r9,%rax
  27:   48 c1 e8 03             shr    $0x3,%rax
  2b:*  42 80 3c 28 00          cmpb   $0x0,(%rax,%r13,1)               <-- trapping instruction
  30:   0f 85 70 04 00 00       jne    0x4a6
  36:   49 8b 47 10             mov    0x10(%r15),%rax
  3a:   48 85 c0                test   %rax,%rax
  3d:   0f                      .byte 0xf
  3e:   84                      .byte 0x84
  3f:   80                      .byte 0x80
        ...

Code starting with the faulting instruction
===========================================
   0:   42 80 3c 28 00          cmpb   $0x0,(%rax,%r13,1)
   5:   0f 85 70 04 00 00       jne    0x47b
   b:   49 8b 47 10             mov    0x10(%r15),%rax
   f:   48 85 c0                test   %rax,%rax
  12:   0f                      .byte 0xf
  13:   84                      .byte 0x84
  14:   80                      .byte 0x80
        ...
[  945.219713] RIP __bfs (kernel/locking/lockdep.c:965 kernel/locking/lockdep.c:1029)
[  945.219713]  RSP <ffff8805109c7908>

And from the second:

[ 1591.632824] WARNING: CPU: 2 PID: 32763 at kernel/locking/lockdep.c:3161 __lock_acquire+0x857/0x5dd0()
[ 1591.635094] DEBUG_LOCKS_WARN_ON(id >= MAX_LOCKDEP_KEYS)
[ 1591.636477] Modules linked in:
[ 1591.637377] CPU: 2 PID: 32763 Comm: trinity-c176 Not tainted 3.18.0-rc4-next-20141112-sasha-00047-g5d04499-dirty #1453
[ 1591.639998]  0000000000000000 0000000000000000 ffff88039d343be8 ffff88039d343b88
[ 1591.640076]  ffffffff92f656f0 0000000000000000 ffff88039d343bf0 ffff88039d343bd8
[ 1591.640076]  ffffffff8144f560 ffff88039d343bc8 ffffffff815f5597 ffff880399d08000
[ 1591.640076] Call Trace:
[ 1591.640076] dump_stack (lib/dump_stack.c:52)
[ 1591.640076] warn_slowpath_common (kernel/panic.c:444)
[ 1591.640076] ? __lock_acquire (kernel/locking/lockdep.c:3161 (discriminator 9))
[ 1591.640076] warn_slowpath_fmt (kernel/panic.c:458)
[ 1591.640076] __lock_acquire (kernel/locking/lockdep.c:3161 (discriminator 9))
[ 1591.640076] ? kvm_clock_read (./arch/x86/include/asm/preempt.h:87 arch/x86/kernel/kvmclock.c:85)
[ 1591.640076] ? kvm_clock_read (./arch/x86/include/asm/preempt.h:87 arch/x86/kernel/kvmclock.c:85)
[ 1591.640076] ? sched_clock (./arch/x86/include/asm/paravirt.h:192 arch/x86/kernel/tsc.c:304)
[ 1591.640076] ? sched_clock_local (kernel/sched/clock.c:202)
[ 1591.640076] lock_acquire (kernel/locking/lockdep.c:3604)
[ 1591.640076] ? fuse_dev_release (fs/fuse/dev.c:2118)
[ 1591.640076] _raw_spin_lock (include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:151)
[ 1591.640076] ? fuse_dev_release (fs/fuse/dev.c:2118)
[ 1591.640076] fuse_dev_release (fs/fuse/dev.c:2118)
[ 1591.640076] __fput (fs/file_table.c:209)
[ 1591.640076] ____fput (fs/file_table.c:245)
[ 1591.640076] task_work_run (kernel/task_work.c:125 (discriminator 1))
[ 1591.640076] do_notify_resume (include/linux/tracehook.h:190 arch/x86/kernel/signal.c:758)
[ 1591.640076] int_signal (arch/x86/kernel/entry_64.S:587)


Thanks,
Sasha
