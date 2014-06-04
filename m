Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207AbaFDOlq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 10:41:46 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:37029 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbaFDOlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 10:41:45 -0400
Message-ID: <538F3020.6000609@oracle.com>
Date: Wed, 04 Jun 2014 10:41:36 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>, Hugh Dickins <hughd@google.com>,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: mm: NULL ptr deref in anon_vma_fork
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While fuzzing with trinity inside a KVM tools guest running the latest -next
kernel I've stumbled on the following spew:

(Note that that what the RIP got translated to seems wrong to me, I'd ignore that
and look at mm/rmap.c:285 .)

[11075.253201] BUG: unable to handle kernel NULL pointer dereference at           (null)
[11075.254437] IP: anon_vma_clone (mm/rmap.c:1768)
[11075.255384] PGD 7a9616067 PUD 7932e0067 PMD 0
[11075.256150] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[11075.258315] Dumping ftrace buffer:
[11075.260035]    (ftrace buffer empty)
[11075.260035] Modules linked in:
[11075.260035] CPU: 26 PID: 13162 Comm: timeout3 Tainted: G    B   W     3.15.0-rc8-next-20140603-sasha-00019-ge0df846-dirty #589
[11075.260035] task: ffff8807a7b83000 ti: ffff8807931cc000 task.ti: ffff8807931cc000
[11075.260035] RIP: anon_vma_clone (mm/rmap.c:1768)
[11075.260035] RSP: 0018:ffff8807931cfcf0  EFLAGS: 00010282
[11075.260035] RAX: ffff880da9d137c8 RBX: ffff8807a96a9200 RCX: 0000000000000200
[11075.260035] RDX: 0000000000000001 RSI: 0000000000000050 RDI: ffff880da9d137c8
[11075.260035] RBP: ffff8807931cfd30 R08: ffff880da9d10ff0 R09: 0000000000000000
[11075.260035] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8807aa9f8000
[11075.260035] R13: ffff8807a96a9200 R14: ffff880da9d137c8 R15: 0000000000000000
[11075.260035] FS:  00007f58eed93700(0000) GS:ffff880dabc00000(0000) knlGS:0000000000000000
[11075.260035] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[11075.260035] CR2: 0000000000000000 CR3: 00000007932dd000 CR4: 00000000000006a0
[11075.260035] DR0: 00000000006d6000 DR1: 0000000000000000 DR2: 0000000000000000
[11075.260035] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
[11075.260035] Stack:
[11075.260035]  ffff880da9958800 ffff8807a99b2c78 ffff8807931cfd60 ffff880daa5c3000
[11075.260035]  ffff8807a99b2c00 ffff880da9958800 00007f58eed939d0 ffff8807a99b2c00
[11075.260035]  ffff8807931cfd60 ffffffffa62cb318 ffff880daa5c3000 ffff880da9958800
[11075.260035] Call Trace:
[11075.260035] anon_vma_fork (mm/rmap.c:285)
[11075.260035] copy_process (kernel/fork.c:410 kernel/fork.c:835 kernel/fork.c:898 kernel/fork.c:1346)
[11075.260035] ? trace_hardirqs_off_caller (kernel/locking/lockdep.c:2619)
[11075.260035] do_fork (kernel/fork.c:1607)
[11075.260035] ? get_parent_ip (kernel/sched/core.c:2519)
[11075.260035] ? context_tracking_user_exit (./arch/x86/include/asm/paravirt.h:809 (discriminator 2) kernel/context_tracking.c:182 (discriminator 2))
[11075.260035] ? trace_hardirqs_on_caller (kernel/locking/lockdep.c:2564)
[11075.260035] ? trace_hardirqs_on (kernel/locking/lockdep.c:2607)
[11075.260035] SyS_clone (kernel/fork.c:1693)
[11075.260035] stub_clone (arch/x86/kernel/entry_64.S:637)
[11075.260035] ? tracesys (arch/x86/kernel/entry_64.S:542)
[11075.260035] Code: b2 db 43 07 be d0 00 00 00 e8 18 48 02 00 48 85 c0 49 89 c6 0f 85 a7 00 00 00 e9 7f 00 00 00 0f 1f 80 00 00 00 00 4d 8b 7c 24 08 <49> 8b 1f 4c 39 eb 74 37 4d 85 ed 74 26 80 3d 7a 5b ec 05 00 75
All code
========
   0:	b2 db                	mov    $0xdb,%dl
   2:	43 07                	rex.XB (bad)
   4:	be d0 00 00 00       	mov    $0xd0,%esi
   9:	e8 18 48 02 00       	callq  0x24826
   e:	48 85 c0             	test   %rax,%rax
  11:	49 89 c6             	mov    %rax,%r14
  14:	0f 85 a7 00 00 00    	jne    0xc1
  1a:	e9 7f 00 00 00       	jmpq   0x9e
  1f:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  26:	4d 8b 7c 24 08       	mov    0x8(%r12),%r15
  2b:*	49 8b 1f             	mov    (%r15),%rbx		<-- trapping instruction
  2e:	4c 39 eb             	cmp    %r13,%rbx
  31:	74 37                	je     0x6a
  33:	4d 85 ed             	test   %r13,%r13
  36:	74 26                	je     0x5e
  38:	80 3d 7a 5b ec 05 00 	cmpb   $0x0,0x5ec5b7a(%rip)        # 0x5ec5bb9
  3f:	75 00                	jne    0x41

Code starting with the faulting instruction
===========================================
   0:	49 8b 1f             	mov    (%r15),%rbx
   3:	4c 39 eb             	cmp    %r13,%rbx
   6:	74 37                	je     0x3f
   8:	4d 85 ed             	test   %r13,%r13
   b:	74 26                	je     0x33
   d:	80 3d 7a 5b ec 05 00 	cmpb   $0x0,0x5ec5b7a(%rip)        # 0x5ec5b8e
  14:	75 00                	jne    0x16
[11075.260035] RIP anon_vma_clone (mm/rmap.c:1768)
[11075.260035]  RSP <ffff8807931cfcf0>
[11075.260035] CR2: 0000000000000000


Thanks,
Sasha
