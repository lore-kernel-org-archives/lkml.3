Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797Ab3JWJJX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 05:09:23 -0400
Received: from mail09.linbit.com ([212.69.161.110]:48163 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612Ab3JWJJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 05:09:21 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>,
        Philipp Reisner <philipp.reisner@linbit.com>
Subject: [PATCH 5/5] drbd: avoid to shrink max_bio_size due to peer re-configuration
Date: Wed, 23 Oct 2013 10:59:19 +0200
Message-Id: <1382518759-5467-6-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1382518759-5467-1-git-send-email-philipp.reisner@linbit.com>
References: <1382518759-5467-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

For a long time, the receiving side has spread "too large" incoming
requests over multiple bios.  No need to shrink our max_bio_size
(max_hw_sectors) if the peer is reconfigured to use a different storage.

The problem manifests itself if we are not the top of the device stack
(DRBD is used a LVM PV).

A hardware reconfiguration on the peer may cause the supported
max_bio_size to shrink, and the connection handshake would now
unnecessarily shrink the max_bio_size on the active node.

There is no way to notify upper layers that they have to "re-stack"
their limits. So they won't notice at all, and may keep submitting bios
that are suddenly considered "too large for device".

We already check for compatibility and ignore changes on the peer,
the code only was masked out unless we have a fully established connection.
We just need to allow it a bit earlier during the handshake.

Also consider max_hw_sectors in our merge bvec function, just in case.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_nl.c  |    4 ++--
 drivers/block/drbd/drbd_req.c |    3 +++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 37dad18..c706d50 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1132,9 +1132,9 @@ void drbd_reconsider_max_bio_size(struct drbd_conf *mdev)
 	/* We may ignore peer limits if the peer is modern enough.
 	   Because new from 8.3.8 onwards the peer can use multiple
 	   BIOs for a single peer_request */
-	if (mdev->state.conn >= C_CONNECTED) {
+	if (mdev->state.conn >= C_WF_REPORT_PARAMS) {
 		if (mdev->tconn->agreed_pro_version < 94)
-			peer = min( mdev->peer_max_bio_size, DRBD_MAX_SIZE_H80_PACKET);
+			peer = min(mdev->peer_max_bio_size, DRBD_MAX_SIZE_H80_PACKET);
 			/* Correct old drbd (up to 8.3.7) if it believes it can do more than 32KiB */
 		else if (mdev->tconn->agreed_pro_version == 94)
 			peer = DRBD_MAX_SIZE_H80_PACKET;
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index c24379f..fec7bef 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -1306,6 +1306,7 @@ int drbd_merge_bvec(struct request_queue *q, struct bvec_merge_data *bvm, struct
 	int backing_limit;
 
 	if (bio_size && get_ldev(mdev)) {
+		unsigned int max_hw_sectors = queue_max_hw_sectors(q);
 		struct request_queue * const b =
 			mdev->ldev->backing_bdev->bd_disk->queue;
 		if (b->merge_bvec_fn) {
@@ -1313,6 +1314,8 @@ int drbd_merge_bvec(struct request_queue *q, struct bvec_merge_data *bvm, struct
 			limit = min(limit, backing_limit);
 		}
 		put_ldev(mdev);
+		if ((limit >> 9) > max_hw_sectors)
+			limit = max_hw_sectors << 9;
 	}
 	return limit;
 }
-- 
1.7.9.5

