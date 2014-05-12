Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038AbaELPnO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 11:43:14 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:50259 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbaELPnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 11:43:13 -0400
Message-ID: <5370EBE9.6@oracle.com>
Date: Mon, 12 May 2014 11:42:33 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        acme@ghostprotocols.net
CC: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Dave Jones <davej@redhat.com>
Subject: perf: use after free in perf_remove_from_context
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While fuzzing with trinity inside a KVM tools guest running the latest -next
kernel I've stumbled on the following spew. Maybe related to the very recent
change in freeing on task exit?

[ 2509.827261] general protection fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[ 2509.830379] Dumping ftrace buffer:
[ 2509.830379]    (ftrace buffer empty)
[ 2509.830379] Modules linked in:
[ 2509.830379] CPU: 47 PID: 43306 Comm: trinity-c126 Tainted: G        W     3.15.0-rc5-next-20140512-sasha-00019-ga20bc00-dirty #456
[ 2509.830379] task: ffff880142e03000 ti: ffff880129628000 task.ti: ffff880129628000
[ 2509.830379] RIP: perf_remove_from_context (kernel/events/core.c:1495)
[ 2509.830379] RSP: 0000:ffff880129629bf8  EFLAGS: 00010292
[ 2509.830379] RAX: 0000000000000000 RBX: 6b6b6b6b6b6b6b6b RCX: 0000000000000001
[ 2509.830379] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 6b6b6b6b6b6b6b6b
[ 2509.830379] RBP: ffff880129629c38 R08: 0000000000000000 R09: 0000000000000000
[ 2509.830379] R10: 0000000000000001 R11: 0000000000000000 R12: ffff8801439caaa8
[ 2509.830379] R13: ffff88002cc84a40 R14: 6b6b6b6b6b6b6b6b R15: 0000000000000001
[ 2509.830379] FS:  00007fcd0ca92700(0000) GS:ffff8803a0e00000(0000) knlGS:0000000000000000
[ 2509.830379] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2509.830379] CR2: 00000000029b7ff8 CR3: 00000004ad510000 CR4: 00000000000006a0
[ 2509.830379] DR0: 00000000006df000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2509.830379] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
[ 2509.830379] Stack:
[ 2509.830379]  6b6b6b6b6b6b6b6b 0000000000000201 ffff880129629c28 6b6b6b6b6b6b6b6b
[ 2509.830379]  ffff8801439caaa8 ffff88002cc84a40 ffff880142e03000 0000000000000001
[ 2509.830379]  ffff880129629ca8 ffffffffa127fa81 ffff880112f77200 ffff88002cc84c38
[ 2509.830379] Call Trace:
[ 2509.830379] perf_event_exit_task (kernel/events/core.c:7426 kernel/events/core.c:7489 kernel/events/core.c:7520)
[ 2509.830379] do_exit (kernel/exit.c:766)
[ 2509.830379] ? debug_smp_processor_id (lib/smp_processor_id.c:57)
[ 2509.830379] ? put_lock_stats.isra.12 (arch/x86/include/asm/preempt.h:98 kernel/locking/lockdep.c:254)
[ 2509.830379] ? _raw_spin_unlock_irq (arch/x86/include/asm/paravirt.h:819 include/linux/spinlock_api_smp.h:168 kernel/locking/spinlock.c:199)
[ 2509.830379] do_group_exit (kernel/exit.c:884)
[ 2509.830379] get_signal_to_deliver (kernel/signal.c:2346)
[ 2509.830379] ? vtime_account_user (kernel/sched/cputime.c:687)
[ 2509.830379] do_signal (arch/x86/kernel/signal.c:698)
[ 2509.830379] ? vtime_account_user (kernel/sched/cputime.c:687)
[ 2509.830379] ? preempt_count_sub (kernel/sched/core.c:2575)
[ 2509.830379] ? context_tracking_user_exit (arch/x86/include/asm/paravirt.h:809 (discriminator 2) kernel/context_tracking.c:182 (discriminator 2))
[ 2509.830379] ? __this_cpu_preempt_check (lib/smp_processor_id.c:63)
[ 2509.830379] ? trace_hardirqs_on_caller (kernel/locking/lockdep.c:2557 kernel/locking/lockdep.c:2599)
[ 2509.830379] do_notify_resume (arch/x86/kernel/signal.c:751)
[ 2509.830379] retint_signal (arch/x86/kernel/entry_64.S:1125)
[ 2509.830379] Code: f8 c9 c3 0f 1f 00 55 48 89 e5 41 57 41 89 f7 41 56 49 89 fe 41 55 41 54 53 48 83 ec 18 40 88 75 c8 8b 35 0f c4 ae 05 48 89 7d c0 <4c> 8b a7 d8 01 00 00 85 f6 4d 8b ac 24 50 01 00 00 74 18 49 8d
[ 2509.830379] RIP perf_remove_from_context (kernel/events/core.c:1495)
[ 2509.830379]  RSP <ffff880129629bf8>


Thanks,
Sasha
