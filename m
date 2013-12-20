Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932576Ab3LTMnO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 07:43:14 -0500
Received: from mail09.linbit.com ([212.69.161.110]:38637 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756301Ab3LTMje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 07:39:34 -0500
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 08/26] drbd: Introduce "peer_device" object between "device" and "connection"
Date: Fri, 20 Dec 2013 13:29:05 +0100
Message-Id: <1387542563-6833-9-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387542563-6833-1-git-send-email-philipp.reisner@linbit.com>
References: <1387542563-6833-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

In a setup where a device (aka volume) can replicate to multiple peers and one
connection can be shared between multiple devices, we need separate objects to
represent devices on peer nodes and network connections.

As a first step to introduce multiple connections per device, give each
drbd_device object a single drbd_peer_device object which connects it to a
drbd_connection object.

Signed-off-by: Andreas Gruenbacher <agruen@linbit.com>
Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
---
 drivers/block/drbd/drbd_actlog.c   |    8 +-
 drivers/block/drbd/drbd_bitmap.c   |    8 +-
 drivers/block/drbd/drbd_int.h      |   58 ++++++---
 drivers/block/drbd/drbd_main.c     |  156 ++++++++++++-----------
 drivers/block/drbd/drbd_nl.c       |   90 ++++++-------
 drivers/block/drbd/drbd_proc.c     |    6 +-
 drivers/block/drbd/drbd_receiver.c |  246 ++++++++++++++++++------------------
 drivers/block/drbd/drbd_req.c      |   48 +++----
 drivers/block/drbd/drbd_req.h      |    4 +-
 drivers/block/drbd/drbd_state.c    |   73 +++++------
 drivers/block/drbd/drbd_worker.c   |   96 +++++++-------
 11 files changed, 416 insertions(+), 377 deletions(-)

diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index d9905b0..5553219 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -314,7 +314,7 @@ void drbd_al_begin_io_commit(struct drbd_device *device, bool delegate)
 {
 	bool locked = false;
 
-	BUG_ON(delegate && current == device->connection->worker.task);
+	BUG_ON(delegate && current == first_peer_device(device)->connection->worker.task);
 
 	/* Serialize multiple transactions.
 	 * This uses test_and_set_bit, memory barrier is implicit.
@@ -353,7 +353,7 @@ void drbd_al_begin_io_commit(struct drbd_device *device, bool delegate)
  */
 void drbd_al_begin_io(struct drbd_device *device, struct drbd_interval *i, bool delegate)
 {
-	BUG_ON(delegate && current == device->connection->worker.task);
+	BUG_ON(delegate && current == first_peer_device(device)->connection->worker.task);
 
 	if (drbd_al_begin_io_prepare(device, i))
 		drbd_al_begin_io_commit(device, delegate);
@@ -613,7 +613,7 @@ static int al_write_transaction(struct drbd_device *device, bool delegate)
 		init_completion(&al_work.event);
 		al_work.w.cb = w_al_write_transaction;
 		al_work.w.device = device;
-		drbd_queue_work_front(&device->connection->sender_work, &al_work.w);
+		drbd_queue_work_front(&first_peer_device(device)->connection->sender_work, &al_work.w);
 		wait_for_completion(&al_work.event);
 		return al_work.err;
 	} else
@@ -795,7 +795,7 @@ static void drbd_try_clear_on_disk_bm(struct drbd_device *device, sector_t secto
 				udw->enr = ext->lce.lc_number;
 				udw->w.cb = w_update_odbm;
 				udw->w.device = device;
-				drbd_queue_work_front(&device->connection->sender_work, &udw->w);
+				drbd_queue_work_front(&first_peer_device(device)->connection->sender_work, &udw->w);
 			} else {
 				dev_warn(DEV, "Could not kmalloc an udw\n");
 			}
diff --git a/drivers/block/drbd/drbd_bitmap.c b/drivers/block/drbd/drbd_bitmap.c
index 5bd0db2..bc66d2a 100644
--- a/drivers/block/drbd/drbd_bitmap.c
+++ b/drivers/block/drbd/drbd_bitmap.c
@@ -119,9 +119,9 @@ static void __bm_print_lock_info(struct drbd_device *device, const char *func)
 	if (!__ratelimit(&drbd_ratelimit_state))
 		return;
 	dev_err(DEV, "FIXME %s in %s, bitmap locked for '%s' by %s\n",
-		drbd_task_to_thread_name(device->connection, current),
+		drbd_task_to_thread_name(first_peer_device(device)->connection, current),
 		func, b->bm_why ?: "?",
-		drbd_task_to_thread_name(device->connection, b->bm_task));
+		drbd_task_to_thread_name(first_peer_device(device)->connection, b->bm_task));
 }
 
 void drbd_bm_lock(struct drbd_device *device, char *why, enum bm_flag flags)
@@ -138,9 +138,9 @@ void drbd_bm_lock(struct drbd_device *device, char *why, enum bm_flag flags)
 
 	if (trylock_failed) {
 		dev_warn(DEV, "%s going to '%s' but bitmap already locked for '%s' by %s\n",
-			 drbd_task_to_thread_name(device->connection, current),
+			 drbd_task_to_thread_name(first_peer_device(device)->connection, current),
 			 why, b->bm_why ?: "?",
-			 drbd_task_to_thread_name(device->connection, b->bm_task));
+			 drbd_task_to_thread_name(first_peer_device(device)->connection, b->bm_task));
 		mutex_lock(&b->bm_change);
 	}
 	if (BM_LOCKED_MASK & b->bm_flags)
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index e6947bd..498bebd 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -478,7 +478,7 @@ struct drbd_backing_dev {
 	struct block_device *backing_bdev;
 	struct block_device *md_bdev;
 	struct drbd_md md;
-	struct disk_conf *disk_conf; /* RCU, for updates: device->connection->conf_update */
+	struct disk_conf *disk_conf; /* RCU, for updates: first_peer_device(device)->connection->conf_update */
 	sector_t known_size; /* last known size of that backing device */
 };
 
@@ -612,8 +612,14 @@ struct submit_worker {
 	struct list_head writes;
 };
 
