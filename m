Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370AbaCADys (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 22:54:48 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:32640 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674AbaCADyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 22:54:45 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: akpm@linux-foundation.org
Cc: riel@redhat.com, hannes@cmpxchg.org, minchan@kernel.org, mgorman@suse.de,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] lib: radix: return correct error code on insertion failure
Date: Fri, 28 Feb 2014 22:54:24 -0500
Message-Id: <1393646064-23785-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.3.2
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We would never check the return value of __radix_tree_create() on insertion
which would cause us to return -EEXIST on all cases of failure, even when
such failure would be running out of memory, for example.

This would trigger errors in various code that assumed that -EEXIST is
a critical failure, as opposed to a "regular" error. For example, it
would trigger a VM_BUG_ON in mm's swap handling:

[  469.636769] kernel BUG at mm/swap_state.c:113!
[  469.636769] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[  469.638313] Dumping ftrace buffer:
[  469.638526]    (ftrace buffer empty)
[  469.640016] Modules linked in:
[  469.640110] CPU: 54 PID: 4598 Comm: kswapd6 Tainted: G        W    3.14.0-rc4-next-20140228-sasha-00012-g6bbcf46-dirty #29
[  469.640110] task: ffff8802850d3000 ti: ffff8802850cc000 task.ti: ffff8802850cc000
[  469.640110] RIP: 0010:[<ffffffff81296a82>]  [<ffffffff81296a82>] __add_to_swap_cache+0x132/0x170
[  469.640110] RSP: 0000:ffff8802850cd7a8  EFLAGS: 00010246
[  469.640110] RAX: 0000000080000001 RBX: ffffea000a02ca00 RCX: 0000000000000000
[  469.640110] RDX: 0000000000000001 RSI: 0000000000000001 RDI: 00000000ffffffff
[  469.640110] RBP: ffff8802850cd7c8 R08: 0000000000000000 R09: 0000000000000000
[  469.640110] R10: 0000000000000001 R11: 0000000000000001 R12: ffffffff868c2e18
[  469.640110] R13: ffffffff868c2e30 R14: 00000000ffffffef R15: 0000000000000000
[  469.640110] FS:  0000000000000000(0000) GS:ffff880286800000(0000) knlGS:0000000000000000
[  469.640110] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  469.640110] CR2: 00000000029c23b0 CR3: 00000000824ca000 CR4: 00000000000006e0
[  469.640110] Stack:
[  469.640110]  ffffea000a02ca00 020000000004c037 ffff8802850cd9c8 ffffea000a02ca00
[  469.640110]  ffff8802850cd7f8 ffffffff81296cac ffff8802850cd9c8 ffff8802850cd9c8
[  469.640110]  ffffea000a02ca00 020000000004c037 ffff8802850cd828 ffffffff81296d90
[  469.640110] Call Trace:
[  469.640110]  [<ffffffff81296cac>] add_to_swap_cache+0x2c/0x60
[  469.640110]  [<ffffffff81296d90>] add_to_swap+0xb0/0xe0
[  469.640110]  [<ffffffff81263d21>] shrink_page_list+0x411/0x7c0
[  469.640110]  [<ffffffff812657ac>] shrink_inactive_list+0x31c/0x570
[  469.640110]  [<ffffffff81265d0b>] ? shrink_active_list+0x30b/0x320
[  469.640110]  [<ffffffff81265e44>] shrink_lruvec+0x124/0x300
[  469.640110]  [<ffffffff812660ae>] shrink_zone+0x8e/0x1d0
[  469.640110]  [<ffffffff81266771>] kswapd_shrink_zone+0xf1/0x1b0
[  469.640110]  [<ffffffff81267783>] balance_pgdat+0x363/0x540
[  469.640110]  [<ffffffff81269383>] kswapd+0x2b3/0x310
[  469.640110]  [<ffffffff812690d0>] ? ftrace_raw_event_mm_vmscan_writepage+0x180/0x180
[  469.640110]  [<ffffffff811678b5>] kthread+0x105/0x110
[  469.640110]  [<ffffffff811a3b52>] ? __lock_release+0x1e2/0x200
[  469.640110]  [<ffffffff811677b0>] ? set_kthreadd_affinity+0x30/0x30
[  469.640110]  [<ffffffff8439f58c>] ret_from_fork+0x7c/0xb0
[  469.640110]  [<ffffffff811677b0>] ? set_kthreadd_affinity+0x30/0x30
[  469.640110] Code: 00 00 be 0a 00 00 00 e8 0d ae fd ff 48 ff 05 b6 33 d2 06 4c 89 ef e8 1e f6 0f 03 eb 2c 4c 89 ef e8 14 f6 0f 03 41 83 fe ef 75 04 <0f> 0b eb fe 48 c7 43 30 00 00 00 00 f0 80 63 02 fe 48 89 df e8
[  469.640110] RIP  [<ffffffff81296a82>] __add_to_swap_cache+0x132/0x170
[  469.640110]  RSP <ffff8802850cd7a8>

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 lib/radix-tree.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/lib/radix-tree.c b/lib/radix-tree.c
index f5ea7c9..9599aa7 100644
--- a/lib/radix-tree.c
+++ b/lib/radix-tree.c
@@ -444,6 +444,8 @@ int radix_tree_insert(struct radix_tree_root *root,
 	BUG_ON(radix_tree_is_indirect_ptr(item));
 
 	error = __radix_tree_create(root, index, &node, &slot);
+	if (error)
+		return error;
 	if (*slot != NULL)
 		return -EEXIST;
 	rcu_assign_pointer(*slot, item);
-- 
1.7.2.5

