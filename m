Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933749Ab3AOX04 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 18:26:56 -0500
Received: from mail.kernel.org ([198.145.19.201]:46949 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933538Ab3AOWwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:52:42 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Josh Durgin <josh.durgin@inktank.com>, Alex Elder <elder@inktank.com>
Subject: [ 133/171] rbd: return errors for mapped but deleted snapshot
Date: Tue, 15 Jan 2013 14:44:58 -0800
Message-Id: <20130115224322.925302722@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115224313.394976595@linuxfoundation.org>
References: <20130115224313.394976595@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Josh Durgin <josh.durgin@inktank.com>

When a snapshot is deleted, the OSD will return ENOENT when reading
from it. This is normally interpreted as a hole by rbd, which will
return zeroes. To minimize the time in which this can happen, stop
requests early when we are notified that our snapshot no longer
exists.

[elder@inktank.com: updated __rbd_init_snaps_header() logic]

Signed-off-by: Josh Durgin <josh.durgin@inktank.com>
Reviewed-by: Alex Elder <elder@inktank.com>
(cherry picked from commit e88a36ec961b8c1899c59c5e4ae35a318c0209d3)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Conflicts:

	drivers/block/rbd.c
---
 drivers/block/rbd.c |   32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -174,9 +174,13 @@ struct rbd_device {
 
 	/* protects updating the header */
 	struct rw_semaphore     header_rwsem;
+	/* name of the snapshot this device reads from */
 	char                    snap_name[RBD_MAX_SNAP_NAME_LEN];
+	/* id of the snapshot this device reads from */
 	u64                     snap_id;	/* current snapshot id */
-	int read_only;
+	/* whether the snap_id this device reads from still exists */
+	bool                    snap_exists;
+	int                     read_only;
 
 	struct list_head	node;
 
@@ -590,6 +594,7 @@ static int rbd_header_set_snap(struct rb
 		else
 			snapc->seq = 0;
 		dev->snap_id = CEPH_NOSNAP;
+		dev->snap_exists = false;
 		dev->read_only = 0;
 		if (size)
 			*size = header->image_size;
@@ -598,6 +603,7 @@ static int rbd_header_set_snap(struct rb
 		if (ret < 0)
 			goto done;
 		dev->snap_id = snapc->seq;
+		dev->snap_exists = true;
 		dev->read_only = 1;
 	}
 
@@ -1466,6 +1472,21 @@ static void rbd_rq_fn(struct request_que
 
 		spin_unlock_irq(q->queue_lock);
 
+		if (rbd_dev->snap_id != CEPH_NOSNAP) {
+			bool snap_exists;
+
+			down_read(&rbd_dev->header_rwsem);
+			snap_exists = rbd_dev->snap_exists;
+			up_read(&rbd_dev->header_rwsem);
+
+			if (!snap_exists) {
+				dout("request for non-existent snapshot");
+				spin_lock_irq(q->queue_lock);
+				__blk_end_request_all(rq, -ENXIO);
+				continue;
+			}
+		}
+
 		dout("%s 0x%x bytes at 0x%llx\n",
 		     do_write ? "write" : "read",
 		     size, blk_rq_pos(rq) * SECTOR_SIZE);
@@ -2069,7 +2090,14 @@ static int __rbd_init_snaps_header(struc
 			cur_id = rbd_dev->header.snapc->snaps[i - 1];
 
 		if (!i || old_snap->id < cur_id) {
-			/* old_snap->id was skipped, thus was removed */
+			/*
+			 * old_snap->id was skipped, thus was
+			 * removed.  If this rbd_dev is mapped to
+			 * the removed snapshot, record that it no
+			 * longer exists, to prevent further I/O.
+			 */
+			if (rbd_dev->snap_id == old_snap->id)
+				rbd_dev->snap_exists = false;
 			__rbd_remove_snap_dev(rbd_dev, old_snap);
 			continue;
 		}


