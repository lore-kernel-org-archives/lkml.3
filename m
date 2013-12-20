Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932562Ab3LTMln (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 07:41:43 -0500
Received: from mail09.linbit.com ([212.69.161.110]:38634 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756644Ab3LTMjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 07:39:35 -0500
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 18/26] drbd: Turn connection->volumes into connection->peer_devices
Date: Fri, 20 Dec 2013 13:29:15 +0100
Message-Id: <1387542563-6833-19-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387542563-6833-1-git-send-email-philipp.reisner@linbit.com>
References: <1387542563-6833-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Let connection->peer_devices point to peer devices; connection->volumes was
pointing to devices.

Signed-off-by: Andreas Gruenbacher <agruen@linbit.com>
Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |    7 ++-
 drivers/block/drbd/drbd_main.c     |   27 ++++++-----
 drivers/block/drbd/drbd_nl.c       |   59 ++++++++++++++-----------
 drivers/block/drbd/drbd_receiver.c |   44 +++++++++++-------
 drivers/block/drbd/drbd_state.c    |   86 +++++++++++++++++++++---------------
 drivers/block/drbd/drbd_worker.c   |    5 ++-
 6 files changed, 136 insertions(+), 92 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index e1d6c53..8b263a9 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -544,7 +544,7 @@ struct drbd_connection {
 	struct list_head connections;
 	struct drbd_resource *resource;
 	struct kref kref;
-	struct idr volumes;		/* <connection, vnr> to device mapping */
+	struct idr peer_devices;	/* volume number to peer device mapping */
 	enum drbd_conns cstate;		/* Only C_STANDALONE to C_WF_REPORT_PARAMS */
 	unsigned susp:1;		/* IO suspended by user */
 	unsigned susp_nod:1;		/* IO suspended because no data */
@@ -817,7 +817,10 @@ static inline unsigned int device_to_minor(struct drbd_device *device)
 
 static inline struct drbd_device *vnr_to_device(struct drbd_connection *connection, int vnr)
 {
-	return (struct drbd_device *)idr_find(&connection->volumes, vnr);
+	struct drbd_peer_device *peer_device;
+
+	peer_device = idr_find(&connection->peer_devices, vnr);
+	return peer_device ? peer_device->device : NULL;
 }
 
 /*
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 1792bc2..25b928e 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -498,15 +498,16 @@ char *drbd_task_to_thread_name(struct drbd_connection *connection, struct task_s
 
 int conn_lowest_minor(struct drbd_connection *connection)
 {
-	struct drbd_device *device;
-	int vnr = 0, m;
+	struct drbd_peer_device *peer_device;
+	int vnr = 0, minor = -1;
 
 	rcu_read_lock();
-	device = idr_get_next(&connection->volumes, &vnr);
-	m = device ? device_to_minor(device) : -1;
+	peer_device = idr_get_next(&connection->peer_devices, &vnr);
+	if (peer_device)
+		minor = device_to_minor(peer_device->device);
 	rcu_read_unlock();
 
-	return m;
+	return minor;
 }
 
 #ifdef CONFIG_SMP
@@ -2592,7 +2593,7 @@ struct drbd_connection *conn_create(const char *name, struct res_opts *res_opts)
 	spin_lock_init(&connection->req_lock);
 	mutex_init(&connection->conf_update);
 	init_waitqueue_head(&connection->ping_wait);
-	idr_init(&connection->volumes);
+	idr_init(&connection->peer_devices);
 
 	drbd_init_workqueue(&connection->sender_work);
 	mutex_init(&connection->data.mutex);
@@ -2634,7 +2635,7 @@ void drbd_destroy_connection(struct kref *kref)
 		conn_err(connection, "epoch_size:%d\n", atomic_read(&connection->current_epoch->epoch_size));
 	kfree(connection->current_epoch);
 
-	idr_destroy(&connection->volumes);
+	idr_destroy(&connection->peer_devices);
 
 	free_cpumask_var(connection->cpu_mask);
 	drbd_free_socket(&connection->meta);
@@ -2762,7 +2763,7 @@ enum drbd_ret_code drbd_create_minor(struct drbd_connection *connection, unsigne
 	}
 	kref_get(&device->kref);
 
-	id = idr_alloc(&connection->volumes, device, vnr, vnr + 1, GFP_KERNEL);
+	id = idr_alloc(&connection->peer_devices, peer_device, vnr, vnr + 1, GFP_KERNEL);
 	if (id < 0) {
 		if (id == -ENOSPC) {
 			err = ERR_INVALID_REQUEST;
@@ -2788,7 +2789,7 @@ enum drbd_ret_code drbd_create_minor(struct drbd_connection *connection, unsigne
 	return NO_ERROR;
 
 out_idr_remove_vol:
-	idr_remove(&connection->volumes, vnr);
+	idr_remove(&connection->peer_devices, vnr);
 out_idr_remove_from_resource:
 	idr_remove(&resource->devices, vnr);
 out_idr_remove_minor:
@@ -2817,7 +2818,7 @@ void drbd_delete_minor(struct drbd_device *device)
 	int refs = 3;
 
 	for_each_connection(connection, resource) {
-		idr_remove(&connection->volumes, device->vnr);
+		idr_remove(&connection->peer_devices, device->vnr);
 		refs++;
 	}
 	idr_remove(&resource->devices, device->vnr);
@@ -2940,11 +2941,13 @@ void drbd_free_sock(struct drbd_connection *connection)
 
 void conn_md_sync(struct drbd_connection *connection)
 {
-	struct drbd_device *device;
+	struct drbd_peer_device *peer_device;
 	int vnr;
 
 	rcu_read_lock();
-	idr_for_each_entry(&connection->volumes, device, vnr) {
+	idr_for_each_entry(&connection->peer_devices, peer_device, vnr) {
+		struct drbd_device *device = peer_device->device;
+
 		kref_get(&device->kref);
 		rcu_read_unlock();
 		drbd_md_sync(device);
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 2153afd..88cad90 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -415,14 +415,16 @@ int conn_khelper(struct drbd_connection *connection, char *cmd)
 static enum drbd_fencing_p highest_fencing_policy(struct drbd_connection *connection)
 {
 	enum drbd_fencing_p fp = FP_NOT_AVAIL;
-	struct drbd_device *device;
+	struct drbd_peer_device *peer_device;
 	int vnr;
 
 	rcu_read_lock();
-	idr_for_each_entry(&connection->volumes, device, vnr) {
+	idr_for_each_entry(&connection->peer_devices, peer_device, vnr) {
+		struct drbd_device *device = peer_device->device;
 		if (get_ldev_if_state(device, D_CONSISTENT)) {
-			fp = max_t(enum drbd_fencing_p, fp,
-				   rcu_dereference(device->ldev->disk_conf)->fencing);
+			struct disk_conf *disk_conf =
+				rcu_dereference(peer_device->device->ldev->disk_conf);
+			fp = max_t(enum drbd_fencing_p, fp, disk_conf->fencing);
 			put_ldev(device);
 		}
 	}
@@ -1878,12 +1880,13 @@ out:
 
 static bool conn_resync_running(struct drbd_connection *connection)
 {
-	struct drbd_device *device;
+	struct drbd_peer_device *peer_device;
 	bool rv = false;
 	int vnr;
 
 	rcu_read_lock();
-	idr_for_each_entry(&connection->volumes, device, vnr) {
+	idr_for_each_entry(&connection->peer_devices, peer_device, vnr) {
+		struct drbd_device *device = peer_device->device;
 		if (device->state.conn == C_SYNC_SOURCE ||
 		    device->state.conn == C_SYNC_TARGET ||
 		    device->state.conn == C_PAUSED_SYNC_S ||
@@ -1899,12 +1902,13 @@ static bool conn_resync_running(struct drbd_connection *connection)
 
 static bool conn_ov_running(struct drbd_connection *connection)
 {
-	struct drbd_device *device;
+	struct drbd_peer_device *peer_device;
 	bool rv = false;
 	int vnr;
 
 	rcu_read_lock();
-	idr_for_each_entry(&connection->volumes, device, vnr) {
+	idr_for_each_entry(&connection->peer_devices, peer_device, vnr) {
+		struct drbd_device *device = peer_device->device;
 		if (device->state.conn == C_VERIFY_S ||
 		    device->state.conn == C_VERIFY_T) {
 			rv = true;
@@ -1919,7 +1923,7 @@ static bool conn_ov_running(struct drbd_connection *connection)
 static enum drbd_ret_code
 _check_net_options(struct drbd_connection *connection, struct net_conf *old_conf, struct net_conf *new_conf)
 {
-	struct drbd_device *device;
+	struct drbd_peer_device *peer_device;
 	int i;
 
 	if (old_conf && connection->cstate == C_WF_REPORT_PARAMS && connection->agreed_pro_version < 100) {
@@ -1942,7 +1946,8 @@ _check_net_options(struct drbd_connection *connection, struct net_conf *old_conf
 	    (new_conf->wire_protocol != DRBD_PROT_C))
 		return ERR_NOT_PROTO_C;
 
-	idr_for_each_entry(&connection->volumes, device, i) {
+	idr_for_each_entry(&connection->peer_devices, peer_device, i) {
+		struct drbd_device *device = peer_device->device;
 		if (get_ldev(device)) {
 			enum drbd_fencing_p fp = rcu_dereference(device->ldev->disk_conf)->fencing;
 			put_ldev(device);
@@ -1963,7 +1968,7 @@ static enum drbd_ret_code
 check_net_options(struct drbd_connection *connection, struct net_conf *new_conf)
 {
 	static enum drbd_ret_code rv;
-	struct drbd_device *device;
+	struct drbd_peer_device *peer_device;
 	int i;
 
 	rcu_read_lock();
@@ -1971,7 +1976,8 @@ check_net_options(struct drbd_connection *connection, struct net_conf *new_conf)
 	rcu_read_unlock();
 
 	/* connection->volumes protected by genl_lock() here */
-	idr_for_each_entry(&connection->volumes, device, i) {
+	idr_for_each_entry(&connection->peer_devices, peer_device, i) {
+		struct drbd_device *device = peer_device->device;
 		if (!device->bitmap) {
 			if (drbd_bm_init(device))
 				return ERR_NOMEM;
@@ -2155,7 +2161,7 @@ int drbd_adm_net_opts(struct sk_buff *skb, struct genl_info *info)
 
 int drbd_adm_connect(struct sk_buff *skb, struct genl_info *info)
 {
-	struct drbd_device *device;
+	struct drbd_peer_device *peer_device;
 	struct net_conf *old_conf, *new_conf = NULL;
 	struct crypto crypto = { };
 	struct drbd_resource *resource;
@@ -2256,7 +2262,8 @@ int drbd_adm_connect(struct sk_buff *skb, struct genl_info *info)
 	mutex_unlock(&connection->conf_update);
 
 	rcu_read_lock();
-	idr_for_each_entry(&connection->volumes, device, i) {
+	idr_for_each_entry(&connection->peer_devices, peer_device, i) {
+		struct drbd_device *device = peer_device->device;
 		device->send_cnt = 0;
 		device->recv_cnt = 0;
 	}
@@ -2915,6 +2922,7 @@ out:
 
 static int get_one_status(struct sk_buff *skb, struct netlink_callback *cb)
 {
+	struct drbd_peer_device *peer_device;
 	struct drbd_device *device;
 	struct drbd_genlmsghdr *dh;
 	struct drbd_resource *pos = (struct drbd_resource *)cb->args[0];
@@ -2926,7 +2934,7 @@ static int get_one_status(struct sk_buff *skb, struct netlink_callback *cb)
 	/* Open coded, deferred, iteration:
 	 * for_each_resource_safe(resource, tmp, &drbd_resources) {
 	 *      connection = "first connection of resource";
-	 *	idr_for_each_entry(&connection->volumes, device, i) {
+	 *	idr_for_each_entry(&connection->peer_devices, peer_device, i) {
 	 *	  ...
 	 *	}
 	 * }
@@ -2962,8 +2970,8 @@ static int get_one_status(struct sk_buff *skb, struct netlink_callback *cb)
 	if (resource) {
 next_resource:
 		connection = first_connection(resource);
-		device = idr_get_next(&connection->volumes, &volume);
-		if (!device) {
+		peer_device = idr_get_next(&connection->peer_devices, &volume);
+		if (!peer_device) {
 			/* No more volumes to dump on this resource.
 			 * Advance resource iterator. */
 			pos = list_entry_rcu(resource->resources.next,
@@ -2987,7 +2995,7 @@ next_resource:
 		if (!dh)
 			goto out;
 
-		if (!device) {
+		if (!peer_device) {
 			/* This is a connection without a single volume.
 			 * Suprisingly enough, it may have a network
 			 * configuration. */
@@ -3002,6 +3010,7 @@ next_resource:
 			goto done;
 		}
 
+		device = peer_device->device;
 		D_ASSERT(device->vnr == volume);
 		D_ASSERT(first_peer_device(device)->connection == connection);
 
@@ -3359,7 +3368,7 @@ out:
 int drbd_adm_down(struct sk_buff *skb, struct genl_info *info)
 {
 	int retcode; /* enum drbd_ret_code rsp. enum drbd_state_rv */
-	struct drbd_device *device;
+	struct drbd_peer_device *peer_device;
 	unsigned i;
 
 	retcode = drbd_adm_prepare(skb, info, DRBD_ADM_NEED_RESOURCE);
@@ -3369,8 +3378,8 @@ int drbd_adm_down(struct sk_buff *skb, struct genl_info *info)
 		goto out;
 
 	/* demote */
-	idr_for_each_entry(&adm_ctx.connection->volumes, device, i) {
-		retcode = drbd_set_role(device, R_SECONDARY, 0);
+	idr_for_each_entry(&adm_ctx.connection->peer_devices, peer_device, i) {
+		retcode = drbd_set_role(peer_device->device, R_SECONDARY, 0);
 		if (retcode < SS_SUCCESS) {
 			drbd_msg_put_info("failed to demote");
 			goto out;
@@ -3384,8 +3393,8 @@ int drbd_adm_down(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	/* detach */
-	idr_for_each_entry(&adm_ctx.connection->volumes, device, i) {
-		retcode = adm_detach(device, 0);
+	idr_for_each_entry(&adm_ctx.connection->peer_devices, peer_device, i) {
+		retcode = adm_detach(peer_device->device, 0);
 		if (retcode < SS_SUCCESS || retcode > NO_ERROR) {
 			drbd_msg_put_info("failed to detach");
 			goto out;
@@ -3400,8 +3409,8 @@ int drbd_adm_down(struct sk_buff *skb, struct genl_info *info)
 	/* Now, nothing can fail anymore */
 
 	/* delete volumes */
-	idr_for_each_entry(&adm_ctx.connection->volumes, device, i) {
-		retcode = adm_del_minor(device);
+	idr_for_each_entry(&adm_ctx.connection->peer_devices, peer_device, i) {
+		retcode = adm_del_minor(peer_device->device);
 		if (retcode != NO_ERROR) {
 			/* "can not happen" */
 			drbd_msg_put_info("failed to delete volume");
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index e480e73..a750102 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -867,7 +867,7 @@ int drbd_connected(struct drbd_device *device)
 static int conn_connect(struct drbd_connection *connection)
 {
 	struct drbd_socket sock, msock;
-	struct drbd_device *device;
+	struct drbd_peer_device *peer_device;
 	struct net_conf *nc;
 	int vnr, timeout, h, ok;
 	bool discard_my_data;
@@ -1038,7 +1038,8 @@ randomize:
 	set_bit(STATE_SENT, &connection->flags);
 
 	rcu_read_lock();
-	idr_for_each_entry(&connection->volumes, device, vnr) {
+	idr_for_each_entry(&connection->peer_devices, peer_device, vnr) {
+		struct drbd_device *device = peer_device->device;
 		kref_get(&device->kref);
 		rcu_read_unlock();
 
@@ -1145,12 +1146,14 @@ static int drbd_recv_header(struct drbd_connection *connection, struct packet_in
 static void drbd_flush(struct drbd_connection *connection)
 {
 	int rv;
-	struct drbd_device *device;
+	struct drbd_peer_device *peer_device;
 	int vnr;
 
 	if (connection->write_ordering >= WO_bdev_flush) {
 		rcu_read_lock();
-		idr_for_each_entry(&connection->volumes, device, vnr) {
+		idr_for_each_entry(&connection->peer_devices, peer_device, vnr) {
+			struct drbd_device *device = peer_device->device;
+
 			if (!get_ldev(device))
 				continue;
 			kref_get(&device->kref);
@@ -1260,7 +1263,7 @@ static enum finish_epoch drbd_may_finish_epoch(struct drbd_connection *connectio
 void drbd_bump_write_ordering(struct drbd_connection *connection, enum write_ordering_e wo)
 {
 	struct disk_conf *dc;
-	struct drbd_device *device;
+	struct drbd_peer_device *peer_device;
 	enum write_ordering_e pwo;
 	int vnr;
 	static char *write_ordering_str[] = {
@@ -1272,7 +1275,9 @@ void drbd_bump_write_ordering(struct drbd_connection *connection, enum write_ord
 	pwo = connection->write_ordering;
 	wo = min(pwo, wo);
 	rcu_read_lock();
-	idr_for_each_entry(&connection->volumes, device, vnr) {
+	idr_for_each_entry(&connection->peer_devices, peer_device, vnr) {
+		struct drbd_device *device = peer_device->device;
+
 		if (!get_ldev_if_state(device, D_ATTACHING))
 			continue;
 		dc = rcu_dereference(device->ldev->disk_conf);
@@ -1401,11 +1406,13 @@ static void drbd_remove_epoch_entry_interval(struct drbd_device *device,
 
 void conn_wait_active_ee_empty(struct drbd_connection *connection)
 {
-	struct drbd_device *device;
+	struct drbd_peer_device *peer_device;
 	int vnr;
 
 	rcu_read_lock();
-	idr_for_each_entry(&connection->volumes, device, vnr) {
+	idr_for_each_entry(&connection->peer_devices, peer_device, vnr) {
+		struct drbd_device *device = peer_device->device;
+
 		kref_get(&device->kref);
 		rcu_read_unlock();
 		drbd_wait_ee_list_empty(device, &device->active_ee);
@@ -4435,7 +4442,7 @@ void conn_flush_workqueue(struct drbd_connection *connection)
 
 static void conn_disconnect(struct drbd_connection *connection)
 {
-	struct drbd_device *device;
+	struct drbd_peer_device *peer_device;
 	enum drbd_conns oc;
 	int vnr;
 
@@ -4454,11 +4461,12 @@ static void conn_disconnect(struct drbd_connection *connection)
 	drbd_free_sock(connection);
 
 	rcu_read_lock();
-	idr_for_each_entry(&connection->volumes, device, vnr) {
+	idr_for_each_entry(&connection->peer_devices, peer_device, vnr) {
+		struct drbd_device *device = peer_device->device;
 		kref_get(&device->kref);
 		rcu_read_unlock();
 		drbd_disconnected(device);
-		kref_put(&device->kref, &drbd_destroy_device);
+		kref_put(&device->kref, drbd_destroy_device);
 		rcu_read_lock();
 	}
 	rcu_read_unlock();
@@ -5110,13 +5118,15 @@ static int got_NegRSDReply(struct drbd_connection *connection, struct packet_inf
 static int got_BarrierAck(struct drbd_connection *connection, struct packet_info *pi)
 {
 	struct p_barrier_ack *p = pi->data;
-	struct drbd_device *device;
+	struct drbd_peer_device *peer_device;
 	int vnr;
 
 	tl_release(connection, p->barrier, be32_to_cpu(p->set_size));
 
 	rcu_read_lock();
-	idr_for_each_entry(&connection->volumes, device, vnr) {
+	idr_for_each_entry(&connection->peer_devices, peer_device, vnr) {
+		struct drbd_device *device = peer_device->device;
+
 		if (device->state.conn == C_AHEAD &&
 		    atomic_read(&device->ap_in_flight) == 0 &&
 		    !test_and_set_bit(AHEAD_TO_SYNC_SOURCE, &device->flags)) {
@@ -5186,7 +5196,7 @@ static int got_skip(struct drbd_connection *connection, struct packet_info *pi)
 
 static int connection_finish_peer_reqs(struct drbd_connection *connection)
 {
-	struct drbd_device *device;
+	struct drbd_peer_device *peer_device;
 	int vnr, not_empty = 0;
 
 	do {
@@ -5194,7 +5204,8 @@ static int connection_finish_peer_reqs(struct drbd_connection *connection)
 		flush_signals(current);
 
 		rcu_read_lock();
-		idr_for_each_entry(&connection->volumes, device, vnr) {
+		idr_for_each_entry(&connection->peer_devices, peer_device, vnr) {
+			struct drbd_device *device = peer_device->device;
 			kref_get(&device->kref);
 			rcu_read_unlock();
 			if (drbd_finish_peer_reqs(device)) {
@@ -5207,7 +5218,8 @@ static int connection_finish_peer_reqs(struct drbd_connection *connection)
 		set_bit(SIGNAL_ASENDER, &connection->flags);
 
 		spin_lock_irq(&connection->req_lock);
-		idr_for_each_entry(&connection->volumes, device, vnr) {
+		idr_for_each_entry(&connection->peer_devices, peer_device, vnr) {
+			struct drbd_device *device = peer_device->device;
 			not_empty = !list_empty(&device->done_ee);
 			if (not_empty)
 				break;
diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index 516992d..f6a5d4d 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -66,12 +66,13 @@ static inline bool is_susp(union drbd_state s)
 
 bool conn_all_vols_unconf(struct drbd_connection *connection)
 {
-	struct drbd_device *device;
+	struct drbd_peer_device *peer_device;
 	bool rv = true;
 	int vnr;
 
 	rcu_read_lock();
-	idr_for_each_entry(&connection->volumes, device, vnr) {
+	idr_for_each_entry(&connection->peer_devices, peer_device, vnr) {
+		struct drbd_device *device = peer_device->device;
 		if (device->state.disk != D_DISKLESS ||
 		    device->state.conn != C_STANDALONE ||
 		    device->state.role != R_SECONDARY) {
@@ -106,12 +107,14 @@ static enum drbd_role min_role(enum drbd_role role1, enum drbd_role role2)
 enum drbd_role conn_highest_role(struct drbd_connection *connection)
 {
 	enum drbd_role role = R_UNKNOWN;
-	struct drbd_device *device;
+	struct drbd_peer_device *peer_device;
 	int vnr;
 
 	rcu_read_lock();
-	idr_for_each_entry(&connection->volumes, device, vnr)
+	idr_for_each_entry(&connection->peer_devices, peer_device, vnr) {
+		struct drbd_device *device = peer_device->device;
 		role = max_role(role, device->state.role);
+	}
 	rcu_read_unlock();
 
 	return role;
@@ -120,12 +123,14 @@ enum drbd_role conn_highest_role(struct drbd_connection *connection)
 enum drbd_role conn_highest_peer(struct drbd_connection *connection)
 {
 	enum drbd_role peer = R_UNKNOWN;
-	struct drbd_device *device;
+	struct drbd_peer_device *peer_device;
 	int vnr;
 
 	rcu_read_lock();
-	idr_for_each_entry(&connection->volumes, device, vnr)
+	idr_for_each_entry(&connection->peer_devices, peer_device, vnr) {
+		struct drbd_device *device = peer_device->device;
 		peer = max_role(peer, device->state.peer);
+	}
 	rcu_read_unlock();
 
 	return peer;
@@ -134,12 +139,14 @@ enum drbd_role conn_highest_peer(struct drbd_connection *connection)
 enum drbd_disk_state conn_highest_disk(struct drbd_connection *connection)
 {
 	enum drbd_disk_state ds = D_DISKLESS;
-	struct drbd_device *device;
+	struct drbd_peer_device *peer_device;
 	int vnr;
 
 	rcu_read_lock();
-	idr_for_each_entry(&connection->volumes, device, vnr)
+	idr_for_each_entry(&connection->peer_devices, peer_device, vnr) {
+		struct drbd_device *device = peer_device->device;
 		ds = max_t(enum drbd_disk_state, ds, device->state.disk);
+	}
 	rcu_read_unlock();
 
 	return ds;
@@ -148,12 +155,14 @@ enum drbd_disk_state conn_highest_disk(struct drbd_connection *connection)
 enum drbd_disk_state conn_lowest_disk(struct drbd_connection *connection)
 {
 	enum drbd_disk_state ds = D_MASK;
-	struct drbd_device *device;
+	struct drbd_peer_device *peer_device;
 	int vnr;
 
 	rcu_read_lock();
-	idr_for_each_entry(&connection->volumes, device, vnr)
+	idr_for_each_entry(&connection->peer_devices, peer_device, vnr) {
+		struct drbd_device *device = peer_device->device;
 		ds = min_t(enum drbd_disk_state, ds, device->state.disk);
+	}
 	rcu_read_unlock();
 
 	return ds;
@@ -162,12 +171,14 @@ enum drbd_disk_state conn_lowest_disk(struct drbd_connection *connection)
 enum drbd_disk_state conn_highest_pdsk(struct drbd_connection *connection)
 {
 	enum drbd_disk_state ds = D_DISKLESS;
-	struct drbd_device *device;
+	struct drbd_peer_device *peer_device;
 	int vnr;
 
 	rcu_read_lock();
-	idr_for_each_entry(&connection->volumes, device, vnr)
+	idr_for_each_entry(&connection->peer_devices, peer_device, vnr) {
+		struct drbd_device *device = peer_device->device;
 		ds = max_t(enum drbd_disk_state, ds, device->state.pdsk);
+	}
 	rcu_read_unlock();
 
 	return ds;
@@ -176,12 +187,14 @@ enum drbd_disk_state conn_highest_pdsk(struct drbd_connection *connection)
 enum drbd_conns conn_lowest_conn(struct drbd_connection *connection)
 {
 	enum drbd_conns conn = C_MASK;
-	struct drbd_device *device;
+	struct drbd_peer_device *peer_device;
 	int vnr;
 
 	rcu_read_lock();
-	idr_for_each_entry(&connection->volumes, device, vnr)
+	idr_for_each_entry(&connection->peer_devices, peer_device, vnr) {
+		struct drbd_device *device = peer_device->device;
 		conn = min_t(enum drbd_conns, conn, device->state.conn);
+	}
 	rcu_read_unlock();
 
 	return conn;
@@ -189,13 +202,13 @@ enum drbd_conns conn_lowest_conn(struct drbd_connection *connection)
 
 static bool no_peer_wf_report_params(struct drbd_connection *connection)
 {
-	struct drbd_device *device;
+	struct drbd_peer_device *peer_device;
 	int vnr;
 	bool rv = true;
 
 	rcu_read_lock();
-	idr_for_each_entry(&connection->volumes, device, vnr)
-		if (device->state.conn == C_WF_REPORT_PARAMS) {
+	idr_for_each_entry(&connection->peer_devices, peer_device, vnr)
+		if (peer_device->device->state.conn == C_WF_REPORT_PARAMS) {
 			rv = false;
 			break;
 		}
@@ -1259,12 +1272,12 @@ static void after_state_ch(struct drbd_device *device, union drbd_state os,
 		spin_lock_irq(&connection->req_lock);
 		if (connection->susp_fen && conn_lowest_conn(connection) >= C_CONNECTED) {
 			/* case2: The connection was established again: */
-			struct drbd_device *odev;
+			struct drbd_peer_device *peer_device;
 			int vnr;
 
 			rcu_read_lock();
-			idr_for_each_entry(&connection->volumes, odev, vnr)
-				clear_bit(NEW_CUR_UUID, &odev->flags);
+			idr_for_each_entry(&connection->peer_devices, peer_device, vnr)
+				clear_bit(NEW_CUR_UUID, &peer_device->device->flags);
 			rcu_read_unlock();
 			_tl_restart(connection, RESEND);
 			_conn_request_state(connection,
@@ -1533,7 +1546,7 @@ static int w_after_conn_state_ch(struct drbd_work *w, int unused)
 	struct drbd_connection *connection = w->connection;
 	enum drbd_conns oc = acscw->oc;
 	union drbd_state ns_max = acscw->ns_max;
-	struct drbd_device *device;
+	struct drbd_peer_device *peer_device;
 	int vnr;
 
 	kfree(acscw);
@@ -1561,7 +1574,8 @@ static int w_after_conn_state_ch(struct drbd_work *w, int unused)
 		/* case1: The outdate peer handler is successful: */
 		if (ns_max.pdsk <= D_OUTDATED) {
 			rcu_read_lock();
-			idr_for_each_entry(&connection->volumes, device, vnr) {
+			idr_for_each_entry(&connection->peer_devices, peer_device, vnr) {
+				struct drbd_device *device = peer_device->device;
 				if (test_bit(NEW_CUR_UUID, &device->flags)) {
 					drbd_uuid_new_current(device);
 					clear_bit(NEW_CUR_UUID, &device->flags);
@@ -1587,7 +1601,7 @@ static int w_after_conn_state_ch(struct drbd_work *w, int unused)
 void conn_old_common_state(struct drbd_connection *connection, union drbd_state *pcs, enum chg_state_flags *pf)
 {
 	enum chg_state_flags flags = ~0;
-	struct drbd_device *device;
+	struct drbd_peer_device *peer_device;
 	int vnr, first_vol = 1;
 	union drbd_dev_state os, cs = {
 		{ .role = R_SECONDARY,
@@ -1598,7 +1612,8 @@ void conn_old_common_state(struct drbd_connection *connection, union drbd_state
 		} };
 
 	rcu_read_lock();
-	idr_for_each_entry(&connection->volumes, device, vnr) {
+	idr_for_each_entry(&connection->peer_devices, peer_device, vnr) {
+		struct drbd_device *device = peer_device->device;
 		os = device->state;
 
 		if (first_vol) {
@@ -1635,11 +1650,12 @@ conn_is_valid_transition(struct drbd_connection *connection, union drbd_state ma
 {
 	enum drbd_state_rv rv = SS_SUCCESS;
 	union drbd_state ns, os;
-	struct drbd_device *device;
+	struct drbd_peer_device *peer_device;
 	int vnr;
 
 	rcu_read_lock();
-	idr_for_each_entry(&connection->volumes, device, vnr) {
+	idr_for_each_entry(&connection->peer_devices, peer_device, vnr) {
+		struct drbd_device *device = peer_device->device;
 		os = drbd_read_state(device);
 		ns = sanitize_state(device, apply_mask_val(os, mask, val), NULL);
 
@@ -1650,10 +1666,8 @@ conn_is_valid_transition(struct drbd_connection *connection, union drbd_state ma
 			continue;
 
 		rv = is_valid_transition(os, ns);
-		if (rv < SS_SUCCESS)
-			break;
 
-		if (!(flags & CS_HARD)) {
+		if (rv >= SS_SUCCESS && !(flags & CS_HARD)) {
 			rv = is_valid_state(device, ns);
 			if (rv < SS_SUCCESS) {
 				if (is_valid_state(device, os) == rv)
@@ -1661,14 +1675,15 @@ conn_is_valid_transition(struct drbd_connection *connection, union drbd_state ma
 			} else
 				rv = is_valid_soft_transition(os, ns, connection);
 		}
-		if (rv < SS_SUCCESS)
+
+		if (rv < SS_SUCCESS) {
+			if (flags & CS_VERBOSE)
+				print_st_err(device, os, ns, rv);
 			break;
+		}
 	}
 	rcu_read_unlock();
 
-	if (rv < SS_SUCCESS && flags & CS_VERBOSE)
-		print_st_err(device, os, ns, rv);
-
 	return rv;
 }
 
@@ -1684,7 +1699,7 @@ conn_set_state(struct drbd_connection *connection, union drbd_state mask, union
 		  .disk = D_MASK,
 		  .pdsk = D_MASK
 		} };
-	struct drbd_device *device;
+	struct drbd_peer_device *peer_device;
 	enum drbd_state_rv rv;
 	int vnr, number_of_volumes = 0;
 
@@ -1699,7 +1714,8 @@ conn_set_state(struct drbd_connection *connection, union drbd_state mask, union
 	}
 
 	rcu_read_lock();
-	idr_for_each_entry(&connection->volumes, device, vnr) {
+	idr_for_each_entry(&connection->peer_devices, peer_device, vnr) {
+		struct drbd_device *device = peer_device->device;
 		number_of_volumes++;
 		os = drbd_read_state(device);
 		ns = apply_mask_val(os, mask, val);
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 4c8de54..06491d9 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -1890,7 +1890,7 @@ int drbd_worker(struct drbd_thread *thi)
 {
 	struct drbd_connection *connection = thi->connection;
 	struct drbd_work *w = NULL;
-	struct drbd_device *device;
+	struct drbd_peer_device *peer_device;
 	LIST_HEAD(work_list);
 	int vnr;
 
@@ -1934,7 +1934,8 @@ int drbd_worker(struct drbd_thread *thi)
 	} while (!list_empty(&work_list));
 
 	rcu_read_lock();
-	idr_for_each_entry(&connection->volumes, device, vnr) {
+	idr_for_each_entry(&connection->peer_devices, peer_device, vnr) {
+		struct drbd_device *device = peer_device->device;
 		D_ASSERT(device->state.disk == D_DISKLESS && device->state.conn == C_STANDALONE);
 		kref_get(&device->kref);
 		rcu_read_unlock();
-- 
1.7.9.5

