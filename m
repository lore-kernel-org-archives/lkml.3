Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693Ab3HZNwB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 09:52:01 -0400
Received: from usindpps05.hds.com ([207.126.252.18]:45429 "EHLO
	usindpps05.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887Ab3HZNwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 09:52:00 -0400
X-Greylist: delayed 384 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Aug 2013 09:51:59 EDT
Subject: [PATCH] elevator: Fix a race in elevator switching and md device
 initialization
To: linux-kernel@vger.kernel.org
From: Tomoki Sekiyama <tomoki.sekiyama@hds.com>
Cc: axboe@kernel.dk, seiji.aguchi@hds.com, vgoyal@redhat.com,
        majianpeng@gmail.com
Date: Mon, 26 Aug 2013 09:45:15 -0400
Message-ID: <20130826134515.2298.55571.stgit@outback>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx ip4:207.126.244.0/26 ip4:207.126.252.0/25 include:mktomail.com
 include:cloud.hds.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-08-26_03:2013-08-26,2013-08-26,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=outbound_policy score=0 spamscore=0 suspectscore=1
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1308260085
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The soft lockup below happes at the boot time of the system using dm
multipath and automated elevator switching udev rules.

[  356.127001] BUG: soft lockup - CPU#3 stuck for 22s! [sh:483]
[  356.127001] RIP: 0010:[<ffffffff81072a7d>]  [<ffffffff81072a7d>] lock_timer_base.isra.35+0x1d/0x50
...
[  356.127001] Call Trace:
[  356.127001]  [<ffffffff81073810>] try_to_del_timer_sync+0x20/0x70
[  356.127001]  [<ffffffff8118b08a>] ? kmem_cache_alloc_node_trace+0x20a/0x230
[  356.127001]  [<ffffffff810738b2>] del_timer_sync+0x52/0x60
[  356.127001]  [<ffffffff812ece22>] cfq_exit_queue+0x32/0xf0
[  356.127001]  [<ffffffff812c98df>] elevator_exit+0x2f/0x50
[  356.127001]  [<ffffffff812c9f21>] elevator_change+0xf1/0x1c0
[  356.127001]  [<ffffffff812caa50>] elv_iosched_store+0x20/0x50
[  356.127001]  [<ffffffff812d1d09>] queue_attr_store+0x59/0xb0
[  356.127001]  [<ffffffff812143f6>] sysfs_write_file+0xc6/0x140
[  356.127001]  [<ffffffff811a326d>] vfs_write+0xbd/0x1e0
[  356.127001]  [<ffffffff811a3ca9>] SyS_write+0x49/0xa0
[  356.127001]  [<ffffffff8164e899>] system_call_fastpath+0x16/0x1b

This is caused by a race between md device initialization and sysfs knob
to switch the scheduler.

* multipathd:
 SyS_ioctl -> do_vfs_ioctl -> dm_ctl_ioctl -> ctl_ioctl ->  table_load
  -> dm_setup_md_queue -> blk_init_allocated_queue -> elevator_init:

    q->elevator = elevator_alloc(q, e); // not yet initialized

* sh -c 'echo deadline > /sys/$DEVPATH/queue/scheduler'
 SyS_write -> vfs_write -> sysfs_write_file -> queue_attr_store
     ( mutex_lock(&q->sysfs_lock) here. )
  -> elv_iosched_store -> elevator_change:

  elevator_exit(old); // try to de-init uninitialized elevator and hang up

This patch adds acquisition of q->sysfs_lock in blk_init_allocated_queue().
This also adds the lock into elevator_change() to ensure locking from the
other path, as it is exposed function (and queue_attr_store will uses
__elevator_change() now, the non-locking version of elevator_change()).

Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama@hds.com>
---
 block/blk-core.c |    6 +++++-
 block/elevator.c |   16 ++++++++++++++--
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 93a18d1..2323ec3 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -739,9 +739,13 @@ blk_init_allocated_queue(struct request_queue *q, request_fn_proc *rfn,
 
 	q->sg_reserved_size = INT_MAX;
 
+	/* Protect q->elevator from elevator_change */
+	mutex_lock(&q->sysfs_lock);
 	/* init elevator */
 	if (elevator_init(q, NULL))
-		return NULL;
+		q = NULL;
+	mutex_unlock(&q->sysfs_lock);
+
 	return q;
 }
 EXPORT_SYMBOL(blk_init_allocated_queue);
diff --git a/block/elevator.c b/block/elevator.c
index 668394d..5232565 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -959,7 +959,7 @@ fail_init:
 /*
  * Switch this queue to the given IO scheduler.
  */
-int elevator_change(struct request_queue *q, const char *name)
+static int __elevator_change(struct request_queue *q, const char *name)
 {
 	char elevator_name[ELV_NAME_MAX];
 	struct elevator_type *e;
@@ -981,6 +981,18 @@ int elevator_change(struct request_queue *q, const char *name)
 
 	return elevator_switch(q, e);
 }
+
+int elevator_change(struct request_queue *q, const char *name)
+{
+	int ret;
+
+	/* Protect q->elevator from blk_init_allocated_queue() */
+	mutex_lock(&q->sysfs_lock);
+	ret = __elevator_change(q, name);
+	mutex_unlock(&q->sysfs_lock);
+
+	return ret;
+}
 EXPORT_SYMBOL(elevator_change);
 
 ssize_t elv_iosched_store(struct request_queue *q, const char *name,
@@ -991,7 +1003,7 @@ ssize_t elv_iosched_store(struct request_queue *q, const char *name,
 	if (!q->elevator)
 		return count;
 
-	ret = elevator_change(q, name);
+	ret = __elevator_change(q, name);
 	if (!ret)
 		return count;
 

