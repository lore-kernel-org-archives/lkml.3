Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964818AbaGAQUy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 12:20:54 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:53114 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757677AbaGAQQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 12:16:55 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 09/20] drbd: application writes may set-in-sync in protocol != C
Date: Tue,  1 Jul 2014 18:16:39 +0200
Message-Id: <1404231410-29852-10-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404231410-29852-1-git-send-email-philipp.reisner@linbit.com>
References: <1404231410-29852-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

If "dirty" blocks are written to during resync,
that brings them in-sync.

By explicitly requesting write-acks during resync even in protocol != C,
we now can actually respect this.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_interval.h |  4 ++-
 drivers/block/drbd/drbd_main.c     |  5 ++-
 drivers/block/drbd/drbd_receiver.c |  3 ++
 drivers/block/drbd/drbd_req.c      | 68 ++++++++++++++++++++++----------------
 4 files changed, 49 insertions(+), 31 deletions(-)

diff --git a/drivers/block/drbd/drbd_interval.h b/drivers/block/drbd/drbd_interval.h
index f38fcb0..f210543 100644
--- a/drivers/block/drbd/drbd_interval.h
+++ b/drivers/block/drbd/drbd_interval.h
@@ -10,7 +10,9 @@ struct drbd_interval {
 	unsigned int size;	/* size in bytes */
 	sector_t end;		/* highest interval end in subtree */
 	int local:1		/* local or remote request? */;
-	int waiting:1;
+	int waiting:1;		/* someone is waiting for this to complete */
+	int completed:1;	/* this has been completed already;
+				 * ignore for conflict detection */
 };
 
 static inline void drbd_clear_interval(struct drbd_interval *i)
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 7c06024..7ada5d3 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -1639,7 +1639,10 @@ int drbd_send_dblock(struct drbd_peer_device *peer_device, struct drbd_request *
 	if (peer_device->connection->agreed_pro_version >= 100) {
 		if (req->rq_state & RQ_EXP_RECEIVE_ACK)
 			dp_flags |= DP_SEND_RECEIVE_ACK;
-		if (req->rq_state & RQ_EXP_WRITE_ACK)
+		/* During resync, request an explicit write ack,
+		 * even in protocol != C */
+		if (req->rq_state & RQ_EXP_WRITE_ACK
+		|| (dp_flags & DP_MAY_SET_IN_SYNC))
 			dp_flags |= DP_SEND_WRITE_ACK;
 	}
 	p->dp_flags = cpu_to_be32(dp_flags);
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index b89e6fb..3a3c489 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -1930,6 +1930,7 @@ static int e_end_block(struct drbd_work *w, int cancel)
 		}
 		dec_unacked(device);
 	}
