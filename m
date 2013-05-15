Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748Ab3EOVsU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 17:48:20 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:41447 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342Ab3EOVsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 17:48:18 -0400
Date: Wed, 15 May 2013 14:48:13 -0700
From: Tejun Heo <tj@kernel.org>
To: Lingzhu Xiang <lxiang@redhat.com>
Cc: CAI Qian <caiqian@redhat.com>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] workqueue: don't perform NUMA-aware allocations on offline
 nodes in wq_numa_init()
Message-ID: <20130515214813.GF26222@htj.dyndns.org>
References: <22600323.7586117.1367826906910.JavaMail.root@redhat.com>
 <5191B101.1070000@redhat.com>
 <20130514183500.GN6795@mtj.dyndns.org>
 <51930FCD.3090001@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51930FCD.3090001@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 1be0c25da56e860992af972a60321563ca2cfcd1 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Wed, 15 May 2013 14:24:24 -0700

wq_numa_init() builds per-node cpumasks which are later used to make
unbound workqueues NUMA-aware.  The cpumasks are allocated using
alloc_cpumask_var_node() for all possible nodes.  Unfortunately, on
machines with off-line nodes, this leads to NUMA-aware allocations on
existing bug offline nodes, which in turn triggers BUG in the memory
allocation code.

Fix it by using NUMA_NO_NODE for cpumask allocations for offline
nodes.

  kernel BUG at include/linux/gfp.h:323!
  invalid opcode: 0000 [#1] SMP
  Modules linked in:
  CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.9.0+ #1
  Hardware name: ProLiant BL465c G7, BIOS A19 12/10/2011
  task: ffff880234608000 ti: ffff880234602000 task.ti: ffff880234602000
  RIP: 0010:[<ffffffff8117495d>]  [<ffffffff8117495d>] new_slab+0x2ad/0x340
  RSP: 0000:ffff880234603bf8  EFLAGS: 00010246
  RAX: 0000000000000000 RBX: ffff880237404b40 RCX: 00000000000000d0
  RDX: 0000000000000001 RSI: 0000000000000003 RDI: 00000000002052d0
  RBP: ffff880234603c28 R08: 0000000000000000 R09: 0000000000000001
  R10: 0000000000000001 R11: ffffffff812e3aa8 R12: 0000000000000001
  R13: ffff8802378161c0 R14: 0000000000030027 R15: 00000000000040d0
  FS:  0000000000000000(0000) GS:ffff880237800000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
  CR2: ffff88043fdff000 CR3: 00000000018d5000 CR4: 00000000000007f0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
  Stack:
   ffff880234603c28 0000000000000001 00000000000000d0 ffff8802378161c0
   ffff880237404b40 ffff880237404b40 ffff880234603d28 ffffffff815edba1
   ffff880237816140 0000000000000000 ffff88023740e1c0
  Call Trace:
   [<ffffffff815edba1>] __slab_alloc+0x330/0x4f2
   [<ffffffff81174b25>] kmem_cache_alloc_node_trace+0xa5/0x200
   [<ffffffff812e3aa8>] alloc_cpumask_var_node+0x28/0x90
   [<ffffffff81a0bdb3>] wq_numa_init+0x10d/0x1be
   [<ffffffff81a0bec8>] init_workqueues+0x64/0x341
   [<ffffffff810002ea>] do_one_initcall+0xea/0x1a0
   [<ffffffff819f1f31>] kernel_init_freeable+0xb7/0x1ec
   [<ffffffff815d50de>] kernel_init+0xe/0xf0
   [<ffffffff815ff89c>] ret_from_fork+0x7c/0xb0
  Code: 45  84 ac 00 00 00 f0 41 80 4d 00 40 e9 f6 fe ff ff 66 0f 1f 84 00 00 00 00 00 e8 eb 4b ff ff 49 89 c5 e9 05 fe ff ff <0f> 0b 4c 8b 73 38 44 89 ff 81 cf 00 00 20 00 4c 89 f6 48 c1 ee

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-and-Tested-by: Lingzhu Xiang <lxiang@redhat.com>
---
Applied to wq/for-3.10-fixes.  Will push to Linus in several days.

Thanks!

 kernel/workqueue.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 02916f4..ee8e29a 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -4905,7 +4905,8 @@ static void __init wq_numa_init(void)
 	BUG_ON(!tbl);
 
 	for_each_node(node)
-		BUG_ON(!alloc_cpumask_var_node(&tbl[node], GFP_KERNEL, node));
+		BUG_ON(!alloc_cpumask_var_node(&tbl[node], GFP_KERNEL,
+				node_online(node) ? node : NUMA_NO_NODE));
 
 	for_each_possible_cpu(cpu) {
 		node = cpu_to_node(cpu);
-- 
1.8.1.4

