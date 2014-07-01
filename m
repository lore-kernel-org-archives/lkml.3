Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964839AbaGAQV3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 12:21:29 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:53113 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757662AbaGAQQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 12:16:54 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 10/20] drbd: short-circuit in maybe_pull_ahead
Date: Tue,  1 Jul 2014 18:16:40 +0200
Message-Id: <1404231410-29852-11-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404231410-29852-1-git-send-email-philipp.reisner@linbit.com>
References: <1404231410-29852-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

If we already "pulled ahead", we can short-circuit,
and avoid logging the same messages over and over again.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_req.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index f07a724..3824d5c 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -899,6 +899,9 @@ static void maybe_pull_ahead(struct drbd_device *device)
 	    connection->agreed_pro_version < 96)
 		return;
 
+	if (on_congestion == OC_PULL_AHEAD && device->state.conn == C_AHEAD)
+		return; /* nothing to do ... */
+
 	/* If I don't even have good local storage, we can not reasonably try
 	 * to pull ahead of the peer. We also need the local reference to make
 	 * sure device->act_log is there.
-- 
1.9.1