-struct drbd_device {
+struct drbd_peer_device {
+	struct list_head peer_devices;
+	struct drbd_device *device;
 	struct drbd_connection *connection;
+};
+
+struct drbd_device {
+	struct list_head peer_devices;
 	int vnr;			/* volume number within the connection */
 	struct kref kref;
 
@@ -739,7 +745,7 @@ struct drbd_device {
 	struct bm_io_work bm_io_work;
 	u64 ed_uuid; /* UUID of the exposed data */
 	struct mutex own_state_mutex;
-	struct mutex *state_mutex; /* either own_state_mutex or device->connection->cstate_mutex */
+	struct mutex *state_mutex; /* either own_state_mutex or first_peer_device(device)->connection->cstate_mutex */
 	char congestion_reason;  /* Why we where congested... */
 	atomic_t rs_sect_in; /* for incoming resync data rate, SyncTarget */
 	atomic_t rs_sect_ev; /* for submitted resync data rate, both */
@@ -763,6 +769,20 @@ static inline struct drbd_device *minor_to_device(unsigned int minor)
 	return (struct drbd_device *)idr_find(&minors, minor);
 }
 
+static inline struct drbd_peer_device *first_peer_device(struct drbd_device *device)
+{
+	return list_first_entry(&device->peer_devices, struct drbd_peer_device, peer_devices);
+}
+
+#define for_each_peer_device(peer_device, device) \
+	list_for_each_entry(peer_device, &device->peer_devices, peer_devices)
+
+#define for_each_peer_device_rcu(peer_device, device) \
+	list_for_each_entry_rcu(peer_device, &device->peer_devices, peer_devices)
+
+#define for_each_peer_device_safe(peer_device, tmp, device) \
+	list_for_each_entry_safe(peer_device, tmp, &device->peer_devices, peer_devices)
+
 static inline unsigned int device_to_minor(struct drbd_device *device)
 {
 	return device->minor;
@@ -1149,7 +1169,7 @@ extern struct bio *bio_alloc_drbd(gfp_t gfp_mask);
 extern rwlock_t global_state_lock;
 
 extern int conn_lowest_minor(struct drbd_connection *connection);
-enum drbd_ret_code conn_new_minor(struct drbd_connection *connection, unsigned int minor, int vnr);
+enum drbd_ret_code drbd_create_minor(struct drbd_connection *connection, unsigned int minor, int vnr);
 extern void drbd_minor_destroy(struct kref *kref);
 
 extern int set_resource_options(struct drbd_connection *connection, struct res_opts *res_opts);
@@ -1270,7 +1290,7 @@ extern void conn_flush_workqueue(struct drbd_connection *connection);
 extern int drbd_connected(struct drbd_device *device);
 static inline void drbd_flush_workqueue(struct drbd_device *device)
 {
-	conn_flush_workqueue(device->connection);
+	conn_flush_workqueue(first_peer_device(device)->connection);
 }
 
 /* Yes, there is kernel_setsockopt, but only since 2.6.18.
@@ -1416,9 +1436,9 @@ static inline union drbd_state drbd_read_state(struct drbd_device *device)
 	union drbd_state rv;
 
 	rv.i = device->state.i;
-	rv.susp = device->connection->susp;
-	rv.susp_nod = device->connection->susp_nod;
-	rv.susp_fen = device->connection->susp_fen;
+	rv.susp = first_peer_device(device)->connection->susp;
+	rv.susp_nod = first_peer_device(device)->connection->susp_nod;
+	rv.susp_fen = first_peer_device(device)->connection->susp_fen;
 
 	return rv;
 }
@@ -1500,9 +1520,9 @@ static inline void drbd_chk_io_error_(struct drbd_device *device,
 {
 	if (error) {
 		unsigned long flags;
-		spin_lock_irqsave(&device->connection->req_lock, flags);
+		spin_lock_irqsave(&first_peer_device(device)->connection->req_lock, flags);
 		__drbd_chk_io_error_(device, forcedetach, where);
-		spin_unlock_irqrestore(&device->connection->req_lock, flags);
+		spin_unlock_irqrestore(&first_peer_device(device)->connection->req_lock, flags);
 	}
 }
 
@@ -1778,7 +1798,7 @@ static inline void put_ldev(struct drbd_device *device)
 		if (device->state.disk == D_FAILED) {
 			/* all application IO references gone. */
 			if (!test_and_set_bit(GO_DISKLESS, &device->flags))
-				drbd_queue_work(&device->connection->sender_work, &device->go_diskless);
+				drbd_queue_work(&first_peer_device(device)->connection->sender_work, &device->go_diskless);
 		}
 		wake_up(&device->misc_wait);
 	}
@@ -1860,7 +1880,7 @@ static inline int drbd_get_max_buffers(struct drbd_device *device)
 	int mxb;
 
 	rcu_read_lock();
-	nc = rcu_dereference(device->connection->net_conf);
+	nc = rcu_dereference(first_peer_device(device)->connection->net_conf);
 	mxb = nc ? nc->max_buffers : 1000000;  /* arbitrary limit on open requests */
 	rcu_read_unlock();
 
@@ -1903,7 +1923,7 @@ static inline int drbd_state_is_stable(struct drbd_device *device)
 
 		/* Allow IO in BM exchange states with new protocols */
 	case C_WF_BITMAP_S:
-		if (device->connection->agreed_pro_version < 96)
+		if (first_peer_device(device)->connection->agreed_pro_version < 96)
 			return 0;
 		break;
 
@@ -1939,7 +1959,7 @@ static inline int drbd_state_is_stable(struct drbd_device *device)
 
 static inline int drbd_suspended(struct drbd_device *device)
 {
-	struct drbd_connection *connection = device->connection;
+	struct drbd_connection *connection = first_peer_device(device)->connection;
 
 	return connection->susp || connection->susp_fen || connection->susp_nod;
 }
@@ -1974,11 +1994,11 @@ static inline bool inc_ap_bio_cond(struct drbd_device *device)
 {
 	bool rv = false;
 
-	spin_lock_irq(&device->connection->req_lock);
+	spin_lock_irq(&first_peer_device(device)->connection->req_lock);
 	rv = may_inc_ap_bio(device);
 	if (rv)
 		atomic_inc(&device->ap_bio_cnt);
-	spin_unlock_irq(&device->connection->req_lock);
+	spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
 
 	return rv;
 }
@@ -2005,7 +2025,7 @@ static inline void dec_ap_bio(struct drbd_device *device)
 
 	if (ap_bio == 0 && test_bit(BITMAP_IO, &device->flags)) {
 		if (!test_and_set_bit(BITMAP_IO_QUEUED, &device->flags))
-			drbd_queue_work(&device->connection->sender_work, &device->bm_io_work.w);
+			drbd_queue_work(&first_peer_device(device)->connection->sender_work, &device->bm_io_work.w);
 	}
 
 	/* this currently does wake_up for every dec_ap_bio!
@@ -2017,8 +2037,8 @@ static inline void dec_ap_bio(struct drbd_device *device)
 
 static inline bool verify_can_do_stop_sector(struct drbd_device *device)
 {
-	return device->connection->agreed_pro_version >= 97 &&
-		device->connection->agreed_pro_version != 100;
+	return first_peer_device(device)->connection->agreed_pro_version >= 97 &&
+		first_peer_device(device)->connection->agreed_pro_version != 100;
 }
 
 static inline int drbd_set_ed_uuid(struct drbd_device *device, u64 val)
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 04816aa..0c0cfa5 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -310,7 +310,7 @@ void tl_clear(struct drbd_connection *connection)
  */
 void tl_abort_disk_io(struct drbd_device *device)
 {
-	struct drbd_connection *connection = device->connection;
+	struct drbd_connection *connection = first_peer_device(device)->connection;
 	struct drbd_request *req, *r;
 
 	spin_lock_irq(&connection->req_lock);
@@ -635,7 +635,7 @@ void *conn_prepare_command(struct drbd_connection *connection, struct drbd_socke
 
 void *drbd_prepare_command(struct drbd_device *device, struct drbd_socket *sock)
 {
-	return conn_prepare_command(device->connection, sock);
+	return conn_prepare_command(first_peer_device(device)->connection, sock);
 }
 
 static int __send_command(struct drbd_connection *connection, int vnr,
@@ -688,7 +688,7 @@ int drbd_send_command(struct drbd_device *device, struct drbd_socket *sock,
 {
 	int err;
 
-	err = __send_command(device->connection, device->vnr, sock, cmd, header_size,
+	err = __send_command(first_peer_device(device)->connection, device->vnr, sock, cmd, header_size,
 			     data, size);
 	mutex_unlock(&sock->mutex);
 	return err;
@@ -719,18 +719,18 @@ int drbd_send_sync_param(struct drbd_device *device)
 	struct drbd_socket *sock;
 	struct p_rs_param_95 *p;
 	int size;
-	const int apv = device->connection->agreed_pro_version;
+	const int apv = first_peer_device(device)->connection->agreed_pro_version;
 	enum drbd_packet cmd;
 	struct net_conf *nc;
 	struct disk_conf *dc;
 
-	sock = &device->connection->data;
+	sock = &first_peer_device(device)->connection->data;
 	p = drbd_prepare_command(device, sock);
 	if (!p)
 		return -EIO;
 
 	rcu_read_lock();
-	nc = rcu_dereference(device->connection->net_conf);
+	nc = rcu_dereference(first_peer_device(device)->connection->net_conf);
 
 	size = apv <= 87 ? sizeof(struct p_rs_param)
 		: apv == 88 ? sizeof(struct p_rs_param)
@@ -833,7 +833,7 @@ int _drbd_send_uuids(struct drbd_device *device, u64 uuid_flags)
 	if (!get_ldev_if_state(device, D_NEGOTIATING))
 		return 0;
 
-	sock = &device->connection->data;
+	sock = &first_peer_device(device)->connection->data;
 	p = drbd_prepare_command(device, sock);
 	if (!p) {
 		put_ldev(device);
@@ -847,7 +847,7 @@ int _drbd_send_uuids(struct drbd_device *device, u64 uuid_flags)
 	device->comm_bm_set = drbd_bm_total_weight(device);
 	p->uuid[UI_SIZE] = cpu_to_be64(device->comm_bm_set);
 	rcu_read_lock();
-	uuid_flags |= rcu_dereference(device->connection->net_conf)->discard_my_data ? 1 : 0;
+	uuid_flags |= rcu_dereference(first_peer_device(device)->connection->net_conf)->discard_my_data ? 1 : 0;
 	rcu_read_unlock();
 	uuid_flags |= test_bit(CRASHED_PRIMARY, &device->flags) ? 2 : 0;
 	uuid_flags |= device->new_state_tmp.disk == D_INCONSISTENT ? 4 : 0;
@@ -902,7 +902,7 @@ void drbd_gen_and_send_sync_uuid(struct drbd_device *device)
 	drbd_print_uuids(device, "updated sync UUID");
 	drbd_md_sync(device);
 
-	sock = &device->connection->data;
+	sock = &first_peer_device(device)->connection->data;
 	p = drbd_prepare_command(device, sock);
 	if (p) {
 		p->uuid = cpu_to_be64(uuid);
@@ -935,14 +935,14 @@ int drbd_send_sizes(struct drbd_device *device, int trigger_reply, enum dds_flag
 		max_bio_size = DRBD_MAX_BIO_SIZE; /* ... multiple BIOs per peer_request */
 	}
 
-	sock = &device->connection->data;
+	sock = &first_peer_device(device)->connection->data;
 	p = drbd_prepare_command(device, sock);
 	if (!p)
 		return -EIO;
 
-	if (device->connection->agreed_pro_version <= 94)
+	if (first_peer_device(device)->connection->agreed_pro_version <= 94)
 		max_bio_size = min(max_bio_size, DRBD_MAX_SIZE_H80_PACKET);
-	else if (device->connection->agreed_pro_version < 100)
+	else if (first_peer_device(device)->connection->agreed_pro_version < 100)
 		max_bio_size = min(max_bio_size, DRBD_MAX_BIO_SIZE_P95);
 
 	p->d_size = cpu_to_be64(d_size);
@@ -963,7 +963,7 @@ int drbd_send_current_state(struct drbd_device *device)
 	struct drbd_socket *sock;
 	struct p_state *p;
 
-	sock = &device->connection->data;
+	sock = &first_peer_device(device)->connection->data;
 	p = drbd_prepare_command(device, sock);
 	if (!p)
 		return -EIO;
@@ -986,7 +986,7 @@ int drbd_send_state(struct drbd_device *device, union drbd_state state)
 	struct drbd_socket *sock;
 	struct p_state *p;
 
-	sock = &device->connection->data;
+	sock = &first_peer_device(device)->connection->data;
 	p = drbd_prepare_command(device, sock);
 	if (!p)
 		return -EIO;
@@ -999,7 +999,7 @@ int drbd_send_state_req(struct drbd_device *device, union drbd_state mask, union
 	struct drbd_socket *sock;
 	struct p_req_state *p;
 
-	sock = &device->connection->data;
+	sock = &first_peer_device(device)->connection->data;
 	p = drbd_prepare_command(device, sock);
 	if (!p)
 		return -EIO;
@@ -1029,7 +1029,7 @@ void drbd_send_sr_reply(struct drbd_device *device, enum drbd_state_rv retcode)
 	struct drbd_socket *sock;
 	struct p_req_state_reply *p;
 
-	sock = &device->connection->meta;
+	sock = &first_peer_device(device)->connection->meta;
 	p = drbd_prepare_command(device, sock);
 	if (p) {
 		p->retcode = cpu_to_be32(retcode);
@@ -1083,9 +1083,9 @@ int fill_bitmap_rle_bits(struct drbd_device *device,
 
 	/* may we use this feature? */
 	rcu_read_lock();
-	use_rle = rcu_dereference(device->connection->net_conf)->use_rle;
+	use_rle = rcu_dereference(first_peer_device(device)->connection->net_conf)->use_rle;
 	rcu_read_unlock();
-	if (!use_rle || device->connection->agreed_pro_version < 90)
+	if (!use_rle || first_peer_device(device)->connection->agreed_pro_version < 90)
 		return 0;
 
 	if (c->bit_offset >= c->bm_bits)
@@ -1174,8 +1174,8 @@ int fill_bitmap_rle_bits(struct drbd_device *device,
 static int
 send_bitmap_rle_or_plain(struct drbd_device *device, struct bm_xfer_ctx *c)
 {
-	struct drbd_socket *sock = &device->connection->data;
-	unsigned int header_size = drbd_header_size(device->connection);
+	struct drbd_socket *sock = &first_peer_device(device)->connection->data;
+	unsigned int header_size = drbd_header_size(first_peer_device(device)->connection);
 	struct p_compressed_bm *p = sock->sbuf + header_size;
 	int len, err;
 
@@ -1186,7 +1186,7 @@ send_bitmap_rle_or_plain(struct drbd_device *device, struct bm_xfer_ctx *c)
 
 	if (len) {
 		dcbp_set_code(p, RLE_VLI_Bits);
-		err = __send_command(device->connection, device->vnr, sock,
+		err = __send_command(first_peer_device(device)->connection, device->vnr, sock,
 				     P_COMPRESSED_BITMAP, sizeof(*p) + len,
 				     NULL, 0);
 		c->packets[0]++;
@@ -1207,7 +1207,7 @@ send_bitmap_rle_or_plain(struct drbd_device *device, struct bm_xfer_ctx *c)
 		len = num_words * sizeof(*p);
 		if (len)
 			drbd_bm_get_lel(device, c->word_offset, num_words, p);
-		err = __send_command(device->connection, device->vnr, sock, P_BITMAP, len, NULL, 0);
+		err = __send_command(first_peer_device(device)->connection, device->vnr, sock, P_BITMAP, len, NULL, 0);
 		c->word_offset += num_words;
 		c->bit_offset = c->word_offset * BITS_PER_LONG;
 
@@ -1267,7 +1267,7 @@ static int _drbd_send_bitmap(struct drbd_device *device)
 
 int drbd_send_bitmap(struct drbd_device *device)
 {
-	struct drbd_socket *sock = &device->connection->data;
+	struct drbd_socket *sock = &first_peer_device(device)->connection->data;
 	int err = -1;
 
 	mutex_lock(&sock->mutex);
@@ -1311,7 +1311,7 @@ static int _drbd_send_ack(struct drbd_device *device, enum drbd_packet cmd,
 	if (device->state.conn < C_CONNECTED)
 		return -EIO;
 
-	sock = &device->connection->meta;
+	sock = &first_peer_device(device)->connection->meta;
 	p = drbd_prepare_command(device, sock);
 	if (!p)
 		return -EIO;
@@ -1328,8 +1328,8 @@ static int _drbd_send_ack(struct drbd_device *device, enum drbd_packet cmd,
 void drbd_send_ack_dp(struct drbd_device *device, enum drbd_packet cmd,
 		      struct p_data *dp, int data_size)
 {
-	if (device->connection->peer_integrity_tfm)
-		data_size -= crypto_hash_digestsize(device->connection->peer_integrity_tfm);
+	if (first_peer_device(device)->connection->peer_integrity_tfm)
+		data_size -= crypto_hash_digestsize(first_peer_device(device)->connection->peer_integrity_tfm);
 	_drbd_send_ack(device, cmd, dp->sector, cpu_to_be32(data_size),
 		       dp->block_id);
 }
@@ -1372,7 +1372,7 @@ int drbd_send_drequest(struct drbd_device *device, int cmd,
 	struct drbd_socket *sock;
 	struct p_block_req *p;
 
-	sock = &device->connection->data;
+	sock = &first_peer_device(device)->connection->data;
 	p = drbd_prepare_command(device, sock);
 	if (!p)
 		return -EIO;
@@ -1390,7 +1390,7 @@ int drbd_send_drequest_csum(struct drbd_device *device, sector_t sector, int siz
 
 	/* FIXME: Put the digest into the preallocated socket buffer.  */
 
-	sock = &device->connection->data;
+	sock = &first_peer_device(device)->connection->data;
 	p = drbd_prepare_command(device, sock);
 	if (!p)
 		return -EIO;
@@ -1406,7 +1406,7 @@ int drbd_send_ov_request(struct drbd_device *device, sector_t sector, int size)
 	struct drbd_socket *sock;
 	struct p_block_req *p;
 
-	sock = &device->connection->data;
+	sock = &first_peer_device(device)->connection->data;
 	p = drbd_prepare_command(device, sock);
 	if (!p)
 		return -EIO;
@@ -1478,9 +1478,9 @@ static int _drbd_no_send_page(struct drbd_device *device, struct page *page,
 	void *addr;
 	int err;
 
-	socket = device->connection->data.socket;
+	socket = first_peer_device(device)->connection->data.socket;
 	addr = kmap(page) + offset;
-	err = drbd_send_all(device->connection, socket, addr, size, msg_flags);
+	err = drbd_send_all(first_peer_device(device)->connection, socket, addr, size, msg_flags);
 	kunmap(page);
 	if (!err)
 		device->send_cnt += size >> 9;
@@ -1490,7 +1490,7 @@ static int _drbd_no_send_page(struct drbd_device *device, struct page *page,
 static int _drbd_send_page(struct drbd_device *device, struct page *page,
 		    int offset, size_t size, unsigned msg_flags)
 {
-	struct socket *socket = device->connection->data.socket;
+	struct socket *socket = first_peer_device(device)->connection->data.socket;
 	mm_segment_t oldfs = get_fs();
 	int len = size;
 	int err = -EIO;
@@ -1505,7 +1505,7 @@ static int _drbd_send_page(struct drbd_device *device, struct page *page,
 		return _drbd_no_send_page(device, page, offset, size, msg_flags);
 
 	msg_flags |= MSG_NOSIGNAL;
-	drbd_update_congested(device->connection);
+	drbd_update_congested(first_peer_device(device)->connection);
 	set_fs(KERNEL_DS);
 	do {
 		int sent;
@@ -1513,7 +1513,7 @@ static int _drbd_send_page(struct drbd_device *device, struct page *page,
 		sent = socket->ops->sendpage(socket, page, offset, len, msg_flags);
 		if (sent <= 0) {
 			if (sent == -EAGAIN) {
-				if (we_should_drop_the_connection(device->connection, socket))
+				if (we_should_drop_the_connection(first_peer_device(device)->connection, socket))
 					break;
 				continue;
 			}
@@ -1527,7 +1527,7 @@ static int _drbd_send_page(struct drbd_device *device, struct page *page,
 		offset += sent;
 	} while (len > 0 /* THINK && device->cstate >= C_CONNECTED*/);
 	set_fs(oldfs);
-	clear_bit(NET_CONGESTED, &device->connection->flags);
+	clear_bit(NET_CONGESTED, &first_peer_device(device)->connection->flags);
 
 	if (len == 0) {
 		err = 0;
@@ -1595,7 +1595,7 @@ static int _drbd_send_zc_ee(struct drbd_device *device,
 
 static u32 bio_flags_to_wire(struct drbd_device *device, unsigned long bi_rw)
 {
-	if (device->connection->agreed_pro_version >= 95)
+	if (first_peer_device(device)->connection->agreed_pro_version >= 95)
 		return  (bi_rw & REQ_SYNC ? DP_RW_SYNC : 0) |
 			(bi_rw & REQ_FUA ? DP_FUA : 0) |
 			(bi_rw & REQ_FLUSH ? DP_FLUSH : 0) |
@@ -1615,9 +1615,10 @@ int drbd_send_dblock(struct drbd_device *device, struct drbd_request *req)
 	int dgs;
 	int err;
 
-	sock = &device->connection->data;
+	sock = &first_peer_device(device)->connection->data;
 	p = drbd_prepare_command(device, sock);
-	dgs = device->connection->integrity_tfm ? crypto_hash_digestsize(device->connection->integrity_tfm) : 0;
+	dgs = first_peer_device(device)->connection->integrity_tfm ?
+	      crypto_hash_digestsize(first_peer_device(device)->connection->integrity_tfm) : 0;
 
 	if (!p)
 		return -EIO;
@@ -1628,7 +1629,7 @@ int drbd_send_dblock(struct drbd_device *device, struct drbd_request *req)
 	if (device->state.conn >= C_SYNC_SOURCE &&
 	    device->state.conn <= C_PAUSED_SYNC_T)
 		dp_flags |= DP_MAY_SET_IN_SYNC;
-	if (device->connection->agreed_pro_version >= 100) {
+	if (first_peer_device(device)->connection->agreed_pro_version >= 100) {
 		if (req->rq_state & RQ_EXP_RECEIVE_ACK)
 			dp_flags |= DP_SEND_RECEIVE_ACK;
 		if (req->rq_state & RQ_EXP_WRITE_ACK)
@@ -1636,8 +1637,8 @@ int drbd_send_dblock(struct drbd_device *device, struct drbd_request *req)
 	}
 	p->dp_flags = cpu_to_be32(dp_flags);
 	if (dgs)
-		drbd_csum_bio(device, device->connection->integrity_tfm, req->master_bio, p + 1);
-	err = __send_command(device->connection, device->vnr, sock, P_DATA, sizeof(*p) + dgs, NULL, req->i.size);
+		drbd_csum_bio(device, first_peer_device(device)->connection->integrity_tfm, req->master_bio, p + 1);
+	err = __send_command(first_peer_device(device)->connection, device->vnr, sock, P_DATA, sizeof(*p) + dgs, NULL, req->i.size);
 	if (!err) {
 		/* For protocol A, we have to memcpy the payload into
 		 * socket buffers, as we may complete right away
@@ -1660,7 +1661,7 @@ int drbd_send_dblock(struct drbd_device *device, struct drbd_request *req)
 			/* 64 byte, 512 bit, is the largest digest size
 			 * currently supported in kernel crypto. */
 			unsigned char digest[64];
-			drbd_csum_bio(device, device->connection->integrity_tfm, req->master_bio, digest);
+			drbd_csum_bio(device, first_peer_device(device)->connection->integrity_tfm, req->master_bio, digest);
 			if (memcmp(p + 1, digest, dgs)) {
 				dev_warn(DEV,
 					"Digest mismatch, buffer modified by upper layers during write: %llus +%u\n",
@@ -1687,10 +1688,11 @@ int drbd_send_block(struct drbd_device *device, enum drbd_packet cmd,
 	int err;
 	int dgs;
 
-	sock = &device->connection->data;
+	sock = &first_peer_device(device)->connection->data;
 	p = drbd_prepare_command(device, sock);
 
-	dgs = device->connection->integrity_tfm ? crypto_hash_digestsize(device->connection->integrity_tfm) : 0;
+	dgs = first_peer_device(device)->connection->integrity_tfm ?
+	      crypto_hash_digestsize(first_peer_device(device)->connection->integrity_tfm) : 0;
 
 	if (!p)
 		return -EIO;
@@ -1699,8 +1701,8 @@ int drbd_send_block(struct drbd_device *device, enum drbd_packet cmd,
 	p->seq_num = 0;  /* unused */
 	p->dp_flags = 0;
 	if (dgs)
-		drbd_csum_ee(device, device->connection->integrity_tfm, peer_req, p + 1);
-	err = __send_command(device->connection, device->vnr, sock, cmd, sizeof(*p) + dgs, NULL, peer_req->i.size);
+		drbd_csum_ee(device, first_peer_device(device)->connection->integrity_tfm, peer_req, p + 1);
+	err = __send_command(first_peer_device(device)->connection, device->vnr, sock, cmd, sizeof(*p) + dgs, NULL, peer_req->i.size);
 	if (!err)
 		err = _drbd_send_zc_ee(device, peer_req);
 	mutex_unlock(&sock->mutex);  /* locked by drbd_prepare_command() */
@@ -1713,7 +1715,7 @@ int drbd_send_out_of_sync(struct drbd_device *device, struct drbd_request *req)
 	struct drbd_socket *sock;
 	struct p_block_desc *p;
 
-	sock = &device->connection->data;
+	sock = &first_peer_device(device)->connection->data;
 	p = drbd_prepare_command(device, sock);
 	if (!p)
 		return -EIO;
@@ -1834,7 +1836,7 @@ static int drbd_open(struct block_device *bdev, fmode_t mode)
 	int rv = 0;
 
 	mutex_lock(&drbd_main_mutex);
-	spin_lock_irqsave(&device->connection->req_lock, flags);
+	spin_lock_irqsave(&first_peer_device(device)->connection->req_lock, flags);
 	/* to have a stable device->state.role
 	 * and no race with updating open_cnt */
 
@@ -1847,7 +1849,7 @@ static int drbd_open(struct block_device *bdev, fmode_t mode)
 
 	if (!rv)
 		device->open_cnt++;
-	spin_unlock_irqrestore(&device->connection->req_lock, flags);
+	spin_unlock_irqrestore(&first_peer_device(device)->connection->req_lock, flags);
 	mutex_unlock(&drbd_main_mutex);
 
 	return rv;
@@ -1952,9 +1954,9 @@ void drbd_init_set_defaults(struct drbd_device *device)
 void drbd_device_cleanup(struct drbd_device *device)
 {
 	int i;
-	if (device->connection->receiver.t_state != NONE)
+	if (first_peer_device(device)->connection->receiver.t_state != NONE)
 		dev_err(DEV, "ASSERT FAILED: receiver t_state == %d expected 0.\n",
-				device->connection->receiver.t_state);
+				first_peer_device(device)->connection->receiver.t_state);
 
 	device->al_writ_cnt  =
 	device->bm_writ_cnt  =
@@ -1972,7 +1974,7 @@ void drbd_device_cleanup(struct drbd_device *device)
 		device->rs_mark_left[i] = 0;
 		device->rs_mark_time[i] = 0;
 	}
-	D_ASSERT(device->connection->net_conf == NULL);
+	D_ASSERT(first_peer_device(device)->connection->net_conf == NULL);
 
 	drbd_set_my_capacity(device, 0);
 	if (device->bitmap) {
@@ -1992,7 +1994,7 @@ void drbd_device_cleanup(struct drbd_device *device)
 	D_ASSERT(list_empty(&device->read_ee));
 	D_ASSERT(list_empty(&device->net_ee));
 	D_ASSERT(list_empty(&device->resync_reads));
-	D_ASSERT(list_empty(&device->connection->sender_work.q));
+	D_ASSERT(list_empty(&first_peer_device(device)->connection->sender_work.q));
 	D_ASSERT(list_empty(&device->resync_work.list));
 	D_ASSERT(list_empty(&device->unplug_work.list));
 	D_ASSERT(list_empty(&device->go_diskless.list));
@@ -2161,7 +2163,7 @@ static void drbd_release_all_peer_reqs(struct drbd_device *device)
 void drbd_minor_destroy(struct kref *kref)
 {
 	struct drbd_device *device = container_of(kref, struct drbd_device, kref);
-	struct drbd_connection *connection = device->connection;
+	struct drbd_connection *connection = first_peer_device(device)->connection;
 
 	del_timer_sync(&device->request_timer);
 
@@ -2192,6 +2194,7 @@ void drbd_minor_destroy(struct kref *kref)
 	put_disk(device->vdisk);
 	blk_cleanup_queue(device->rq_queue);
 	kfree(device->rs_plan_s);
+	kfree(first_peer_device(device));
 	kfree(device);
 
 	kref_put(&connection->kref, &conn_destroy);
@@ -2302,7 +2305,7 @@ static void drbd_cleanup(void)
 
 	idr_for_each_entry(&minors, device, i) {
 		idr_remove(&minors, device_to_minor(device));
-		idr_remove(&device->connection->volumes, device->vnr);
+		idr_remove(&first_peer_device(device)->connection->volumes, device->vnr);
 		destroy_workqueue(device->submit.wq);
 		del_gendisk(device->vdisk);
 		/* synchronize_rcu(); No other threads running at this point */
@@ -2345,7 +2348,7 @@ static int drbd_congested(void *congested_data, int bdi_bits)
 		goto out;
 	}
 
-	if (test_bit(CALLBACK_PENDING, &device->connection->flags)) {
+	if (test_bit(CALLBACK_PENDING, &first_peer_device(device)->connection->flags)) {
 		r |= (1 << BDI_async_congested);
 		/* Without good local data, we would need to read from remote,
 		 * and that would need the worker thread as well, which is
@@ -2369,7 +2372,8 @@ static int drbd_congested(void *congested_data, int bdi_bits)
 			reason = 'b';
 	}
 
-	if (bdi_bits & (1 << BDI_async_congested) && test_bit(NET_CONGESTED, &device->connection->flags)) {
+	if (bdi_bits & (1 << BDI_async_congested) &&
+	    test_bit(NET_CONGESTED, &first_peer_device(device)->connection->flags)) {
 		r |= (1 << BDI_async_congested);
 		reason = reason == 'b' ? 'a' : 'n';
 	}
@@ -2608,9 +2612,10 @@ int init_submitter(struct drbd_device *device)
 	return 0;
 }
 
-enum drbd_ret_code conn_new_minor(struct drbd_connection *connection, unsigned int minor, int vnr)
+enum drbd_ret_code drbd_create_minor(struct drbd_connection *connection, unsigned int minor, int vnr)
 {
 	struct drbd_device *device;
+	struct drbd_peer_device *peer_device;
 	struct gendisk *disk;
 	struct request_queue *q;
 	int vnr_got = vnr;
@@ -2625,9 +2630,15 @@ enum drbd_ret_code conn_new_minor(struct drbd_connection *connection, unsigned i
 	device = kzalloc(sizeof(struct drbd_device), GFP_KERNEL);
 	if (!device)
 		return ERR_NOMEM;
+	peer_device = kzalloc(sizeof(struct drbd_peer_device), GFP_KERNEL);
+	if (!peer_device)
+		goto out_no_peer_device;
 
+	INIT_LIST_HEAD(&device->peer_devices);
+	list_add(&peer_device->peer_devices, &device->peer_devices);
 	kref_get(&connection->kref);
-	device->connection = connection;
+	peer_device->connection = connection;
+	peer_device->device = device;
 
 	device->minor = minor;
 	device->vnr = vnr;
@@ -2668,7 +2679,7 @@ enum drbd_ret_code conn_new_minor(struct drbd_connection *connection, unsigned i
 	blk_queue_max_hw_sectors(q, DRBD_MAX_BIO_SIZE_SAFE >> 8);
 	blk_queue_bounce_limit(q, BLK_BOUNCE_ANY);
 	blk_queue_merge_bvec(q, drbd_merge_bvec);
-	q->queue_lock = &device->connection->req_lock; /* needed since we use */
+	q->queue_lock = &first_peer_device(device)->connection->req_lock; /* needed since we use */
 
 	device->md_io_page = alloc_page(GFP_KERNEL);
 	if (!device->md_io_page)
@@ -2727,8 +2738,9 @@ out_no_io_page:
 out_no_disk:
 	blk_cleanup_queue(q);
 out_no_q:
-	kfree(device);
 	kref_put(&connection->kref, &conn_destroy);
+out_no_peer_device:
+	kfree(device);
 	return err;
 }
 
@@ -3174,14 +3186,14 @@ int drbd_md_read(struct drbd_device *device, struct drbd_backing_dev *bdev)
 
 	rv = NO_ERROR;
 
-	spin_lock_irq(&device->connection->req_lock);
+	spin_lock_irq(&first_peer_device(device)->connection->req_lock);
 	if (device->state.conn < C_CONNECTED) {
 		unsigned int peer;
 		peer = be32_to_cpu(buffer->la_peer_max_bio_size);
 		peer = max(peer, DRBD_MAX_BIO_SIZE_SAFE);
 		device->peer_max_bio_size = peer;
 	}
-	spin_unlock_irq(&device->connection->req_lock);
+	spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
 
  err:
 	drbd_md_put_buffer(device);
@@ -3456,7 +3468,7 @@ void drbd_queue_bitmap_io(struct drbd_device *device,
 			  void (*done)(struct drbd_device *, int),
 			  char *why, enum bm_flag flags)
 {
-	D_ASSERT(current == device->connection->worker.task);
+	D_ASSERT(current == first_peer_device(device)->connection->worker.task);
 
 	D_ASSERT(!test_bit(BITMAP_IO_QUEUED, &device->flags));
 	D_ASSERT(!test_bit(BITMAP_IO, &device->flags));
@@ -3470,13 +3482,13 @@ void drbd_queue_bitmap_io(struct drbd_device *device,
 	device->bm_io_work.why = why;
 	device->bm_io_work.flags = flags;
 
-	spin_lock_irq(&device->connection->req_lock);
+	spin_lock_irq(&first_peer_device(device)->connection->req_lock);
 	set_bit(BITMAP_IO, &device->flags);
 	if (atomic_read(&device->ap_bio_cnt) == 0) {
 		if (!test_and_set_bit(BITMAP_IO_QUEUED, &device->flags))
-			drbd_queue_work(&device->connection->sender_work, &device->bm_io_work.w);
+			drbd_queue_work(&first_peer_device(device)->connection->sender_work, &device->bm_io_work.w);
 	}
-	spin_unlock_irq(&device->connection->req_lock);
+	spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
 }
 
 /**
@@ -3493,7 +3505,7 @@ int drbd_bitmap_io(struct drbd_device *device, int (*io_fn)(struct drbd_device *
 {
 	int rv;
 
-	D_ASSERT(current != device->connection->worker.task);
+	D_ASSERT(current != first_peer_device(device)->connection->worker.task);
 
 	if ((flags & BM_LOCKED_SET_ALLOWED) == 0)
 		drbd_suspend_io(device);
@@ -3534,7 +3546,7 @@ static void md_sync_timer_fn(unsigned long data)
 
 	/* must not double-queue! */
 	if (list_empty(&device->md_sync_work.list))
-		drbd_queue_work_front(&device->connection->sender_work, &device->md_sync_work);
+		drbd_queue_work_front(&first_peer_device(device)->connection->sender_work, &device->md_sync_work);
 }
 
 static int w_md_sync(struct drbd_work *w, int unused)
@@ -3633,7 +3645,7 @@ int drbd_wait_misc(struct drbd_device *device, struct drbd_interval *i)
 	long timeout;
 
 	rcu_read_lock();
-	nc = rcu_dereference(device->connection->net_conf);
+	nc = rcu_dereference(first_peer_device(device)->connection->net_conf);
 	if (!nc) {
 		rcu_read_unlock();
 		return -ETIMEDOUT;
@@ -3644,10 +3656,10 @@ int drbd_wait_misc(struct drbd_device *device, struct drbd_interval *i)
 	/* Indicate to wake up device->misc_wait on progress.  */
 	i->waiting = true;
 	prepare_to_wait(&device->misc_wait, &wait, TASK_INTERRUPTIBLE);
-	spin_unlock_irq(&device->connection->req_lock);
+	spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
 	timeout = schedule_timeout(timeout);
 	finish_wait(&device->misc_wait, &wait);
-	spin_lock_irq(&device->connection->req_lock);
+	spin_lock_irq(&first_peer_device(device)->connection->req_lock);
 	if (!timeout || device->state.conn < C_CONNECTED)
 		return -ETIMEDOUT;
 	if (signal_pending(current))
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index ae5ad9b..9e89f8c 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -246,10 +246,10 @@ static int drbd_adm_prepare(struct sk_buff *skb, struct genl_info *info,
 
 	/* some more paranoia, if the request was over-determined */
 	if (adm_ctx.device && adm_ctx.connection &&
-	    adm_ctx.device->connection != adm_ctx.connection) {
+	    first_peer_device(adm_ctx.device)->connection != adm_ctx.connection) {
 		pr_warning("request: minor=%u, resource=%s; but that minor belongs to connection %s\n",
 				adm_ctx.minor, adm_ctx.resource_name,
-				adm_ctx.device->connection->name);
+				first_peer_device(adm_ctx.device)->connection->name);
 		drbd_msg_put_info("minor exists in different resource");
 		return ERR_INVALID_REQUEST;
 	}
@@ -258,7 +258,7 @@ static int drbd_adm_prepare(struct sk_buff *skb, struct genl_info *info,
 	    adm_ctx.volume != adm_ctx.device->vnr) {
 		pr_warning("request: minor=%u, volume=%u; but that minor is volume %u in %s\n",
 				adm_ctx.minor, adm_ctx.volume,
-				adm_ctx.device->vnr, adm_ctx.device->connection->name);
+				adm_ctx.device->vnr, first_peer_device(adm_ctx.device)->connection->name);
 		drbd_msg_put_info("minor exists as different volume");
 		return ERR_INVALID_REQUEST;
 	}
@@ -323,7 +323,7 @@ int drbd_khelper(struct drbd_device *device, char *cmd)
 			NULL };
 	char mb[12];
 	char *argv[] = {usermode_helper, cmd, mb, NULL };
-	struct drbd_connection *connection = device->connection;
+	struct drbd_connection *connection = first_peer_device(device)->connection;
 	struct sib_info sib;
 	int ret;
 
@@ -544,7 +544,7 @@ drbd_set_role(struct drbd_device *device, enum drbd_role new_role, int force)
 	union drbd_state mask, val;
 
 	if (new_role == R_PRIMARY)
-		request_ping(device->connection); /* Detect a dead peer ASAP */
+		request_ping(first_peer_device(device)->connection); /* Detect a dead peer ASAP */
 
 	mutex_lock(device->state_mutex);
 
@@ -575,7 +575,7 @@ drbd_set_role(struct drbd_device *device, enum drbd_role new_role, int force)
 		    device->state.disk == D_CONSISTENT && mask.pdsk == 0) {
 			D_ASSERT(device->state.pdsk == D_UNKNOWN);
 
-			if (conn_try_outdate_peer(device->connection)) {
+			if (conn_try_outdate_peer(first_peer_device(device)->connection)) {
 				val.disk = D_UP_TO_DATE;
 				mask.disk = D_MASK;
 			}
@@ -585,7 +585,7 @@ drbd_set_role(struct drbd_device *device, enum drbd_role new_role, int force)
 		if (rv == SS_NOTHING_TO_DO)
 			goto out;
 		if (rv == SS_PRIMARY_NOP && mask.pdsk == 0) {
-			if (!conn_try_outdate_peer(device->connection) && force) {
+			if (!conn_try_outdate_peer(first_peer_device(device)->connection) && force) {
 				dev_warn(DEV, "Forced into split brain situation!\n");
 				mask.pdsk = D_MASK;
 				val.pdsk  = D_OUTDATED;
@@ -598,7 +598,7 @@ drbd_set_role(struct drbd_device *device, enum drbd_role new_role, int force)
 			   retry at most once more in this case. */
 			int timeo;
 			rcu_read_lock();
-			nc = rcu_dereference(device->connection->net_conf);
+			nc = rcu_dereference(first_peer_device(device)->connection->net_conf);
 			timeo = nc ? (nc->ping_timeo + 1) * HZ / 10 : 1;
 			rcu_read_unlock();
 			schedule_timeout_interruptible(timeo);
@@ -633,11 +633,11 @@ drbd_set_role(struct drbd_device *device, enum drbd_role new_role, int force)
 			put_ldev(device);
 		}
 	} else {
-		mutex_lock(&device->connection->conf_update);
-		nc = device->connection->net_conf;
+		mutex_lock(&first_peer_device(device)->connection->conf_update);
+		nc = first_peer_device(device)->connection->net_conf;
 		if (nc)
 			nc->discard_my_data = 0; /* without copy; single bit op is atomic */
-		mutex_unlock(&device->connection->conf_update);
+		mutex_unlock(&first_peer_device(device)->connection->conf_update);
 
 		set_disk_ro(device->vdisk, false);
 		if (get_ldev(device)) {
@@ -1134,12 +1134,12 @@ void drbd_reconsider_max_bio_size(struct drbd_device *device)
 	   Because new from 8.3.8 onwards the peer can use multiple
 	   BIOs for a single peer_request */
 	if (device->state.conn >= C_WF_REPORT_PARAMS) {
-		if (device->connection->agreed_pro_version < 94)
+		if (first_peer_device(device)->connection->agreed_pro_version < 94)
 			peer = min(device->peer_max_bio_size, DRBD_MAX_SIZE_H80_PACKET);
 			/* Correct old drbd (up to 8.3.7) if it believes it can do more than 32KiB */
-		else if (device->connection->agreed_pro_version == 94)
+		else if (first_peer_device(device)->connection->agreed_pro_version == 94)
 			peer = DRBD_MAX_SIZE_H80_PACKET;
-		else if (device->connection->agreed_pro_version < 100)
+		else if (first_peer_device(device)->connection->agreed_pro_version < 100)
 			peer = DRBD_MAX_BIO_SIZE_P95;  /* drbd 8.3.8 onwards, before 8.4.0 */
 		else
 			peer = DRBD_MAX_BIO_SIZE;
@@ -1190,10 +1190,10 @@ static void drbd_suspend_al(struct drbd_device *device)
 	}
 
 	drbd_al_shrink(device);
-	spin_lock_irq(&device->connection->req_lock);
+	spin_lock_irq(&first_peer_device(device)->connection->req_lock);
 	if (device->state.conn < C_CONNECTED)
 		s = !test_and_set_bit(AL_SUSPENDED, &device->flags);
-	spin_unlock_irq(&device->connection->req_lock);
+	spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
 	lc_unlock(device->act_log);
 
 	if (s)
@@ -1264,7 +1264,7 @@ int drbd_adm_disk_opts(struct sk_buff *skb, struct genl_info *info)
 		goto fail;
 	}
 
-	mutex_lock(&device->connection->conf_update);
+	mutex_lock(&first_peer_device(device)->connection->conf_update);
 	old_disk_conf = device->ldev->disk_conf;
 	*new_disk_conf = *old_disk_conf;
 	if (should_set_defaults(info))
@@ -1327,7 +1327,7 @@ int drbd_adm_disk_opts(struct sk_buff *skb, struct genl_info *info)
 		rcu_assign_pointer(device->rs_plan_s, new_plan);
 	}
 
-	mutex_unlock(&device->connection->conf_update);
+	mutex_unlock(&first_peer_device(device)->connection->conf_update);
 
 	if (new_disk_conf->al_updates)
 		device->ldev->md.flags &= ~MDF_AL_DISABLED;
@@ -1339,7 +1339,7 @@ int drbd_adm_disk_opts(struct sk_buff *skb, struct genl_info *info)
 	else
 		set_bit(MD_NO_FUA, &device->flags);
 
-	drbd_bump_write_ordering(device->connection, WO_bdev_flush);
+	drbd_bump_write_ordering(first_peer_device(device)->connection, WO_bdev_flush);
 
 	drbd_md_sync(device);
 
@@ -1353,7 +1353,7 @@ int drbd_adm_disk_opts(struct sk_buff *skb, struct genl_info *info)
 	goto success;
 
 fail_unlock:
-	mutex_unlock(&device->connection->conf_update);
+	mutex_unlock(&first_peer_device(device)->connection->conf_update);
  fail:
 	kfree(new_disk_conf);
 	kfree(new_plan);
@@ -1388,7 +1388,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 		goto finish;
 
 	device = adm_ctx.device;
-	conn_reconfig_start(device->connection);
+	conn_reconfig_start(first_peer_device(device)->connection);
 
 	/* if you want to reconfigure, please tear down first */
 	if (device->state.disk > D_DISKLESS) {
@@ -1455,7 +1455,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 		goto fail;
 
 	rcu_read_lock();
-	nc = rcu_dereference(device->connection->net_conf);
+	nc = rcu_dereference(first_peer_device(device)->connection->net_conf);
 	if (nc) {
 		if (new_disk_conf->fencing == FP_STONITH && nc->wire_protocol == DRBD_PROT_A) {
 			rcu_read_unlock();
@@ -1636,7 +1636,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 	new_disk_conf = NULL;
 	new_plan = NULL;
 
-	drbd_bump_write_ordering(device->connection, WO_bdev_flush);
+	drbd_bump_write_ordering(first_peer_device(device)->connection, WO_bdev_flush);
 
 	if (drbd_md_test_flag(device->ldev, MDF_CRASHED_PRIMARY))
 		set_bit(CRASHED_PRIMARY, &device->flags);
@@ -1644,7 +1644,8 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 		clear_bit(CRASHED_PRIMARY, &device->flags);
 
 	if (drbd_md_test_flag(device->ldev, MDF_PRIMARY_IND) &&
-	    !(device->state.role == R_PRIMARY && device->connection->susp_nod))
+	    !(device->state.role == R_PRIMARY &&
+	      first_peer_device(device)->connection->susp_nod))
 		set_bit(CRASHED_PRIMARY, &device->flags);
 
 	device->send_cnt = 0;
@@ -1702,7 +1703,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 	if (_drbd_bm_total_weight(device) == drbd_bm_bits(device))
 		drbd_suspend_al(device); /* IO is still suspended here... */
 
-	spin_lock_irq(&device->connection->req_lock);
+	spin_lock_irq(&first_peer_device(device)->connection->req_lock);
 	os = drbd_read_state(device);
 	ns = os;
 	/* If MDF_CONSISTENT is not set go into inconsistent state,
@@ -1754,7 +1755,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	rv = _drbd_set_state(device, ns, CS_VERBOSE, NULL);
-	spin_unlock_irq(&device->connection->req_lock);
+	spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
 
 	if (rv < SS_SUCCESS)
 		goto force_diskless_dec;
@@ -1771,7 +1772,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 
 	kobject_uevent(&disk_to_dev(device->vdisk)->kobj, KOBJ_CHANGE);
 	put_ldev(device);
-	conn_reconfig_done(device->connection);
+	conn_reconfig_done(first_peer_device(device)->connection);
 	drbd_adm_finish(info, retcode);
 	return 0;
 
@@ -1781,7 +1782,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 	drbd_force_state(device, NS(disk, D_DISKLESS));
 	drbd_md_sync(device);
  fail:
-	conn_reconfig_done(device->connection);
+	conn_reconfig_done(first_peer_device(device)->connection);
 	if (nbc) {
 		if (nbc->backing_bdev)
 			blkdev_put(nbc->backing_bdev,
@@ -2357,7 +2358,7 @@ void resync_after_online_grow(struct drbd_device *device)
 	if (device->state.role != device->state.peer)
 		iass = (device->state.role == R_PRIMARY);
 	else
-		iass = test_bit(RESOLVE_CONFLICTS, &device->connection->flags);
+		iass = test_bit(RESOLVE_CONFLICTS, &first_peer_device(device)->connection->flags);
 
 	if (iass)
 		drbd_start_resync(device, C_SYNC_SOURCE);
@@ -2412,7 +2413,7 @@ int drbd_adm_resize(struct sk_buff *skb, struct genl_info *info)
 		goto fail_ldev;
 	}
 
-	if (rs.no_resync && device->connection->agreed_pro_version < 93) {
+	if (rs.no_resync && first_peer_device(device)->connection->agreed_pro_version < 93) {
 		retcode = ERR_NEED_APV_93;
 		goto fail_ldev;
 	}
@@ -2454,12 +2455,12 @@ int drbd_adm_resize(struct sk_buff *skb, struct genl_info *info)
 		device->ldev->known_size = drbd_get_capacity(device->ldev->backing_bdev);
 
 	if (new_disk_conf) {
-		mutex_lock(&device->connection->conf_update);
+		mutex_lock(&first_peer_device(device)->connection->conf_update);
 		old_disk_conf = device->ldev->disk_conf;
 		*new_disk_conf = *old_disk_conf;
 		new_disk_conf->disk_size = (sector_t)rs.resize_size;
 		rcu_assign_pointer(device->ldev->disk_conf, new_disk_conf);
-		mutex_unlock(&device->connection->conf_update);
+		mutex_unlock(&first_peer_device(device)->connection->conf_update);
 		synchronize_rcu();
 		kfree(old_disk_conf);
 	}
@@ -2710,9 +2711,9 @@ int drbd_adm_resume_io(struct sk_buff *skb, struct genl_info *info)
 	retcode = drbd_request_state(device, NS3(susp, 0, susp_nod, 0, susp_fen, 0));
 	if (retcode == SS_SUCCESS) {
 		if (device->state.conn < C_CONNECTED)
-			tl_clear(device->connection);
+			tl_clear(first_peer_device(device)->connection);
 		if (device->state.disk == D_DISKLESS || device->state.disk == D_FAILED)
-			tl_restart(device->connection, FAIL_FROZEN_DISK_IO);
+			tl_restart(first_peer_device(device)->connection, FAIL_FROZEN_DISK_IO);
 	}
 	drbd_resume_io(device);
 
@@ -2778,10 +2779,10 @@ int nla_put_status_info(struct sk_buff *skb, struct drbd_device *device,
 
 	/* We need to add connection name and volume number information still.
 	 * Minor number is in drbd_genlmsghdr. */
-	if (nla_put_drbd_cfg_context(skb, device->connection, device->vnr))
+	if (nla_put_drbd_cfg_context(skb, first_peer_device(device)->connection, device->vnr))
 		goto nla_put_failure;
 
-	if (res_opts_to_skb(skb, &device->connection->res_opts, exclude_sensitive))
+	if (res_opts_to_skb(skb, &first_peer_device(device)->connection->res_opts, exclude_sensitive))
 		goto nla_put_failure;
 
 	rcu_read_lock();
@@ -2794,7 +2795,7 @@ int nla_put_status_info(struct sk_buff *skb, struct drbd_device *device,
 	if (!err) {
 		struct net_conf *nc;
 
-		nc = rcu_dereference(device->connection->net_conf);
+		nc = rcu_dereference(first_peer_device(device)->connection->net_conf);
 		if (nc)
 			err = net_conf_to_skb(skb, nc, exclude_sensitive);
 	}
@@ -2981,7 +2982,7 @@ next_connection:
 		}
 
 		D_ASSERT(device->vnr == volume);
-		D_ASSERT(device->connection == connection);
+		D_ASSERT(first_peer_device(device)->connection == connection);
 
 		dh->minor = device_to_minor(device);
 		dh->ret_code = NO_ERROR;
@@ -3168,7 +3169,8 @@ int drbd_adm_new_c_uuid(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	/* this is "skip initial sync", assume to be clean */
-	if (device->state.conn == C_CONNECTED && device->connection->agreed_pro_version >= 90 &&
+	if (device->state.conn == C_CONNECTED &&
+	    first_peer_device(device)->connection->agreed_pro_version >= 90 &&
 	    device->ldev->md.uuid[UI_CURRENT] == UUID_JUST_CREATED && args.clear_bm) {
 		dev_info(DEV, "Preparing to skip initial sync\n");
 		skip_initial_sync = 1;
@@ -3191,10 +3193,10 @@ int drbd_adm_new_c_uuid(struct sk_buff *skb, struct genl_info *info)
 			drbd_send_uuids_skip_initial_sync(device);
 			_drbd_uuid_set(device, UI_BITMAP, 0);
 			drbd_print_uuids(device, "cleared bitmap UUID");
-			spin_lock_irq(&device->connection->req_lock);
+			spin_lock_irq(&first_peer_device(device)->connection->req_lock);
 			_drbd_set_state(_NS2(device, disk, D_UP_TO_DATE, pdsk, D_UP_TO_DATE),
 					CS_VERBOSE, NULL);
-			spin_unlock_irq(&device->connection->req_lock);
+			spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
 		}
 	}
 
@@ -3287,7 +3289,7 @@ int drbd_adm_add_minor(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	/* drbd_adm_prepare made sure already
-	 * that device->connection and device->vnr match the request. */
+	 * that first_peer_device(device)->connection and device->vnr match the request. */
 	if (adm_ctx.device) {
 		if (info->nlhdr->nlmsg_flags & NLM_F_EXCL)
 			retcode = ERR_MINOR_EXISTS;
@@ -3295,7 +3297,7 @@ int drbd_adm_add_minor(struct sk_buff *skb, struct genl_info *info)
 		goto out;
 	}
 
-	retcode = conn_new_minor(adm_ctx.connection, dh->minor, adm_ctx.volume);
+	retcode = drbd_create_minor(adm_ctx.connection, dh->minor, adm_ctx.volume);
 out:
 	drbd_adm_finish(info, retcode);
 	return 0;
@@ -3310,7 +3312,7 @@ static enum drbd_ret_code adm_delete_minor(struct drbd_device *device)
 	    device->state.role == R_SECONDARY) {
 		_drbd_request_state(device, NS(conn, C_WF_REPORT_PARAMS),
 				    CS_VERBOSE + CS_WAIT_COMPLETE);
-		idr_remove(&device->connection->volumes, device->vnr);
+		idr_remove(&first_peer_device(device)->connection->volumes, device->vnr);
 		idr_remove(&minors, device_to_minor(device));
 		destroy_workqueue(device->submit.wq);
 		del_gendisk(device->vdisk);
diff --git a/drivers/block/drbd/drbd_proc.c b/drivers/block/drbd/drbd_proc.c
index b8bbe47..34cf724 100644
--- a/drivers/block/drbd/drbd_proc.c
+++ b/drivers/block/drbd/drbd_proc.c
@@ -251,7 +251,7 @@ static int drbd_seq_show(struct seq_file *seq, void *v)
 			/* reset device->congestion_reason */
 			bdi_rw_congested(&device->rq_queue->backing_dev_info);
 
-			nc = rcu_dereference(device->connection->net_conf);
+			nc = rcu_dereference(first_peer_device(device)->connection->net_conf);
 			wp = nc ? nc->wire_protocol - DRBD_PROT_A + 'A' : ' ';
 			seq_printf(seq,
 			   "%2d: cs:%s ro:%s/%s ds:%s/%s %c %c%c%c%c%c%c\n"
@@ -280,8 +280,8 @@ static int drbd_seq_show(struct seq_file *seq, void *v)
 			   atomic_read(&device->rs_pending_cnt),
 			   atomic_read(&device->unacked_cnt),
 			   atomic_read(&device->ap_bio_cnt),
-			   device->connection->epochs,
-			   write_ordering_chars[device->connection->write_ordering]
+			   first_peer_device(device)->connection->epochs,
+			   write_ordering_chars[first_peer_device(device)->connection->write_ordering]
 			);
 			seq_printf(seq, " oos:%llu\n",
 				   Bit2KB((unsigned long long)
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 9112436..c2397e6 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -221,9 +221,9 @@ static void drbd_kick_lo_and_reclaim_net(struct drbd_device *device)
 	LIST_HEAD(reclaimed);
 	struct drbd_peer_request *peer_req, *t;
 
-	spin_lock_irq(&device->connection->req_lock);
+	spin_lock_irq(&first_peer_device(device)->connection->req_lock);
 	reclaim_finished_net_peer_reqs(device, &reclaimed);
-	spin_unlock_irq(&device->connection->req_lock);
+	spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
 
 	list_for_each_entry_safe(peer_req, t, &reclaimed, w.list)
 		drbd_free_net_peer_req(device, peer_req);
@@ -252,7 +252,7 @@ struct page *drbd_alloc_pages(struct drbd_device *device, unsigned int number,
 	/* Yes, we may run up to @number over max_buffers. If we
 	 * follow it strictly, the admin will get it wrong anyways. */
 	rcu_read_lock();
-	nc = rcu_dereference(device->connection->net_conf);
+	nc = rcu_dereference(first_peer_device(device)->connection->net_conf);
 	mxb = nc ? nc->max_buffers : 1000000;
 	rcu_read_unlock();
 
@@ -288,7 +288,7 @@ struct page *drbd_alloc_pages(struct drbd_device *device, unsigned int number,
 }
 
 /* Must not be used from irq, as that may deadlock: see drbd_alloc_pages.
- * Is also used from inside an other spin_lock_irq(&device->connection->req_lock);
+ * Is also used from inside an other spin_lock_irq(&first_peer_device(device)->connection->req_lock);
  * Either links the page chain back to the global pool,
  * or returns all pages to the system. */
 static void drbd_free_pages(struct drbd_device *device, struct page *page, int is_net)
@@ -396,9 +396,9 @@ int drbd_free_peer_reqs(struct drbd_device *device, struct list_head *list)
 	int count = 0;
 	int is_net = list == &device->net_ee;
 
-	spin_lock_irq(&device->connection->req_lock);
+	spin_lock_irq(&first_peer_device(device)->connection->req_lock);
 	list_splice_init(list, &work_list);
-	spin_unlock_irq(&device->connection->req_lock);
+	spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
 
 	list_for_each_entry_safe(peer_req, t, &work_list, w.list) {
 		__drbd_free_peer_req(device, peer_req, is_net);
@@ -417,10 +417,10 @@ static int drbd_finish_peer_reqs(struct drbd_device *device)
 	struct drbd_peer_request *peer_req, *t;
 	int err = 0;
 
-	spin_lock_irq(&device->connection->req_lock);
+	spin_lock_irq(&first_peer_device(device)->connection->req_lock);
 	reclaim_finished_net_peer_reqs(device, &reclaimed);
 	list_splice_init(&device->done_ee, &work_list);
-	spin_unlock_irq(&device->connection->req_lock);
+	spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
 
 	list_for_each_entry_safe(peer_req, t, &reclaimed, w.list)
 		drbd_free_net_peer_req(device, peer_req);
@@ -452,19 +452,19 @@ static void _drbd_wait_ee_list_empty(struct drbd_device *device,
 	 * and calling prepare_to_wait in the fast path */
 	while (!list_empty(head)) {
 		prepare_to_wait(&device->ee_wait, &wait, TASK_UNINTERRUPTIBLE);
-		spin_unlock_irq(&device->connection->req_lock);
+		spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
 		io_schedule();
 		finish_wait(&device->ee_wait, &wait);
-		spin_lock_irq(&device->connection->req_lock);
+		spin_lock_irq(&first_peer_device(device)->connection->req_lock);
 	}
 }
 
 static void drbd_wait_ee_list_empty(struct drbd_device *device,
 				    struct list_head *head)
 {
-	spin_lock_irq(&device->connection->req_lock);
+	spin_lock_irq(&first_peer_device(device)->connection->req_lock);
 	_drbd_wait_ee_list_empty(device, head);
-	spin_unlock_irq(&device->connection->req_lock);
+	spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
 }
 
 static int drbd_recv_short(struct socket *sock, void *buf, size_t size, int flags)
@@ -838,8 +838,8 @@ int drbd_connected(struct drbd_device *device)
 	atomic_set(&device->packet_seq, 0);
 	device->peer_seq = 0;
 
-	device->state_mutex = device->connection->agreed_pro_version < 100 ?
-		&device->connection->cstate_mutex :
+	device->state_mutex = first_peer_device(device)->connection->agreed_pro_version < 100 ?
+		&first_peer_device(device)->connection->cstate_mutex :
 		&device->own_state_mutex;
 
 	err = drbd_send_sync_param(device);
@@ -1492,18 +1492,18 @@ read_in_block(struct drbd_device *device, u64 id, sector_t sector,
 	struct drbd_peer_request *peer_req;
 	struct page *page;
 	int dgs, ds, err;
-	void *dig_in = device->connection->int_dig_in;
-	void *dig_vv = device->connection->int_dig_vv;
+	void *dig_in = first_peer_device(device)->connection->int_dig_in;
+	void *dig_vv = first_peer_device(device)->connection->int_dig_vv;
 	unsigned long *data;
 
 	dgs = 0;
-	if (device->connection->peer_integrity_tfm) {
-		dgs = crypto_hash_digestsize(device->connection->peer_integrity_tfm);
+	if (first_peer_device(device)->connection->peer_integrity_tfm) {
+		dgs = crypto_hash_digestsize(first_peer_device(device)->connection->peer_integrity_tfm);
 		/*
 		 * FIXME: Receive the incoming digest into the receive buffer
 		 *	  here, together with its struct p_data?
 		 */
-		err = drbd_recv_all_warn(device->connection, dig_in, dgs);
+		err = drbd_recv_all_warn(first_peer_device(device)->connection, dig_in, dgs);
 		if (err)
 			return NULL;
 		data_size -= dgs;
@@ -1539,7 +1539,7 @@ read_in_block(struct drbd_device *device, u64 id, sector_t sector,
 	page_chain_for_each(page) {
 		unsigned len = min_t(int, ds, PAGE_SIZE);
 		data = kmap(page);
-		err = drbd_recv_all_warn(device->connection, data, len);
+		err = drbd_recv_all_warn(first_peer_device(device)->connection, data, len);
 		if (drbd_insert_fault(device, DRBD_FAULT_RECEIVE)) {
 			dev_err(DEV, "Fault injection: Corrupting data on receive\n");
 			data[0] = data[0] ^ (unsigned long)-1;
@@ -1553,7 +1553,7 @@ read_in_block(struct drbd_device *device, u64 id, sector_t sector,
 	}
 
 	if (dgs) {
-		drbd_csum_ee(device, device->connection->peer_integrity_tfm, peer_req, dig_vv);
+		drbd_csum_ee(device, first_peer_device(device)->connection->peer_integrity_tfm, peer_req, dig_vv);
 		if (memcmp(dig_in, dig_vv, dgs)) {
 			dev_err(DEV, "Digest integrity check FAILED: %llus +%u\n",
 				(unsigned long long)sector, data_size);
@@ -1583,7 +1583,7 @@ static int drbd_drain_block(struct drbd_device *device, int data_size)
 	while (data_size) {
 		unsigned int len = min_t(int, data_size, PAGE_SIZE);
 
-		err = drbd_recv_all_warn(device->connection, data, len);
+		err = drbd_recv_all_warn(first_peer_device(device)->connection, data, len);
 		if (err)
 			break;
 		data_size -= len;
@@ -1600,13 +1600,13 @@ static int recv_dless_read(struct drbd_device *device, struct drbd_request *req,
 	struct bvec_iter iter;
 	struct bio *bio;
 	int dgs, err, expect;
-	void *dig_in = device->connection->int_dig_in;
-	void *dig_vv = device->connection->int_dig_vv;
+	void *dig_in = first_peer_device(device)->connection->int_dig_in;
+	void *dig_vv = first_peer_device(device)->connection->int_dig_vv;
 
 	dgs = 0;
-	if (device->connection->peer_integrity_tfm) {
-		dgs = crypto_hash_digestsize(device->connection->peer_integrity_tfm);
-		err = drbd_recv_all_warn(device->connection, dig_in, dgs);
+	if (first_peer_device(device)->connection->peer_integrity_tfm) {
+		dgs = crypto_hash_digestsize(first_peer_device(device)->connection->peer_integrity_tfm);
+		err = drbd_recv_all_warn(first_peer_device(device)->connection, dig_in, dgs);
 		if (err)
 			return err;
 		data_size -= dgs;
@@ -1622,7 +1622,7 @@ static int recv_dless_read(struct drbd_device *device, struct drbd_request *req,
 	bio_for_each_segment(bvec, bio, iter) {
 		void *mapped = kmap(bvec.bv_page) + bvec.bv_offset;
 		expect = min_t(int, data_size, bvec.bv_len);
-		err = drbd_recv_all_warn(device->connection, mapped, expect);
+		err = drbd_recv_all_warn(first_peer_device(device)->connection, mapped, expect);
 		kunmap(bvec.bv_page);
 		if (err)
 			return err;
@@ -1630,7 +1630,7 @@ static int recv_dless_read(struct drbd_device *device, struct drbd_request *req,
 	}
 
 	if (dgs) {
-		drbd_csum_bio(device, device->connection->peer_integrity_tfm, bio, dig_vv);
+		drbd_csum_bio(device, first_peer_device(device)->connection->peer_integrity_tfm, bio, dig_vv);
 		if (memcmp(dig_in, dig_vv, dgs)) {
 			dev_err(DEV, "Digest integrity check FAILED. Broken NICs?\n");
 			return -EINVAL;
@@ -1685,9 +1685,9 @@ static int recv_resync_read(struct drbd_device *device, sector_t sector, int dat
 
 	peer_req->w.cb = e_end_resync_block;
 
-	spin_lock_irq(&device->connection->req_lock);
+	spin_lock_irq(&first_peer_device(device)->connection->req_lock);
 	list_add(&peer_req->w.list, &device->sync_ee);
-	spin_unlock_irq(&device->connection->req_lock);
+	spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
 
 	atomic_add(data_size >> 9, &device->rs_sect_ev);
 	if (drbd_submit_peer_request(device, peer_req, WRITE, DRBD_FAULT_RS_WR) == 0)
@@ -1695,9 +1695,9 @@ static int recv_resync_read(struct drbd_device *device, sector_t sector, int dat
 
 	/* don't care for the reason here */
 	dev_err(DEV, "submit failed, triggering re-connect\n");
-	spin_lock_irq(&device->connection->req_lock);
+	spin_lock_irq(&first_peer_device(device)->connection->req_lock);
 	list_del(&peer_req->w.list);
-	spin_unlock_irq(&device->connection->req_lock);
+	spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
 
 	drbd_free_peer_req(device, peer_req);
 fail:
@@ -1736,9 +1736,9 @@ static int receive_DataReply(struct drbd_connection *connection, struct packet_i
 
 	sector = be64_to_cpu(p->sector);
 
-	spin_lock_irq(&device->connection->req_lock);
+	spin_lock_irq(&first_peer_device(device)->connection->req_lock);
 	req = find_request(device, &device->read_requests, p->block_id, sector, false, __func__);
-	spin_unlock_irq(&device->connection->req_lock);
+	spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
 	if (unlikely(!req))
 		return -EIO;
 
@@ -1837,16 +1837,16 @@ static int e_end_block(struct drbd_work *w, int cancel)
 	/* we delete from the conflict detection hash _after_ we sent out the
 	 * P_WRITE_ACK / P_NEG_ACK, to get the sequence number right.  */
 	if (peer_req->flags & EE_IN_INTERVAL_TREE) {
-		spin_lock_irq(&device->connection->req_lock);
+		spin_lock_irq(&first_peer_device(device)->connection->req_lock);
 		D_ASSERT(!drbd_interval_empty(&peer_req->i));
 		drbd_remove_epoch_entry_interval(device, peer_req);
 		if (peer_req->flags & EE_RESTART_REQUESTS)
 			restart_conflicting_writes(device, sector, peer_req->i.size);
-		spin_unlock_irq(&device->connection->req_lock);
+		spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
 	} else
 		D_ASSERT(drbd_interval_empty(&peer_req->i));
 
-	drbd_may_finish_epoch(device->connection, peer_req->epoch, EV_PUT + (cancel ? EV_CLEANUP : 0));
+	drbd_may_finish_epoch(first_peer_device(device)->connection, peer_req->epoch, EV_PUT + (cancel ? EV_CLEANUP : 0));
 
 	return err;
 }
@@ -1871,7 +1871,7 @@ static int e_send_superseded(struct drbd_work *w, int unused)
 
 static int e_send_retry_write(struct drbd_work *w, int unused)
 {
-	struct drbd_connection *connection = w->device->connection;
+	struct drbd_connection *connection = first_peer_device(w->device)->connection;
 
 	return e_send_ack(w, connection->agreed_pro_version >= 100 ?
 			     P_RETRY_WRITE : P_SUPERSEDED);
@@ -1896,7 +1896,7 @@ static void update_peer_seq(struct drbd_device *device, unsigned int peer_seq)
 {
 	unsigned int newest_peer_seq;
 
-	if (test_bit(RESOLVE_CONFLICTS, &device->connection->flags)) {
+	if (test_bit(RESOLVE_CONFLICTS, &first_peer_device(device)->connection->flags)) {
 		spin_lock(&device->peer_seq_lock);
 		newest_peer_seq = seq_max(device->peer_seq, peer_seq);
 		device->peer_seq = newest_peer_seq;
@@ -1918,7 +1918,7 @@ static bool overlapping_resync_write(struct drbd_device *device, struct drbd_pee
 	struct drbd_peer_request *rs_req;
 	bool rv = 0;
 
-	spin_lock_irq(&device->connection->req_lock);
+	spin_lock_irq(&first_peer_device(device)->connection->req_lock);
 	list_for_each_entry(rs_req, &device->sync_ee, w.list) {
 		if (overlaps(peer_req->i.sector, peer_req->i.size,
 			     rs_req->i.sector, rs_req->i.size)) {
@@ -1926,7 +1926,7 @@ static bool overlapping_resync_write(struct drbd_device *device, struct drbd_pee
 			break;
 		}
 	}
-	spin_unlock_irq(&device->connection->req_lock);
+	spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
 
 	return rv;
 }
@@ -1958,7 +1958,7 @@ static int wait_for_and_update_peer_seq(struct drbd_device *device, const u32 pe
 	long timeout;
 	int ret = 0, tp;
 
-	if (!test_bit(RESOLVE_CONFLICTS, &device->connection->flags))
+	if (!test_bit(RESOLVE_CONFLICTS, &first_peer_device(device)->connection->flags))
 		return 0;
 
 	spin_lock(&device->peer_seq_lock);
@@ -1974,7 +1974,7 @@ static int wait_for_and_update_peer_seq(struct drbd_device *device, const u32 pe
 		}
 
 		rcu_read_lock();
-		tp = rcu_dereference(device->connection->net_conf)->two_primaries;
+		tp = rcu_dereference(first_peer_device(device)->connection->net_conf)->two_primaries;
 		rcu_read_unlock();
 
 		if (!tp)
@@ -1984,7 +1984,7 @@ static int wait_for_and_update_peer_seq(struct drbd_device *device, const u32 pe
 		prepare_to_wait(&device->seq_wait, &wait, TASK_INTERRUPTIBLE);
 		spin_unlock(&device->peer_seq_lock);
 		rcu_read_lock();
-		timeout = rcu_dereference(device->connection->net_conf)->ping_timeo*HZ/10;
+		timeout = rcu_dereference(first_peer_device(device)->connection->net_conf)->ping_timeo*HZ/10;
 		rcu_read_unlock();
 		timeout = schedule_timeout(timeout);
 		spin_lock(&device->peer_seq_lock);
@@ -2027,10 +2027,10 @@ static void fail_postponed_requests(struct drbd_device *device, sector_t sector,
 			continue;
 		req->rq_state &= ~RQ_POSTPONED;
 		__req_mod(req, NEG_ACKED, &m);
-		spin_unlock_irq(&device->connection->req_lock);
+		spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
 		if (m.bio)
 			complete_master_bio(device, &m);
-		spin_lock_irq(&device->connection->req_lock);
+		spin_lock_irq(&first_peer_device(device)->connection->req_lock);
 		goto repeat;
 	}
 }
@@ -2038,7 +2038,7 @@ static void fail_postponed_requests(struct drbd_device *device, sector_t sector,
 static int handle_write_conflicts(struct drbd_device *device,
 				  struct drbd_peer_request *peer_req)
 {
-	struct drbd_connection *connection = device->connection;
+	struct drbd_connection *connection = first_peer_device(device)->connection;
 	bool resolve_conflicts = test_bit(RESOLVE_CONFLICTS, &connection->flags);
 	sector_t sector = peer_req->i.sector;
 	const unsigned int size = peer_req->i.size;
@@ -2092,7 +2092,7 @@ static int handle_write_conflicts(struct drbd_device *device,
 			peer_req->w.cb = superseded ? e_send_superseded :
 						   e_send_retry_write;
 			list_add_tail(&peer_req->w.list, &device->done_ee);
-			wake_asender(device->connection);
+			wake_asender(first_peer_device(device)->connection);
 
 			err = -ENOENT;
 			goto out;
@@ -2121,7 +2121,7 @@ static int handle_write_conflicts(struct drbd_device *device,
 				 */
 				err = drbd_wait_misc(device, &req->i);
 				if (err) {
-					_conn_request_state(device->connection,
+					_conn_request_state(first_peer_device(device)->connection,
 							    NS(conn, C_TIMEOUT),
 							    CS_HARD);
 					fail_postponed_requests(device, sector, size);
@@ -2204,17 +2204,17 @@ static int receive_Data(struct drbd_connection *connection, struct packet_info *
 	spin_unlock(&connection->epoch_lock);
 
 	rcu_read_lock();
-	tp = rcu_dereference(device->connection->net_conf)->two_primaries;
+	tp = rcu_dereference(first_peer_device(device)->connection->net_conf)->two_primaries;
 	rcu_read_unlock();
 	if (tp) {
 		peer_req->flags |= EE_IN_INTERVAL_TREE;
 		err = wait_for_and_update_peer_seq(device, peer_seq);
 		if (err)
 			goto out_interrupted;
-		spin_lock_irq(&device->connection->req_lock);
+		spin_lock_irq(&first_peer_device(device)->connection->req_lock);
 		err = handle_write_conflicts(device, peer_req);
 		if (err) {
-			spin_unlock_irq(&device->connection->req_lock);
+			spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
 			if (err == -ENOENT) {
 				put_ldev(device);
 				return 0;
@@ -2223,17 +2223,17 @@ static int receive_Data(struct drbd_connection *connection, struct packet_info *
 		}
 	} else {
 		update_peer_seq(device, peer_seq);
-		spin_lock_irq(&device->connection->req_lock);
+		spin_lock_irq(&first_peer_device(device)->connection->req_lock);
 	}
 	list_add(&peer_req->w.list, &device->active_ee);
-	spin_unlock_irq(&device->connection->req_lock);
+	spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
 
 	if (device->state.conn == C_SYNC_TARGET)
 		wait_event(device->ee_wait, !overlapping_resync_write(device, peer_req));
 
-	if (device->connection->agreed_pro_version < 100) {
+	if (first_peer_device(device)->connection->agreed_pro_version < 100) {
 		rcu_read_lock();
-		switch (rcu_dereference(device->connection->net_conf)->wire_protocol) {
+		switch (rcu_dereference(first_peer_device(device)->connection->net_conf)->wire_protocol) {
 		case DRBD_PROT_C:
 			dp_flags |= DP_SEND_WRITE_ACK;
 			break;
@@ -2271,10 +2271,10 @@ static int receive_Data(struct drbd_connection *connection, struct packet_info *
 
 	/* don't care for the reason here */
 	dev_err(DEV, "submit failed, triggering re-connect\n");
-	spin_lock_irq(&device->connection->req_lock);
+	spin_lock_irq(&first_peer_device(device)->connection->req_lock);
 	list_del(&peer_req->w.list);
 	drbd_remove_epoch_entry_interval(device, peer_req);
-	spin_unlock_irq(&device->connection->req_lock);
+	spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
 	if (peer_req->flags & EE_CALL_AL_COMPLETE_IO)
 		drbd_al_complete_io(device, &peer_req->i);
 
@@ -2450,11 +2450,11 @@ static int receive_DataRequest(struct drbd_connection *connection, struct packet
 		peer_req->digest = di;
 		peer_req->flags |= EE_HAS_DIGEST;
 
-		if (drbd_recv_all(device->connection, di->digest, pi->size))
+		if (drbd_recv_all(first_peer_device(device)->connection, di->digest, pi->size))
 			goto out_free_e;
 
 		if (pi->cmd == P_CSUM_RS_REQUEST) {
-			D_ASSERT(device->connection->agreed_pro_version >= 89);
+			D_ASSERT(first_peer_device(device)->connection->agreed_pro_version >= 89);
 			peer_req->w.cb = w_e_end_csum_rs_req;
 			/* used in the sector offset progress display */
 			device->bm_resync_fo = BM_SECT_TO_BIT(sector);
@@ -2471,7 +2471,7 @@ static int receive_DataRequest(struct drbd_connection *connection, struct packet
 
 	case P_OV_REQUEST:
 		if (device->ov_start_sector == ~(sector_t)0 &&
-		    device->connection->agreed_pro_version >= 90) {
+		    first_peer_device(device)->connection->agreed_pro_version >= 90) {
 			unsigned long now = jiffies;
 			int i;
 			device->ov_start_sector = sector;
@@ -2525,18 +2525,18 @@ submit_for_resync:
 
 submit:
 	inc_unacked(device);
-	spin_lock_irq(&device->connection->req_lock);
+	spin_lock_irq(&first_peer_device(device)->connection->req_lock);
 	list_add_tail(&peer_req->w.list, &device->read_ee);
-	spin_unlock_irq(&device->connection->req_lock);
+	spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
 
 	if (drbd_submit_peer_request(device, peer_req, READ, fault_type) == 0)
 		return 0;
 
 	/* don't care for the reason here */
 	dev_err(DEV, "submit failed, triggering re-connect\n");
-	spin_lock_irq(&device->connection->req_lock);
+	spin_lock_irq(&first_peer_device(device)->connection->req_lock);
 	list_del(&peer_req->w.list);
-	spin_unlock_irq(&device->connection->req_lock);
+	spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
 	/* no drbd_rs_complete_io(), we are dropping the connection anyways */
 
 out_free_e:
@@ -2558,7 +2558,7 @@ static int drbd_asb_recover_0p(struct drbd_device *device) __must_hold(local)
 	ch_self = device->comm_bm_set;
 
 	rcu_read_lock();
-	after_sb_0p = rcu_dereference(device->connection->net_conf)->after_sb_0p;
+	after_sb_0p = rcu_dereference(first_peer_device(device)->connection->net_conf)->after_sb_0p;
 	rcu_read_unlock();
 	switch (after_sb_0p) {
 	case ASB_CONSENSUS:
@@ -2593,7 +2593,7 @@ static int drbd_asb_recover_0p(struct drbd_device *device) __must_hold(local)
 		     "Using discard-least-changes instead\n");
 	case ASB_DISCARD_ZERO_CHG:
 		if (ch_peer == 0 && ch_self == 0) {
-			rv = test_bit(RESOLVE_CONFLICTS, &device->connection->flags)
+			rv = test_bit(RESOLVE_CONFLICTS, &first_peer_device(device)->connection->flags)
 				? -1 : 1;
 			break;
 		} else {
@@ -2609,7 +2609,7 @@ static int drbd_asb_recover_0p(struct drbd_device *device) __must_hold(local)
 			rv =  1;
 		else /* ( ch_self == ch_peer ) */
 		     /* Well, then use something else. */
-			rv = test_bit(RESOLVE_CONFLICTS, &device->connection->flags)
+			rv = test_bit(RESOLVE_CONFLICTS, &first_peer_device(device)->connection->flags)
 				? -1 : 1;
 		break;
 	case ASB_DISCARD_LOCAL:
@@ -2628,7 +2628,7 @@ static int drbd_asb_recover_1p(struct drbd_device *device) __must_hold(local)
 	enum drbd_after_sb_p after_sb_1p;
 
 	rcu_read_lock();
-	after_sb_1p = rcu_dereference(device->connection->net_conf)->after_sb_1p;
+	after_sb_1p = rcu_dereference(first_peer_device(device)->connection->net_conf)->after_sb_1p;
 	rcu_read_unlock();
 	switch (after_sb_1p) {
 	case ASB_DISCARD_YOUNGER_PRI:
@@ -2681,7 +2681,7 @@ static int drbd_asb_recover_2p(struct drbd_device *device) __must_hold(local)
 	enum drbd_after_sb_p after_sb_2p;
 
 	rcu_read_lock();
-	after_sb_2p = rcu_dereference(device->connection->net_conf)->after_sb_2p;
+	after_sb_2p = rcu_dereference(first_peer_device(device)->connection->net_conf)->after_sb_2p;
 	rcu_read_unlock();
 	switch (after_sb_2p) {
 	case ASB_DISCARD_YOUNGER_PRI:
@@ -2777,7 +2777,7 @@ static int drbd_uuid_compare(struct drbd_device *device, int *rule_nr) __must_ho
 
 		if (device->p_uuid[UI_BITMAP] == (u64)0 && device->ldev->md.uuid[UI_BITMAP] != (u64)0) {
 
-			if (device->connection->agreed_pro_version < 91)
+			if (first_peer_device(device)->connection->agreed_pro_version < 91)
 				return -1091;
 
 			if ((device->ldev->md.uuid[UI_BITMAP] & ~((u64)1)) == (device->p_uuid[UI_HISTORY_START] & ~((u64)1)) &&
@@ -2800,7 +2800,7 @@ static int drbd_uuid_compare(struct drbd_device *device, int *rule_nr) __must_ho
 
 		if (device->ldev->md.uuid[UI_BITMAP] == (u64)0 && device->p_uuid[UI_BITMAP] != (u64)0) {
 
-			if (device->connection->agreed_pro_version < 91)
+			if (first_peer_device(device)->connection->agreed_pro_version < 91)
 				return -1091;
 
 			if ((device->ldev->md.uuid[UI_HISTORY_START] & ~((u64)1)) == (device->p_uuid[UI_BITMAP] & ~((u64)1)) &&
@@ -2833,7 +2833,7 @@ static int drbd_uuid_compare(struct drbd_device *device, int *rule_nr) __must_ho
 		case 1: /*  self_pri && !peer_pri */ return 1;
 		case 2: /* !self_pri &&  peer_pri */ return -1;
 		case 3: /*  self_pri &&  peer_pri */
-			dc = test_bit(RESOLVE_CONFLICTS, &device->connection->flags);
+			dc = test_bit(RESOLVE_CONFLICTS, &first_peer_device(device)->connection->flags);
 			return dc ? -1 : 1;
 		}
 	}
@@ -2846,14 +2846,14 @@ static int drbd_uuid_compare(struct drbd_device *device, int *rule_nr) __must_ho
 	*rule_nr = 51;
 	peer = device->p_uuid[UI_HISTORY_START] & ~((u64)1);
 	if (self == peer) {
-		if (device->connection->agreed_pro_version < 96 ?
+		if (first_peer_device(device)->connection->agreed_pro_version < 96 ?
 		    (device->ldev->md.uuid[UI_HISTORY_START] & ~((u64)1)) ==
 		    (device->p_uuid[UI_HISTORY_START + 1] & ~((u64)1)) :
 		    peer + UUID_NEW_BM_OFFSET == (device->p_uuid[UI_BITMAP] & ~((u64)1))) {
 			/* The last P_SYNC_UUID did not get though. Undo the last start of
 			   resync as sync source modifications of the peer's UUIDs. */
 
-			if (device->connection->agreed_pro_version < 91)
+			if (first_peer_device(device)->connection->agreed_pro_version < 91)
 				return -1091;
 
 			device->p_uuid[UI_BITMAP] = device->p_uuid[UI_HISTORY_START];
@@ -2883,14 +2883,14 @@ static int drbd_uuid_compare(struct drbd_device *device, int *rule_nr) __must_ho
 	*rule_nr = 71;
 	self = device->ldev->md.uuid[UI_HISTORY_START] & ~((u64)1);
 	if (self == peer) {
-		if (device->connection->agreed_pro_version < 96 ?
+		if (first_peer_device(device)->connection->agreed_pro_version < 96 ?
 		    (device->ldev->md.uuid[UI_HISTORY_START + 1] & ~((u64)1)) ==
 		    (device->p_uuid[UI_HISTORY_START] & ~((u64)1)) :
 		    self + UUID_NEW_BM_OFFSET == (device->ldev->md.uuid[UI_BITMAP] & ~((u64)1))) {
 			/* The last P_SYNC_UUID did not get though. Undo the last start of
 			   resync as sync source modifications of our UUIDs. */
 
-			if (device->connection->agreed_pro_version < 91)
+			if (first_peer_device(device)->connection->agreed_pro_version < 91)
 				return -1091;
 
 			__drbd_uuid_set(device, UI_BITMAP, device->ldev->md.uuid[UI_HISTORY_START]);
@@ -2982,7 +2982,7 @@ static enum drbd_conns drbd_sync_handshake(struct drbd_device *device, enum drbd
 		drbd_khelper(device, "initial-split-brain");
 
 	rcu_read_lock();
-	nc = rcu_dereference(device->connection->net_conf);
+	nc = rcu_dereference(first_peer_device(device)->connection->net_conf);
 
 	if (hg == 100 || (hg == -100 && nc->always_asbp)) {
 		int pcount = (device->state.role == R_PRIMARY)
@@ -3057,7 +3057,7 @@ static enum drbd_conns drbd_sync_handshake(struct drbd_device *device, enum drbd
 		}
 	}
 
-	if (tentative || test_bit(CONN_DRY_RUN, &device->connection->flags)) {
+	if (tentative || test_bit(CONN_DRY_RUN, &first_peer_device(device)->connection->flags)) {
 		if (hg == 0)
 			dev_info(DEV, "dry-run connect: No resync, would become Connected immediately.\n");
 		else
@@ -3360,17 +3360,17 @@ static int receive_SyncParam(struct drbd_connection *connection, struct packet_i
 	p = pi->data;
 	memset(p->verify_alg, 0, 2 * SHARED_SECRET_MAX);
 
-	err = drbd_recv_all(device->connection, p, header_size);
+	err = drbd_recv_all(first_peer_device(device)->connection, p, header_size);
 	if (err)
 		return err;
 
-	mutex_lock(&device->connection->conf_update);
-	old_net_conf = device->connection->net_conf;
+	mutex_lock(&first_peer_device(device)->connection->conf_update);
+	old_net_conf = first_peer_device(device)->connection->net_conf;
 	if (get_ldev(device)) {
 		new_disk_conf = kzalloc(sizeof(struct disk_conf), GFP_KERNEL);
 		if (!new_disk_conf) {
 			put_ldev(device);
-			mutex_unlock(&device->connection->conf_update);
+			mutex_unlock(&first_peer_device(device)->connection->conf_update);
 			dev_err(DEV, "Allocation of new disk_conf failed\n");
 			return -ENOMEM;
 		}
@@ -3391,7 +3391,7 @@ static int receive_SyncParam(struct drbd_connection *connection, struct packet_i
 				goto reconnect;
 			}
 
-			err = drbd_recv_all(device->connection, p->verify_alg, data_size);
+			err = drbd_recv_all(first_peer_device(device)->connection, p->verify_alg, data_size);
 			if (err)
 				goto reconnect;
 			/* we expect NUL terminated string */
@@ -3465,15 +3465,15 @@ static int receive_SyncParam(struct drbd_connection *connection, struct packet_i
 			if (verify_tfm) {
 				strcpy(new_net_conf->verify_alg, p->verify_alg);
 				new_net_conf->verify_alg_len = strlen(p->verify_alg) + 1;
-				crypto_free_hash(device->connection->verify_tfm);
-				device->connection->verify_tfm = verify_tfm;
+				crypto_free_hash(first_peer_device(device)->connection->verify_tfm);
+				first_peer_device(device)->connection->verify_tfm = verify_tfm;
 				dev_info(DEV, "using verify-alg: \"%s\"\n", p->verify_alg);
 			}
 			if (csums_tfm) {
 				strcpy(new_net_conf->csums_alg, p->csums_alg);
 				new_net_conf->csums_alg_len = strlen(p->csums_alg) + 1;
-				crypto_free_hash(device->connection->csums_tfm);
-				device->connection->csums_tfm = csums_tfm;
+				crypto_free_hash(first_peer_device(device)->connection->csums_tfm);
+				first_peer_device(device)->connection->csums_tfm = csums_tfm;
 				dev_info(DEV, "using csums-alg: \"%s\"\n", p->csums_alg);
 			}
 			rcu_assign_pointer(connection->net_conf, new_net_conf);
@@ -3490,7 +3490,7 @@ static int receive_SyncParam(struct drbd_connection *connection, struct packet_i
 		rcu_assign_pointer(device->rs_plan_s, new_plan);
 	}
 
-	mutex_unlock(&device->connection->conf_update);
+	mutex_unlock(&first_peer_device(device)->connection->conf_update);
 	synchronize_rcu();
 	if (new_net_conf)
 		kfree(old_net_conf);
@@ -3504,7 +3504,7 @@ reconnect:
 		put_ldev(device);
 		kfree(new_disk_conf);
 	}
-	mutex_unlock(&device->connection->conf_update);
+	mutex_unlock(&first_peer_device(device)->connection->conf_update);
 	return -EIO;
 
 disconnect:
@@ -3513,13 +3513,13 @@ disconnect:
 		put_ldev(device);
 		kfree(new_disk_conf);
 	}
-	mutex_unlock(&device->connection->conf_update);
+	mutex_unlock(&first_peer_device(device)->connection->conf_update);
 	/* just for completeness: actually not needed,
 	 * as this is not reached if csums_tfm was ok. */
 	crypto_free_hash(csums_tfm);
 	/* but free the verify_tfm again, if csums_tfm did not work out */
 	crypto_free_hash(verify_tfm);
-	conn_request_state(device->connection, NS(conn, C_DISCONNECTING), CS_HARD);
+	conn_request_state(first_peer_device(device)->connection, NS(conn, C_DISCONNECTING), CS_HARD);
 	return -EIO;
 }
 
@@ -3578,7 +3578,7 @@ static int receive_sizes(struct drbd_connection *connection, struct packet_info
 		    device->state.disk >= D_OUTDATED &&
 		    device->state.conn < C_CONNECTED) {
 			dev_err(DEV, "The peer's disk size is too small!\n");
-			conn_request_state(device->connection, NS(conn, C_DISCONNECTING), CS_HARD);
+			conn_request_state(first_peer_device(device)->connection, NS(conn, C_DISCONNECTING), CS_HARD);
 			put_ldev(device);
 			return -EIO;
 		}
@@ -3593,13 +3593,13 @@ static int receive_sizes(struct drbd_connection *connection, struct packet_info
 				return -ENOMEM;
 			}
 
-			mutex_lock(&device->connection->conf_update);
+			mutex_lock(&first_peer_device(device)->connection->conf_update);
 			old_disk_conf = device->ldev->disk_conf;
 			*new_disk_conf = *old_disk_conf;
 			new_disk_conf->disk_size = p_usize;
 
 			rcu_assign_pointer(device->ldev->disk_conf, new_disk_conf);
-			mutex_unlock(&device->connection->conf_update);
+			mutex_unlock(&first_peer_device(device)->connection->conf_update);
 			synchronize_rcu();
 			kfree(old_disk_conf);
 
@@ -3686,14 +3686,14 @@ static int receive_uuids(struct drbd_connection *connection, struct packet_info
 	    (device->ed_uuid & ~((u64)1)) != (p_uuid[UI_CURRENT] & ~((u64)1))) {
 		dev_err(DEV, "Can only connect to data with current UUID=%016llX\n",
 		    (unsigned long long)device->ed_uuid);
-		conn_request_state(device->connection, NS(conn, C_DISCONNECTING), CS_HARD);
+		conn_request_state(first_peer_device(device)->connection, NS(conn, C_DISCONNECTING), CS_HARD);
 		return -EIO;
 	}
 
 	if (get_ldev(device)) {
 		int skip_initial_sync =
 			device->state.conn == C_CONNECTED &&
-			device->connection->agreed_pro_version >= 90 &&
+			first_peer_device(device)->connection->agreed_pro_version >= 90 &&
 			device->ldev->md.uuid[UI_CURRENT] == UUID_JUST_CREATED &&
 			(p_uuid[UI_FLAGS] & 8);
 		if (skip_initial_sync) {
@@ -3776,7 +3776,7 @@ static int receive_req_state(struct drbd_connection *connection, struct packet_i
 	mask.i = be32_to_cpu(p->mask);
 	val.i = be32_to_cpu(p->val);
 
-	if (test_bit(RESOLVE_CONFLICTS, &device->connection->flags) &&
+	if (test_bit(RESOLVE_CONFLICTS, &first_peer_device(device)->connection->flags) &&
 	    mutex_is_locked(device->state_mutex)) {
 		drbd_send_sr_reply(device, SS_CONCURRENT_ST_CHG);
 		return 0;
@@ -3838,10 +3838,10 @@ static int receive_state(struct drbd_connection *connection, struct packet_info
 		dev_info(DEV, "real peer disk state = %s\n", drbd_disk_str(real_peer_disk));
 	}
 
-	spin_lock_irq(&device->connection->req_lock);
+	spin_lock_irq(&first_peer_device(device)->connection->req_lock);
  retry:
 	os = ns = drbd_read_state(device);
-	spin_unlock_irq(&device->connection->req_lock);
+	spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
 
 	/* If some other part of the code (asender thread, timeout)
 	 * already decided to close the connection again,
@@ -3935,16 +3935,16 @@ static int receive_state(struct drbd_connection *connection, struct packet_info
 				peer_state.disk = D_DISKLESS;
 				real_peer_disk = D_DISKLESS;
 			} else {
-				if (test_and_clear_bit(CONN_DRY_RUN, &device->connection->flags))
+				if (test_and_clear_bit(CONN_DRY_RUN, &first_peer_device(device)->connection->flags))
 					return -EIO;
 				D_ASSERT(os.conn == C_WF_REPORT_PARAMS);
-				conn_request_state(device->connection, NS(conn, C_DISCONNECTING), CS_HARD);
+				conn_request_state(first_peer_device(device)->connection, NS(conn, C_DISCONNECTING), CS_HARD);
 				return -EIO;
 			}
 		}
 	}
 
-	spin_lock_irq(&device->connection->req_lock);
+	spin_lock_irq(&first_peer_device(device)->connection->req_lock);
 	if (os.i != drbd_read_state(device).i)
 		goto retry;
 	clear_bit(CONSIDER_RESYNC, &device->flags);
@@ -3958,20 +3958,20 @@ static int receive_state(struct drbd_connection *connection, struct packet_info
 	    test_bit(NEW_CUR_UUID, &device->flags)) {
 		/* Do not allow tl_restart(RESEND) for a rebooted peer. We can only allow this
 		   for temporal network outages! */
-		spin_unlock_irq(&device->connection->req_lock);
+		spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
 		dev_err(DEV, "Aborting Connect, can not thaw IO with an only Consistent peer\n");
-		tl_clear(device->connection);
+		tl_clear(first_peer_device(device)->connection);
 		drbd_uuid_new_current(device);
 		clear_bit(NEW_CUR_UUID, &device->flags);
-		conn_request_state(device->connection, NS2(conn, C_PROTOCOL_ERROR, susp, 0), CS_HARD);
+		conn_request_state(first_peer_device(device)->connection, NS2(conn, C_PROTOCOL_ERROR, susp, 0), CS_HARD);
 		return -EIO;
 	}
 	rv = _drbd_set_state(device, ns, cs_flags, NULL);
 	ns = drbd_read_state(device);
-	spin_unlock_irq(&device->connection->req_lock);
+	spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
 
 	if (rv < SS_SUCCESS) {
-		conn_request_state(device->connection, NS(conn, C_DISCONNECTING), CS_HARD);
+		conn_request_state(first_peer_device(device)->connection, NS(conn, C_DISCONNECTING), CS_HARD);
 		return -EIO;
 	}
 
@@ -4037,7 +4037,7 @@ receive_bitmap_plain(struct drbd_device *device, unsigned int size,
 		     unsigned long *p, struct bm_xfer_ctx *c)
 {
 	unsigned int data_size = DRBD_SOCKET_BUFFER_SIZE -
-				 drbd_header_size(device->connection);
+				 drbd_header_size(first_peer_device(device)->connection);
 	unsigned int num_words = min_t(size_t, data_size / sizeof(*p),
 				       c->bm_words - c->word_offset);
 	unsigned int want = num_words * sizeof(*p);
@@ -4049,7 +4049,7 @@ receive_bitmap_plain(struct drbd_device *device, unsigned int size,
 	}
 	if (want == 0)
 		return 0;
-	err = drbd_recv_all(device->connection, p, want);
+	err = drbd_recv_all(first_peer_device(device)->connection, p, want);
 	if (err)
 		return err;
 
@@ -4167,7 +4167,7 @@ decode_bitmap_c(struct drbd_device *device,
 	 * during all our tests. */
 
 	dev_err(DEV, "receive_bitmap_c: unknown encoding %u\n", p->encoding);
-	conn_request_state(device->connection, NS(conn, C_PROTOCOL_ERROR), CS_HARD);
+	conn_request_state(first_peer_device(device)->connection, NS(conn, C_PROTOCOL_ERROR), CS_HARD);
 	return -EIO;
 }
 
@@ -4175,7 +4175,7 @@ void INFO_bm_xfer_stats(struct drbd_device *device,
 		const char *direction, struct bm_xfer_ctx *c)
 {
 	/* what would it take to transfer it "plaintext" */
-	unsigned int header_size = drbd_header_size(device->connection);
+	unsigned int header_size = drbd_header_size(first_peer_device(device)->connection);
 	unsigned int data_size = DRBD_SOCKET_BUFFER_SIZE - header_size;
 	unsigned int plain =
 		header_size * (DIV_ROUND_UP(c->bm_words, data_size) + 1) +
@@ -4252,7 +4252,7 @@ static int receive_bitmap(struct drbd_connection *connection, struct packet_info
 				err = -EIO;
 				goto out;
 			}
-			err = drbd_recv_all(device->connection, p, pi->size);
+			err = drbd_recv_all(first_peer_device(device)->connection, p, pi->size);
 			if (err)
 			       goto out;
 			err = decode_bitmap_c(device, p, &c, pi->size);
@@ -4270,7 +4270,7 @@ static int receive_bitmap(struct drbd_connection *connection, struct packet_info
 				goto out;
 			break;
 		}
-		err = drbd_recv_header(device->connection, pi);
+		err = drbd_recv_header(first_peer_device(device)->connection, pi);
 		if (err)
 			goto out;
 	}
@@ -4490,11 +4490,11 @@ static int drbd_disconnected(struct drbd_device *device)
 	unsigned int i;
 
 	/* wait for current activity to cease. */
-	spin_lock_irq(&device->connection->req_lock);
+	spin_lock_irq(&first_peer_device(device)->connection->req_lock);
 	_drbd_wait_ee_list_empty(device, &device->active_ee);
 	_drbd_wait_ee_list_empty(device, &device->sync_ee);
 	_drbd_wait_ee_list_empty(device, &device->read_ee);
-	spin_unlock_irq(&device->connection->req_lock);
+	spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
 
 	/* We do not have data structures that would allow us to
 	 * get the rs_pending_cnt down to 0 again.
@@ -4535,7 +4535,7 @@ static int drbd_disconnected(struct drbd_device *device)
 	device->p_uuid = NULL;
 
 	if (!drbd_suspended(device))
-		tl_clear(device->connection);
+		tl_clear(first_peer_device(device)->connection);
 
 	drbd_md_sync(device);
 
@@ -4936,7 +4936,7 @@ static int got_IsInSync(struct drbd_connection *connection, struct packet_info *
 	if (!device)
 		return -EIO;
 
-	D_ASSERT(device->connection->agreed_pro_version >= 89);
+	D_ASSERT(first_peer_device(device)->connection->agreed_pro_version >= 89);
 
 	update_peer_seq(device, be32_to_cpu(p->seq_num));
 
@@ -4961,14 +4961,14 @@ validate_req_change_req_state(struct drbd_device *device, u64 id, sector_t secto
 	struct drbd_request *req;
 	struct bio_and_error m;
 
-	spin_lock_irq(&device->connection->req_lock);
+	spin_lock_irq(&first_peer_device(device)->connection->req_lock);
 	req = find_request(device, root, id, sector, missing_ok, func);
 	if (unlikely(!req)) {
-		spin_unlock_irq(&device->connection->req_lock);
+		spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
 		return -EIO;
 	}
 	__req_mod(req, what, &m);
-	spin_unlock_irq(&device->connection->req_lock);
+	spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
 
 	if (m.bio)
 		complete_master_bio(device, &m);
@@ -5168,7 +5168,7 @@ static int got_OVResult(struct drbd_connection *connection, struct packet_info *
 		if (w) {
 			w->cb = w_ov_finished;
 			w->device = device;
-			drbd_queue_work(&device->connection->sender_work, w);
+			drbd_queue_work(&first_peer_device(device)->connection->sender_work, w);
 		} else {
 			dev_err(DEV, "kmalloc(w) failed.");
 			ov_out_of_sync_print(device);
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index c77843e..1b46b92 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -274,8 +274,8 @@ void drbd_req_complete(struct drbd_request *req, struct bio_and_error *m)
 	 * and reset the transfer log epoch write_cnt.
 	 */
 	if (rw == WRITE &&
-	    req->epoch == atomic_read(&device->connection->current_tle_nr))
-		start_new_tl_epoch(device->connection);
+	    req->epoch == atomic_read(&first_peer_device(device)->connection->current_tle_nr))
+		start_new_tl_epoch(first_peer_device(device)->connection);
 
 	/* Update disk stats */
 	_drbd_end_io_acct(device, req);
@@ -477,7 +477,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		 * and from w_read_retry_remote */
 		D_ASSERT(!(req->rq_state & RQ_NET_MASK));
 		rcu_read_lock();
-		nc = rcu_dereference(device->connection->net_conf);
+		nc = rcu_dereference(first_peer_device(device)->connection->net_conf);
 		p = nc->wire_protocol;
 		rcu_read_unlock();
 		req->rq_state |=
@@ -542,7 +542,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		D_ASSERT((req->rq_state & RQ_LOCAL_MASK) == 0);
 		mod_rq_state(req, m, 0, RQ_NET_QUEUED);
 		req->w.cb = w_send_read_req;
-		drbd_queue_work(&device->connection->sender_work, &req->w);
+		drbd_queue_work(&first_peer_device(device)->connection->sender_work, &req->w);
 		break;
 
 	case QUEUE_FOR_NET_WRITE:
@@ -577,22 +577,22 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		D_ASSERT(req->rq_state & RQ_NET_PENDING);
 		mod_rq_state(req, m, 0, RQ_NET_QUEUED|RQ_EXP_BARR_ACK);
 		req->w.cb =  w_send_dblock;
-		drbd_queue_work(&device->connection->sender_work, &req->w);
+		drbd_queue_work(&first_peer_device(device)->connection->sender_work, &req->w);
 
 		/* close the epoch, in case it outgrew the limit */
 		rcu_read_lock();
-		nc = rcu_dereference(device->connection->net_conf);
+		nc = rcu_dereference(first_peer_device(device)->connection->net_conf);
 		p = nc->max_epoch_size;
 		rcu_read_unlock();
-		if (device->connection->current_tle_writes >= p)
-			start_new_tl_epoch(device->connection);
+		if (first_peer_device(device)->connection->current_tle_writes >= p)
+			start_new_tl_epoch(first_peer_device(device)->connection);
 
 		break;
 
 	case QUEUE_FOR_SEND_OOS:
 		mod_rq_state(req, m, 0, RQ_NET_QUEUED);
 		req->w.cb =  w_send_out_of_sync;
-		drbd_queue_work(&device->connection->sender_work, &req->w);
+		drbd_queue_work(&first_peer_device(device)->connection->sender_work, &req->w);
 		break;
 
 	case READ_RETRY_REMOTE_CANCELED:
@@ -704,7 +704,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 
 		get_ldev(device); /* always succeeds in this call path */
 		req->w.cb = w_restart_disk_io;
-		drbd_queue_work(&device->connection->sender_work, &req->w);
+		drbd_queue_work(&first_peer_device(device)->connection->sender_work, &req->w);
 		break;
 
 	case RESEND:
@@ -725,7 +725,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 
 			mod_rq_state(req, m, RQ_COMPLETION_SUSP, RQ_NET_QUEUED|RQ_NET_PENDING);
 			if (req->w.cb) {
-				drbd_queue_work(&device->connection->sender_work, &req->w);
+				drbd_queue_work(&first_peer_device(device)->connection->sender_work, &req->w);
 				rv = req->rq_state & RQ_WRITE ? MR_WRITE : MR_READ;
 			} /* else: FIXME can this happen? */
 			break;
@@ -757,7 +757,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		break;
 
 	case QUEUE_AS_DRBD_BARRIER:
-		start_new_tl_epoch(device->connection);
+		start_new_tl_epoch(first_peer_device(device)->connection);
 		mod_rq_state(req, m, 0, RQ_NET_OK|RQ_NET_DONE);
 		break;
 	};
@@ -851,9 +851,9 @@ static void complete_conflicting_writes(struct drbd_request *req)
 			break;
 		/* Indicate to wake up device->misc_wait on progress.  */
 		i->waiting = true;
-		spin_unlock_irq(&device->connection->req_lock);
+		spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
 		schedule();
-		spin_lock_irq(&device->connection->req_lock);
+		spin_lock_irq(&first_peer_device(device)->connection->req_lock);
 	}
 	finish_wait(&device->misc_wait, &wait);
 }
@@ -861,7 +861,7 @@ static void complete_conflicting_writes(struct drbd_request *req)
 /* called within req_lock and rcu_read_lock() */
 static void maybe_pull_ahead(struct drbd_device *device)
 {
-	struct drbd_connection *connection = device->connection;
+	struct drbd_connection *connection = first_peer_device(device)->connection;
 	struct net_conf *nc;
 	bool congested = false;
 	enum drbd_on_congestion on_congestion;
@@ -894,7 +894,7 @@ static void maybe_pull_ahead(struct drbd_device *device)
 
 	if (congested) {
 		/* start a new epoch for non-mirrored writes */
-		start_new_tl_epoch(device->connection);
+		start_new_tl_epoch(first_peer_device(device)->connection);
 
 		if (on_congestion == OC_PULL_AHEAD)
 			_drbd_set_state(_NS(device, conn, C_AHEAD), 0, NULL);
@@ -1078,7 +1078,7 @@ static void drbd_send_and_submit(struct drbd_device *device, struct drbd_request
 	struct bio_and_error m = { NULL, };
 	bool no_remote = false;
 
-	spin_lock_irq(&device->connection->req_lock);
+	spin_lock_irq(&first_peer_device(device)->connection->req_lock);
 	if (rw == WRITE) {
 		/* This may temporarily give up the req_lock,
 		 * but will re-aquire it before it returns here.
@@ -1112,15 +1112,15 @@ static void drbd_send_and_submit(struct drbd_device *device, struct drbd_request
 	}
 
 	/* which transfer log epoch does this belong to? */
-	req->epoch = atomic_read(&device->connection->current_tle_nr);
+	req->epoch = atomic_read(&first_peer_device(device)->connection->current_tle_nr);
 
 	/* no point in adding empty flushes to the transfer log,
 	 * they are mapped to drbd barriers already. */
 	if (likely(req->i.size!=0)) {
 		if (rw == WRITE)
-			device->connection->current_tle_writes++;
+			first_peer_device(device)->connection->current_tle_writes++;
 
-		list_add_tail(&req->tl_requests, &device->connection->transfer_log);
+		list_add_tail(&req->tl_requests, &first_peer_device(device)->connection->transfer_log);
 	}
 
 	if (rw == WRITE) {
@@ -1140,9 +1140,9 @@ static void drbd_send_and_submit(struct drbd_device *device, struct drbd_request
 		/* needs to be marked within the same spinlock */
 		_req_mod(req, TO_BE_SUBMITTED);
 		/* but we need to give up the spinlock to submit */
-		spin_unlock_irq(&device->connection->req_lock);
+		spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
 		drbd_submit_req_private_bio(req);
-		spin_lock_irq(&device->connection->req_lock);
+		spin_lock_irq(&first_peer_device(device)->connection->req_lock);
 	} else if (no_remote) {
 nodata:
 		if (__ratelimit(&drbd_ratelimit_state))
@@ -1155,7 +1155,7 @@ nodata:
 out:
 	if (drbd_req_put_completion_ref(req, &m, 1))
 		kref_put(&req->kref, drbd_req_destroy);
-	spin_unlock_irq(&device->connection->req_lock);
+	spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
 
 	if (m.bio)
 		complete_master_bio(device, &m);
@@ -1336,7 +1336,7 @@ struct drbd_request *find_oldest_request(struct drbd_connection *connection)
 void request_timer_fn(unsigned long data)
 {
 	struct drbd_device *device = (struct drbd_device *) data;
-	struct drbd_connection *connection = device->connection;
+	struct drbd_connection *connection = first_peer_device(device)->connection;
 	struct drbd_request *req; /* oldest request */
 	struct net_conf *nc;
 	unsigned long ent = 0, dt = 0, et, nt; /* effective timeout = ko_count * timeout */
diff --git a/drivers/block/drbd/drbd_req.h b/drivers/block/drbd/drbd_req.h
index 407404b..27283e6 100644
--- a/drivers/block/drbd/drbd_req.h
+++ b/drivers/block/drbd/drbd_req.h
@@ -318,9 +318,9 @@ static inline int req_mod(struct drbd_request *req,
 	struct bio_and_error m;
 	int rv;
 
-	spin_lock_irqsave(&device->connection->req_lock, flags);
+	spin_lock_irqsave(&first_peer_device(device)->connection->req_lock, flags);
 	rv = __req_mod(req, what, &m);
-	spin_unlock_irqrestore(&device->connection->req_lock, flags);
+	spin_unlock_irqrestore(&first_peer_device(device)->connection->req_lock, flags);
 
 	if (m.bio)
 		complete_master_bio(device, &m);
diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index df5098d..f029d12 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -240,10 +240,10 @@ drbd_change_state(struct drbd_device *device, enum chg_state_flags f,
 	union drbd_state ns;
 	enum drbd_state_rv rv;
 
-	spin_lock_irqsave(&device->connection->req_lock, flags);
+	spin_lock_irqsave(&first_peer_device(device)->connection->req_lock, flags);
 	ns = apply_mask_val(drbd_read_state(device), mask, val);
 	rv = _drbd_set_state(device, ns, f, NULL);
-	spin_unlock_irqrestore(&device->connection->req_lock, flags);
+	spin_unlock_irqrestore(&first_peer_device(device)->connection->req_lock, flags);
 
 	return rv;
 }
@@ -274,7 +274,7 @@ _req_st_cond(struct drbd_device *device, union drbd_state mask,
 	if (test_and_clear_bit(CL_ST_CHG_FAIL, &device->flags))
 		return SS_CW_FAILED_BY_PEER;
 
-	spin_lock_irqsave(&device->connection->req_lock, flags);
+	spin_lock_irqsave(&first_peer_device(device)->connection->req_lock, flags);
 	os = drbd_read_state(device);
 	ns = sanitize_state(device, apply_mask_val(os, mask, val), NULL);
 	rv = is_valid_transition(os, ns);
@@ -286,12 +286,12 @@ _req_st_cond(struct drbd_device *device, union drbd_state mask,
 	if (rv == SS_UNKNOWN_ERROR) {
 		rv = is_valid_state(device, ns);
 		if (rv >= SS_SUCCESS) {
-			rv = is_valid_soft_transition(os, ns, device->connection);
+			rv = is_valid_soft_transition(os, ns, first_peer_device(device)->connection);
 			if (rv >= SS_SUCCESS)
 				rv = SS_UNKNOWN_ERROR; /* cont waiting, otherwise fail. */
 		}
 	}
-	spin_unlock_irqrestore(&device->connection->req_lock, flags);
+	spin_unlock_irqrestore(&first_peer_device(device)->connection->req_lock, flags);
 
 	return rv;
 }
@@ -320,20 +320,20 @@ drbd_req_state(struct drbd_device *device, union drbd_state mask,
 	if (f & CS_SERIALIZE)
 		mutex_lock(device->state_mutex);
 
-	spin_lock_irqsave(&device->connection->req_lock, flags);
+	spin_lock_irqsave(&first_peer_device(device)->connection->req_lock, flags);
 	os = drbd_read_state(device);
 	ns = sanitize_state(device, apply_mask_val(os, mask, val), NULL);
 	rv = is_valid_transition(os, ns);
 	if (rv < SS_SUCCESS) {
-		spin_unlock_irqrestore(&device->connection->req_lock, flags);
+		spin_unlock_irqrestore(&first_peer_device(device)->connection->req_lock, flags);
 		goto abort;
 	}
 
 	if (cl_wide_st_chg(device, os, ns)) {
 		rv = is_valid_state(device, ns);
 		if (rv == SS_SUCCESS)
-			rv = is_valid_soft_transition(os, ns, device->connection);
-		spin_unlock_irqrestore(&device->connection->req_lock, flags);
+			rv = is_valid_soft_transition(os, ns, first_peer_device(device)->connection);
+		spin_unlock_irqrestore(&first_peer_device(device)->connection->req_lock, flags);
 
 		if (rv < SS_SUCCESS) {
 			if (f & CS_VERBOSE)
@@ -356,17 +356,17 @@ drbd_req_state(struct drbd_device *device, union drbd_state mask,
 				print_st_err(device, os, ns, rv);
 			goto abort;
 		}
-		spin_lock_irqsave(&device->connection->req_lock, flags);
+		spin_lock_irqsave(&first_peer_device(device)->connection->req_lock, flags);
 		ns = apply_mask_val(drbd_read_state(device), mask, val);
 		rv = _drbd_set_state(device, ns, f, &done);
 	} else {
 		rv = _drbd_set_state(device, ns, f, &done);
 	}
 
-	spin_unlock_irqrestore(&device->connection->req_lock, flags);
+	spin_unlock_irqrestore(&first_peer_device(device)->connection->req_lock, flags);
 
 	if (f & CS_WAIT_COMPLETE && rv == SS_SUCCESS) {
-		D_ASSERT(current != device->connection->worker.task);
+		D_ASSERT(current != first_peer_device(device)->connection->worker.task);
 		wait_for_completion(&done);
 	}
 
@@ -522,12 +522,12 @@ is_valid_state(struct drbd_device *device, union drbd_state ns)
 		put_ldev(device);
 	}
 
-	nc = rcu_dereference(device->connection->net_conf);
+	nc = rcu_dereference(first_peer_device(device)->connection->net_conf);
 	if (nc) {
 		if (!nc->two_primaries && ns.role == R_PRIMARY) {
 			if (ns.peer == R_PRIMARY)
 				rv = SS_TWO_PRIMARIES;
-			else if (conn_highest_peer(device->connection) == R_PRIMARY)
+			else if (conn_highest_peer(first_peer_device(device)->connection) == R_PRIMARY)
 				rv = SS_O_VOL_PEER_PRI;
 		}
 	}
@@ -568,7 +568,7 @@ is_valid_state(struct drbd_device *device, union drbd_state ns)
 		rv = SS_NO_VERIFY_ALG;
 
 	else if ((ns.conn == C_VERIFY_S || ns.conn == C_VERIFY_T) &&
-		  device->connection->agreed_pro_version < 88)
+		  first_peer_device(device)->connection->agreed_pro_version < 88)
 		rv = SS_NOT_SUPPORTED;
 
 	else if (ns.role == R_PRIMARY && ns.disk < D_UP_TO_DATE && ns.pdsk < D_UP_TO_DATE)
@@ -874,7 +874,7 @@ static union drbd_state sanitize_state(struct drbd_device *device, union drbd_st
 	    (ns.role == R_PRIMARY && ns.conn < C_CONNECTED && ns.pdsk > D_OUTDATED))
 		ns.susp_fen = 1; /* Suspend IO while fence-peer handler runs (peer lost) */
 
-	if (device->connection->res_opts.on_no_data == OND_SUSPEND_IO &&
+	if (first_peer_device(device)->connection->res_opts.on_no_data == OND_SUSPEND_IO &&
 	    (ns.role == R_PRIMARY && ns.disk < D_UP_TO_DATE && ns.pdsk < D_UP_TO_DATE))
 		ns.susp_nod = 1; /* Suspend IO while no data available (no accessible data available) */
 
@@ -902,7 +902,7 @@ void drbd_resume_al(struct drbd_device *device)
 /* helper for __drbd_set_state */
 static void set_ov_position(struct drbd_device *device, enum drbd_conns cs)
 {
-	if (device->connection->agreed_pro_version < 90)
+	if (first_peer_device(device)->connection->agreed_pro_version < 90)
 		device->ov_start_sector = 0;
 	device->rs_total = drbd_bm_bits(device);
 	device->ov_position = 0;
@@ -965,9 +965,9 @@ __drbd_set_state(struct drbd_device *device, union drbd_state ns,
 			   this happen...*/
 
 			if (is_valid_state(device, os) == rv)
-				rv = is_valid_soft_transition(os, ns, device->connection);
+				rv = is_valid_soft_transition(os, ns, first_peer_device(device)->connection);
 		} else
-			rv = is_valid_soft_transition(os, ns, device->connection);
+			rv = is_valid_soft_transition(os, ns, first_peer_device(device)->connection);
 	}
 
 	if (rv < SS_SUCCESS) {
@@ -984,7 +984,8 @@ __drbd_set_state(struct drbd_device *device, union drbd_state ns,
 	   sanitize_state(). Only display it here if we where not called from
 	   _conn_request_state() */
 	if (!(flags & CS_DC_SUSP))
-		conn_pr_state_change(device->connection, os, ns, (flags & ~CS_DC_MASK) | CS_DC_SUSP);
+		conn_pr_state_change(first_peer_device(device)->connection, os, ns,
+				     (flags & ~CS_DC_MASK) | CS_DC_SUSP);
 
 	/* if we are going -> D_FAILED or D_DISKLESS, grab one extra reference
 	 * on the ldev here, to be sure the transition -> D_DISKLESS resp.
@@ -997,25 +998,25 @@ __drbd_set_state(struct drbd_device *device, union drbd_state ns,
 	did_remote = drbd_should_do_remote(device->state);
 	device->state.i = ns.i;
 	should_do_remote = drbd_should_do_remote(device->state);
-	device->connection->susp = ns.susp;
-	device->connection->susp_nod = ns.susp_nod;
-	device->connection->susp_fen = ns.susp_fen;
+	first_peer_device(device)->connection->susp = ns.susp;
+	first_peer_device(device)->connection->susp_nod = ns.susp_nod;
+	first_peer_device(device)->connection->susp_fen = ns.susp_fen;
 
 	/* put replicated vs not-replicated requests in seperate epochs */
 	if (did_remote != should_do_remote)
-		start_new_tl_epoch(device->connection);
+		start_new_tl_epoch(first_peer_device(device)->connection);
 
 	if (os.disk == D_ATTACHING && ns.disk >= D_NEGOTIATING)
 		drbd_print_uuids(device, "attached to UUIDs");
 
 	/* Wake up role changes, that were delayed because of connection establishing */
 	if (os.conn == C_WF_REPORT_PARAMS && ns.conn != C_WF_REPORT_PARAMS &&
-	    no_peer_wf_report_params(device->connection))
-		clear_bit(STATE_SENT, &device->connection->flags);
+	    no_peer_wf_report_params(first_peer_device(device)->connection))
+		clear_bit(STATE_SENT, &first_peer_device(device)->connection->flags);
 
 	wake_up(&device->misc_wait);
 	wake_up(&device->state_wait);
-	wake_up(&device->connection->ping_wait);
+	wake_up(&first_peer_device(device)->connection->ping_wait);
 
 	/* Aborted verify run, or we reached the stop sector.
 	 * Log the last position, unless end-of-device. */
@@ -1104,21 +1105,21 @@ __drbd_set_state(struct drbd_device *device, union drbd_state ns,
 
 	/* Receiver should clean up itself */
 	if (os.conn != C_DISCONNECTING && ns.conn == C_DISCONNECTING)
-		drbd_thread_stop_nowait(&device->connection->receiver);
+		drbd_thread_stop_nowait(&first_peer_device(device)->connection->receiver);
 
 	/* Now the receiver finished cleaning up itself, it should die */
 	if (os.conn != C_STANDALONE && ns.conn == C_STANDALONE)
-		drbd_thread_stop_nowait(&device->connection->receiver);
+		drbd_thread_stop_nowait(&first_peer_device(device)->connection->receiver);
 
 	/* Upon network failure, we need to restart the receiver. */
 	if (os.conn > C_WF_CONNECTION &&
 	    ns.conn <= C_TEAR_DOWN && ns.conn >= C_TIMEOUT)
-		drbd_thread_restart_nowait(&device->connection->receiver);
+		drbd_thread_restart_nowait(&first_peer_device(device)->connection->receiver);
 
 	/* Resume AL writing if we get a connection */
 	if (os.conn < C_CONNECTED && ns.conn >= C_CONNECTED) {
 		drbd_resume_al(device);
-		device->connection->connect_cnt++;
+		first_peer_device(device)->connection->connect_cnt++;
 	}
 
 	/* remember last attach time so request_timer_fn() won't
@@ -1136,7 +1137,7 @@ __drbd_set_state(struct drbd_device *device, union drbd_state ns,
 		ascw->w.cb = w_after_state_ch;
 		ascw->w.device = device;
 		ascw->done = done;
-		drbd_queue_work(&device->connection->sender_work, &ascw->w);
+		drbd_queue_work(&first_peer_device(device)->connection->sender_work, &ascw->w);
 	} else {
 		dev_err(DEV, "Could not kmalloc an ascw\n");
 	}
@@ -1184,7 +1185,7 @@ int drbd_bitmap_io_from_worker(struct drbd_device *device,
 {
 	int rv;
 
-	D_ASSERT(current == device->connection->worker.task);
+	D_ASSERT(current == first_peer_device(device)->connection->worker.task);
 
 	/* open coded non-blocking drbd_suspend_io(device); */
 	set_bit(SUSPEND_IO, &device->flags);
@@ -1231,7 +1232,7 @@ static void after_state_ch(struct drbd_device *device, union drbd_state os,
 	   state change. This function might sleep */
 
 	if (ns.susp_nod) {
-		struct drbd_connection *connection = device->connection;
+		struct drbd_connection *connection = first_peer_device(device)->connection;
 		enum drbd_req_event what = NOTHING;
 
 		spin_lock_irq(&connection->req_lock);
@@ -1253,7 +1254,7 @@ static void after_state_ch(struct drbd_device *device, union drbd_state os,
 	}
 
 	if (ns.susp_fen) {
-		struct drbd_connection *connection = device->connection;
+		struct drbd_connection *connection = first_peer_device(device)->connection;
 
 		spin_lock_irq(&connection->req_lock);
 		if (connection->susp_fen && conn_lowest_conn(connection) >= C_CONNECTED) {
@@ -1280,7 +1281,7 @@ static void after_state_ch(struct drbd_device *device, union drbd_state os,
 	 * which is unexpected. */
 	if ((os.conn != C_SYNC_SOURCE && os.conn != C_PAUSED_SYNC_S) &&
 	    (ns.conn == C_SYNC_SOURCE || ns.conn == C_PAUSED_SYNC_S) &&
-	    device->connection->agreed_pro_version >= 96 && get_ldev(device)) {
+	    first_peer_device(device)->connection->agreed_pro_version >= 96 && get_ldev(device)) {
 		drbd_gen_and_send_sync_uuid(device);
 		put_ldev(device);
 	}
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index eb2565c..272fbd1 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -102,16 +102,16 @@ void drbd_endio_read_sec_final(struct drbd_peer_request *peer_req) __releases(lo
 	unsigned long flags = 0;
 	struct drbd_device *device = peer_req->w.device;
 
-	spin_lock_irqsave(&device->connection->req_lock, flags);
+	spin_lock_irqsave(&first_peer_device(device)->connection->req_lock, flags);
 	device->read_cnt += peer_req->i.size >> 9;
 	list_del(&peer_req->w.list);
 	if (list_empty(&device->read_ee))
 		wake_up(&device->ee_wait);
 	if (test_bit(__EE_WAS_ERROR, &peer_req->flags))
 		__drbd_chk_io_error(device, DRBD_READ_ERROR);
-	spin_unlock_irqrestore(&device->connection->req_lock, flags);
+	spin_unlock_irqrestore(&first_peer_device(device)->connection->req_lock, flags);
 
-	drbd_queue_work(&device->connection->sender_work, &peer_req->w);
+	drbd_queue_work(&first_peer_device(device)->connection->sender_work, &peer_req->w);
 	put_ldev(device);
 }
 
@@ -134,7 +134,7 @@ static void drbd_endio_write_sec_final(struct drbd_peer_request *peer_req) __rel
 	do_al_complete_io = peer_req->flags & EE_CALL_AL_COMPLETE_IO;
 	block_id = peer_req->block_id;
 
-	spin_lock_irqsave(&device->connection->req_lock, flags);
+	spin_lock_irqsave(&first_peer_device(device)->connection->req_lock, flags);
 	device->writ_cnt += peer_req->i.size >> 9;
 	list_move_tail(&peer_req->w.list, &device->done_ee);
 
@@ -150,7 +150,7 @@ static void drbd_endio_write_sec_final(struct drbd_peer_request *peer_req) __rel
 
 	if (test_bit(__EE_WAS_ERROR, &peer_req->flags))
 		__drbd_chk_io_error(device, DRBD_WRITE_ERROR);
-	spin_unlock_irqrestore(&device->connection->req_lock, flags);
+	spin_unlock_irqrestore(&first_peer_device(device)->connection->req_lock, flags);
 
 	if (block_id == ID_SYNCER)
 		drbd_rs_complete_io(device, i.sector);
@@ -161,7 +161,7 @@ static void drbd_endio_write_sec_final(struct drbd_peer_request *peer_req) __rel
 	if (do_al_complete_io)
 		drbd_al_complete_io(device, &i);
 
-	wake_asender(device->connection);
+	wake_asender(first_peer_device(device)->connection);
 	put_ldev(device);
 }
 
@@ -273,9 +273,9 @@ void drbd_request_endio(struct bio *bio, int error)
 	req->private_bio = ERR_PTR(error);
 
 	/* not req_mod(), we need irqsave here! */
-	spin_lock_irqsave(&device->connection->req_lock, flags);
+	spin_lock_irqsave(&first_peer_device(device)->connection->req_lock, flags);
 	__req_mod(req, what, &m);
-	spin_unlock_irqrestore(&device->connection->req_lock, flags);
+	spin_unlock_irqrestore(&first_peer_device(device)->connection->req_lock, flags);
 	put_ldev(device);
 
 	if (m.bio)
@@ -345,12 +345,12 @@ static int w_e_send_csum(struct drbd_work *w, int cancel)
 	if (unlikely((peer_req->flags & EE_WAS_ERROR) != 0))
 		goto out;
 
-	digest_size = crypto_hash_digestsize(device->connection->csums_tfm);
+	digest_size = crypto_hash_digestsize(first_peer_device(device)->connection->csums_tfm);
 	digest = kmalloc(digest_size, GFP_NOIO);
 	if (digest) {
 		sector_t sector = peer_req->i.sector;
 		unsigned int size = peer_req->i.size;
-		drbd_csum_ee(device, device->connection->csums_tfm, peer_req, digest);
+		drbd_csum_ee(device, first_peer_device(device)->connection->csums_tfm, peer_req, digest);
 		/* Free peer_req and pages before send.
 		 * In case we block on congestion, we could otherwise run into
 		 * some distributed deadlock, if the other side blocks on
@@ -397,9 +397,9 @@ static int read_for_csum(struct drbd_device *device, sector_t sector, int size)
 		goto defer;
 
 	peer_req->w.cb = w_e_send_csum;
-	spin_lock_irq(&device->connection->req_lock);
+	spin_lock_irq(&first_peer_device(device)->connection->req_lock);
 	list_add(&peer_req->w.list, &device->read_ee);
-	spin_unlock_irq(&device->connection->req_lock);
+	spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
 
 	atomic_add(size >> 9, &device->rs_sect_ev);
 	if (drbd_submit_peer_request(device, peer_req, READ, DRBD_FAULT_RS_RD) == 0)
@@ -409,9 +409,9 @@ static int read_for_csum(struct drbd_device *device, sector_t sector, int size)
 	 * because bio_add_page failed (probably broken lower level driver),
 	 * retry may or may not help.
 	 * If it does not, you may need to force disconnect. */
-	spin_lock_irq(&device->connection->req_lock);
+	spin_lock_irq(&first_peer_device(device)->connection->req_lock);
 	list_del(&peer_req->w.list);
-	spin_unlock_irq(&device->connection->req_lock);
+	spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
 
 	drbd_free_peer_req(device, peer_req);
 defer:
@@ -439,7 +439,7 @@ void resync_timer_fn(unsigned long data)
 	struct drbd_device *device = (struct drbd_device *) data;
 
 	if (list_empty(&device->resync_work.list))
-		drbd_queue_work(&device->connection->sender_work, &device->resync_work);
+		drbd_queue_work(&first_peer_device(device)->connection->sender_work, &device->resync_work);
 }
 
 static void fifo_set(struct fifo_buffer *fb, int value)
@@ -597,15 +597,15 @@ int w_make_resync_request(struct drbd_work *w, int cancel)
 
 	for (i = 0; i < number; i++) {
 		/* Stop generating RS requests, when half of the send buffer is filled */
-		mutex_lock(&device->connection->data.mutex);
-		if (device->connection->data.socket) {
-			queued = device->connection->data.socket->sk->sk_wmem_queued;
-			sndbuf = device->connection->data.socket->sk->sk_sndbuf;
+		mutex_lock(&first_peer_device(device)->connection->data.mutex);
+		if (first_peer_device(device)->connection->data.socket) {
+			queued = first_peer_device(device)->connection->data.socket->sk->sk_wmem_queued;
+			sndbuf = first_peer_device(device)->connection->data.socket->sk->sk_sndbuf;
 		} else {
 			queued = 1;
 			sndbuf = 0;
 		}
-		mutex_unlock(&device->connection->data.mutex);
+		mutex_unlock(&first_peer_device(device)->connection->data.mutex);
 		if (queued > sndbuf / 2)
 			goto requeue;
 
@@ -675,7 +675,8 @@ next_sector:
 		/* adjust very last sectors, in case we are oddly sized */
 		if (sector + (size>>9) > capacity)
 			size = (capacity-sector)<<9;
-		if (device->connection->agreed_pro_version >= 89 && device->connection->csums_tfm) {
+		if (first_peer_device(device)->connection->agreed_pro_version >= 89 &&
+		    first_peer_device(device)->connection->csums_tfm) {
 			switch (read_for_csum(device, sector, size)) {
 			case -EIO: /* Disk failure */
 				put_ldev(device);
@@ -800,7 +801,7 @@ static int w_resync_finished(struct drbd_work *w, int cancel)
 
 static void ping_peer(struct drbd_device *device)
 {
-	struct drbd_connection *connection = device->connection;
+	struct drbd_connection *connection = first_peer_device(device)->connection;
 
 	clear_bit(GOT_PING_ACK, &connection->flags);
 	request_ping(connection);
@@ -831,7 +832,7 @@ int drbd_resync_finished(struct drbd_device *device)
 		if (w) {
 			w->cb = w_resync_finished;
 			w->device = device;
-			drbd_queue_work(&device->connection->sender_work, w);
+			drbd_queue_work(&first_peer_device(device)->connection->sender_work, w);
 			return 1;
 		}
 		dev_err(DEV, "Warn failed to drbd_rs_del_all() and to kmalloc(w).\n");
@@ -854,7 +855,7 @@ int drbd_resync_finished(struct drbd_device *device)
 
 	ping_peer(device);
 
-	spin_lock_irq(&device->connection->req_lock);
+	spin_lock_irq(&first_peer_device(device)->connection->req_lock);
 	os = drbd_read_state(device);
 
 	verify_done = (os.conn == C_VERIFY_S || os.conn == C_VERIFY_T);
@@ -885,7 +886,7 @@ int drbd_resync_finished(struct drbd_device *device)
 		if (os.conn == C_SYNC_TARGET || os.conn == C_PAUSED_SYNC_T)
 			khelper_cmd = "after-resync-target";
 
-		if (device->connection->csums_tfm && device->rs_total) {
+		if (first_peer_device(device)->connection->csums_tfm && device->rs_total) {
 			const unsigned long s = device->rs_same_csum;
 			const unsigned long t = device->rs_total;
 			const int ratio =
@@ -943,7 +944,7 @@ int drbd_resync_finished(struct drbd_device *device)
 
 	_drbd_set_state(device, ns, CS_VERBOSE, NULL);
 out_unlock:
-	spin_unlock_irq(&device->connection->req_lock);
+	spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
 	put_ldev(device);
 out:
 	device->rs_total  = 0;
@@ -970,9 +971,9 @@ static void move_to_net_ee_or_free(struct drbd_device *device, struct drbd_peer_
 		int i = (peer_req->i.size + PAGE_SIZE -1) >> PAGE_SHIFT;
 		atomic_add(i, &device->pp_in_use_by_net);
 		atomic_sub(i, &device->pp_in_use);
-		spin_lock_irq(&device->connection->req_lock);
+		spin_lock_irq(&first_peer_device(device)->connection->req_lock);
 		list_add_tail(&peer_req->w.list, &device->net_ee);
-		spin_unlock_irq(&device->connection->req_lock);
+		spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
 		wake_up(&drbd_pp_wait);
 	} else
 		drbd_free_peer_req(device, peer_req);
@@ -1096,13 +1097,13 @@ int w_e_end_csum_rs_req(struct drbd_work *w, int cancel)
 		/* quick hack to try to avoid a race against reconfiguration.
 		 * a real fix would be much more involved,
 		 * introducing more locking mechanisms */
-		if (device->connection->csums_tfm) {
-			digest_size = crypto_hash_digestsize(device->connection->csums_tfm);
+		if (first_peer_device(device)->connection->csums_tfm) {
+			digest_size = crypto_hash_digestsize(first_peer_device(device)->connection->csums_tfm);
 			D_ASSERT(digest_size == di->digest_size);
 			digest = kmalloc(digest_size, GFP_NOIO);
 		}
 		if (digest) {
-			drbd_csum_ee(device, device->connection->csums_tfm, peer_req, digest);
+			drbd_csum_ee(device, first_peer_device(device)->connection->csums_tfm, peer_req, digest);
 			eq = !memcmp(digest, di->digest, digest_size);
 			kfree(digest);
 		}
@@ -1146,7 +1147,7 @@ int w_e_end_ov_req(struct drbd_work *w, int cancel)
 	if (unlikely(cancel))
 		goto out;
 
-	digest_size = crypto_hash_digestsize(device->connection->verify_tfm);
+	digest_size = crypto_hash_digestsize(first_peer_device(device)->connection->verify_tfm);
 	digest = kmalloc(digest_size, GFP_NOIO);
 	if (!digest) {
 		err = 1;	/* terminate the connection in case the allocation failed */
@@ -1154,7 +1155,7 @@ int w_e_end_ov_req(struct drbd_work *w, int cancel)
 	}
 
 	if (likely(!(peer_req->flags & EE_WAS_ERROR)))
-		drbd_csum_ee(device, device->connection->verify_tfm, peer_req, digest);
+		drbd_csum_ee(device, first_peer_device(device)->connection->verify_tfm, peer_req, digest);
 	else
 		memset(digest, 0, digest_size);
 
@@ -1217,10 +1218,10 @@ int w_e_end_ov_reply(struct drbd_work *w, int cancel)
 	di = peer_req->digest;
 
 	if (likely((peer_req->flags & EE_WAS_ERROR) == 0)) {
-		digest_size = crypto_hash_digestsize(device->connection->verify_tfm);
+		digest_size = crypto_hash_digestsize(first_peer_device(device)->connection->verify_tfm);
 		digest = kmalloc(digest_size, GFP_NOIO);
 		if (digest) {
-			drbd_csum_ee(device, device->connection->verify_tfm, peer_req, digest);
+			drbd_csum_ee(device, first_peer_device(device)->connection->verify_tfm, peer_req, digest);
 
 			D_ASSERT(digest_size == di->digest_size);
 			eq = !memcmp(digest, di->digest, digest_size);
@@ -1297,7 +1298,7 @@ int w_send_write_hint(struct drbd_work *w, int cancel)
 
 	if (cancel)
 		return 0;
-	sock = &device->connection->data;
+	sock = &first_peer_device(device)->connection->data;
 	if (!drbd_prepare_command(device, sock))
 		return -EIO;
 	return drbd_send_command(device, sock, P_UNPLUG_REMOTE, 0, NULL, 0);
@@ -1328,7 +1329,7 @@ int w_send_out_of_sync(struct drbd_work *w, int cancel)
 {
 	struct drbd_request *req = container_of(w, struct drbd_request, w);
 	struct drbd_device *device = w->device;
-	struct drbd_connection *connection = device->connection;
+	struct drbd_connection *connection = first_peer_device(device)->connection;
 	int err;
 
 	if (unlikely(cancel)) {
@@ -1358,7 +1359,7 @@ int w_send_dblock(struct drbd_work *w, int cancel)
 {
 	struct drbd_request *req = container_of(w, struct drbd_request, w);
 	struct drbd_device *device = w->device;
-	struct drbd_connection *connection = device->connection;
+	struct drbd_connection *connection = first_peer_device(device)->connection;
 	int err;
 
 	if (unlikely(cancel)) {
@@ -1386,7 +1387,7 @@ int w_send_read_req(struct drbd_work *w, int cancel)
 {
 	struct drbd_request *req = container_of(w, struct drbd_request, w);
 	struct drbd_device *device = w->device;
-	struct drbd_connection *connection = device->connection;
+	struct drbd_connection *connection = first_peer_device(device)->connection;
 	int err;
 
 	if (unlikely(cancel)) {
@@ -1581,7 +1582,7 @@ void start_resync_timer_fn(unsigned long data)
 {
 	struct drbd_device *device = (struct drbd_device *) data;
 
-	drbd_queue_work(&device->connection->sender_work, &device->start_resync_work);
+	drbd_queue_work(&first_peer_device(device)->connection->sender_work, &device->start_resync_work);
 }
 
 int w_start_resync(struct drbd_work *w, int cancel)
@@ -1628,7 +1629,7 @@ void drbd_start_resync(struct drbd_device *device, enum drbd_conns side)
 			if (r > 0) {
 				dev_info(DEV, "before-resync-target handler returned %d, "
 					 "dropping connection.\n", r);
-				conn_request_state(device->connection, NS(conn, C_DISCONNECTING), CS_HARD);
+				conn_request_state(first_peer_device(device)->connection, NS(conn, C_DISCONNECTING), CS_HARD);
 				return;
 			}
 		} else /* C_SYNC_SOURCE */ {
@@ -1641,14 +1642,15 @@ void drbd_start_resync(struct drbd_device *device, enum drbd_conns side)
 				} else {
 					dev_info(DEV, "before-resync-source handler returned %d, "
 						 "dropping connection.\n", r);
-					conn_request_state(device->connection, NS(conn, C_DISCONNECTING), CS_HARD);
+					conn_request_state(first_peer_device(device)->connection,
+							   NS(conn, C_DISCONNECTING), CS_HARD);
 					return;
 				}
 			}
 		}
 	}
 
-	if (current == device->connection->worker.task) {
+	if (current == first_peer_device(device)->connection->worker.task) {
 		/* The worker should not sleep waiting for state_mutex,
 		   that can take long */
 		if (!mutex_trylock(device->state_mutex)) {
@@ -1727,10 +1729,12 @@ void drbd_start_resync(struct drbd_device *device, enum drbd_conns side)
 		 * drbd_resync_finished from here in that case.
 		 * We drbd_gen_and_send_sync_uuid here for protocol < 96,
 		 * and from after_state_ch otherwise. */
-		if (side == C_SYNC_SOURCE && device->connection->agreed_pro_version < 96)
+		if (side == C_SYNC_SOURCE &&
+		    first_peer_device(device)->connection->agreed_pro_version < 96)
 			drbd_gen_and_send_sync_uuid(device);
 
-		if (device->connection->agreed_pro_version < 95 && device->rs_total == 0) {
+		if (first_peer_device(device)->connection->agreed_pro_version < 95 &&
+		    device->rs_total == 0) {
 			/* This still has a race (about when exactly the peers
 			 * detect connection loss) that can lead to a full sync
 			 * on next handshake. In 8.3.9 we fixed this with explicit
@@ -1746,7 +1750,7 @@ void drbd_start_resync(struct drbd_device *device, enum drbd_conns side)
 				int timeo;
 
 				rcu_read_lock();
-				nc = rcu_dereference(device->connection->net_conf);
+				nc = rcu_dereference(first_peer_device(device)->connection->net_conf);
 				timeo = nc->ping_int * HZ + nc->ping_timeo * HZ / 9;
 				rcu_read_unlock();
 				schedule_timeout_interruptible(timeo);
-- 
1.7.9.5

