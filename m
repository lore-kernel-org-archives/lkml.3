Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932588Ab3LWWBY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 17:01:24 -0500
Received: from zimbra13.linbit.com ([212.69.166.240]:60677 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932449Ab3LWV7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 16:59:00 -0500
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 11/27] drbd: Replace vnr_to_mdev() with conn_peer_device()
Date: Mon, 23 Dec 2013 22:50:40 +0100
Message-Id: <1387835456-29695-12-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387835456-29695-1-git-send-email-philipp.reisner@linbit.com>
References: <1387835456-29695-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

The new function returns a peer device, which allows us to eliminate a few
instances of first_peer_device().

Signed-off-by: Andreas Gruenbacher <agruen@linbit.com>
Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |    8 --
 drivers/block/drbd/drbd_receiver.c |  174 ++++++++++++++++++++++--------------
 2 files changed, 109 insertions(+), 73 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 7ba1db8..461cf8d 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -851,14 +851,6 @@ static inline unsigned int device_to_minor(struct drbd_device *device)
 	return device->minor;
 }
 
-static inline struct drbd_device *vnr_to_device(struct drbd_connection *connection, int vnr)
-{
-	struct drbd_peer_device *peer_device;
-
-	peer_device = idr_find(&connection->peer_devices, vnr);
-	return peer_device ? peer_device->device : NULL;
-}
-
 /*
  * function declarations
  *************************/
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index cb37e23..edd5cac 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -1422,6 +1422,12 @@ void conn_wait_active_ee_empty(struct drbd_connection *connection)
 	rcu_read_unlock();
 }
 
