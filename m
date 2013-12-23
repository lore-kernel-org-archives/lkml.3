Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368Ab3LWWBQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 17:01:16 -0500
Received: from zimbra13.linbit.com ([212.69.166.240]:60686 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932455Ab3LWV7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 16:59:00 -0500
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 04/27] drbd: Move conf_mutex from connection to resource
Date: Mon, 23 Dec 2013 22:50:33 +0100
Message-Id: <1387835456-29695-5-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387835456-29695-1-git-send-email-philipp.reisner@linbit.com>
References: <1387835456-29695-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Andreas Gruenbacher <agruen@linbit.com>
Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |   15 +++--
 drivers/block/drbd/drbd_main.c     |   36 +++++------
 drivers/block/drbd/drbd_nl.c       |   50 ++++++++--------
 drivers/block/drbd/drbd_receiver.c |  116 ++++++++++++++++++------------------
 drivers/block/drbd/drbd_req.c      |   18 +++---
 drivers/block/drbd/drbd_req.h      |    4 +-
 drivers/block/drbd/drbd_state.c    |   48 +++++++--------
 drivers/block/drbd/drbd_worker.c   |   34 +++++------
 8 files changed, 160 insertions(+), 161 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index e0b42f0..bdfa1de 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -513,7 +513,7 @@ struct drbd_backing_dev {
 	struct block_device *backing_bdev;
 	struct block_device *md_bdev;
 	struct drbd_md md;
-	struct disk_conf *disk_conf; /* RCU, for updates: first_peer_device(device)->connection->conf_update */
+	struct disk_conf *disk_conf; /* RCU, for updates: resource->conf_update */
 	sector_t known_size; /* last known size of that backing device */
 };
 
