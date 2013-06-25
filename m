Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211Ab3FYOvz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 10:51:55 -0400
Received: from mail09.linbit.com ([212.69.161.110]:50482 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab3FYOuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 10:50:13 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 4/6] drbd: Ignore the exit code of a fence-peer handler if it returns too late
Date: Tue, 25 Jun 2013 16:50:06 +0200
Message-Id: <1372171808-30515-5-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1372171808-30515-1-git-send-email-philipp.reisner@linbit.com>
References: <1372171808-30515-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case the connection was established and lost again before
the a fence-peer handler returns, ignore the exit code of this
instance. (And use the exit code of the later started instance)

Signed-off-by: Andreas Gruenbacher <agruen@linbit.com>
Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
---
 drivers/block/drbd/drbd_int.h   |    1 +
 drivers/block/drbd/drbd_nl.c    |   15 +++++++++++++--
 drivers/block/drbd/drbd_state.c |    4 +++-
 3 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index f943aac..f104328 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -832,6 +832,7 @@ struct drbd_tconn {			/* is a resource from the config file */
 	unsigned susp_nod:1;		/* IO suspended because no data */
 	unsigned susp_fen:1;		/* IO suspended because fence peer handler runs */
 	struct mutex cstate_mutex;	/* Protects graceful disconnects */
+	unsigned int connect_cnt;	/* Inc each time a connection is established */
 
 	unsigned long flags;
 	struct net_conf *net_conf;	/* content protected by rcu */
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 0936d6a..e25803b 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -417,6 +417,7 @@ static enum drbd_fencing_p highest_fencing_policy(struct drbd_tconn *tconn)
 
 bool conn_try_outdate_peer(struct drbd_tconn *tconn)
 {
+	unsigned int connect_cnt;
 	union drbd_state mask = { };
 	union drbd_state val = { };
 	enum drbd_fencing_p fp;
@@ -428,6 +429,10 @@ bool conn_try_outdate_peer(struct drbd_tconn *tconn)
 		return false;
 	}
 
+	spin_lock_irq(&tconn->req_lock);
+	connect_cnt = tconn->connect_cnt;
+	spin_unlock_irq(&tconn->req_lock);
+
 	fp = highest_fencing_policy(tconn);
 	switch (fp) {
 	case FP_NOT_AVAIL:
@@ -492,8 +497,14 @@ bool conn_try_outdate_peer(struct drbd_tconn *tconn)
 	   here, because we might were able to re-establish the connection in the
 	   meantime. */
 	spin_lock_irq(&tconn->req_lock);
-	if (tconn->cstate < C_WF_REPORT_PARAMS && !test_bit(STATE_SENT, &tconn->flags))
-		_conn_request_state(tconn, mask, val, CS_VERBOSE);
+	if (tconn->cstate < C_WF_REPORT_PARAMS && !test_bit(STATE_SENT, &tconn->flags)) {
+		if (tconn->connect_cnt != connect_cnt)
+			/* In case the connection was established and droped
+			   while the fence-peer handler was running, ignore it */
+			conn_info(tconn, "Ignoring fence-peer exit code\n");
+		else
+			_conn_request_state(tconn, mask, val, CS_VERBOSE);
+	}
 	spin_unlock_irq(&tconn->req_lock);
 
 	return conn_highest_pdsk(tconn) <= D_OUTDATED;
diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index 90c5be2..216d47b 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -1115,8 +1115,10 @@ __drbd_set_state(struct drbd_conf *mdev, union drbd_state ns,
 		drbd_thread_restart_nowait(&mdev->tconn->receiver);
 
 	/* Resume AL writing if we get a connection */
-	if (os.conn < C_CONNECTED && ns.conn >= C_CONNECTED)
+	if (os.conn < C_CONNECTED && ns.conn >= C_CONNECTED) {
 		drbd_resume_al(mdev);
+		mdev->tconn->connect_cnt++;
+	}
 
 	/* remember last attach time so request_timer_fn() won't
 	 * kill newly established sessions while we are still trying to thaw
-- 
1.7.9.5

