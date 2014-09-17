Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344AbaIQVbH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 17:31:07 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:25878 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756415AbaIQVbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 17:31:05 -0400
Message-ID: <5419FD5F.7090407@oracle.com>
Date: Wed, 17 Sep 2014 17:30:07 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
CC: Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: sched: NULL ptr deref in update_blocked_averages
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While fuzzing with trinity inside a KVM tools guest running the latest -next
kernel, I've stumbled on the following spew:

[  688.177091] BUG: unable to handle kernel NULL pointer dereference at 00000000000000e0
[  688.184049] IP: update_blocked_averages (kernel/sched/fair.c:5512 (discriminator 17) kernel/sched/fair.c:5557 (discriminator 17))
[  688.186981] PGD 66fe03067 PUD 66f550067 PMD 0
[  688.186981] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[  688.186981] Dumping ftrace buffer:
[  688.186981]    (ftrace buffer empty)
[  688.186981] Modules linked in:
[  688.186981] CPU: 2 PID: 14377 Comm: trinity-c269 Tainted: G        W      3.17.0-rc5-next-20140917-sasha-00041-gd01267b #1198
[  688.186981] task: ffff88068c02b000 ti: ffff8806478ec000 task.ti: ffff8806478ec000
[  688.186981] RIP: update_blocked_averages (kernel/sched/fair.c:5512 (discriminator 17) kernel/sched/fair.c:5557 (discriminator 17))
[  688.186981] RSP: 0018:ffff880111c03dc8  EFLAGS: 00010006
[  688.186981] RAX: 0000000000000000 RBX: ffff880111de2a00 RCX: 0000000000000000
[  688.186981] RDX: 0000000000000002 RSI: ffffffffa408a480 RDI: 0000000000000082
[  688.186981] RBP: ffff880111c03e18 R08: 0000000000000000 R09: 0000000000000000
[  688.186981] R10: ffff880102a8dbe0 R11: ffff880111de2ac8 R12: ffff8800a1b23b10
[  688.186981] R13: ffff8800a1b23bd0 R14: 0000000000000000 R15: ffff880111de3330
[  688.186981] FS:  00007ff7df150700(0000) GS:ffff880111c00000(0000) knlGS:0000000000000000
[  688.186981] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  688.186981] CR2: 00000000000000e0 CR3: 000000066fe02000 CR4: 00000000000006a0
[  688.186981] Stack:
[  688.186981]  0000001200000003 0000000000000296 0000000000000002 ffff8800a1b23bd0
[  688.186981]  ffff880111c03e28 00000001000097a2 0000000000000007 0000000000000007
[  688.186981]  0000000000000001 0000000000000001 ffff880111c03e98 ffffffff9f1abc8b
[  688.186981] Call Trace:
[  688.186981]  <IRQ>
[  688.186981] rebalance_domains (kernel/sched/fair.c:7240)
[  688.186981] ? trace_hardirqs_on_caller (kernel/locking/lockdep.c:2559 kernel/locking/lockdep.c:2601)
[  688.186981] run_rebalance_domains (kernel/sched/fair.c:7449)
[  688.186981] ? __lock_is_held (kernel/locking/lockdep.c:3518)
[  688.186981] __do_softirq (kernel/softirq.c:269 include/linux/jump_label.h:114 include/trace/events/irq.h:126 kernel/softirq.c:270)
[  688.186981] ? irq_exit (include/linux/vtime.h:82 include/linux/vtime.h:121 kernel/softirq.c:384)
[  688.186981] irq_exit (kernel/softirq.c:346 kernel/softirq.c:387)
[  688.186981] smp_trace_apic_timer_interrupt (arch/x86/kernel/apic/apic.c:969)
[  688.232227] FAULT_INJECTION: forcing a failure
[  688.186981] trace_apic_timer_interrupt (arch/x86/kernel/entry_64.S:999)
[  688.186981]  <EOI>
[  688.186981] ? _raw_spin_unlock_irqrestore (./arch/x86/include/asm/paravirt.h:809 include/linux/spinlock_api_smp.h:160 kernel/locking/spinlock.c:191)
[  688.186981] p9_virtio_request (net/9p/trans_virtio.c:312)
[  688.186981] p9_client_rpc (net/9p/client.c:748)
[  688.186981] ? v9fs_file_fsync_dotl (fs/9p/vfs_file.c:568)
[  688.186981] ? preempt_count_sub (kernel/sched/core.c:2634)
[  688.186981] p9_client_fsync (net/9p/client.c:1433)
[  688.186981] v9fs_file_fsync_dotl (fs/9p/vfs_file.c:573)
[  688.186981] do_fsync (include/linux/file.h:38 fs/sync.c:207)
[  688.186981] SyS_fsync (fs/sync.c:212)
[  688.186981] tracesys_phase2 (arch/x86/kernel/entry_64.S:529)
[ 688.186981] Code: 30 09 00 00 4d 8d a5 40 ff ff ff 4d 39 ef 0f 84 95 02 00 00 0f 1f 84 00 00 00 00 00 49 8b 84 24 d0 00 00 00 48 63 93 f8 09 00 00 <48> 8b 88 e0 00 00 00 4c 8b 2c d1 66 66 66 66 90 48 8b 80 d8 00
All code
========
   0:	30 09                	xor    %cl,(%rcx)
   2:	00 00                	add    %al,(%rax)
   4:	4d 8d a5 40 ff ff ff 	lea    -0xc0(%r13),%r12
   b:	4d 39 ef             	cmp    %r13,%r15
   e:	0f 84 95 02 00 00    	je     0x2a9
  14:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  1b:	00
  1c:	49 8b 84 24 d0 00 00 	mov    0xd0(%r12),%rax
  23:	00
  24:	48 63 93 f8 09 00 00 	movslq 0x9f8(%rbx),%rdx
  2b:*	48 8b 88 e0 00 00 00 	mov    0xe0(%rax),%rcx		<-- trapping instruction
  32:	4c 8b 2c d1          	mov    (%rcx,%rdx,8),%r13
  36:	66 66 66 66 90       	data32 data32 data32 xchg %ax,%ax
  3b:	48                   	rex.W
  3c:	8b                   	.byte 0x8b
  3d:	80 d8 00             	sbb    $0x0,%al
	...

Code starting with the faulting instruction
===========================================
   0:	48 8b 88 e0 00 00 00 	mov    0xe0(%rax),%rcx
   7:	4c 8b 2c d1          	mov    (%rcx,%rdx,8),%r13
   b:	66 66 66 66 90       	data32 data32 data32 xchg %ax,%ax
  10:	48                   	rex.W
  11:	8b                   	.byte 0x8b
  12:	80 d8 00             	sbb    $0x0,%al
	...
[  688.186981] RIP update_blocked_averages (kernel/sched/fair.c:5512 (discriminator 17) kernel/sched/fair.c:5557 (discriminator 17))
[  688.186981]  RSP <ffff880111c03dc8>
[  688.186981] CR2: 00000000000000e0


Thanks,
Sasha
