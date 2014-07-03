Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089AbaGCDPQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 23:15:16 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:28613 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248AbaGCDPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 23:15:13 -0400
Message-ID: <53B4CAB8.5070407@oracle.com>
Date: Wed, 02 Jul 2014 23:15:04 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>
CC: Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: fs: use after free in /proc/pid/mountinfo
References: <53B3F331.7090204@oracle.com>
In-Reply-To: <53B3F331.7090204@oracle.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2014 07:55 AM, Sasha Levin wrote:
> Hi all,
> 
> While fuzzing with trinity inside a KVM tools guest running the latest -next
> kernel I've stumbled on the following spew:
> 
> [ 3569.869749] general protection fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> [ 3569.869769] Dumping ftrace buffer:
> [ 3569.869879]    (ftrace buffer empty)
> [ 3569.869894] Modules linked in:
> [ 3569.869900] CPU: 7 PID: 10239 Comm: trinity-c86 Tainted: G        W      3.16.0-rc3-next-20140701-sasha-00023-g4eb2544-dirty #759
> [ 3569.869906] task: ffff88039e873000 ti: ffff880393f8c000 task.ti: ffff880393f8c000
> [ 3569.869932] RIP: show_mountinfo (fs/proc_namespace.c:127)
> [ 3569.869938] RSP: 0018:ffff880393f8fd08  EFLAGS: 00010282
> [ 3569.869943] RAX: ffff880200c6d208 RBX: 6b6b6b6b6b6b6b03 RCX: 0000000000000074
> [ 3569.869946] RDX: 0000000000000000 RSI: 6b6b6b6b6b6b6b03 RDI: ffff880200c6d208
> [ 3569.869953] RBP: ffff880393f8fd58 R08: 0000000000000001 R09: ffff88039e873d38
> [ 3569.869957] R10: 0000000000000001 R11: 0000000000000000 R12: ffff880200c6d208
> [ 3569.869962] R13: 6b6b6b6b6b6b6b6b R14: ffff880393f8ff50 R15: ffff880200c6d208
> [ 3569.869966] FS:  00007f6f20db9700(0000) GS:ffff8801ece00000(0000) knlGS:0000000000000000
> [ 3569.869969] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 3569.869974] CR2: 00007f6f20bee000 CR3: 00000003a0775000 CR4: 00000000000006a0
> [ 3569.869992] Stack:
> [ 3569.870011]  ffff880393f8ff50 ffff880200c6d208 ffff880393f8fd48 ffffffff984e10ea
> [ 3569.870025]  ffffffff9532c7fe ffff8802069a3b80 0000000000000065 6b6b6b6b6b6b6b6b
> [ 3569.870036]  ffff880393f8ff50 ffff880200c6d208 ffff880393f8fd68 ffffffff9532c756
> [ 3569.870038] Call Trace:
> [ 3569.870051] ? down_read (kernel/locking/rwsem.c:45 (discriminator 2))
> [ 3569.870059] ? m_start (kernel/module.c:3634)
> [ 3569.870069] m_show (kernel/module.c:3649)
> [ 3569.870076] seq_read (fs/seq_file.c:235)
> [ 3569.870081] ? single_open_size (fs/seq_file.c:166)
> [ 3569.870092] do_loop_readv_writev (fs/read_write.c:708)
> [ 3569.870098] ? single_open_size (fs/seq_file.c:166)
> [ 3569.870098] do_readv_writev (fs/read_write.c:840)
> [ 3569.870098] ? get_parent_ip (kernel/sched/core.c:2550)
> [ 3569.870098] ? mutex_lock_nested (./arch/x86/include/asm/preempt.h:98 kernel/locking/mutex.c:570 kernel/locking/mutex.c:587)
> [ 3569.870098] ? __fdget_pos (fs/file.c:714)
> [ 3569.870098] ? __fdget_pos (fs/file.c:714)
> [ 3569.870098] ? trace_hardirqs_on_caller (kernel/locking/lockdep.c:2557 kernel/locking/lockdep.c:2599)
> [ 3569.870098] ? __fget_light (fs/file.c:685)
> [ 3569.870098] vfs_readv (fs/read_write.c:866)
> [ 3569.870098] SyS_readv (fs/read_write.c:892 fs/read_write.c:884)
> [ 3569.870098] tracesys (arch/x86/kernel/entry_64.S:542)
> [ 3569.870098] Code: 00 00 00 00 66 66 66 66 90 55 48 89 e5 48 83 ec 50 48 89 5d d8 48 89 f3 4c 89 65 e0 49 89 fc 4c 89 6d e8 4c 89 75 f0 4c 89 7d f8 <48> 8b 06 48 89 75 b0 4c 8b 76 08 8b 96 ec 00 00 00 48 89 45 b8
> All code
> ========
>    0:	00 00                	add    %al,(%rax)
>    2:	00 00                	add    %al,(%rax)
>    4:	66 66 66 66 90       	data32 data32 data32 xchg %ax,%ax
>    9:	55                   	push   %rbp
>    a:	48 89 e5             	mov    %rsp,%rbp
>    d:	48 83 ec 50          	sub    $0x50,%rsp
>   11:	48 89 5d d8          	mov    %rbx,-0x28(%rbp)
>   15:	48 89 f3             	mov    %rsi,%rbx
>   18:	4c 89 65 e0          	mov    %r12,-0x20(%rbp)
>   1c:	49 89 fc             	mov    %rdi,%r12
>   1f:	4c 89 6d e8          	mov    %r13,-0x18(%rbp)
>   23:	4c 89 75 f0          	mov    %r14,-0x10(%rbp)
>   27:	4c 89 7d f8          	mov    %r15,-0x8(%rbp)
>   2b:*	48 8b 06             	mov    (%rsi),%rax		<-- trapping instruction
>   2e:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
>   32:	4c 8b 76 08          	mov    0x8(%rsi),%r14
>   36:	8b 96 ec 00 00 00    	mov    0xec(%rsi),%edx
>   3c:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
> 	...
> 
> Code starting with the faulting instruction
> ===========================================
>    0:	48 8b 06             	mov    (%rsi),%rax
>    3:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
>    7:	4c 8b 76 08          	mov    0x8(%rsi),%r14
>    b:	8b 96 ec 00 00 00    	mov    0xec(%rsi),%edx
>   11:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
> 	...
> [ 3569.870098] RIP show_mountinfo (fs/proc_namespace.c:127)
> [ 3569.870098]  RSP <ffff880393f8fd08>
> 
> 
> Thanks,
> Sasha
> 

