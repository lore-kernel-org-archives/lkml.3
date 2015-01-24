Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391AbbAXBmg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 20:42:36 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:32459 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbbAXBmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 20:42:33 -0500
Message-ID: <54C2F80A.20700@oracle.com>
Date: Fri, 23 Jan 2015 20:40:26 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, acme@ghostprotocols.net
CC: LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@codemonkey.org.uk>
Subject: perf: NULL ptr deref in perf_event_mmap, d_path
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While fuzzing with trinity inside a KVM tools guest running the latest -next
kernel and the KASan patchset, I've stumbled on the following spew:

[  549.058124] general protection fault: 0000 [#1] PREEMPT SMP KASAN
[  549.060152] Dumping ftrace buffer:
[  549.060219]    (ftrace buffer empty)
[  549.062191] Modules linked in:
[  549.062191] CPU: 19 PID: 16330 Comm: modprobe Not tainted 3.19.0-rc5-next-20150123-sasha-00061-g527ff0d-dirty #1813
[  549.062191] task: ffff880399620000 ti: ffff88039bec0000 task.ti: ffff88039bec0000
[  549.062191] RIP: prepend_path (fs/dcache.c:2864)
[  549.062191] RSP: 0018:ffff88039bec7748  EFLAGS: 00010202
[  549.062191] RAX: 0000000000000004 RBX: 0000000000000000 RCX: 1ffff10000003733
[  549.062191] RDX: ffff88003deb79c0 RSI: ffff88039bec7858 RDI: ffff88003deb4eb0
[  549.062191] RBP: ffff88039bec7908 R08: dffffc0000000000 R09: 0000000000000000
[  549.062191] R10: ffff88039bec7648 R11: 0000000000000004 R12: 0000000000000020
[  549.062191] R13: 0000000000000000 R14: dffffc0000000000 R15: ffff88039bec79c8
[  549.062191] FS:  0000000000000000(0000) GS:ffff8805f8800000(0000) knlGS:0000000000000000
[  549.062191] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  549.062191] CR2: 00007f8a3989d4a0 CR3: 00000006b1a55000 CR4: 00000000000006a0
[  549.062191] DR0: a800000010000000 DR1: 0000000000000000 DR2: 0000000000000000
[  549.062191] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
[  549.062191] Stack:
[  549.062191]  ffffffff81c35e2b ffff880399620cf0 0000000041b58ab3 ffffffff95ab8e78
[  549.062191]  ffff88039bec79d0 1ffff100737d8ef7 ffff8805da69b758 ffffed00737d8f39
[  549.062191]  ffff88039bec7964 ffff88039bec7988 ffff8805da69b750 ffffed00737d8f3a
[  549.062191] Call Trace:
[  549.111668] d_path (fs/dcache.c:2987 fs/dcache.c:3044)
[  549.111668] perf_event_mmap (kernel/events/core.c:5435 kernel/events/core.c:5560)
[  549.111668] mmap_region (mm/mmap.c:1207 mm/mmap.c:1650)
[  549.111668] do_mmap_pgoff (mm/mmap.c:1393)
[  549.111668] vm_mmap_pgoff (mm/util.c:335)
[  549.111668] SyS_mmap_pgoff (mm/mmap.c:1443 mm/mmap.c:1401)
[  549.111668] SyS_mmap (arch/x86/kernel/sys_x86_64.c:70)
[  549.111668] tracesys_phase2 (arch/x86/kernel/entry_64.S:530)
[ 549.111668] Code: c7 07 0f 85 cc 00 00 00 48 39 d3 0f 84 cc 01 00 00 4d 85 e4 0f 84 90 08 00 00 41 f6 c4 07 0f 85 86 08 00 00 4c 89 e0 48 c1 e8 03 <42> 80 3c 30 00 0f 85 96 08 00 00 49 3b 1c 24 0f 84 2d 01 00 00
All code
========
   0:   c7 07 0f 85 cc 00       movl   $0xcc850f,(%rdi)
   6:   00 00                   add    %al,(%rax)
   8:   48 39 d3                cmp    %rdx,%rbx
   b:   0f 84 cc 01 00 00       je     0x1dd
  11:   4d 85 e4                test   %r12,%r12
  14:   0f 84 90 08 00 00       je     0x8aa
  1a:   41 f6 c4 07             test   $0x7,%r12b
  1e:   0f 85 86 08 00 00       jne    0x8aa
  24:   4c 89 e0                mov    %r12,%rax
  27:   48 c1 e8 03             shr    $0x3,%rax
  2b:*  42 80 3c 30 00          cmpb   $0x0,(%rax,%r14,1)               <-- trapping instruction
  30:   0f 85 96 08 00 00       jne    0x8cc
  36:   49 3b 1c 24             cmp    (%r12),%rbx
  3a:   0f 84 2d 01 00 00       je     0x16d
        ...

Code starting with the faulting instruction
===========================================
   0:   42 80 3c 30 00          cmpb   $0x0,(%rax,%r14,1)
   5:   0f 85 96 08 00 00       jne    0x8a1
   b:   49 3b 1c 24             cmp    (%r12),%rbx
   f:   0f 84 2d 01 00 00       je     0x142
        ...
[  549.111668] RIP prepend_path (fs/dcache.c:2864)
[  549.111668]  RSP <ffff88039bec7748>

Thanks,
Sasha
