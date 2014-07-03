Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868AbaGCInU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 04:43:20 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:45864 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477AbaGCInS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 04:43:18 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 02/23] drbd: fix drbd_destroy_device reference count updates
Date: Thu,  3 Jul 2014 10:42:54 +0200
Message-Id: <1404376995-4877-3-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404376995-4877-1-git-send-email-philipp.reisner@linbit.com>
References: <1404376995-4877-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

drbd_destroy_device means to give up reference counts
on the connection(s) reachable via the peer_device(s).

It must not do that by iterating via device->resource->connections,
resource and connections may have already been disassociated
by drbd_free_resource, and we'd leak connection refs.

Instead, iterate via device->peer_devices->connection.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_main.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 92547d1..56cf11b 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2160,7 +2160,7 @@ void drbd_destroy_device(struct kref *kref)
 {
 	struct drbd_device *device = container_of(kref, struct drbd_device, kref);
 	struct drbd_resource *resource = device->resource;
-	struct drbd_connection *connection;
+	struct drbd_peer_device *peer_device, *tmp_peer_device;
 
 	del_timer_sync(&device->request_timer);
 
@@ -2191,12 +2191,16 @@ void drbd_destroy_device(struct kref *kref)
 	put_disk(device->vdisk);
 	blk_cleanup_queue(device->rq_queue);
 	kfree(device->rs_plan_s);
-	kfree(first_peer_device(device));
+
+	/* not for_each_connection(connection, resource):
+	 * those may have been cleaned up and disassociated already.
+	 */
+	for_each_peer_device_safe(peer_device, tmp_peer_device, device) {
+		kref_put(&peer_device->connection->kref, drbd_destroy_connection);
+		kfree(peer_device);
+	}
 	memset(device, 0xfd, sizeof(*device));
 	kfree(device);
-
-	for_each_connection(connection, resource)
-		kref_put(&connection->kref, drbd_destroy_connection);
 	kref_put(&resource->kref, drbd_destroy_resource);
 }
 
-- 
1.9.1

