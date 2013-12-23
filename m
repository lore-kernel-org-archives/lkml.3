Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932671Ab3LWWGQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 17:06:16 -0500
Received: from zimbra13.linbit.com ([212.69.166.240]:60637 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758018Ab3LWV6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 16:58:53 -0500
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 02/27] drbd: Iterate over all connections
Date: Mon, 23 Dec 2013 22:50:31 +0100
Message-Id: <1387835456-29695-3-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387835456-29695-1-git-send-email-philipp.reisner@linbit.com>
References: <1387835456-29695-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

in drbd_adm_down(), drbd_create_device() and drbd_set_role()

Signed-off-by: Andreas Gruenbacher <agruen@linbit.com>
Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
---
 drivers/block/drbd/drbd_main.c |   55 +++++++++++++++++++-------------
 drivers/block/drbd/drbd_nl.c   |   68 ++++++++++++++++++++++------------------
 2 files changed, 70 insertions(+), 53 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 6ed09d5..c4aec68 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2663,9 +2663,9 @@ int init_submitter(struct drbd_device *device)
 
 enum drbd_ret_code drbd_create_device(struct drbd_resource *resource, unsigned int minor, int vnr)
 {
-	struct drbd_connection *connection = first_connection(resource);
+	struct drbd_connection *connection;
 	struct drbd_device *device;
-	struct drbd_peer_device *peer_device;
+	struct drbd_peer_device *peer_device, *tmp_peer_device;
 	struct gendisk *disk;
 	struct request_queue *q;
 	int id;
@@ -2681,18 +2681,8 @@ enum drbd_ret_code drbd_create_device(struct drbd_resource *resource, unsigned i
 		return ERR_NOMEM;
 	kref_init(&device->kref);
 
-	peer_device = kzalloc(sizeof(struct drbd_peer_device), GFP_KERNEL);
-	if (!peer_device)
-		goto out_no_peer_device;
-
-	INIT_LIST_HEAD(&device->peer_devices);
-	list_add(&peer_device->peer_devices, &device->peer_devices);
 	kref_get(&resource->kref);
 	device->resource = resource;
-	kref_get(&connection->kref);
-	peer_device->connection = connection;
-	peer_device->device = device;
-
 	device->minor = minor;
 	device->vnr = vnr;
 
@@ -2763,15 +2753,27 @@ enum drbd_ret_code drbd_create_device(struct drbd_resource *resource, unsigned i
 	}
 	kref_get(&device->kref);
 
-	id = idr_alloc(&connection->peer_devices, peer_device, vnr, vnr + 1, GFP_KERNEL);
-	if (id < 0) {
-		if (id == -ENOSPC) {
-			err = ERR_INVALID_REQUEST;
-			drbd_msg_put_info("requested volume exists already");
+	INIT_LIST_HEAD(&device->peer_devices);
+	for_each_connection(connection, resource) {
+		peer_device = kzalloc(sizeof(struct drbd_peer_device), GFP_KERNEL);
+		if (!peer_device)
+			goto out_idr_remove_from_resource;
+		peer_device->connection = connection;
+		peer_device->device = device;
+
+		list_add(&peer_device->peer_devices, &device->peer_devices);
+		kref_get(&device->kref);
+
+		id = idr_alloc(&connection->peer_devices, peer_device, vnr, vnr + 1, GFP_KERNEL);
+		if (id < 0) {
+			if (id == -ENOSPC) {
+				err = ERR_INVALID_REQUEST;
+				drbd_msg_put_info("requested volume exists already");
+			}
+			goto out_idr_remove_from_resource;
 		}
-		goto out_idr_remove_from_resource;
+		kref_get(&connection->kref);
 	}
-	kref_get(&device->kref);
 
 	if (init_submitter(device)) {
 		err = ERR_NOMEM;
@@ -2782,7 +2784,7 @@ enum drbd_ret_code drbd_create_device(struct drbd_resource *resource, unsigned i
 	add_disk(disk);
 
 	/* inherit the connection state */
-	device->state.conn = connection->cstate;
+	device->state.conn = first_connection(resource)->cstate;
 	if (device->state.conn == C_WF_REPORT_PARAMS)
 		drbd_connected(device);
 
@@ -2791,6 +2793,17 @@ enum drbd_ret_code drbd_create_device(struct drbd_resource *resource, unsigned i
 out_idr_remove_vol:
 	idr_remove(&connection->peer_devices, vnr);
 out_idr_remove_from_resource:
+	for_each_connection(connection, resource) {
+		peer_device = idr_find(&connection->peer_devices, vnr);
+		if (peer_device) {
+			idr_remove(&connection->peer_devices, vnr);
+			kref_put(&connection->kref, drbd_destroy_connection);
+		}
+	}
+	for_each_peer_device_safe(peer_device, tmp_peer_device, device) {
+		list_del(&peer_device->peer_devices);
+		kfree(peer_device);
+	}
 	idr_remove(&resource->devices, vnr);
 out_idr_remove_minor:
 	idr_remove(&drbd_devices, minor);
@@ -2804,9 +2817,7 @@ out_no_io_page:
 out_no_disk:
 	blk_cleanup_queue(q);
 out_no_q:
-	kref_put(&connection->kref, drbd_destroy_connection);
 	kref_put(&resource->kref, drbd_destroy_resource);
-out_no_peer_device:
 	kfree(device);
 	return err;
 }
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index a07b65a..26051c6 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -560,8 +560,16 @@ drbd_set_role(struct drbd_device *device, enum drbd_role new_role, int force)
 	int forced = 0;
 	union drbd_state mask, val;
 
-	if (new_role == R_PRIMARY)
-		request_ping(first_peer_device(device)->connection); /* Detect a dead peer ASAP */
+	if (new_role == R_PRIMARY) {
+		struct drbd_connection *connection;
+
+		/* Detect dead peers as soon as possible.  */
+
+		rcu_read_lock();
+		for_each_connection(connection, device->resource)
+			request_ping(connection);
+		rcu_read_unlock();
+	}
 
 	mutex_lock(device->state_mutex);
 
@@ -3387,8 +3395,10 @@ out:
 
 int drbd_adm_down(struct sk_buff *skb, struct genl_info *info)
 {
+	struct drbd_resource *resource;
+	struct drbd_connection *connection;
+	struct drbd_device *device;
 	int retcode; /* enum drbd_ret_code rsp. enum drbd_state_rv */
-	struct drbd_peer_device *peer_device;
 	unsigned i;
 
 	retcode = drbd_adm_prepare(skb, info, DRBD_ADM_NEED_RESOURCE);
@@ -3397,24 +3407,29 @@ int drbd_adm_down(struct sk_buff *skb, struct genl_info *info)
 	if (retcode != NO_ERROR)
 		goto out;
 
+	resource = adm_ctx.resource;
 	/* demote */
-	idr_for_each_entry(&adm_ctx.connection->peer_devices, peer_device, i) {
-		retcode = drbd_set_role(peer_device->device, R_SECONDARY, 0);
+	for_each_connection(connection, resource) {
+		struct drbd_peer_device *peer_device;
+
+		idr_for_each_entry(&connection->peer_devices, peer_device, i) {
+			retcode = drbd_set_role(peer_device->device, R_SECONDARY, 0);
+			if (retcode < SS_SUCCESS) {
+				drbd_msg_put_info("failed to demote");
+				goto out;
+			}
+		}
+
+		retcode = conn_try_disconnect(connection, 0);
 		if (retcode < SS_SUCCESS) {
-			drbd_msg_put_info("failed to demote");
+			drbd_msg_put_info("failed to disconnect");
 			goto out;
 		}
 	}
 
-	retcode = conn_try_disconnect(adm_ctx.connection, 0);
-	if (retcode < SS_SUCCESS) {
-		drbd_msg_put_info("failed to disconnect");
-		goto out;
-	}
-
 	/* detach */
-	idr_for_each_entry(&adm_ctx.connection->peer_devices, peer_device, i) {
-		retcode = adm_detach(peer_device->device, 0);
+	idr_for_each_entry(&resource->devices, device, i) {
+		retcode = adm_detach(device, 0);
 		if (retcode < SS_SUCCESS || retcode > NO_ERROR) {
 			drbd_msg_put_info("failed to detach");
 			goto out;
@@ -3424,13 +3439,14 @@ int drbd_adm_down(struct sk_buff *skb, struct genl_info *info)
 	/* If we reach this, all volumes (of this connection) are Secondary,
 	 * Disconnected, Diskless, aka Unconfigured. Make sure all threads have
 	 * actually stopped, state handling only does drbd_thread_stop_nowait(). */
-	drbd_thread_stop(&adm_ctx.connection->worker);
+	for_each_connection(connection, resource)
+		drbd_thread_stop(&connection->worker);
 
 	/* Now, nothing can fail anymore */
 
 	/* delete volumes */
-	idr_for_each_entry(&adm_ctx.connection->peer_devices, peer_device, i) {
-		retcode = adm_del_minor(peer_device->device);
+	idr_for_each_entry(&resource->devices, device, i) {
+		retcode = adm_del_minor(device);
 		if (retcode != NO_ERROR) {
 			/* "can not happen" */
 			drbd_msg_put_info("failed to delete volume");
@@ -3438,21 +3454,11 @@ int drbd_adm_down(struct sk_buff *skb, struct genl_info *info)
 		}
 	}
 
-	/* delete connection */
-	if (conn_lowest_minor(adm_ctx.connection) < 0) {
-		struct drbd_resource *resource = adm_ctx.connection->resource;
-
-		list_del_rcu(&resource->resources);
-		synchronize_rcu();
-		drbd_free_resource(resource);
+	list_del_rcu(&resource->resources);
+	synchronize_rcu();
+	drbd_free_resource(resource);
+	retcode = NO_ERROR;
 
-		retcode = NO_ERROR;
-	} else {
-		/* "can not happen" */
-		retcode = ERR_RES_IN_USE;
-		drbd_msg_put_info("failed to delete connection");
-	}
-	goto out;
 out:
 	drbd_adm_finish(info, retcode);
 	return 0;
-- 
1.7.9.5

