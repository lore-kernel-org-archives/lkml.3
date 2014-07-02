Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897AbaGBLzl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 07:55:41 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:35292 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaGBLzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 07:55:39 -0400
Message-ID: <53B3F331.7090204@oracle.com>
Date: Wed, 02 Jul 2014 07:55:29 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>
CC: Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: fs: use after free in /proc/pid/mountinfo
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While fuzzing with trinity inside a KVM tools guest running the latest -next
kernel I've stumbled on the following spew:

[ 3569.869749] general protection fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[ 3569.869769] Dumping ftrace buffer:
[ 3569.869879]    (ftrace buffer empty)
[ 3569.869894] Modules linked in:
[ 3569.869900] CPU: 7 PID: 10239 Comm: trinity-c86 Tainted: G        W      3.16.0-rc3-next-20140701-sasha-00023-g4eb2544-dirty #759
[ 3569.869906] task: ffff88039e873000 ti: ffff880393f8c000 task.ti: ffff880393f8c000
[ 3569.869932] RIP: show_mountinfo (fs/proc_namespace.c:127)
[ 3569.869938] RSP: 0018:ffff880393f8fd08  EFLAGS: 00010282
[ 3569.869943] RAX: ffff880200c6d208 RBX: 6b6b6b6b6b6b6b03 RCX: 0000000000000074
[ 3569.869946] RDX: 0000000000000000 RSI: 6b6b6b6b6b6b6b03 RDI: ffff880200c6d208
[ 3569.869953] RBP: ffff880393f8fd58 R08: 0000000000000001 R09: ffff88039e873d38
[ 3569.869957] R10: 0000000000000001 R11: 0000000000000000 R12: ffff880200c6d208
[ 3569.869962] R13: 6b6b6b6b6b6b6b6b R14: ffff880393f8ff50 R15: ffff880200c6d208
[ 3569.869966] FS:  00007f6f20db9700(0000) GS:ffff8801ece00000(0000) knlGS:0000000000000000
[ 3569.869969] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3569.869974] CR2: 00007f6f20bee000 CR3: 00000003a0775000 CR4: 00000000000006a0
[ 3569.869992] Stack:
[ 3569.870011]  ffff880393f8ff50 ffff880200c6d208 ffff880393f8fd48 ffffffff984e10ea
[ 3569.870025]  ffffffff9532c7fe ffff8802069a3b80 0000000000000065 6b6b6b6b6b6b6b6b
[ 3569.870036]  ffff880393f8ff50 ffff880200c6d208 ffff880393f8fd68 ffffffff9532c756
[ 3569.870038] Call Trace:
[ 3569.870051] ? down_read (kernel/locking/rwsem.c:45 (discriminator 2))
[ 3569.870059] ? m_start (kernel/module.c:3634)
[ 3569.870069] m_show (kernel/module.c:3649)
[ 3569.870076] seq_read (fs/seq_file.c:235)
[ 3569.870081] ? single_open_size (fs/seq_file.c:166)
[ 3569.870092] do_loop_readv_writev (fs/read_write.c:708)
[ 3569.870098] ? single_open_size (fs/seq_file.c:166)
[ 3569.870098] do_readv_writev (fs/read_write.c:840)
[ 3569.870098] ? get_parent_ip (kernel/sched/core.c:2550)
[ 3569.870098] ? mutex_lock_nested (./arch/x86/include/asm/preempt.h:98 kernel/locking/mutex.c:570 kernel/locking/mutex.c:587)
[ 3569.870098] ? __fdget_pos (fs/file.c:714)
[ 3569.870098] ? __fdget_pos (fs/file.c:714)
[ 3569.870098] ? trace_hardirqs_on_caller (kernel/locking/lockdep.c:2557 kernel/locking/lockdep.c:2599)
[ 3569.870098] ? __fget_light (fs/file.c:685)
[ 3569.870098] vfs_readv (fs/read_write.c:866)
[ 3569.870098] SyS_readv (fs/read_write.c:892 fs/read_write.c:884)
[ 3569.870098] tracesys (arch/x86/kernel/entry_64.S:542)
[ 3569.870098] Code: 00 00 00 00 66 66 66 66 90 55 48 89 e5 48 83 ec 50 48 89 5d d8 48 89 f3 4c 89 65 e0 49 89 fc 4c 89 6d e8 4c 89 75 f0 4c 89 7d f8 <48> 8b 06 48 89 75 b0 4c 8b 76 08 8b 96 ec 00 00 00 48 89 45 b8
All code
========
   0:	00 00                	add    %al,(%rax)
   2:	00 00                	add    %al,(%rax)
   4:	66 66 66 66 90       	data32 data32 data32 xchg %ax,%ax
   9:	55                   	push   %rbp
   a:	48 89 e5             	mov    %rsp,%rbp
   d:	48 83 ec 50          	sub    $0x50,%rsp
  11:	48 89 5d d8          	mov    %rbx,-0x28(%rbp)
  15:	48 89 f3             	mov    %rsi,%rbx
  18:	4c 89 65 e0          	mov    %r12,-0x20(%rbp)
  1c:	49 89 fc             	mov    %rdi,%r12
  1f:	4c 89 6d e8          	mov    %r13,-0x18(%rbp)
  23:	4c 89 75 f0          	mov    %r14,-0x10(%rbp)
  27:	4c 89 7d f8          	mov    %r15,-0x8(%rbp)
  2b:*	48 8b 06             	mov    (%rsi),%rax		<-- trapping instruction
  2e:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
  32:	4c 8b 76 08          	mov    0x8(%rsi),%r14
  36:	8b 96 ec 00 00 00    	mov    0xec(%rsi),%edx
  3c:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	...

Code starting with the faulting instruction
===========================================
   0:	48 8b 06             	mov    (%rsi),%rax
   3:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
   7:	4c 8b 76 08          	mov    0x8(%rsi),%r14
   b:	8b 96 ec 00 00 00    	mov    0xec(%rsi),%edx
  11:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	...
[ 3569.870098] RIP show_mountinfo (fs/proc_namespace.c:127)
[ 3569.870098]  RSP <ffff880393f8fd08>


Thanks,
Sasha
