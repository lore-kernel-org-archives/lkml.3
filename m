Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932437Ab3LTMjk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 07:39:40 -0500
Received: from mail09.linbit.com ([212.69.161.110]:38635 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932359Ab3LTMj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 07:39:27 -0500
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 14/26] drbd: Add struct drbd_resource->devices
Date: Fri, 20 Dec 2013 13:29:11 +0100
Message-Id: <1387542563-6833-15-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387542563-6833-1-git-send-email-philipp.reisner@linbit.com>
References: <1387542563-6833-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

This allows to access the volumes of a resource by number.

Signed-off-by: Andreas Gruenbacher <agruen@linbit.com>
Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
---
 drivers/block/drbd/drbd_int.h  |    2 ++
 drivers/block/drbd/drbd_main.c |   62 +++++++++++++++++++++++++++++++---------
 drivers/block/drbd/drbd_nl.c   |    7 +----
 3 files changed, 51 insertions(+), 20 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 7a2f659..8b57e0b 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -534,6 +534,7 @@ enum {
 struct drbd_resource {
 	char *name;
 	struct kref kref;
+	struct idr devices;		/* volume number to device mapping */
 	struct list_head connections;
 	struct list_head resources;
 };
@@ -1197,6 +1198,7 @@ extern rwlock_t global_state_lock;
 extern int conn_lowest_minor(struct drbd_connection *connection);
 enum drbd_ret_code drbd_create_minor(struct drbd_connection *connection, unsigned int minor, int vnr);
 extern void drbd_destroy_device(struct kref *kref);
+extern void drbd_delete_minor(struct drbd_device *mdev);
 
 extern struct drbd_resource *drbd_create_resource(const char *name);
 extern void drbd_free_resource(struct drbd_resource *resource);
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 1ce1066..fe16e6d 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2164,7 +2164,8 @@ static void drbd_release_all_peer_reqs(struct drbd_device *device)
 void drbd_destroy_device(struct kref *kref)
 {
 	struct drbd_device *device = container_of(kref, struct drbd_device, kref);
-	struct drbd_connection *connection = first_peer_device(device)->connection;
+	struct drbd_resource *resource = device->resource;
+	struct drbd_connection *connection;
 
 	del_timer_sync(&device->request_timer);
 
@@ -2198,7 +2199,9 @@ void drbd_destroy_device(struct kref *kref)
 	kfree(first_peer_device(device));
 	kfree(device);
 
-	kref_put(&connection->kref, drbd_destroy_connection);
+	for_each_connection(connection, resource)
+		kref_put(&connection->kref, drbd_destroy_connection);
+	kref_put(&resource->kref, drbd_destroy_resource);
 }
 
 /* One global retry thread, if we need to push back some bio and have it
@@ -2284,6 +2287,7 @@ void drbd_destroy_resource(struct kref *kref)
 	struct drbd_resource *resource =
 		container_of(kref, struct drbd_resource, kref);
 
+	idr_destroy(&resource->devices);
 	kfree(resource->name);
 	kfree(resource);
 }
@@ -2323,14 +2327,8 @@ static void drbd_cleanup(void)
 
 	drbd_genl_unregister();
 
-	idr_for_each_entry(&drbd_devices, device, i) {
-		idr_remove(&drbd_devices, device_to_minor(device));
-		idr_remove(&first_peer_device(device)->connection->volumes, device->vnr);
-		destroy_workqueue(device->submit.wq);
-		del_gendisk(device->vdisk);
-		/* synchronize_rcu(); No other threads running at this point */
-		kref_put(&device->kref, drbd_destroy_device);
-	}
+	idr_for_each_entry(&drbd_devices, device, i)
+		drbd_delete_minor(device);
 
 	/* not _rcu since, no other updater anymore. Genl already unregistered */
 	for_each_resource_safe(resource, tmp, &drbd_resources) {
@@ -2545,6 +2543,7 @@ struct drbd_resource *drbd_create_resource(const char *name)
 		return NULL;
 	}
 	kref_init(&resource->kref);
+	idr_init(&resource->devices);
 	INIT_LIST_HEAD(&resource->connections);
 	list_add_tail_rcu(&resource->resources, &drbd_resources);
 	return resource;
