Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932619Ab3LWWB2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 17:01:28 -0500
Received: from zimbra13.linbit.com ([212.69.166.240]:60667 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757813Ab3LWV67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 16:58:59 -0500
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 12/27] drbd: Pass a peer device to a number of fuctions
Date: Mon, 23 Dec 2013 22:50:41 +0100
Message-Id: <1387835456-29695-13-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387835456-29695-1-git-send-email-philipp.reisner@linbit.com>
References: <1387835456-29695-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

These functions actually operate on a peer device, or
need a peer device.

drbd_prepare_command(), drbd_send_command(), drbd_send_sync_param()
drbd_send_uuids(), drbd_gen_and_send_sync_uuid(), drbd_send_sizes()
drbd_send_state(), drbd_send_current_state(), and drbd_send_state_req()
drbd_send_sr_reply(), drbd_send_ack(), drbd_send_drequest(),
drbd_send_drequest_csum(), drbd_send_ov_request(), drbd_send_dblock()
drbd_send_block(), drbd_send_out_of_sync(), recv_dless_read()
drbd_drain_block(), receive_bitmap_plain(), recv_resync_read()
read_in_block(), read_for_csum(), drbd_alloc_pages(), drbd_alloc_peer_req()
need_peer_seq(), update_peer_seq(), wait_for_and_update_peer_seq()
drbd_sync_handshake(), drbd_asb_recover_{0,1,2}p(), drbd_connected()
drbd_disconnected(), decode_bitmap_c() and recv_bm_rle_bits()

