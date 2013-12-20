Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932484Ab3LTMrC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 07:47:02 -0500
Received: from mail09.linbit.com ([212.69.161.110]:38586 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932321Ab3LTMjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 07:39:23 -0500
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 24/26] drbd: get_one_status(): Iterate over resource->devices instead of connection->peer_devices
Date: Fri, 20 Dec 2013 13:29:21 +0100
Message-Id: <1387542563-6833-25-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387542563-6833-1-git-send-email-philipp.reisner@linbit.com>
References: <1387542563-6833-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Andreas Gruenbacher <agruen@linbit.com>
Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
---
 drivers/block/drbd/drbd_nl.c |   70 +++++++++++++++++++++++++++---------------
 1 file changed, 45 insertions(+), 25 deletions(-)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 12a65ce..f999e7c 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -2752,23 +2752,28 @@ int drbd_adm_outdate(struct sk_buff *skb, struct genl_info *info)
 	return drbd_adm_simple_request_state(skb, info, NS(disk, D_OUTDATED));
 }
 
-int nla_put_drbd_cfg_context(struct sk_buff *skb, struct drbd_connection *connection, unsigned vnr)
+static int nla_put_drbd_cfg_context(struct sk_buff *skb,
+				    struct drbd_resource *resource,
+				    struct drbd_connection *connection,
+				    struct drbd_device *device)
 {
 	struct nlattr *nla;
 	nla = nla_nest_start(skb, DRBD_NLA_CFG_CONTEXT);
 	if (!nla)
 		goto nla_put_failure;
-	if (vnr != VOLUME_UNSPECIFIED &&
-	    nla_put_u32(skb, T_ctx_volume, vnr))
+	if (device &&
+	    nla_put_u32(skb, T_ctx_volume, device->vnr))
 		goto nla_put_failure;
 	if (nla_put_string(skb, T_ctx_resource_name, connection->resource->name))
 		goto nla_put_failure;
-	if (connection->my_addr_len &&
-	    nla_put(skb, T_ctx_my_addr, connection->my_addr_len, &connection->my_addr))
-		goto nla_put_failure;
-	if (connection->peer_addr_len &&
-	    nla_put(skb, T_ctx_peer_addr, connection->peer_addr_len, &connection->peer_addr))
-		goto nla_put_failure;
+	if (connection) {
+		if (connection->my_addr_len &&
+		    nla_put(skb, T_ctx_my_addr, connection->my_addr_len, &connection->my_addr))
+			goto nla_put_failure;
+		if (connection->peer_addr_len &&
+		    nla_put(skb, T_ctx_peer_addr, connection->peer_addr_len, &connection->peer_addr))
+			goto nla_put_failure;
+	}
 	nla_nest_end(skb, nla);
 	return 0;
 
@@ -2778,9 +2783,22 @@ nla_put_failure:
 	return -EMSGSIZE;
 }
 
+/*
+ * Return the connection of @resource if @resource has exactly one connection.
+ */
+static struct drbd_connection *the_only_connection(struct drbd_resource *resource)
+{
+	struct list_head *connections = &resource->connections;
+
+	if (list_empty(connections) || connections->next->next != connections)
+		return NULL;
+	return list_first_entry(&resource->connections, struct drbd_connection, connections);
+}
+
 int nla_put_status_info(struct sk_buff *skb, struct drbd_device *device,
 		const struct sib_info *sib)
 {
+	struct drbd_resource *resource = device->resource;
 	struct state_info *si = NULL; /* for sizeof(si->member); */
 	struct nlattr *nla;
 	int got_ldev;
@@ -2804,7 +2822,7 @@ int nla_put_status_info(struct sk_buff *skb, struct drbd_device *device,
 
 	/* We need to add connection name and volume number information still.
 	 * Minor number is in drbd_genlmsghdr. */
-	if (nla_put_drbd_cfg_context(skb, first_peer_device(device)->connection, device->vnr))
+	if (nla_put_drbd_cfg_context(skb, resource, the_only_connection(resource), device))
 		goto nla_put_failure;
 
 	if (res_opts_to_skb(skb, &device->resource->res_opts, exclude_sensitive))
@@ -2922,19 +2940,17 @@ out:
 
 static int get_one_status(struct sk_buff *skb, struct netlink_callback *cb)
 {
-	struct drbd_peer_device *peer_device;
 	struct drbd_device *device;
 	struct drbd_genlmsghdr *dh;
 	struct drbd_resource *pos = (struct drbd_resource *)cb->args[0];
 	struct drbd_resource *resource = NULL;
-	struct drbd_connection *connection;
 	struct drbd_resource *tmp;
 	unsigned volume = cb->args[1];
 
 	/* Open coded, deferred, iteration:
 	 * for_each_resource_safe(resource, tmp, &drbd_resources) {
-	 *      connection = "first connection of resource";
-	 *	idr_for_each_entry(&connection->peer_devices, peer_device, i) {
+	 *      connection = "first connection of resource or undefined";
+	 *	idr_for_each_entry(&resource->devices, device, i) {
 	 *	  ...
 	 *	}
 	 * }
@@ -2969,9 +2985,8 @@ static int get_one_status(struct sk_buff *skb, struct netlink_callback *cb)
 	}
 	if (resource) {
 next_resource:
-		connection = first_connection(resource);
-		peer_device = idr_get_next(&connection->peer_devices, &volume);
-		if (!peer_device) {
+		device = idr_get_next(&resource->devices, &volume);
+		if (!device) {
 			/* No more volumes to dump on this resource.
 			 * Advance resource iterator. */
 			pos = list_entry_rcu(resource->resources.next,
@@ -2995,24 +3010,29 @@ next_resource:
 		if (!dh)
 			goto out;
 
-		if (!peer_device) {
+		if (!device) {
 			/* This is a connection without a single volume.
 			 * Suprisingly enough, it may have a network
 			 * configuration. */
-			struct net_conf *nc;
+			struct drbd_connection *connection;
+
 			dh->minor = -1U;
 			dh->ret_code = NO_ERROR;
-			if (nla_put_drbd_cfg_context(skb, connection, VOLUME_UNSPECIFIED))
-				goto cancel;
-			nc = rcu_dereference(connection->net_conf);
-			if (nc && net_conf_to_skb(skb, nc, 1) != 0)
+			connection = the_only_connection(resource);
+			if (nla_put_drbd_cfg_context(skb, resource, connection, NULL))
 				goto cancel;
+			if (connection) {
+				struct net_conf *nc;
+
+				nc = rcu_dereference(connection->net_conf);
+				if (nc && net_conf_to_skb(skb, nc, 1) != 0)
+					goto cancel;
+			}
 			goto done;
 		}
 
-		device = peer_device->device;
 		D_ASSERT(device, device->vnr == volume);
-		D_ASSERT(device, first_peer_device(device)->connection == connection);
+		D_ASSERT(device, device->resource == resource);
 
 		dh->minor = device_to_minor(device);
 		dh->ret_code = NO_ERROR;
-- 
1.7.9.5

