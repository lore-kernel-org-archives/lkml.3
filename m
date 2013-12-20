Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932689Ab3LTMnZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 07:43:25 -0500
Received: from mail09.linbit.com ([212.69.161.110]:38650 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932382Ab3LTMj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 07:39:27 -0500
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 23/26] drbd: Rename drbd_{create,delete}_minor -> drbd_{create,delete}_device
Date: Fri, 20 Dec 2013 13:29:20 +0100
Message-Id: <1387542563-6833-24-git-send-email-philipp.reisner@linbit.com>
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
 drivers/block/drbd/drbd_int.h  |    4 ++--
 drivers/block/drbd/drbd_main.c |    6 +++---
 drivers/block/drbd/drbd_nl.c   |    4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 3d1fb33..7021621 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1234,9 +1234,9 @@ extern struct bio *bio_alloc_drbd(gfp_t gfp_mask);
 extern rwlock_t global_state_lock;
 
 extern int conn_lowest_minor(struct drbd_connection *connection);
-enum drbd_ret_code drbd_create_minor(struct drbd_connection *connection, unsigned int minor, int vnr);
+enum drbd_ret_code drbd_create_device(struct drbd_connection *connection, unsigned int minor, int vnr);
 extern void drbd_destroy_device(struct kref *kref);
-extern void drbd_delete_minor(struct drbd_device *mdev);
+extern void drbd_delete_device(struct drbd_device *mdev);
 
 extern struct drbd_resource *drbd_create_resource(const char *name);
 extern void drbd_free_resource(struct drbd_resource *resource);
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 72ead5b..7cab345 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2329,7 +2329,7 @@ static void drbd_cleanup(void)
 	drbd_genl_unregister();
 
 	idr_for_each_entry(&drbd_devices, device, i)
-		drbd_delete_minor(device);
+		drbd_delete_device(device);
 
 	/* not _rcu since, no other updater anymore. Genl already unregistered */
 	for_each_resource_safe(resource, tmp, &drbd_resources) {
@@ -2661,7 +2661,7 @@ int init_submitter(struct drbd_device *device)
 	return 0;
 }
 
-enum drbd_ret_code drbd_create_minor(struct drbd_connection *connection, unsigned int minor, int vnr)
+enum drbd_ret_code drbd_create_device(struct drbd_connection *connection, unsigned int minor, int vnr)
 {
 	struct drbd_resource *resource = connection->resource;
 	struct drbd_device *device;
@@ -2811,7 +2811,7 @@ out_no_peer_device:
 	return err;
 }
 
-void drbd_delete_minor(struct drbd_device *device)
+void drbd_delete_device(struct drbd_device *device)
 {
 	struct drbd_resource *resource = device->resource;
 	struct drbd_connection *connection;
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index c8604e7..12a65ce 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -3328,7 +3328,7 @@ int drbd_adm_new_minor(struct sk_buff *skb, struct genl_info *info)
 		goto out;
 	}
 
-	retcode = drbd_create_minor(adm_ctx.connection, dh->minor, adm_ctx.volume);
+	retcode = drbd_create_device(adm_ctx.connection, dh->minor, adm_ctx.volume);
 out:
 	drbd_adm_finish(info, retcode);
 	return 0;
@@ -3343,7 +3343,7 @@ static enum drbd_ret_code adm_del_minor(struct drbd_device *device)
 	    device->state.role == R_SECONDARY) {
 		_drbd_request_state(device, NS(conn, C_WF_REPORT_PARAMS),
 				    CS_VERBOSE + CS_WAIT_COMPLETE);
-		drbd_delete_minor(device);
+		drbd_delete_device(device);
 		return NO_ERROR;
 	} else
 		return ERR_MINOR_CONFIGURED;
-- 
1.7.9.5

