Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350AbaF3QDI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 12:03:08 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:49990 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600AbaF3PxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 11:53:10 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 01/18] drbd: Move write_ordering from connection to resource
Date: Mon, 30 Jun 2014 17:52:50 +0200
Message-Id: <1404143587-24344-2-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404143587-24344-1-git-send-email-philipp.reisner@linbit.com>
References: <1404143587-24344-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |  5 +++--
 drivers/block/drbd/drbd_main.c     |  2 +-
 drivers/block/drbd/drbd_nl.c       |  4 ++--
 drivers/block/drbd/drbd_proc.c     |  2 +-
 drivers/block/drbd/drbd_receiver.c | 25 ++++++++++++-------------
 5 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index a76ceb3..1ef2474 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -594,6 +594,8 @@ struct drbd_resource {
 	unsigned susp_nod:1;		/* IO suspended because no data */
 	unsigned susp_fen:1;		/* IO suspended because fence peer handler runs */
 
+	enum write_ordering_e write_ordering;
+
 	cpumask_var_t cpu_mask;
 };
 
@@ -636,7 +638,6 @@ struct drbd_connection {
 	struct drbd_epoch *current_epoch;
 	spinlock_t epoch_lock;
 	unsigned int epochs;
-	enum write_ordering_e write_ordering;
 	atomic_t current_tle_nr;	/* transfer log epoch number */
 	unsigned current_tle_writes;	/* writes seen within this tl epoch */
 
@@ -1478,7 +1479,7 @@ static inline void drbd_generic_make_request(struct drbd_device *device,
 		generic_make_request(bio);
 }
 
-void drbd_bump_write_ordering(struct drbd_connection *connection, enum write_ordering_e wo);
+void drbd_bump_write_ordering(struct drbd_resource *resource, enum write_ordering_e wo);
 
 /* drbd_proc.c */
 extern struct proc_dir_entry *drbd_proc;
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 960645c..17b9a23 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2579,6 +2579,7 @@ struct drbd_resource *drbd_create_resource(const char *name)
 	kref_init(&resource->kref);
 	idr_init(&resource->devices);
 	INIT_LIST_HEAD(&resource->connections);
+	resource->write_ordering = WO_bdev_flush;
 	list_add_tail_rcu(&resource->resources, &drbd_resources);
 	mutex_init(&resource->conf_update);
 	mutex_init(&resource->adm_mutex);
@@ -2617,7 +2618,6 @@ struct drbd_connection *conn_create(const char *name, struct res_opts *res_opts)
 	INIT_LIST_HEAD(&connection->current_epoch->list);
 	connection->epochs = 1;
 	spin_lock_init(&connection->epoch_lock);
-	connection->write_ordering = WO_bdev_flush;
 
 	connection->send.seen_any_write_yet = false;
 	connection->send.current_epoch_nr = 0;
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 1b35c45..43fad2c 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1399,7 +1399,7 @@ int drbd_adm_disk_opts(struct sk_buff *skb, struct genl_info *info)
 	else
 		set_bit(MD_NO_FUA, &device->flags);
 
-	drbd_bump_write_ordering(first_peer_device(device)->connection, WO_bdev_flush);
+	drbd_bump_write_ordering(device->resource, WO_bdev_flush);
 
 	drbd_md_sync(device);
 
@@ -1704,7 +1704,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 	new_disk_conf = NULL;
 	new_plan = NULL;
 
-	drbd_bump_write_ordering(first_peer_device(device)->connection, WO_bdev_flush);
+	drbd_bump_write_ordering(device->resource, WO_bdev_flush);
 
 	if (drbd_md_test_flag(device->ldev, MDF_CRASHED_PRIMARY))
 		set_bit(CRASHED_PRIMARY, &device->flags);
diff --git a/drivers/block/drbd/drbd_proc.c b/drivers/block/drbd/drbd_proc.c
index 89736bd..f11e573 100644
--- a/drivers/block/drbd/drbd_proc.c
+++ b/drivers/block/drbd/drbd_proc.c
@@ -281,7 +281,7 @@ static int drbd_seq_show(struct seq_file *seq, void *v)
 			   atomic_read(&device->unacked_cnt),
 			   atomic_read(&device->ap_bio_cnt),
 			   first_peer_device(device)->connection->epochs,
-			   write_ordering_chars[first_peer_device(device)->connection->write_ordering]
+			   write_ordering_chars[device->resource->write_ordering]
 			);
 			seq_printf(seq, " oos:%llu\n",
 				   Bit2KB((unsigned long long)
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 5b17ec8..c708418 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -1151,7 +1151,7 @@ static void drbd_flush(struct drbd_connection *connection)
 	struct drbd_peer_device *peer_device;
 	int vnr;
 
-	if (connection->write_ordering >= WO_bdev_flush) {
+	if (connection->resource->write_ordering >= WO_bdev_flush) {
 		rcu_read_lock();
 		idr_for_each_entry(&connection->peer_devices, peer_device, vnr) {
 			struct drbd_device *device = peer_device->device;
@@ -1168,7 +1168,7 @@ static void drbd_flush(struct drbd_connection *connection)
 				/* would rather check on EOPNOTSUPP, but that is not reliable.
 				 * don't try again for ANY return value != 0
 				 * if (rv == -EOPNOTSUPP) */
-				drbd_bump_write_ordering(connection, WO_drain_io);
+				drbd_bump_write_ordering(connection->resource, WO_drain_io);
 			}
 			put_ldev(device);
 			kref_put(&device->kref, drbd_destroy_device);
@@ -1262,10 +1262,10 @@ static enum finish_epoch drbd_may_finish_epoch(struct drbd_connection *connectio
  * @connection:	DRBD connection.
  * @wo:		Write ordering method to try.
  */
-void drbd_bump_write_ordering(struct drbd_connection *connection, enum write_ordering_e wo)
+void drbd_bump_write_ordering(struct drbd_resource *resource, enum write_ordering_e wo)
 {
 	struct disk_conf *dc;
-	struct drbd_peer_device *peer_device;
+	struct drbd_device *device;
 	enum write_ordering_e pwo;
 	int vnr;
 	static char *write_ordering_str[] = {
@@ -1274,12 +1274,10 @@ void drbd_bump_write_ordering(struct drbd_connection *connection, enum write_ord
 		[WO_bdev_flush] = "flush",
 	};
 
-	pwo = connection->write_ordering;
+	pwo = resource->write_ordering;
 	wo = min(pwo, wo);
 	rcu_read_lock();
-	idr_for_each_entry(&connection->peer_devices, peer_device, vnr) {
-		struct drbd_device *device = peer_device->device;
-
+	idr_for_each_entry(&resource->devices, device, vnr) {
 		if (!get_ldev_if_state(device, D_ATTACHING))
 			continue;
 		dc = rcu_dereference(device->ldev->disk_conf);
@@ -1291,9 +1289,9 @@ void drbd_bump_write_ordering(struct drbd_connection *connection, enum write_ord
 		put_ldev(device);
 	}
 	rcu_read_unlock();
-	connection->write_ordering = wo;
-	if (pwo != connection->write_ordering || wo == WO_bdev_flush)
-		drbd_info(connection, "Method to ensure write ordering: %s\n", write_ordering_str[connection->write_ordering]);
+	resource->write_ordering = wo;
+	if (pwo != resource->write_ordering || wo == WO_bdev_flush)
+		drbd_info(resource, "Method to ensure write ordering: %s\n", write_ordering_str[resource->write_ordering]);
 }
 
 /**
@@ -1471,7 +1469,7 @@ static int receive_Barrier(struct drbd_connection *connection, struct packet_inf
 	 * R_PRIMARY crashes now.
 	 * Therefore we must send the barrier_ack after the barrier request was
 	 * completed. */
-	switch (connection->write_ordering) {
+	switch (connection->resource->write_ordering) {
 	case WO_none:
 		if (rv == FE_RECYCLED)
 			return 0;
@@ -1498,7 +1496,8 @@ static int receive_Barrier(struct drbd_connection *connection, struct packet_inf
 
 		return 0;
 	default:
-		drbd_err(connection, "Strangeness in connection->write_ordering %d\n", connection->write_ordering);
+		drbd_err(connection, "Strangeness in connection->write_ordering %d\n",
+			 connection->resource->write_ordering);
 		return -EIO;
 	}
 
-- 
1.9.1

