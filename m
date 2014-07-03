Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436AbaGCItY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 04:49:24 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:45933 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756280AbaGCInZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 04:43:25 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 11/23] drbd: debugfs: add basic hierarchy
Date: Thu,  3 Jul 2014 10:43:03 +0200
Message-Id: <1404376995-4877-12-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404376995-4877-1-git-send-email-philipp.reisner@linbit.com>
References: <1404376995-4877-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

Add new debugfs hierarchy /sys/kernel/debug/
  drbd/
    resources/
      $resource_name/connections/peer/$volume_number/
      $resource_name/volumes/$volume_number/
    minors/$minor_number -> ../resources/$resource_name/volumes/$volume_number/

Followup commits will populate this hierarchy with files containing
statistics, diagnostic information and some attribute data.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/Makefile       |   1 +
 drivers/block/drbd/drbd_debugfs.c | 191 ++++++++++++++++++++++++++++++++++++++
 drivers/block/drbd/drbd_debugfs.h |  39 ++++++++
 drivers/block/drbd/drbd_int.h     |  30 +++++-
 drivers/block/drbd/drbd_main.c    |  22 ++++-
 5 files changed, 278 insertions(+), 5 deletions(-)
 create mode 100644 drivers/block/drbd/drbd_debugfs.c
 create mode 100644 drivers/block/drbd/drbd_debugfs.h

diff --git a/drivers/block/drbd/Makefile b/drivers/block/drbd/Makefile
index 8b45033..4464e35 100644
--- a/drivers/block/drbd/Makefile
+++ b/drivers/block/drbd/Makefile
@@ -3,5 +3,6 @@ drbd-y += drbd_worker.o drbd_receiver.o drbd_req.o drbd_actlog.o
 drbd-y += drbd_main.o drbd_strings.o drbd_nl.o
 drbd-y += drbd_interval.o drbd_state.o
 drbd-y += drbd_nla.o
+drbd-$(CONFIG_DEBUG_FS) += drbd_debugfs.o
 
 obj-$(CONFIG_BLK_DEV_DRBD)     += drbd.o
