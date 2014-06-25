Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524AbaFYPwm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 11:52:42 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:45934 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757441AbaFYPwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 11:52:41 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH] drbd: fix NULL pointer deref in blk_add_request_payload
Date: Wed, 25 Jun 2014 17:52:38 +0200
Message-Id: <1403711558-27267-2-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403711558-27267-1-git-send-email-philipp.reisner@linbit.com>
References: <1403711558-27267-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

Discards don't have any payload.
But the scsi layer still expects a bio_vec it can use internally,
see sd_setup_discard_cmnd() and blk_add_request_payload().

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_receiver.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index b6c8aaf..5b17ec8 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -1337,8 +1337,11 @@ int drbd_submit_peer_request(struct drbd_device *device,
 		return 0;
 	}
 
+	/* Discards don't have any payload.
+	 * But the scsi layer still expects a bio_vec it can use internally,
+	 * see sd_setup_discard_cmnd() and blk_add_request_payload(). */
 	if (peer_req->flags & EE_IS_TRIM)
-		nr_pages = 0; /* discards don't have any payload. */
+		nr_pages = 1;
 
 	/* In most cases, we will only need one bio.  But in case the lower
 	 * level restrictions happen to be different at this offset on this
-- 
1.9.1

