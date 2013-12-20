Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932607Ab3LTMnT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 07:43:19 -0500
Received: from mail09.linbit.com ([212.69.161.110]:38659 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756353Ab3LTMjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 07:39:33 -0500
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 10/26] drbd: Add struct drbd_resource
Date: Fri, 20 Dec 2013 13:29:07 +0100
Message-Id: <1387542563-6833-11-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387542563-6833-1-git-send-email-philipp.reisner@linbit.com>
References: <1387542563-6833-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

In a first step, each resource has exactly one connection, and both objects are
allocated at the same time.  The final result will be one resource and zero or
more connections.

Only allow to delete a resource if all its connections are C_STANDALONE.
Stop the worker threads of all connections early enough.

Signed-off-by: Andreas Gruenbacher <agruen@linbit.com>
Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
---
 drivers/block/drbd/drbd_int.h  |   45 +++++++++++++--
 drivers/block/drbd/drbd_main.c |   96 +++++++++++++++++++++++---------
 drivers/block/drbd/drbd_nl.c   |  118 +++++++++++++++++++++++-----------------
 3 files changed, 180 insertions(+), 79 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 2b9361e..7277d11 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -104,7 +104,7 @@ struct drbd_connection;
 #define DEV (disk_to_dev(device->vdisk))
 
 #define conn_printk(LEVEL, TCONN, FMT, ARGS...) \
