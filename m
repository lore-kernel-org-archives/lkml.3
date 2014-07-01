Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758278AbaGAQSA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 12:18:00 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:53128 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758149AbaGAQQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 12:16:56 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 20/20] drbd: also keep track of trim -> zero-out fallback peer_requests
Date: Tue,  1 Jul 2014 18:16:50 +0200
Message-Id: <1404231410-29852-21-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404231410-29852-1-git-send-email-philipp.reisner@linbit.com>
References: <1404231410-29852-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

To be able to find and present such zero-out fallback peer_requests
in debugfs, we add those to "active_ee", once that list drained.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_receiver.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index db5c580..7a1078d 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -1370,6 +1370,11 @@ int drbd_submit_peer_request(struct drbd_device *device,
 		/* wait for all pending IO completions, before we start
 		 * zeroing things out. */
 		conn_wait_active_ee_empty(first_peer_device(device)->connection);
+		/* add it to the active list now,
+		 * so we can find it to present it in debugfs */
+		spin_lock_irq(&device->resource->req_lock);
+		list_add_tail(&peer_req->w.list, &device->active_ee);
+		spin_unlock_irq(&device->resource->req_lock);
 		if (blkdev_issue_zeroout(device->ldev->backing_bdev,
 			sector, ds >> 9, GFP_NOIO))
 			peer_req->flags |= EE_WAS_ERROR;
-- 
1.9.1