@@ -573,6 +573,8 @@ struct drbd_resource {
 	struct list_head connections;
 	struct list_head resources;
 	struct res_opts res_opts;
+	struct mutex conf_update;	/* mutex for ready-copy-update of net_conf and disk_conf */
+	spinlock_t req_lock;
 };
 
 struct drbd_connection {
@@ -589,7 +591,6 @@ struct drbd_connection {
 
 	unsigned long flags;
 	struct net_conf *net_conf;	/* content protected by rcu */
-	struct mutex conf_update;	/* mutex for ready-copy-update of net_conf and disk_conf */
 	wait_queue_head_t ping_wait;	/* Woken upon reception of a ping, and a state change */
 
 	struct sockaddr_storage my_addr;
@@ -603,8 +604,6 @@ struct drbd_connection {
 	unsigned long last_received;	/* in jiffies, either socket */
 	unsigned int ko_count;
 
-	spinlock_t req_lock;
-
 	struct list_head transfer_log;	/* all requests not yet fully processed */
 
 	struct crypto_hash *cram_hmac_tfm;
@@ -1590,9 +1589,9 @@ static inline void drbd_chk_io_error_(struct drbd_device *device,
 {
 	if (error) {
 		unsigned long flags;
-		spin_lock_irqsave(&first_peer_device(device)->connection->req_lock, flags);
+		spin_lock_irqsave(&device->resource->req_lock, flags);
 		__drbd_chk_io_error_(device, forcedetach, where);
-		spin_unlock_irqrestore(&first_peer_device(device)->connection->req_lock, flags);
+		spin_unlock_irqrestore(&device->resource->req_lock, flags);
 	}
 }
 
@@ -2064,11 +2063,11 @@ static inline bool inc_ap_bio_cond(struct drbd_device *device)
 {
 	bool rv = false;
 
-	spin_lock_irq(&first_peer_device(device)->connection->req_lock);
+	spin_lock_irq(&device->resource->req_lock);
 	rv = may_inc_ap_bio(device);
 	if (rv)
 		atomic_inc(&device->ap_bio_cnt);
-	spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
+	spin_unlock_irq(&device->resource->req_lock);
 
 	return rv;
 }
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index c4aec68..43b9141 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -200,7 +200,7 @@ void tl_release(struct drbd_connection *connection, unsigned int barrier_nr,
 	int expect_epoch = 0;
 	int expect_size = 0;
 
-	spin_lock_irq(&connection->req_lock);
+	spin_lock_irq(&connection->resource->req_lock);
 
 	/* find oldest not yet barrier-acked write request,
 	 * count writes in its epoch. */
@@ -257,12 +257,12 @@ void tl_release(struct drbd_connection *connection, unsigned int barrier_nr,
 			break;
 		_req_mod(req, BARRIER_ACKED);
 	}
-	spin_unlock_irq(&connection->req_lock);
+	spin_unlock_irq(&connection->resource->req_lock);
 
 	return;
 
 bail:
-	spin_unlock_irq(&connection->req_lock);
+	spin_unlock_irq(&connection->resource->req_lock);
 	conn_request_state(connection, NS(conn, C_PROTOCOL_ERROR), CS_HARD);
 }
 
@@ -286,9 +286,9 @@ void _tl_restart(struct drbd_connection *connection, enum drbd_req_event what)
 
 void tl_restart(struct drbd_connection *connection, enum drbd_req_event what)
 {
-	spin_lock_irq(&connection->req_lock);
+	spin_lock_irq(&connection->resource->req_lock);
 	_tl_restart(connection, what);
-	spin_unlock_irq(&connection->req_lock);
+	spin_unlock_irq(&connection->resource->req_lock);
 }
 
 /**
@@ -313,7 +313,7 @@ void tl_abort_disk_io(struct drbd_device *device)
 	struct drbd_connection *connection = first_peer_device(device)->connection;
 	struct drbd_request *req, *r;
 
-	spin_lock_irq(&connection->req_lock);
+	spin_lock_irq(&connection->resource->req_lock);
 	list_for_each_entry_safe(req, r, &connection->transfer_log, tl_requests) {
 		if (!(req->rq_state & RQ_LOCAL_PENDING))
 			continue;
@@ -321,7 +321,7 @@ void tl_abort_disk_io(struct drbd_device *device)
 			continue;
 		_req_mod(req, ABORT_DISK_IO);
 	}
-	spin_unlock_irq(&connection->req_lock);
+	spin_unlock_irq(&connection->resource->req_lock);
 }
 
 static int drbd_thread_setup(void *arg)
@@ -1838,7 +1838,7 @@ static int drbd_open(struct block_device *bdev, fmode_t mode)
 	int rv = 0;
 
 	mutex_lock(&drbd_main_mutex);
-	spin_lock_irqsave(&first_peer_device(device)->connection->req_lock, flags);
+	spin_lock_irqsave(&device->resource->req_lock, flags);
 	/* to have a stable device->state.role
 	 * and no race with updating open_cnt */
 
@@ -1851,7 +1851,7 @@ static int drbd_open(struct block_device *bdev, fmode_t mode)
 
 	if (!rv)
 		device->open_cnt++;
-	spin_unlock_irqrestore(&first_peer_device(device)->connection->req_lock, flags);
+	spin_unlock_irqrestore(&device->resource->req_lock, flags);
 	mutex_unlock(&drbd_main_mutex);
 
 	return rv;
@@ -2548,6 +2548,8 @@ struct drbd_resource *drbd_create_resource(const char *name)
 	idr_init(&resource->devices);
 	INIT_LIST_HEAD(&resource->connections);
 	list_add_tail_rcu(&resource->resources, &drbd_resources);
+	mutex_init(&resource->conf_update);
+	spin_lock_init(&resource->req_lock);
 	return resource;
 }
 
@@ -2590,8 +2592,6 @@ struct drbd_connection *conn_create(const char *name, struct res_opts *res_opts)
 
 	connection->cstate = C_STANDALONE;
 	mutex_init(&connection->cstate_mutex);
-	spin_lock_init(&connection->req_lock);
-	mutex_init(&connection->conf_update);
 	init_waitqueue_head(&connection->ping_wait);
 	idr_init(&connection->peer_devices);
 
@@ -2722,7 +2722,7 @@ enum drbd_ret_code drbd_create_device(struct drbd_resource *resource, unsigned i
 	blk_queue_max_hw_sectors(q, DRBD_MAX_BIO_SIZE_SAFE >> 8);
 	blk_queue_bounce_limit(q, BLK_BOUNCE_ANY);
 	blk_queue_merge_bvec(q, drbd_merge_bvec);
-	q->queue_lock = &connection->req_lock;
+	q->queue_lock = &resource->req_lock;
 
 	device->md_io_page = alloc_page(GFP_KERNEL);
 	if (!device->md_io_page)
@@ -3283,14 +3283,14 @@ int drbd_md_read(struct drbd_device *device, struct drbd_backing_dev *bdev)
 
 	rv = NO_ERROR;
 
-	spin_lock_irq(&first_peer_device(device)->connection->req_lock);
+	spin_lock_irq(&device->resource->req_lock);
 	if (device->state.conn < C_CONNECTED) {
 		unsigned int peer;
 		peer = be32_to_cpu(buffer->la_peer_max_bio_size);
 		peer = max(peer, DRBD_MAX_BIO_SIZE_SAFE);
 		device->peer_max_bio_size = peer;
 	}
-	spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
+	spin_unlock_irq(&device->resource->req_lock);
 
  err:
 	drbd_md_put_buffer(device);
@@ -3579,13 +3579,13 @@ void drbd_queue_bitmap_io(struct drbd_device *device,
 	device->bm_io_work.why = why;
 	device->bm_io_work.flags = flags;
 
-	spin_lock_irq(&first_peer_device(device)->connection->req_lock);
+	spin_lock_irq(&device->resource->req_lock);
 	set_bit(BITMAP_IO, &device->flags);
 	if (atomic_read(&device->ap_bio_cnt) == 0) {
 		if (!test_and_set_bit(BITMAP_IO_QUEUED, &device->flags))
 			drbd_queue_work(&first_peer_device(device)->connection->sender_work, &device->bm_io_work.w);
 	}
-	spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
+	spin_unlock_irq(&device->resource->req_lock);
 }
 
 /**
@@ -3753,10 +3753,10 @@ int drbd_wait_misc(struct drbd_device *device, struct drbd_interval *i)
 	/* Indicate to wake up device->misc_wait on progress.  */
 	i->waiting = true;
 	prepare_to_wait(&device->misc_wait, &wait, TASK_INTERRUPTIBLE);
-	spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
+	spin_unlock_irq(&device->resource->req_lock);
 	timeout = schedule_timeout(timeout);
 	finish_wait(&device->misc_wait, &wait);
-	spin_lock_irq(&first_peer_device(device)->connection->req_lock);
+	spin_lock_irq(&device->resource->req_lock);
 	if (!timeout || device->state.conn < C_CONNECTED)
 		return -ETIMEDOUT;
 	if (signal_pending(current))
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 372efd5..5ccfebb 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -443,9 +443,9 @@ bool conn_try_outdate_peer(struct drbd_connection *connection)
 		return false;
 	}
 
-	spin_lock_irq(&connection->req_lock);
+	spin_lock_irq(&connection->resource->req_lock);
 	connect_cnt = connection->connect_cnt;
-	spin_unlock_irq(&connection->req_lock);
+	spin_unlock_irq(&connection->resource->req_lock);
 
 	fp = highest_fencing_policy(connection);
 	switch (fp) {
@@ -510,7 +510,7 @@ bool conn_try_outdate_peer(struct drbd_connection *connection)
 	   conn_request_state(connection, mask, val, CS_VERBOSE);
 	   here, because we might were able to re-establish the connection in the
 	   meantime. */
-	spin_lock_irq(&connection->req_lock);
+	spin_lock_irq(&connection->resource->req_lock);
 	if (connection->cstate < C_WF_REPORT_PARAMS && !test_bit(STATE_SENT, &connection->flags)) {
 		if (connection->connect_cnt != connect_cnt)
 			/* In case the connection was established and droped
@@ -519,7 +519,7 @@ bool conn_try_outdate_peer(struct drbd_connection *connection)
 		else
 			_conn_request_state(connection, mask, val, CS_VERBOSE);
 	}
-	spin_unlock_irq(&connection->req_lock);
+	spin_unlock_irq(&connection->resource->req_lock);
 
 	return conn_highest_pdsk(connection) <= D_OUTDATED;
 }
@@ -654,11 +654,11 @@ drbd_set_role(struct drbd_device *device, enum drbd_role new_role, int force)
 			put_ldev(device);
 		}
 	} else {
-		mutex_lock(&first_peer_device(device)->connection->conf_update);
+		mutex_lock(&device->resource->conf_update);
 		nc = first_peer_device(device)->connection->net_conf;
 		if (nc)
 			nc->discard_my_data = 0; /* without copy; single bit op is atomic */
-		mutex_unlock(&first_peer_device(device)->connection->conf_update);
+		mutex_unlock(&device->resource->conf_update);
 
 		set_disk_ro(device->vdisk, false);
 		if (get_ldev(device)) {
@@ -1188,10 +1188,10 @@ static void conn_reconfig_start(struct drbd_connection *connection)
 static void conn_reconfig_done(struct drbd_connection *connection)
 {
 	bool stop_threads;
-	spin_lock_irq(&connection->req_lock);
+	spin_lock_irq(&connection->resource->req_lock);
 	stop_threads = conn_all_vols_unconf(connection) &&
 		connection->cstate == C_STANDALONE;
-	spin_unlock_irq(&connection->req_lock);
+	spin_unlock_irq(&connection->resource->req_lock);
 	if (stop_threads) {
 		/* asender is implicitly stopped by receiver
 		 * in conn_disconnect() */
@@ -1211,10 +1211,10 @@ static void drbd_suspend_al(struct drbd_device *device)
 	}
 
 	drbd_al_shrink(device);
-	spin_lock_irq(&first_peer_device(device)->connection->req_lock);
+	spin_lock_irq(&device->resource->req_lock);
 	if (device->state.conn < C_CONNECTED)
 		s = !test_and_set_bit(AL_SUSPENDED, &device->flags);
-	spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
+	spin_unlock_irq(&device->resource->req_lock);
 	lc_unlock(device->act_log);
 
 	if (s)
@@ -1285,7 +1285,7 @@ int drbd_adm_disk_opts(struct sk_buff *skb, struct genl_info *info)
 		goto fail;
 	}
 
-	mutex_lock(&first_peer_device(device)->connection->conf_update);
+	mutex_lock(&device->resource->conf_update);
 	old_disk_conf = device->ldev->disk_conf;
 	*new_disk_conf = *old_disk_conf;
 	if (should_set_defaults(info))
@@ -1348,7 +1348,7 @@ int drbd_adm_disk_opts(struct sk_buff *skb, struct genl_info *info)
 		rcu_assign_pointer(device->rs_plan_s, new_plan);
 	}
 
-	mutex_unlock(&first_peer_device(device)->connection->conf_update);
+	mutex_unlock(&device->resource->conf_update);
 
 	if (new_disk_conf->al_updates)
 		device->ldev->md.flags &= ~MDF_AL_DISABLED;
@@ -1374,7 +1374,7 @@ int drbd_adm_disk_opts(struct sk_buff *skb, struct genl_info *info)
 	goto success;
 
 fail_unlock:
-	mutex_unlock(&first_peer_device(device)->connection->conf_update);
+	mutex_unlock(&device->resource->conf_update);
  fail:
 	kfree(new_disk_conf);
 	kfree(new_plan);
@@ -1724,7 +1724,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 	if (_drbd_bm_total_weight(device) == drbd_bm_bits(device))
 		drbd_suspend_al(device); /* IO is still suspended here... */
 
-	spin_lock_irq(&first_peer_device(device)->connection->req_lock);
+	spin_lock_irq(&device->resource->req_lock);
 	os = drbd_read_state(device);
 	ns = os;
 	/* If MDF_CONSISTENT is not set go into inconsistent state,
@@ -1776,7 +1776,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	rv = _drbd_set_state(device, ns, CS_VERBOSE, NULL);
-	spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
+	spin_unlock_irq(&device->resource->req_lock);
 
 	if (rv < SS_SUCCESS)
 		goto force_diskless_dec;
@@ -2077,7 +2077,7 @@ int drbd_adm_net_opts(struct sk_buff *skb, struct genl_info *info)
 	conn_reconfig_start(connection);
 
 	mutex_lock(&connection->data.mutex);
-	mutex_lock(&connection->conf_update);
+	mutex_lock(&connection->resource->conf_update);
 	old_net_conf = connection->net_conf;
 
 	if (!old_net_conf) {
@@ -2141,7 +2141,7 @@ int drbd_adm_net_opts(struct sk_buff *skb, struct genl_info *info)
 	crypto_free_hash(connection->cram_hmac_tfm);
 	connection->cram_hmac_tfm = crypto.cram_hmac_tfm;
 
-	mutex_unlock(&connection->conf_update);
+	mutex_unlock(&connection->resource->conf_update);
 	mutex_unlock(&connection->data.mutex);
 	synchronize_rcu();
 	kfree(old_net_conf);
@@ -2152,7 +2152,7 @@ int drbd_adm_net_opts(struct sk_buff *skb, struct genl_info *info)
 	goto done;
 
  fail:
-	mutex_unlock(&connection->conf_update);
+	mutex_unlock(&connection->resource->conf_update);
 	mutex_unlock(&connection->data.mutex);
 	free_crypto(&crypto);
 	kfree(new_net_conf);
@@ -2243,11 +2243,11 @@ int drbd_adm_connect(struct sk_buff *skb, struct genl_info *info)
 
 	conn_flush_workqueue(connection);
 
-	mutex_lock(&connection->conf_update);
+	mutex_lock(&adm_ctx.resource->conf_update);
 	old_net_conf = connection->net_conf;
 	if (old_net_conf) {
 		retcode = ERR_NET_CONFIGURED;
-		mutex_unlock(&connection->conf_update);
+		mutex_unlock(&adm_ctx.resource->conf_update);
 		goto fail;
 	}
 	rcu_assign_pointer(connection->net_conf, new_net_conf);
@@ -2263,7 +2263,7 @@ int drbd_adm_connect(struct sk_buff *skb, struct genl_info *info)
 	connection->peer_addr_len = nla_len(adm_ctx.peer_addr);
 	memcpy(&connection->peer_addr, nla_data(adm_ctx.peer_addr), connection->peer_addr_len);
 
-	mutex_unlock(&connection->conf_update);
+	mutex_unlock(&adm_ctx.resource->conf_update);
 
 	rcu_read_lock();
 	idr_for_each_entry(&connection->peer_devices, peer_device, i) {
@@ -2486,12 +2486,12 @@ int drbd_adm_resize(struct sk_buff *skb, struct genl_info *info)
 		device->ldev->known_size = drbd_get_capacity(device->ldev->backing_bdev);
 
 	if (new_disk_conf) {
-		mutex_lock(&first_peer_device(device)->connection->conf_update);
+		mutex_lock(&device->resource->conf_update);
 		old_disk_conf = device->ldev->disk_conf;
 		*new_disk_conf = *old_disk_conf;
 		new_disk_conf->disk_size = (sector_t)rs.resize_size;
 		rcu_assign_pointer(device->ldev->disk_conf, new_disk_conf);
-		mutex_unlock(&first_peer_device(device)->connection->conf_update);
+		mutex_unlock(&device->resource->conf_update);
 		synchronize_rcu();
 		kfree(old_disk_conf);
 	}
@@ -3248,10 +3248,10 @@ int drbd_adm_new_c_uuid(struct sk_buff *skb, struct genl_info *info)
 			drbd_send_uuids_skip_initial_sync(device);
 			_drbd_uuid_set(device, UI_BITMAP, 0);
 			drbd_print_uuids(device, "cleared bitmap UUID");
-			spin_lock_irq(&first_peer_device(device)->connection->req_lock);
+			spin_lock_irq(&device->resource->req_lock);
 			_drbd_set_state(_NS2(device, disk, D_UP_TO_DATE, pdsk, D_UP_TO_DATE),
 					CS_VERBOSE, NULL);
-			spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
+			spin_unlock_irq(&device->resource->req_lock);
 		}
 	}
 
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 90aa3aa..217ed11 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -221,9 +221,9 @@ static void drbd_kick_lo_and_reclaim_net(struct drbd_device *device)
 	LIST_HEAD(reclaimed);
 	struct drbd_peer_request *peer_req, *t;
 
-	spin_lock_irq(&first_peer_device(device)->connection->req_lock);
+	spin_lock_irq(&device->resource->req_lock);
 	reclaim_finished_net_peer_reqs(device, &reclaimed);
-	spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
+	spin_unlock_irq(&device->resource->req_lock);
 
 	list_for_each_entry_safe(peer_req, t, &reclaimed, w.list)
 		drbd_free_net_peer_req(device, peer_req);
@@ -288,7 +288,7 @@ struct page *drbd_alloc_pages(struct drbd_device *device, unsigned int number,
 }
 
 /* Must not be used from irq, as that may deadlock: see drbd_alloc_pages.
- * Is also used from inside an other spin_lock_irq(&first_peer_device(device)->connection->req_lock);
+ * Is also used from inside an other spin_lock_irq(&resource->req_lock);
  * Either links the page chain back to the global pool,
  * or returns all pages to the system. */
 static void drbd_free_pages(struct drbd_device *device, struct page *page, int is_net)
@@ -396,9 +396,9 @@ int drbd_free_peer_reqs(struct drbd_device *device, struct list_head *list)
 	int count = 0;
 	int is_net = list == &device->net_ee;
 
-	spin_lock_irq(&first_peer_device(device)->connection->req_lock);
+	spin_lock_irq(&device->resource->req_lock);
 	list_splice_init(list, &work_list);
-	spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
+	spin_unlock_irq(&device->resource->req_lock);
 
 	list_for_each_entry_safe(peer_req, t, &work_list, w.list) {
 		__drbd_free_peer_req(device, peer_req, is_net);
@@ -417,10 +417,10 @@ static int drbd_finish_peer_reqs(struct drbd_device *device)
 	struct drbd_peer_request *peer_req, *t;
 	int err = 0;
 
-	spin_lock_irq(&first_peer_device(device)->connection->req_lock);
+	spin_lock_irq(&device->resource->req_lock);
 	reclaim_finished_net_peer_reqs(device, &reclaimed);
 	list_splice_init(&device->done_ee, &work_list);
-	spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
+	spin_unlock_irq(&device->resource->req_lock);
 
 	list_for_each_entry_safe(peer_req, t, &reclaimed, w.list)
 		drbd_free_net_peer_req(device, peer_req);
@@ -452,19 +452,19 @@ static void _drbd_wait_ee_list_empty(struct drbd_device *device,
 	 * and calling prepare_to_wait in the fast path */
 	while (!list_empty(head)) {
 		prepare_to_wait(&device->ee_wait, &wait, TASK_UNINTERRUPTIBLE);
-		spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
+		spin_unlock_irq(&device->resource->req_lock);
 		io_schedule();
 		finish_wait(&device->ee_wait, &wait);
-		spin_lock_irq(&first_peer_device(device)->connection->req_lock);
+		spin_lock_irq(&device->resource->req_lock);
 	}
 }
 
 static void drbd_wait_ee_list_empty(struct drbd_device *device,
 				    struct list_head *head)
 {
-	spin_lock_irq(&first_peer_device(device)->connection->req_lock);
+	spin_lock_irq(&device->resource->req_lock);
 	_drbd_wait_ee_list_empty(device, head);
-	spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
+	spin_unlock_irq(&device->resource->req_lock);
 }
 
 static int drbd_recv_short(struct socket *sock, void *buf, size_t size, int flags)
@@ -1072,13 +1072,13 @@ randomize:
 
 	drbd_thread_start(&connection->asender);
 
-	mutex_lock(&connection->conf_update);
+	mutex_lock(&connection->resource->conf_update);
 	/* The discard_my_data flag is a single-shot modifier to the next
 	 * connection attempt, the handshake of which is now well underway.
 	 * No need for rcu style copying of the whole struct
 	 * just to clear a single value. */
 	connection->net_conf->discard_my_data = 0;
-	mutex_unlock(&connection->conf_update);
+	mutex_unlock(&connection->resource->conf_update);
 
 	return h;
 
@@ -1692,9 +1692,9 @@ static int recv_resync_read(struct drbd_device *device, sector_t sector, int dat
 
 	peer_req->w.cb = e_end_resync_block;
 
-	spin_lock_irq(&first_peer_device(device)->connection->req_lock);
+	spin_lock_irq(&device->resource->req_lock);
 	list_add(&peer_req->w.list, &device->sync_ee);
-	spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
+	spin_unlock_irq(&device->resource->req_lock);
 
 	atomic_add(data_size >> 9, &device->rs_sect_ev);
 	if (drbd_submit_peer_request(device, peer_req, WRITE, DRBD_FAULT_RS_WR) == 0)
@@ -1702,9 +1702,9 @@ static int recv_resync_read(struct drbd_device *device, sector_t sector, int dat
 
 	/* don't care for the reason here */
 	drbd_err(device, "submit failed, triggering re-connect\n");
-	spin_lock_irq(&first_peer_device(device)->connection->req_lock);
+	spin_lock_irq(&device->resource->req_lock);
 	list_del(&peer_req->w.list);
-	spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
+	spin_unlock_irq(&device->resource->req_lock);
 
 	drbd_free_peer_req(device, peer_req);
 fail:
@@ -1743,9 +1743,9 @@ static int receive_DataReply(struct drbd_connection *connection, struct packet_i
 
 	sector = be64_to_cpu(p->sector);
 
-	spin_lock_irq(&first_peer_device(device)->connection->req_lock);
+	spin_lock_irq(&device->resource->req_lock);
 	req = find_request(device, &device->read_requests, p->block_id, sector, false, __func__);
-	spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
+	spin_unlock_irq(&device->resource->req_lock);
 	if (unlikely(!req))
 		return -EIO;
 
@@ -1844,12 +1844,12 @@ static int e_end_block(struct drbd_work *w, int cancel)
 	/* we delete from the conflict detection hash _after_ we sent out the
 	 * P_WRITE_ACK / P_NEG_ACK, to get the sequence number right.  */
 	if (peer_req->flags & EE_IN_INTERVAL_TREE) {
-		spin_lock_irq(&first_peer_device(device)->connection->req_lock);
+		spin_lock_irq(&device->resource->req_lock);
 		D_ASSERT(device, !drbd_interval_empty(&peer_req->i));
 		drbd_remove_epoch_entry_interval(device, peer_req);
 		if (peer_req->flags & EE_RESTART_REQUESTS)
 			restart_conflicting_writes(device, sector, peer_req->i.size);
-		spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
+		spin_unlock_irq(&device->resource->req_lock);
 	} else
 		D_ASSERT(device, drbd_interval_empty(&peer_req->i));
 
@@ -1925,7 +1925,7 @@ static bool overlapping_resync_write(struct drbd_device *device, struct drbd_pee
 	struct drbd_peer_request *rs_req;
 	bool rv = 0;
 
-	spin_lock_irq(&first_peer_device(device)->connection->req_lock);
+	spin_lock_irq(&device->resource->req_lock);
 	list_for_each_entry(rs_req, &device->sync_ee, w.list) {
 		if (overlaps(peer_req->i.sector, peer_req->i.size,
 			     rs_req->i.sector, rs_req->i.size)) {
@@ -1933,7 +1933,7 @@ static bool overlapping_resync_write(struct drbd_device *device, struct drbd_pee
 			break;
 		}
 	}
-	spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
+	spin_unlock_irq(&device->resource->req_lock);
 
 	return rv;
 }
@@ -2034,10 +2034,10 @@ static void fail_postponed_requests(struct drbd_device *device, sector_t sector,
 			continue;
 		req->rq_state &= ~RQ_POSTPONED;
 		__req_mod(req, NEG_ACKED, &m);
-		spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
+		spin_unlock_irq(&device->resource->req_lock);
 		if (m.bio)
 			complete_master_bio(device, &m);
-		spin_lock_irq(&first_peer_device(device)->connection->req_lock);
+		spin_lock_irq(&device->resource->req_lock);
 		goto repeat;
 	}
 }
@@ -2218,10 +2218,10 @@ static int receive_Data(struct drbd_connection *connection, struct packet_info *
 		err = wait_for_and_update_peer_seq(device, peer_seq);
 		if (err)
 			goto out_interrupted;
-		spin_lock_irq(&first_peer_device(device)->connection->req_lock);
+		spin_lock_irq(&device->resource->req_lock);
 		err = handle_write_conflicts(device, peer_req);
 		if (err) {
-			spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
+			spin_unlock_irq(&device->resource->req_lock);
 			if (err == -ENOENT) {
 				put_ldev(device);
 				return 0;
@@ -2230,10 +2230,10 @@ static int receive_Data(struct drbd_connection *connection, struct packet_info *
 		}
 	} else {
 		update_peer_seq(device, peer_seq);
-		spin_lock_irq(&first_peer_device(device)->connection->req_lock);
+		spin_lock_irq(&device->resource->req_lock);
 	}
 	list_add(&peer_req->w.list, &device->active_ee);
-	spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
+	spin_unlock_irq(&device->resource->req_lock);
 
 	if (device->state.conn == C_SYNC_TARGET)
 		wait_event(device->ee_wait, !overlapping_resync_write(device, peer_req));
@@ -2278,10 +2278,10 @@ static int receive_Data(struct drbd_connection *connection, struct packet_info *
 
 	/* don't care for the reason here */
 	drbd_err(device, "submit failed, triggering re-connect\n");
-	spin_lock_irq(&first_peer_device(device)->connection->req_lock);
+	spin_lock_irq(&device->resource->req_lock);
 	list_del(&peer_req->w.list);
 	drbd_remove_epoch_entry_interval(device, peer_req);
-	spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
+	spin_unlock_irq(&device->resource->req_lock);
 	if (peer_req->flags & EE_CALL_AL_COMPLETE_IO)
 		drbd_al_complete_io(device, &peer_req->i);
 
@@ -2532,18 +2532,18 @@ submit_for_resync:
 
 submit:
 	inc_unacked(device);
-	spin_lock_irq(&first_peer_device(device)->connection->req_lock);
+	spin_lock_irq(&device->resource->req_lock);
 	list_add_tail(&peer_req->w.list, &device->read_ee);
-	spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
+	spin_unlock_irq(&device->resource->req_lock);
 
 	if (drbd_submit_peer_request(device, peer_req, READ, fault_type) == 0)
 		return 0;
 
 	/* don't care for the reason here */
 	drbd_err(device, "submit failed, triggering re-connect\n");
-	spin_lock_irq(&first_peer_device(device)->connection->req_lock);
+	spin_lock_irq(&device->resource->req_lock);
 	list_del(&peer_req->w.list);
-	spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
+	spin_unlock_irq(&device->resource->req_lock);
 	/* no drbd_rs_complete_io(), we are dropping the connection anyways */
 
 out_free_e:
@@ -3221,7 +3221,7 @@ static int receive_protocol(struct drbd_connection *connection, struct packet_in
 	}
 
 	mutex_lock(&connection->data.mutex);
-	mutex_lock(&connection->conf_update);
+	mutex_lock(&connection->resource->conf_update);
 	old_net_conf = connection->net_conf;
 	*new_net_conf = *old_net_conf;
 
@@ -3232,7 +3232,7 @@ static int receive_protocol(struct drbd_connection *connection, struct packet_in
 	new_net_conf->two_primaries = p_two_primaries;
 
 	rcu_assign_pointer(connection->net_conf, new_net_conf);
-	mutex_unlock(&connection->conf_update);
+	mutex_unlock(&connection->resource->conf_update);
 	mutex_unlock(&connection->data.mutex);
 
 	crypto_free_hash(connection->peer_integrity_tfm);
@@ -3371,13 +3371,13 @@ static int receive_SyncParam(struct drbd_connection *connection, struct packet_i
 	if (err)
 		return err;
 
-	mutex_lock(&first_peer_device(device)->connection->conf_update);
+	mutex_lock(&connection->resource->conf_update);
 	old_net_conf = first_peer_device(device)->connection->net_conf;
 	if (get_ldev(device)) {
 		new_disk_conf = kzalloc(sizeof(struct disk_conf), GFP_KERNEL);
 		if (!new_disk_conf) {
 			put_ldev(device);
-			mutex_unlock(&first_peer_device(device)->connection->conf_update);
+			mutex_unlock(&connection->resource->conf_update);
 			drbd_err(device, "Allocation of new disk_conf failed\n");
 			return -ENOMEM;
 		}
@@ -3497,7 +3497,7 @@ static int receive_SyncParam(struct drbd_connection *connection, struct packet_i
 		rcu_assign_pointer(device->rs_plan_s, new_plan);
 	}
 
-	mutex_unlock(&first_peer_device(device)->connection->conf_update);
+	mutex_unlock(&connection->resource->conf_update);
 	synchronize_rcu();
 	if (new_net_conf)
 		kfree(old_net_conf);
@@ -3511,7 +3511,7 @@ reconnect:
 		put_ldev(device);
 		kfree(new_disk_conf);
 	}
-	mutex_unlock(&first_peer_device(device)->connection->conf_update);
+	mutex_unlock(&connection->resource->conf_update);
 	return -EIO;
 
 disconnect:
@@ -3520,7 +3520,7 @@ disconnect:
 		put_ldev(device);
 		kfree(new_disk_conf);
 	}
-	mutex_unlock(&first_peer_device(device)->connection->conf_update);
+	mutex_unlock(&connection->resource->conf_update);
 	/* just for completeness: actually not needed,
 	 * as this is not reached if csums_tfm was ok. */
 	crypto_free_hash(csums_tfm);
@@ -3600,13 +3600,13 @@ static int receive_sizes(struct drbd_connection *connection, struct packet_info
 				return -ENOMEM;
 			}
 
-			mutex_lock(&first_peer_device(device)->connection->conf_update);
+			mutex_lock(&connection->resource->conf_update);
 			old_disk_conf = device->ldev->disk_conf;
 			*new_disk_conf = *old_disk_conf;
 			new_disk_conf->disk_size = p_usize;
 
 			rcu_assign_pointer(device->ldev->disk_conf, new_disk_conf);
-			mutex_unlock(&first_peer_device(device)->connection->conf_update);
+			mutex_unlock(&connection->resource->conf_update);
 			synchronize_rcu();
 			kfree(old_disk_conf);
 
@@ -3845,10 +3845,10 @@ static int receive_state(struct drbd_connection *connection, struct packet_info
 		drbd_info(device, "real peer disk state = %s\n", drbd_disk_str(real_peer_disk));
 	}
 
-	spin_lock_irq(&first_peer_device(device)->connection->req_lock);
+	spin_lock_irq(&device->resource->req_lock);
  retry:
 	os = ns = drbd_read_state(device);
-	spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
+	spin_unlock_irq(&device->resource->req_lock);
 
 	/* If some other part of the code (asender thread, timeout)
 	 * already decided to close the connection again,
@@ -3951,7 +3951,7 @@ static int receive_state(struct drbd_connection *connection, struct packet_info
 		}
 	}
 
-	spin_lock_irq(&first_peer_device(device)->connection->req_lock);
+	spin_lock_irq(&device->resource->req_lock);
 	if (os.i != drbd_read_state(device).i)
 		goto retry;
 	clear_bit(CONSIDER_RESYNC, &device->flags);
@@ -3965,7 +3965,7 @@ static int receive_state(struct drbd_connection *connection, struct packet_info
 	    test_bit(NEW_CUR_UUID, &device->flags)) {
 		/* Do not allow tl_restart(RESEND) for a rebooted peer. We can only allow this
 		   for temporal network outages! */
-		spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
+		spin_unlock_irq(&device->resource->req_lock);
 		drbd_err(device, "Aborting Connect, can not thaw IO with an only Consistent peer\n");
 		tl_clear(first_peer_device(device)->connection);
 		drbd_uuid_new_current(device);
@@ -3975,7 +3975,7 @@ static int receive_state(struct drbd_connection *connection, struct packet_info
 	}
 	rv = _drbd_set_state(device, ns, cs_flags, NULL);
 	ns = drbd_read_state(device);
-	spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
+	spin_unlock_irq(&device->resource->req_lock);
 
 	if (rv < SS_SUCCESS) {
 		conn_request_state(first_peer_device(device)->connection, NS(conn, C_DISCONNECTING), CS_HARD);
@@ -4482,12 +4482,12 @@ static void conn_disconnect(struct drbd_connection *connection)
 	if (conn_highest_role(connection) == R_PRIMARY && conn_highest_pdsk(connection) >= D_UNKNOWN)
 		conn_try_outdate_peer_async(connection);
 
-	spin_lock_irq(&connection->req_lock);
+	spin_lock_irq(&connection->resource->req_lock);
 	oc = connection->cstate;
 	if (oc >= C_UNCONNECTED)
 		_conn_request_state(connection, NS(conn, C_UNCONNECTED), CS_VERBOSE);
 
-	spin_unlock_irq(&connection->req_lock);
+	spin_unlock_irq(&connection->resource->req_lock);
 
 	if (oc == C_DISCONNECTING)
 		conn_request_state(connection, NS(conn, C_STANDALONE), CS_VERBOSE | CS_HARD);
@@ -4498,11 +4498,11 @@ static int drbd_disconnected(struct drbd_device *device)
 	unsigned int i;
 
 	/* wait for current activity to cease. */
-	spin_lock_irq(&first_peer_device(device)->connection->req_lock);
+	spin_lock_irq(&device->resource->req_lock);
 	_drbd_wait_ee_list_empty(device, &device->active_ee);
 	_drbd_wait_ee_list_empty(device, &device->sync_ee);
 	_drbd_wait_ee_list_empty(device, &device->read_ee);
-	spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
+	spin_unlock_irq(&device->resource->req_lock);
 
 	/* We do not have data structures that would allow us to
 	 * get the rs_pending_cnt down to 0 again.
@@ -4969,14 +4969,14 @@ validate_req_change_req_state(struct drbd_device *device, u64 id, sector_t secto
 	struct drbd_request *req;
 	struct bio_and_error m;
 
-	spin_lock_irq(&first_peer_device(device)->connection->req_lock);
+	spin_lock_irq(&device->resource->req_lock);
 	req = find_request(device, root, id, sector, missing_ok, func);
 	if (unlikely(!req)) {
-		spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
+		spin_unlock_irq(&device->resource->req_lock);
 		return -EIO;
 	}
 	__req_mod(req, what, &m);
-	spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
+	spin_unlock_irq(&device->resource->req_lock);
 
 	if (m.bio)
 		complete_master_bio(device, &m);
@@ -5217,14 +5217,14 @@ static int connection_finish_peer_reqs(struct drbd_connection *connection)
 		}
 		set_bit(SIGNAL_ASENDER, &connection->flags);
 
-		spin_lock_irq(&connection->req_lock);
+		spin_lock_irq(&connection->resource->req_lock);
 		idr_for_each_entry(&connection->peer_devices, peer_device, vnr) {
 			struct drbd_device *device = peer_device->device;
 			not_empty = !list_empty(&device->done_ee);
 			if (not_empty)
 				break;
 		}
-		spin_unlock_irq(&connection->req_lock);
+		spin_unlock_irq(&connection->resource->req_lock);
 		rcu_read_unlock();
 	} while (not_empty);
 
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index a4b46741..daf7861 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -851,9 +851,9 @@ static void complete_conflicting_writes(struct drbd_request *req)
 			break;
 		/* Indicate to wake up device->misc_wait on progress.  */
 		i->waiting = true;
-		spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
+		spin_unlock_irq(&device->resource->req_lock);
 		schedule();
-		spin_lock_irq(&first_peer_device(device)->connection->req_lock);
+		spin_lock_irq(&device->resource->req_lock);
 	}
 	finish_wait(&device->misc_wait, &wait);
 }
@@ -1078,7 +1078,7 @@ static void drbd_send_and_submit(struct drbd_device *device, struct drbd_request
 	struct bio_and_error m = { NULL, };
 	bool no_remote = false;
 
-	spin_lock_irq(&first_peer_device(device)->connection->req_lock);
+	spin_lock_irq(&device->resource->req_lock);
 	if (rw == WRITE) {
 		/* This may temporarily give up the req_lock,
 		 * but will re-aquire it before it returns here.
@@ -1140,9 +1140,9 @@ static void drbd_send_and_submit(struct drbd_device *device, struct drbd_request
 		/* needs to be marked within the same spinlock */
 		_req_mod(req, TO_BE_SUBMITTED);
 		/* but we need to give up the spinlock to submit */
-		spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
+		spin_unlock_irq(&device->resource->req_lock);
 		drbd_submit_req_private_bio(req);
-		spin_lock_irq(&first_peer_device(device)->connection->req_lock);
+		spin_lock_irq(&device->resource->req_lock);
 	} else if (no_remote) {
 nodata:
 		if (__ratelimit(&drbd_ratelimit_state))
@@ -1155,7 +1155,7 @@ nodata:
 out:
 	if (drbd_req_put_completion_ref(req, &m, 1))
 		kref_put(&req->kref, drbd_req_destroy);
-	spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
+	spin_unlock_irq(&device->resource->req_lock);
 
 	if (m.bio)
 		complete_master_bio(device, &m);
@@ -1360,10 +1360,10 @@ void request_timer_fn(unsigned long data)
 
 	now = jiffies;
 
-	spin_lock_irq(&connection->req_lock);
+	spin_lock_irq(&device->resource->req_lock);
 	req = find_oldest_request(connection);
 	if (!req) {
-		spin_unlock_irq(&connection->req_lock);
+		spin_unlock_irq(&device->resource->req_lock);
 		mod_timer(&device->request_timer, now + et);
 		return;
 	}
@@ -1397,6 +1397,6 @@ void request_timer_fn(unsigned long data)
 		__drbd_chk_io_error(device, DRBD_FORCE_DETACH);
 	}
 	nt = (time_after(now, req->start_time + et) ? now : req->start_time) + et;
-	spin_unlock_irq(&connection->req_lock);
+	spin_unlock_irq(&connection->resource->req_lock);
 	mod_timer(&device->request_timer, nt);
 }
diff --git a/drivers/block/drbd/drbd_req.h b/drivers/block/drbd/drbd_req.h
index 27283e6..5ce6dc5 100644
--- a/drivers/block/drbd/drbd_req.h
+++ b/drivers/block/drbd/drbd_req.h
@@ -318,9 +318,9 @@ static inline int req_mod(struct drbd_request *req,
 	struct bio_and_error m;
 	int rv;
 
-	spin_lock_irqsave(&first_peer_device(device)->connection->req_lock, flags);
+	spin_lock_irqsave(&device->resource->req_lock, flags);
 	rv = __req_mod(req, what, &m);
-	spin_unlock_irqrestore(&first_peer_device(device)->connection->req_lock, flags);
+	spin_unlock_irqrestore(&device->resource->req_lock, flags);
 
 	if (m.bio)
 		complete_master_bio(device, &m);
diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index cbd287a..0e69bb1 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -253,10 +253,10 @@ drbd_change_state(struct drbd_device *device, enum chg_state_flags f,
 	union drbd_state ns;
 	enum drbd_state_rv rv;
 
-	spin_lock_irqsave(&first_peer_device(device)->connection->req_lock, flags);
+	spin_lock_irqsave(&device->resource->req_lock, flags);
 	ns = apply_mask_val(drbd_read_state(device), mask, val);
 	rv = _drbd_set_state(device, ns, f, NULL);
-	spin_unlock_irqrestore(&first_peer_device(device)->connection->req_lock, flags);
+	spin_unlock_irqrestore(&device->resource->req_lock, flags);
 
 	return rv;
 }
@@ -287,7 +287,7 @@ _req_st_cond(struct drbd_device *device, union drbd_state mask,
 	if (test_and_clear_bit(CL_ST_CHG_FAIL, &device->flags))
 		return SS_CW_FAILED_BY_PEER;
 
-	spin_lock_irqsave(&first_peer_device(device)->connection->req_lock, flags);
+	spin_lock_irqsave(&device->resource->req_lock, flags);
 	os = drbd_read_state(device);
 	ns = sanitize_state(device, apply_mask_val(os, mask, val), NULL);
 	rv = is_valid_transition(os, ns);
@@ -304,7 +304,7 @@ _req_st_cond(struct drbd_device *device, union drbd_state mask,
 				rv = SS_UNKNOWN_ERROR; /* cont waiting, otherwise fail. */
 		}
 	}
-	spin_unlock_irqrestore(&first_peer_device(device)->connection->req_lock, flags);
+	spin_unlock_irqrestore(&device->resource->req_lock, flags);
 
 	return rv;
 }
@@ -333,12 +333,12 @@ drbd_req_state(struct drbd_device *device, union drbd_state mask,
 	if (f & CS_SERIALIZE)
 		mutex_lock(device->state_mutex);
 
-	spin_lock_irqsave(&first_peer_device(device)->connection->req_lock, flags);
+	spin_lock_irqsave(&device->resource->req_lock, flags);
 	os = drbd_read_state(device);
 	ns = sanitize_state(device, apply_mask_val(os, mask, val), NULL);
 	rv = is_valid_transition(os, ns);
 	if (rv < SS_SUCCESS) {
-		spin_unlock_irqrestore(&first_peer_device(device)->connection->req_lock, flags);
+		spin_unlock_irqrestore(&device->resource->req_lock, flags);
 		goto abort;
 	}
 
@@ -346,7 +346,7 @@ drbd_req_state(struct drbd_device *device, union drbd_state mask,
 		rv = is_valid_state(device, ns);
 		if (rv == SS_SUCCESS)
 			rv = is_valid_soft_transition(os, ns, first_peer_device(device)->connection);
-		spin_unlock_irqrestore(&first_peer_device(device)->connection->req_lock, flags);
+		spin_unlock_irqrestore(&device->resource->req_lock, flags);
 
 		if (rv < SS_SUCCESS) {
 			if (f & CS_VERBOSE)
@@ -369,14 +369,14 @@ drbd_req_state(struct drbd_device *device, union drbd_state mask,
 				print_st_err(device, os, ns, rv);
 			goto abort;
 		}
-		spin_lock_irqsave(&first_peer_device(device)->connection->req_lock, flags);
+		spin_lock_irqsave(&device->resource->req_lock, flags);
 		ns = apply_mask_val(drbd_read_state(device), mask, val);
 		rv = _drbd_set_state(device, ns, f, &done);
 	} else {
 		rv = _drbd_set_state(device, ns, f, &done);
 	}
 
-	spin_unlock_irqrestore(&first_peer_device(device)->connection->req_lock, flags);
+	spin_unlock_irqrestore(&device->resource->req_lock, flags);
 
 	if (f & CS_WAIT_COMPLETE && rv == SS_SUCCESS) {
 		D_ASSERT(device, current != first_peer_device(device)->connection->worker.task);
@@ -1248,7 +1248,7 @@ static void after_state_ch(struct drbd_device *device, union drbd_state os,
 		struct drbd_connection *connection = first_peer_device(device)->connection;
 		enum drbd_req_event what = NOTHING;
 
-		spin_lock_irq(&connection->req_lock);
+		spin_lock_irq(&device->resource->req_lock);
 		if (os.conn < C_CONNECTED && conn_lowest_conn(connection) >= C_CONNECTED)
 			what = RESEND;
 
@@ -1263,13 +1263,13 @@ static void after_state_ch(struct drbd_device *device, union drbd_state os,
 					    (union drbd_state) { { .susp_nod = 0 } },
 					    CS_VERBOSE);
 		}
-		spin_unlock_irq(&connection->req_lock);
+		spin_unlock_irq(&device->resource->req_lock);
 	}
 
 	if (ns.susp_fen) {
 		struct drbd_connection *connection = first_peer_device(device)->connection;
 
-		spin_lock_irq(&connection->req_lock);
+		spin_lock_irq(&device->resource->req_lock);
 		if (connection->susp_fen && conn_lowest_conn(connection) >= C_CONNECTED) {
 			/* case2: The connection was established again: */
 			struct drbd_peer_device *peer_device;
@@ -1285,7 +1285,7 @@ static void after_state_ch(struct drbd_device *device, union drbd_state os,
 					    (union drbd_state) { { .susp_fen = 0 } },
 					    CS_VERBOSE);
 		}
-		spin_unlock_irq(&connection->req_lock);
+		spin_unlock_irq(&device->resource->req_lock);
 	}
 
 	/* Became sync source.  With protocol >= 96, we still need to send out
@@ -1558,13 +1558,13 @@ static int w_after_conn_state_ch(struct drbd_work *w, int unused)
 	if (oc == C_DISCONNECTING && ns_max.conn == C_STANDALONE) {
 		struct net_conf *old_conf;
 
-		mutex_lock(&connection->conf_update);
+		mutex_lock(&connection->resource->conf_update);
 		old_conf = connection->net_conf;
 		connection->my_addr_len = 0;
 		connection->peer_addr_len = 0;
 		rcu_assign_pointer(connection->net_conf, NULL);
 		conn_free_crypto(connection);
-		mutex_unlock(&connection->conf_update);
+		mutex_unlock(&connection->resource->conf_update);
 
 		synchronize_rcu();
 		kfree(old_conf);
@@ -1582,13 +1582,13 @@ static int w_after_conn_state_ch(struct drbd_work *w, int unused)
 				}
 			}
 			rcu_read_unlock();
-			spin_lock_irq(&connection->req_lock);
+			spin_lock_irq(&connection->resource->req_lock);
 			_tl_restart(connection, CONNECTION_LOST_WHILE_PENDING);
 			_conn_request_state(connection,
 					    (union drbd_state) { { .susp_fen = 1 } },
 					    (union drbd_state) { { .susp_fen = 0 } },
 					    CS_VERBOSE);
-			spin_unlock_irq(&connection->req_lock);
+			spin_unlock_irq(&connection->resource->req_lock);
 		}
 	}
 	kref_put(&connection->kref, drbd_destroy_connection);
@@ -1805,7 +1805,7 @@ _conn_request_state(struct drbd_connection *connection, union drbd_state mask, u
 		/* This will be a cluster-wide state change.
 		 * Need to give up the spinlock, grab the mutex,
 		 * then send the state change request, ... */
-		spin_unlock_irq(&connection->req_lock);
+		spin_unlock_irq(&connection->resource->req_lock);
 		mutex_lock(&connection->cstate_mutex);
 		have_mutex = true;
 
@@ -1824,10 +1824,10 @@ _conn_request_state(struct drbd_connection *connection, union drbd_state mask, u
 		/* ... and re-aquire the spinlock.
 		 * If _conn_rq_cond() returned >= SS_SUCCESS, we must call
 		 * conn_set_state() within the same spinlock. */
-		spin_lock_irq(&connection->req_lock);
+		spin_lock_irq(&connection->resource->req_lock);
 		wait_event_lock_irq(connection->ping_wait,
 				(rv = _conn_rq_cond(connection, mask, val)),
-				connection->req_lock);
+				connection->resource->req_lock);
 		clear_bit(CONN_WD_ST_CHG_REQ, &connection->flags);
 		if (rv < SS_SUCCESS)
 			goto abort;
@@ -1856,10 +1856,10 @@ _conn_request_state(struct drbd_connection *connection, union drbd_state mask, u
 	if (have_mutex) {
 		/* mutex_unlock() "... must not be used in interrupt context.",
 		 * so give up the spinlock, then re-aquire it */
-		spin_unlock_irq(&connection->req_lock);
+		spin_unlock_irq(&connection->resource->req_lock);
  abort_unlocked:
 		mutex_unlock(&connection->cstate_mutex);
-		spin_lock_irq(&connection->req_lock);
+		spin_lock_irq(&connection->resource->req_lock);
 	}
 	if (rv < SS_SUCCESS && flags & CS_VERBOSE) {
 		drbd_err(connection, "State change failed: %s\n", drbd_set_st_err_str(rv));
@@ -1875,9 +1875,9 @@ conn_request_state(struct drbd_connection *connection, union drbd_state mask, un
 {
 	enum drbd_state_rv rv;
 
-	spin_lock_irq(&connection->req_lock);
+	spin_lock_irq(&connection->resource->req_lock);
 	rv = _conn_request_state(connection, mask, val, flags);
-	spin_unlock_irq(&connection->req_lock);
+	spin_unlock_irq(&connection->resource->req_lock);
 
 	return rv;
 }
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 560ebfd..167c198 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -102,14 +102,14 @@ void drbd_endio_read_sec_final(struct drbd_peer_request *peer_req) __releases(lo
 	unsigned long flags = 0;
 	struct drbd_device *device = peer_req->w.device;
 
-	spin_lock_irqsave(&first_peer_device(device)->connection->req_lock, flags);
+	spin_lock_irqsave(&device->resource->req_lock, flags);
 	device->read_cnt += peer_req->i.size >> 9;
 	list_del(&peer_req->w.list);
 	if (list_empty(&device->read_ee))
 		wake_up(&device->ee_wait);
 	if (test_bit(__EE_WAS_ERROR, &peer_req->flags))
 		__drbd_chk_io_error(device, DRBD_READ_ERROR);
-	spin_unlock_irqrestore(&first_peer_device(device)->connection->req_lock, flags);
+	spin_unlock_irqrestore(&device->resource->req_lock, flags);
 
 	drbd_queue_work(&first_peer_device(device)->connection->sender_work, &peer_req->w);
 	put_ldev(device);
@@ -134,7 +134,7 @@ static void drbd_endio_write_sec_final(struct drbd_peer_request *peer_req) __rel
 	do_al_complete_io = peer_req->flags & EE_CALL_AL_COMPLETE_IO;
 	block_id = peer_req->block_id;
 
-	spin_lock_irqsave(&first_peer_device(device)->connection->req_lock, flags);
+	spin_lock_irqsave(&device->resource->req_lock, flags);
 	device->writ_cnt += peer_req->i.size >> 9;
 	list_move_tail(&peer_req->w.list, &device->done_ee);
 
@@ -150,7 +150,7 @@ static void drbd_endio_write_sec_final(struct drbd_peer_request *peer_req) __rel
 
 	if (test_bit(__EE_WAS_ERROR, &peer_req->flags))
 		__drbd_chk_io_error(device, DRBD_WRITE_ERROR);
-	spin_unlock_irqrestore(&first_peer_device(device)->connection->req_lock, flags);
+	spin_unlock_irqrestore(&device->resource->req_lock, flags);
 
 	if (block_id == ID_SYNCER)
 		drbd_rs_complete_io(device, i.sector);
@@ -273,9 +273,9 @@ void drbd_request_endio(struct bio *bio, int error)
 	req->private_bio = ERR_PTR(error);
 
 	/* not req_mod(), we need irqsave here! */
-	spin_lock_irqsave(&first_peer_device(device)->connection->req_lock, flags);
+	spin_lock_irqsave(&device->resource->req_lock, flags);
 	__req_mod(req, what, &m);
-	spin_unlock_irqrestore(&first_peer_device(device)->connection->req_lock, flags);
+	spin_unlock_irqrestore(&device->resource->req_lock, flags);
 	put_ldev(device);
 
 	if (m.bio)
@@ -397,9 +397,9 @@ static int read_for_csum(struct drbd_device *device, sector_t sector, int size)
 		goto defer;
 
 	peer_req->w.cb = w_e_send_csum;
-	spin_lock_irq(&first_peer_device(device)->connection->req_lock);
+	spin_lock_irq(&device->resource->req_lock);
 	list_add(&peer_req->w.list, &device->read_ee);
-	spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
+	spin_unlock_irq(&device->resource->req_lock);
 
 	atomic_add(size >> 9, &device->rs_sect_ev);
 	if (drbd_submit_peer_request(device, peer_req, READ, DRBD_FAULT_RS_RD) == 0)
@@ -409,9 +409,9 @@ static int read_for_csum(struct drbd_device *device, sector_t sector, int size)
 	 * because bio_add_page failed (probably broken lower level driver),
 	 * retry may or may not help.
 	 * If it does not, you may need to force disconnect. */
-	spin_lock_irq(&first_peer_device(device)->connection->req_lock);
+	spin_lock_irq(&device->resource->req_lock);
 	list_del(&peer_req->w.list);
-	spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
+	spin_unlock_irq(&device->resource->req_lock);
 
 	drbd_free_peer_req(device, peer_req);
 defer:
@@ -855,7 +855,7 @@ int drbd_resync_finished(struct drbd_device *device)
 
 	ping_peer(device);
 
-	spin_lock_irq(&first_peer_device(device)->connection->req_lock);
+	spin_lock_irq(&device->resource->req_lock);
 	os = drbd_read_state(device);
 
 	verify_done = (os.conn == C_VERIFY_S || os.conn == C_VERIFY_T);
@@ -944,7 +944,7 @@ int drbd_resync_finished(struct drbd_device *device)
 
 	_drbd_set_state(device, ns, CS_VERBOSE, NULL);
 out_unlock:
-	spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
+	spin_unlock_irq(&device->resource->req_lock);
 	put_ldev(device);
 out:
 	device->rs_total  = 0;
@@ -971,9 +971,9 @@ static void move_to_net_ee_or_free(struct drbd_device *device, struct drbd_peer_
 		int i = (peer_req->i.size + PAGE_SIZE -1) >> PAGE_SHIFT;
 		atomic_add(i, &device->pp_in_use_by_net);
 		atomic_sub(i, &device->pp_in_use);
-		spin_lock_irq(&first_peer_device(device)->connection->req_lock);
+		spin_lock_irq(&device->resource->req_lock);
 		list_add_tail(&peer_req->w.list, &device->net_ee);
-		spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
+		spin_unlock_irq(&device->resource->req_lock);
 		wake_up(&drbd_pp_wait);
 	} else
 		drbd_free_peer_req(device, peer_req);
@@ -1847,7 +1847,7 @@ void wait_for_work(struct drbd_connection *connection, struct list_head *work_li
 	for (;;) {
 		int send_barrier;
 		prepare_to_wait(&connection->sender_work.q_wait, &wait, TASK_INTERRUPTIBLE);
-		spin_lock_irq(&connection->req_lock);
+		spin_lock_irq(&connection->resource->req_lock);
 		spin_lock(&connection->sender_work.q_lock);	/* FIXME get rid of this one? */
 		/* dequeue single item only,
 		 * we still use drbd_queue_work_front() in some places */
@@ -1855,11 +1855,11 @@ void wait_for_work(struct drbd_connection *connection, struct list_head *work_li
 			list_move(connection->sender_work.q.next, work_list);
 		spin_unlock(&connection->sender_work.q_lock);	/* FIXME get rid of this one? */
 		if (!list_empty(work_list) || signal_pending(current)) {
-			spin_unlock_irq(&connection->req_lock);
+			spin_unlock_irq(&connection->resource->req_lock);
 			break;
 		}
 		send_barrier = need_to_send_barrier(connection);
-		spin_unlock_irq(&connection->req_lock);
+		spin_unlock_irq(&connection->resource->req_lock);
 		if (send_barrier) {
 			drbd_send_barrier(connection);
 			connection->send.current_epoch_nr++;
-- 
1.7.9.5

