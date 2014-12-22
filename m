Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965AbaLVOZc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 09:25:32 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:22222 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754561AbaLVOZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 09:25:31 -0500
Message-ID: <54982993.4090609@oracle.com>
Date: Mon, 22 Dec 2014 09:24:19 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Greg KH <greg@kroah.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Andrew Morton <akpm@linux-foundation.org>, hch@infradead.org,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: module,sysfs: gpf in module_attr_store
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While fuzzing with trinity inside a KVM tools guest running the latest -next
kernel, I've stumbled on the following spew:

[ 2775.284941] general protection fault: 0000 [#1] PREEMPT SMP KASAN
[ 2775.285681] Dumping ftrace buffer:
[ 2775.286124]    (ftrace buffer empty)
[ 2775.286612] Modules linked in:
[ 2775.286999] CPU: 15 PID: 29531 Comm: trinity-c307 Tainted: G    B          3.18.0-next-20141219-sasha-00047-gaab33f6-dirty #1627
[ 2775.288272] task: ffff8805c49aa000 ti: ffff8808f7734000 task.ti: ffff8808f7734000
[ 2775.289081] RIP: module_attr_store (kernel/params.c:894)
[ 2775.290021] RSP: 0018:ffff8808f7737c98  EFLAGS: 00010246
[ 2775.290021] RAX: dfffe90000000000 RBX: ffff88090b3b82f0 RCX: 0000000000001000
[ 2775.290021] RDX: ffff88061852c290 RSI: ffff88090b3bbd98 RDI: ffff88090b3b82f0
[ 2775.290021] RBP: ffff8808f7737cb8 R08: 0000000000000000 R09: 0000000000000000
[ 2775.290021] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88090b3bbd98
[ 2775.290021] R13: ffffffffb04544a0 R14: ffff88061852c290 R15: ffff88090b3bbd98
[ 2775.290021] FS:  00007f727b070700(0000) GS:ffff88064c400000(0000) knlGS:0000000000000000
[ 2775.290021] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2775.290021] CR2: 0000000077d9d000 CR3: 00000008f52e6000 CR4: 00000000000006a0
[ 2775.290021] DR0: ffffffff81000000 DR1: a200000080000000 DR2: 0000000000000000
[ 2775.290021] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
[ 2775.290021] Stack:
[ 2775.290021]  ffff8808f7737d08 ffffffffa09e85f7 ffff8802757c7480 ffffffffa04723b0
[ 2775.290021]  ffff8808f7737d08 ffffffffa0c6d0b9 000000000000000f ffffffffa0c6952e
[ 2775.290021]  ffff8808f7737cf8 ffff88061852c290 0000000000001000 ffff8805b1ae1948
[ 2775.290021] Call Trace:
[ 2775.290021] ? __kmalloc (mm/slub.c:3298)
[ 2775.290021] ? module_attr_show (kernel/params.c:883)
[ 2775.290021] sysfs_kf_write (fs/sysfs/file.c:132)
[ 2775.290021] ? kernfs_fop_write (include/linux/slab.h:436 fs/kernfs/file.c:287)
[ 2775.290021] ? sysfs_kf_bin_read (fs/sysfs/file.c:124)
[ 2775.290021] kernfs_fop_write (fs/kernfs/file.c:311)
[ 2775.290021] do_loop_readv_writev (fs/read_write.c:722)
[ 2775.290021] ? kernfs_vma_page_mkwrite (fs/kernfs/file.c:271)
[ 2775.290021] ? kernfs_vma_page_mkwrite (fs/kernfs/file.c:271)
[ 2775.290021] do_readv_writev (fs/read_write.c:854)
[ 2775.290021] ? preempt_count_sub (kernel/sched/core.c:2620)
[ 2775.290021] ? _raw_spin_unlock (./arch/x86/include/asm/preempt.h:95 include/linux/spinlock_api_smp.h:152 kernel/locking/spinlock.c:183)
[ 2775.290021] ? vtime_account_user (kernel/sched/cputime.c:701)
[ 2775.290021] vfs_writev (fs/read_write.c:893)
[ 2775.290021] SyS_writev (fs/read_write.c:926 fs/read_write.c:917)
[ 2775.290021] tracesys_phase2 (arch/x86/kernel/entry_64.S:529)
[ 2775.290021] Code: 00 00 00 00 e9 ff df 48 89 fe 48 c1 ee 03 80 3c 06 00 75 35 48 83 7b 18 00 74 25 48 85 db 74 64 f6 c3 07 75 5f 4c 89 e6 48 89 df <ff> 53 18 48 98 48 83 c4 10 5b 41 5c 5d c3 0f 1f 80 00 00 00 00
All code
========
   0:	00 00                	add    %al,(%rax)
   2:	00 00                	add    %al,(%rax)
   4:	e9 ff df 48 89       	jmpq   0xffffffff8948e008
   9:	fe 48 c1             	decb   -0x3f(%rax)
   c:	ee                   	out    %al,(%dx)
   d:	03 80 3c 06 00 75    	add    0x7500063c(%rax),%eax
  13:	35 48 83 7b 18       	xor    $0x187b8348,%eax
  18:	00 74 25 48          	add    %dh,0x48(%rbp,%riz,1)
  1c:	85 db                	test   %ebx,%ebx
  1e:	74 64                	je     0x84
  20:	f6 c3 07             	test   $0x7,%bl
  23:	75 5f                	jne    0x84
  25:	4c 89 e6             	mov    %r12,%rsi
  28:	48 89 df             	mov    %rbx,%rdi
  2b:*	ff 53 18             	callq  *0x18(%rbx)		<-- trapping instruction
  2e:	48 98                	cltq
  30:	48 83 c4 10          	add    $0x10,%rsp
  34:	5b                   	pop    %rbx
  35:	41 5c                	pop    %r12
  37:	5d                   	pop    %rbp
  38:	c3                   	retq
  39:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
	...

Code starting with the faulting instruction
===========================================
   0:	ff 53 18             	callq  *0x18(%rbx)
   3:	48 98                	cltq
   5:	48 83 c4 10          	add    $0x10,%rsp
   9:	5b                   	pop    %rbx
   a:	41 5c                	pop    %r12
   c:	5d                   	pop    %rbp
   d:	c3                   	retq
   e:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
	...
[ 2775.290021] RIP module_attr_store (kernel/params.c:894)
[ 2775.290021]  RSP <ffff8808f7737c98>


Thanks,
Sasha
