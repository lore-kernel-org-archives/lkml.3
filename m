Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbaKJQVb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 11:21:31 -0500
Received: from zimbra13.linbit.com ([212.69.166.240]:54034 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422AbaKJQVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 11:21:19 -0500
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 2/7] drbd: Only use drbd_msg_put_info() in drbd_nl.c
Date: Mon, 10 Nov 2014 17:21:10 +0100
Message-Id: <1415636475-7883-3-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415636475-7883-1-git-send-email-philipp.reisner@linbit.com>
References: <1415636475-7883-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Avoid generic netlink calls in other parts of the code base.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h  |  1 -
 drivers/block/drbd/drbd_main.c | 17 +++--------------
 drivers/block/drbd/drbd_nl.c   |  2 +-
 3 files changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index c14b718..d2a7589 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1454,7 +1454,6 @@ extern int is_valid_ar_handle(struct drbd_request *, sector_t);
 
 
 /* drbd_nl.c */
-extern int drbd_msg_put_info(struct sk_buff *skb, const char *info);
 extern void drbd_suspend_io(struct drbd_device *device);
 extern void drbd_resume_io(struct drbd_device *device);
 extern char *ppsize(char *buf, unsigned long long size);
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index cce25a5..1fc8342 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2532,10 +2532,6 @@ int set_resource_options(struct drbd_resource *resource, struct res_opts *res_op
 
 	if (!zalloc_cpumask_var(&new_cpu_mask, GFP_KERNEL))
 		return -ENOMEM;
-		/*
-		retcode = ERR_NOMEM;
-		drbd_msg_put_info("unable to allocate cpumask");
-		*/
 
 	/* silently ignore cpu mask on UP kernel */
 	if (nr_cpu_ids > 1 && res_opts->cpu_mask[0] != 0) {
@@ -2793,20 +2789,16 @@ enum drbd_ret_code drbd_create_device(struct drbd_config_context *adm_ctx, unsig
 
 	id = idr_alloc(&drbd_devices, device, minor, minor + 1, GFP_KERNEL);
 	if (id < 0) {
-		if (id == -ENOSPC) {
+		if (id == -ENOSPC)
 			err = ERR_MINOR_OR_VOLUME_EXISTS;
-			drbd_msg_put_info(adm_ctx->reply_skb, "requested minor exists already");
-		}
 		goto out_no_minor_idr;
 	}
 	kref_get(&device->kref);
 
 	id = idr_alloc(&resource->devices, device, vnr, vnr + 1, GFP_KERNEL);
 	if (id < 0) {
-		if (id == -ENOSPC) {
+		if (id == -ENOSPC)
 			err = ERR_MINOR_OR_VOLUME_EXISTS;
-			drbd_msg_put_info(adm_ctx->reply_skb, "requested minor exists already");
-		}
 		goto out_idr_remove_minor;
 	}
 	kref_get(&device->kref);
@@ -2825,10 +2817,8 @@ enum drbd_ret_code drbd_create_device(struct drbd_config_context *adm_ctx, unsig
 
 		id = idr_alloc(&connection->peer_devices, peer_device, vnr, vnr + 1, GFP_KERNEL);
 		if (id < 0) {
-			if (id == -ENOSPC) {
+			if (id == -ENOSPC)
 				err = ERR_INVALID_REQUEST;
-				drbd_msg_put_info(adm_ctx->reply_skb, "requested volume exists already");
-			}
 			goto out_idr_remove_from_resource;
 		}
 		kref_get(&connection->kref);
@@ -2836,7 +2826,6 @@ enum drbd_ret_code drbd_create_device(struct drbd_config_context *adm_ctx, unsig
 
 	if (init_submitter(device)) {
 		err = ERR_NOMEM;
-		drbd_msg_put_info(adm_ctx->reply_skb, "unable to create submit workqueue");
 		goto out_idr_remove_vol;
 	}
 
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index c145619..4782d07 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -92,7 +92,7 @@ static void drbd_adm_send_reply(struct sk_buff *skb, struct genl_info *info)
 
 /* Used on a fresh "drbd_adm_prepare"d reply_skb, this cannot fail: The only
  * reason it could fail was no space in skb, and there are 4k available. */
-int drbd_msg_put_info(struct sk_buff *skb, const char *info)
+static int drbd_msg_put_info(struct sk_buff *skb, const char *info)
 {
 	struct nlattr *nla;
 	int err = -EMSGSIZE;
-- 
1.9.1