@@ -2660,6 +2659,7 @@ int init_submitter(struct drbd_device *device)
 
 enum drbd_ret_code drbd_create_minor(struct drbd_connection *connection, unsigned int minor, int vnr)
 {
+	struct drbd_resource *resource = connection->resource;
 	struct drbd_device *device;
 	struct drbd_peer_device *peer_device;
 	struct gendisk *disk;
@@ -2675,14 +2675,17 @@ enum drbd_ret_code drbd_create_minor(struct drbd_connection *connection, unsigne
 	device = kzalloc(sizeof(struct drbd_device), GFP_KERNEL);
 	if (!device)
 		return ERR_NOMEM;
+	kref_init(&device->kref);
+
 	peer_device = kzalloc(sizeof(struct drbd_peer_device), GFP_KERNEL);
 	if (!peer_device)
 		goto out_no_peer_device;
 
 	INIT_LIST_HEAD(&device->peer_devices);
 	list_add(&peer_device->peer_devices, &device->peer_devices);
+	kref_get(&resource->kref);
+	device->resource = resource;
 	kref_get(&connection->kref);
-	device->resource = connection->resource;
 	peer_device->connection = connection;
 	peer_device->device = device;
 
@@ -2725,7 +2728,7 @@ enum drbd_ret_code drbd_create_minor(struct drbd_connection *connection, unsigne
 	blk_queue_max_hw_sectors(q, DRBD_MAX_BIO_SIZE_SAFE >> 8);
 	blk_queue_bounce_limit(q, BLK_BOUNCE_ANY);
 	blk_queue_merge_bvec(q, drbd_merge_bvec);
-	q->queue_lock = &first_peer_device(device)->connection->req_lock; /* needed since we use */
+	q->queue_lock = &connection->req_lock;
 
 	device->md_io_page = alloc_page(GFP_KERNEL);
 	if (!device->md_io_page)
@@ -2744,6 +2747,17 @@ enum drbd_ret_code drbd_create_minor(struct drbd_connection *connection, unsigne
 		}
 		goto out_no_minor_idr;
 	}
+	kref_get(&device->kref);
+
+	id = idr_alloc(&resource->devices, device, vnr, vnr + 1, GFP_KERNEL);
+	if (id < 0) {
+		if (id == -ENOSPC) {
+			err = ERR_MINOR_EXISTS;
+			drbd_msg_put_info("requested minor exists already");
+		}
+		goto out_idr_remove_minor;
+	}
+	kref_get(&device->kref);
 
 	id = idr_alloc(&connection->volumes, device, vnr, vnr + 1, GFP_KERNEL);
 	if (id < 0) {
@@ -2751,8 +2765,9 @@ enum drbd_ret_code drbd_create_minor(struct drbd_connection *connection, unsigne
 			err = ERR_INVALID_REQUEST;
 			drbd_msg_put_info("requested volume exists already");
 		}
-		goto out_idr_remove_minor;
+		goto out_idr_remove_from_resource;
 	}
+	kref_get(&device->kref);
 
 	if (init_submitter(device)) {
 		err = ERR_NOMEM;
@@ -2761,7 +2776,6 @@ enum drbd_ret_code drbd_create_minor(struct drbd_connection *connection, unsigne
 	}
 
 	add_disk(disk);
-	kref_init(&device->kref); /* one ref for both idrs and the the add_disk */
 
 	/* inherit the connection state */
 	device->state.conn = connection->cstate;
@@ -2772,6 +2786,8 @@ enum drbd_ret_code drbd_create_minor(struct drbd_connection *connection, unsigne
 
 out_idr_remove_vol:
 	idr_remove(&connection->volumes, vnr);
+out_idr_remove_from_resource:
+	idr_remove(&resource->devices, vnr);
 out_idr_remove_minor:
 	idr_remove(&drbd_devices, minor);
 	synchronize_rcu();
@@ -2785,11 +2801,29 @@ out_no_disk:
 	blk_cleanup_queue(q);
 out_no_q:
 	kref_put(&connection->kref, drbd_destroy_connection);
+	kref_put(&resource->kref, drbd_destroy_resource);
 out_no_peer_device:
 	kfree(device);
 	return err;
 }
 
+void drbd_delete_minor(struct drbd_device *device)
+{
+	struct drbd_resource *resource = device->resource;
+	struct drbd_connection *connection;
+	int refs = 3;
+
+	for_each_connection(connection, resource) {
+		idr_remove(&connection->volumes, device->vnr);
+		refs++;
+	}
+	idr_remove(&resource->devices, device->vnr);
+	idr_remove(&drbd_devices, device_to_minor(device));
+	del_gendisk(device->vdisk);
+	synchronize_rcu();
+	kref_sub(&device->kref, refs, drbd_destroy_device);
+}
+
 int __init drbd_init(void)
 {
 	int err;
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 2cef34f..6b0aa47 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -3324,12 +3324,7 @@ static enum drbd_ret_code adm_del_minor(struct drbd_device *device)
 	    device->state.role == R_SECONDARY) {
 		_drbd_request_state(device, NS(conn, C_WF_REPORT_PARAMS),
 				    CS_VERBOSE + CS_WAIT_COMPLETE);
-		idr_remove(&first_peer_device(device)->connection->volumes, device->vnr);
-		idr_remove(&drbd_devices, device_to_minor(device));
-		destroy_workqueue(device->submit.wq);
-		del_gendisk(device->vdisk);
-		synchronize_rcu();
-		kref_put(&device->kref, drbd_destroy_device);
+		drbd_delete_minor(device);
 		return NO_ERROR;
 	} else
 		return ERR_MINOR_CONFIGURED;
-- 
1.7.9.5