Signed-off-by: Andreas Gruenbacher <agruen@linbit.com>
Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |   48 +++----
 drivers/block/drbd/drbd_main.c     |  260 ++++++++++++++++++------------------
 drivers/block/drbd/drbd_nl.c       |   27 ++--
 drivers/block/drbd/drbd_receiver.c |  253 +++++++++++++++++++----------------
 drivers/block/drbd/drbd_state.c    |   34 ++---
 drivers/block/drbd/drbd_worker.c   |   45 ++++---
 6 files changed, 353 insertions(+), 314 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 461cf8d..b89e7ed 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -882,36 +882,36 @@ extern int drbd_send_all(struct drbd_connection *, struct socket *, void *, size
 
 extern int __drbd_send_protocol(struct drbd_connection *connection, enum drbd_packet cmd);
 extern int drbd_send_protocol(struct drbd_connection *connection);
-extern int drbd_send_uuids(struct drbd_device *device);
-extern int drbd_send_uuids_skip_initial_sync(struct drbd_device *device);
-extern void drbd_gen_and_send_sync_uuid(struct drbd_device *device);
-extern int drbd_send_sizes(struct drbd_device *device, int trigger_reply, enum dds_flags flags);
-extern int drbd_send_state(struct drbd_device *device, union drbd_state s);
-extern int drbd_send_current_state(struct drbd_device *device);
-extern int drbd_send_sync_param(struct drbd_device *device);
+extern int drbd_send_uuids(struct drbd_peer_device *);
+extern int drbd_send_uuids_skip_initial_sync(struct drbd_peer_device *);
+extern void drbd_gen_and_send_sync_uuid(struct drbd_peer_device *);
+extern int drbd_send_sizes(struct drbd_peer_device *, int trigger_reply, enum dds_flags flags);
+extern int drbd_send_state(struct drbd_peer_device *, union drbd_state s);
+extern int drbd_send_current_state(struct drbd_peer_device *);
+extern int drbd_send_sync_param(struct drbd_peer_device *);
 extern void drbd_send_b_ack(struct drbd_connection *connection, u32 barrier_nr,
 			    u32 set_size);
-extern int drbd_send_ack(struct drbd_device *, enum drbd_packet,
+extern int drbd_send_ack(struct drbd_peer_device *, enum drbd_packet,
 			 struct drbd_peer_request *);
-extern void drbd_send_ack_rp(struct drbd_device *device, enum drbd_packet cmd,
+extern void drbd_send_ack_rp(struct drbd_peer_device *, enum drbd_packet,
 			     struct p_block_req *rp);
-extern void drbd_send_ack_dp(struct drbd_device *device, enum drbd_packet cmd,
+extern void drbd_send_ack_dp(struct drbd_peer_device *, enum drbd_packet,
 			     struct p_data *dp, int data_size);
-extern int drbd_send_ack_ex(struct drbd_device *device, enum drbd_packet cmd,
+extern int drbd_send_ack_ex(struct drbd_peer_device *, enum drbd_packet,
 			    sector_t sector, int blksize, u64 block_id);
-extern int drbd_send_out_of_sync(struct drbd_device *, struct drbd_request *);
-extern int drbd_send_block(struct drbd_device *, enum drbd_packet,
+extern int drbd_send_out_of_sync(struct drbd_peer_device *, struct drbd_request *);
+extern int drbd_send_block(struct drbd_peer_device *, enum drbd_packet,
 			   struct drbd_peer_request *);
-extern int drbd_send_dblock(struct drbd_device *device, struct drbd_request *req);
-extern int drbd_send_drequest(struct drbd_device *device, int cmd,
+extern int drbd_send_dblock(struct drbd_peer_device *, struct drbd_request *req);
+extern int drbd_send_drequest(struct drbd_peer_device *, int cmd,
 			      sector_t sector, int size, u64 block_id);
-extern int drbd_send_drequest_csum(struct drbd_device *device, sector_t sector,
+extern int drbd_send_drequest_csum(struct drbd_peer_device *, sector_t sector,
 				   int size, void *digest, int digest_size,
 				   enum drbd_packet cmd);
-extern int drbd_send_ov_request(struct drbd_device *device, sector_t sector, int size);
+extern int drbd_send_ov_request(struct drbd_peer_device *, sector_t sector, int size);
 
 extern int drbd_send_bitmap(struct drbd_device *device);
-extern void drbd_send_sr_reply(struct drbd_device *device, enum drbd_state_rv retcode);
+extern void drbd_send_sr_reply(struct drbd_peer_device *, enum drbd_state_rv retcode);
 extern void conn_send_sr_reply(struct drbd_connection *connection, enum drbd_state_rv retcode);
 extern void drbd_free_bc(struct drbd_backing_dev *ldev);
 extern void drbd_device_cleanup(struct drbd_device *device);
@@ -1338,18 +1338,18 @@ extern int drbd_submit_peer_request(struct drbd_device *,
 				    struct drbd_peer_request *, const unsigned,
 				    const int);
 extern int drbd_free_peer_reqs(struct drbd_device *, struct list_head *);
-extern struct drbd_peer_request *drbd_alloc_peer_req(struct drbd_device *, u64,
+extern struct drbd_peer_request *drbd_alloc_peer_req(struct drbd_peer_device *, u64,
 						     sector_t, unsigned int,
 						     gfp_t) __must_hold(local);
 extern void __drbd_free_peer_req(struct drbd_device *, struct drbd_peer_request *,
 				 int);
 #define drbd_free_peer_req(m,e) __drbd_free_peer_req(m, e, 0)
 #define drbd_free_net_peer_req(m,e) __drbd_free_peer_req(m, e, 1)
-extern struct page *drbd_alloc_pages(struct drbd_device *, unsigned int, bool);
+extern struct page *drbd_alloc_pages(struct drbd_peer_device *, unsigned int, bool);
 extern void drbd_set_recv_tcq(struct drbd_device *device, int tcq_enabled);
 extern void _drbd_clear_done_ee(struct drbd_device *device, struct list_head *to_be_freed);
 extern void conn_flush_workqueue(struct drbd_connection *connection);
-extern int drbd_connected(struct drbd_device *device);
+extern int drbd_connected(struct drbd_peer_device *);
 static inline void drbd_flush_workqueue(struct drbd_device *device)
 {
 	conn_flush_workqueue(first_peer_device(device)->connection);
@@ -1721,17 +1721,17 @@ static inline void request_ping(struct drbd_connection *connection)
 }
 
 extern void *conn_prepare_command(struct drbd_connection *, struct drbd_socket *);
-extern void *drbd_prepare_command(struct drbd_device *, struct drbd_socket *);
+extern void *drbd_prepare_command(struct drbd_peer_device *, struct drbd_socket *);
 extern int conn_send_command(struct drbd_connection *, struct drbd_socket *,
 			     enum drbd_packet, unsigned int, void *,
 			     unsigned int);
-extern int drbd_send_command(struct drbd_device *, struct drbd_socket *,
+extern int drbd_send_command(struct drbd_peer_device *, struct drbd_socket *,
 			     enum drbd_packet, unsigned int, void *,
 			     unsigned int);
 
 extern int drbd_send_ping(struct drbd_connection *connection);
 extern int drbd_send_ping_ack(struct drbd_connection *connection);
-extern int drbd_send_state_req(struct drbd_device *, union drbd_state, union drbd_state);
+extern int drbd_send_state_req(struct drbd_peer_device *, union drbd_state, union drbd_state);
 extern int conn_send_state_req(struct drbd_connection *, union drbd_state, union drbd_state);
 
 static inline void drbd_thread_stop(struct drbd_thread *thi)
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 7df2de8..f18a5d5 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -642,9 +642,9 @@ void *conn_prepare_command(struct drbd_connection *connection, struct drbd_socke
 	return p;
 }
 
-void *drbd_prepare_command(struct drbd_device *device, struct drbd_socket *sock)
+void *drbd_prepare_command(struct drbd_peer_device *peer_device, struct drbd_socket *sock)
 {
-	return conn_prepare_command(first_peer_device(device)->connection, sock);
+	return conn_prepare_command(peer_device->connection, sock);
 }
 
 static int __send_command(struct drbd_connection *connection, int vnr,
@@ -691,14 +691,14 @@ int conn_send_command(struct drbd_connection *connection, struct drbd_socket *so
 	return err;
 }
 
-int drbd_send_command(struct drbd_device *device, struct drbd_socket *sock,
+int drbd_send_command(struct drbd_peer_device *peer_device, struct drbd_socket *sock,
 		      enum drbd_packet cmd, unsigned int header_size,
 		      void *data, unsigned int size)
 {
 	int err;
 
-	err = __send_command(first_peer_device(device)->connection, device->vnr, sock, cmd, header_size,
-			     data, size);
+	err = __send_command(peer_device->connection, peer_device->device->vnr,
+			     sock, cmd, header_size, data, size);
 	mutex_unlock(&sock->mutex);
 	return err;
 }
@@ -723,23 +723,23 @@ int drbd_send_ping_ack(struct drbd_connection *connection)
 	return conn_send_command(connection, sock, P_PING_ACK, 0, NULL, 0);
 }
 
-int drbd_send_sync_param(struct drbd_device *device)
+int drbd_send_sync_param(struct drbd_peer_device *peer_device)
 {
 	struct drbd_socket *sock;
 	struct p_rs_param_95 *p;
 	int size;
-	const int apv = first_peer_device(device)->connection->agreed_pro_version;
+	const int apv = peer_device->connection->agreed_pro_version;
 	enum drbd_packet cmd;
 	struct net_conf *nc;
 	struct disk_conf *dc;
 
-	sock = &first_peer_device(device)->connection->data;
-	p = drbd_prepare_command(device, sock);
+	sock = &peer_device->connection->data;
+	p = drbd_prepare_command(peer_device, sock);
 	if (!p)
 		return -EIO;
 
 	rcu_read_lock();
-	nc = rcu_dereference(first_peer_device(device)->connection->net_conf);
+	nc = rcu_dereference(peer_device->connection->net_conf);
 
 	size = apv <= 87 ? sizeof(struct p_rs_param)
 		: apv == 88 ? sizeof(struct p_rs_param)
@@ -752,14 +752,14 @@ int drbd_send_sync_param(struct drbd_device *device)
 	/* initialize verify_alg and csums_alg */
 	memset(p->verify_alg, 0, 2 * SHARED_SECRET_MAX);
 
-	if (get_ldev(device)) {
-		dc = rcu_dereference(device->ldev->disk_conf);
+	if (get_ldev(peer_device->device)) {
+		dc = rcu_dereference(peer_device->device->ldev->disk_conf);
 		p->resync_rate = cpu_to_be32(dc->resync_rate);
 		p->c_plan_ahead = cpu_to_be32(dc->c_plan_ahead);
 		p->c_delay_target = cpu_to_be32(dc->c_delay_target);
 		p->c_fill_target = cpu_to_be32(dc->c_fill_target);
 		p->c_max_rate = cpu_to_be32(dc->c_max_rate);
-		put_ldev(device);
+		put_ldev(peer_device->device);
 	} else {
 		p->resync_rate = cpu_to_be32(DRBD_RESYNC_RATE_DEF);
 		p->c_plan_ahead = cpu_to_be32(DRBD_C_PLAN_AHEAD_DEF);
@@ -774,7 +774,7 @@ int drbd_send_sync_param(struct drbd_device *device)
 		strcpy(p->csums_alg, nc->csums_alg);
 	rcu_read_unlock();
 
-	return drbd_send_command(device, sock, cmd, size, NULL, 0);
+	return drbd_send_command(peer_device, sock, cmd, size, NULL, 0);
 }
 
 int __drbd_send_protocol(struct drbd_connection *connection, enum drbd_packet cmd)
@@ -833,8 +833,9 @@ int drbd_send_protocol(struct drbd_connection *connection)
 	return err;
 }
 
-int _drbd_send_uuids(struct drbd_device *device, u64 uuid_flags)
+static int _drbd_send_uuids(struct drbd_peer_device *peer_device, u64 uuid_flags)
 {
+	struct drbd_device *device = peer_device->device;
 	struct drbd_socket *sock;
 	struct p_uuids *p;
 	int i;
@@ -842,8 +843,8 @@ int _drbd_send_uuids(struct drbd_device *device, u64 uuid_flags)
 	if (!get_ldev_if_state(device, D_NEGOTIATING))
 		return 0;
 
-	sock = &first_peer_device(device)->connection->data;
-	p = drbd_prepare_command(device, sock);
+	sock = &peer_device->connection->data;
+	p = drbd_prepare_command(peer_device, sock);
 	if (!p) {
 		put_ldev(device);
 		return -EIO;
@@ -856,24 +857,24 @@ int _drbd_send_uuids(struct drbd_device *device, u64 uuid_flags)
 	device->comm_bm_set = drbd_bm_total_weight(device);
 	p->uuid[UI_SIZE] = cpu_to_be64(device->comm_bm_set);
 	rcu_read_lock();
-	uuid_flags |= rcu_dereference(first_peer_device(device)->connection->net_conf)->discard_my_data ? 1 : 0;
+	uuid_flags |= rcu_dereference(peer_device->connection->net_conf)->discard_my_data ? 1 : 0;
 	rcu_read_unlock();
 	uuid_flags |= test_bit(CRASHED_PRIMARY, &device->flags) ? 2 : 0;
 	uuid_flags |= device->new_state_tmp.disk == D_INCONSISTENT ? 4 : 0;
 	p->uuid[UI_FLAGS] = cpu_to_be64(uuid_flags);
 
 	put_ldev(device);
-	return drbd_send_command(device, sock, P_UUIDS, sizeof(*p), NULL, 0);
+	return drbd_send_command(peer_device, sock, P_UUIDS, sizeof(*p), NULL, 0);
 }
 
-int drbd_send_uuids(struct drbd_device *device)
+int drbd_send_uuids(struct drbd_peer_device *peer_device)
 {
-	return _drbd_send_uuids(device, 0);
+	return _drbd_send_uuids(peer_device, 0);
 }
 
-int drbd_send_uuids_skip_initial_sync(struct drbd_device *device)
+int drbd_send_uuids_skip_initial_sync(struct drbd_peer_device *peer_device)
 {
-	return _drbd_send_uuids(device, 8);
+	return _drbd_send_uuids(peer_device, 8);
 }
 
 void drbd_print_uuids(struct drbd_device *device, const char *text)
@@ -894,8 +895,9 @@ void drbd_print_uuids(struct drbd_device *device, const char *text)
 	}
 }
 
-void drbd_gen_and_send_sync_uuid(struct drbd_device *device)
+void drbd_gen_and_send_sync_uuid(struct drbd_peer_device *peer_device)
 {
+	struct drbd_device *device = peer_device->device;
 	struct drbd_socket *sock;
 	struct p_rs_uuid *p;
 	u64 uuid;
@@ -911,16 +913,17 @@ void drbd_gen_and_send_sync_uuid(struct drbd_device *device)
 	drbd_print_uuids(device, "updated sync UUID");
 	drbd_md_sync(device);
 
-	sock = &first_peer_device(device)->connection->data;
-	p = drbd_prepare_command(device, sock);
+	sock = &peer_device->connection->data;
+	p = drbd_prepare_command(peer_device, sock);
 	if (p) {
 		p->uuid = cpu_to_be64(uuid);
-		drbd_send_command(device, sock, P_SYNC_UUID, sizeof(*p), NULL, 0);
+		drbd_send_command(peer_device, sock, P_SYNC_UUID, sizeof(*p), NULL, 0);
 	}
 }
 
-int drbd_send_sizes(struct drbd_device *device, int trigger_reply, enum dds_flags flags)
+int drbd_send_sizes(struct drbd_peer_device *peer_device, int trigger_reply, enum dds_flags flags)
 {
+	struct drbd_device *device = peer_device->device;
 	struct drbd_socket *sock;
 	struct p_sizes *p;
 	sector_t d_size, u_size;
@@ -944,14 +947,14 @@ int drbd_send_sizes(struct drbd_device *device, int trigger_reply, enum dds_flag
 		max_bio_size = DRBD_MAX_BIO_SIZE; /* ... multiple BIOs per peer_request */
 	}
 
-	sock = &first_peer_device(device)->connection->data;
-	p = drbd_prepare_command(device, sock);
+	sock = &peer_device->connection->data;
+	p = drbd_prepare_command(peer_device, sock);
 	if (!p)
 		return -EIO;
 
-	if (first_peer_device(device)->connection->agreed_pro_version <= 94)
+	if (peer_device->connection->agreed_pro_version <= 94)
 		max_bio_size = min(max_bio_size, DRBD_MAX_SIZE_H80_PACKET);
-	else if (first_peer_device(device)->connection->agreed_pro_version < 100)
+	else if (peer_device->connection->agreed_pro_version < 100)
 		max_bio_size = min(max_bio_size, DRBD_MAX_BIO_SIZE_P95);
 
 	p->d_size = cpu_to_be64(d_size);
@@ -960,29 +963,29 @@ int drbd_send_sizes(struct drbd_device *device, int trigger_reply, enum dds_flag
 	p->max_bio_size = cpu_to_be32(max_bio_size);
 	p->queue_order_type = cpu_to_be16(q_order_type);
 	p->dds_flags = cpu_to_be16(flags);
-	return drbd_send_command(device, sock, P_SIZES, sizeof(*p), NULL, 0);
+	return drbd_send_command(peer_device, sock, P_SIZES, sizeof(*p), NULL, 0);
 }
 
 /**
  * drbd_send_current_state() - Sends the drbd state to the peer
- * @device:	DRBD device.
+ * @peer_device:	DRBD peer device.
  */
-int drbd_send_current_state(struct drbd_device *device)
+int drbd_send_current_state(struct drbd_peer_device *peer_device)
 {
 	struct drbd_socket *sock;
 	struct p_state *p;
 
-	sock = &first_peer_device(device)->connection->data;
-	p = drbd_prepare_command(device, sock);
+	sock = &peer_device->connection->data;
+	p = drbd_prepare_command(peer_device, sock);
 	if (!p)
 		return -EIO;
-	p->state = cpu_to_be32(device->state.i); /* Within the send mutex */
-	return drbd_send_command(device, sock, P_STATE, sizeof(*p), NULL, 0);
+	p->state = cpu_to_be32(peer_device->device->state.i); /* Within the send mutex */
+	return drbd_send_command(peer_device, sock, P_STATE, sizeof(*p), NULL, 0);
 }
 
 /**
  * drbd_send_state() - After a state change, sends the new state to the peer
- * @device:      DRBD device.
+ * @peer_device:      DRBD peer device.
  * @state:     the state to send, not necessarily the current state.
  *
  * Each state change queues an "after_state_ch" work, which will eventually
@@ -990,31 +993,31 @@ int drbd_send_current_state(struct drbd_device *device)
  * between queuing and processing of the after_state_ch work, we still
  * want to send each intermediary state in the order it occurred.
  */
-int drbd_send_state(struct drbd_device *device, union drbd_state state)
+int drbd_send_state(struct drbd_peer_device *peer_device, union drbd_state state)
 {
 	struct drbd_socket *sock;
 	struct p_state *p;
 
-	sock = &first_peer_device(device)->connection->data;
-	p = drbd_prepare_command(device, sock);
+	sock = &peer_device->connection->data;
+	p = drbd_prepare_command(peer_device, sock);
 	if (!p)
 		return -EIO;
 	p->state = cpu_to_be32(state.i); /* Within the send mutex */
-	return drbd_send_command(device, sock, P_STATE, sizeof(*p), NULL, 0);
+	return drbd_send_command(peer_device, sock, P_STATE, sizeof(*p), NULL, 0);
 }
 
-int drbd_send_state_req(struct drbd_device *device, union drbd_state mask, union drbd_state val)
+int drbd_send_state_req(struct drbd_peer_device *peer_device, union drbd_state mask, union drbd_state val)
 {
 	struct drbd_socket *sock;
 	struct p_req_state *p;
 
-	sock = &first_peer_device(device)->connection->data;
-	p = drbd_prepare_command(device, sock);
+	sock = &peer_device->connection->data;
+	p = drbd_prepare_command(peer_device, sock);
 	if (!p)
 		return -EIO;
 	p->mask = cpu_to_be32(mask.i);
 	p->val = cpu_to_be32(val.i);
-	return drbd_send_command(device, sock, P_STATE_CHG_REQ, sizeof(*p), NULL, 0);
+	return drbd_send_command(peer_device, sock, P_STATE_CHG_REQ, sizeof(*p), NULL, 0);
 }
 
 int conn_send_state_req(struct drbd_connection *connection, union drbd_state mask, union drbd_state val)
@@ -1033,16 +1036,16 @@ int conn_send_state_req(struct drbd_connection *connection, union drbd_state mas
 	return conn_send_command(connection, sock, cmd, sizeof(*p), NULL, 0);
 }
 
-void drbd_send_sr_reply(struct drbd_device *device, enum drbd_state_rv retcode)
+void drbd_send_sr_reply(struct drbd_peer_device *peer_device, enum drbd_state_rv retcode)
 {
 	struct drbd_socket *sock;
 	struct p_req_state_reply *p;
 
-	sock = &first_peer_device(device)->connection->meta;
-	p = drbd_prepare_command(device, sock);
+	sock = &peer_device->connection->meta;
+	p = drbd_prepare_command(peer_device, sock);
 	if (p) {
 		p->retcode = cpu_to_be32(retcode);
-		drbd_send_command(device, sock, P_STATE_CHG_REPLY, sizeof(*p), NULL, 0);
+		drbd_send_command(peer_device, sock, P_STATE_CHG_REPLY, sizeof(*p), NULL, 0);
 	}
 }
 
@@ -1311,42 +1314,42 @@ void drbd_send_b_ack(struct drbd_connection *connection, u32 barrier_nr, u32 set
  * @blksize:	size in byte, needs to be in big endian byte order
  * @block_id:	Id, big endian byte order
  */
-static int _drbd_send_ack(struct drbd_device *device, enum drbd_packet cmd,
+static int _drbd_send_ack(struct drbd_peer_device *peer_device, enum drbd_packet cmd,
 			  u64 sector, u32 blksize, u64 block_id)
 {
 	struct drbd_socket *sock;
 	struct p_block_ack *p;
 
-	if (device->state.conn < C_CONNECTED)
+	if (peer_device->device->state.conn < C_CONNECTED)
 		return -EIO;
 
-	sock = &first_peer_device(device)->connection->meta;
-	p = drbd_prepare_command(device, sock);
+	sock = &peer_device->connection->meta;
+	p = drbd_prepare_command(peer_device, sock);
 	if (!p)
 		return -EIO;
 	p->sector = sector;
 	p->block_id = block_id;
 	p->blksize = blksize;
-	p->seq_num = cpu_to_be32(atomic_inc_return(&device->packet_seq));
-	return drbd_send_command(device, sock, cmd, sizeof(*p), NULL, 0);
+	p->seq_num = cpu_to_be32(atomic_inc_return(&peer_device->device->packet_seq));
+	return drbd_send_command(peer_device, sock, cmd, sizeof(*p), NULL, 0);
 }
 
 /* dp->sector and dp->block_id already/still in network byte order,
  * data_size is payload size according to dp->head,
  * and may need to be corrected for digest size. */
-void drbd_send_ack_dp(struct drbd_device *device, enum drbd_packet cmd,
+void drbd_send_ack_dp(struct drbd_peer_device *peer_device, enum drbd_packet cmd,
 		      struct p_data *dp, int data_size)
 {
-	if (first_peer_device(device)->connection->peer_integrity_tfm)
-		data_size -= crypto_hash_digestsize(first_peer_device(device)->connection->peer_integrity_tfm);
-	_drbd_send_ack(device, cmd, dp->sector, cpu_to_be32(data_size),
+	if (peer_device->connection->peer_integrity_tfm)
+		data_size -= crypto_hash_digestsize(peer_device->connection->peer_integrity_tfm);
+	_drbd_send_ack(peer_device, cmd, dp->sector, cpu_to_be32(data_size),
 		       dp->block_id);
 }
 
-void drbd_send_ack_rp(struct drbd_device *device, enum drbd_packet cmd,
+void drbd_send_ack_rp(struct drbd_peer_device *peer_device, enum drbd_packet cmd,
 		      struct p_block_req *rp)
 {
-	_drbd_send_ack(device, cmd, rp->sector, rp->blksize, rp->block_id);
+	_drbd_send_ack(peer_device, cmd, rp->sector, rp->blksize, rp->block_id);
 }
 
 /**
@@ -1355,10 +1358,10 @@ void drbd_send_ack_rp(struct drbd_device *device, enum drbd_packet cmd,
  * @cmd:	packet command code
  * @peer_req:	peer request
  */
-int drbd_send_ack(struct drbd_device *device, enum drbd_packet cmd,
+int drbd_send_ack(struct drbd_peer_device *peer_device, enum drbd_packet cmd,
 		  struct drbd_peer_request *peer_req)
 {
-	return _drbd_send_ack(device, cmd,
+	return _drbd_send_ack(peer_device, cmd,
 			      cpu_to_be64(peer_req->i.sector),
 			      cpu_to_be32(peer_req->i.size),
 			      peer_req->block_id);
@@ -1366,32 +1369,32 @@ int drbd_send_ack(struct drbd_device *device, enum drbd_packet cmd,
 
 /* This function misuses the block_id field to signal if the blocks
  * are is sync or not. */
-int drbd_send_ack_ex(struct drbd_device *device, enum drbd_packet cmd,
+int drbd_send_ack_ex(struct drbd_peer_device *peer_device, enum drbd_packet cmd,
 		     sector_t sector, int blksize, u64 block_id)
 {
-	return _drbd_send_ack(device, cmd,
+	return _drbd_send_ack(peer_device, cmd,
 			      cpu_to_be64(sector),
 			      cpu_to_be32(blksize),
 			      cpu_to_be64(block_id));
 }
 
-int drbd_send_drequest(struct drbd_device *device, int cmd,
+int drbd_send_drequest(struct drbd_peer_device *peer_device, int cmd,
 		       sector_t sector, int size, u64 block_id)
 {
 	struct drbd_socket *sock;
 	struct p_block_req *p;
 
-	sock = &first_peer_device(device)->connection->data;
-	p = drbd_prepare_command(device, sock);
+	sock = &peer_device->connection->data;
+	p = drbd_prepare_command(peer_device, sock);
 	if (!p)
 		return -EIO;
 	p->sector = cpu_to_be64(sector);
 	p->block_id = block_id;
 	p->blksize = cpu_to_be32(size);
-	return drbd_send_command(device, sock, cmd, sizeof(*p), NULL, 0);
+	return drbd_send_command(peer_device, sock, cmd, sizeof(*p), NULL, 0);
 }
 
-int drbd_send_drequest_csum(struct drbd_device *device, sector_t sector, int size,
+int drbd_send_drequest_csum(struct drbd_peer_device *peer_device, sector_t sector, int size,
 			    void *digest, int digest_size, enum drbd_packet cmd)
 {
 	struct drbd_socket *sock;
@@ -1399,30 +1402,29 @@ int drbd_send_drequest_csum(struct drbd_device *device, sector_t sector, int siz
 
 	/* FIXME: Put the digest into the preallocated socket buffer.  */
 
-	sock = &first_peer_device(device)->connection->data;
-	p = drbd_prepare_command(device, sock);
+	sock = &peer_device->connection->data;
+	p = drbd_prepare_command(peer_device, sock);
 	if (!p)
 		return -EIO;
 	p->sector = cpu_to_be64(sector);
 	p->block_id = ID_SYNCER /* unused */;
 	p->blksize = cpu_to_be32(size);
-	return drbd_send_command(device, sock, cmd, sizeof(*p),
-				 digest, digest_size);
+	return drbd_send_command(peer_device, sock, cmd, sizeof(*p), digest, digest_size);
 }
 
-int drbd_send_ov_request(struct drbd_device *device, sector_t sector, int size)
+int drbd_send_ov_request(struct drbd_peer_device *peer_device, sector_t sector, int size)
 {
 	struct drbd_socket *sock;
 	struct p_block_req *p;
 
-	sock = &first_peer_device(device)->connection->data;
-	p = drbd_prepare_command(device, sock);
+	sock = &peer_device->connection->data;
+	p = drbd_prepare_command(peer_device, sock);
 	if (!p)
 		return -EIO;
 	p->sector = cpu_to_be64(sector);
 	p->block_id = ID_SYNCER /* unused */;
 	p->blksize = cpu_to_be32(size);
-	return drbd_send_command(device, sock, P_OV_REQUEST, sizeof(*p), NULL, 0);
+	return drbd_send_command(peer_device, sock, P_OV_REQUEST, sizeof(*p), NULL, 0);
 }
 
 /* called on sndtimeo
@@ -1480,26 +1482,26 @@ static void drbd_update_congested(struct drbd_connection *connection)
  * As a workaround, we disable sendpage on pages
  * with page_count == 0 or PageSlab.
  */
-static int _drbd_no_send_page(struct drbd_device *device, struct page *page,
+static int _drbd_no_send_page(struct drbd_peer_device *peer_device, struct page *page,
 			      int offset, size_t size, unsigned msg_flags)
 {
 	struct socket *socket;
 	void *addr;
 	int err;
 
-	socket = first_peer_device(device)->connection->data.socket;
+	socket = peer_device->connection->data.socket;
 	addr = kmap(page) + offset;
-	err = drbd_send_all(first_peer_device(device)->connection, socket, addr, size, msg_flags);
+	err = drbd_send_all(peer_device->connection, socket, addr, size, msg_flags);
 	kunmap(page);
 	if (!err)
-		device->send_cnt += size >> 9;
+		peer_device->device->send_cnt += size >> 9;
 	return err;
 }
 
-static int _drbd_send_page(struct drbd_device *device, struct page *page,
+static int _drbd_send_page(struct drbd_peer_device *peer_device, struct page *page,
 		    int offset, size_t size, unsigned msg_flags)
 {
-	struct socket *socket = first_peer_device(device)->connection->data.socket;
+	struct socket *socket = peer_device->connection->data.socket;
 	mm_segment_t oldfs = get_fs();
 	int len = size;
 	int err = -EIO;
@@ -1511,10 +1513,10 @@ static int _drbd_send_page(struct drbd_device *device, struct page *page,
 	 * __page_cache_release a page that would actually still be referenced
 	 * by someone, leading to some obscure delayed Oops somewhere else. */
 	if (disable_sendpage || (page_count(page) < 1) || PageSlab(page))
-		return _drbd_no_send_page(device, page, offset, size, msg_flags);
+		return _drbd_no_send_page(peer_device, page, offset, size, msg_flags);
 
 	msg_flags |= MSG_NOSIGNAL;
-	drbd_update_congested(first_peer_device(device)->connection);
+	drbd_update_congested(peer_device->connection);
 	set_fs(KERNEL_DS);
 	do {
 		int sent;
@@ -1522,11 +1524,11 @@ static int _drbd_send_page(struct drbd_device *device, struct page *page,
 		sent = socket->ops->sendpage(socket, page, offset, len, msg_flags);
 		if (sent <= 0) {
 			if (sent == -EAGAIN) {
-				if (we_should_drop_the_connection(first_peer_device(device)->connection, socket))
+				if (we_should_drop_the_connection(peer_device->connection, socket))
 					break;
 				continue;
 			}
-			drbd_warn(device, "%s: size=%d len=%d sent=%d\n",
+			drbd_warn(peer_device->device, "%s: size=%d len=%d sent=%d\n",
 			     __func__, (int)size, len, sent);
 			if (sent < 0)
 				err = sent;
@@ -1536,16 +1538,16 @@ static int _drbd_send_page(struct drbd_device *device, struct page *page,
 		offset += sent;
 	} while (len > 0 /* THINK && device->cstate >= C_CONNECTED*/);
 	set_fs(oldfs);
-	clear_bit(NET_CONGESTED, &first_peer_device(device)->connection->flags);
+	clear_bit(NET_CONGESTED, &peer_device->connection->flags);
 
 	if (len == 0) {
 		err = 0;
-		device->send_cnt += size >> 9;
+		peer_device->device->send_cnt += size >> 9;
 	}
 	return err;
 }
 
-static int _drbd_send_bio(struct drbd_device *device, struct bio *bio)
+static int _drbd_send_bio(struct drbd_peer_device *peer_device, struct bio *bio)
 {
 	struct bio_vec bvec;
 	struct bvec_iter iter;
@@ -1554,7 +1556,7 @@ static int _drbd_send_bio(struct drbd_device *device, struct bio *bio)
 	bio_for_each_segment(bvec, bio, iter) {
 		int err;
 
-		err = _drbd_no_send_page(device, bvec.bv_page,
+		err = _drbd_no_send_page(peer_device, bvec.bv_page,
 					 bvec.bv_offset, bvec.bv_len,
 					 bio_iter_last(bvec, iter)
 					 ? 0 : MSG_MORE);
@@ -1564,7 +1566,7 @@ static int _drbd_send_bio(struct drbd_device *device, struct bio *bio)
 	return 0;
 }
 
-static int _drbd_send_zc_bio(struct drbd_device *device, struct bio *bio)
+static int _drbd_send_zc_bio(struct drbd_peer_device *peer_device, struct bio *bio)
 {
 	struct bio_vec bvec;
 	struct bvec_iter iter;
@@ -1573,7 +1575,7 @@ static int _drbd_send_zc_bio(struct drbd_device *device, struct bio *bio)
 	bio_for_each_segment(bvec, bio, iter) {
 		int err;
 
-		err = _drbd_send_page(device, bvec.bv_page,
+		err = _drbd_send_page(peer_device, bvec.bv_page,
 				      bvec.bv_offset, bvec.bv_len,
 				      bio_iter_last(bvec, iter) ? 0 : MSG_MORE);
 		if (err)
@@ -1582,7 +1584,7 @@ static int _drbd_send_zc_bio(struct drbd_device *device, struct bio *bio)
 	return 0;
 }
 
-static int _drbd_send_zc_ee(struct drbd_device *device,
+static int _drbd_send_zc_ee(struct drbd_peer_device *peer_device,
 			    struct drbd_peer_request *peer_req)
 {
 	struct page *page = peer_req->pages;
@@ -1593,7 +1595,7 @@ static int _drbd_send_zc_ee(struct drbd_device *device,
 	page_chain_for_each(page) {
 		unsigned l = min_t(unsigned, len, PAGE_SIZE);
 
-		err = _drbd_send_page(device, page, 0, l,
+		err = _drbd_send_page(peer_device, page, 0, l,
 				      page_chain_next(page) ? MSG_MORE : 0);
 		if (err)
 			return err;
@@ -1602,9 +1604,9 @@ static int _drbd_send_zc_ee(struct drbd_device *device,
 	return 0;
 }
 
-static u32 bio_flags_to_wire(struct drbd_device *device, unsigned long bi_rw)
+static u32 bio_flags_to_wire(struct drbd_connection *connection, unsigned long bi_rw)
 {
-	if (first_peer_device(device)->connection->agreed_pro_version >= 95)
+	if (connection->agreed_pro_version >= 95)
 		return  (bi_rw & REQ_SYNC ? DP_RW_SYNC : 0) |
 			(bi_rw & REQ_FUA ? DP_FUA : 0) |
 			(bi_rw & REQ_FLUSH ? DP_FLUSH : 0) |
@@ -1616,29 +1618,30 @@ static u32 bio_flags_to_wire(struct drbd_device *device, unsigned long bi_rw)
 /* Used to send write requests
  * R_PRIMARY -> Peer	(P_DATA)
  */
-int drbd_send_dblock(struct drbd_device *device, struct drbd_request *req)
+int drbd_send_dblock(struct drbd_peer_device *peer_device, struct drbd_request *req)
 {
+	struct drbd_device *device = peer_device->device;
 	struct drbd_socket *sock;
 	struct p_data *p;
 	unsigned int dp_flags = 0;
 	int dgs;
 	int err;
 
-	sock = &first_peer_device(device)->connection->data;
-	p = drbd_prepare_command(device, sock);
-	dgs = first_peer_device(device)->connection->integrity_tfm ?
-	      crypto_hash_digestsize(first_peer_device(device)->connection->integrity_tfm) : 0;
+	sock = &peer_device->connection->data;
+	p = drbd_prepare_command(peer_device, sock);
+	dgs = peer_device->connection->integrity_tfm ?
+	      crypto_hash_digestsize(peer_device->connection->integrity_tfm) : 0;
 
 	if (!p)
 		return -EIO;
 	p->sector = cpu_to_be64(req->i.sector);
 	p->block_id = (unsigned long)req;
 	p->seq_num = cpu_to_be32(atomic_inc_return(&device->packet_seq));
-	dp_flags = bio_flags_to_wire(device, req->master_bio->bi_rw);
+	dp_flags = bio_flags_to_wire(peer_device->connection, req->master_bio->bi_rw);
 	if (device->state.conn >= C_SYNC_SOURCE &&
 	    device->state.conn <= C_PAUSED_SYNC_T)
 		dp_flags |= DP_MAY_SET_IN_SYNC;
-	if (first_peer_device(device)->connection->agreed_pro_version >= 100) {
+	if (peer_device->connection->agreed_pro_version >= 100) {
 		if (req->rq_state & RQ_EXP_RECEIVE_ACK)
 			dp_flags |= DP_SEND_RECEIVE_ACK;
 		if (req->rq_state & RQ_EXP_WRITE_ACK)
@@ -1646,8 +1649,8 @@ int drbd_send_dblock(struct drbd_device *device, struct drbd_request *req)
 	}
 	p->dp_flags = cpu_to_be32(dp_flags);
 	if (dgs)
-		drbd_csum_bio(first_peer_device(device)->connection->integrity_tfm, req->master_bio, p + 1);
-	err = __send_command(first_peer_device(device)->connection, device->vnr, sock, P_DATA, sizeof(*p) + dgs, NULL, req->i.size);
+		drbd_csum_bio(peer_device->connection->integrity_tfm, req->master_bio, p + 1);
+	err = __send_command(peer_device->connection, device->vnr, sock, P_DATA, sizeof(*p) + dgs, NULL, req->i.size);
 	if (!err) {
 		/* For protocol A, we have to memcpy the payload into
 		 * socket buffers, as we may complete right away
@@ -1661,16 +1664,16 @@ int drbd_send_dblock(struct drbd_device *device, struct drbd_request *req)
 		 * receiving side, we sure have detected corruption elsewhere.
 		 */
 		if (!(req->rq_state & (RQ_EXP_RECEIVE_ACK | RQ_EXP_WRITE_ACK)) || dgs)
-			err = _drbd_send_bio(device, req->master_bio);
+			err = _drbd_send_bio(peer_device, req->master_bio);
 		else
-			err = _drbd_send_zc_bio(device, req->master_bio);
+			err = _drbd_send_zc_bio(peer_device, req->master_bio);
 
 		/* double check digest, sometimes buffers have been modified in flight. */
 		if (dgs > 0 && dgs <= 64) {
 			/* 64 byte, 512 bit, is the largest digest size
 			 * currently supported in kernel crypto. */
 			unsigned char digest[64];
-			drbd_csum_bio(first_peer_device(device)->connection->integrity_tfm, req->master_bio, digest);
+			drbd_csum_bio(peer_device->connection->integrity_tfm, req->master_bio, digest);
 			if (memcmp(p + 1, digest, dgs)) {
 				drbd_warn(device,
 					"Digest mismatch, buffer modified by upper layers during write: %llus +%u\n",
@@ -1689,19 +1692,20 @@ int drbd_send_dblock(struct drbd_device *device, struct drbd_request *req)
  *  Peer       -> (diskless) R_PRIMARY   (P_DATA_REPLY)
  *  C_SYNC_SOURCE -> C_SYNC_TARGET         (P_RS_DATA_REPLY)
  */
-int drbd_send_block(struct drbd_device *device, enum drbd_packet cmd,
+int drbd_send_block(struct drbd_peer_device *peer_device, enum drbd_packet cmd,
 		    struct drbd_peer_request *peer_req)
 {
+	struct drbd_device *device = peer_device->device;
 	struct drbd_socket *sock;
 	struct p_data *p;
 	int err;
 	int dgs;
 
-	sock = &first_peer_device(device)->connection->data;
-	p = drbd_prepare_command(device, sock);
+	sock = &peer_device->connection->data;
+	p = drbd_prepare_command(peer_device, sock);
 
-	dgs = first_peer_device(device)->connection->integrity_tfm ?
-	      crypto_hash_digestsize(first_peer_device(device)->connection->integrity_tfm) : 0;
+	dgs = peer_device->connection->integrity_tfm ?
+	      crypto_hash_digestsize(peer_device->connection->integrity_tfm) : 0;
 
 	if (!p)
 		return -EIO;
@@ -1710,27 +1714,27 @@ int drbd_send_block(struct drbd_device *device, enum drbd_packet cmd,
 	p->seq_num = 0;  /* unused */
 	p->dp_flags = 0;
 	if (dgs)
-		drbd_csum_ee(first_peer_device(device)->connection->integrity_tfm, peer_req, p + 1);
-	err = __send_command(first_peer_device(device)->connection, device->vnr, sock, cmd, sizeof(*p) + dgs, NULL, peer_req->i.size);
+		drbd_csum_ee(peer_device->connection->integrity_tfm, peer_req, p + 1);
+	err = __send_command(peer_device->connection, device->vnr, sock, cmd, sizeof(*p) + dgs, NULL, peer_req->i.size);
 	if (!err)
-		err = _drbd_send_zc_ee(device, peer_req);
+		err = _drbd_send_zc_ee(peer_device, peer_req);
 	mutex_unlock(&sock->mutex);  /* locked by drbd_prepare_command() */
 
 	return err;
 }
 
-int drbd_send_out_of_sync(struct drbd_device *device, struct drbd_request *req)
+int drbd_send_out_of_sync(struct drbd_peer_device *peer_device, struct drbd_request *req)
 {
 	struct drbd_socket *sock;
 	struct p_block_desc *p;
 
-	sock = &first_peer_device(device)->connection->data;
-	p = drbd_prepare_command(device, sock);
+	sock = &peer_device->connection->data;
+	p = drbd_prepare_command(peer_device, sock);
 	if (!p)
 		return -EIO;
 	p->sector = cpu_to_be64(req->i.sector);
 	p->blksize = cpu_to_be32(req->i.size);
-	return drbd_send_command(device, sock, P_OUT_OF_SYNC, sizeof(*p), NULL, 0);
+	return drbd_send_command(peer_device, sock, P_OUT_OF_SYNC, sizeof(*p), NULL, 0);
 }
 
 /*
@@ -2795,8 +2799,10 @@ enum drbd_ret_code drbd_create_device(struct drbd_resource *resource, unsigned i
 
 	/* inherit the connection state */
 	device->state.conn = first_connection(resource)->cstate;
-	if (device->state.conn == C_WF_REPORT_PARAMS)
-		drbd_connected(device);
+	if (device->state.conn == C_WF_REPORT_PARAMS) {
+		for_each_peer_device(peer_device, device)
+			drbd_connected(peer_device);
+	}
 
 	return NO_ERROR;
 
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index f7d62ff..f613ba9 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -678,8 +678,8 @@ drbd_set_role(struct drbd_device *device, enum drbd_role new_role, int force)
 	if (device->state.conn >= C_WF_REPORT_PARAMS) {
 		/* if this was forced, we should consider sync */
 		if (forced)
-			drbd_send_uuids(device);
-		drbd_send_current_state(device);
+			drbd_send_uuids(first_peer_device(device));
+		drbd_send_current_state(first_peer_device(device));
 	}
 
 	drbd_md_sync(device);
@@ -1364,8 +1364,12 @@ int drbd_adm_disk_opts(struct sk_buff *skb, struct genl_info *info)
 
 	drbd_md_sync(device);
 
-	if (device->state.conn >= C_CONNECTED)
-		drbd_send_sync_param(device);
+	if (device->state.conn >= C_CONNECTED) {
+		struct drbd_peer_device *peer_device;
+
+		for_each_peer_device(peer_device, device)
+			drbd_send_sync_param(peer_device);
+	}
 
 	synchronize_rcu();
 	kfree(old_disk_conf);
@@ -2145,8 +2149,13 @@ int drbd_adm_net_opts(struct sk_buff *skb, struct genl_info *info)
 	synchronize_rcu();
 	kfree(old_net_conf);
 
-	if (connection->cstate >= C_WF_REPORT_PARAMS)
-		drbd_send_sync_param(minor_to_device(conn_lowest_minor(connection)));
+	if (connection->cstate >= C_WF_REPORT_PARAMS) {
+		struct drbd_peer_device *peer_device;
+		int vnr;
+
+		idr_for_each_entry(&connection->peer_devices, peer_device, vnr)
+			drbd_send_sync_param(peer_device);
+	}
 
 	goto done;
 
@@ -2514,8 +2523,8 @@ int drbd_adm_resize(struct sk_buff *skb, struct genl_info *info)
 		if (dd == DS_GREW)
 			set_bit(RESIZE_PENDING, &device->flags);
 
-		drbd_send_uuids(device);
-		drbd_send_sizes(device, 1, ddsf);
+		drbd_send_uuids(first_peer_device(device));
+		drbd_send_sizes(first_peer_device(device), 1, ddsf);
 	}
 
  fail:
@@ -3244,7 +3253,7 @@ int drbd_adm_new_c_uuid(struct sk_buff *skb, struct genl_info *info)
 			retcode = ERR_IO_MD_DISK;
 		}
 		if (skip_initial_sync) {
-			drbd_send_uuids_skip_initial_sync(device);
+			drbd_send_uuids_skip_initial_sync(first_peer_device(device));
 			_drbd_uuid_set(device, UI_BITMAP, 0);
 			drbd_print_uuids(device, "cleared bitmap UUID");
 			spin_lock_irq(&device->resource->req_lock);
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index edd5cac..9ccb856 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -64,7 +64,7 @@ enum finish_epoch {
 
 static int drbd_do_features(struct drbd_connection *connection);
 static int drbd_do_auth(struct drbd_connection *connection);
-static int drbd_disconnected(struct drbd_device *device);
+static int drbd_disconnected(struct drbd_peer_device *);
 
 static enum finish_epoch drbd_may_finish_epoch(struct drbd_connection *, struct drbd_epoch *, enum epoch_event);
 static int e_end_block(struct drbd_work *, int);
@@ -241,9 +241,10 @@ static void drbd_kick_lo_and_reclaim_net(struct drbd_device *device)
  *
  * Returns a page chain linked via page->private.
  */
-struct page *drbd_alloc_pages(struct drbd_device *device, unsigned int number,
+struct page *drbd_alloc_pages(struct drbd_peer_device *peer_device, unsigned int number,
 			      bool retry)
 {
+	struct drbd_device *device = peer_device->device;
 	struct page *page = NULL;
 	struct net_conf *nc;
 	DEFINE_WAIT(wait);
@@ -252,7 +253,7 @@ struct page *drbd_alloc_pages(struct drbd_device *device, unsigned int number,
 	/* Yes, we may run up to @number over max_buffers. If we
 	 * follow it strictly, the admin will get it wrong anyways. */
 	rcu_read_lock();
-	nc = rcu_dereference(first_peer_device(device)->connection->net_conf);
+	nc = rcu_dereference(peer_device->connection->net_conf);
 	mxb = nc ? nc->max_buffers : 1000000;
 	rcu_read_unlock();
 
@@ -331,9 +332,10 @@ You must not have the req_lock:
 */
 
 struct drbd_peer_request *
-drbd_alloc_peer_req(struct drbd_device *device, u64 id, sector_t sector,
+drbd_alloc_peer_req(struct drbd_peer_device *peer_device, u64 id, sector_t sector,
 		    unsigned int data_size, gfp_t gfp_mask) __must_hold(local)
 {
+	struct drbd_device *device = peer_device->device;
 	struct drbd_peer_request *peer_req;
 	struct page *page = NULL;
 	unsigned nr_pages = (data_size + PAGE_SIZE -1) >> PAGE_SHIFT;
@@ -349,7 +351,7 @@ drbd_alloc_peer_req(struct drbd_device *device, u64 id, sector_t sector,
 	}
 
 	if (data_size) {
-		page = drbd_alloc_pages(device, nr_pages, (gfp_mask & __GFP_WAIT));
+		page = drbd_alloc_pages(peer_device, nr_pages, (gfp_mask & __GFP_WAIT));
 		if (!page)
 			goto fail;
 	}
@@ -831,24 +833,25 @@ static int drbd_socket_okay(struct socket **sock)
 }
 /* Gets called if a connection is established, or if a new minor gets created
    in a connection */
-int drbd_connected(struct drbd_device *device)
+int drbd_connected(struct drbd_peer_device *peer_device)
 {
+	struct drbd_device *device = peer_device->device;
 	int err;
 
 	atomic_set(&device->packet_seq, 0);
 	device->peer_seq = 0;
 
-	device->state_mutex = first_peer_device(device)->connection->agreed_pro_version < 100 ?
-		&first_peer_device(device)->connection->cstate_mutex :
+	device->state_mutex = peer_device->connection->agreed_pro_version < 100 ?
+		&peer_device->connection->cstate_mutex :
 		&device->own_state_mutex;
 
-	err = drbd_send_sync_param(device);
+	err = drbd_send_sync_param(peer_device);
 	if (!err)
-		err = drbd_send_sizes(device, 0, 0);
+		err = drbd_send_sizes(peer_device, 0, 0);
 	if (!err)
-		err = drbd_send_uuids(device);
+		err = drbd_send_uuids(peer_device);
 	if (!err)
-		err = drbd_send_current_state(device);
+		err = drbd_send_current_state(peer_device);
 	clear_bit(USE_DEGR_WFC_T, &device->flags);
 	clear_bit(RESIZE_PENDING, &device->flags);
 	atomic_set(&device->ap_in_flight, 0);
@@ -1058,7 +1061,7 @@ randomize:
 		else
 			clear_bit(DISCARD_MY_DATA, &device->flags);
 
-		drbd_connected(device);
+		drbd_connected(peer_device);
 		kref_put(&device->kref, drbd_destroy_device);
 		rcu_read_lock();
 	}
@@ -1498,25 +1501,26 @@ static int receive_Barrier(struct drbd_connection *connection, struct packet_inf
 /* used from receive_RSDataReply (recv_resync_read)
  * and from receive_Data */
 static struct drbd_peer_request *
-read_in_block(struct drbd_device *device, u64 id, sector_t sector,
+read_in_block(struct drbd_peer_device *peer_device, u64 id, sector_t sector,
 	      int data_size) __must_hold(local)
 {
+	struct drbd_device *device = peer_device->device;
 	const sector_t capacity = drbd_get_capacity(device->this_bdev);
 	struct drbd_peer_request *peer_req;
 	struct page *page;
 	int dgs, ds, err;
-	void *dig_in = first_peer_device(device)->connection->int_dig_in;
-	void *dig_vv = first_peer_device(device)->connection->int_dig_vv;
+	void *dig_in = peer_device->connection->int_dig_in;
+	void *dig_vv = peer_device->connection->int_dig_vv;
 	unsigned long *data;
 
 	dgs = 0;
-	if (first_peer_device(device)->connection->peer_integrity_tfm) {
-		dgs = crypto_hash_digestsize(first_peer_device(device)->connection->peer_integrity_tfm);
+	if (peer_device->connection->peer_integrity_tfm) {
+		dgs = crypto_hash_digestsize(peer_device->connection->peer_integrity_tfm);
 		/*
 		 * FIXME: Receive the incoming digest into the receive buffer
 		 *	  here, together with its struct p_data?
 		 */
-		err = drbd_recv_all_warn(first_peer_device(device)->connection, dig_in, dgs);
+		err = drbd_recv_all_warn(peer_device->connection, dig_in, dgs);
 		if (err)
 			return NULL;
 		data_size -= dgs;
@@ -1540,7 +1544,7 @@ read_in_block(struct drbd_device *device, u64 id, sector_t sector,
 	/* GFP_NOIO, because we must not cause arbitrary write-out: in a DRBD
 	 * "criss-cross" setup, that might cause write-out on some other DRBD,
 	 * which in turn might block on the other node at this very place.  */
-	peer_req = drbd_alloc_peer_req(device, id, sector, data_size, GFP_NOIO);
+	peer_req = drbd_alloc_peer_req(peer_device, id, sector, data_size, GFP_NOIO);
 	if (!peer_req)
 		return NULL;
 
@@ -1552,7 +1556,7 @@ read_in_block(struct drbd_device *device, u64 id, sector_t sector,
 	page_chain_for_each(page) {
 		unsigned len = min_t(int, ds, PAGE_SIZE);
 		data = kmap(page);
-		err = drbd_recv_all_warn(first_peer_device(device)->connection, data, len);
+		err = drbd_recv_all_warn(peer_device->connection, data, len);
 		if (drbd_insert_fault(device, DRBD_FAULT_RECEIVE)) {
 			drbd_err(device, "Fault injection: Corrupting data on receive\n");
 			data[0] = data[0] ^ (unsigned long)-1;
@@ -1566,7 +1570,7 @@ read_in_block(struct drbd_device *device, u64 id, sector_t sector,
 	}
 
 	if (dgs) {
-		drbd_csum_ee(first_peer_device(device)->connection->peer_integrity_tfm, peer_req, dig_vv);
+		drbd_csum_ee(peer_device->connection->peer_integrity_tfm, peer_req, dig_vv);
 		if (memcmp(dig_in, dig_vv, dgs)) {
 			drbd_err(device, "Digest integrity check FAILED: %llus +%u\n",
 				(unsigned long long)sector, data_size);
@@ -1581,7 +1585,7 @@ read_in_block(struct drbd_device *device, u64 id, sector_t sector,
 /* drbd_drain_block() just takes a data block
  * out of the socket input buffer, and discards it.
  */
-static int drbd_drain_block(struct drbd_device *device, int data_size)
+static int drbd_drain_block(struct drbd_peer_device *peer_device, int data_size)
 {
 	struct page *page;
 	int err = 0;
@@ -1590,36 +1594,36 @@ static int drbd_drain_block(struct drbd_device *device, int data_size)
 	if (!data_size)
 		return 0;
 
-	page = drbd_alloc_pages(device, 1, 1);
+	page = drbd_alloc_pages(peer_device, 1, 1);
 
 	data = kmap(page);
 	while (data_size) {
 		unsigned int len = min_t(int, data_size, PAGE_SIZE);
 
-		err = drbd_recv_all_warn(first_peer_device(device)->connection, data, len);
+		err = drbd_recv_all_warn(peer_device->connection, data, len);
 		if (err)
 			break;
 		data_size -= len;
 	}
 	kunmap(page);
-	drbd_free_pages(device, page, 0);
+	drbd_free_pages(peer_device->device, page, 0);
 	return err;
 }
 
-static int recv_dless_read(struct drbd_device *device, struct drbd_request *req,
+static int recv_dless_read(struct drbd_peer_device *peer_device, struct drbd_request *req,
 			   sector_t sector, int data_size)
 {
 	struct bio_vec bvec;
 	struct bvec_iter iter;
 	struct bio *bio;
 	int dgs, err, expect;
-	void *dig_in = first_peer_device(device)->connection->int_dig_in;
-	void *dig_vv = first_peer_device(device)->connection->int_dig_vv;
+	void *dig_in = peer_device->connection->int_dig_in;
+	void *dig_vv = peer_device->connection->int_dig_vv;
 
 	dgs = 0;
-	if (first_peer_device(device)->connection->peer_integrity_tfm) {
-		dgs = crypto_hash_digestsize(first_peer_device(device)->connection->peer_integrity_tfm);
-		err = drbd_recv_all_warn(first_peer_device(device)->connection, dig_in, dgs);
+	if (peer_device->connection->peer_integrity_tfm) {
+		dgs = crypto_hash_digestsize(peer_device->connection->peer_integrity_tfm);
+		err = drbd_recv_all_warn(peer_device->connection, dig_in, dgs);
 		if (err)
 			return err;
 		data_size -= dgs;
@@ -1627,15 +1631,15 @@ static int recv_dless_read(struct drbd_device *device, struct drbd_request *req,
 
 	/* optimistically update recv_cnt.  if receiving fails below,
 	 * we disconnect anyways, and counters will be reset. */
-	device->recv_cnt += data_size>>9;
+	peer_device->device->recv_cnt += data_size>>9;
 
 	bio = req->master_bio;
-	D_ASSERT(device, sector == bio->bi_iter.bi_sector);
+	D_ASSERT(peer_device->device, sector == bio->bi_iter.bi_sector);
 
 	bio_for_each_segment(bvec, bio, iter) {
 		void *mapped = kmap(bvec.bv_page) + bvec.bv_offset;
 		expect = min_t(int, data_size, bvec.bv_len);
-		err = drbd_recv_all_warn(first_peer_device(device)->connection, mapped, expect);
+		err = drbd_recv_all_warn(peer_device->connection, mapped, expect);
 		kunmap(bvec.bv_page);
 		if (err)
 			return err;
@@ -1643,14 +1647,14 @@ static int recv_dless_read(struct drbd_device *device, struct drbd_request *req,
 	}
 
 	if (dgs) {
-		drbd_csum_bio(first_peer_device(device)->connection->peer_integrity_tfm, bio, dig_vv);
+		drbd_csum_bio(peer_device->connection->peer_integrity_tfm, bio, dig_vv);
 		if (memcmp(dig_in, dig_vv, dgs)) {
-			drbd_err(device, "Digest integrity check FAILED. Broken NICs?\n");
+			drbd_err(peer_device, "Digest integrity check FAILED. Broken NICs?\n");
 			return -EINVAL;
 		}
 	}
 
-	D_ASSERT(device, data_size == 0);
+	D_ASSERT(peer_device->device, data_size == 0);
 	return 0;
 }
 
@@ -1670,23 +1674,25 @@ static int e_end_resync_block(struct drbd_work *w, int unused)
 
 	if (likely((peer_req->flags & EE_WAS_ERROR) == 0)) {
 		drbd_set_in_sync(device, sector, peer_req->i.size);
-		err = drbd_send_ack(device, P_RS_WRITE_ACK, peer_req);
+		err = drbd_send_ack(first_peer_device(device), P_RS_WRITE_ACK, peer_req);
 	} else {
 		/* Record failure to sync */
 		drbd_rs_failed_io(device, sector, peer_req->i.size);
 
-		err  = drbd_send_ack(device, P_NEG_ACK, peer_req);
+		err  = drbd_send_ack(first_peer_device(device), P_NEG_ACK, peer_req);
 	}
 	dec_unacked(device);
 
 	return err;
 }
 
-static int recv_resync_read(struct drbd_device *device, sector_t sector, int data_size) __releases(local)
+static int recv_resync_read(struct drbd_peer_device *peer_device, sector_t sector,
+			    int data_size) __releases(local)
 {
+	struct drbd_device *device = peer_device->device;
 	struct drbd_peer_request *peer_req;
 
-	peer_req = read_in_block(device, ID_SYNCER, sector, data_size);
+	peer_req = read_in_block(peer_device, ID_SYNCER, sector, data_size);
 	if (!peer_req)
 		goto fail;
 
@@ -1760,7 +1766,7 @@ static int receive_DataReply(struct drbd_connection *connection, struct packet_i
 	/* hlist_del(&req->collision) is done in _req_may_be_done, to avoid
 	 * special casing it there for the various failure cases.
 	 * still no race with drbd_fail_pending_reads */
-	err = recv_dless_read(device, req, sector, pi->size);
+	err = recv_dless_read(peer_device, req, sector, pi->size);
 	if (!err)
 		req_mod(req, DATA_RECEIVED);
 	/* else: nothing. handled from drbd_disconnect...
@@ -1790,14 +1796,14 @@ static int receive_RSDataReply(struct drbd_connection *connection, struct packet
 		/* data is submitted to disk within recv_resync_read.
 		 * corresponding put_ldev done below on error,
 		 * or in drbd_peer_request_endio. */
-		err = recv_resync_read(device, sector, pi->size);
+		err = recv_resync_read(peer_device, sector, pi->size);
 	} else {
 		if (__ratelimit(&drbd_ratelimit_state))
 			drbd_err(device, "Can not write resync data to local disk.\n");
 
-		err = drbd_drain_block(device, pi->size);
+		err = drbd_drain_block(peer_device, pi->size);
 
-		drbd_send_ack_dp(device, P_NEG_ACK, p, pi->size);
+		drbd_send_ack_dp(peer_device, P_NEG_ACK, p, pi->size);
 	}
 
 	atomic_add(pi->size >> 9, &device->rs_sect_in);
@@ -1841,11 +1847,11 @@ static int e_end_block(struct drbd_work *w, int cancel)
 				device->state.conn <= C_PAUSED_SYNC_T &&
 				peer_req->flags & EE_MAY_SET_IN_SYNC) ?
 				P_RS_WRITE_ACK : P_WRITE_ACK;
-			err = drbd_send_ack(device, pcmd, peer_req);
+			err = drbd_send_ack(first_peer_device(device), pcmd, peer_req);
 			if (pcmd == P_RS_WRITE_ACK)
 				drbd_set_in_sync(device, sector, peer_req->i.size);
 		} else {
-			err = drbd_send_ack(device, P_NEG_ACK, peer_req);
+			err = drbd_send_ack(first_peer_device(device), P_NEG_ACK, peer_req);
 			/* we expect it to be marked out of sync anyways...
 			 * maybe assert this?  */
 		}
@@ -1875,7 +1881,7 @@ static int e_send_ack(struct drbd_work *w, enum drbd_packet ack)
 		container_of(w, struct drbd_peer_request, w);
 	int err;
 
-	err = drbd_send_ack(device, ack, peer_req);
+	err = drbd_send_ack(first_peer_device(device), ack, peer_req);
 	dec_unacked(device);
 
 	return err;
@@ -1909,11 +1915,12 @@ static u32 seq_max(u32 a, u32 b)
 	return seq_greater(a, b) ? a : b;
 }
 
-static void update_peer_seq(struct drbd_device *device, unsigned int peer_seq)
+static void update_peer_seq(struct drbd_peer_device *peer_device, unsigned int peer_seq)
 {
+	struct drbd_device *device = peer_device->device;
 	unsigned int newest_peer_seq;
 
-	if (test_bit(RESOLVE_CONFLICTS, &first_peer_device(device)->connection->flags)) {
+	if (test_bit(RESOLVE_CONFLICTS, &peer_device->connection->flags)) {
 		spin_lock(&device->peer_seq_lock);
 		newest_peer_seq = seq_max(device->peer_seq, peer_seq);
 		device->peer_seq = newest_peer_seq;
@@ -1969,13 +1976,14 @@ static bool overlapping_resync_write(struct drbd_device *device, struct drbd_pee
  *
  * returns 0 if we may process the packet,
  * -ERESTARTSYS if we were interrupted (by disconnect signal). */
-static int wait_for_and_update_peer_seq(struct drbd_device *device, const u32 peer_seq)
+static int wait_for_and_update_peer_seq(struct drbd_peer_device *peer_device, const u32 peer_seq)
 {
+	struct drbd_device *device = peer_device->device;
 	DEFINE_WAIT(wait);
 	long timeout;
 	int ret = 0, tp;
 
-	if (!test_bit(RESOLVE_CONFLICTS, &first_peer_device(device)->connection->flags))
+	if (!test_bit(RESOLVE_CONFLICTS, &peer_device->connection->flags))
 		return 0;
 
 	spin_lock(&device->peer_seq_lock);
@@ -2001,7 +2009,7 @@ static int wait_for_and_update_peer_seq(struct drbd_device *device, const u32 pe
 		prepare_to_wait(&device->seq_wait, &wait, TASK_INTERRUPTIBLE);
 		spin_unlock(&device->peer_seq_lock);
 		rcu_read_lock();
-		timeout = rcu_dereference(first_peer_device(device)->connection->net_conf)->ping_timeo*HZ/10;
+		timeout = rcu_dereference(peer_device->connection->net_conf)->ping_timeo*HZ/10;
 		rcu_read_unlock();
 		timeout = schedule_timeout(timeout);
 		spin_lock(&device->peer_seq_lock);
@@ -2182,10 +2190,10 @@ static int receive_Data(struct drbd_connection *connection, struct packet_info *
 	if (!get_ldev(device)) {
 		int err2;
 
-		err = wait_for_and_update_peer_seq(device, peer_seq);
-		drbd_send_ack_dp(device, P_NEG_ACK, p, pi->size);
+		err = wait_for_and_update_peer_seq(peer_device, peer_seq);
+		drbd_send_ack_dp(peer_device, P_NEG_ACK, p, pi->size);
 		atomic_inc(&connection->current_epoch->epoch_size);
-		err2 = drbd_drain_block(device, pi->size);
+		err2 = drbd_drain_block(peer_device, pi->size);
 		if (!err)
 			err = err2;
 		return err;
@@ -2198,7 +2206,7 @@ static int receive_Data(struct drbd_connection *connection, struct packet_info *
 	 */
 
 	sector = be64_to_cpu(p->sector);
-	peer_req = read_in_block(device, p->block_id, sector, pi->size);
+	peer_req = read_in_block(peer_device, p->block_id, sector, pi->size);
 	if (!peer_req) {
 		put_ldev(device);
 		return -EIO;
@@ -2227,7 +2235,7 @@ static int receive_Data(struct drbd_connection *connection, struct packet_info *
 	rcu_read_unlock();
 	if (tp) {
 		peer_req->flags |= EE_IN_INTERVAL_TREE;
-		err = wait_for_and_update_peer_seq(device, peer_seq);
+		err = wait_for_and_update_peer_seq(peer_device, peer_seq);
 		if (err)
 			goto out_interrupted;
 		spin_lock_irq(&device->resource->req_lock);
@@ -2241,7 +2249,7 @@ static int receive_Data(struct drbd_connection *connection, struct packet_info *
 			goto out_interrupted;
 		}
 	} else {
-		update_peer_seq(device, peer_seq);
+		update_peer_seq(peer_device, peer_seq);
 		spin_lock_irq(&device->resource->req_lock);
 	}
 	list_add(&peer_req->w.list, &device->active_ee);
@@ -2273,7 +2281,7 @@ static int receive_Data(struct drbd_connection *connection, struct packet_info *
 	if (dp_flags & DP_SEND_RECEIVE_ACK) {
 		/* I really don't like it that the receiver thread
 		 * sends on the msock, but anyways */
-		drbd_send_ack(device, P_RECV_ACK, peer_req);
+		drbd_send_ack(first_peer_device(device), P_RECV_ACK, peer_req);
 	}
 
 	if (device->state.pdsk < D_INCONSISTENT) {
@@ -2412,17 +2420,17 @@ static int receive_DataRequest(struct drbd_connection *connection, struct packet
 		verb = 1;
 		switch (pi->cmd) {
 		case P_DATA_REQUEST:
-			drbd_send_ack_rp(device, P_NEG_DREPLY, p);
+			drbd_send_ack_rp(peer_device, P_NEG_DREPLY, p);
 			break;
 		case P_RS_DATA_REQUEST:
 		case P_CSUM_RS_REQUEST:
 		case P_OV_REQUEST:
-			drbd_send_ack_rp(device, P_NEG_RS_DREPLY , p);
+			drbd_send_ack_rp(peer_device, P_NEG_RS_DREPLY , p);
 			break;
 		case P_OV_REPLY:
 			verb = 0;
 			dec_rs_pending(device);
-			drbd_send_ack_ex(device, P_OV_RESULT, sector, size, ID_IN_SYNC);
+			drbd_send_ack_ex(peer_device, P_OV_RESULT, sector, size, ID_IN_SYNC);
 			break;
 		default:
 			BUG();
@@ -2432,13 +2440,13 @@ static int receive_DataRequest(struct drbd_connection *connection, struct packet
 			    "no local data.\n");
 
 		/* drain possibly payload */
-		return drbd_drain_block(device, pi->size);
+		return drbd_drain_block(peer_device, pi->size);
 	}
 
 	/* GFP_NOIO, because we must not cause arbitrary write-out: in a DRBD
 	 * "criss-cross" setup, that might cause write-out on some other DRBD,
 	 * which in turn might block on the other node at this very place.  */
-	peer_req = drbd_alloc_peer_req(device, p->block_id, sector, size, GFP_NOIO);
+	peer_req = drbd_alloc_peer_req(peer_device, p->block_id, sector, size, GFP_NOIO);
 	if (!peer_req) {
 		put_ldev(device);
 		return -ENOMEM;
@@ -2566,8 +2574,12 @@ out_free_e:
 	return -EIO;
 }
 
-static int drbd_asb_recover_0p(struct drbd_device *device) __must_hold(local)
+/**
+ * drbd_asb_recover_0p  -  Recover after split-brain with no remaining primaries
+ */
+static int drbd_asb_recover_0p(struct drbd_peer_device *peer_device) __must_hold(local)
 {
+	struct drbd_device *device = peer_device->device;
 	int self, peer, rv = -100;
 	unsigned long ch_self, ch_peer;
 	enum drbd_after_sb_p after_sb_0p;
@@ -2579,7 +2591,7 @@ static int drbd_asb_recover_0p(struct drbd_device *device) __must_hold(local)
 	ch_self = device->comm_bm_set;
 
 	rcu_read_lock();
-	after_sb_0p = rcu_dereference(first_peer_device(device)->connection->net_conf)->after_sb_0p;
+	after_sb_0p = rcu_dereference(peer_device->connection->net_conf)->after_sb_0p;
 	rcu_read_unlock();
 	switch (after_sb_0p) {
 	case ASB_CONSENSUS:
@@ -2614,7 +2626,7 @@ static int drbd_asb_recover_0p(struct drbd_device *device) __must_hold(local)
 		     "Using discard-least-changes instead\n");
 	case ASB_DISCARD_ZERO_CHG:
 		if (ch_peer == 0 && ch_self == 0) {
-			rv = test_bit(RESOLVE_CONFLICTS, &first_peer_device(device)->connection->flags)
+			rv = test_bit(RESOLVE_CONFLICTS, &peer_device->connection->flags)
 				? -1 : 1;
 			break;
 		} else {
@@ -2630,7 +2642,7 @@ static int drbd_asb_recover_0p(struct drbd_device *device) __must_hold(local)
 			rv =  1;
 		else /* ( ch_self == ch_peer ) */
 		     /* Well, then use something else. */
-			rv = test_bit(RESOLVE_CONFLICTS, &first_peer_device(device)->connection->flags)
+			rv = test_bit(RESOLVE_CONFLICTS, &peer_device->connection->flags)
 				? -1 : 1;
 		break;
 	case ASB_DISCARD_LOCAL:
@@ -2643,13 +2655,17 @@ static int drbd_asb_recover_0p(struct drbd_device *device) __must_hold(local)
 	return rv;
 }
 
-static int drbd_asb_recover_1p(struct drbd_device *device) __must_hold(local)
+/**
+ * drbd_asb_recover_1p  -  Recover after split-brain with one remaining primary
+ */
+static int drbd_asb_recover_1p(struct drbd_peer_device *peer_device) __must_hold(local)
 {
+	struct drbd_device *device = peer_device->device;
 	int hg, rv = -100;
 	enum drbd_after_sb_p after_sb_1p;
 
 	rcu_read_lock();
-	after_sb_1p = rcu_dereference(first_peer_device(device)->connection->net_conf)->after_sb_1p;
+	after_sb_1p = rcu_dereference(peer_device->connection->net_conf)->after_sb_1p;
 	rcu_read_unlock();
 	switch (after_sb_1p) {
 	case ASB_DISCARD_YOUNGER_PRI:
@@ -2663,19 +2679,19 @@ static int drbd_asb_recover_1p(struct drbd_device *device) __must_hold(local)
 	case ASB_DISCONNECT:
 		break;
 	case ASB_CONSENSUS:
-		hg = drbd_asb_recover_0p(device);
+		hg = drbd_asb_recover_0p(peer_device);
 		if (hg == -1 && device->state.role == R_SECONDARY)
 			rv = hg;
 		if (hg == 1  && device->state.role == R_PRIMARY)
 			rv = hg;
 		break;
 	case ASB_VIOLENTLY:
-		rv = drbd_asb_recover_0p(device);
+		rv = drbd_asb_recover_0p(peer_device);
 		break;
 	case ASB_DISCARD_SECONDARY:
 		return device->state.role == R_PRIMARY ? 1 : -1;
 	case ASB_CALL_HELPER:
-		hg = drbd_asb_recover_0p(device);
+		hg = drbd_asb_recover_0p(peer_device);
 		if (hg == -1 && device->state.role == R_PRIMARY) {
 			enum drbd_state_rv rv2;
 
@@ -2696,13 +2712,17 @@ static int drbd_asb_recover_1p(struct drbd_device *device) __must_hold(local)
 	return rv;
 }
 
-static int drbd_asb_recover_2p(struct drbd_device *device) __must_hold(local)
+/**
+ * drbd_asb_recover_2p  -  Recover after split-brain with two remaining primaries
+ */
+static int drbd_asb_recover_2p(struct drbd_peer_device *peer_device) __must_hold(local)
 {
+	struct drbd_device *device = peer_device->device;
 	int hg, rv = -100;
 	enum drbd_after_sb_p after_sb_2p;
 
 	rcu_read_lock();
-	after_sb_2p = rcu_dereference(first_peer_device(device)->connection->net_conf)->after_sb_2p;
+	after_sb_2p = rcu_dereference(peer_device->connection->net_conf)->after_sb_2p;
 	rcu_read_unlock();
 	switch (after_sb_2p) {
 	case ASB_DISCARD_YOUNGER_PRI:
@@ -2716,12 +2736,12 @@ static int drbd_asb_recover_2p(struct drbd_device *device) __must_hold(local)
 		drbd_err(device, "Configuration error.\n");
 		break;
 	case ASB_VIOLENTLY:
-		rv = drbd_asb_recover_0p(device);
+		rv = drbd_asb_recover_0p(peer_device);
 		break;
 	case ASB_DISCONNECT:
 		break;
 	case ASB_CALL_HELPER:
-		hg = drbd_asb_recover_0p(device);
+		hg = drbd_asb_recover_0p(peer_device);
 		if (hg == -1) {
 			enum drbd_state_rv rv2;
 
@@ -2956,9 +2976,11 @@ static int drbd_uuid_compare(struct drbd_device *device, int *rule_nr) __must_ho
 /* drbd_sync_handshake() returns the new conn state on success, or
    CONN_MASK (-1) on failure.
  */
-static enum drbd_conns drbd_sync_handshake(struct drbd_device *device, enum drbd_role peer_role,
+static enum drbd_conns drbd_sync_handshake(struct drbd_peer_device *peer_device,
+					   enum drbd_role peer_role,
 					   enum drbd_disk_state peer_disk) __must_hold(local)
 {
+	struct drbd_device *device = peer_device->device;
 	enum drbd_conns rv = C_MASK;
 	enum drbd_disk_state mydisk;
 	struct net_conf *nc;
@@ -3003,7 +3025,7 @@ static enum drbd_conns drbd_sync_handshake(struct drbd_device *device, enum drbd
 		drbd_khelper(device, "initial-split-brain");
 
 	rcu_read_lock();
-	nc = rcu_dereference(first_peer_device(device)->connection->net_conf);
+	nc = rcu_dereference(peer_device->connection->net_conf);
 
 	if (hg == 100 || (hg == -100 && nc->always_asbp)) {
 		int pcount = (device->state.role == R_PRIMARY)
@@ -3012,13 +3034,13 @@ static enum drbd_conns drbd_sync_handshake(struct drbd_device *device, enum drbd
 
 		switch (pcount) {
 		case 0:
-			hg = drbd_asb_recover_0p(device);
+			hg = drbd_asb_recover_0p(peer_device);
 			break;
 		case 1:
-			hg = drbd_asb_recover_1p(device);
+			hg = drbd_asb_recover_1p(peer_device);
 			break;
 		case 2:
-			hg = drbd_asb_recover_2p(device);
+			hg = drbd_asb_recover_2p(peer_device);
 			break;
 		}
 		if (abs(hg) < 100) {
@@ -3078,7 +3100,7 @@ static enum drbd_conns drbd_sync_handshake(struct drbd_device *device, enum drbd
 		}
 	}
 
-	if (tentative || test_bit(CONN_DRY_RUN, &first_peer_device(device)->connection->flags)) {
+	if (tentative || test_bit(CONN_DRY_RUN, &peer_device->connection->flags)) {
 		if (hg == 0)
 			drbd_info(device, "dry-run connect: No resync, would become Connected immediately.\n");
 		else
@@ -3664,7 +3686,7 @@ static int receive_sizes(struct drbd_connection *connection, struct packet_info
 		    drbd_get_capacity(device->this_bdev) || ldsc) {
 			/* we have different sizes, probably peer
 			 * needs to know my new size... */
-			drbd_send_sizes(device, 0, ddsf);
+			drbd_send_sizes(peer_device, 0, ddsf);
 		}
 		if (test_and_clear_bit(RESIZE_PENDING, &device->flags) ||
 		    (dd == DS_GREW && device->state.conn == C_CONNECTED)) {
@@ -3807,7 +3829,7 @@ static int receive_req_state(struct drbd_connection *connection, struct packet_i
 
 	if (test_bit(RESOLVE_CONFLICTS, &peer_device->connection->flags) &&
 	    mutex_is_locked(device->state_mutex)) {
-		drbd_send_sr_reply(device, SS_CONCURRENT_ST_CHG);
+		drbd_send_sr_reply(peer_device, SS_CONCURRENT_ST_CHG);
 		return 0;
 	}
 
@@ -3815,7 +3837,7 @@ static int receive_req_state(struct drbd_connection *connection, struct packet_i
 	val = convert_state(val);
 
 	rv = drbd_change_state(device, CS_VERBOSE, mask, val);
-	drbd_send_sr_reply(device, rv);
+	drbd_send_sr_reply(peer_device, rv);
 
 	drbd_md_sync(device);
 
@@ -3954,7 +3976,7 @@ static int receive_state(struct drbd_connection *connection, struct packet_info
 				 peer_state.conn <= C_WF_BITMAP_T));
 
 		if (cr)
-			ns.conn = drbd_sync_handshake(device, peer_state.role, real_peer_disk);
+			ns.conn = drbd_sync_handshake(peer_device, peer_state.role, real_peer_disk);
 
 		put_ldev(device);
 		if (ns.conn == C_MASK) {
@@ -4012,8 +4034,8 @@ static int receive_state(struct drbd_connection *connection, struct packet_info
 			/* we want resync, peer has not yet decided to sync... */
 			/* Nowadays only used when forcing a node into primary role and
 			   setting its disk to UpToDate with that */
-			drbd_send_uuids(device);
-			drbd_send_current_state(device);
+			drbd_send_uuids(peer_device);
+			drbd_send_current_state(peer_device);
 		}
 	}
 
@@ -4066,27 +4088,27 @@ static int receive_sync_uuid(struct drbd_connection *connection, struct packet_i
  * code upon failure.
  */
 static int
-receive_bitmap_plain(struct drbd_device *device, unsigned int size,
+receive_bitmap_plain(struct drbd_peer_device *peer_device, unsigned int size,
 		     unsigned long *p, struct bm_xfer_ctx *c)
 {
 	unsigned int data_size = DRBD_SOCKET_BUFFER_SIZE -
-				 drbd_header_size(first_peer_device(device)->connection);
+				 drbd_header_size(peer_device->connection);
 	unsigned int num_words = min_t(size_t, data_size / sizeof(*p),
 				       c->bm_words - c->word_offset);
 	unsigned int want = num_words * sizeof(*p);
 	int err;
 
 	if (want != size) {
-		drbd_err(device, "%s:want (%u) != size (%u)\n", __func__, want, size);
+		drbd_err(peer_device, "%s:want (%u) != size (%u)\n", __func__, want, size);
 		return -EIO;
 	}
 	if (want == 0)
 		return 0;
-	err = drbd_recv_all(first_peer_device(device)->connection, p, want);
+	err = drbd_recv_all(peer_device->connection, p, want);
 	if (err)
 		return err;
 
-	drbd_bm_merge_lel(device, c->word_offset, num_words, p);
+	drbd_bm_merge_lel(peer_device->device, c->word_offset, num_words, p);
 
 	c->word_offset += num_words;
 	c->bit_offset = c->word_offset * BITS_PER_LONG;
@@ -4118,7 +4140,7 @@ static int dcbp_get_pad_bits(struct p_compressed_bm *p)
  * code upon failure.
  */
 static int
-recv_bm_rle_bits(struct drbd_device *device,
+recv_bm_rle_bits(struct drbd_peer_device *peer_device,
 		struct p_compressed_bm *p,
 		 struct bm_xfer_ctx *c,
 		 unsigned int len)
@@ -4147,14 +4169,14 @@ recv_bm_rle_bits(struct drbd_device *device,
 		if (toggle) {
 			e = s + rl -1;
 			if (e >= c->bm_bits) {
-				drbd_err(device, "bitmap overflow (e:%lu) while decoding bm RLE packet\n", e);
+				drbd_err(peer_device, "bitmap overflow (e:%lu) while decoding bm RLE packet\n", e);
 				return -EIO;
 			}
-			_drbd_bm_set_bits(device, s, e);
+			_drbd_bm_set_bits(peer_device->device, s, e);
 		}
 
 		if (have < bits) {
-			drbd_err(device, "bitmap decoding error: h:%d b:%d la:0x%08llx l:%u/%u\n",
+			drbd_err(peer_device, "bitmap decoding error: h:%d b:%d la:0x%08llx l:%u/%u\n",
 				have, bits, look_ahead,
 				(unsigned int)(bs.cur.b - p->code),
 				(unsigned int)bs.buf_len);
@@ -4187,20 +4209,20 @@ recv_bm_rle_bits(struct drbd_device *device,
  * code upon failure.
  */
 static int
-decode_bitmap_c(struct drbd_device *device,
+decode_bitmap_c(struct drbd_peer_device *peer_device,
 		struct p_compressed_bm *p,
 		struct bm_xfer_ctx *c,
 		unsigned int len)
 {
 	if (dcbp_get_code(p) == RLE_VLI_Bits)
-		return recv_bm_rle_bits(device, p, c, len - sizeof(*p));
+		return recv_bm_rle_bits(peer_device, p, c, len - sizeof(*p));
 
 	/* other variants had been implemented for evaluation,
 	 * but have been dropped as this one turned out to be "best"
 	 * during all our tests. */
 
-	drbd_err(device, "receive_bitmap_c: unknown encoding %u\n", p->encoding);
-	conn_request_state(first_peer_device(device)->connection, NS(conn, C_PROTOCOL_ERROR), CS_HARD);
+	drbd_err(peer_device, "receive_bitmap_c: unknown encoding %u\n", p->encoding);
+	conn_request_state(peer_device->connection, NS(conn, C_PROTOCOL_ERROR), CS_HARD);
 	return -EIO;
 }
 
@@ -4271,7 +4293,7 @@ static int receive_bitmap(struct drbd_connection *connection, struct packet_info
 
 	for(;;) {
 		if (pi->cmd == P_BITMAP)
-			err = receive_bitmap_plain(device, pi->size, pi->data, &c);
+			err = receive_bitmap_plain(peer_device, pi->size, pi->data, &c);
 		else if (pi->cmd == P_COMPRESSED_BITMAP) {
 			/* MAYBE: sanity check that we speak proto >= 90,
 			 * and the feature is enabled! */
@@ -4290,7 +4312,7 @@ static int receive_bitmap(struct drbd_connection *connection, struct packet_info
 			err = drbd_recv_all(peer_device->connection, p, pi->size);
 			if (err)
 			       goto out;
-			err = decode_bitmap_c(device, p, &c, pi->size);
+			err = decode_bitmap_c(peer_device, p, &c, pi->size);
 		} else {
 			drbd_warn(device, "receive_bitmap: cmd neither ReportBitMap nor ReportCBitMap (is 0x%x)", pi->cmd);
 			err = -EIO;
@@ -4495,7 +4517,7 @@ static void conn_disconnect(struct drbd_connection *connection)
 		struct drbd_device *device = peer_device->device;
 		kref_get(&device->kref);
 		rcu_read_unlock();
-		drbd_disconnected(device);
+		drbd_disconnected(peer_device);
 		kref_put(&device->kref, drbd_destroy_device);
 		rcu_read_lock();
 	}
@@ -4523,8 +4545,9 @@ static void conn_disconnect(struct drbd_connection *connection)
 		conn_request_state(connection, NS(conn, C_STANDALONE), CS_VERBOSE | CS_HARD);
 }
 
-static int drbd_disconnected(struct drbd_device *device)
+static int drbd_disconnected(struct drbd_peer_device *peer_device)
 {
+	struct drbd_device *device = peer_device->device;
 	unsigned int i;
 
 	/* wait for current activity to cease. */
@@ -4573,7 +4596,7 @@ static int drbd_disconnected(struct drbd_device *device)
 	device->p_uuid = NULL;
 
 	if (!drbd_suspended(device))
-		tl_clear(first_peer_device(device)->connection);
+		tl_clear(peer_device->connection);
 
 	drbd_md_sync(device);
 
@@ -4980,7 +5003,7 @@ static int got_IsInSync(struct drbd_connection *connection, struct packet_info *
 
 	D_ASSERT(device, peer_device->connection->agreed_pro_version >= 89);
 
-	update_peer_seq(device, be32_to_cpu(p->seq_num));
+	update_peer_seq(peer_device, be32_to_cpu(p->seq_num));
 
 	if (get_ldev(device)) {
 		drbd_rs_complete_io(device, sector);
@@ -5031,7 +5054,7 @@ static int got_BlockAck(struct drbd_connection *connection, struct packet_info *
 		return -EIO;
 	device = peer_device->device;
 
-	update_peer_seq(device, be32_to_cpu(p->seq_num));
+	update_peer_seq(peer_device, be32_to_cpu(p->seq_num));
 
 	if (p->block_id == ID_SYNCER) {
 		drbd_set_in_sync(device, sector, blksize);
@@ -5077,7 +5100,7 @@ static int got_NegAck(struct drbd_connection *connection, struct packet_info *pi
 		return -EIO;
 	device = peer_device->device;
 
-	update_peer_seq(device, be32_to_cpu(p->seq_num));
+	update_peer_seq(peer_device, be32_to_cpu(p->seq_num));
 
 	if (p->block_id == ID_SYNCER) {
 		dec_rs_pending(device);
@@ -5111,7 +5134,7 @@ static int got_NegDReply(struct drbd_connection *connection, struct packet_info
 		return -EIO;
 	device = peer_device->device;
 
-	update_peer_seq(device, be32_to_cpu(p->seq_num));
+	update_peer_seq(peer_device, be32_to_cpu(p->seq_num));
 
 	drbd_err(device, "Got NegDReply; Sector %llus, len %u.\n",
 	    (unsigned long long)sector, be32_to_cpu(p->blksize));
@@ -5137,7 +5160,7 @@ static int got_NegRSDReply(struct drbd_connection *connection, struct packet_inf
 	sector = be64_to_cpu(p->sector);
 	size = be32_to_cpu(p->blksize);
 
-	update_peer_seq(device, be32_to_cpu(p->seq_num));
+	update_peer_seq(peer_device, be32_to_cpu(p->seq_num));
 
 	dec_rs_pending(device);
 
@@ -5198,7 +5221,7 @@ static int got_OVResult(struct drbd_connection *connection, struct packet_info *
 	sector = be64_to_cpu(p->sector);
 	size = be32_to_cpu(p->blksize);
 
-	update_peer_seq(device, be32_to_cpu(p->seq_num));
+	update_peer_seq(peer_device, be32_to_cpu(p->seq_num));
 
 	if (be64_to_cpu(p->block_id) == ID_OUT_OF_SYNC)
 		drbd_ov_out_of_sync_found(device, sector, size);
diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index 56b4aee..1aef152 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -354,7 +354,7 @@ drbd_req_state(struct drbd_device *device, union drbd_state mask,
 			goto abort;
 		}
 
-		if (drbd_send_state_req(device, mask, val)) {
+		if (drbd_send_state_req(first_peer_device(device), mask, val)) {
 			rv = SS_CW_FAILED_BY_PEER;
 			if (f & CS_VERBOSE)
 				print_st_err(device, os, ns, rv);
@@ -1296,7 +1296,7 @@ static void after_state_ch(struct drbd_device *device, union drbd_state os,
 	if ((os.conn != C_SYNC_SOURCE && os.conn != C_PAUSED_SYNC_S) &&
 	    (ns.conn == C_SYNC_SOURCE || ns.conn == C_PAUSED_SYNC_S) &&
 	    first_peer_device(device)->connection->agreed_pro_version >= 96 && get_ldev(device)) {
-		drbd_gen_and_send_sync_uuid(device);
+		drbd_gen_and_send_sync_uuid(first_peer_device(device));
 		put_ldev(device);
 	}
 
@@ -1310,8 +1310,8 @@ static void after_state_ch(struct drbd_device *device, union drbd_state os,
 		atomic_set(&device->rs_pending_cnt, 0);
 		drbd_rs_cancel_all(device);
 
-		drbd_send_uuids(device);
-		drbd_send_state(device, ns);
+		drbd_send_uuids(first_peer_device(device));
+		drbd_send_state(first_peer_device(device), ns);
 	}
 	/* No point in queuing send_bitmap if we don't have a connection
 	 * anymore, so check also the _current_ state, not only the new state
@@ -1336,7 +1336,7 @@ static void after_state_ch(struct drbd_device *device, union drbd_state os,
 					set_bit(NEW_CUR_UUID, &device->flags);
 				} else {
 					drbd_uuid_new_current(device);
-					drbd_send_uuids(device);
+					drbd_send_uuids(first_peer_device(device));
 				}
 			}
 			put_ldev(device);
@@ -1347,7 +1347,7 @@ static void after_state_ch(struct drbd_device *device, union drbd_state os,
 		if (os.peer == R_SECONDARY && ns.peer == R_PRIMARY &&
 		    device->ldev->md.uuid[UI_BITMAP] == 0 && ns.disk >= D_UP_TO_DATE) {
 			drbd_uuid_new_current(device);
-			drbd_send_uuids(device);
+			drbd_send_uuids(first_peer_device(device));
 		}
 		/* D_DISKLESS Peer becomes secondary */
 		if (os.peer == R_PRIMARY && ns.peer == R_SECONDARY)
@@ -1374,16 +1374,16 @@ static void after_state_ch(struct drbd_device *device, union drbd_state os,
 	/* Last part of the attaching process ... */
 	if (ns.conn >= C_CONNECTED &&
 	    os.disk == D_ATTACHING && ns.disk == D_NEGOTIATING) {
-		drbd_send_sizes(device, 0, 0);  /* to start sync... */
-		drbd_send_uuids(device);
-		drbd_send_state(device, ns);
+		drbd_send_sizes(first_peer_device(device), 0, 0);  /* to start sync... */
+		drbd_send_uuids(first_peer_device(device));
+		drbd_send_state(first_peer_device(device), ns);
 	}
 
 	/* We want to pause/continue resync, tell peer. */
 	if (ns.conn >= C_CONNECTED &&
 	     ((os.aftr_isp != ns.aftr_isp) ||
 	      (os.user_isp != ns.user_isp)))
-		drbd_send_state(device, ns);
+		drbd_send_state(first_peer_device(device), ns);
 
 	/* In case one of the isp bits got set, suspend other devices. */
 	if ((!os.aftr_isp && !os.peer_isp && !os.user_isp) &&
@@ -1393,10 +1393,10 @@ static void after_state_ch(struct drbd_device *device, union drbd_state os,
 	/* Make sure the peer gets informed about eventual state
 	   changes (ISP bits) while we were in WFReportParams. */
 	if (os.conn == C_WF_REPORT_PARAMS && ns.conn >= C_CONNECTED)
-		drbd_send_state(device, ns);
+		drbd_send_state(first_peer_device(device), ns);
 
 	if (os.conn != C_AHEAD && ns.conn == C_AHEAD)
-		drbd_send_state(device, ns);
+		drbd_send_state(first_peer_device(device), ns);
 
 	/* We are in the progress to start a full sync... */
 	if ((os.conn != C_STARTING_SYNC_T && ns.conn == C_STARTING_SYNC_T) ||
@@ -1450,7 +1450,7 @@ static void after_state_ch(struct drbd_device *device, union drbd_state os,
 					drbd_disk_str(device->state.disk));
 
 			if (ns.conn >= C_CONNECTED)
-				drbd_send_state(device, ns);
+				drbd_send_state(first_peer_device(device), ns);
 
 			drbd_rs_cancel_all(device);
 
@@ -1474,7 +1474,7 @@ static void after_state_ch(struct drbd_device *device, union drbd_state os,
 				 drbd_disk_str(device->state.disk));
 
 		if (ns.conn >= C_CONNECTED)
-			drbd_send_state(device, ns);
+			drbd_send_state(first_peer_device(device), ns);
 		/* corresponding get_ldev in __drbd_set_state
 		 * this may finally trigger drbd_ldev_destroy. */
 		put_ldev(device);
@@ -1482,7 +1482,7 @@ static void after_state_ch(struct drbd_device *device, union drbd_state os,
 
 	/* Notify peer that I had a local IO error, and did not detached.. */
 	if (os.disk == D_UP_TO_DATE && ns.disk == D_INCONSISTENT && ns.conn >= C_CONNECTED)
-		drbd_send_state(device, ns);
+		drbd_send_state(first_peer_device(device), ns);
 
 	/* Disks got bigger while they were detached */
 	if (ns.disk > D_NEGOTIATING && ns.pdsk > D_NEGOTIATING &&
@@ -1500,14 +1500,14 @@ static void after_state_ch(struct drbd_device *device, union drbd_state os,
 	/* sync target done with resync.  Explicitly notify peer, even though
 	 * it should (at least for non-empty resyncs) already know itself. */
 	if (os.disk < D_UP_TO_DATE && os.conn >= C_SYNC_SOURCE && ns.conn == C_CONNECTED)
-		drbd_send_state(device, ns);
+		drbd_send_state(first_peer_device(device), ns);
 
 	/* Verify finished, or reached stop sector.  Peer did not know about
 	 * the stop sector, and we may even have changed the stop sector during
 	 * verify to interrupt/stop early.  Send the new state. */
 	if (os.conn == C_VERIFY_S && ns.conn == C_CONNECTED
 	&& verify_can_do_stop_sector(device))
-		drbd_send_state(device, ns);
+		drbd_send_state(first_peer_device(device), ns);
 
 	/* This triggers bitmap writeout of potentially still unwritten pages
 	 * if the resync finished cleanly, or aborted because of peer disk
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index cf40a8a..8aaec6c 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -358,7 +358,7 @@ static int w_e_send_csum(struct drbd_work *w, int cancel)
 		drbd_free_peer_req(device, peer_req);
 		peer_req = NULL;
 		inc_rs_pending(device);
-		err = drbd_send_drequest_csum(device, sector, size,
+		err = drbd_send_drequest_csum(first_peer_device(device), sector, size,
 					      digest, digest_size,
 					      P_CSUM_RS_REQUEST);
 		kfree(digest);
@@ -378,8 +378,9 @@ out:
 
 #define GFP_TRY	(__GFP_HIGHMEM | __GFP_NOWARN)
 
-static int read_for_csum(struct drbd_device *device, sector_t sector, int size)
+static int read_for_csum(struct drbd_peer_device *peer_device, sector_t sector, int size)
 {
+	struct drbd_device *device = peer_device->device;
 	struct drbd_peer_request *peer_req;
 
 	if (!get_ldev(device))
@@ -390,7 +391,7 @@ static int read_for_csum(struct drbd_device *device, sector_t sector, int size)
 
 	/* GFP_TRY, because if there is no memory available right now, this may
 	 * be rescheduled for later. It is "only" background resync, after all. */
-	peer_req = drbd_alloc_peer_req(device, ID_SYNCER /* unused */, sector,
+	peer_req = drbd_alloc_peer_req(peer_device, ID_SYNCER /* unused */, sector,
 				       size, GFP_TRY);
 	if (!peer_req)
 		goto defer;
@@ -676,7 +677,7 @@ next_sector:
 			size = (capacity-sector)<<9;
 		if (first_peer_device(device)->connection->agreed_pro_version >= 89 &&
 		    first_peer_device(device)->connection->csums_tfm) {
-			switch (read_for_csum(device, sector, size)) {
+			switch (read_for_csum(first_peer_device(device), sector, size)) {
 			case -EIO: /* Disk failure */
 				put_ldev(device);
 				return -EIO;
@@ -695,7 +696,7 @@ next_sector:
 			int err;
 
 			inc_rs_pending(device);
-			err = drbd_send_drequest(device, P_RS_DATA_REQUEST,
+			err = drbd_send_drequest(first_peer_device(device), P_RS_DATA_REQUEST,
 						 sector, size, ID_SYNCER);
 			if (err) {
 				drbd_err(device, "drbd_send_drequest() failed, aborting...\n");
@@ -763,7 +764,7 @@ static int w_make_ov_request(struct drbd_work *w, int cancel)
 			size = (capacity-sector)<<9;
 
 		inc_rs_pending(device);
-		if (drbd_send_ov_request(device, sector, size)) {
+		if (drbd_send_ov_request(first_peer_device(device), sector, size)) {
 			dec_rs_pending(device);
 			return 0;
 		}
@@ -997,13 +998,13 @@ int w_e_end_data_req(struct drbd_work *w, int cancel)
 	}
 
 	if (likely((peer_req->flags & EE_WAS_ERROR) == 0)) {
-		err = drbd_send_block(device, P_DATA_REPLY, peer_req);
+		err = drbd_send_block(first_peer_device(device), P_DATA_REPLY, peer_req);
 	} else {
 		if (__ratelimit(&drbd_ratelimit_state))
 			drbd_err(device, "Sending NegDReply. sector=%llus.\n",
 			    (unsigned long long)peer_req->i.sector);
 
-		err = drbd_send_ack(device, P_NEG_DREPLY, peer_req);
+		err = drbd_send_ack(first_peer_device(device), P_NEG_DREPLY, peer_req);
 	}
 
 	dec_unacked(device);
@@ -1039,11 +1040,11 @@ int w_e_end_rsdata_req(struct drbd_work *w, int cancel)
 	}
 
 	if (device->state.conn == C_AHEAD) {
-		err = drbd_send_ack(device, P_RS_CANCEL, peer_req);
+		err = drbd_send_ack(first_peer_device(device), P_RS_CANCEL, peer_req);
 	} else if (likely((peer_req->flags & EE_WAS_ERROR) == 0)) {
 		if (likely(device->state.pdsk >= D_INCONSISTENT)) {
 			inc_rs_pending(device);
-			err = drbd_send_block(device, P_RS_DATA_REPLY, peer_req);
+			err = drbd_send_block(first_peer_device(device), P_RS_DATA_REPLY, peer_req);
 		} else {
 			if (__ratelimit(&drbd_ratelimit_state))
 				drbd_err(device, "Not sending RSDataReply, "
@@ -1055,7 +1056,7 @@ int w_e_end_rsdata_req(struct drbd_work *w, int cancel)
 			drbd_err(device, "Sending NegRSDReply. sector %llus.\n",
 			    (unsigned long long)peer_req->i.sector);
 
-		err = drbd_send_ack(device, P_NEG_RS_DREPLY, peer_req);
+		err = drbd_send_ack(first_peer_device(device), P_NEG_RS_DREPLY, peer_req);
 
 		/* update resync data with failure */
 		drbd_rs_failed_io(device, peer_req->i.sector, peer_req->i.size);
@@ -1111,16 +1112,16 @@ int w_e_end_csum_rs_req(struct drbd_work *w, int cancel)
 			drbd_set_in_sync(device, peer_req->i.sector, peer_req->i.size);
 			/* rs_same_csums unit is BM_BLOCK_SIZE */
 			device->rs_same_csum += peer_req->i.size >> BM_BLOCK_SHIFT;
-			err = drbd_send_ack(device, P_RS_IS_IN_SYNC, peer_req);
+			err = drbd_send_ack(first_peer_device(device), P_RS_IS_IN_SYNC, peer_req);
 		} else {
 			inc_rs_pending(device);
 			peer_req->block_id = ID_SYNCER; /* By setting block_id, digest pointer becomes invalid! */
 			peer_req->flags &= ~EE_HAS_DIGEST; /* This peer request no longer has a digest pointer */
 			kfree(di);
-			err = drbd_send_block(device, P_RS_DATA_REPLY, peer_req);
+			err = drbd_send_block(first_peer_device(device), P_RS_DATA_REPLY, peer_req);
 		}
 	} else {
-		err = drbd_send_ack(device, P_NEG_RS_DREPLY, peer_req);
+		err = drbd_send_ack(first_peer_device(device), P_NEG_RS_DREPLY, peer_req);
 		if (__ratelimit(&drbd_ratelimit_state))
 			drbd_err(device, "Sending NegDReply. I guess it gets messy.\n");
 	}
@@ -1166,7 +1167,7 @@ int w_e_end_ov_req(struct drbd_work *w, int cancel)
 	drbd_free_peer_req(device, peer_req);
 	peer_req = NULL;
 	inc_rs_pending(device);
-	err = drbd_send_drequest_csum(device, sector, size, digest, digest_size, P_OV_REPLY);
+	err = drbd_send_drequest_csum(first_peer_device(device), sector, size, digest, digest_size, P_OV_REPLY);
 	if (err)
 		dec_rs_pending(device);
 	kfree(digest);
@@ -1239,7 +1240,7 @@ int w_e_end_ov_reply(struct drbd_work *w, int cancel)
 	else
 		ov_out_of_sync_print(device);
 
-	err = drbd_send_ack_ex(device, P_OV_RESULT, sector, size,
+	err = drbd_send_ack_ex(first_peer_device(device), P_OV_RESULT, sector, size,
 			       eq ? ID_IN_SYNC : ID_OUT_OF_SYNC);
 
 	dec_unacked(device);
@@ -1298,9 +1299,9 @@ int w_send_write_hint(struct drbd_work *w, int cancel)
 	if (cancel)
 		return 0;
 	sock = &first_peer_device(device)->connection->data;
-	if (!drbd_prepare_command(device, sock))
+	if (!drbd_prepare_command(first_peer_device(device), sock))
 		return -EIO;
-	return drbd_send_command(device, sock, P_UNPLUG_REMOTE, 0, NULL, 0);
+	return drbd_send_command(first_peer_device(device), sock, P_UNPLUG_REMOTE, 0, NULL, 0);
 }
 
 static void re_init_if_first_write(struct drbd_connection *connection, unsigned int epoch)
@@ -1342,7 +1343,7 @@ int w_send_out_of_sync(struct drbd_work *w, int cancel)
 	 * No more barriers will be sent, until we leave AHEAD mode again. */
 	maybe_send_barrier(connection, req->epoch);
 
-	err = drbd_send_out_of_sync(device, req);
+	err = drbd_send_out_of_sync(first_peer_device(device), req);
 	req_mod(req, OOS_HANDED_TO_NETWORK);
 
 	return err;
@@ -1370,7 +1371,7 @@ int w_send_dblock(struct drbd_work *w, int cancel)
 	maybe_send_barrier(connection, req->epoch);
 	connection->send.current_epoch_writes++;
 
-	err = drbd_send_dblock(device, req);
+	err = drbd_send_dblock(first_peer_device(device), req);
 	req_mod(req, err ? SEND_FAILED : HANDED_OVER_TO_NETWORK);
 
 	return err;
@@ -1398,7 +1399,7 @@ int w_send_read_req(struct drbd_work *w, int cancel)
 	 * if there was any yet. */
 	maybe_send_barrier(connection, req->epoch);
 
-	err = drbd_send_drequest(device, P_DATA_REQUEST, req->i.sector, req->i.size,
+	err = drbd_send_drequest(first_peer_device(device), P_DATA_REQUEST, req->i.sector, req->i.size,
 				 (unsigned long)req);
 
 	req_mod(req, err ? SEND_FAILED : HANDED_OVER_TO_NETWORK);
@@ -1730,7 +1731,7 @@ void drbd_start_resync(struct drbd_device *device, enum drbd_conns side)
 		 * and from after_state_ch otherwise. */
 		if (side == C_SYNC_SOURCE &&
 		    first_peer_device(device)->connection->agreed_pro_version < 96)
-			drbd_gen_and_send_sync_uuid(device);
+			drbd_gen_and_send_sync_uuid(first_peer_device(device));
 
 		if (first_peer_device(device)->connection->agreed_pro_version < 95 &&
 		    device->rs_total == 0) {
-- 
1.7.9.5

