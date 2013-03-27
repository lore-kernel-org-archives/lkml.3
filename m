Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455Ab3C0NNS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 09:13:18 -0400
Received: from mail09.linbit.com ([212.69.161.110]:44296 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172Ab3C0NJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 09:09:21 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com, Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: [PATCH 06/17] drbd: drop now useless duplicate state request from invalidate
Date: Wed, 27 Mar 2013 14:08:38 +0100
Message-Id: <1364389729-17559-7-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364389729-17559-1-git-send-email-philipp.reisner@linbit.com>
References: <1364389729-17559-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch best viewed with git diff --ignore-space-change.

Now that we attempt the fallback to local bitmap operation
only when disconnected, we can safely drop the extra "silent"
state request from both invalidate and invalidate-remote.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_nl.c |   62 +++++++++++++++++++-----------------------
 1 file changed, 28 insertions(+), 34 deletions(-)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index c49bda7..56bafdc 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -2446,26 +2446,19 @@ int drbd_adm_invalidate(struct sk_buff *skb, struct genl_info *info)
 	wait_event(mdev->misc_wait, !test_bit(BITMAP_IO, &mdev->flags));
 	drbd_flush_workqueue(mdev);
 
-	retcode = _drbd_request_state(mdev, NS(conn, C_STARTING_SYNC_T), CS_ORDERED);
-
-	/* If that did not work, try again,
-	 * but log failures this time (implicit CS_VERBOSE).
-	 *
-	 * If we happen to be C_STANDALONE R_SECONDARY,
-	 * just change to D_INCONSISTENT, and set all bits in the bitmap.
-	 * Otherwise, we just fail, to avoid races with the resync handshake.
+	/* If we happen to be C_STANDALONE R_SECONDARY, just change to
+	 * D_INCONSISTENT, and set all bits in the bitmap.  Otherwise,
+	 * try to start a resync handshake as sync target for full sync.
 	 */
-	if (retcode < SS_SUCCESS) {
-		if (mdev->state.conn == C_STANDALONE && mdev->state.role == R_SECONDARY) {
-			retcode = drbd_request_state(mdev, NS(disk, D_INCONSISTENT));
-			if (retcode >= SS_SUCCESS) {
-				if (drbd_bitmap_io(mdev, &drbd_bmio_set_n_write,
-					"set_n_write from invalidate", BM_LOCKED_MASK))
-					retcode = ERR_IO_MD_DISK;
-			}
-		} else
-			retcode = drbd_request_state(mdev, NS(conn, C_STARTING_SYNC_T));
-	}
+	if (mdev->state.conn == C_STANDALONE && mdev->state.role == R_SECONDARY) {
+		retcode = drbd_request_state(mdev, NS(disk, D_INCONSISTENT));
+		if (retcode >= SS_SUCCESS) {
+			if (drbd_bitmap_io(mdev, &drbd_bmio_set_n_write,
+				"set_n_write from invalidate", BM_LOCKED_MASK))
+				retcode = ERR_IO_MD_DISK;
+		}
+	} else
+		retcode = drbd_request_state(mdev, NS(conn, C_STARTING_SYNC_T));
 	drbd_resume_io(mdev);
 
 out:
@@ -2519,21 +2512,22 @@ int drbd_adm_invalidate_peer(struct sk_buff *skb, struct genl_info *info)
 	wait_event(mdev->misc_wait, !test_bit(BITMAP_IO, &mdev->flags));
 	drbd_flush_workqueue(mdev);
 
-	retcode = _drbd_request_state(mdev, NS(conn, C_STARTING_SYNC_S), CS_ORDERED);
-	if (retcode < SS_SUCCESS) {
-		if (mdev->state.conn == C_STANDALONE && mdev->state.role == R_PRIMARY) {
-			/* The peer will get a resync upon connect anyways. Just make that
-			   into a full resync. */
-			retcode = drbd_request_state(mdev, NS(pdsk, D_INCONSISTENT));
-			if (retcode >= SS_SUCCESS) {
-				if (drbd_bitmap_io(mdev, &drbd_bmio_set_susp_al,
-						   "set_n_write from invalidate_peer",
-						   BM_LOCKED_SET_ALLOWED))
-					retcode = ERR_IO_MD_DISK;
-			}
-		} else
-			retcode = drbd_request_state(mdev, NS(conn, C_STARTING_SYNC_S));
-	}
+	/* If we happen to be C_STANDALONE R_PRIMARY, just set all bits
+	 * in the bitmap.  Otherwise, try to start a resync handshake
+	 * as sync source for full sync.
+	 */
+	if (mdev->state.conn == C_STANDALONE && mdev->state.role == R_PRIMARY) {
+		/* The peer will get a resync upon connect anyways. Just make that
+		   into a full resync. */
+		retcode = drbd_request_state(mdev, NS(pdsk, D_INCONSISTENT));
+		if (retcode >= SS_SUCCESS) {
+			if (drbd_bitmap_io(mdev, &drbd_bmio_set_susp_al,
+				"set_n_write from invalidate_peer",
+				BM_LOCKED_SET_ALLOWED))
+				retcode = ERR_IO_MD_DISK;
+		}
+	} else
+		retcode = drbd_request_state(mdev, NS(conn, C_STARTING_SYNC_S));
 	drbd_resume_io(mdev);
 
 out:
-- 
1.7.9.5

