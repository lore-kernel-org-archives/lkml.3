Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422636Ab3LTMrE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 07:47:04 -0500
Received: from mail09.linbit.com ([212.69.161.110]:38585 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932320Ab3LTMjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 07:39:23 -0500
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 17/26] drbd: Move resource options from connection to resource
Date: Fri, 20 Dec 2013 13:29:14 +0100
Message-Id: <1387542563-6833-18-git-send-email-philipp.reisner@linbit.com>
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
 drivers/block/drbd/drbd_int.h   |    4 ++--
 drivers/block/drbd/drbd_main.c  |   33 +++++++++++++++++++--------------
 drivers/block/drbd/drbd_nl.c    |    8 +++-----
 drivers/block/drbd/drbd_state.c |    2 +-
 4 files changed, 25 insertions(+), 22 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 1a1dd41..e1d6c53 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -537,6 +537,7 @@ struct drbd_resource {
 	struct idr devices;		/* volume number to device mapping */
 	struct list_head connections;
 	struct list_head resources;
+	struct res_opts res_opts;
 };
 
 struct drbd_connection {
@@ -555,7 +556,6 @@ struct drbd_connection {
 	struct net_conf *net_conf;	/* content protected by rcu */
 	struct mutex conf_update;	/* mutex for ready-copy-update of net_conf and disk_conf */
 	wait_queue_head_t ping_wait;	/* Woken upon reception of a ping, and a state change */
-	struct res_opts res_opts;
 
 	struct sockaddr_storage my_addr;
 	int my_addr_len;
@@ -1203,7 +1203,7 @@ extern void drbd_delete_minor(struct drbd_device *mdev);
 extern struct drbd_resource *drbd_create_resource(const char *name);
 extern void drbd_free_resource(struct drbd_resource *resource);
 
-extern int set_resource_options(struct drbd_connection *connection, struct res_opts *res_opts);
+extern int set_resource_options(struct drbd_resource *resource, struct res_opts *res_opts);
 extern struct drbd_connection *conn_create(const char *name, struct res_opts *res_opts);
 extern void drbd_destroy_connection(struct kref *kref);
 extern struct drbd_connection *conn_get_by_addrs(void *my_addr, int my_addr_len,
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index dd9fe7a..1792bc2 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2489,8 +2489,9 @@ void conn_free_crypto(struct drbd_connection *connection)
 	connection->int_dig_vv = NULL;
 }
 
-int set_resource_options(struct drbd_connection *connection, struct res_opts *res_opts)
+int set_resource_options(struct drbd_resource *resource, struct res_opts *res_opts)
 {
+	struct drbd_connection *connection;
 	cpumask_var_t new_cpu_mask;
 	int err;
 
@@ -2512,13 +2513,15 @@ int set_resource_options(struct drbd_connection *connection, struct res_opts *re
 			goto fail;
 		}
 	}
-	connection->res_opts = *res_opts;
-	if (!cpumask_equal(connection->cpu_mask, new_cpu_mask)) {
-		cpumask_copy(connection->cpu_mask, new_cpu_mask);
-		drbd_calc_cpu_mask(connection);
-		connection->receiver.reset_cpu_mask = 1;
-		connection->asender.reset_cpu_mask = 1;
-		connection->worker.reset_cpu_mask = 1;
+	resource->res_opts = *res_opts;
+	for_each_connection_rcu(connection, resource) {
+		if (!cpumask_equal(connection->cpu_mask, new_cpu_mask)) {
+			cpumask_copy(connection->cpu_mask, new_cpu_mask);
+			drbd_calc_cpu_mask(connection);
+			connection->receiver.reset_cpu_mask = 1;
+			connection->asender.reset_cpu_mask = 1;
+			connection->worker.reset_cpu_mask = 1;
+		}
 	}
 	err = 0;
 
@@ -2565,9 +2568,6 @@ struct drbd_connection *conn_create(const char *name, struct res_opts *res_opts)
 	if (!zalloc_cpumask_var(&connection->cpu_mask, GFP_KERNEL))
 		goto fail;
 
-	if (set_resource_options(connection, res_opts))
-		goto fail;
-
 	connection->current_epoch = kzalloc(sizeof(struct drbd_epoch), GFP_KERNEL);
 	if (!connection->current_epoch)
 		goto fail;
@@ -2604,19 +2604,24 @@ struct drbd_connection *conn_create(const char *name, struct res_opts *res_opts)
 
 	kref_init(&connection->kref);
 
-	kref_get(&resource->kref);
 	connection->resource = resource;
-	list_add_tail_rcu(&connection->connections, &resource->connections);
 
+	if (set_resource_options(resource, res_opts))
+		goto fail_resource;
+
+	kref_get(&resource->kref);
+	list_add_tail_rcu(&connection->connections, &resource->connections);
 	return connection;
 
+fail_resource:
+	list_del(&resource->resources);
+	drbd_free_resource(resource);
 fail:
 	kfree(connection->current_epoch);
 	free_cpumask_var(connection->cpu_mask);
 	drbd_free_socket(&connection->meta);
 	drbd_free_socket(&connection->data);
 	kfree(connection);
-
 	return NULL;
 }
 
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index e804487..2153afd 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -2520,7 +2520,6 @@ int drbd_adm_resize(struct sk_buff *skb, struct genl_info *info)
 int drbd_adm_resource_opts(struct sk_buff *skb, struct genl_info *info)
 {
 	enum drbd_ret_code retcode;
-	struct drbd_connection *connection;
 	struct res_opts res_opts;
 	int err;
 
@@ -2529,9 +2528,8 @@ int drbd_adm_resource_opts(struct sk_buff *skb, struct genl_info *info)
 		return retcode;
 	if (retcode != NO_ERROR)
 		goto fail;
-	connection = adm_ctx.connection;
 
-	res_opts = connection->res_opts;
+	res_opts = adm_ctx.resource->res_opts;
 	if (should_set_defaults(info))
 		set_res_opts_defaults(&res_opts);
 
@@ -2542,7 +2540,7 @@ int drbd_adm_resource_opts(struct sk_buff *skb, struct genl_info *info)
 		goto fail;
 	}
 
-	err = set_resource_options(connection, &res_opts);
+	err = set_resource_options(adm_ctx.resource, &res_opts);
 	if (err) {
 		retcode = ERR_INVALID_REQUEST;
 		if (err == -ENOMEM)
@@ -2802,7 +2800,7 @@ int nla_put_status_info(struct sk_buff *skb, struct drbd_device *device,
 	if (nla_put_drbd_cfg_context(skb, first_peer_device(device)->connection, device->vnr))
 		goto nla_put_failure;
 
-	if (res_opts_to_skb(skb, &first_peer_device(device)->connection->res_opts, exclude_sensitive))
+	if (res_opts_to_skb(skb, &device->resource->res_opts, exclude_sensitive))
 		goto nla_put_failure;
 
 	rcu_read_lock();
diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index cf6b475..516992d 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -874,7 +874,7 @@ static union drbd_state sanitize_state(struct drbd_device *device, union drbd_st
 	    (ns.role == R_PRIMARY && ns.conn < C_CONNECTED && ns.pdsk > D_OUTDATED))
 		ns.susp_fen = 1; /* Suspend IO while fence-peer handler runs (peer lost) */
 
-	if (first_peer_device(device)->connection->res_opts.on_no_data == OND_SUSPEND_IO &&
+	if (device->resource->res_opts.on_no_data == OND_SUSPEND_IO &&
 	    (ns.role == R_PRIMARY && ns.disk < D_UP_TO_DATE && ns.pdsk < D_UP_TO_DATE))
 		ns.susp_nod = 1; /* Suspend IO while no data available (no accessible data available) */
 
-- 
1.7.9.5

