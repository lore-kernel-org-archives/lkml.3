Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932465Ab3LTMjn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 07:39:43 -0500
Received: from mail09.linbit.com ([212.69.161.110]:38637 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932356Ab3LTMj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 07:39:26 -0500
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 12/26] drbd: Add struct drbd_device->resource
Date: Fri, 20 Dec 2013 13:29:09 +0100
Message-Id: <1387542563-6833-13-git-send-email-philipp.reisner@linbit.com>
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
 drivers/block/drbd/drbd_int.h  |    1 +
 drivers/block/drbd/drbd_main.c |    1 +
 drivers/block/drbd/drbd_nl.c   |    4 ++--
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 7277d11..7a2f659 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -626,6 +626,7 @@ struct drbd_peer_device {
 };
 
 struct drbd_device {
+	struct drbd_resource *resource;
 	struct list_head peer_devices;
 	int vnr;			/* volume number within the connection */
 	struct kref kref;
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index fa7c471..e8ffb68 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2683,6 +2683,7 @@ enum drbd_ret_code drbd_create_minor(struct drbd_connection *connection, unsigne
 	INIT_LIST_HEAD(&device->peer_devices);
 	list_add(&peer_device->peer_devices, &device->peer_devices);
 	kref_get(&connection->kref);
+	device->resource = connection->resource;
 	peer_device->connection = connection;
 	peer_device->device = device;
 
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 7e22046..2cef34f 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -251,7 +251,7 @@ static int drbd_adm_prepare(struct sk_buff *skb, struct genl_info *info,
 	    first_peer_device(adm_ctx.device)->connection != adm_ctx.connection) {
 		pr_warning("request: minor=%u, resource=%s; but that minor belongs to connection %s\n",
 				adm_ctx.minor, adm_ctx.resource_name,
-				first_peer_device(adm_ctx.device)->connection->resource->name);
+				adm_ctx.device->resource->name);
 		drbd_msg_put_info("minor exists in different resource");
 		return ERR_INVALID_REQUEST;
 	}
@@ -261,7 +261,7 @@ static int drbd_adm_prepare(struct sk_buff *skb, struct genl_info *info,
 		pr_warning("request: minor=%u, volume=%u; but that minor is volume %u in %s\n",
 				adm_ctx.minor, adm_ctx.volume,
 				adm_ctx.device->vnr,
-				first_peer_device(adm_ctx.device)->connection->resource->name);
+				adm_ctx.device->resource->name);
 		drbd_msg_put_info("minor exists as different volume");
 		return ERR_INVALID_REQUEST;
 	}
-- 
1.7.9.5