+
 	/* we delete from the conflict detection hash _after_ we sent out the
 	 * P_WRITE_ACK / P_NEG_ACK, to get the sequence number right.  */
 	if (peer_req->flags & EE_IN_INTERVAL_TREE) {
@@ -2156,6 +2157,8 @@ static int handle_write_conflicts(struct drbd_device *device,
 	drbd_for_each_overlap(i, &device->write_requests, sector, size) {
 		if (i == &peer_req->i)
 			continue;
+		if (i->completed)
+			continue;
 
 		if (!i->local) {
 			/*
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 1ee7355..f07a724 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -92,6 +92,19 @@ static struct drbd_request *drbd_req_new(struct drbd_device *device,
 	return req;
 }
 
+static void drbd_remove_request_interval(struct rb_root *root,
+					 struct drbd_request *req)
+{
+	struct drbd_device *device = req->device;
+	struct drbd_interval *i = &req->i;
+
+	drbd_remove_interval(root, i);
+
+	/* Wake up any processes waiting for this request to complete.  */
+	if (i->waiting)
+		wake_up(&device->misc_wait);
+}
+
 void drbd_req_destroy(struct kref *kref)
 {
 	struct drbd_request *req = container_of(kref, struct drbd_request, kref);
@@ -115,6 +128,20 @@ void drbd_req_destroy(struct kref *kref)
 	 * here unconditionally */
 	list_del_init(&req->tl_requests);
 
+	/* finally remove the request from the conflict detection
+	 * respective block_id verification interval tree. */
+	if (!drbd_interval_empty(&req->i)) {
+		struct rb_root *root;
+
+		if (s & RQ_WRITE)
+			root = &device->write_requests;
+		else
+			root = &device->read_requests;
+		drbd_remove_request_interval(root, req);
+	} else if (s & (RQ_NET_MASK & ~RQ_NET_DONE) && req->i.size != 0)
+		drbd_err(device, "drbd_req_destroy: Logic BUG: interval empty, but: rq_state=0x%x, sect=%llu, size=%u\n",
+			s, (unsigned long long)req->i.sector, req->i.size);
+
 	/* if it was a write, we may have to set the corresponding
 	 * bit(s) out-of-sync first. If it had a local part, we need to
 	 * release the reference to the activity log. */
@@ -188,19 +215,6 @@ void complete_master_bio(struct drbd_device *device,
 }
 
 
-static void drbd_remove_request_interval(struct rb_root *root,
-					 struct drbd_request *req)
-{
-	struct drbd_device *device = req->device;
-	struct drbd_interval *i = &req->i;
-
-	drbd_remove_interval(root, i);
-
-	/* Wake up any processes waiting for this request to complete.  */
-	if (i->waiting)
-		wake_up(&device->misc_wait);
-}
-
 /* Helper for __req_mod().
  * Set m->bio to the master bio, if it is fit to be completed,
  * or leave it alone (it is initialized to NULL in __req_mod),
@@ -254,18 +268,6 @@ void drbd_req_complete(struct drbd_request *req, struct bio_and_error *m)
 	ok = (s & RQ_LOCAL_OK) || (s & RQ_NET_OK);
 	error = PTR_ERR(req->private_bio);
 
-	/* remove the request from the conflict detection
-	 * respective block_id verification hash */
-	if (!drbd_interval_empty(&req->i)) {
-		struct rb_root *root;
-
-		if (rw == WRITE)
-			root = &device->write_requests;
-		else
-			root = &device->read_requests;
-		drbd_remove_request_interval(root, req);
-	}
-
 	/* Before we can signal completion to the upper layers,
 	 * we may need to close the current transfer log epoch.
 	 * We are within the request lock, so we can simply compare
@@ -301,7 +303,15 @@ void drbd_req_complete(struct drbd_request *req, struct bio_and_error *m)
 		m->error = ok ? 0 : (error ?: -EIO);
 		m->bio = req->master_bio;
 		req->master_bio = NULL;
+		/* We leave it in the tree, to be able to verify later
+		 * write-acks in protocol != C during resync.
+		 * But we mark it as "complete", so it won't be counted as
+		 * conflict in a multi-primary setup. */
+		req->i.completed = true;
 	}
+
+	if (req->i.waiting)
+		wake_up(&device->misc_wait);
 }
 
 static int drbd_req_put_completion_ref(struct drbd_request *req, struct bio_and_error *m, int put)
@@ -660,12 +670,13 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 	case WRITE_ACKED_BY_PEER_AND_SIS:
 		req->rq_state |= RQ_NET_SIS;
 	case WRITE_ACKED_BY_PEER:
-		D_ASSERT(device, req->rq_state & RQ_EXP_WRITE_ACK);
-		/* protocol C; successfully written on peer.
+		/* Normal operation protocol C: successfully written on peer.
+		 * During resync, even in protocol != C,
+		 * we requested an explicit write ack anyways.
+		 * Which means we cannot even assert anything here.
 		 * Nothing more to do here.
 		 * We want to keep the tl in place for all protocols, to cater
 		 * for volatile write-back caches on lower level devices. */
-
 		goto ack_common;
 	case RECV_ACKED_BY_PEER:
 		D_ASSERT(device, req->rq_state & RQ_EXP_RECEIVE_ACK);
@@ -673,7 +684,6 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		 * see also notes above in HANDED_OVER_TO_NETWORK about
 		 * protocol != C */
 	ack_common:
-		D_ASSERT(device, req->rq_state & RQ_NET_PENDING);
 		mod_rq_state(req, m, RQ_NET_PENDING, RQ_NET_OK);
 		break;
 
-- 
1.9.1

