Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914AbaESOlA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 10:41:00 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:31722 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238AbaESOk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 10:40:58 -0400
X-Nat-Received: from [202.181.97.72]:24112 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1400510447.16042
To: riel@redhat.com, kosaki.motohiro@jp.fujitsu.com, fengguang.wu@intel.com,
        kamezawa.hiroyu@jp.fujitsu.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] mm/vmscan: Do not block forever at shrink_inactive_list().
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <201405192340.FCD48964.OFQHOOJLVSFFMt@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Mon, 19 May 2014 23:40:46 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 19052014 #7951212, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From f016db5d7f84d6321132150b13c5888ef67d694f Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Mon, 19 May 2014 23:24:11 +0900
Subject: [PATCH] mm/vmscan: Do not block forever at shrink_inactive_list().

I can observe that commit 35cd7815 "vmscan: throttle direct reclaim when
too many pages are isolated already" causes RHEL7 environment to stall with
0% CPU usage when a certain type of memory pressure is given.

Upon memory pressure, kswapd calls xfs_vm_writepage() from shrink_page_list().
xfs_vm_writepage() eventually calls wait_for_completion() which waits for
xfs_bmapi_allocate_worker().

Then, a kernel worker thread calls xfs_bmapi_allocate_worker() and
xfs_bmapi_allocate_worker() eventually calls xfs_btree_lookup_get_block().
xfs_btree_lookup_get_block() eventually calls alloc_page().
alloc_page() eventually calls shrink_inactive_list().

The stack trace showed that the kernel worker thread which the kswapd is
waiting for was looping at a while loop in shrink_inactive_list().

