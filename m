Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030206Ab3BFUFm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 15:05:42 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37795 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030177Ab3BFTuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 14:50:11 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        linux1394-devel@lists.sourceforge.net
Subject: [PATCH 29/77] firewire: convert to idr_alloc()
Date: Wed,  6 Feb 2013 11:40:01 -0800
Message-Id: <1360179649-22465-30-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360179649-22465-1-git-send-email-tj@kernel.org>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

v2: Stefan pointed out that add_client_resource() may be called from
    non-process context.  Preload iff @gfp_mask contains __GFP_WAIT.
    Also updated to include minor upper limit check.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net
---
 drivers/firewire/core-cdev.c   | 19 ++++++++++---------
 drivers/firewire/core-device.c |  8 +-------
 2 files changed, 11 insertions(+), 16 deletions(-)

diff --git a/drivers/firewire/core-cdev.c b/drivers/firewire/core-cdev.c
index 68c3138..27ac423 100644
--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -487,27 +487,28 @@ static int ioctl_get_info(struct client *client, union ioctl_arg *arg)
 static int add_client_resource(struct client *client,
 			       struct client_resource *resource, gfp_t gfp_mask)
 {
+	bool preload = gfp_mask & __GFP_WAIT;
 	unsigned long flags;
 	int ret;
 
- retry:
-	if (idr_pre_get(&client->resource_idr, gfp_mask) == 0)
-		return -ENOMEM;
-
+	if (preload)
+		idr_preload(gfp_mask);
 	spin_lock_irqsave(&client->lock, flags);
+
 	if (client->in_shutdown)
 		ret = -ECANCELED;
 	else
-		ret = idr_get_new(&client->resource_idr, resource,
-				  &resource->handle);
+		ret = idr_alloc(&client->resource_idr, resource, 0, 0,
+				GFP_NOWAIT);
 	if (ret >= 0) {
+		resource->handle = ret;
 		client_get(client);
 		schedule_if_iso_resource(resource);
 	}
-	spin_unlock_irqrestore(&client->lock, flags);
 
-	if (ret == -EAGAIN)
-		goto retry;
+	spin_unlock_irqrestore(&client->lock, flags);
+	if (preload)
+		idr_preload_end();
 
 	return ret < 0 ? ret : 0;
 }
diff --git a/drivers/firewire/core-device.c b/drivers/firewire/core-device.c
index af3e8aa..b946330 100644
--- a/drivers/firewire/core-device.c
+++ b/drivers/firewire/core-device.c
@@ -1017,13 +1017,7 @@ static void fw_device_init(struct work_struct *work)
 
 	fw_device_get(device);
 	down_write(&fw_device_rwsem);
-	ret = idr_pre_get(&fw_device_idr, GFP_KERNEL) ?
-	      idr_get_new(&fw_device_idr, device, &minor) :
-	      -ENOMEM;
-	if (minor >= 1 << MINORBITS) {
-		idr_remove(&fw_device_idr, minor);
-		minor = -ENOSPC;
-	}
+	ret = idr_alloc(&fw_device_idr, device, 0, 1 << MINORBITS, GFP_KERNEL);
 	up_write(&fw_device_rwsem);
 
 	if (ret < 0)
-- 
1.8.1

