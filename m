Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191AbaGDQqD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 12:46:03 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:31403 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742AbaGDQqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 12:46:01 -0400
Message-ID: <53B6DA3E.40704@oracle.com>
Date: Fri, 04 Jul 2014 12:45:50 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@fb.com>
CC: LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: blk: NULL ptr deref in blk_throtl_drain
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

[ 3660.610281] BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
[ 3660.612608] IP: blk_throtl_drain (block/blk-throttle.c:1639)
[ 3660.614522] PGD 43c71067 PUD 51a45067 PMD 0
[ 3660.615848] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[ 3660.617482] Dumping ftrace buffer:
[ 3660.618500]    (ftrace buffer empty)
[ 3660.619543] Modules linked in:
[ 3660.620060] CPU: 16 PID: 794 Comm: kworker/16:1 Not tainted 3.16.0-rc3-next-20140703-sasha-00024-g2ad7668-dirty #763
[ 3660.622778] Workqueue: events kobject_delayed_cleanup
[ 3660.622778] task: ffff8803d6a43000 ti: ffff8803d6aa4000 task.ti: ffff8803d6aa4000
[ 3660.622778] RIP: blk_throtl_drain (block/blk-throttle.c:1639)
[ 3660.622778] RSP: 0018:ffff8803d6aa7bd8  EFLAGS: 00010046
[ 3660.622778] RAX: 0000000000000000 RBX: ffff8804ae39c4e8 RCX: 0000000000000000
[ 3660.622778] RDX: 0000000000000002 RSI: ffffffffb59160a5 RDI: 0000000000000000
[ 3660.622778] RBP: ffff8803d6aa7bf8 R08: 0000000000000001 R09: 0000000000000000
[ 3660.622778] R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
[ 3660.622778] R13: ffff8803d5c4ed70 R14: ffff8803d5c4e150 R15: 0000000000000800
[ 3660.622778] FS:  0000000000000000(0000) GS:ffff8803d7000000(0000) knlGS:0000000000000000
[ 3660.622778] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 3660.622778] CR2: 0000000000000028 CR3: 000000004a2dc000 CR4: 00000000000006a0
[ 3660.622778] Stack:
[ 3660.622778]  ffff8803d5c4e150 0000000000000000 ffff8803d5c4ed70 ffff8803d5c4ed60
[ 3660.622778]  ffff8803d6aa7c18 ffffffffb1af40d0 0000000000000000 ffff8803d5c4e150
[ 3660.622778]  ffff8803d6aa7c48 ffffffffb1acfad7 ffff8803d5c4e150 ffffffffb6d61fe0
[ 3660.622778] Call Trace:
[ 3660.622778] blkcg_drain_queue (block/blk-cgroup.c:876 (discriminator 6))
[ 3660.622778] __blk_drain_queue (block/blk-core.c:385)
[ 3660.622778] blk_queue_bypass_start (include/linux/spinlock.h:353 block/blk-core.c:454)
[ 3660.622778] blkcg_deactivate_policy (include/linux/spinlock.h:328 block/blk-cgroup.c:1058)
[ 3660.622778] blk_throtl_exit (block/blk-throttle.c:1684)
[ 3660.622778] blkcg_exit_queue (block/blk-cgroup.c:891)
[ 3660.622778] blk_release_queue (block/blk-sysfs.c:508)
[ 3660.622778] kobject_delayed_cleanup (lib/kobject.c:629 lib/kobject.c:638)
[ 3660.660168] process_one_work (kernel/workqueue.c:2070 include/linux/jump_label.h:115 include/trace/events/workqueue.h:111 kernel/workqueue.c:2075)
[ 3660.660168] ? process_one_work (include/linux/workqueue.h:185 kernel/workqueue.c:599 kernel/workqueue.c:626 kernel/workqueue.c:2063)
[ 3660.660168] worker_thread (kernel/workqueue.c:2202)
[ 3660.660168] ? process_scheduled_works (kernel/workqueue.c:2146)
[ 3660.660168] kthread (kernel/kthread.c:210)
[ 3660.660168] ? put_lock_stats.isra.12 (./arch/x86/include/asm/preempt.h:98 kernel/locking/lockdep.c:254)
[ 3660.660168] ? kthread_create_on_node (kernel/kthread.c:176)
[ 3660.660168] ret_from_fork (arch/x86/kernel/entry_64.S:349)
[ 3660.670128] ? kthread_create_on_node (kernel/kthread.c:176)
[ 3660.670128] Code: c0 0f 84 e4 00 00 00 0f 1f 80 00 00 00 00 e8 13 e4 6e ff 0f 1f 00 e8 5b f2 6e ff 48 8b 83 d0 00 00 00 31 ff 48 8b 80 80 0b 00 00 <48> 8b 70 28 e8 62 57 72 ff 48 85 c0 49 89 c4 0f 84 c6 00 00 00
All code
========
   0:	c0 0f 84             	rorb   $0x84,(%rdi)
   3:	e4 00                	in     $0x0,%al
   5:	00 00                	add    %al,(%rax)
   7:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
   e:	e8 13 e4 6e ff       	callq  0xffffffffff6ee426
  13:	0f 1f 00             	nopl   (%rax)
  16:	e8 5b f2 6e ff       	callq  0xffffffffff6ef276
  1b:	48 8b 83 d0 00 00 00 	mov    0xd0(%rbx),%rax
  22:	31 ff                	xor    %edi,%edi
  24:	48 8b 80 80 0b 00 00 	mov    0xb80(%rax),%rax
  2b:*	48 8b 70 28          	mov    0x28(%rax),%rsi		<-- trapping instruction
  2f:	e8 62 57 72 ff       	callq  0xffffffffff725796
  34:	48 85 c0             	test   %rax,%rax
  37:	49 89 c4             	mov    %rax,%r12
  3a:	0f 84 c6 00 00 00    	je     0x106
	...

Code starting with the faulting instruction
===========================================
   0:	48 8b 70 28          	mov    0x28(%rax),%rsi
   4:	e8 62 57 72 ff       	callq  0xffffffffff72576b
   9:	48 85 c0             	test   %rax,%rax
   c:	49 89 c4             	mov    %rax,%r12
   f:	0f 84 c6 00 00 00    	je     0xdb
	...
[ 3660.670128] RIP blk_throtl_drain (block/blk-throttle.c:1639)
[ 3660.670128]  RSP <ffff8803d6aa7bd8>
[ 3660.670128] CR2: 0000000000000028


Thanks,
Sasha