diff --git a/drivers/block/drbd/drbd_debugfs.c b/drivers/block/drbd/drbd_debugfs.c
new file mode 100644
index 0000000..9b120c3
--- /dev/null
+++ b/drivers/block/drbd/drbd_debugfs.c
@@ -0,0 +1,191 @@
+#define pr_fmt(fmt) "drbd debugfs: " fmt
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/debugfs.h>
+#include <linux/stat.h>
+#include <linux/list.h>
+
+#include "drbd_int.h"
+#include "drbd_req.h"
+#include "drbd_debugfs.h"
+
+static struct dentry *drbd_debugfs_root;
+static struct dentry *drbd_debugfs_resources;
+static struct dentry *drbd_debugfs_minors;
+
+void drbd_debugfs_resource_add(struct drbd_resource *resource)
+{
+	struct dentry *dentry;
+	if (!drbd_debugfs_resources)
+		return;
+
+	dentry = debugfs_create_dir(resource->name, drbd_debugfs_resources);
+	if (IS_ERR_OR_NULL(dentry))
+		goto fail;
+	resource->debugfs_res = dentry;
+
+	dentry = debugfs_create_dir("volumes", resource->debugfs_res);
+	if (IS_ERR_OR_NULL(dentry))
+		goto fail;
+	resource->debugfs_res_volumes = dentry;
+
+	dentry = debugfs_create_dir("connections", resource->debugfs_res);
+	if (IS_ERR_OR_NULL(dentry))
+		goto fail;
+	resource->debugfs_res_connections = dentry;
+
+	return;
+
+fail:
+	drbd_debugfs_resource_cleanup(resource);
+	drbd_err(resource, "failed to create debugfs dentry\n");
+}
+
+static void drbd_debugfs_remove(struct dentry **dp)
+{
+	debugfs_remove(*dp);
+	*dp = NULL;
+}
+
+void drbd_debugfs_resource_cleanup(struct drbd_resource *resource)
+{
+	/* it is ok to call debugfs_remove(NULL) */
+	drbd_debugfs_remove(&resource->debugfs_res_in_flight_summary);
+	drbd_debugfs_remove(&resource->debugfs_res_connections);
+	drbd_debugfs_remove(&resource->debugfs_res_volumes);
+	drbd_debugfs_remove(&resource->debugfs_res);
+}
+
+void drbd_debugfs_connection_add(struct drbd_connection *connection)
+{
+	struct dentry *conns_dir = connection->resource->debugfs_res_connections;
+	struct dentry *dentry;
+	if (!conns_dir)
+		return;
+
+	/* Once we enable mutliple peers,
+	 * these connections will have descriptive names.
+	 * For now, it is just the one connection to the (only) "peer". */
+	dentry = debugfs_create_dir("peer", conns_dir);
+	if (IS_ERR_OR_NULL(dentry))
+		goto fail;
+	connection->debugfs_conn = dentry;
+	return;
+
+fail:
+	drbd_debugfs_connection_cleanup(connection);
+	drbd_err(connection, "failed to create debugfs dentry\n");
+}
+
+void drbd_debugfs_connection_cleanup(struct drbd_connection *connection)
+{
+	drbd_debugfs_remove(&connection->debugfs_conn_callback_history);
+	drbd_debugfs_remove(&connection->debugfs_conn_oldest_requests);
+	drbd_debugfs_remove(&connection->debugfs_conn);
+}
+
+void drbd_debugfs_device_add(struct drbd_device *device)
+{
+	struct dentry *vols_dir = device->resource->debugfs_res_volumes;
+	char minor_buf[8]; /* MINORMASK, MINORBITS == 20; */
+	char vnr_buf[8];   /* volume number vnr is even 16 bit only; */
+	char *slink_name = NULL;
+
+	struct dentry *dentry;
+	if (!vols_dir || !drbd_debugfs_minors)
+		return;
+
+	snprintf(vnr_buf, sizeof(vnr_buf), "%u", device->vnr);
+	dentry = debugfs_create_dir(vnr_buf, vols_dir);
+	if (IS_ERR_OR_NULL(dentry))
+		goto fail;
+	device->debugfs_vol = dentry;
+
+	snprintf(minor_buf, sizeof(minor_buf), "%u", device->minor);
+	slink_name = kasprintf(GFP_KERNEL, "../resources/%s/volumes/%u",
+			device->resource->name, device->vnr);
+	if (!slink_name)
+		goto fail;
+	dentry = debugfs_create_symlink(minor_buf, drbd_debugfs_minors, slink_name);
+	if (IS_ERR_OR_NULL(dentry))
+		goto fail;
+	device->debugfs_minor = dentry;
+	kfree(slink_name);
+
+fail:
+	drbd_debugfs_device_cleanup(device);
+	drbd_err(device, "failed to create debugfs entries\n");
+}
+
+void drbd_debugfs_device_cleanup(struct drbd_device *device)
+{
+	drbd_debugfs_remove(&device->debugfs_minor);
+	drbd_debugfs_remove(&device->debugfs_vol_oldest_requests);
+	drbd_debugfs_remove(&device->debugfs_vol_act_log_extents);
+	drbd_debugfs_remove(&device->debugfs_vol_resync_extents);
+	drbd_debugfs_remove(&device->debugfs_vol_data_gen_id);
+	drbd_debugfs_remove(&device->debugfs_vol);
+}
+
+void drbd_debugfs_peer_device_add(struct drbd_peer_device *peer_device)
+{
+	struct dentry *conn_dir = peer_device->connection->debugfs_conn;
+	struct dentry *dentry;
+	char vnr_buf[8];
+
+	if (!conn_dir)
+		return;
+
+	snprintf(vnr_buf, sizeof(vnr_buf), "%u", peer_device->device->vnr);
+	dentry = debugfs_create_dir(vnr_buf, conn_dir);
+	if (IS_ERR_OR_NULL(dentry))
+		goto fail;
+	peer_device->debugfs_peer_dev = dentry;
+	return;
+
+fail:
+	drbd_debugfs_peer_device_cleanup(peer_device);
+	drbd_err(peer_device, "failed to create debugfs entries\n");
+}
+
+void drbd_debugfs_peer_device_cleanup(struct drbd_peer_device *peer_device)
+{
+	drbd_debugfs_remove(&peer_device->debugfs_peer_dev);
+}
+
+/* not __exit, may be indirectly called
+ * from the module-load-failure path as well. */
+void drbd_debugfs_cleanup(void)
+{
+	drbd_debugfs_remove(&drbd_debugfs_resources);
+	drbd_debugfs_remove(&drbd_debugfs_minors);
+	drbd_debugfs_remove(&drbd_debugfs_root);
+}
+
+int __init drbd_debugfs_init(void)
+{
+	struct dentry *dentry;
+
+	dentry = debugfs_create_dir("drbd", NULL);
+	if (IS_ERR_OR_NULL(dentry))
+		goto fail;
+	drbd_debugfs_root = dentry;
+
+	dentry = debugfs_create_dir("resources", drbd_debugfs_root);
+	if (IS_ERR_OR_NULL(dentry))
+		goto fail;
+	drbd_debugfs_resources = dentry;
+
+	dentry = debugfs_create_dir("minors", drbd_debugfs_root);
+	if (IS_ERR_OR_NULL(dentry))
+		goto fail;
+	drbd_debugfs_minors = dentry;
+	return 0;
+
+fail:
+	drbd_debugfs_cleanup();
+	if (dentry)
+		return PTR_ERR(dentry);
+	else
+		return -EINVAL;
+}
diff --git a/drivers/block/drbd/drbd_debugfs.h b/drivers/block/drbd/drbd_debugfs.h
new file mode 100644
index 0000000..8bee213
--- /dev/null
+++ b/drivers/block/drbd/drbd_debugfs.h
@@ -0,0 +1,39 @@
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/debugfs.h>
+
+#include "drbd_int.h"
+
+#ifdef CONFIG_DEBUG_FS
+int __init drbd_debugfs_init(void);
+void drbd_debugfs_cleanup(void);
+
+void drbd_debugfs_resource_add(struct drbd_resource *resource);
+void drbd_debugfs_resource_cleanup(struct drbd_resource *resource);
+
+void drbd_debugfs_connection_add(struct drbd_connection *connection);
+void drbd_debugfs_connection_cleanup(struct drbd_connection *connection);
+
+void drbd_debugfs_device_add(struct drbd_device *device);
+void drbd_debugfs_device_cleanup(struct drbd_device *device);
+
+void drbd_debugfs_peer_device_add(struct drbd_peer_device *peer_device);
+void drbd_debugfs_peer_device_cleanup(struct drbd_peer_device *peer_device);
+#else
+
+static inline int __init drbd_debugfs_init(void) { return -ENODEV; }
+static inline void drbd_debugfs_cleanup(void) { }
+
+static inline void drbd_debugfs_resource_add(struct drbd_resource *resource) { }
+static inline void drbd_debugfs_resource_cleanup(struct drbd_resource *resource) { }
+
+static inline void drbd_debugfs_connection_add(struct drbd_connection *connection) { }
+static inline void drbd_debugfs_connection_cleanup(struct drbd_connection *connection) { }
+
+static inline void drbd_debugfs_device_add(struct drbd_device *device) { }
+static inline void drbd_debugfs_device_cleanup(struct drbd_device *device) { }
+
+static inline void drbd_debugfs_peer_device_add(struct drbd_peer_device *peer_device) { }
+static inline void drbd_debugfs_peer_device_cleanup(struct drbd_peer_device *peer_device) { }
+
+#endif
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 40c816c..20f2b38 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -670,6 +670,12 @@ enum {
 
 struct drbd_resource {
 	char *name;
+#ifdef CONFIG_DEBUG_FS
+	struct dentry *debugfs_res;
+	struct dentry *debugfs_res_volumes;
+	struct dentry *debugfs_res_connections;
+	struct dentry *debugfs_res_in_flight_summary;
+#endif
 	struct kref kref;
 	struct idr devices;		/* volume number to device mapping */
 	struct list_head connections;
@@ -691,6 +697,11 @@ struct drbd_resource {
 struct drbd_connection {
 	struct list_head connections;
 	struct drbd_resource *resource;
+#ifdef CONFIG_DEBUG_FS
+	struct dentry *debugfs_conn;
+	struct dentry *debugfs_conn_callback_history;
+	struct dentry *debugfs_conn_oldest_requests;
+#endif
 	struct kref kref;
 	struct idr peer_devices;	/* volume number to peer device mapping */
 	enum drbd_conns cstate;		/* Only C_STANDALONE to C_WF_REPORT_PARAMS */
@@ -772,13 +783,29 @@ struct drbd_peer_device {
 	struct list_head peer_devices;
 	struct drbd_device *device;
 	struct drbd_connection *connection;
+#ifdef CONFIG_DEBUG_FS
+	struct dentry *debugfs_peer_dev;
+#endif
 };
 
 struct drbd_device {
 	struct drbd_resource *resource;
 	struct list_head peer_devices;
 	struct list_head pending_bitmap_io;
-	int vnr;			/* volume number within the connection */
+
+	unsigned long flush_jif;
+#ifdef CONFIG_DEBUG_FS
+	struct dentry *debugfs_minor;
+	struct dentry *debugfs_vol;
+	struct dentry *debugfs_vol_oldest_requests;
+	struct dentry *debugfs_vol_act_log_extents;
+	struct dentry *debugfs_vol_resync_extents;
+	struct dentry *debugfs_vol_data_gen_id;
+#endif
+
+	unsigned int vnr;	/* volume number within the connection */
+	unsigned int minor;	/* device minor number */
+
 	struct kref kref;
 
 	/* things that are stored as / read from meta data on disk */
@@ -895,7 +922,6 @@ struct drbd_device {
 	atomic_t packet_seq;
 	unsigned int peer_seq;
 	spinlock_t peer_seq_lock;
-	unsigned int minor;
 	unsigned long comm_bm_set; /* communicated number of set bits. */
 	struct bm_io_work bm_io_work;
 	u64 ed_uuid; /* UUID of the exposed data */
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 922d631..01de57e 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -57,8 +57,8 @@
 #include "drbd_int.h"
 #include "drbd_protocol.h"
 #include "drbd_req.h" /* only for _req_mod in tl_release and tl_clear */
-
 #include "drbd_vli.h"
+#include "drbd_debugfs.h"
 
 static DEFINE_MUTEX(drbd_main_mutex);
 static int drbd_open(struct block_device *bdev, fmode_t mode);
@@ -2308,8 +2308,10 @@ void drbd_free_resource(struct drbd_resource *resource)
 
 	for_each_connection_safe(connection, tmp, resource) {
 		list_del(&connection->connections);
+		drbd_debugfs_connection_cleanup(connection);
 		kref_put(&connection->kref, drbd_destroy_connection);
 	}
+	drbd_debugfs_resource_cleanup(resource);
 	kref_put(&resource->kref, drbd_destroy_resource);
 }
 
@@ -2334,6 +2336,7 @@ static void drbd_cleanup(void)
 		destroy_workqueue(retry.wq);
 
 	drbd_genl_unregister();
+	drbd_debugfs_cleanup();
 
 	idr_for_each_entry(&drbd_devices, device, i)
 		drbd_delete_device(device);
@@ -2583,6 +2586,7 @@ struct drbd_resource *drbd_create_resource(const char *name)
 	mutex_init(&resource->conf_update);
 	mutex_init(&resource->adm_mutex);
 	spin_lock_init(&resource->req_lock);
+	drbd_debugfs_resource_add(resource);
 	return resource;
 
 fail_free_name:
@@ -2593,7 +2597,7 @@ fail:
 	return NULL;
 }
 
-/* caller must be under genl_lock() */
+/* caller must be under adm_mutex */
 struct drbd_connection *conn_create(const char *name, struct res_opts *res_opts)
 {
 	struct drbd_resource *resource;
@@ -2651,6 +2655,7 @@ struct drbd_connection *conn_create(const char *name, struct res_opts *res_opts)
 
 	kref_get(&resource->kref);
 	list_add_tail_rcu(&connection->connections, &resource->connections);
+	drbd_debugfs_connection_add(connection);
 	return connection;
 
 fail_resource:
@@ -2829,7 +2834,10 @@ enum drbd_ret_code drbd_create_device(struct drbd_config_context *adm_ctx, unsig
 		for_each_peer_device(peer_device, device)
 			drbd_connected(peer_device);
 	}
-
+	/* move to create_peer_device() */
+	for_each_peer_device(peer_device, device)
+		drbd_debugfs_peer_device_add(peer_device);
+	drbd_debugfs_device_add(device);
 	return NO_ERROR;
 
 out_idr_remove_vol:
@@ -2868,8 +2876,13 @@ void drbd_delete_device(struct drbd_device *device)
 {
 	struct drbd_resource *resource = device->resource;
 	struct drbd_connection *connection;
+	struct drbd_peer_device *peer_device;
 	int refs = 3;
 
+	/* move to free_peer_device() */
+	for_each_peer_device(peer_device, device)
+		drbd_debugfs_peer_device_cleanup(peer_device);
+	drbd_debugfs_device_cleanup(device);
 	for_each_connection(connection, resource) {
 		idr_remove(&connection->peer_devices, device->vnr);
 		refs++;
@@ -2938,6 +2951,9 @@ static int __init drbd_init(void)
 	spin_lock_init(&retry.lock);
 	INIT_LIST_HEAD(&retry.writes);
 
+	if (drbd_debugfs_init())
+		pr_notice("failed to initialize debugfs -- will not be available\n");
+
 	pr_info("initialized. "
 	       "Version: " REL_VERSION " (api:%d/proto:%d-%d)\n",
 	       API_VERSION, PRO_VERSION_MIN, PRO_VERSION_MAX);
-- 
1.9.1

