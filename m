Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932435Ab3LTMqI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 07:46:08 -0500
Received: from mail09.linbit.com ([212.69.161.110]:38621 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932338Ab3LTMjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 07:39:25 -0500
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 09/26] drbd: Improve some function and variable naming
Date: Fri, 20 Dec 2013 13:29:06 +0100
Message-Id: <1387542563-6833-10-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387542563-6833-1-git-send-email-philipp.reisner@linbit.com>
References: <1387542563-6833-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Rename functions
conn_destroy() -> drbd_destroy_connection(),
drbd_minor_destroy() -> drbd_destroy_device()
drbd_adm_add_minor() -> drbd_adm_add_minor()
drbd_adm_delete_minor() -> drbd_adm_del_minor()

Rename global variable minors to drbd_devices

Signed-off-by: Andreas Gruenbacher <agruen@linbit.com>
Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |    8 ++++----
 drivers/block/drbd/drbd_main.c     |   32 ++++++++++++++++----------------
 drivers/block/drbd/drbd_nl.c       |   32 ++++++++++++++++----------------
 drivers/block/drbd/drbd_proc.c     |    2 +-
 drivers/block/drbd/drbd_receiver.c |   12 ++++++------
 drivers/block/drbd/drbd_state.c    |    2 +-
 drivers/block/drbd/drbd_worker.c   |    6 +++---
 include/linux/drbd_genl.h          |    4 ++--
 8 files changed, 49 insertions(+), 49 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 498bebd..2b9361e 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -165,7 +165,7 @@ drbd_insert_fault(struct drbd_device *device, unsigned int type) {
 #define div_floor(A, B) ((A)/(B))
 
 extern struct ratelimit_state drbd_ratelimit_state;
-extern struct idr minors; /* RCU, updates: genl_lock() */
+extern struct idr drbd_devices; /* RCU, updates: genl_lock() */
 extern struct list_head drbd_connections; /* RCU, updates: genl_lock() */
 
 extern const char *cmdname(enum drbd_packet cmd);
@@ -766,7 +766,7 @@ struct drbd_device {
 
 static inline struct drbd_device *minor_to_device(unsigned int minor)
 {
-	return (struct drbd_device *)idr_find(&minors, minor);
+	return (struct drbd_device *)idr_find(&drbd_devices, minor);
 }
 
 static inline struct drbd_peer_device *first_peer_device(struct drbd_device *device)
@@ -1170,11 +1170,11 @@ extern rwlock_t global_state_lock;
 
 extern int conn_lowest_minor(struct drbd_connection *connection);
 enum drbd_ret_code drbd_create_minor(struct drbd_connection *connection, unsigned int minor, int vnr);
-extern void drbd_minor_destroy(struct kref *kref);
+extern void drbd_destroy_device(struct kref *kref);
 
 extern int set_resource_options(struct drbd_connection *connection, struct res_opts *res_opts);
 extern struct drbd_connection *conn_create(const char *name, struct res_opts *res_opts);
-extern void conn_destroy(struct kref *kref);
+extern void drbd_destroy_connection(struct kref *kref);
 struct drbd_connection *conn_get_by_name(const char *name);
 extern struct drbd_connection *conn_get_by_addrs(void *my_addr, int my_addr_len,
 					    void *peer_addr, int peer_addr_len);
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 0c0cfa5..cd2d25e 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -119,7 +119,7 @@ module_param_string(usermode_helper, usermode_helper, sizeof(usermode_helper), 0
 /* in 2.6.x, our device mapping and config info contains our virtual gendisks
  * as member "struct gendisk *vdisk;"
  */
-struct idr minors;
+struct idr drbd_devices;
 struct list_head drbd_connections;  /* list of struct drbd_connection */
 
 struct kmem_cache *drbd_request_cache;
@@ -366,7 +366,7 @@ restart:
 
 	/* Release mod reference taken when thread was started */
 
-	kref_put(&connection->kref, &conn_destroy);
+	kref_put(&connection->kref, drbd_destroy_connection);
 	module_put(THIS_MODULE);
 	return retval;
 }
@@ -418,7 +418,7 @@ int drbd_thread_start(struct drbd_thread *thi)
 		if (IS_ERR(nt)) {
 			conn_err(connection, "Couldn't start thread\n");
 
-			kref_put(&connection->kref, &conn_destroy);
+			kref_put(&connection->kref, drbd_destroy_connection);
 			module_put(THIS_MODULE);
 			return false;
 		}
@@ -2160,7 +2160,7 @@ static void drbd_release_all_peer_reqs(struct drbd_device *device)
 }
 
 /* caution. no locking. */
-void drbd_minor_destroy(struct kref *kref)
+void drbd_destroy_device(struct kref *kref)
 {
 	struct drbd_device *device = container_of(kref, struct drbd_device, kref);
 	struct drbd_connection *connection = first_peer_device(device)->connection;
@@ -2197,7 +2197,7 @@ void drbd_minor_destroy(struct kref *kref)
 	kfree(first_peer_device(device));
 	kfree(device);
 
-	kref_put(&connection->kref, &conn_destroy);
+	kref_put(&connection->kref, drbd_destroy_connection);
 }
 
 /* One global retry thread, if we need to push back some bio and have it
@@ -2303,26 +2303,26 @@ static void drbd_cleanup(void)
 
 	drbd_genl_unregister();
 
-	idr_for_each_entry(&minors, device, i) {
-		idr_remove(&minors, device_to_minor(device));
+	idr_for_each_entry(&drbd_devices, device, i) {
+		idr_remove(&drbd_devices, device_to_minor(device));
 		idr_remove(&first_peer_device(device)->connection->volumes, device->vnr);
 		destroy_workqueue(device->submit.wq);
 		del_gendisk(device->vdisk);
 		/* synchronize_rcu(); No other threads running at this point */
-		kref_put(&device->kref, &drbd_minor_destroy);
+		kref_put(&device->kref, drbd_destroy_device);
 	}
 
 	/* not _rcu since, no other updater anymore. Genl already unregistered */
 	list_for_each_entry_safe(connection, tmp, &drbd_connections, connections) {
 		list_del(&connection->connections); /* not _rcu no proc, not other threads */
 		/* synchronize_rcu(); */
-		kref_put(&connection->kref, &conn_destroy);
+		kref_put(&connection->kref, drbd_destroy_connection);
 	}
 
 	drbd_destroy_mempools();
 	unregister_blkdev(DRBD_MAJOR, "drbd");
 
