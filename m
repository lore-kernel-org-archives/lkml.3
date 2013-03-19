Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933442Ab3CSRSZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 13:18:25 -0400
Received: from mail09.linbit.com ([212.69.161.110]:44782 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933372Ab3CSRRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 13:17:06 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, drbd-dev@lists.linbit.com,
        lars.ellenberg@linbit.com
Subject: [PATCH 16/18] drbd: move start io accounting before activity log transaction
Date: Tue, 19 Mar 2013 18:16:57 +0100
Message-Id: <1363713419-17803-17-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363713419-17803-1-git-send-email-philipp.reisner@linbit.com>
References: <1363713419-17803-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

The IO accounting of the drbd "queue depth" was misleading.
We only started IO accounting once we already wrote the activity log.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_req.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index b923d41..d72f2fe 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -1056,6 +1056,9 @@ drbd_request_prepare(struct drbd_conf *mdev, struct bio *bio, unsigned long star
 		req->private_bio = NULL;
 	}
 
+	/* Update disk stats */
+	_drbd_start_io_acct(mdev, req);
+
 	if (rw == WRITE && req->private_bio && req->i.size
 	&& !test_bit(AL_SUSPENDED, &mdev->flags)) {
 		if (!drbd_al_begin_io_fastpath(mdev, &req->i)) {
@@ -1095,9 +1098,6 @@ static void drbd_send_and_submit(struct drbd_conf *mdev, struct drbd_request *re
 		goto out;
 	}
 
-	/* Update disk stats */
-	_drbd_start_io_acct(mdev, req);
-
 	/* We fail READ/READA early, if we can not serve it.
 	 * We must do this before req is registered on any lists.
 	 * Otherwise, drbd_req_complete() will queue failed READ for retry. */
-- 
1.7.9.5

