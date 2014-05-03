Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830AbaECNQr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 09:16:47 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:45655 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbaECNQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 09:16:45 -0400
Message-ID: <5364EC10.9090900@oracle.com>
Date: Sat, 03 May 2014 09:16:00 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Mel Gorman <mgorman@suse.de>
CC: LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: sched,numa: invalid memory access in account_entity_dequeue
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While fuzzing with trinity inside a KVM tools guest running latest -next
kernel I've stumbled on the following:


[ 1796.591361] BUG: unable to handle kernel paging request at fffffffedf97f040
[ 1796.592665] IP: __cpu_to_node (arch/x86/mm/numa.c:777)
[ 1796.593710] PGD 21e30067 PUD 0
[ 1796.594174] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[ 1796.594937] Dumping ftrace buffer:
[ 1796.595678]    (ftrace buffer empty)
[ 1796.596329] Modules linked in:
[ 1796.596733] CPU: 2 PID: 0 Comm: swapper/2 Tainted: G        W     3.15.0-rc3-next-20140502-sasha-00019-g5cb1c98 #431
[ 1796.598143] task: ffff8803345b8000 ti: ffff880035fc0000 task.ti: ffff880035fc0000
[ 1796.598975] RIP: __cpu_to_node (arch/x86/mm/numa.c:777)
[ 1796.600093] RSP: 0018:ffff8800a6c03b88  EFLAGS: 00010046
[ 1796.600197] RAX: ffff8806e791a000 RBX: ffffffffe791a028 RCX: 0000000000000000
[ 1796.600197] RDX: 0000000000000001 RSI: ffff8806cdc68068 RDI: 00000000e791a028
[ 1796.600197] RBP: ffff8800a6c03b98 R08: ffff880496183078 R09: 00000000000151c6
[ 1796.600197] R10: 000000000000b731 R11: 0000000000000001 R12: ffff8801b4dd7840
[ 1796.600197] R13: 0000000000000000 R14: 000000000000001e R15: ffff8801b34ac1a0
[ 1796.600197] FS:  0000000000000000(0000) GS:ffff8800a6c00000(0000) knlGS:0000000000000000
[ 1796.600197] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1796.600197] CR2: fffffffedf97f040 CR3: 0000000021e2d000 CR4: 00000000000006a0
[ 1796.610323] Stack:
[ 1796.610323]  0000000000000000 ffff8801b34ac1a0 ffff8800a6c03bd8 ffffffff9d1a9646
[ 1796.610323]  ffff8800a6c03bd8 ffff8806cdc68068 ffff8806cdc68068 ffff8801b34ac1a0
[ 1796.610323]  0000000000000000 000000000000b7db ffff8800a6c03c38 ffffffff9d1ae987
[ 1796.610323] Call Trace:
[ 1796.610323]  <IRQ>
[ 1796.610323] account_entity_dequeue (kernel/sched/fair.c:859 kernel/sched/fair.c:2009)
[ 1796.610323] dequeue_entity (kernel/sched/fair.c:2827)
[ 1796.610323] dequeue_task_fair (kernel/sched/fair.c:3907 include/linux/jump_label.h:105 kernel/sched/fair.c:3041 kernel/sched/fair.c:3217 kernel/sched/fair.c:3915)
[ 1796.610323] dequeue_task (kernel/sched/core.c:793)
[ 1796.610323] deactivate_task (kernel/sched/core.c:809)
[ 1796.610323] move_task (kernel/sched/fair.c:5032)
[ 1796.610323] load_balance (kernel/sched/fair.c:5305 kernel/sched/fair.c:6485)
[ 1796.610323] ? debug_smp_processor_id (lib/smp_processor_id.c:57)
[ 1796.610323] rebalance_domains (kernel/sched/fair.c:7032)
[ 1796.610323] ? rebalance_domains (kernel/sched/fair.c:6975)
[ 1796.610323] run_rebalance_domains (kernel/sched/fair.c:7105 kernel/sched/fair.c:7198)
[ 1796.610323] __do_softirq (kernel/softirq.c:269 include/linux/jump_label.h:105 include/trace/events/irq.h:126 kernel/softirq.c:270)
[ 1796.610323] ? irq_exit (include/linux/vtime.h:82 include/linux/vtime.h:121 kernel/softirq.c:384)
[ 1796.610323] irq_exit (kernel/softirq.c:346 kernel/softirq.c:387)
[ 1796.610323] scheduler_ipi (kernel/sched/core.c:1545)
[ 1796.610323] smp_reschedule_interrupt (arch/x86/kernel/smp.c:266)
[ 1796.610323] reschedule_interrupt (arch/x86/kernel/entry_64.S:1178)
[ 1796.610323]  <EOI>
[ 1796.610323] ? native_safe_halt (arch/x86/include/asm/irqflags.h:50)
[ 1796.610323] ? trace_hardirqs_on (kernel/locking/lockdep.c:2607)
[ 1796.637135] default_idle (arch/x86/include/asm/paravirt.h:111 arch/x86/kernel/process.c:310)
[ 1796.637135] arch_cpu_idle (arch/x86/kernel/process.c:302)
[ 1796.637135] cpu_idle_loop (kernel/sched/idle.c:179 kernel/sched/idle.c:226)
[ 1796.637135] cpu_startup_entry (??:?)
[ 1796.637135] start_secondary (arch/x86/kernel/smpboot.c:267)
[ 1796.637135] Code: 3a ea 05 00 74 25 89 de 48 c7 c7 08 b4 6c a1 31 c0 e8 99 6c 45 03 e8 7c 39 46 03 48 8b 05 71 3a ea 05 8b 04 98 eb 16 0f 1f 40 00 <48> 8b 14 dd 00 ef 0a a3 48 c7 c0 d8 f4 00 00 8b 04 10 48 83 c4
[ 1796.637135] RIP __cpu_to_node (arch/x86/mm/numa.c:777)
[ 1796.637135]  RSP <ffff8800a6c03b88>
[ 1796.637135] CR2: fffffffedf97f040



Thanks,
Sasha
