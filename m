Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475Ab3C0NMF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 09:12:05 -0400
Received: from mail09.linbit.com ([212.69.161.110]:44313 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342Ab3C0NJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 09:09:21 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com, Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: [PATCH 08/17] drbd: Fix disconnect to keep the peer disk state if connection breaks during operation
Date: Wed, 27 Mar 2013 14:08:40 +0100
Message-Id: <1364389729-17559-9-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364389729-17559-1-git-send-email-philipp.reisner@linbit.com>
References: <1364389729-17559-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The issue was that if the connection broke while we did the
gracefull state change to C_DISCONNECTING (C_TEARDOWN), then
we returned a success code from the state engine. (SS_CW_NO_NEED)

The result of that is that we missed to call the fence-peer
script in such a case.

Fixed that by introducing a new error code (SS_OUTDATE_WO_CONN).
This one should never reach back into user space.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_nl.c      |    7 +++++--
 drivers/block/drbd/drbd_state.c   |   14 +++++++-------
 drivers/block/drbd/drbd_strings.c |    1 +
 include/linux/drbd.h              |    3 ++-
 4 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 56bafdc..39e9a91 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -2198,8 +2198,11 @@ static enum drbd_state_rv conn_try_disconnect(struct drbd_tconn *tconn, bool for
 		return SS_SUCCESS;
 	case SS_PRIMARY_NOP:
 		/* Our state checking code wants to see the peer outdated. */
-		rv = conn_request_state(tconn, NS2(conn, C_DISCONNECTING,
-						pdsk, D_OUTDATED), CS_VERBOSE);
+		rv = conn_request_state(tconn, NS2(conn, C_DISCONNECTING, pdsk, D_OUTDATED), 0);
+
+		if (rv == SS_OUTDATE_WO_CONN) /* lost connection before graceful disconnect succeeded */
+			rv = conn_request_state(tconn, NS(conn, C_DISCONNECTING), CS_VERBOSE);
+
 		break;
 	case SS_CW_FAILED_BY_PEER:
 		/* The peer probably wants to see us outdated. */
diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index 22e259f..90c5be2 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -642,6 +642,10 @@ is_valid_soft_transition(union drbd_state os, union drbd_state ns, struct drbd_t
 	    && os.conn < C_WF_REPORT_PARAMS)
 		rv = SS_NEED_CONNECTION; /* No NetworkFailure -> SyncTarget etc... */
 
+	if (ns.conn == C_DISCONNECTING && ns.pdsk == D_OUTDATED &&
+	    os.conn < C_CONNECTED && os.pdsk > D_OUTDATED)
+		rv = SS_OUTDATE_WO_CONN;
+
 	return rv;
 }
 
@@ -1748,13 +1752,9 @@ _conn_rq_cond(struct drbd_tconn *tconn, union drbd_state mask, union drbd_state
 	if (test_and_clear_bit(CONN_WD_ST_CHG_FAIL, &tconn->flags))
 		return SS_CW_FAILED_BY_PEER;
 
-	rv = tconn->cstate != C_WF_REPORT_PARAMS ? SS_CW_NO_NEED : SS_UNKNOWN_ERROR;
-
-	if (rv == SS_UNKNOWN_ERROR)
-		rv = conn_is_valid_transition(tconn, mask, val, 0);
-
-	if (rv == SS_SUCCESS)
-		rv = SS_UNKNOWN_ERROR; /* cont waiting, otherwise fail. */
+	rv = conn_is_valid_transition(tconn, mask, val, 0);
+	if (rv == SS_SUCCESS && tconn->cstate == C_WF_REPORT_PARAMS)
+		rv = SS_UNKNOWN_ERROR; /* continue waiting */
 
 	return rv;
 }
diff --git a/drivers/block/drbd/drbd_strings.c b/drivers/block/drbd/drbd_strings.c
index 9a664bd..58e08ff 100644
--- a/drivers/block/drbd/drbd_strings.c
+++ b/drivers/block/drbd/drbd_strings.c
@@ -89,6 +89,7 @@ static const char *drbd_state_sw_errors[] = {
 	[-SS_LOWER_THAN_OUTDATED] = "Disk state is lower than outdated",
 	[-SS_IN_TRANSIENT_STATE] = "In transient state, retry after next state change",
 	[-SS_CONCURRENT_ST_CHG] = "Concurrent state changes detected and aborted",
+	[-SS_OUTDATE_WO_CONN] = "Need a connection for a graceful disconnect/outdate peer",
 	[-SS_O_VOL_PEER_PRI] = "Other vol primary on peer not allowed by config",
 };
 
diff --git a/include/linux/drbd.h b/include/linux/drbd.h
index 0c5a18e..3163307 100644
--- a/include/linux/drbd.h
+++ b/include/linux/drbd.h
@@ -319,7 +319,8 @@ enum drbd_state_rv {
 	SS_IN_TRANSIENT_STATE = -18,  /* Retry after the next state change */
 	SS_CONCURRENT_ST_CHG = -19,   /* Concurrent cluster side state change! */
 	SS_O_VOL_PEER_PRI = -20,
-	SS_AFTER_LAST_ERROR = -21,    /* Keep this at bottom */
+	SS_OUTDATE_WO_CONN = -21,
+	SS_AFTER_LAST_ERROR = -22,    /* Keep this at bottom */
 };
 
 /* from drbd_strings.c */
-- 
1.7.9.5

