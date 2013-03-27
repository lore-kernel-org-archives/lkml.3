Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492Ab3C0NOK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 09:14:10 -0400
Received: from mail09.linbit.com ([212.69.161.110]:44234 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981Ab3C0NJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 09:09:19 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com, Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: [PATCH 04/17] drbd: move invalidating the whole bitmap out of after_state ch()
Date: Wed, 27 Mar 2013 14:08:36 +0100
Message-Id: <1364389729-17559-5-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364389729-17559-1-git-send-email-philipp.reisner@linbit.com>
References: <1364389729-17559-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To avoid other state change requests, after passing through
sanitize_state(), to be mistaken for an invalidate,
move the "set all bits as out-of-sync" into the invalidate path.

Make invalidate and invalidate-remote behave consistently wrt.
current connection state (need either an established replication link,
or really be disconnected). Also mention that in the documentation.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_nl.c    |   36 ++++++++++++++++++++----------------
 drivers/block/drbd/drbd_state.c |    7 -------
 2 files changed, 20 insertions(+), 23 deletions(-)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 42fda4a..c49bda7 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -2448,19 +2448,23 @@ int drbd_adm_invalidate(struct sk_buff *skb, struct genl_info *info)
 
 	retcode = _drbd_request_state(mdev, NS(conn, C_STARTING_SYNC_T), CS_ORDERED);
 
-	if (retcode < SS_SUCCESS && retcode != SS_NEED_CONNECTION)
-		retcode = drbd_request_state(mdev, NS(conn, C_STARTING_SYNC_T));
-
-	while (retcode == SS_NEED_CONNECTION) {
-		spin_lock_irq(&mdev->tconn->req_lock);
-		if (mdev->state.conn < C_CONNECTED)
-			retcode = _drbd_set_state(_NS(mdev, disk, D_INCONSISTENT), CS_VERBOSE, NULL);
-		spin_unlock_irq(&mdev->tconn->req_lock);
-
-		if (retcode != SS_NEED_CONNECTION)
-			break;
-
-		retcode = drbd_request_state(mdev, NS(conn, C_STARTING_SYNC_T));
+	/* If that did not work, try again,
+	 * but log failures this time (implicit CS_VERBOSE).
+	 *
+	 * If we happen to be C_STANDALONE R_SECONDARY,
+	 * just change to D_INCONSISTENT, and set all bits in the bitmap.
+	 * Otherwise, we just fail, to avoid races with the resync handshake.
+	 */
+	if (retcode < SS_SUCCESS) {
+		if (mdev->state.conn == C_STANDALONE && mdev->state.role == R_SECONDARY) {
+			retcode = drbd_request_state(mdev, NS(disk, D_INCONSISTENT));
+			if (retcode >= SS_SUCCESS) {
+				if (drbd_bitmap_io(mdev, &drbd_bmio_set_n_write,
+					"set_n_write from invalidate", BM_LOCKED_MASK))
+					retcode = ERR_IO_MD_DISK;
+			}
+		} else
+			retcode = drbd_request_state(mdev, NS(conn, C_STARTING_SYNC_T));
 	}
 	drbd_resume_io(mdev);
 
@@ -2517,9 +2521,9 @@ int drbd_adm_invalidate_peer(struct sk_buff *skb, struct genl_info *info)
 
 	retcode = _drbd_request_state(mdev, NS(conn, C_STARTING_SYNC_S), CS_ORDERED);
 	if (retcode < SS_SUCCESS) {
-		if (retcode == SS_NEED_CONNECTION && mdev->state.role == R_PRIMARY) {
-			/* The peer will get a resync upon connect anyways.
-			 * Just make that into a full resync. */
+		if (mdev->state.conn == C_STANDALONE && mdev->state.role == R_PRIMARY) {
+			/* The peer will get a resync upon connect anyways. Just make that
+			   into a full resync. */
 			retcode = drbd_request_state(mdev, NS(pdsk, D_INCONSISTENT));
 			if (retcode >= SS_SUCCESS) {
 				if (drbd_bitmap_io(mdev, &drbd_bmio_set_susp_al,
diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index 0fe220c..3bc686f 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -1377,13 +1377,6 @@ static void after_state_ch(struct drbd_conf *mdev, union drbd_state os,
 			&drbd_bmio_set_n_write, &abw_start_sync,
 			"set_n_write from StartingSync", BM_LOCKED_TEST_ALLOWED);
 
-	/* We are invalidating our self... */
-	if (os.conn < C_CONNECTED && ns.conn < C_CONNECTED &&
-	    os.disk > D_INCONSISTENT && ns.disk == D_INCONSISTENT)
-		/* other bitmap operation expected during this phase */
-		drbd_queue_bitmap_io(mdev, &drbd_bmio_set_n_write, NULL,
-			"set_n_write from invalidate", BM_LOCKED_MASK);
-
 	/* first half of local IO error, failure to attach,
 	 * or administrative detach */
 	if (os.disk != D_FAILED && ns.disk == D_FAILED) {
-- 
1.7.9.5

