Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049AbaF3PxP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 11:53:15 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:49987 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbaF3PxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 11:53:10 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 04/18] drbd: reduce number of spinlock drop/re-aquire cycles
Date: Mon, 30 Jun 2014 17:52:53 +0200
Message-Id: <1404143587-24344-5-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404143587-24344-1-git-send-email-philipp.reisner@linbit.com>
References: <1404143587-24344-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

Instead of dropping and re-aquiring the spinlock around the submit,
just remember that we want to submit, and do that only once we have
dropped the spinlock for good.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_req.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 09803d0..4c7fee1 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -1086,11 +1086,13 @@ drbd_request_prepare(struct drbd_device *device, struct bio *bio, unsigned long
 
 static void drbd_send_and_submit(struct drbd_device *device, struct drbd_request *req)
 {
+	struct drbd_resource *resource = device->resource;
 	const int rw = bio_rw(req->master_bio);
 	struct bio_and_error m = { NULL, };
 	bool no_remote = false;
+	bool submit_private_bio = false;
 
-	spin_lock_irq(&device->resource->req_lock);
+	spin_lock_irq(&resource->req_lock);
 	if (rw == WRITE) {
 		/* This may temporarily give up the req_lock,
 		 * but will re-aquire it before it returns here.
@@ -1152,9 +1154,7 @@ static void drbd_send_and_submit(struct drbd_device *device, struct drbd_request
 		/* needs to be marked within the same spinlock */
 		_req_mod(req, TO_BE_SUBMITTED);
 		/* but we need to give up the spinlock to submit */
-		spin_unlock_irq(&device->resource->req_lock);
-		drbd_submit_req_private_bio(req);
-		spin_lock_irq(&device->resource->req_lock);
+		submit_private_bio = true;
 	} else if (no_remote) {
 nodata:
 		if (__ratelimit(&drbd_ratelimit_state))
@@ -1167,8 +1167,16 @@ nodata:
 out:
 	if (drbd_req_put_completion_ref(req, &m, 1))
 		kref_put(&req->kref, drbd_req_destroy);
-	spin_unlock_irq(&device->resource->req_lock);
-
+	spin_unlock_irq(&resource->req_lock);
+
+	/* Even though above is a kref_put(), this is safe.
+	 * As long as we still need to submit our private bio,
+	 * we hold a completion ref, and the request cannot disappear.
+	 * If however this request did not even have a private bio to submit
+	 * (e.g. remote read), req may already be invalid now.
+	 * That's why we cannot check on req->private_bio. */
+	if (submit_private_bio)
+		drbd_submit_req_private_bio(req);
 	if (m.bio)
 		complete_master_bio(device, &m);
 }
-- 
1.9.1

