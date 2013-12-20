Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932406Ab3LTMjg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 07:39:36 -0500
Received: from mail09.linbit.com ([212.69.161.110]:38638 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932361Ab3LTMj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 07:39:27 -0500
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 11/26] drbd: drbd_adm_down(): Move valid resource name check to drbd_adm_prepare()
Date: Fri, 20 Dec 2013 13:29:08 +0100
Message-Id: <1387542563-6833-12-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387542563-6833-1-git-send-email-philipp.reisner@linbit.com>
References: <1387542563-6833-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Andreas Gruenbacher <agruen@linbit.com>
Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
---
 drivers/block/drbd/drbd_nl.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index a332399..7e22046 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -221,6 +221,8 @@ static int drbd_adm_prepare(struct sk_buff *skb, struct genl_info *info,
 	}
 	if (!adm_ctx.connection && (flags & DRBD_ADM_NEED_RESOURCE)) {
 		drbd_msg_put_info("unknown resource");
+		if (adm_ctx.resource_name)
+			return ERR_RES_NOT_KNOWN;
 		return ERR_INVALID_REQUEST;
 	}
 
@@ -3355,17 +3357,12 @@ int drbd_adm_down(struct sk_buff *skb, struct genl_info *info)
 	struct drbd_device *device;
 	unsigned i;
 
-	retcode = drbd_adm_prepare(skb, info, 0);
+	retcode = drbd_adm_prepare(skb, info, DRBD_ADM_NEED_RESOURCE);
 	if (!adm_ctx.reply_skb)
 		return retcode;
 	if (retcode != NO_ERROR)
 		goto out;
 
-	if (!adm_ctx.connection) {
-		retcode = ERR_RES_NOT_KNOWN;
-		goto out;
-	}
-
 	/* demote */
 	idr_for_each_entry(&adm_ctx.connection->volumes, device, i) {
 		retcode = drbd_set_role(device, R_SECONDARY, 0);
-- 
1.7.9.5

