Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932447Ab3LWV65 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 16:58:57 -0500
Received: from zimbra13.linbit.com ([212.69.166.240]:60635 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757813Ab3LWV6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 16:58:53 -0500
X-Greylist: delayed 473 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Dec 2013 16:58:52 EST
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 26/27] drbd: Use the right peer device
Date: Mon, 23 Dec 2013 22:50:55 +0100
Message-Id: <1387835456-29695-27-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387835456-29695-1-git-send-email-philipp.reisner@linbit.com>
References: <1387835456-29695-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@kernel.org>

in w_e_ (peer request) callbacks and in peer request I/O completion handlers

Signed-off-by: Andreas Gruenbacher <agruen@linbit.com>
Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
---
 drivers/block/drbd/drbd_worker.c |   69 +++++++++++++++++++++-----------------
 1 file changed, 38 insertions(+), 31 deletions(-)

diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index b826648..bf55f13 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -100,7 +100,8 @@ void drbd_md_io_complete(struct bio *bio, int error)
 void drbd_endio_read_sec_final(struct drbd_peer_request *peer_req) __releases(local)
 {
 	unsigned long flags = 0;
-	struct drbd_device *device = peer_req->peer_device->device;
+	struct drbd_peer_device *peer_device = peer_req->peer_device;
+	struct drbd_device *device = peer_device->device;
 
 	spin_lock_irqsave(&device->resource->req_lock, flags);
 	device->read_cnt += peer_req->i.size >> 9;
@@ -111,8 +112,7 @@ void drbd_endio_read_sec_final(struct drbd_peer_request *peer_req) __releases(lo
 		__drbd_chk_io_error(device, DRBD_READ_ERROR);
 	spin_unlock_irqrestore(&device->resource->req_lock, flags);
 
-	drbd_queue_work(&first_peer_device(device)->connection->sender_work,
-			&peer_req->w);
+	drbd_queue_work(&peer_device->connection->sender_work, &peer_req->w);
 	put_ldev(device);
 }
 
@@ -121,7 +121,8 @@ void drbd_endio_read_sec_final(struct drbd_peer_request *peer_req) __releases(lo
 static void drbd_endio_write_sec_final(struct drbd_peer_request *peer_req) __releases(local)
 {
 	unsigned long flags = 0;
-	struct drbd_device *device = peer_req->peer_device->device;
+	struct drbd_peer_device *peer_device = peer_req->peer_device;
+	struct drbd_device *device = peer_device->device;
 	struct drbd_interval i;
 	int do_wake;
 	u64 block_id;
@@ -162,7 +163,7 @@ static void drbd_endio_write_sec_final(struct drbd_peer_request *peer_req) __rel
 	if (do_al_complete_io)
 		drbd_al_complete_io(device, &i);
 
-	wake_asender(first_peer_device(device)->connection);
+	wake_asender(peer_device->connection);
 	put_ldev(device);
 }
 
@@ -334,7 +335,8 @@ void drbd_csum_bio(struct crypto_hash *tfm, struct bio *bio, void *digest)
 static int w_e_send_csum(struct drbd_work *w, int cancel)
 {
 	struct drbd_peer_request *peer_req = container_of(w, struct drbd_peer_request, w);
-	struct drbd_device *device = peer_req->peer_device->device;
+	struct drbd_peer_device *peer_device = peer_req->peer_device;
+	struct drbd_device *device = peer_device->device;
 	int digest_size;
 	void *digest;
 	int err = 0;
@@ -345,12 +347,12 @@ static int w_e_send_csum(struct drbd_work *w, int cancel)
 	if (unlikely((peer_req->flags & EE_WAS_ERROR) != 0))
 		goto out;
 
-	digest_size = crypto_hash_digestsize(first_peer_device(device)->connection->csums_tfm);
+	digest_size = crypto_hash_digestsize(peer_device->connection->csums_tfm);
 	digest = kmalloc(digest_size, GFP_NOIO);
 	if (digest) {
 		sector_t sector = peer_req->i.sector;
 		unsigned int size = peer_req->i.size;
-		drbd_csum_ee(first_peer_device(device)->connection->csums_tfm, peer_req, digest);
+		drbd_csum_ee(peer_device->connection->csums_tfm, peer_req, digest);
 		/* Free peer_req and pages before send.
 		 * In case we block on congestion, we could otherwise run into
 		 * some distributed deadlock, if the other side blocks on
@@ -359,7 +361,7 @@ static int w_e_send_csum(struct drbd_work *w, int cancel)
 		drbd_free_peer_req(device, peer_req);
 		peer_req = NULL;
 		inc_rs_pending(device);
-		err = drbd_send_drequest_csum(first_peer_device(device), sector, size,
+		err = drbd_send_drequest_csum(peer_device, sector, size,
 					      digest, digest_size,
 					      P_CSUM_RS_REQUEST);
 		kfree(digest);
@@ -995,7 +997,8 @@ static void move_to_net_ee_or_free(struct drbd_device *device, struct drbd_peer_
 int w_e_end_data_req(struct drbd_work *w, int cancel)
 {
 	struct drbd_peer_request *peer_req = container_of(w, struct drbd_peer_request, w);
-	struct drbd_device *device = peer_req->peer_device->device;
+	struct drbd_peer_device *peer_device = peer_req->peer_device;
+	struct drbd_device *device = peer_device->device;
 	int err;
 
 	if (unlikely(cancel)) {
@@ -1005,13 +1008,13 @@ int w_e_end_data_req(struct drbd_work *w, int cancel)
 	}
 
 	if (likely((peer_req->flags & EE_WAS_ERROR) == 0)) {
-		err = drbd_send_block(first_peer_device(device), P_DATA_REPLY, peer_req);
+		err = drbd_send_block(peer_device, P_DATA_REPLY, peer_req);
 	} else {
 		if (__ratelimit(&drbd_ratelimit_state))
 			drbd_err(device, "Sending NegDReply. sector=%llus.\n",
 			    (unsigned long long)peer_req->i.sector);
 
-		err = drbd_send_ack(first_peer_device(device), P_NEG_DREPLY, peer_req);
+		err = drbd_send_ack(peer_device, P_NEG_DREPLY, peer_req);
 	}
 
 	dec_unacked(device);
@@ -1031,7 +1034,8 @@ int w_e_end_data_req(struct drbd_work *w, int cancel)
 int w_e_end_rsdata_req(struct drbd_work *w, int cancel)
 {
 	struct drbd_peer_request *peer_req = container_of(w, struct drbd_peer_request, w);
-	struct drbd_device *device = peer_req->peer_device->device;
+	struct drbd_peer_device *peer_device = peer_req->peer_device;
+	struct drbd_device *device = peer_device->device;
 	int err;
 
 	if (unlikely(cancel)) {
@@ -1046,11 +1050,11 @@ int w_e_end_rsdata_req(struct drbd_work *w, int cancel)
 	}
 
 	if (device->state.conn == C_AHEAD) {
-		err = drbd_send_ack(first_peer_device(device), P_RS_CANCEL, peer_req);
+		err = drbd_send_ack(peer_device, P_RS_CANCEL, peer_req);
 	} else if (likely((peer_req->flags & EE_WAS_ERROR) == 0)) {
 		if (likely(device->state.pdsk >= D_INCONSISTENT)) {
 			inc_rs_pending(device);
-			err = drbd_send_block(first_peer_device(device), P_RS_DATA_REPLY, peer_req);
+			err = drbd_send_block(peer_device, P_RS_DATA_REPLY, peer_req);
 		} else {
 			if (__ratelimit(&drbd_ratelimit_state))
 				drbd_err(device, "Not sending RSDataReply, "
@@ -1062,7 +1066,7 @@ int w_e_end_rsdata_req(struct drbd_work *w, int cancel)
 			drbd_err(device, "Sending NegRSDReply. sector %llus.\n",
 			    (unsigned long long)peer_req->i.sector);
 
-		err = drbd_send_ack(first_peer_device(device), P_NEG_RS_DREPLY, peer_req);
+		err = drbd_send_ack(peer_device, P_NEG_RS_DREPLY, peer_req);
 
 		/* update resync data with failure */
 		drbd_rs_failed_io(device, peer_req->i.sector, peer_req->i.size);
@@ -1080,7 +1084,8 @@ int w_e_end_rsdata_req(struct drbd_work *w, int cancel)
 int w_e_end_csum_rs_req(struct drbd_work *w, int cancel)
 {
 	struct drbd_peer_request *peer_req = container_of(w, struct drbd_peer_request, w);
-	struct drbd_device *device = peer_req->peer_device->device;
+	struct drbd_peer_device *peer_device = peer_req->peer_device;
+	struct drbd_device *device = peer_device->device;
 	struct digest_info *di;
 	int digest_size;
 	void *digest = NULL;
@@ -1103,13 +1108,13 @@ int w_e_end_csum_rs_req(struct drbd_work *w, int cancel)
 		/* quick hack to try to avoid a race against reconfiguration.
 		 * a real fix would be much more involved,
 		 * introducing more locking mechanisms */
-		if (first_peer_device(device)->connection->csums_tfm) {
-			digest_size = crypto_hash_digestsize(first_peer_device(device)->connection->csums_tfm);
+		if (peer_device->connection->csums_tfm) {
+			digest_size = crypto_hash_digestsize(peer_device->connection->csums_tfm);
 			D_ASSERT(device, digest_size == di->digest_size);
 			digest = kmalloc(digest_size, GFP_NOIO);
 		}
 		if (digest) {
-			drbd_csum_ee(first_peer_device(device)->connection->csums_tfm, peer_req, digest);
+			drbd_csum_ee(peer_device->connection->csums_tfm, peer_req, digest);
 			eq = !memcmp(digest, di->digest, digest_size);
 			kfree(digest);
 		}
@@ -1118,16 +1123,16 @@ int w_e_end_csum_rs_req(struct drbd_work *w, int cancel)
 			drbd_set_in_sync(device, peer_req->i.sector, peer_req->i.size);
 			/* rs_same_csums unit is BM_BLOCK_SIZE */
 			device->rs_same_csum += peer_req->i.size >> BM_BLOCK_SHIFT;
-			err = drbd_send_ack(first_peer_device(device), P_RS_IS_IN_SYNC, peer_req);
+			err = drbd_send_ack(peer_device, P_RS_IS_IN_SYNC, peer_req);
 		} else {
 			inc_rs_pending(device);
 			peer_req->block_id = ID_SYNCER; /* By setting block_id, digest pointer becomes invalid! */
 			peer_req->flags &= ~EE_HAS_DIGEST; /* This peer request no longer has a digest pointer */
 			kfree(di);
-			err = drbd_send_block(first_peer_device(device), P_RS_DATA_REPLY, peer_req);
+			err = drbd_send_block(peer_device, P_RS_DATA_REPLY, peer_req);
 		}
 	} else {
-		err = drbd_send_ack(first_peer_device(device), P_NEG_RS_DREPLY, peer_req);
+		err = drbd_send_ack(peer_device, P_NEG_RS_DREPLY, peer_req);
 		if (__ratelimit(&drbd_ratelimit_state))
 			drbd_err(device, "Sending NegDReply. I guess it gets messy.\n");
 	}
@@ -1143,7 +1148,8 @@ int w_e_end_csum_rs_req(struct drbd_work *w, int cancel)
 int w_e_end_ov_req(struct drbd_work *w, int cancel)
 {
 	struct drbd_peer_request *peer_req = container_of(w, struct drbd_peer_request, w);
-	struct drbd_device *device = peer_req->peer_device->device;
+	struct drbd_peer_device *peer_device = peer_req->peer_device;
+	struct drbd_device *device = peer_device->device;
 	sector_t sector = peer_req->i.sector;
 	unsigned int size = peer_req->i.size;
 	int digest_size;
@@ -1153,7 +1159,7 @@ int w_e_end_ov_req(struct drbd_work *w, int cancel)
 	if (unlikely(cancel))
 		goto out;
 
-	digest_size = crypto_hash_digestsize(first_peer_device(device)->connection->verify_tfm);
+	digest_size = crypto_hash_digestsize(peer_device->connection->verify_tfm);
 	digest = kmalloc(digest_size, GFP_NOIO);
 	if (!digest) {
 		err = 1;	/* terminate the connection in case the allocation failed */
@@ -1161,7 +1167,7 @@ int w_e_end_ov_req(struct drbd_work *w, int cancel)
 	}
 
 	if (likely(!(peer_req->flags & EE_WAS_ERROR)))
-		drbd_csum_ee(first_peer_device(device)->connection->verify_tfm, peer_req, digest);
+		drbd_csum_ee(peer_device->connection->verify_tfm, peer_req, digest);
 	else
 		memset(digest, 0, digest_size);
 
@@ -1173,7 +1179,7 @@ int w_e_end_ov_req(struct drbd_work *w, int cancel)
 	drbd_free_peer_req(device, peer_req);
 	peer_req = NULL;
 	inc_rs_pending(device);
-	err = drbd_send_drequest_csum(first_peer_device(device), sector, size, digest, digest_size, P_OV_REPLY);
+	err = drbd_send_drequest_csum(peer_device, sector, size, digest, digest_size, P_OV_REPLY);
 	if (err)
 		dec_rs_pending(device);
 	kfree(digest);
@@ -1199,7 +1205,8 @@ void drbd_ov_out_of_sync_found(struct drbd_device *device, sector_t sector, int
 int w_e_end_ov_reply(struct drbd_work *w, int cancel)
 {
 	struct drbd_peer_request *peer_req = container_of(w, struct drbd_peer_request, w);
-	struct drbd_device *device = peer_req->peer_device->device;
+	struct drbd_peer_device *peer_device = peer_req->peer_device;
+	struct drbd_device *device = peer_device->device;
 	struct digest_info *di;
 	void *digest;
 	sector_t sector = peer_req->i.sector;
@@ -1224,10 +1231,10 @@ int w_e_end_ov_reply(struct drbd_work *w, int cancel)
 	di = peer_req->digest;
 
 	if (likely((peer_req->flags & EE_WAS_ERROR) == 0)) {
-		digest_size = crypto_hash_digestsize(first_peer_device(device)->connection->verify_tfm);
+		digest_size = crypto_hash_digestsize(peer_device->connection->verify_tfm);
 		digest = kmalloc(digest_size, GFP_NOIO);
 		if (digest) {
-			drbd_csum_ee(first_peer_device(device)->connection->verify_tfm, peer_req, digest);
+			drbd_csum_ee(peer_device->connection->verify_tfm, peer_req, digest);
 
 			D_ASSERT(device, digest_size == di->digest_size);
 			eq = !memcmp(digest, di->digest, digest_size);
@@ -1246,7 +1253,7 @@ int w_e_end_ov_reply(struct drbd_work *w, int cancel)
 	else
 		ov_out_of_sync_print(device);
 
-	err = drbd_send_ack_ex(first_peer_device(device), P_OV_RESULT, sector, size,
+	err = drbd_send_ack_ex(peer_device, P_OV_RESULT, sector, size,
 			       eq ? ID_IN_SYNC : ID_OUT_OF_SYNC);
 
 	dec_unacked(device);
-- 
1.7.9.5