+static struct drbd_peer_device *
+conn_peer_device(struct drbd_connection *connection, int volume_number)
+{
+	return idr_find(&connection->peer_devices, volume_number);
+}
+
 static int receive_Barrier(struct drbd_connection *connection, struct packet_info *pi)
 {
 	int rv;
@@ -1731,15 +1737,17 @@ find_request(struct drbd_device *device, struct rb_root *root, u64 id,
 
 static int receive_DataReply(struct drbd_connection *connection, struct packet_info *pi)
 {
+	struct drbd_peer_device *peer_device;
 	struct drbd_device *device;
 	struct drbd_request *req;
 	sector_t sector;
 	int err;
 	struct p_data *p = pi->data;
 
-	device = vnr_to_device(connection, pi->vnr);
-	if (!device)
+	peer_device = conn_peer_device(connection, pi->vnr);
+	if (!peer_device)
 		return -EIO;
+	device = peer_device->device;
 
 	sector = be64_to_cpu(p->sector);
 
@@ -1764,14 +1772,16 @@ static int receive_DataReply(struct drbd_connection *connection, struct packet_i
 
 static int receive_RSDataReply(struct drbd_connection *connection, struct packet_info *pi)
 {
+	struct drbd_peer_device *peer_device;
 	struct drbd_device *device;
 	sector_t sector;
 	int err;
 	struct p_data *p = pi->data;
 
-	device = vnr_to_device(connection, pi->vnr);
-	if (!device)
+	peer_device = conn_peer_device(connection, pi->vnr);
+	if (!peer_device)
 		return -EIO;
+	device = peer_device->device;
 
 	sector = be64_to_cpu(p->sector);
 	D_ASSERT(device, p->block_id == ID_SYNCER);
@@ -2154,6 +2164,7 @@ static int handle_write_conflicts(struct drbd_device *device,
 /* mirrored write */
 static int receive_Data(struct drbd_connection *connection, struct packet_info *pi)
 {
+	struct drbd_peer_device *peer_device;
 	struct drbd_device *device;
 	sector_t sector;
 	struct drbd_peer_request *peer_req;
@@ -2163,9 +2174,10 @@ static int receive_Data(struct drbd_connection *connection, struct packet_info *
 	u32 dp_flags;
 	int err, tp;
 
-	device = vnr_to_device(connection, pi->vnr);
-	if (!device)
+	peer_device = conn_peer_device(connection, pi->vnr);
+	if (!peer_device)
 		return -EIO;
+	device = peer_device->device;
 
 	if (!get_ldev(device)) {
 		int err2;
@@ -2211,7 +2223,7 @@ static int receive_Data(struct drbd_connection *connection, struct packet_info *
 	spin_unlock(&connection->epoch_lock);
 
 	rcu_read_lock();
-	tp = rcu_dereference(first_peer_device(device)->connection->net_conf)->two_primaries;
+	tp = rcu_dereference(peer_device->connection->net_conf)->two_primaries;
 	rcu_read_unlock();
 	if (tp) {
 		peer_req->flags |= EE_IN_INTERVAL_TREE;
@@ -2238,9 +2250,9 @@ static int receive_Data(struct drbd_connection *connection, struct packet_info *
 	if (device->state.conn == C_SYNC_TARGET)
 		wait_event(device->ee_wait, !overlapping_resync_write(device, peer_req));
 
-	if (first_peer_device(device)->connection->agreed_pro_version < 100) {
+	if (peer_device->connection->agreed_pro_version < 100) {
 		rcu_read_lock();
-		switch (rcu_dereference(first_peer_device(device)->connection->net_conf)->wire_protocol) {
+		switch (rcu_dereference(peer_device->connection->net_conf)->wire_protocol) {
 		case DRBD_PROT_C:
 			dp_flags |= DP_SEND_WRITE_ACK;
 			break;
@@ -2366,6 +2378,7 @@ int drbd_rs_should_slow_down(struct drbd_device *device, sector_t sector)
 
 static int receive_DataRequest(struct drbd_connection *connection, struct packet_info *pi)
 {
+	struct drbd_peer_device *peer_device;
 	struct drbd_device *device;
 	sector_t sector;
 	sector_t capacity;
@@ -2375,9 +2388,10 @@ static int receive_DataRequest(struct drbd_connection *connection, struct packet
 	unsigned int fault_type;
 	struct p_block_req *p =	pi->data;
 
-	device = vnr_to_device(connection, pi->vnr);
-	if (!device)
+	peer_device = conn_peer_device(connection, pi->vnr);
+	if (!peer_device)
 		return -EIO;
+	device = peer_device->device;
 	capacity = drbd_get_capacity(device->this_bdev);
 
 	sector = be64_to_cpu(p->sector);
@@ -2457,11 +2471,11 @@ static int receive_DataRequest(struct drbd_connection *connection, struct packet
 		peer_req->digest = di;
 		peer_req->flags |= EE_HAS_DIGEST;
 
-		if (drbd_recv_all(first_peer_device(device)->connection, di->digest, pi->size))
+		if (drbd_recv_all(peer_device->connection, di->digest, pi->size))
 			goto out_free_e;
 
 		if (pi->cmd == P_CSUM_RS_REQUEST) {
-			D_ASSERT(device, first_peer_device(device)->connection->agreed_pro_version >= 89);
+			D_ASSERT(device, peer_device->connection->agreed_pro_version >= 89);
 			peer_req->w.cb = w_e_end_csum_rs_req;
 			/* used in the sector offset progress display */
 			device->bm_resync_fo = BM_SECT_TO_BIT(sector);
@@ -2478,7 +2492,7 @@ static int receive_DataRequest(struct drbd_connection *connection, struct packet
 
 	case P_OV_REQUEST:
 		if (device->ov_start_sector == ~(sector_t)0 &&
-		    first_peer_device(device)->connection->agreed_pro_version >= 90) {
+		    peer_device->connection->agreed_pro_version >= 90) {
 			unsigned long now = jiffies;
 			int i;
 			device->ov_start_sector = sector;
@@ -3322,6 +3336,7 @@ static int config_unknown_volume(struct drbd_connection *connection, struct pack
 
 static int receive_SyncParam(struct drbd_connection *connection, struct packet_info *pi)
 {
+	struct drbd_peer_device *peer_device;
 	struct drbd_device *device;
 	struct p_rs_param_95 *p;
 	unsigned int header_size, data_size, exp_max_sz;
@@ -3334,9 +3349,10 @@ static int receive_SyncParam(struct drbd_connection *connection, struct packet_i
 	int fifo_size = 0;
 	int err;
 
-	device = vnr_to_device(connection, pi->vnr);
-	if (!device)
+	peer_device = conn_peer_device(connection, pi->vnr);
+	if (!peer_device)
 		return config_unknown_volume(connection, pi);
+	device = peer_device->device;
 
 	exp_max_sz  = apv <= 87 ? sizeof(struct p_rs_param)
 		    : apv == 88 ? sizeof(struct p_rs_param)
@@ -3367,12 +3383,12 @@ static int receive_SyncParam(struct drbd_connection *connection, struct packet_i
 	p = pi->data;
 	memset(p->verify_alg, 0, 2 * SHARED_SECRET_MAX);
 
-	err = drbd_recv_all(first_peer_device(device)->connection, p, header_size);
+	err = drbd_recv_all(peer_device->connection, p, header_size);
 	if (err)
 		return err;
 
 	mutex_lock(&connection->resource->conf_update);
-	old_net_conf = first_peer_device(device)->connection->net_conf;
+	old_net_conf = peer_device->connection->net_conf;
 	if (get_ldev(device)) {
 		new_disk_conf = kzalloc(sizeof(struct disk_conf), GFP_KERNEL);
 		if (!new_disk_conf) {
@@ -3398,7 +3414,7 @@ static int receive_SyncParam(struct drbd_connection *connection, struct packet_i
 				goto reconnect;
 			}
 
-			err = drbd_recv_all(first_peer_device(device)->connection, p->verify_alg, data_size);
+			err = drbd_recv_all(peer_device->connection, p->verify_alg, data_size);
 			if (err)
 				goto reconnect;
 			/* we expect NUL terminated string */
@@ -3472,15 +3488,15 @@ static int receive_SyncParam(struct drbd_connection *connection, struct packet_i
 			if (verify_tfm) {
 				strcpy(new_net_conf->verify_alg, p->verify_alg);
 				new_net_conf->verify_alg_len = strlen(p->verify_alg) + 1;
-				crypto_free_hash(first_peer_device(device)->connection->verify_tfm);
-				first_peer_device(device)->connection->verify_tfm = verify_tfm;
+				crypto_free_hash(peer_device->connection->verify_tfm);
+				peer_device->connection->verify_tfm = verify_tfm;
 				drbd_info(device, "using verify-alg: \"%s\"\n", p->verify_alg);
 			}
 			if (csums_tfm) {
 				strcpy(new_net_conf->csums_alg, p->csums_alg);
 				new_net_conf->csums_alg_len = strlen(p->csums_alg) + 1;
-				crypto_free_hash(first_peer_device(device)->connection->csums_tfm);
-				first_peer_device(device)->connection->csums_tfm = csums_tfm;
+				crypto_free_hash(peer_device->connection->csums_tfm);
+				peer_device->connection->csums_tfm = csums_tfm;
 				drbd_info(device, "using csums-alg: \"%s\"\n", p->csums_alg);
 			}
 			rcu_assign_pointer(connection->net_conf, new_net_conf);
@@ -3526,7 +3542,7 @@ disconnect:
 	crypto_free_hash(csums_tfm);
 	/* but free the verify_tfm again, if csums_tfm did not work out */
 	crypto_free_hash(verify_tfm);
-	conn_request_state(first_peer_device(device)->connection, NS(conn, C_DISCONNECTING), CS_HARD);
+	conn_request_state(peer_device->connection, NS(conn, C_DISCONNECTING), CS_HARD);
 	return -EIO;
 }
 
@@ -3545,6 +3561,7 @@ static void warn_if_differ_considerably(struct drbd_device *device,
 
 static int receive_sizes(struct drbd_connection *connection, struct packet_info *pi)
 {
+	struct drbd_peer_device *peer_device;
 	struct drbd_device *device;
 	struct p_sizes *p = pi->data;
 	enum determine_dev_size dd = DS_UNCHANGED;
@@ -3552,9 +3569,10 @@ static int receive_sizes(struct drbd_connection *connection, struct packet_info
 	int ldsc = 0; /* local disk size changed */
 	enum dds_flags ddsf;
 
-	device = vnr_to_device(connection, pi->vnr);
-	if (!device)
+	peer_device = conn_peer_device(connection, pi->vnr);
+	if (!peer_device)
 		return config_unknown_volume(connection, pi);
+	device = peer_device->device;
 
 	p_size = be64_to_cpu(p->d_size);
 	p_usize = be64_to_cpu(p->u_size);
@@ -3585,7 +3603,7 @@ static int receive_sizes(struct drbd_connection *connection, struct packet_info
 		    device->state.disk >= D_OUTDATED &&
 		    device->state.conn < C_CONNECTED) {
 			drbd_err(device, "The peer's disk size is too small!\n");
-			conn_request_state(first_peer_device(device)->connection, NS(conn, C_DISCONNECTING), CS_HARD);
+			conn_request_state(peer_device->connection, NS(conn, C_DISCONNECTING), CS_HARD);
 			put_ldev(device);
 			return -EIO;
 		}
@@ -3666,14 +3684,16 @@ static int receive_sizes(struct drbd_connection *connection, struct packet_info
 
 static int receive_uuids(struct drbd_connection *connection, struct packet_info *pi)
 {
+	struct drbd_peer_device *peer_device;
 	struct drbd_device *device;
 	struct p_uuids *p = pi->data;
 	u64 *p_uuid;
 	int i, updated_uuids = 0;
 
-	device = vnr_to_device(connection, pi->vnr);
-	if (!device)
+	peer_device = conn_peer_device(connection, pi->vnr);
+	if (!peer_device)
 		return config_unknown_volume(connection, pi);
+	device = peer_device->device;
 
 	p_uuid = kmalloc(sizeof(u64)*UI_EXTENDED_SIZE, GFP_NOIO);
 	if (!p_uuid) {
@@ -3693,14 +3713,14 @@ static int receive_uuids(struct drbd_connection *connection, struct packet_info
 	    (device->ed_uuid & ~((u64)1)) != (p_uuid[UI_CURRENT] & ~((u64)1))) {
 		drbd_err(device, "Can only connect to data with current UUID=%016llX\n",
 		    (unsigned long long)device->ed_uuid);
-		conn_request_state(first_peer_device(device)->connection, NS(conn, C_DISCONNECTING), CS_HARD);
+		conn_request_state(peer_device->connection, NS(conn, C_DISCONNECTING), CS_HARD);
 		return -EIO;
 	}
 
 	if (get_ldev(device)) {
 		int skip_initial_sync =
 			device->state.conn == C_CONNECTED &&
-			first_peer_device(device)->connection->agreed_pro_version >= 90 &&
+			peer_device->connection->agreed_pro_version >= 90 &&
 			device->ldev->md.uuid[UI_CURRENT] == UUID_JUST_CREATED &&
 			(p_uuid[UI_FLAGS] & 8);
 		if (skip_initial_sync) {
@@ -3771,19 +3791,21 @@ static union drbd_state convert_state(union drbd_state ps)
 
 static int receive_req_state(struct drbd_connection *connection, struct packet_info *pi)
 {
+	struct drbd_peer_device *peer_device;
 	struct drbd_device *device;
 	struct p_req_state *p = pi->data;
 	union drbd_state mask, val;
 	enum drbd_state_rv rv;
 
-	device = vnr_to_device(connection, pi->vnr);
-	if (!device)
+	peer_device = conn_peer_device(connection, pi->vnr);
+	if (!peer_device)
 		return -EIO;
+	device = peer_device->device;
 
 	mask.i = be32_to_cpu(p->mask);
 	val.i = be32_to_cpu(p->val);
 
-	if (test_bit(RESOLVE_CONFLICTS, &first_peer_device(device)->connection->flags) &&
+	if (test_bit(RESOLVE_CONFLICTS, &peer_device->connection->flags) &&
 	    mutex_is_locked(device->state_mutex)) {
 		drbd_send_sr_reply(device, SS_CONCURRENT_ST_CHG);
 		return 0;
@@ -3826,6 +3848,7 @@ static int receive_req_conn_state(struct drbd_connection *connection, struct pac
 
 static int receive_state(struct drbd_connection *connection, struct packet_info *pi)
 {
+	struct drbd_peer_device *peer_device;
 	struct drbd_device *device;
 	struct p_state *p = pi->data;
 	union drbd_state os, ns, peer_state;
@@ -3833,9 +3856,10 @@ static int receive_state(struct drbd_connection *connection, struct packet_info
 	enum chg_state_flags cs_flags;
 	int rv;
 
-	device = vnr_to_device(connection, pi->vnr);
-	if (!device)
+	peer_device = conn_peer_device(connection, pi->vnr);
+	if (!peer_device)
 		return config_unknown_volume(connection, pi);
+	device = peer_device->device;
 
 	peer_state.i = be32_to_cpu(p->state);
 
@@ -3942,10 +3966,10 @@ static int receive_state(struct drbd_connection *connection, struct packet_info
 				peer_state.disk = D_DISKLESS;
 				real_peer_disk = D_DISKLESS;
 			} else {
-				if (test_and_clear_bit(CONN_DRY_RUN, &first_peer_device(device)->connection->flags))
+				if (test_and_clear_bit(CONN_DRY_RUN, &peer_device->connection->flags))
 					return -EIO;
 				D_ASSERT(device, os.conn == C_WF_REPORT_PARAMS);
-				conn_request_state(first_peer_device(device)->connection, NS(conn, C_DISCONNECTING), CS_HARD);
+				conn_request_state(peer_device->connection, NS(conn, C_DISCONNECTING), CS_HARD);
 				return -EIO;
 			}
 		}
@@ -3967,10 +3991,10 @@ static int receive_state(struct drbd_connection *connection, struct packet_info
 		   for temporal network outages! */
 		spin_unlock_irq(&device->resource->req_lock);
 		drbd_err(device, "Aborting Connect, can not thaw IO with an only Consistent peer\n");
-		tl_clear(first_peer_device(device)->connection);
+		tl_clear(peer_device->connection);
 		drbd_uuid_new_current(device);
 		clear_bit(NEW_CUR_UUID, &device->flags);
-		conn_request_state(first_peer_device(device)->connection, NS2(conn, C_PROTOCOL_ERROR, susp, 0), CS_HARD);
+		conn_request_state(peer_device->connection, NS2(conn, C_PROTOCOL_ERROR, susp, 0), CS_HARD);
 		return -EIO;
 	}
 	rv = _drbd_set_state(device, ns, cs_flags, NULL);
@@ -3978,7 +4002,7 @@ static int receive_state(struct drbd_connection *connection, struct packet_info
 	spin_unlock_irq(&device->resource->req_lock);
 
 	if (rv < SS_SUCCESS) {
-		conn_request_state(first_peer_device(device)->connection, NS(conn, C_DISCONNECTING), CS_HARD);
+		conn_request_state(peer_device->connection, NS(conn, C_DISCONNECTING), CS_HARD);
 		return -EIO;
 	}
 
@@ -4002,12 +4026,14 @@ static int receive_state(struct drbd_connection *connection, struct packet_info
 
 static int receive_sync_uuid(struct drbd_connection *connection, struct packet_info *pi)
 {
+	struct drbd_peer_device *peer_device;
 	struct drbd_device *device;
 	struct p_rs_uuid *p = pi->data;
 
-	device = vnr_to_device(connection, pi->vnr);
-	if (!device)
+	peer_device = conn_peer_device(connection, pi->vnr);
+	if (!peer_device)
 		return -EIO;
+	device = peer_device->device;
 
 	wait_event(device->misc_wait,
 		   device->state.conn == C_WF_SYNC_UUID ||
@@ -4224,13 +4250,15 @@ void INFO_bm_xfer_stats(struct drbd_device *device,
    returns 0 on failure, 1 if we successfully received it. */
 static int receive_bitmap(struct drbd_connection *connection, struct packet_info *pi)
 {
+	struct drbd_peer_device *peer_device;
 	struct drbd_device *device;
 	struct bm_xfer_ctx c;
 	int err;
 
-	device = vnr_to_device(connection, pi->vnr);
-	if (!device)
+	peer_device = conn_peer_device(connection, pi->vnr);
+	if (!peer_device)
 		return -EIO;
+	device = peer_device->device;
 
 	drbd_bm_lock(device, "receive bitmap", BM_LOCKED_SET_ALLOWED);
 	/* you are supposed to send additional out-of-sync information
@@ -4259,7 +4287,7 @@ static int receive_bitmap(struct drbd_connection *connection, struct packet_info
 				err = -EIO;
 				goto out;
 			}
-			err = drbd_recv_all(first_peer_device(device)->connection, p, pi->size);
+			err = drbd_recv_all(peer_device->connection, p, pi->size);
 			if (err)
 			       goto out;
 			err = decode_bitmap_c(device, p, &c, pi->size);
@@ -4277,7 +4305,7 @@ static int receive_bitmap(struct drbd_connection *connection, struct packet_info
 				goto out;
 			break;
 		}
-		err = drbd_recv_header(first_peer_device(device)->connection, pi);
+		err = drbd_recv_header(peer_device->connection, pi);
 		if (err)
 			goto out;
 	}
@@ -4327,12 +4355,14 @@ static int receive_UnplugRemote(struct drbd_connection *connection, struct packe
 
 static int receive_out_of_sync(struct drbd_connection *connection, struct packet_info *pi)
 {
+	struct drbd_peer_device *peer_device;
 	struct drbd_device *device;
 	struct p_block_desc *p = pi->data;
 
-	device = vnr_to_device(connection, pi->vnr);
-	if (!device)
+	peer_device = conn_peer_device(connection, pi->vnr);
+	if (!peer_device)
 		return -EIO;
+	device = peer_device->device;
 
 	switch (device->state.conn) {
 	case C_WF_SYNC_UUID:
@@ -4892,13 +4922,15 @@ static int got_conn_RqSReply(struct drbd_connection *connection, struct packet_i
 
 static int got_RqSReply(struct drbd_connection *connection, struct packet_info *pi)
 {
+	struct drbd_peer_device *peer_device;
 	struct drbd_device *device;
 	struct p_req_state_reply *p = pi->data;
 	int retcode = be32_to_cpu(p->retcode);
 
-	device = vnr_to_device(connection, pi->vnr);
-	if (!device)
+	peer_device = conn_peer_device(connection, pi->vnr);
+	if (!peer_device)
 		return -EIO;
+	device = peer_device->device;
 
 	if (test_bit(CONN_WD_ST_CHG_REQ, &connection->flags)) {
 		D_ASSERT(device, connection->agreed_pro_version < 100);
@@ -4935,16 +4967,18 @@ static int got_PingAck(struct drbd_connection *connection, struct packet_info *p
 
 static int got_IsInSync(struct drbd_connection *connection, struct packet_info *pi)
 {
+	struct drbd_peer_device *peer_device;
 	struct drbd_device *device;
 	struct p_block_ack *p = pi->data;
 	sector_t sector = be64_to_cpu(p->sector);
 	int blksize = be32_to_cpu(p->blksize);
 
-	device = vnr_to_device(connection, pi->vnr);
-	if (!device)
+	peer_device = conn_peer_device(connection, pi->vnr);
+	if (!peer_device)
 		return -EIO;
+	device = peer_device->device;
 
-	D_ASSERT(device, first_peer_device(device)->connection->agreed_pro_version >= 89);
+	D_ASSERT(device, peer_device->connection->agreed_pro_version >= 89);
 
 	update_peer_seq(device, be32_to_cpu(p->seq_num));
 
@@ -4985,15 +5019,17 @@ validate_req_change_req_state(struct drbd_device *device, u64 id, sector_t secto
 
 static int got_BlockAck(struct drbd_connection *connection, struct packet_info *pi)
 {
+	struct drbd_peer_device *peer_device;
 	struct drbd_device *device;
 	struct p_block_ack *p = pi->data;
 	sector_t sector = be64_to_cpu(p->sector);
 	int blksize = be32_to_cpu(p->blksize);
 	enum drbd_req_event what;
 
-	device = vnr_to_device(connection, pi->vnr);
-	if (!device)
+	peer_device = conn_peer_device(connection, pi->vnr);
+	if (!peer_device)
 		return -EIO;
+	device = peer_device->device;
 
 	update_peer_seq(device, be32_to_cpu(p->seq_num));
 
@@ -5029,15 +5065,17 @@ static int got_BlockAck(struct drbd_connection *connection, struct packet_info *
 
 static int got_NegAck(struct drbd_connection *connection, struct packet_info *pi)
 {
+	struct drbd_peer_device *peer_device;
 	struct drbd_device *device;
 	struct p_block_ack *p = pi->data;
 	sector_t sector = be64_to_cpu(p->sector);
 	int size = be32_to_cpu(p->blksize);
 	int err;
 
-	device = vnr_to_device(connection, pi->vnr);
-	if (!device)
+	peer_device = conn_peer_device(connection, pi->vnr);
+	if (!peer_device)
 		return -EIO;
+	device = peer_device->device;
 
 	update_peer_seq(device, be32_to_cpu(p->seq_num));
 
@@ -5063,13 +5101,15 @@ static int got_NegAck(struct drbd_connection *connection, struct packet_info *pi
 
 static int got_NegDReply(struct drbd_connection *connection, struct packet_info *pi)
 {
+	struct drbd_peer_device *peer_device;
 	struct drbd_device *device;
 	struct p_block_ack *p = pi->data;
 	sector_t sector = be64_to_cpu(p->sector);
 
-	device = vnr_to_device(connection, pi->vnr);
-	if (!device)
+	peer_device = conn_peer_device(connection, pi->vnr);
+	if (!peer_device)
 		return -EIO;
+	device = peer_device->device;
 
 	update_peer_seq(device, be32_to_cpu(p->seq_num));
 
@@ -5083,14 +5123,16 @@ static int got_NegDReply(struct drbd_connection *connection, struct packet_info
 
 static int got_NegRSDReply(struct drbd_connection *connection, struct packet_info *pi)
 {
+	struct drbd_peer_device *peer_device;
 	struct drbd_device *device;
 	sector_t sector;
 	int size;
 	struct p_block_ack *p = pi->data;
 
-	device = vnr_to_device(connection, pi->vnr);
-	if (!device)
+	peer_device = conn_peer_device(connection, pi->vnr);
+	if (!peer_device)
 		return -EIO;
+	device = peer_device->device;
 
 	sector = be64_to_cpu(p->sector);
 	size = be32_to_cpu(p->blksize);
@@ -5141,15 +5183,17 @@ static int got_BarrierAck(struct drbd_connection *connection, struct packet_info
 
 static int got_OVResult(struct drbd_connection *connection, struct packet_info *pi)
 {
+	struct drbd_peer_device *peer_device;
 	struct drbd_device *device;
 	struct p_block_ack *p = pi->data;
 	struct drbd_work *w;
 	sector_t sector;
 	int size;
 
-	device = vnr_to_device(connection, pi->vnr);
-	if (!device)
+	peer_device = conn_peer_device(connection, pi->vnr);
+	if (!peer_device)
 		return -EIO;
+	device = peer_device->device;
 
 	sector = be64_to_cpu(p->sector);
 	size = be32_to_cpu(p->blksize);
@@ -5178,7 +5222,7 @@ static int got_OVResult(struct drbd_connection *connection, struct packet_info *
 		if (w) {
 			w->cb = w_ov_finished;
 			w->device = device;
-			drbd_queue_work(&first_peer_device(device)->connection->sender_work, w);
+			drbd_queue_work(&peer_device->connection->sender_work, w);
 		} else {
 			drbd_err(device, "kmalloc(w) failed.");
 			ov_out_of_sync_print(device);
-- 
1.7.9.5