This one seems related:

[ 4292.460172] kernel tried to execute NX-protected page - exploit attempt? (uid: 84)
[ 4292.462109] BUG: unable to handle kernel paging request at ffff8804650c3ec8
[ 4292.464167] IP: 0xffff8804650c3ec8  (??:?)
[ 4292.465775] PGD 24b7d067 PUD 703f42067 PMD 703e19067 PTE 80000004650c3163
[ 4292.467882] Oops: 0011 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[ 4292.469606] Dumping ftrace buffer:
[ 4292.470032]    (ftrace buffer empty)
[ 4292.470032] Modules linked in:
[ 4292.470032] CPU: 9 PID: 16397 Comm: trinity-c103 Tainted: G        W      3.16.0-rc3-next-20140702-sasha-00023-ga35ffce-dirty #760
[ 4292.470032] task: ffff8801b479b000 ti: ffff8804650c0000 task.ti: ffff8804650c0000
[ 4292.470032] RIP: 0xffff8804650c3ec8  (??:?)
[ 4292.470032] RSP: 0000:ffff8804650c3e60  EFLAGS: 00010293
[ 4292.470032] RAX: ffff8803d5e586a0 RBX: ffff88007bf85b00 RCX: ffff8800a5ab69a8
[ 4292.470032] RDX: 0000000000000000 RSI: ffffffffa31352f8 RDI: ffff8803d5e5b6a8
[ 4292.470032] RBP: ffff8804650c3e58 R08: ffff8803d5e5b6a8 R09: 0000000000000009
[ 4292.470032] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[ 4292.490142] R13: ffff8803d5e5b6a8 R14: ffff8804650c3f50 R15: ffff88008082e900
[ 4292.490142] FS:  00007ff380e2e700(0000) GS:ffff88025ce00000(0000) knlGS:0000000000000000
[ 4292.490142] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 4292.490142] CR2: ffff8804650c3ec8 CR3: 000000017f20e000 CR4: 00000000000006a0
[ 4292.490142] Stack:
[ 4292.490142]  ffffffff9d332972 0000000000000009 0000000081000000 ffff88008082e940
[ 4292.490142]  0000000000000e5f 0000000000000000 0000000000000001 ffff8804650c3ec8
[ 4292.490142]  ffff8803d69b1ff0 ffff88007bf85b00 0000000081000000 ffff8804650c3f50
[ 4292.490142] Call Trace:
[ 4292.490142] seq_read (fs/seq_file.c:265)
[ 4292.490142] ? proc_reg_read (fs/proc/inode.c:211)
[ 4292.508936] ? vfs_read (fs/read_write.c:430)
[ 4292.508936] ? SyS_read (fs/read_write.c:568 fs/read_write.c:560)
[ 4292.508936] ? ia32_do_call (arch/x86/ia32/ia32entry.S:430)
[ 4292.508936] Code: 88 ff ff f0 1f 9b d6 03 88 ff ff 00 5b f8 7b 00 88 ff ff 00 00 00 81 00 00 00 00 50 3f 0c 65 04 88 ff ff 03 00 00 00 00 00 00 00 <f8> 3e 0c 65 04 88 ff ff 42 ae 37 9d ff ff ff ff 08 3f 0c 65 04
All code
========
   0:	88 ff                	mov    %bh,%bh
   2:	ff f0                	push   %rax
   4:	1f                   	(bad)
   5:	9b                   	fwait
   6:	d6                   	(bad)
   7:	03 88 ff ff 00 5b    	add    0x5b00ffff(%rax),%ecx
   d:	f8                   	clc
   e:	7b 00                	jnp    0x10
  10:	88 ff                	mov    %bh,%bh
  12:	ff 00                	incl   (%rax)
  14:	00 00                	add    %al,(%rax)
  16:	81 00 00 00 00 50    	addl   $0x50000000,(%rax)
  1c:	3f                   	(bad)
  1d:	0c 65                	or     $0x65,%al
  1f:	04 88                	add    $0x88,%al
  21:	ff                   	(bad)
  22:	ff 03                	incl   (%rbx)
  24:	00 00                	add    %al,(%rax)
  26:	00 00                	add    %al,(%rax)
  28:	00 00                	add    %al,(%rax)
  2a:*	00 f8                	add    %bh,%al		<-- trapping instruction
  2c:	3e                   	ds
  2d:	0c 65                	or     $0x65,%al
  2f:	04 88                	add    $0x88,%al
  31:	ff                   	(bad)
  32:	ff 42 ae             	incl   -0x52(%rdx)
  35:	37                   	(bad)
  36:	9d                   	popfq
  37:	ff                   	(bad)
  38:	ff                   	(bad)
  39:	ff                   	(bad)
  3a:	ff 08                	decl   (%rax)
  3c:	3f                   	(bad)
  3d:	0c 65                	or     $0x65,%al
  3f:	04 00                	add    $0x0,%al

Code starting with the faulting instruction
===========================================
   0:	f8                   	clc
   1:	3e                   	ds
   2:	0c 65                	or     $0x65,%al
   4:	04 88                	add    $0x88,%al
   6:	ff                   	(bad)
   7:	ff 42 ae             	incl   -0x52(%rdx)
   a:	37                   	(bad)
   b:	9d                   	popfq
   c:	ff                   	(bad)
   d:	ff                   	(bad)
   e:	ff                   	(bad)
   f:	ff 08                	decl   (%rax)
  11:	3f                   	(bad)
  12:	0c 65                	or     $0x65,%al
  14:	04 00                	add    $0x0,%al
[ 4292.508936] RIP 0xffff8804650c3ec8  (??:?)
[ 4292.508936]  RSP <ffff8804650c3e60>
[ 4292.508936] CR2: ffff8804650c3ec8


Thanks,
Sasha
