Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239AbaGCInX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 04:43:23 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:45858 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194AbaGCInS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 04:43:18 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 01/23] drbd: poison free'd device, resource and connection structs
Date: Thu,  3 Jul 2014 10:42:53 +0200
Message-Id: <1404376995-4877-2-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404376995-4877-1-git-send-email-philipp.reisner@linbit.com>
References: <1404376995-4877-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

Now that we have additional asynchronous kref_get/kref_put
via debugfs, make sure we catch access after free.

Poison struct drbd_device, drbd_connection and drbd_resource
before kfree() with 0xfd, 0xfc, and 0xf2, respectively.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 686c5a5..92547d1 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2192,6 +2192,7 @@ void drbd_destroy_device(struct kref *kref)
 	blk_cleanup_queue(device->rq_queue);
 	kfree(device->rs_plan_s);
 	kfree(first_peer_device(device));
+	memset(device, 0xfd, sizeof(*device));
 	kfree(device);
 
 	for_each_connection(connection, resource)
@@ -2285,6 +2286,7 @@ void drbd_destroy_resource(struct kref *kref)
 	idr_destroy(&resource->devices);
 	free_cpumask_var(resource->cpu_mask);
 	kfree(resource->name);
+	memset(resource, 0xf2, sizeof(*resource));
 	kfree(resource);
 }
 
@@ -2665,6 +2667,7 @@ void drbd_destroy_connection(struct kref *kref)
 	drbd_free_socket(&connection->data);
 	kfree(connection->int_dig_in);
 	kfree(connection->int_dig_vv);
+	memset(connection, 0xfc, sizeof(*connection));
 	kfree(connection);
 	kref_put(&resource->kref, drbd_destroy_resource);
 }
-- 
1.9.1

