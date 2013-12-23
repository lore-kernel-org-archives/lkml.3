Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932572Ab3LWWBW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 17:01:22 -0500
Received: from zimbra13.linbit.com ([212.69.166.240]:60676 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932453Ab3LWV7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 16:59:00 -0500
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 05/27] drbd: Move susp, susp_nod, susp_fen from connection to resource
Date: Mon, 23 Dec 2013 22:50:34 +0100
Message-Id: <1387835456-29695-6-git-send-email-philipp.reisner@linbit.com>
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
 drivers/block/drbd/drbd_int.h   |   18 ++++++++++--------
 drivers/block/drbd/drbd_main.c  |    2 +-
 drivers/block/drbd/drbd_nl.c    |    3 +--
 drivers/block/drbd/drbd_state.c |   17 +++++++++--------
 4 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index bdfa1de..d0defe8 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -575,6 +575,10 @@ struct drbd_resource {
 	struct res_opts res_opts;
 	struct mutex conf_update;	/* mutex for ready-copy-update of net_conf and disk_conf */
 	spinlock_t req_lock;
+
+	unsigned susp:1;		/* IO suspended by user */
+	unsigned susp_nod:1;		/* IO suspended because no data */
+	unsigned susp_fen:1;		/* IO suspended because fence peer handler runs */
 };
 
 struct drbd_connection {
@@ -583,9 +587,6 @@ struct drbd_connection {
 	struct kref kref;
 	struct idr peer_devices;	/* volume number to peer device mapping */
 	enum drbd_conns cstate;		/* Only C_STANDALONE to C_WF_REPORT_PARAMS */
-	unsigned susp:1;		/* IO suspended by user */
-	unsigned susp_nod:1;		/* IO suspended because no data */
-	unsigned susp_fen:1;		/* IO suspended because fence peer handler runs */
 	struct mutex cstate_mutex;	/* Protects graceful disconnects */
 	unsigned int connect_cnt;	/* Inc each time a connection is established */
 
@@ -1502,12 +1503,13 @@ _drbd_set_state(struct drbd_device *device, union drbd_state ns,
 
 static inline union drbd_state drbd_read_state(struct drbd_device *device)
 {
+	struct drbd_resource *resource = device->resource;
 	union drbd_state rv;
 
 	rv.i = device->state.i;
-	rv.susp = first_peer_device(device)->connection->susp;
-	rv.susp_nod = first_peer_device(device)->connection->susp_nod;
-	rv.susp_fen = first_peer_device(device)->connection->susp_fen;
+	rv.susp = resource->susp;
+	rv.susp_nod = resource->susp_nod;
+	rv.susp_fen = resource->susp_fen;
 
 	return rv;
 }
@@ -2028,9 +2030,9 @@ static inline int drbd_state_is_stable(struct drbd_device *device)
 
 static inline int drbd_suspended(struct drbd_device *device)
 {
-	struct drbd_connection *connection = first_peer_device(device)->connection;
+	struct drbd_resource *resource = device->resource;
 
-	return connection->susp || connection->susp_fen || connection->susp_nod;
+	return resource->susp || resource->susp_fen || resource->susp_nod;
 }
 
 static inline bool may_inc_ap_bio(struct drbd_device *device)
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 43b9141..824bc7a 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2536,7 +2536,7 @@ struct drbd_resource *drbd_create_resource(const char *name)
 {
 	struct drbd_resource *resource;
 
-	resource = kmalloc(sizeof(struct drbd_resource), GFP_KERNEL);
+	resource = kzalloc(sizeof(struct drbd_resource), GFP_KERNEL);
 	if (!resource)
 		return NULL;
 	resource->name = kstrdup(name, GFP_KERNEL);
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 5ccfebb..a84f1e2 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1665,8 +1665,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 		clear_bit(CRASHED_PRIMARY, &device->flags);
 
 	if (drbd_md_test_flag(device->ldev, MDF_PRIMARY_IND) &&
-	    !(device->state.role == R_PRIMARY &&
-	      first_peer_device(device)->connection->susp_nod))
+	    !(device->state.role == R_PRIMARY && device->resource->susp_nod))
 		set_bit(CRASHED_PRIMARY, &device->flags);
 
 	device->send_cnt = 0;
diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index 0e69bb1..56b4aee 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -1011,9 +1011,9 @@ __drbd_set_state(struct drbd_device *device, union drbd_state ns,
 	did_remote = drbd_should_do_remote(device->state);
 	device->state.i = ns.i;
 	should_do_remote = drbd_should_do_remote(device->state);
-	first_peer_device(device)->connection->susp = ns.susp;
-	first_peer_device(device)->connection->susp_nod = ns.susp_nod;
-	first_peer_device(device)->connection->susp_fen = ns.susp_fen;
+	device->resource->susp = ns.susp;
+	device->resource->susp_nod = ns.susp_nod;
+	device->resource->susp_fen = ns.susp_fen;
 
 	/* put replicated vs not-replicated requests in seperate epochs */
 	if (did_remote != should_do_remote)
@@ -1222,6 +1222,7 @@ int drbd_bitmap_io_from_worker(struct drbd_device *device,
 static void after_state_ch(struct drbd_device *device, union drbd_state os,
 			   union drbd_state ns, enum chg_state_flags flags)
 {
+	struct drbd_resource *resource = device->resource;
 	struct sib_info sib;
 
 	sib.sib_reason = SIB_STATE_CHANGE;
@@ -1256,7 +1257,7 @@ static void after_state_ch(struct drbd_device *device, union drbd_state os,
 		    conn_lowest_disk(connection) > D_NEGOTIATING)
 			what = RESTART_FROZEN_DISK_IO;
 
-		if (connection->susp_nod && what != NOTHING) {
+		if (resource->susp_nod && what != NOTHING) {
 			_tl_restart(connection, what);
 			_conn_request_state(connection,
 					    (union drbd_state) { { .susp_nod = 1 } },
@@ -1270,7 +1271,7 @@ static void after_state_ch(struct drbd_device *device, union drbd_state os,
 		struct drbd_connection *connection = first_peer_device(device)->connection;
 
 		spin_lock_irq(&device->resource->req_lock);
-		if (connection->susp_fen && conn_lowest_conn(connection) >= C_CONNECTED) {
+		if (resource->susp_fen && conn_lowest_conn(connection) >= C_CONNECTED) {
 			/* case2: The connection was established again: */
 			struct drbd_peer_device *peer_device;
 			int vnr;
@@ -1753,9 +1754,9 @@ conn_set_state(struct drbd_connection *connection, union drbd_state mask, union
 			} };
 	}
 
-	ns_min.susp = ns_max.susp = connection->susp;
-	ns_min.susp_nod = ns_max.susp_nod = connection->susp_nod;
-	ns_min.susp_fen = ns_max.susp_fen = connection->susp_fen;
+	ns_min.susp = ns_max.susp = connection->resource->susp;
+	ns_min.susp_nod = ns_max.susp_nod = connection->resource->susp_nod;
+	ns_min.susp_fen = ns_max.susp_fen = connection->resource->susp_fen;
 
 	*pns_min = ns_min;
 	*pns_max = ns_max;
-- 
1.7.9.5