---------- stack trace start ----------
[  923.927838] kswapd0         D ffff88007fa34580     0   101      2 0x00000000
[  923.930028]  ffff880079103550 0000000000000046 ffff880079103fd8 0000000000014580
[  923.932324]  ffff880079103fd8 0000000000014580 ffff88007c31f1c0 ffff880079103680
[  923.934599]  ffff880079103688 7fffffffffffffff ffff88007c31f1c0 ffff880079103880
[  923.936855] Call Trace:
[  923.937920]  [<ffffffff815f18b9>] schedule+0x29/0x70
[  923.939538]  [<ffffffff815ef7b9>] schedule_timeout+0x209/0x2d0
[  923.941360]  [<ffffffff810976c3>] ? wake_up_process+0x23/0x40
[  923.943157]  [<ffffffff8107b464>] ? wake_up_worker+0x24/0x30
[  923.945147]  [<ffffffff8107bdf2>] ? insert_work+0x62/0xa0
[  923.946900]  [<ffffffff815f1de6>] wait_for_completion+0x116/0x170
[  923.948786]  [<ffffffff81097700>] ? wake_up_state+0x20/0x20
[  923.950572]  [<ffffffffa019ad44>] xfs_bmapi_allocate+0xa4/0xd0 [xfs]
[  923.952515]  [<ffffffffa01cc9f9>] xfs_bmapi_write+0x509/0x810 [xfs]
[  923.954398]  [<ffffffffa019a1f0>] ? xfs_next_bit+0x90/0x90 [xfs]
[  923.956223]  [<ffffffffa01abb50>] xfs_iomap_write_allocate+0x150/0x350 [xfs]
[  923.958256]  [<ffffffffa0197186>] xfs_map_blocks+0x216/0x240 [xfs]
[  923.960141]  [<ffffffffa01983b3>] xfs_vm_writepage+0x263/0x5c0 [xfs]
[  923.962053]  [<ffffffff8115497d>] shrink_page_list+0x80d/0xab0
[  923.963840]  [<ffffffff811552ca>] shrink_inactive_list+0x1ea/0x580
[  923.965677]  [<ffffffff81155dc5>] shrink_lruvec+0x375/0x6e0
[  923.967419]  [<ffffffff811b2556>] ? put_super+0x36/0x40
[  923.969072]  [<ffffffff811b2556>] ? put_super+0x36/0x40
[  923.970694]  [<ffffffff811561a6>] shrink_zone+0x76/0x1a0
[  923.972389]  [<ffffffff8115744c>] balance_pgdat+0x48c/0x5e0
[  923.974110]  [<ffffffff8115770b>] kswapd+0x16b/0x430
[  923.975682]  [<ffffffff81086ab0>] ? wake_up_bit+0x30/0x30
[  923.977395]  [<ffffffff811575a0>] ? balance_pgdat+0x5e0/0x5e0
[  923.979176]  [<ffffffff81085aef>] kthread+0xcf/0xe0
[  923.980739]  [<ffffffff81085a20>] ? kthread_create_on_node+0x140/0x140
[  923.982692]  [<ffffffff815fc76c>] ret_from_fork+0x7c/0xb0
[  923.984380]  [<ffffffff81085a20>] ? kthread_create_on_node+0x140/0x140
[  924.642947] kworker/1:2     D ffff88007fa34580     0   328      2 0x00000000
[  924.645307] Workqueue: xfsalloc xfs_bmapi_allocate_worker [xfs]
[  924.647219]  ffff8800781b1380 0000000000000046 ffff8800781b1fd8 0000000000014580
[  924.649586]  ffff8800781b1fd8 0000000000014580 ffff880078130b60 ffff88007c254000
[  924.651900]  ffff8800781b13b0 0000000100098869 ffff88007c254000 000000000000e728
[  924.654185] Call Trace:
[  924.655305]  [<ffffffff815f18b9>] schedule+0x29/0x70
[  924.656960]  [<ffffffff815ef725>] schedule_timeout+0x175/0x2d0
[  924.658832]  [<ffffffff8106e070>] ? __internal_add_timer+0x130/0x130
[  924.660803]  [<ffffffff815f10ab>] io_schedule_timeout+0x9b/0xf0
[  924.662685]  [<ffffffff81160a32>] congestion_wait+0x82/0x110
[  924.664520]  [<ffffffff81086ab0>] ? wake_up_bit+0x30/0x30
[  924.666269]  [<ffffffff8115543c>] shrink_inactive_list+0x35c/0x580
[  924.668188]  [<ffffffff812d028d>] ? list_del+0xd/0x30
[  924.669860]  [<ffffffff81155dc5>] shrink_lruvec+0x375/0x6e0
[  924.671662]  [<ffffffff811b2556>] ? put_super+0x36/0x40
[  924.673348]  [<ffffffff811b2556>] ? put_super+0x36/0x40
[  924.675045]  [<ffffffff811561a6>] shrink_zone+0x76/0x1a0
[  924.676749]  [<ffffffff811566b0>] do_try_to_free_pages+0xf0/0x4e0
[  924.678605]  [<ffffffff81156b9c>] try_to_free_pages+0xfc/0x180
[  924.680429]  [<ffffffff8114b2ce>] __alloc_pages_nodemask+0x75e/0xb10
[  924.682378]  [<ffffffff81188689>] alloc_pages_current+0xa9/0x170
[  924.684264]  [<ffffffffa020db11>] xfs_buf_allocate_memory+0x16d/0x24a [xfs]
[  924.686324]  [<ffffffffa019e3b5>] xfs_buf_get_map+0x125/0x180 [xfs]
[  924.688225]  [<ffffffffa019ed4c>] xfs_buf_read_map+0x2c/0x140 [xfs]
[  924.690172]  [<ffffffffa0202089>] xfs_trans_read_buf_map+0x2d9/0x4a0 [xfs]
[  924.692245]  [<ffffffffa01cf698>] xfs_btree_read_buf_block.isra.18.constprop.29+0x78/0xc0 [xfs]
[  924.694673]  [<ffffffffa01cf760>] xfs_btree_lookup_get_block+0x80/0x100 [xfs]
[  924.696793]  [<ffffffffa01d38e7>] xfs_btree_lookup+0xd7/0x4b0 [xfs]
[  924.698716]  [<ffffffffa01bc211>] ? xfs_allocbt_init_cursor+0x41/0xd0 [xfs]
[  924.700787]  [<ffffffffa01b9811>] xfs_alloc_ag_vextent_near+0x91/0xa50 [xfs]
[  924.702836]  [<ffffffffa01baa3d>] xfs_alloc_ag_vextent+0xcd/0x110 [xfs]
[  924.704849]  [<ffffffffa01bb7c9>] xfs_alloc_vextent+0x429/0x5e0 [xfs]
[  924.706807]  [<ffffffffa01cb73f>] xfs_bmap_btalloc+0x2df/0x820 [xfs]
[  924.709010]  [<ffffffffa01cbc8e>] xfs_bmap_alloc+0xe/0x10 [xfs]
[  924.710887]  [<ffffffffa01cc2d7>] __xfs_bmapi_allocate+0xc7/0x2e0 [xfs]
[  924.712905]  [<ffffffffa019a221>] xfs_bmapi_allocate_worker+0x31/0x60 [xfs]
[  924.714954]  [<ffffffff8107e02b>] process_one_work+0x17b/0x460
[  924.716754]  [<ffffffff8107edfb>] worker_thread+0x11b/0x400
[  924.718468]  [<ffffffff8107ece0>] ? rescuer_thread+0x400/0x400
[  924.720252]  [<ffffffff81085aef>] kthread+0xcf/0xe0
[  924.721855]  [<ffffffff81085a20>] ? kthread_create_on_node+0x140/0x140
[  924.723815]  [<ffffffff815fc76c>] ret_from_fork+0x7c/0xb0
[  924.725516]  [<ffffffff81085a20>] ? kthread_create_on_node+0x140/0x140
---------- stack trace end ----------

Since the kernel worker thread needs to escape from the while loop so that
alloc_page() can allocate memory (and eventually allow xfs_vm_writepage()
to release memory), I think that we should not block forever. This patch
introduces 30 seconds timeout for userspace processes and 5 seconds timeout
for kernel processes.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 mm/vmscan.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 32c661d..3eeeda6 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1459,13 +1459,18 @@ shrink_inactive_list(unsigned long nr_to_scan, struct lruvec *lruvec,
 	int file = is_file_lru(lru);
 	struct zone *zone = lruvec_zone(lruvec);
 	struct zone_reclaim_stat *reclaim_stat = &lruvec->reclaim_stat;
+	int i = 0;
 
-	while (unlikely(too_many_isolated(zone, file, sc))) {
+	/* Throttle with timeout. */
+	while (unlikely(too_many_isolated(zone, file, sc)) && i++ < 300) {
 		congestion_wait(BLK_RW_ASYNC, HZ/10);
 
 		/* We are about to die and free our memory. Return now. */
 		if (fatal_signal_pending(current))
 			return SWAP_CLUSTER_MAX;
+		/* Kernel threads should not be blocked for too long. */
+		if (i == 50 && (current->flags & PF_KTHREAD))
+			break;
 	}
 
 	lru_add_drain();
-- 
1.7.1