-	printk(LEVEL "d-con %s: " FMT, TCONN->name , ## ARGS)
+	printk(LEVEL "d-con %s: " FMT, TCONN->resource->name , ## ARGS)
 #define conn_alert(TCONN, FMT, ARGS...)  conn_printk(KERN_ALERT, TCONN, FMT, ## ARGS)
 #define conn_crit(TCONN, FMT, ARGS...)   conn_printk(KERN_CRIT, TCONN, FMT, ## ARGS)
 #define conn_err(TCONN, FMT, ARGS...)    conn_printk(KERN_ERR, TCONN, FMT, ## ARGS)
@@ -166,7 +166,7 @@ drbd_insert_fault(struct drbd_device *device, unsigned int type) {
 
 extern struct ratelimit_state drbd_ratelimit_state;
 extern struct idr drbd_devices; /* RCU, updates: genl_lock() */
-extern struct list_head drbd_connections; /* RCU, updates: genl_lock() */
+extern struct list_head drbd_resources; /* RCU, updates: genl_lock() */
 
 extern const char *cmdname(enum drbd_packet cmd);
 
@@ -531,9 +531,16 @@ enum {
 	DISCONNECT_SENT,
 };
 
-struct drbd_connection {			/* is a resource from the config file */
-	char *name;			/* Resource name */
-	struct list_head connections;	/* linked on global drbd_connections */
+struct drbd_resource {
+	char *name;
+	struct kref kref;
+	struct list_head connections;
+	struct list_head resources;
+};
+
+struct drbd_connection {
+	struct list_head connections;
+	struct drbd_resource *resource;
 	struct kref kref;
 	struct idr volumes;		/* <connection, vnr> to device mapping */
 	enum drbd_conns cstate;		/* Only C_STANDALONE to C_WF_REPORT_PARAMS */
@@ -774,6 +781,24 @@ static inline struct drbd_peer_device *first_peer_device(struct drbd_device *dev
 	return list_first_entry(&device->peer_devices, struct drbd_peer_device, peer_devices);
 }
 
+#define for_each_resource(resource, _resources) \
+	list_for_each_entry(resource, _resources, resources)
+
+#define for_each_resource_rcu(resource, _resources) \
+	list_for_each_entry_rcu(resource, _resources, resources)
+
+#define for_each_resource_safe(resource, tmp, _resources) \
+	list_for_each_entry_safe(resource, tmp, _resources, resources)
+
+#define for_each_connection(connection, resource) \
+	list_for_each_entry(connection, &resource->connections, connections)
+
+#define for_each_connection_rcu(connection, resource) \
+	list_for_each_entry_rcu(connection, &resource->connections, connections)
+
+#define for_each_connection_safe(connection, tmp, resource) \
+	list_for_each_entry_safe(connection, tmp, &resource->connections, connections)
+
 #define for_each_peer_device(peer_device, device) \
 	list_for_each_entry(peer_device, &device->peer_devices, peer_devices)
 
@@ -1172,12 +1197,16 @@ extern int conn_lowest_minor(struct drbd_connection *connection);
 enum drbd_ret_code drbd_create_minor(struct drbd_connection *connection, unsigned int minor, int vnr);
 extern void drbd_destroy_device(struct kref *kref);
 
+extern struct drbd_resource *drbd_create_resource(const char *name);
+extern void drbd_free_resource(struct drbd_resource *resource);
+
 extern int set_resource_options(struct drbd_connection *connection, struct res_opts *res_opts);
 extern struct drbd_connection *conn_create(const char *name, struct res_opts *res_opts);
 extern void drbd_destroy_connection(struct kref *kref);
 struct drbd_connection *conn_get_by_name(const char *name);
 extern struct drbd_connection *conn_get_by_addrs(void *my_addr, int my_addr_len,
 					    void *peer_addr, int peer_addr_len);
+extern void drbd_destroy_resource(struct kref *kref);
 extern void conn_free_crypto(struct drbd_connection *connection);
 
 extern int proc_details;
@@ -2077,4 +2106,10 @@ static inline void drbd_md_flush(struct drbd_device *device)
 	}
 }
 
+static inline struct drbd_connection *first_connection(struct drbd_resource *resource)
+{
+	return list_first_entry(&resource->connections,
+				struct drbd_connection, connections);
+}
+
 #endif
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index cd2d25e..fa7c471 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -120,7 +120,7 @@ module_param_string(usermode_helper, usermode_helper, sizeof(usermode_helper), 0
  * as member "struct gendisk *vdisk;"
  */
 struct idr drbd_devices;
-struct list_head drbd_connections;  /* list of struct drbd_connection */
+struct list_head drbd_resources;
 
 struct kmem_cache *drbd_request_cache;
 struct kmem_cache *drbd_ee_cache;	/* peer requests */
@@ -332,7 +332,8 @@ static int drbd_thread_setup(void *arg)
 	int retval;
 
 	snprintf(current->comm, sizeof(current->comm), "drbd_%c_%s",
-		 thi->name[0], thi->connection->name);
+		 thi->name[0],
+		 thi->connection->resource->name);
 
 restart:
 	retval = thi->function(thi);
@@ -413,7 +414,7 @@ int drbd_thread_start(struct drbd_thread *thi)
 		flush_signals(current); /* otherw. may get -ERESTARTNOINTR */
 
 		nt = kthread_create(drbd_thread_setup, (void *) thi,
-				    "drbd_%c_%s", thi->name[0], thi->connection->name);
+				    "drbd_%c_%s", thi->name[0], thi->connection->resource->name);
 
 		if (IS_ERR(nt)) {
 			conn_err(connection, "Couldn't start thread\n");
@@ -2278,12 +2279,31 @@ void drbd_restart_request(struct drbd_request *req)
 	queue_work(retry.wq, &retry.worker);
 }
 
+void drbd_destroy_resource(struct kref *kref)
+{
+	struct drbd_resource *resource =
+		container_of(kref, struct drbd_resource, kref);
+
+	kfree(resource->name);
+	kfree(resource);
+}
+
+void drbd_free_resource(struct drbd_resource *resource)
+{
+	struct drbd_connection *connection, *tmp;
+
+	for_each_connection_safe(connection, tmp, resource) {
+		list_del(&connection->connections);
+		kref_put(&connection->kref, drbd_destroy_connection);
+	}
+	kref_put(&resource->kref, drbd_destroy_resource);
+}
 
 static void drbd_cleanup(void)
 {
 	unsigned int i;
 	struct drbd_device *device;
-	struct drbd_connection *connection, *tmp;
+	struct drbd_resource *resource, *tmp;
 
 	unregister_reboot_notifier(&drbd_notifier);
 
@@ -2313,10 +2333,9 @@ static void drbd_cleanup(void)
 	}
 
 	/* not _rcu since, no other updater anymore. Genl already unregistered */
-	list_for_each_entry_safe(connection, tmp, &drbd_connections, connections) {
-		list_del(&connection->connections); /* not _rcu no proc, not other threads */
-		/* synchronize_rcu(); */
-		kref_put(&connection->kref, drbd_destroy_connection);
+	for_each_resource_safe(resource, tmp, &drbd_resources) {
+		list_del(&resource->resources);
+		drbd_free_resource(resource);
 	}
 
 	drbd_destroy_mempools();
@@ -2393,13 +2412,15 @@ static void drbd_init_workqueue(struct drbd_work_queue* wq)
 struct drbd_connection *conn_get_by_name(const char *name)
 {
 	struct drbd_connection *connection;
+	struct drbd_resource *resource;
 
 	if (!name || !name[0])
 		return NULL;
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(connection, &drbd_connections, connections) {
-		if (!strcmp(connection->name, name)) {
+	for_each_resource_rcu(resource, &drbd_resources) {
+		if (!strcmp(resource->name, name)) {
+			connection = first_connection(resource);
 			kref_get(&connection->kref);
 			goto found;
 		}
@@ -2413,16 +2434,19 @@ found:
 struct drbd_connection *conn_get_by_addrs(void *my_addr, int my_addr_len,
 				     void *peer_addr, int peer_addr_len)
 {
+	struct drbd_resource *resource;
 	struct drbd_connection *connection;
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(connection, &drbd_connections, connections) {
-		if (connection->my_addr_len == my_addr_len &&
-		    connection->peer_addr_len == peer_addr_len &&
-		    !memcmp(&connection->my_addr, my_addr, my_addr_len) &&
-		    !memcmp(&connection->peer_addr, peer_addr, peer_addr_len)) {
-			kref_get(&connection->kref);
-			goto found;
+	for_each_resource_rcu(resource, &drbd_resources) {
+		for_each_connection_rcu(connection, resource) {
+			if (connection->my_addr_len == my_addr_len &&
+			    connection->peer_addr_len == peer_addr_len &&
+			    !memcmp(&connection->my_addr, my_addr, my_addr_len) &&
+			    !memcmp(&connection->peer_addr, peer_addr, peer_addr_len)) {
+				kref_get(&connection->kref);
+				goto found;
+			}
 		}
 	}
 	connection = NULL;
@@ -2508,19 +2532,34 @@ fail:
 
 }
 
+struct drbd_resource *drbd_create_resource(const char *name)
+{
+	struct drbd_resource *resource;
+
+	resource = kmalloc(sizeof(struct drbd_resource), GFP_KERNEL);
+	if (!resource)
+		return NULL;
+	resource->name = kstrdup(name, GFP_KERNEL);
+	if (!resource->name) {
+		kfree(resource);
+		return NULL;
+	}
+	kref_init(&resource->kref);
+	INIT_LIST_HEAD(&resource->connections);
+	list_add_tail_rcu(&resource->resources, &drbd_resources);
+	return resource;
+}
+
 /* caller must be under genl_lock() */
 struct drbd_connection *conn_create(const char *name, struct res_opts *res_opts)
 {
+	struct drbd_resource *resource;
 	struct drbd_connection *connection;
 
 	connection = kzalloc(sizeof(struct drbd_connection), GFP_KERNEL);
 	if (!connection)
 		return NULL;
 
-	connection->name = kstrdup(name, GFP_KERNEL);
-	if (!connection->name)
-		goto fail;
-
 	if (drbd_alloc_socket(&connection->data))
 		goto fail;
 	if (drbd_alloc_socket(&connection->meta))
@@ -2547,6 +2586,10 @@ struct drbd_connection *conn_create(const char *name, struct res_opts *res_opts)
 	connection->send.current_epoch_nr = 0;
 	connection->send.current_epoch_writes = 0;
 
+	resource = drbd_create_resource(name);
+	if (!resource)
+		goto fail;
+
 	connection->cstate = C_STANDALONE;
 	mutex_init(&connection->cstate_mutex);
 	spin_lock_init(&connection->req_lock);
@@ -2563,7 +2606,10 @@ struct drbd_connection *conn_create(const char *name, struct res_opts *res_opts)
 	drbd_thread_init(connection, &connection->asender, drbd_asender, "asender");
 
 	kref_init(&connection->kref);
-	list_add_tail_rcu(&connection->connections, &drbd_connections);
+
+	kref_get(&resource->kref);
+	connection->resource = resource;
+	list_add_tail_rcu(&connection->connections, &resource->connections);
 
 	return connection;
 
@@ -2572,7 +2618,6 @@ fail:
 	free_cpumask_var(connection->cpu_mask);
 	drbd_free_socket(&connection->meta);
 	drbd_free_socket(&connection->data);
-	kfree(connection->name);
 	kfree(connection);
 
 	return NULL;
@@ -2581,6 +2626,7 @@ fail:
 void drbd_destroy_connection(struct kref *kref)
 {
 	struct drbd_connection *connection = container_of(kref, struct drbd_connection, kref);
+	struct drbd_resource *resource = connection->resource;
 
 	if (atomic_read(&connection->current_epoch->epoch_size) !=  0)
 		conn_err(connection, "epoch_size:%d\n", atomic_read(&connection->current_epoch->epoch_size));
@@ -2591,10 +2637,10 @@ void drbd_destroy_connection(struct kref *kref)
 	free_cpumask_var(connection->cpu_mask);
 	drbd_free_socket(&connection->meta);
 	drbd_free_socket(&connection->data);
-	kfree(connection->name);
 	kfree(connection->int_dig_in);
 	kfree(connection->int_dig_vv);
 	kfree(connection);
+	kref_put(&resource->kref, drbd_destroy_resource);
 }
 
 int init_submitter(struct drbd_device *device)
@@ -2777,7 +2823,7 @@ int __init drbd_init(void)
 	idr_init(&drbd_devices);
 
 	rwlock_init(&global_state_lock);
-	INIT_LIST_HEAD(&drbd_connections);
+	INIT_LIST_HEAD(&drbd_resources);
 
 	err = drbd_genl_register();
 	if (err) {
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index e4ef018..a332399 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -249,7 +249,7 @@ static int drbd_adm_prepare(struct sk_buff *skb, struct genl_info *info,
 	    first_peer_device(adm_ctx.device)->connection != adm_ctx.connection) {
 		pr_warning("request: minor=%u, resource=%s; but that minor belongs to connection %s\n",
 				adm_ctx.minor, adm_ctx.resource_name,
-				first_peer_device(adm_ctx.device)->connection->name);
+				first_peer_device(adm_ctx.device)->connection->resource->name);
 		drbd_msg_put_info("minor exists in different resource");
 		return ERR_INVALID_REQUEST;
 	}
@@ -258,7 +258,8 @@ static int drbd_adm_prepare(struct sk_buff *skb, struct genl_info *info,
 	    adm_ctx.volume != adm_ctx.device->vnr) {
 		pr_warning("request: minor=%u, volume=%u; but that minor is volume %u in %s\n",
 				adm_ctx.minor, adm_ctx.volume,
-				adm_ctx.device->vnr, first_peer_device(adm_ctx.device)->connection->name);
+				adm_ctx.device->vnr,
+				first_peer_device(adm_ctx.device)->connection->resource->name);
 		drbd_msg_put_info("minor exists as different volume");
 		return ERR_INVALID_REQUEST;
 	}
@@ -371,23 +372,24 @@ int conn_khelper(struct drbd_connection *connection, char *cmd)
 			 (char[20]) { }, /* address family */
 			 (char[60]) { }, /* address */
 			NULL };
-	char *argv[] = {usermode_helper, cmd, connection->name, NULL };
+	char *resource_name = connection->resource->name;
+	char *argv[] = {usermode_helper, cmd, resource_name, NULL };
 	int ret;
 
 	setup_khelper_env(connection, envp);
 	conn_md_sync(connection);
 
-	conn_info(connection, "helper command: %s %s %s\n", usermode_helper, cmd, connection->name);
+	conn_info(connection, "helper command: %s %s %s\n", usermode_helper, cmd, resource_name);
 	/* TODO: conn_bcast_event() ?? */
 
 	ret = call_usermodehelper(usermode_helper, argv, envp, UMH_WAIT_PROC);
 	if (ret)
 		conn_warn(connection, "helper command: %s %s %s exit code %u (0x%x)\n",
-			  usermode_helper, cmd, connection->name,
+			  usermode_helper, cmd, resource_name,
 			  (ret >> 8) & 0xff, ret);
 	else
 		conn_info(connection, "helper command: %s %s %s exit code %u (0x%x)\n",
-			  usermode_helper, cmd, connection->name,
+			  usermode_helper, cmd, resource_name,
 			  (ret >> 8) & 0xff, ret);
 	/* TODO: conn_bcast_event() ?? */
 
@@ -2143,6 +2145,7 @@ int drbd_adm_connect(struct sk_buff *skb, struct genl_info *info)
 	struct drbd_device *device;
 	struct net_conf *old_conf, *new_conf = NULL;
 	struct crypto crypto = { };
+	struct drbd_resource *resource;
 	struct drbd_connection *connection;
 	enum drbd_ret_code retcode;
 	int i;
@@ -2163,17 +2166,21 @@ int drbd_adm_connect(struct sk_buff *skb, struct genl_info *info)
 	/* No need for _rcu here. All reconfiguration is
 	 * strictly serialized on genl_lock(). We are protected against
 	 * concurrent reconfiguration/addition/deletion */
-	list_for_each_entry(connection, &drbd_connections, connections) {
-		if (nla_len(adm_ctx.my_addr) == connection->my_addr_len &&
-		    !memcmp(nla_data(adm_ctx.my_addr), &connection->my_addr, connection->my_addr_len)) {
-			retcode = ERR_LOCAL_ADDR;
-			goto out;
-		}
+	for_each_resource(resource, &drbd_resources) {
+		for_each_connection(connection, resource) {
+			if (nla_len(adm_ctx.my_addr) == connection->my_addr_len &&
+			    !memcmp(nla_data(adm_ctx.my_addr), &connection->my_addr,
+				    connection->my_addr_len)) {
+				retcode = ERR_LOCAL_ADDR;
+				goto out;
+			}
 
-		if (nla_len(adm_ctx.peer_addr) == connection->peer_addr_len &&
-		    !memcmp(nla_data(adm_ctx.peer_addr), &connection->peer_addr, connection->peer_addr_len)) {
-			retcode = ERR_PEER_ADDR;
-			goto out;
+			if (nla_len(adm_ctx.peer_addr) == connection->peer_addr_len &&
+			    !memcmp(nla_data(adm_ctx.peer_addr), &connection->peer_addr,
+				    connection->peer_addr_len)) {
+				retcode = ERR_PEER_ADDR;
+				goto out;
+			}
 		}
 	}
 
@@ -2736,7 +2743,7 @@ int nla_put_drbd_cfg_context(struct sk_buff *skb, struct drbd_connection *connec
 	if (vnr != VOLUME_UNSPECIFIED &&
 	    nla_put_u32(skb, T_ctx_volume, vnr))
 		goto nla_put_failure;
-	if (nla_put_string(skb, T_ctx_resource_name, connection->name))
+	if (nla_put_string(skb, T_ctx_resource_name, connection->resource->name))
 		goto nla_put_failure;
 	if (connection->my_addr_len &&
 	    nla_put(skb, T_ctx_my_addr, connection->my_addr_len, &connection->my_addr))
@@ -2895,22 +2902,24 @@ out:
 	return 0;
 }
 
-int get_one_status(struct sk_buff *skb, struct netlink_callback *cb)
+static int get_one_status(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	struct drbd_device *device;
 	struct drbd_genlmsghdr *dh;
-	struct drbd_connection *pos = (struct drbd_connection *)cb->args[0];
-	struct drbd_connection *connection = NULL;
-	struct drbd_connection *tmp;
+	struct drbd_resource *pos = (struct drbd_resource *)cb->args[0];
+	struct drbd_resource *resource = NULL;
+	struct drbd_connection *connection;
+	struct drbd_resource *tmp;
 	unsigned volume = cb->args[1];
 
 	/* Open coded, deferred, iteration:
-	 * list_for_each_entry_safe(connection, tmp, &drbd_connections, connections) {
+	 * for_each_resource_safe(resource, tmp, &drbd_resources) {
+	 *      connection = "first connection of resource";
 	 *	idr_for_each_entry(&connection->volumes, device, i) {
 	 *	  ...
 	 *	}
 	 * }
-	 * where connection is cb->args[0];
+	 * where resource is cb->args[0];
 	 * and i is cb->args[1];
 	 *
 	 * cb->args[2] indicates if we shall loop over all resources,
@@ -2927,36 +2936,37 @@ int get_one_status(struct sk_buff *skb, struct netlink_callback *cb)
 	/* synchronize with conn_create()/drbd_destroy_connection() */
 	rcu_read_lock();
 	/* revalidate iterator position */
-	list_for_each_entry_rcu(tmp, &drbd_connections, connections) {
+	for_each_resource_rcu(tmp, &drbd_resources) {
 		if (pos == NULL) {
 			/* first iteration */
 			pos = tmp;
-			connection = pos;
+			resource = pos;
 			break;
 		}
 		if (tmp == pos) {
-			connection = pos;
+			resource = pos;
 			break;
 		}
 	}
-	if (connection) {
-next_connection:
+	if (resource) {
+next_resource:
+		connection = first_connection(resource);
 		device = idr_get_next(&connection->volumes, &volume);
 		if (!device) {
-			/* No more volumes to dump on this connection.
-			 * Advance connection iterator. */
-			pos = list_entry_rcu(connection->connections.next,
-					     struct drbd_connection, connections);
-			/* Did we dump any volume on this connection yet? */
+			/* No more volumes to dump on this resource.
+			 * Advance resource iterator. */
+			pos = list_entry_rcu(resource->resources.next,
+					     struct drbd_resource, resources);
+			/* Did we dump any volume of this resource yet? */
 			if (volume != 0) {
 				/* If we reached the end of the list,
 				 * or only a single resource dump was requested,
 				 * we are done. */
-				if (&pos->connections == &drbd_connections || cb->args[2])
+				if (&pos->resources == &drbd_resources || cb->args[2])
 					goto out;
 				volume = 0;
-				connection = pos;
-				goto next_connection;
+				resource = pos;
+				goto next_resource;
 			}
 		}
 
@@ -3000,9 +3010,9 @@ out:
 	rcu_read_unlock();
 	/* where to start the next iteration */
 	cb->args[0] = (long)pos;
-	cb->args[1] = (pos == connection) ? volume + 1 : 0;
+	cb->args[1] = (pos == resource) ? volume + 1 : 0;
 
-	/* No more connections/volumes/minors found results in an empty skb.
+	/* No more resources/volumes/minors found results in an empty skb.
 	 * Which will terminate the dump. */
         return skb->len;
 }
@@ -3399,9 +3409,11 @@ int drbd_adm_down(struct sk_buff *skb, struct genl_info *info)
 
 	/* delete connection */
 	if (conn_lowest_minor(adm_ctx.connection) < 0) {
-		list_del_rcu(&adm_ctx.connection->connections);
+		struct drbd_resource *resource = adm_ctx.connection->resource;
+
+		list_del_rcu(&resource->resources);
 		synchronize_rcu();
-		kref_put(&adm_ctx.connection->kref, drbd_destroy_connection);
+		drbd_free_resource(resource);
 
 		retcode = NO_ERROR;
 	} else {
@@ -3417,6 +3429,8 @@ out:
 
 int drbd_adm_del_resource(struct sk_buff *skb, struct genl_info *info)
 {
+	struct drbd_resource *resource;
+	struct drbd_connection *connection;
 	enum drbd_ret_code retcode;
 
 	retcode = drbd_adm_prepare(skb, info, DRBD_ADM_NEED_RESOURCE);
@@ -3425,18 +3439,24 @@ int drbd_adm_del_resource(struct sk_buff *skb, struct genl_info *info)
 	if (retcode != NO_ERROR)
 		goto out;
 
-	if (conn_lowest_minor(adm_ctx.connection) < 0) {
-		list_del_rcu(&adm_ctx.connection->connections);
-		synchronize_rcu();
-		kref_put(&adm_ctx.connection->kref, drbd_destroy_connection);
-
-		retcode = NO_ERROR;
-	} else {
+	resource = adm_ctx.resource;
+	for_each_connection(connection, resource) {
+		if (connection->cstate > C_STANDALONE) {
+			retcode = ERR_NET_CONFIGURED;
+			goto out;
+		}
+	}
+	if (!idr_is_empty(&resource->devices)) {
 		retcode = ERR_RES_IN_USE;
+		goto out;
 	}
 
-	if (retcode == NO_ERROR)
-		drbd_thread_stop(&adm_ctx.connection->worker);
+	list_del_rcu(&resource->resources);
+	for_each_connection(connection, resource)
+		drbd_thread_stop(&connection->worker);
+	synchronize_rcu();
+	drbd_free_resource(resource);
+	retcode = NO_ERROR;
 out:
 	drbd_adm_finish(info, retcode);
 	return 0;
-- 
1.7.9.5

