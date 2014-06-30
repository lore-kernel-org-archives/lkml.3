Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307AbaF3QBh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 12:01:37 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:50030 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754032AbaF3PxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 11:53:12 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 05/18] drbd: refactor use of first_peer_device()
Date: Mon, 30 Jun 2014 17:52:54 +0200
Message-Id: <1404143587-24344-6-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404143587-24344-1-git-send-email-philipp.reisner@linbit.com>
References: <1404143587-24344-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

Reduce the number of calls to first_peer_device(). Instead, call
first_peer_device() just once to assign a local variable peer_device.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_nl.c       | 30 +++++++++++-------
 drivers/block/drbd/drbd_receiver.c | 18 ++++++-----
 drivers/block/drbd/drbd_req.c      | 25 ++++++++-------
 drivers/block/drbd/drbd_state.c    | 65 +++++++++++++++++++-------------------
 drivers/block/drbd/drbd_worker.c   | 55 +++++++++++++++++---------------
 5 files changed, 105 insertions(+), 88 deletions(-)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 25f4b6f..0bf8a60 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -552,8 +552,10 @@ void conn_try_outdate_peer_async(struct drbd_connection *connection)
 }
 
 enum drbd_state_rv
-drbd_set_role(struct drbd_device *device, enum drbd_role new_role, int force)
+drbd_set_role(struct drbd_device *const device, enum drbd_role new_role, int force)
 {
+	struct drbd_peer_device *const peer_device = first_peer_device(device);
+	struct drbd_connection *const connection = peer_device ? peer_device->connection : NULL;
 	const int max_tries = 4;
 	enum drbd_state_rv rv = SS_UNKNOWN_ERROR;
 	struct net_conf *nc;
@@ -601,7 +603,7 @@ drbd_set_role(struct drbd_device *device, enum drbd_role new_role, int force)
 		    device->state.disk == D_CONSISTENT && mask.pdsk == 0) {
 			D_ASSERT(device, device->state.pdsk == D_UNKNOWN);
 
-			if (conn_try_outdate_peer(first_peer_device(device)->connection)) {
+			if (conn_try_outdate_peer(connection)) {
 				val.disk = D_UP_TO_DATE;
 				mask.disk = D_MASK;
 			}
@@ -611,7 +613,7 @@ drbd_set_role(struct drbd_device *device, enum drbd_role new_role, int force)
 		if (rv == SS_NOTHING_TO_DO)
 			goto out;
 		if (rv == SS_PRIMARY_NOP && mask.pdsk == 0) {
-			if (!conn_try_outdate_peer(first_peer_device(device)->connection) && force) {
+			if (!conn_try_outdate_peer(connection) && force) {
 				drbd_warn(device, "Forced into split brain situation!\n");
 				mask.pdsk = D_MASK;
 				val.pdsk  = D_OUTDATED;
@@ -624,7 +626,7 @@ drbd_set_role(struct drbd_device *device, enum drbd_role new_role, int force)
 			   retry at most once more in this case. */
 			int timeo;
 			rcu_read_lock();
-			nc = rcu_dereference(first_peer_device(device)->connection->net_conf);
+			nc = rcu_dereference(connection->net_conf);
 			timeo = nc ? (nc->ping_timeo + 1) * HZ / 10 : 1;
 			rcu_read_unlock();
 			schedule_timeout_interruptible(timeo);
@@ -661,7 +663,7 @@ drbd_set_role(struct drbd_device *device, enum drbd_role new_role, int force)
 	} else {
 		/* Called from drbd_adm_set_role only.
 		 * We are still holding the conf_update mutex. */
-		nc = first_peer_device(device)->connection->net_conf;
+		nc = connection->net_conf;
 		if (nc)
 			nc->discard_my_data = 0; /* without copy; single bit op is atomic */
 
@@ -683,8 +685,8 @@ drbd_set_role(struct drbd_device *device, enum drbd_role new_role, int force)
 	if (device->state.conn >= C_WF_REPORT_PARAMS) {
 		/* if this was forced, we should consider sync */
 		if (forced)
-			drbd_send_uuids(first_peer_device(device));
-		drbd_send_current_state(first_peer_device(device));
+			drbd_send_uuids(peer_device);
+		drbd_send_current_state(peer_device);
 	}
 
 	drbd_md_sync(device);
@@ -1433,6 +1435,8 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 {
 	struct drbd_config_context adm_ctx;
 	struct drbd_device *device;
+	struct drbd_peer_device *peer_device;
+	struct drbd_connection *connection;
 	int err;
 	enum drbd_ret_code retcode;
 	enum determine_dev_size dd;
@@ -1455,7 +1459,9 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 
 	device = adm_ctx.device;
 	mutex_lock(&adm_ctx.resource->adm_mutex);
-	conn_reconfig_start(first_peer_device(device)->connection);
+	peer_device = first_peer_device(device);
+	connection = peer_device ? peer_device->connection : NULL;
+	conn_reconfig_start(connection);
 
 	/* if you want to reconfigure, please tear down first */
 	if (device->state.disk > D_DISKLESS) {
@@ -1522,7 +1528,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 		goto fail;
 
 	rcu_read_lock();
-	nc = rcu_dereference(first_peer_device(device)->connection->net_conf);
+	nc = rcu_dereference(connection->net_conf);
 	if (nc) {
 		if (new_disk_conf->fencing == FP_STONITH && nc->wire_protocol == DRBD_PROT_A) {
 			rcu_read_unlock();
@@ -1642,7 +1648,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 	 */
 	wait_event(device->misc_wait, !atomic_read(&device->ap_pending_cnt) || drbd_suspended(device));
 	/* and for any other previously queued work */
-	drbd_flush_workqueue(&first_peer_device(device)->connection->sender_work);
+	drbd_flush_workqueue(&connection->sender_work);
 
 	rv = _drbd_request_state(device, NS(disk, D_ATTACHING), CS_VERBOSE);
 	retcode = rv;  /* FIXME: Type mismatch. */
@@ -1838,7 +1844,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 
 	kobject_uevent(&disk_to_dev(device->vdisk)->kobj, KOBJ_CHANGE);
 	put_ldev(device);
-	conn_reconfig_done(first_peer_device(device)->connection);
+	conn_reconfig_done(connection);
 	mutex_unlock(&adm_ctx.resource->adm_mutex);
 	drbd_adm_finish(&adm_ctx, info, retcode);
 	return 0;
@@ -1849,7 +1855,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 	drbd_force_state(device, NS(disk, D_DISKLESS));
 	drbd_md_sync(device);
  fail:
-	conn_reconfig_done(first_peer_device(device)->connection);
+	conn_reconfig_done(connection);
 	if (nbc) {
 		if (nbc->backing_bdev)
 			blkdev_put(nbc->backing_bdev,
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index be0c376..bb1434d 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -2857,8 +2857,10 @@ static void drbd_uuid_dump(struct drbd_device *device, char *text, u64 *uuid,
 -1091   requires proto 91
 -1096   requires proto 96
  */
-static int drbd_uuid_compare(struct drbd_device *device, int *rule_nr) __must_hold(local)
+static int drbd_uuid_compare(struct drbd_device *const device, int *rule_nr) __must_hold(local)
 {
+	struct drbd_peer_device *const peer_device = first_peer_device(device);
+	struct drbd_connection *const connection = peer_device ? peer_device->connection : NULL;
 	u64 self, peer;
 	int i, j;
 
@@ -2884,7 +2886,7 @@ static int drbd_uuid_compare(struct drbd_device *device, int *rule_nr) __must_ho
 
 		if (device->p_uuid[UI_BITMAP] == (u64)0 && device->ldev->md.uuid[UI_BITMAP] != (u64)0) {
 
-			if (first_peer_device(device)->connection->agreed_pro_version < 91)
+			if (connection->agreed_pro_version < 91)
 				return -1091;
 
 			if ((device->ldev->md.uuid[UI_BITMAP] & ~((u64)1)) == (device->p_uuid[UI_HISTORY_START] & ~((u64)1)) &&
@@ -2907,7 +2909,7 @@ static int drbd_uuid_compare(struct drbd_device *device, int *rule_nr) __must_ho
 
 		if (device->ldev->md.uuid[UI_BITMAP] == (u64)0 && device->p_uuid[UI_BITMAP] != (u64)0) {
 
-			if (first_peer_device(device)->connection->agreed_pro_version < 91)
+			if (connection->agreed_pro_version < 91)
 				return -1091;
 
 			if ((device->ldev->md.uuid[UI_HISTORY_START] & ~((u64)1)) == (device->p_uuid[UI_BITMAP] & ~((u64)1)) &&
@@ -2940,7 +2942,7 @@ static int drbd_uuid_compare(struct drbd_device *device, int *rule_nr) __must_ho
 		case 1: /*  self_pri && !peer_pri */ return 1;
 		case 2: /* !self_pri &&  peer_pri */ return -1;
 		case 3: /*  self_pri &&  peer_pri */
-			dc = test_bit(RESOLVE_CONFLICTS, &first_peer_device(device)->connection->flags);
+			dc = test_bit(RESOLVE_CONFLICTS, &connection->flags);
 			return dc ? -1 : 1;
 		}
 	}
@@ -2953,14 +2955,14 @@ static int drbd_uuid_compare(struct drbd_device *device, int *rule_nr) __must_ho
 	*rule_nr = 51;
 	peer = device->p_uuid[UI_HISTORY_START] & ~((u64)1);
 	if (self == peer) {
-		if (first_peer_device(device)->connection->agreed_pro_version < 96 ?
+		if (connection->agreed_pro_version < 96 ?
 		    (device->ldev->md.uuid[UI_HISTORY_START] & ~((u64)1)) ==
 		    (device->p_uuid[UI_HISTORY_START + 1] & ~((u64)1)) :
 		    peer + UUID_NEW_BM_OFFSET == (device->p_uuid[UI_BITMAP] & ~((u64)1))) {
 			/* The last P_SYNC_UUID did not get though. Undo the last start of
 			   resync as sync source modifications of the peer's UUIDs. */
 
-			if (first_peer_device(device)->connection->agreed_pro_version < 91)
+			if (connection->agreed_pro_version < 91)
 				return -1091;
 
 			device->p_uuid[UI_BITMAP] = device->p_uuid[UI_HISTORY_START];
@@ -2990,14 +2992,14 @@ static int drbd_uuid_compare(struct drbd_device *device, int *rule_nr) __must_ho
 	*rule_nr = 71;
 	self = device->ldev->md.uuid[UI_HISTORY_START] & ~((u64)1);
 	if (self == peer) {
-		if (first_peer_device(device)->connection->agreed_pro_version < 96 ?
+		if (connection->agreed_pro_version < 96 ?
 		    (device->ldev->md.uuid[UI_HISTORY_START + 1] & ~((u64)1)) ==
 		    (device->p_uuid[UI_HISTORY_START] & ~((u64)1)) :
 		    self + UUID_NEW_BM_OFFSET == (device->ldev->md.uuid[UI_BITMAP] & ~((u64)1))) {
 			/* The last P_SYNC_UUID did not get though. Undo the last start of
 			   resync as sync source modifications of our UUIDs. */
 
-			if (first_peer_device(device)->connection->agreed_pro_version < 91)
+			if (connection->agreed_pro_version < 91)
 				return -1091;
 
 			__drbd_uuid_set(device, UI_BITMAP, device->ldev->md.uuid[UI_HISTORY_START]);
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 4c7fee1..042bbc6 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -454,7 +454,9 @@ static void drbd_report_io_error(struct drbd_device *device, struct drbd_request
 int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		struct bio_and_error *m)
 {
-	struct drbd_device *device = req->device;
+	struct drbd_device *const device = req->device;
+	struct drbd_peer_device *const peer_device = first_peer_device(device);
+	struct drbd_connection *const connection = peer_device ? peer_device->connection : NULL;
 	struct net_conf *nc;
 	int p, rv = 0;
 
@@ -477,7 +479,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		 * and from w_read_retry_remote */
 		D_ASSERT(device, !(req->rq_state & RQ_NET_MASK));
 		rcu_read_lock();
-		nc = rcu_dereference(first_peer_device(device)->connection->net_conf);
+		nc = rcu_dereference(connection->net_conf);
 		p = nc->wire_protocol;
 		rcu_read_unlock();
 		req->rq_state |=
@@ -549,7 +551,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		D_ASSERT(device, (req->rq_state & RQ_LOCAL_MASK) == 0);
 		mod_rq_state(req, m, 0, RQ_NET_QUEUED);
 		req->w.cb = w_send_read_req;
-		drbd_queue_work(&first_peer_device(device)->connection->sender_work,
+		drbd_queue_work(&connection->sender_work,
 				&req->w);
 		break;
 
@@ -585,23 +587,23 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		D_ASSERT(device, req->rq_state & RQ_NET_PENDING);
 		mod_rq_state(req, m, 0, RQ_NET_QUEUED|RQ_EXP_BARR_ACK);
 		req->w.cb =  w_send_dblock;
-		drbd_queue_work(&first_peer_device(device)->connection->sender_work,
+		drbd_queue_work(&connection->sender_work,
 				&req->w);
 
 		/* close the epoch, in case it outgrew the limit */
 		rcu_read_lock();
-		nc = rcu_dereference(first_peer_device(device)->connection->net_conf);
+		nc = rcu_dereference(connection->net_conf);
 		p = nc->max_epoch_size;
 		rcu_read_unlock();
-		if (first_peer_device(device)->connection->current_tle_writes >= p)
-			start_new_tl_epoch(first_peer_device(device)->connection);
+		if (connection->current_tle_writes >= p)
+			start_new_tl_epoch(connection);
 
 		break;
 
 	case QUEUE_FOR_SEND_OOS:
 		mod_rq_state(req, m, 0, RQ_NET_QUEUED);
 		req->w.cb =  w_send_out_of_sync;
-		drbd_queue_work(&first_peer_device(device)->connection->sender_work,
+		drbd_queue_work(&connection->sender_work,
 				&req->w);
 		break;
 
@@ -714,7 +716,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 
 		get_ldev(device); /* always succeeds in this call path */
 		req->w.cb = w_restart_disk_io;
-		drbd_queue_work(&first_peer_device(device)->connection->sender_work,
+		drbd_queue_work(&connection->sender_work,
 				&req->w);
 		break;
 
@@ -736,7 +738,8 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 
 			mod_rq_state(req, m, RQ_COMPLETION_SUSP, RQ_NET_QUEUED|RQ_NET_PENDING);
 			if (req->w.cb) {
-				drbd_queue_work(&first_peer_device(device)->connection->sender_work,
+				/* w.cb expected to be w_send_dblock, or w_send_read_req */
+				drbd_queue_work(&connection->sender_work,
 						&req->w);
 				rv = req->rq_state & RQ_WRITE ? MR_WRITE : MR_READ;
 			} /* else: FIXME can this happen? */
@@ -769,7 +772,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		break;
 
 	case QUEUE_AS_DRBD_BARRIER:
-		start_new_tl_epoch(first_peer_device(device)->connection);
+		start_new_tl_epoch(connection);
 		mod_rq_state(req, m, 0, RQ_NET_OK|RQ_NET_DONE);
 		break;
 	};
diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index a5d8aae..19da7c7 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -952,6 +952,8 @@ enum drbd_state_rv
 __drbd_set_state(struct drbd_device *device, union drbd_state ns,
 	         enum chg_state_flags flags, struct completion *done)
 {
+	struct drbd_peer_device *peer_device = first_peer_device(device);
+	struct drbd_connection *connection = peer_device ? peer_device->connection : NULL;
 	union drbd_state os;
 	enum drbd_state_rv rv = SS_SUCCESS;
 	enum sanitize_state_warnings ssw;
@@ -978,9 +980,9 @@ __drbd_set_state(struct drbd_device *device, union drbd_state ns,
 			   this happen...*/
 
 			if (is_valid_state(device, os) == rv)
-				rv = is_valid_soft_transition(os, ns, first_peer_device(device)->connection);
+				rv = is_valid_soft_transition(os, ns, connection);
 		} else
-			rv = is_valid_soft_transition(os, ns, first_peer_device(device)->connection);
+			rv = is_valid_soft_transition(os, ns, connection);
 	}
 
 	if (rv < SS_SUCCESS) {
@@ -997,7 +999,7 @@ __drbd_set_state(struct drbd_device *device, union drbd_state ns,
 	   sanitize_state(). Only display it here if we where not called from
 	   _conn_request_state() */
 	if (!(flags & CS_DC_SUSP))
-		conn_pr_state_change(first_peer_device(device)->connection, os, ns,
+		conn_pr_state_change(connection, os, ns,
 				     (flags & ~CS_DC_MASK) | CS_DC_SUSP);
 
 	/* if we are going -> D_FAILED or D_DISKLESS, grab one extra reference
@@ -1017,19 +1019,19 @@ __drbd_set_state(struct drbd_device *device, union drbd_state ns,
 
 	/* put replicated vs not-replicated requests in seperate epochs */
 	if (did_remote != should_do_remote)
-		start_new_tl_epoch(first_peer_device(device)->connection);
+		start_new_tl_epoch(connection);
 
 	if (os.disk == D_ATTACHING && ns.disk >= D_NEGOTIATING)
 		drbd_print_uuids(device, "attached to UUIDs");
 
 	/* Wake up role changes, that were delayed because of connection establishing */
 	if (os.conn == C_WF_REPORT_PARAMS && ns.conn != C_WF_REPORT_PARAMS &&
-	    no_peer_wf_report_params(first_peer_device(device)->connection))
-		clear_bit(STATE_SENT, &first_peer_device(device)->connection->flags);
+	    no_peer_wf_report_params(connection))
+		clear_bit(STATE_SENT, &connection->flags);
 
 	wake_up(&device->misc_wait);
 	wake_up(&device->state_wait);
-	wake_up(&first_peer_device(device)->connection->ping_wait);
+	wake_up(&connection->ping_wait);
 
 	/* Aborted verify run, or we reached the stop sector.
 	 * Log the last position, unless end-of-device. */
@@ -1118,21 +1120,21 @@ __drbd_set_state(struct drbd_device *device, union drbd_state ns,
 
 	/* Receiver should clean up itself */
 	if (os.conn != C_DISCONNECTING && ns.conn == C_DISCONNECTING)
-		drbd_thread_stop_nowait(&first_peer_device(device)->connection->receiver);
+		drbd_thread_stop_nowait(&connection->receiver);
 
 	/* Now the receiver finished cleaning up itself, it should die */
 	if (os.conn != C_STANDALONE && ns.conn == C_STANDALONE)
-		drbd_thread_stop_nowait(&first_peer_device(device)->connection->receiver);
+		drbd_thread_stop_nowait(&connection->receiver);
 
 	/* Upon network failure, we need to restart the receiver. */
 	if (os.conn > C_WF_CONNECTION &&
 	    ns.conn <= C_TEAR_DOWN && ns.conn >= C_TIMEOUT)
-		drbd_thread_restart_nowait(&first_peer_device(device)->connection->receiver);
+		drbd_thread_restart_nowait(&connection->receiver);
 
 	/* Resume AL writing if we get a connection */
 	if (os.conn < C_CONNECTED && ns.conn >= C_CONNECTED) {
 		drbd_resume_al(device);
-		first_peer_device(device)->connection->connect_cnt++;
+		connection->connect_cnt++;
 	}
 
 	/* remember last attach time so request_timer_fn() won't
@@ -1150,7 +1152,7 @@ __drbd_set_state(struct drbd_device *device, union drbd_state ns,
 		ascw->w.cb = w_after_state_ch;
 		ascw->device = device;
 		ascw->done = done;
-		drbd_queue_work(&first_peer_device(device)->connection->sender_work,
+		drbd_queue_work(&connection->sender_work,
 				&ascw->w);
 	} else {
 		drbd_err(device, "Could not kmalloc an ascw\n");
@@ -1222,6 +1224,8 @@ static void after_state_ch(struct drbd_device *device, union drbd_state os,
 			   union drbd_state ns, enum chg_state_flags flags)
 {
 	struct drbd_resource *resource = device->resource;
+	struct drbd_peer_device *peer_device = first_peer_device(device);
+	struct drbd_connection *connection = peer_device ? peer_device->connection : NULL;
 	struct sib_info sib;
 
 	sib.sib_reason = SIB_STATE_CHANGE;
@@ -1245,7 +1249,6 @@ static void after_state_ch(struct drbd_device *device, union drbd_state os,
 	   state change. This function might sleep */
 
 	if (ns.susp_nod) {
-		struct drbd_connection *connection = first_peer_device(device)->connection;
 		enum drbd_req_event what = NOTHING;
 
 		spin_lock_irq(&device->resource->req_lock);
@@ -1267,8 +1270,6 @@ static void after_state_ch(struct drbd_device *device, union drbd_state os,
 	}
 
 	if (ns.susp_fen) {
-		struct drbd_connection *connection = first_peer_device(device)->connection;
-
 		spin_lock_irq(&device->resource->req_lock);
 		if (resource->susp_fen && conn_lowest_conn(connection) >= C_CONNECTED) {
 			/* case2: The connection was established again: */
@@ -1294,8 +1295,8 @@ static void after_state_ch(struct drbd_device *device, union drbd_state os,
 	 * which is unexpected. */
 	if ((os.conn != C_SYNC_SOURCE && os.conn != C_PAUSED_SYNC_S) &&
 	    (ns.conn == C_SYNC_SOURCE || ns.conn == C_PAUSED_SYNC_S) &&
-	    first_peer_device(device)->connection->agreed_pro_version >= 96 && get_ldev(device)) {
-		drbd_gen_and_send_sync_uuid(first_peer_device(device));
+	    connection->agreed_pro_version >= 96 && get_ldev(device)) {
+		drbd_gen_and_send_sync_uuid(peer_device);
 		put_ldev(device);
 	}
 
@@ -1309,8 +1310,8 @@ static void after_state_ch(struct drbd_device *device, union drbd_state os,
 		atomic_set(&device->rs_pending_cnt, 0);
 		drbd_rs_cancel_all(device);
 
-		drbd_send_uuids(first_peer_device(device));
-		drbd_send_state(first_peer_device(device), ns);
+		drbd_send_uuids(peer_device);
+		drbd_send_state(peer_device, ns);
 	}
 	/* No point in queuing send_bitmap if we don't have a connection
 	 * anymore, so check also the _current_ state, not only the new state
@@ -1335,7 +1336,7 @@ static void after_state_ch(struct drbd_device *device, union drbd_state os,
 					set_bit(NEW_CUR_UUID, &device->flags);
 				} else {
 					drbd_uuid_new_current(device);
-					drbd_send_uuids(first_peer_device(device));
+					drbd_send_uuids(peer_device);
 				}
 			}
 			put_ldev(device);
@@ -1346,7 +1347,7 @@ static void after_state_ch(struct drbd_device *device, union drbd_state os,
 		if (os.peer == R_SECONDARY && ns.peer == R_PRIMARY &&
 		    device->ldev->md.uuid[UI_BITMAP] == 0 && ns.disk >= D_UP_TO_DATE) {
 			drbd_uuid_new_current(device);
-			drbd_send_uuids(first_peer_device(device));
+			drbd_send_uuids(peer_device);
 		}
 		/* D_DISKLESS Peer becomes secondary */
 		if (os.peer == R_PRIMARY && ns.peer == R_SECONDARY)
@@ -1373,16 +1374,16 @@ static void after_state_ch(struct drbd_device *device, union drbd_state os,
 	/* Last part of the attaching process ... */
 	if (ns.conn >= C_CONNECTED &&
 	    os.disk == D_ATTACHING && ns.disk == D_NEGOTIATING) {
-		drbd_send_sizes(first_peer_device(device), 0, 0);  /* to start sync... */
-		drbd_send_uuids(first_peer_device(device));
-		drbd_send_state(first_peer_device(device), ns);
+		drbd_send_sizes(peer_device, 0, 0);  /* to start sync... */
+		drbd_send_uuids(peer_device);
+		drbd_send_state(peer_device, ns);
 	}
 
 	/* We want to pause/continue resync, tell peer. */
 	if (ns.conn >= C_CONNECTED &&
 	     ((os.aftr_isp != ns.aftr_isp) ||
 	      (os.user_isp != ns.user_isp)))
-		drbd_send_state(first_peer_device(device), ns);
+		drbd_send_state(peer_device, ns);
 
 	/* In case one of the isp bits got set, suspend other devices. */
 	if ((!os.aftr_isp && !os.peer_isp && !os.user_isp) &&
@@ -1392,10 +1393,10 @@ static void after_state_ch(struct drbd_device *device, union drbd_state os,
 	/* Make sure the peer gets informed about eventual state
 	   changes (ISP bits) while we were in WFReportParams. */
 	if (os.conn == C_WF_REPORT_PARAMS && ns.conn >= C_CONNECTED)
-		drbd_send_state(first_peer_device(device), ns);
+		drbd_send_state(peer_device, ns);
 
 	if (os.conn != C_AHEAD && ns.conn == C_AHEAD)
-		drbd_send_state(first_peer_device(device), ns);
+		drbd_send_state(peer_device, ns);
 
 	/* We are in the progress to start a full sync... */
 	if ((os.conn != C_STARTING_SYNC_T && ns.conn == C_STARTING_SYNC_T) ||
@@ -1449,7 +1450,7 @@ static void after_state_ch(struct drbd_device *device, union drbd_state os,
 					drbd_disk_str(device->state.disk));
 
 			if (ns.conn >= C_CONNECTED)
-				drbd_send_state(first_peer_device(device), ns);
+				drbd_send_state(peer_device, ns);
 
 			drbd_rs_cancel_all(device);
 
@@ -1473,7 +1474,7 @@ static void after_state_ch(struct drbd_device *device, union drbd_state os,
 				 drbd_disk_str(device->state.disk));
 
 		if (ns.conn >= C_CONNECTED)
-			drbd_send_state(first_peer_device(device), ns);
+			drbd_send_state(peer_device, ns);
 		/* corresponding get_ldev in __drbd_set_state
 		 * this may finally trigger drbd_ldev_destroy. */
 		put_ldev(device);
@@ -1481,7 +1482,7 @@ static void after_state_ch(struct drbd_device *device, union drbd_state os,
 
 	/* Notify peer that I had a local IO error, and did not detached.. */
 	if (os.disk == D_UP_TO_DATE && ns.disk == D_INCONSISTENT && ns.conn >= C_CONNECTED)
-		drbd_send_state(first_peer_device(device), ns);
+		drbd_send_state(peer_device, ns);
 
 	/* Disks got bigger while they were detached */
 	if (ns.disk > D_NEGOTIATING && ns.pdsk > D_NEGOTIATING &&
@@ -1499,14 +1500,14 @@ static void after_state_ch(struct drbd_device *device, union drbd_state os,
 	/* sync target done with resync.  Explicitly notify peer, even though
 	 * it should (at least for non-empty resyncs) already know itself. */
 	if (os.disk < D_UP_TO_DATE && os.conn >= C_SYNC_SOURCE && ns.conn == C_CONNECTED)
-		drbd_send_state(first_peer_device(device), ns);
+		drbd_send_state(peer_device, ns);
 
 	/* Verify finished, or reached stop sector.  Peer did not know about
 	 * the stop sector, and we may even have changed the stop sector during
 	 * verify to interrupt/stop early.  Send the new state. */
 	if (os.conn == C_VERIFY_S && ns.conn == C_CONNECTED
 	&& verify_can_do_stop_sector(device))
-		drbd_send_state(first_peer_device(device), ns);
+		drbd_send_state(peer_device, ns);
 
 	/* This triggers bitmap writeout of potentially still unwritten pages
 	 * if the resync finished cleanly, or aborted because of peer disk
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index d8f57b6..595ab57 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -583,8 +583,10 @@ static int drbd_rs_number_requests(struct drbd_device *device)
 	return number;
 }
 
-static int make_resync_request(struct drbd_device *device, int cancel)
+static int make_resync_request(struct drbd_device *const device, int cancel)
 {
+	struct drbd_peer_device *const peer_device = first_peer_device(device);
+	struct drbd_connection *const connection = peer_device ? peer_device->connection : NULL;
 	unsigned long bit;
 	sector_t sector;
 	const sector_t capacity = drbd_get_capacity(device->this_bdev);
@@ -618,15 +620,15 @@ static int make_resync_request(struct drbd_device *device, int cancel)
 
 	for (i = 0; i < number; i++) {
 		/* Stop generating RS requests, when half of the send buffer is filled */
-		mutex_lock(&first_peer_device(device)->connection->data.mutex);
-		if (first_peer_device(device)->connection->data.socket) {
-			queued = first_peer_device(device)->connection->data.socket->sk->sk_wmem_queued;
-			sndbuf = first_peer_device(device)->connection->data.socket->sk->sk_sndbuf;
+		mutex_lock(&connection->data.mutex);
+		if (connection->data.socket) {
+			queued = connection->data.socket->sk->sk_wmem_queued;
+			sndbuf = connection->data.socket->sk->sk_sndbuf;
 		} else {
 			queued = 1;
 			sndbuf = 0;
 		}
-		mutex_unlock(&first_peer_device(device)->connection->data.mutex);
+		mutex_unlock(&connection->data.mutex);
 		if (queued > sndbuf / 2)
 			goto requeue;
 
@@ -696,9 +698,9 @@ next_sector:
 		/* adjust very last sectors, in case we are oddly sized */
 		if (sector + (size>>9) > capacity)
 			size = (capacity-sector)<<9;
-		if (first_peer_device(device)->connection->agreed_pro_version >= 89 &&
-		    first_peer_device(device)->connection->csums_tfm) {
-			switch (read_for_csum(first_peer_device(device), sector, size)) {
+		if (connection->agreed_pro_version >= 89 &&
+		    connection->csums_tfm) {
+			switch (read_for_csum(peer_device, sector, size)) {
 			case -EIO: /* Disk failure */
 				put_ldev(device);
 				return -EIO;
@@ -717,7 +719,7 @@ next_sector:
 			int err;
 
 			inc_rs_pending(device);
-			err = drbd_send_drequest(first_peer_device(device), P_RS_DATA_REQUEST,
+			err = drbd_send_drequest(peer_device, P_RS_DATA_REQUEST,
 						 sector, size, ID_SYNCER);
 			if (err) {
 				drbd_err(device, "drbd_send_drequest() failed, aborting...\n");
@@ -1351,7 +1353,8 @@ int w_send_out_of_sync(struct drbd_work *w, int cancel)
 {
 	struct drbd_request *req = container_of(w, struct drbd_request, w);
 	struct drbd_device *device = req->device;
-	struct drbd_connection *connection = first_peer_device(device)->connection;
+	struct drbd_peer_device *const peer_device = first_peer_device(device);
+	struct drbd_connection *const connection = peer_device->connection;
 	int err;
 
 	if (unlikely(cancel)) {
@@ -1365,7 +1368,7 @@ int w_send_out_of_sync(struct drbd_work *w, int cancel)
 	 * No more barriers will be sent, until we leave AHEAD mode again. */
 	maybe_send_barrier(connection, req->epoch);
 
-	err = drbd_send_out_of_sync(first_peer_device(device), req);
+	err = drbd_send_out_of_sync(peer_device, req);
 	req_mod(req, OOS_HANDED_TO_NETWORK);
 
 	return err;
@@ -1380,7 +1383,8 @@ int w_send_dblock(struct drbd_work *w, int cancel)
 {
 	struct drbd_request *req = container_of(w, struct drbd_request, w);
 	struct drbd_device *device = req->device;
-	struct drbd_connection *connection = first_peer_device(device)->connection;
+	struct drbd_peer_device *const peer_device = first_peer_device(device);
+	struct drbd_connection *connection = peer_device->connection;
 	int err;
 
 	if (unlikely(cancel)) {
@@ -1392,7 +1396,7 @@ int w_send_dblock(struct drbd_work *w, int cancel)
 	maybe_send_barrier(connection, req->epoch);
 	connection->send.current_epoch_writes++;
 
-	err = drbd_send_dblock(first_peer_device(device), req);
+	err = drbd_send_dblock(peer_device, req);
 	req_mod(req, err ? SEND_FAILED : HANDED_OVER_TO_NETWORK);
 
 	return err;
@@ -1407,7 +1411,8 @@ int w_send_read_req(struct drbd_work *w, int cancel)
 {
 	struct drbd_request *req = container_of(w, struct drbd_request, w);
 	struct drbd_device *device = req->device;
-	struct drbd_connection *connection = first_peer_device(device)->connection;
+	struct drbd_peer_device *const peer_device = first_peer_device(device);
+	struct drbd_connection *connection = peer_device->connection;
 	int err;
 
 	if (unlikely(cancel)) {
@@ -1419,7 +1424,7 @@ int w_send_read_req(struct drbd_work *w, int cancel)
 	 * if there was any yet. */
 	maybe_send_barrier(connection, req->epoch);
 
-	err = drbd_send_drequest(first_peer_device(device), P_DATA_REQUEST, req->i.sector, req->i.size,
+	err = drbd_send_drequest(peer_device, P_DATA_REQUEST, req->i.sector, req->i.size,
 				 (unsigned long)req);
 
 	req_mod(req, err ? SEND_FAILED : HANDED_OVER_TO_NETWORK);
@@ -1633,6 +1638,8 @@ int w_start_resync(struct drbd_work *w, int cancel)
  */
 void drbd_start_resync(struct drbd_device *device, enum drbd_conns side)
 {
+	struct drbd_peer_device *peer_device = first_peer_device(device);
+	struct drbd_connection *connection = peer_device ? peer_device->connection : NULL;
 	union drbd_state ns;
 	int r;
 
@@ -1651,7 +1658,7 @@ void drbd_start_resync(struct drbd_device *device, enum drbd_conns side)
 			if (r > 0) {
 				drbd_info(device, "before-resync-target handler returned %d, "
 					 "dropping connection.\n", r);
-				conn_request_state(first_peer_device(device)->connection, NS(conn, C_DISCONNECTING), CS_HARD);
+				conn_request_state(connection, NS(conn, C_DISCONNECTING), CS_HARD);
 				return;
 			}
 		} else /* C_SYNC_SOURCE */ {
@@ -1664,7 +1671,7 @@ void drbd_start_resync(struct drbd_device *device, enum drbd_conns side)
 				} else {
 					drbd_info(device, "before-resync-source handler returned %d, "
 						 "dropping connection.\n", r);
-					conn_request_state(first_peer_device(device)->connection,
+					conn_request_state(connection,
 							   NS(conn, C_DISCONNECTING), CS_HARD);
 					return;
 				}
@@ -1672,7 +1679,7 @@ void drbd_start_resync(struct drbd_device *device, enum drbd_conns side)
 		}
 	}
 
-	if (current == first_peer_device(device)->connection->worker.task) {
+	if (current == connection->worker.task) {
 		/* The worker should not sleep waiting for state_mutex,
 		   that can take long */
 		if (!mutex_trylock(device->state_mutex)) {
@@ -1756,12 +1763,10 @@ void drbd_start_resync(struct drbd_device *device, enum drbd_conns side)
 		 * drbd_resync_finished from here in that case.
 		 * We drbd_gen_and_send_sync_uuid here for protocol < 96,
 		 * and from after_state_ch otherwise. */
-		if (side == C_SYNC_SOURCE &&
-		    first_peer_device(device)->connection->agreed_pro_version < 96)
-			drbd_gen_and_send_sync_uuid(first_peer_device(device));
+		if (side == C_SYNC_SOURCE && connection->agreed_pro_version < 96)
+			drbd_gen_and_send_sync_uuid(peer_device);
 
-		if (first_peer_device(device)->connection->agreed_pro_version < 95 &&
-		    device->rs_total == 0) {
+		if (connection->agreed_pro_version < 95 && device->rs_total == 0) {
 			/* This still has a race (about when exactly the peers
 			 * detect connection loss) that can lead to a full sync
 			 * on next handshake. In 8.3.9 we fixed this with explicit
@@ -1777,7 +1782,7 @@ void drbd_start_resync(struct drbd_device *device, enum drbd_conns side)
 				int timeo;
 
 				rcu_read_lock();
-				nc = rcu_dereference(first_peer_device(device)->connection->net_conf);
+				nc = rcu_dereference(connection->net_conf);
 				timeo = nc->ping_int * HZ + nc->ping_timeo * HZ / 9;
 				rcu_read_unlock();
 				schedule_timeout_interruptible(timeo);
-- 
1.9.1

