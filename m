Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932423Ab3LTMji (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 07:39:38 -0500
Received: from mail09.linbit.com ([212.69.161.110]:38634 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932360Ab3LTMj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 07:39:27 -0500
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 13/26] drbd: Minor cleanup in conn_new_minor()
Date: Fri, 20 Dec 2013 13:29:10 +0100
Message-Id: <1387542563-6833-14-git-send-email-philipp.reisner@linbit.com>
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
 drivers/block/drbd/drbd_main.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index e8ffb68..1ce1066 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2664,8 +2664,7 @@ enum drbd_ret_code drbd_create_minor(struct drbd_connection *connection, unsigne
 	struct drbd_peer_device *peer_device;
 	struct gendisk *disk;
 	struct request_queue *q;
-	int vnr_got = vnr;
-	int minor_got = minor;
+	int id;
 	enum drbd_ret_code err = ERR_NOMEM;
 
 	device = minor_to_device(minor);
@@ -2737,18 +2736,18 @@ enum drbd_ret_code drbd_create_minor(struct drbd_connection *connection, unsigne
 	device->read_requests = RB_ROOT;
 	device->write_requests = RB_ROOT;
 
-	minor_got = idr_alloc(&drbd_devices, device, minor, minor + 1, GFP_KERNEL);
-	if (minor_got < 0) {
-		if (minor_got == -ENOSPC) {
+	id = idr_alloc(&drbd_devices, device, minor, minor + 1, GFP_KERNEL);
+	if (id < 0) {
+		if (id == -ENOSPC) {
 			err = ERR_MINOR_EXISTS;
 			drbd_msg_put_info("requested minor exists already");
 		}
 		goto out_no_minor_idr;
 	}
 
-	vnr_got = idr_alloc(&connection->volumes, device, vnr, vnr + 1, GFP_KERNEL);
-	if (vnr_got < 0) {
-		if (vnr_got == -ENOSPC) {
+	id = idr_alloc(&connection->volumes, device, vnr, vnr + 1, GFP_KERNEL);
+	if (id < 0) {
+		if (id == -ENOSPC) {
 			err = ERR_INVALID_REQUEST;
 			drbd_msg_put_info("requested volume exists already");
 		}
@@ -2772,9 +2771,9 @@ enum drbd_ret_code drbd_create_minor(struct drbd_connection *connection, unsigne
 	return NO_ERROR;
 
 out_idr_remove_vol:
-	idr_remove(&connection->volumes, vnr_got);
+	idr_remove(&connection->volumes, vnr);
 out_idr_remove_minor:
-	idr_remove(&drbd_devices, minor_got);
+	idr_remove(&drbd_devices, minor);
 	synchronize_rcu();
 out_no_minor_idr:
 	drbd_bm_cleanup(device);
-- 
1.7.9.5

