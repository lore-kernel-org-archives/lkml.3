Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbaKJQVe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 11:21:34 -0500
Received: from zimbra13.linbit.com ([212.69.166.240]:54042 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496AbaKJQVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 11:21:19 -0500
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 3/7] drbd: fix race between role change and handshake
Date: Mon, 10 Nov 2014 17:21:11 +0100
Message-Id: <1415636475-7883-4-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415636475-7883-1-git-send-email-philipp.reisner@linbit.com>
References: <1415636475-7883-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Symptoms:
If DRBD was "cleanly shut down" (all in sync, both Secondary before
disconnect, identical data generation uuids), and then one side was
promoted *during* the next connection handshake, the role change
could confuse the handshake.

The Primary would get stuck in WFBitmapS, the Secondary would log
unexpected cstate (Connected) in receive_bitmap
and get stuck in WFBitmapT.

Fix:
The test in is_valid_soft_transition wrong. It works because
the not allowed actions (promote/attach) do not touch the
cstate. The previous condition failed to demand a cstate change
in one clause.

In order to avoid deadlocks give up the state_mutex while waiting
for the transient state to go away.

Conflicts:
	drbd/drbd_state.c
	drbd/drbd_state.h
	drbd/drbd_wrappers.h

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_nl.c    |  2 +-
 drivers/block/drbd/drbd_state.c | 41 ++++++++++++++++++++++++++++++++++-------
 drivers/block/drbd/drbd_state.h |  5 +++++
 3 files changed, 40 insertions(+), 8 deletions(-)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 4782d07..74df8cf 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -588,7 +588,7 @@ drbd_set_role(struct drbd_device *const device, enum drbd_role new_role, int for
 	val.i  = 0; val.role  = new_role;
 
 	while (try++ < max_tries) {
-		rv = _drbd_request_state(device, mask, val, CS_WAIT_COMPLETE);
+		rv = _drbd_request_state_holding_state_mutex(device, mask, val, CS_WAIT_COMPLETE);
 
 		/* in case we first succeeded to outdate,
 		 * but now suddenly could establish a connection */
diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index 84b11f8..4529d92 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -215,6 +215,18 @@ static bool no_peer_wf_report_params(struct drbd_connection *connection)
 	return rv;
 }
 
+static void wake_up_all_devices(struct drbd_connection *connection)
+{
+	struct drbd_peer_device *peer_device;
+	int vnr;
+
+	rcu_read_lock();
+	idr_for_each_entry(&connection->peer_devices, peer_device, vnr)
+		wake_up(&peer_device->device->state_wait);
+	rcu_read_unlock();
+
+}
+
 
 /**
  * cl_wide_st_chg() - true if the state change is a cluster wide one
@@ -410,6 +422,22 @@ _drbd_request_state(struct drbd_device *device, union drbd_state mask,
 	return rv;
 }
 
+enum drbd_state_rv
+_drbd_request_state_holding_state_mutex(struct drbd_device *device, union drbd_state mask,
+		    union drbd_state val, enum chg_state_flags f)
+{
+	enum drbd_state_rv rv;
+
+	BUG_ON(f & CS_SERIALIZE);
+
+	wait_event_cmd(device->state_wait,
+		       (rv = drbd_req_state(device, mask, val, f)) != SS_IN_TRANSIENT_STATE,
+		       mutex_unlock(device->state_mutex),
+		       mutex_lock(device->state_mutex));
+
+	return rv;
+}
+
 static void print_st(struct drbd_device *device, const char *name, union drbd_state ns)
 {
 	drbd_err(device, " %s = { cs:%s ro:%s/%s ds:%s/%s %c%c%c%c%c%c }\n",
@@ -629,14 +657,11 @@ is_valid_soft_transition(union drbd_state os, union drbd_state ns, struct drbd_c
 	if (ns.conn == C_DISCONNECTING && os.conn == C_UNCONNECTED)
 		rv = SS_IN_TRANSIENT_STATE;
 
-	/* if (ns.conn == os.conn && ns.conn == C_WF_REPORT_PARAMS)
-	   rv = SS_IN_TRANSIENT_STATE; */
-
 	/* While establishing a connection only allow cstate to change.
-	   Delay/refuse role changes, detach attach etc... */
+	   Delay/refuse role changes, detach attach etc... (they do not touch cstate) */
 	if (test_bit(STATE_SENT, &connection->flags) &&
-	    !(os.conn == C_WF_REPORT_PARAMS ||
-	      (ns.conn == C_WF_REPORT_PARAMS && os.conn == C_WF_CONNECTION)))
+	    !((ns.conn == C_WF_REPORT_PARAMS && os.conn == C_WF_CONNECTION) ||
+	      (ns.conn >= C_CONNECTED && os.conn == C_WF_REPORT_PARAMS)))
 		rv = SS_IN_TRANSIENT_STATE;
 
 	if ((ns.conn == C_VERIFY_S || ns.conn == C_VERIFY_T) && os.conn < C_CONNECTED)
@@ -1032,8 +1057,10 @@ __drbd_set_state(struct drbd_device *device, union drbd_state ns,
 
 	/* Wake up role changes, that were delayed because of connection establishing */
 	if (os.conn == C_WF_REPORT_PARAMS && ns.conn != C_WF_REPORT_PARAMS &&
-	    no_peer_wf_report_params(connection))
+	    no_peer_wf_report_params(connection)) {
 		clear_bit(STATE_SENT, &connection->flags);
+		wake_up_all_devices(connection);
+	}
 
 	wake_up(&device->misc_wait);
 	wake_up(&device->state_wait);
diff --git a/drivers/block/drbd/drbd_state.h b/drivers/block/drbd/drbd_state.h
index cc41605..7f53c40 100644
--- a/drivers/block/drbd/drbd_state.h
+++ b/drivers/block/drbd/drbd_state.h
@@ -117,6 +117,11 @@ extern enum drbd_state_rv _drbd_request_state(struct drbd_device *,
 					      union drbd_state,
 					      union drbd_state,
 					      enum chg_state_flags);
+
+extern enum drbd_state_rv
+_drbd_request_state_holding_state_mutex(struct drbd_device *, union drbd_state,
+					union drbd_state, enum chg_state_flags);
+
 extern enum drbd_state_rv __drbd_set_state(struct drbd_device *, union drbd_state,
 					   enum chg_state_flags,
 					   struct completion *done);
-- 
1.9.1

