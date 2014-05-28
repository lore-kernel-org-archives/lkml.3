Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013AbaE1GYO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 02:24:14 -0400
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:57363 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbaE1GYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 02:24:13 -0400
From: "Li, Zhen-Hua" <zhen-hual@hp.com>
To: <linux-kernel@vger.kernel.org>, Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, <dm-devel@redhat.com>,
        Neil Brown <neilb@suse.de>, <linux-raid@vger.kernel.org>
Cc: "Li, Zhen-Hua" <zhen-hual@hp.com>
Subject: [PATCH 1/1] driver/md/block: Alloc space for member flush_rq
Date: Wed, 28 May 2014 14:22:52 +0800
Message-Id: <1401258172-17381-1-git-send-email-zhen-hual@hp.com>
X-Mailer: git-send-email 2.0.0-rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is trying to fix a kernel crash bug.

When kernel boots on a HP large system, it crashes.
The reason is when blk_rq_init is called, the second parameter rq , which
is a member as q->flush_rq, is NULL. Kernel does not allocate space for it.

This fix adds an alloc for flush_rq member when request_queue is created in
struct mapped_device *alloc_dev(int minor);

Bug Details:
Error message:

[   62.931942] BUG: unable to handle kernel NULL pointer dereference at (null)
[   62.931949] IP: [<ffffffff812b3f30>] blk_rq_init+0x40/0x160^M
[   62.931949] PGD 0 ^M
[   62.931951] Oops: 0002 [#1] SMP

[   62.932019] Call Trace:
[   62.932025]  [<ffffffff812bc5b8>] blk_flush_complete_seq+0x2d8/0x300
[   62.932027]  [<ffffffff812bca55>] blk_insert_flush+0x1e5/0x250
[   62.932029]  [<ffffffff812b3038>] __elv_add_request+0x1d8/0x2d0
[   62.932031]  [<ffffffff812ba630>] blk_flush_plug_list+0x140/0x230
[   62.932033]  [<ffffffff812baab4>] blk_finish_plug+0x14/0x40
[   62.932041]  [<ffffffffa0311e0c>] _xfs_buf_ioapply+0x2fc/0x3d0 [xfs]
[   62.932053]  [<ffffffffa036e63f>] ? xlog_bdstrat+0x1f/0x50 [xfs]
[   62.932061]  [<ffffffffa0313716>] xfs_buf_iorequest+0x46/0x90 [xfs]
[   62.932071]  [<ffffffffa036e63f>] xlog_bdstrat+0x1f/0x50 [xfs]
[   62.932080]  [<ffffffffa0370385>] xlog_sync+0x265/0x450 [xfs]
[   62.932090]  [<ffffffffa0370602>] xlog_state_release_iclog+0x92/0xb0 [xfs]
[   62.932099]  [<ffffffffa03713ba>] _xfs_log_force+0x15a/0x290 [xfs]
[   62.932108]  [<ffffffffa0371516>] xfs_log_force+0x26/0x80 [xfs]
[   62.932117]  [<ffffffffa0371594>] xfs_log_worker+0x24/0x50 [xfs]
[   62.932122]  [<ffffffff8108ce8b>] process_one_work+0x17b/0x460
[   62.932125]  [<ffffffff8108dc5b>] worker_thread+0x11b/0x400
[   62.932126]  [<ffffffff8108db40>] ? rescuer_thread+0x400/0x400
[   62.932130]  [<ffffffff81094ca1>] kthread+0xe1/0x100
[   62.932133]  [<ffffffff81094bc0>] ? kthread_create_on_node+0x1a0/0x1a0
[   62.932140]  [<ffffffff8162ae3c>] ret_from_fork+0x7c/0xb0
[   62.932141]  [<ffffffff81094bc0>] ? kthread_create_on_node+0x1a0/0x1a0

Signed-off-by: Li, Zhen-Hua <zhen-hual@hp.com>
---
 drivers/md/dm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 455e649..9ff6df6 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1893,6 +1893,10 @@ static struct mapped_device *alloc_dev(int minor)
 	if (!md->queue)
 		goto bad_queue;
 
+	md->queue->flush_rq = kzalloc(sizeof(struct request), GFP_KERNEL);
+	if (!md->queue->flush_rq)
+		goto bad_disk;
+
 	dm_init_md_queue(md);
 
 	md->disk = alloc_disk(1);
-- 
2.0.0-rc0