-	idr_destroy(&minors);
+	idr_destroy(&drbd_devices);
 
 	printk(KERN_INFO "drbd: module cleanup done.\n");
 }
@@ -2578,7 +2578,7 @@ fail:
 	return NULL;
 }
 
-void conn_destroy(struct kref *kref)
+void drbd_destroy_connection(struct kref *kref)
 {
 	struct drbd_connection *connection = container_of(kref, struct drbd_connection, kref);
 
@@ -2690,7 +2690,7 @@ enum drbd_ret_code drbd_create_minor(struct drbd_connection *connection, unsigne
 	device->read_requests = RB_ROOT;
 	device->write_requests = RB_ROOT;
 
-	minor_got = idr_alloc(&minors, device, minor, minor + 1, GFP_KERNEL);
+	minor_got = idr_alloc(&drbd_devices, device, minor, minor + 1, GFP_KERNEL);
 	if (minor_got < 0) {
 		if (minor_got == -ENOSPC) {
 			err = ERR_MINOR_EXISTS;
@@ -2727,7 +2727,7 @@ enum drbd_ret_code drbd_create_minor(struct drbd_connection *connection, unsigne
 out_idr_remove_vol:
 	idr_remove(&connection->volumes, vnr_got);
 out_idr_remove_minor:
-	idr_remove(&minors, minor_got);
+	idr_remove(&drbd_devices, minor_got);
 	synchronize_rcu();
 out_no_minor_idr:
 	drbd_bm_cleanup(device);
@@ -2738,7 +2738,7 @@ out_no_io_page:
 out_no_disk:
 	blk_cleanup_queue(q);
 out_no_q:
-	kref_put(&connection->kref, &conn_destroy);
+	kref_put(&connection->kref, drbd_destroy_connection);
 out_no_peer_device:
 	kfree(device);
 	return err;
@@ -2774,7 +2774,7 @@ int __init drbd_init(void)
 	init_waitqueue_head(&drbd_pp_wait);
 
 	drbd_proc = NULL; /* play safe for drbd_cleanup */
-	idr_init(&minors);
+	idr_init(&drbd_devices);
 
 	rwlock_init(&global_state_lock);
 	INIT_LIST_HEAD(&drbd_connections);
@@ -2865,7 +2865,7 @@ void conn_md_sync(struct drbd_connection *connection)
 		kref_get(&device->kref);
 		rcu_read_unlock();
 		drbd_md_sync(device);
-		kref_put(&device->kref, &drbd_minor_destroy);
+		kref_put(&device->kref, drbd_destroy_device);
 		rcu_read_lock();
 	}
 	rcu_read_unlock();
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 9e89f8c..e4ef018 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -45,8 +45,8 @@
 // int drbd_adm_create_resource(struct sk_buff *skb, struct genl_info *info);
 // int drbd_adm_delete_resource(struct sk_buff *skb, struct genl_info *info);
 
-int drbd_adm_add_minor(struct sk_buff *skb, struct genl_info *info);
-int drbd_adm_delete_minor(struct sk_buff *skb, struct genl_info *info);
+int drbd_adm_new_minor(struct sk_buff *skb, struct genl_info *info);
+int drbd_adm_del_minor(struct sk_buff *skb, struct genl_info *info);
 
 int drbd_adm_new_resource(struct sk_buff *skb, struct genl_info *info);
 int drbd_adm_del_resource(struct sk_buff *skb, struct genl_info *info);
@@ -274,7 +274,7 @@ fail:
 static int drbd_adm_finish(struct genl_info *info, int retcode)
 {
 	if (adm_ctx.connection) {
-		kref_put(&adm_ctx.connection->kref, &conn_destroy);
+		kref_put(&adm_ctx.connection->kref, drbd_destroy_connection);
 		adm_ctx.connection = NULL;
 	}
 
@@ -517,7 +517,7 @@ static int _try_outdate_peer_async(void *data)
 
 	conn_try_outdate_peer(connection);
 
-	kref_put(&connection->kref, &conn_destroy);
+	kref_put(&connection->kref, drbd_destroy_connection);
 	return 0;
 }
 
@@ -529,7 +529,7 @@ void conn_try_outdate_peer_async(struct drbd_connection *connection)
 	opa = kthread_run(_try_outdate_peer_async, connection, "drbd_async_h");
 	if (IS_ERR(opa)) {
 		conn_err(connection, "out of mem, failed to invoke fence-peer helper\n");
-		kref_put(&connection->kref, &conn_destroy);
+		kref_put(&connection->kref, drbd_destroy_connection);
 	}
 }
 
@@ -2924,7 +2924,7 @@ int get_one_status(struct sk_buff *skb, struct netlink_callback *cb)
 	 * on each iteration.
 	 */
 
-	/* synchronize with conn_create()/conn_destroy() */
+	/* synchronize with conn_create()/drbd_destroy_connection() */
 	rcu_read_lock();
 	/* revalidate iterator position */
 	list_for_each_entry_rcu(tmp, &drbd_connections, connections) {
@@ -3056,7 +3056,7 @@ int drbd_adm_get_status_all(struct sk_buff *skb, struct netlink_callback *cb)
 	if (!connection)
 		return -ENODEV;
 
-	kref_put(&connection->kref, &conn_destroy); /* get_one_status() (re)validates connection by itself */
+	kref_put(&connection->kref, drbd_destroy_connection); /* get_one_status() (re)validates connection by itself */
 
 	/* prime iterators, and set "filter" mode mark:
 	 * only dump this connection. */
@@ -3266,7 +3266,7 @@ out:
 	return 0;
 }
 
-int drbd_adm_add_minor(struct sk_buff *skb, struct genl_info *info)
+int drbd_adm_new_minor(struct sk_buff *skb, struct genl_info *info)
 {
 	struct drbd_genlmsghdr *dh = info->userhdr;
 	enum drbd_ret_code retcode;
@@ -3303,7 +3303,7 @@ out:
 	return 0;
 }
 
-static enum drbd_ret_code adm_delete_minor(struct drbd_device *device)
+static enum drbd_ret_code adm_del_minor(struct drbd_device *device)
 {
 	if (device->state.disk == D_DISKLESS &&
 	    /* no need to be device->state.conn == C_STANDALONE &&
@@ -3313,17 +3313,17 @@ static enum drbd_ret_code adm_delete_minor(struct drbd_device *device)
 		_drbd_request_state(device, NS(conn, C_WF_REPORT_PARAMS),
 				    CS_VERBOSE + CS_WAIT_COMPLETE);
 		idr_remove(&first_peer_device(device)->connection->volumes, device->vnr);
-		idr_remove(&minors, device_to_minor(device));
+		idr_remove(&drbd_devices, device_to_minor(device));
 		destroy_workqueue(device->submit.wq);
 		del_gendisk(device->vdisk);
 		synchronize_rcu();
-		kref_put(&device->kref, &drbd_minor_destroy);
+		kref_put(&device->kref, drbd_destroy_device);
 		return NO_ERROR;
 	} else
 		return ERR_MINOR_CONFIGURED;
 }
 
-int drbd_adm_delete_minor(struct sk_buff *skb, struct genl_info *info)
+int drbd_adm_del_minor(struct sk_buff *skb, struct genl_info *info)
 {
 	enum drbd_ret_code retcode;
 
@@ -3333,7 +3333,7 @@ int drbd_adm_delete_minor(struct sk_buff *skb, struct genl_info *info)
 	if (retcode != NO_ERROR)
 		goto out;
 
-	retcode = adm_delete_minor(adm_ctx.device);
+	retcode = adm_del_minor(adm_ctx.device);
 out:
 	drbd_adm_finish(info, retcode);
 	return 0;
@@ -3389,7 +3389,7 @@ int drbd_adm_down(struct sk_buff *skb, struct genl_info *info)
 
 	/* delete volumes */
 	idr_for_each_entry(&adm_ctx.connection->volumes, device, i) {
-		retcode = adm_delete_minor(device);
+		retcode = adm_del_minor(device);
 		if (retcode != NO_ERROR) {
 			/* "can not happen" */
 			drbd_msg_put_info("failed to delete volume");
@@ -3401,7 +3401,7 @@ int drbd_adm_down(struct sk_buff *skb, struct genl_info *info)
 	if (conn_lowest_minor(adm_ctx.connection) < 0) {
 		list_del_rcu(&adm_ctx.connection->connections);
 		synchronize_rcu();
-		kref_put(&adm_ctx.connection->kref, &conn_destroy);
+		kref_put(&adm_ctx.connection->kref, drbd_destroy_connection);
 
 		retcode = NO_ERROR;
 	} else {
@@ -3428,7 +3428,7 @@ int drbd_adm_del_resource(struct sk_buff *skb, struct genl_info *info)
 	if (conn_lowest_minor(adm_ctx.connection) < 0) {
 		list_del_rcu(&adm_ctx.connection->connections);
 		synchronize_rcu();
-		kref_put(&adm_ctx.connection->kref, &conn_destroy);
+		kref_put(&adm_ctx.connection->kref, drbd_destroy_connection);
 
 		retcode = NO_ERROR;
 	} else {
diff --git a/drivers/block/drbd/drbd_proc.c b/drivers/block/drbd/drbd_proc.c
index 34cf724..04654a4 100644
--- a/drivers/block/drbd/drbd_proc.c
+++ b/drivers/block/drbd/drbd_proc.c
@@ -236,7 +236,7 @@ static int drbd_seq_show(struct seq_file *seq, void *v)
 	*/
 
 	rcu_read_lock();
-	idr_for_each_entry(&minors, device, i) {
+	idr_for_each_entry(&drbd_devices, device, i) {
 		if (prev_i != i - 1)
 			seq_printf(seq, "\n");
 		prev_i = i;
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index c2397e6..e480e73 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -1058,7 +1058,7 @@ randomize:
 			clear_bit(DISCARD_MY_DATA, &device->flags);
 
 		drbd_connected(device);
-		kref_put(&device->kref, &drbd_minor_destroy);
+		kref_put(&device->kref, drbd_destroy_device);
 		rcu_read_lock();
 	}
 	rcu_read_unlock();
@@ -1166,7 +1166,7 @@ static void drbd_flush(struct drbd_connection *connection)
 				drbd_bump_write_ordering(connection, WO_drain_io);
 			}
 			put_ldev(device);
-			kref_put(&device->kref, &drbd_minor_destroy);
+			kref_put(&device->kref, drbd_destroy_device);
 
 			rcu_read_lock();
 			if (rv)
@@ -1409,7 +1409,7 @@ void conn_wait_active_ee_empty(struct drbd_connection *connection)
 		kref_get(&device->kref);
 		rcu_read_unlock();
 		drbd_wait_ee_list_empty(device, &device->active_ee);
-		kref_put(&device->kref, &drbd_minor_destroy);
+		kref_put(&device->kref, drbd_destroy_device);
 		rcu_read_lock();
 	}
 	rcu_read_unlock();
@@ -4458,7 +4458,7 @@ static void conn_disconnect(struct drbd_connection *connection)
 		kref_get(&device->kref);
 		rcu_read_unlock();
 		drbd_disconnected(device);
-		kref_put(&device->kref, &drbd_minor_destroy);
+		kref_put(&device->kref, &drbd_destroy_device);
 		rcu_read_lock();
 	}
 	rcu_read_unlock();
@@ -5198,10 +5198,10 @@ static int connection_finish_peer_reqs(struct drbd_connection *connection)
 			kref_get(&device->kref);
 			rcu_read_unlock();
 			if (drbd_finish_peer_reqs(device)) {
-				kref_put(&device->kref, &drbd_minor_destroy);
+				kref_put(&device->kref, drbd_destroy_device);
 				return 1;
 			}
-			kref_put(&device->kref, &drbd_minor_destroy);
+			kref_put(&device->kref, drbd_destroy_device);
 			rcu_read_lock();
 		}
 		set_bit(SIGNAL_ASENDER, &connection->flags);
diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index f029d12..cf6b475 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -1577,7 +1577,7 @@ static int w_after_conn_state_ch(struct drbd_work *w, int unused)
 			spin_unlock_irq(&connection->req_lock);
 		}
 	}
-	kref_put(&connection->kref, &conn_destroy);
+	kref_put(&connection->kref, drbd_destroy_connection);
 
 	conn_md_sync(connection);
 
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 272fbd1..4c8de54 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -1458,7 +1458,7 @@ static int _drbd_pause_after(struct drbd_device *device)
 	int i, rv = 0;
 
 	rcu_read_lock();
-	idr_for_each_entry(&minors, odev, i) {
+	idr_for_each_entry(&drbd_devices, odev, i) {
 		if (odev->state.conn == C_STANDALONE && odev->state.disk == D_DISKLESS)
 			continue;
 		if (!_drbd_may_sync_now(odev))
@@ -1482,7 +1482,7 @@ static int _drbd_resume_next(struct drbd_device *device)
 	int i, rv = 0;
 
 	rcu_read_lock();
-	idr_for_each_entry(&minors, odev, i) {
+	idr_for_each_entry(&drbd_devices, odev, i) {
 		if (odev->state.conn == C_STANDALONE && odev->state.disk == D_DISKLESS)
 			continue;
 		if (odev->state.aftr_isp) {
@@ -1939,7 +1939,7 @@ int drbd_worker(struct drbd_thread *thi)
 		kref_get(&device->kref);
 		rcu_read_unlock();
 		drbd_device_cleanup(device);
-		kref_put(&device->kref, &drbd_minor_destroy);
+		kref_put(&device->kref, drbd_destroy_device);
 		rcu_read_lock();
 	}
 	rcu_read_unlock();
diff --git a/include/linux/drbd_genl.h b/include/linux/drbd_genl.h
index e8c4457..b14a2e8 100644
--- a/include/linux/drbd_genl.h
+++ b/include/linux/drbd_genl.h
@@ -276,9 +276,9 @@ GENL_op(
 )
 
 	/* add DRBD minor devices as volumes to resources */
-GENL_op(DRBD_ADM_NEW_MINOR, 5, GENL_doit(drbd_adm_add_minor),
+GENL_op(DRBD_ADM_NEW_MINOR, 5, GENL_doit(drbd_adm_new_minor),
 	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, DRBD_F_REQUIRED))
-GENL_op(DRBD_ADM_DEL_MINOR, 6, GENL_doit(drbd_adm_delete_minor),
+GENL_op(DRBD_ADM_DEL_MINOR, 6, GENL_doit(drbd_adm_del_minor),
 	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, DRBD_F_REQUIRED))
 
 	/* add or delete resources */
-- 
1.7.9.5

