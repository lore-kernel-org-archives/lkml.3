Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758188Ab3LWWFF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 17:05:05 -0500
Received: from zimbra13.linbit.com ([212.69.166.240]:60674 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932331Ab3LWV6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 16:58:54 -0500
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 03/27] drbd: drbd_adm_prepare(): Only set adm_ctx.connection when a connection is requested
Date: Mon, 23 Dec 2013 22:50:32 +0100
Message-Id: <1387835456-29695-4-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387835456-29695-1-git-send-email-philipp.reisner@linbit.com>
References: <1387835456-29695-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Also change drbd_adm_connect() to expect a resource after it requested one.

Signed-off-by: Andreas Gruenbacher <agruen@linbit.com>
Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
---
 drivers/block/drbd/drbd_nl.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 26051c6..372efd5 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -216,10 +216,6 @@ static int drbd_adm_prepare(struct sk_buff *skb, struct genl_info *info,
 	adm_ctx.device = minor_to_device(d_in->minor);
 	if (adm_ctx.resource_name) {
 		adm_ctx.resource = drbd_find_resource(adm_ctx.resource_name);
-		if (adm_ctx.resource) {
-			adm_ctx.connection = first_connection(adm_ctx.resource);
-			kref_get(&adm_ctx.connection->kref);
-		}
 	}
 
 	if (!adm_ctx.device && (flags & DRBD_ADM_NEED_MINOR)) {
@@ -234,7 +230,7 @@ static int drbd_adm_prepare(struct sk_buff *skb, struct genl_info *info,
 	}
 
 	if (flags & DRBD_ADM_NEED_CONNECTION) {
-		if (adm_ctx.connection && !(flags & DRBD_ADM_NEED_RESOURCE)) {
+		if (adm_ctx.resource) {
 			drbd_msg_put_info("no resource name expected");
 			return ERR_INVALID_REQUEST;
 		}
@@ -2211,7 +2207,7 @@ int drbd_adm_connect(struct sk_buff *skb, struct genl_info *info)
 		}
 	}
 
-	connection = adm_ctx.connection;
+	connection = first_connection(adm_ctx.resource);
 	conn_reconfig_start(connection);
 
 	if (connection->cstate > C_STANDALONE) {
-- 
1.7.9.5

