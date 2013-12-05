Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453Ab3LER6a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 12:58:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38149 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933041Ab3LERgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 12:36:54 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 24/90] loop: fix crash when using unassigned loop device
Date: Thu,  5 Dec 2013 17:35:06 +0000
Message-Id: <1386264972-5399-25-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
References: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit ef7e7c82e02b602f29c2b87f42dcd6143a6777da upstream.

When the loop module is loaded, it creates 8 loop devices /dev/loop[0-7].
The devices have no request routine and thus, when they are used without
being assigned, a crash happens.

For example, these commands cause crash (assuming there are no used loop
devices):

Kernel Fault: Code=26 regs=000000007f420980 (Addr=0000000000000010)
CPU: 1 PID: 50 Comm: kworker/1:1 Not tainted 3.11.0 #1
Workqueue: ksnaphd do_metadata [dm_snapshot]
task: 000000007fcf4078 ti: 000000007f420000 task.ti: 000000007f420000
[  116.319988]
     YZrvWESTHLNXBCVMcbcbcbcbOGFRQPDI
PSW: 00001000000001001111111100001111 Not tainted
r00-03  000000ff0804ff0f 00000000408bf5d0 00000000402d8204 000000007b7ff6c0
r04-07  00000000408a95d0 000000007f420950 000000007b7ff6c0 000000007d06c930
r08-11  000000007f4205c0 0000000000000001 000000007f4205c0 000000007f4204b8
r12-15  0000000000000010 0000000000000000 0000000000000000 0000000000000000
r16-19  000000001108dd48 000000004061cd7c 000000007d859800 000000000800000f
r20-23  0000000000000000 0000000000000008 0000000000000000 0000000000000000
r24-27  00000000ffffffff 000000007b7ff6c0 000000007d859800 00000000408a95d0
r28-31  0000000000000000 000000007f420950 000000007f420980 000000007f4208e8
sr00-03  0000000000000000 0000000000000000 0000000000000000 0000000000303000
sr04-07  0000000000000000 0000000000000000 0000000000000000 0000000000000000
[  117.549988]
IASQ: 0000000000000000 0000000000000000 IAOQ: 00000000402d82fc 00000000402d8300
 IIR: 53820020    ISR: 0000000000000000  IOR: 0000000000000010
 CPU:        1   CR30: 000000007f420000 CR31: ffffffffffffffff
 ORIG_R28: 0000000000000001
 IAOQ[0]: generic_make_request+0x11c/0x1a0
 IAOQ[1]: generic_make_request+0x120/0x1a0
 RP(r2): generic_make_request+0x24/0x1a0
Backtrace:
 [<00000000402d83f0>] submit_bio+0x70/0x140
 [<0000000011087c4c>] dispatch_io+0x234/0x478 [dm_mod]
 [<0000000011087f44>] sync_io+0xb4/0x190 [dm_mod]
 [<00000000110883bc>] dm_io+0x2c4/0x310 [dm_mod]
 [<00000000110bfcd0>] do_metadata+0x28/0xb0 [dm_snapshot]
 [<00000000401591d8>] process_one_work+0x160/0x460
 [<0000000040159bc0>] worker_thread+0x300/0x478
 [<0000000040161a70>] kthread+0x118/0x128
 [<0000000040104020>] end_fault_vector+0x20/0x28
 [<0000000040177220>] task_tick_fair+0x420/0x4d0
 [<00000000401aa048>] invoke_rcu_core+0x50/0x60
 [<00000000401ad5b8>] rcu_check_callbacks+0x210/0x8d8
 [<000000004014aaa0>] update_process_times+0xa8/0xc0
 [<00000000401ab86c>] rcu_process_callbacks+0x4b4/0x598
 [<0000000040142408>] __do_softirq+0x250/0x2c0
 [<00000000401789d0>] find_busiest_group+0x3c0/0xc70
[  119.379988]
Kernel panic - not syncing: Kernel Fault
Rebooting in 1 seconds..

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/block/loop.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 1e50244..34f5e1a 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -878,13 +878,6 @@ static int loop_set_fd(struct loop_device *lo, fmode_t mode,
 
 	bio_list_init(&lo->lo_bio_list);
 
-	/*
-	 * set queue make_request_fn, and add limits based on lower level
-	 * device
-	 */
-	blk_queue_make_request(lo->lo_queue, loop_make_request);
-	lo->lo_queue->queuedata = lo;
-
 	if (!(lo_flags & LO_FLAGS_READ_ONLY) && file->f_op->fsync)
 		blk_queue_flush(lo->lo_queue, REQ_FLUSH);
 
@@ -1607,6 +1600,8 @@ static int loop_add(struct loop_device **l, int i)
 	if (!lo)
 		goto out;
 
+	lo->lo_state = Lo_unbound;
+
 	if (!idr_pre_get(&loop_index_idr, GFP_KERNEL))
 		goto out_free_dev;
 
@@ -1636,6 +1631,12 @@ static int loop_add(struct loop_device **l, int i)
 	if (!lo->lo_queue)
 		goto out_free_idr;
 
+	/*
+	 * set queue make_request_fn
+	 */
+	blk_queue_make_request(lo->lo_queue, loop_make_request);
+	lo->lo_queue->queuedata = lo;
+
 	disk = lo->lo_disk = alloc_disk(1 << part_shift);
 	if (!disk)
 		goto out_free_queue;
-- 
1.8.3.2

