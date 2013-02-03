Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab3BCBey (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 20:34:54 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:41882 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281Ab3BCBVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 20:21:43 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, bfields@fieldses.org,
        skinsbursky@parallels.com, ebiederm@xmission.com, jmorris@namei.org,
        axboe@kernel.dk, Tejun Heo <tj@kernel.org>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net
Subject: [PATCH 13/62] firewire: convert to idr_alloc()
Date: Sat,  2 Feb 2013 17:20:14 -0800
Message-Id: <1359854463-2538-14-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359854463-2538-1-git-send-email-tj@kernel.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net
---
This patch depends on an earlier idr changes and I think it would be
best to route these together through -mm.  Please holler if there's
any objection.  Thanks.

 drivers/firewire/core-cdev.c   | 16 +++++++---------
 drivers/firewire/core-device.c |  5 ++---
 2 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/firewire/core-cdev.c b/drivers/firewire/core-cdev.c
index 68c3138..46a1f88 100644
--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -490,24 +490,22 @@ static int add_client_resource(struct client *client,
 	unsigned long flags;
 	int ret;
 
- retry:
-	if (idr_pre_get(&client->resource_idr, gfp_mask) == 0)
-		return -ENOMEM;
-
+	idr_preload(gfp_mask);
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
+	idr_preload_end();
 
 	return ret < 0 ? ret : 0;
 }
diff --git a/drivers/firewire/core-device.c b/drivers/firewire/core-device.c
index 3873d53..c137de6 100644
--- a/drivers/firewire/core-device.c
+++ b/drivers/firewire/core-device.c
@@ -1017,13 +1017,12 @@ static void fw_device_init(struct work_struct *work)
 
 	fw_device_get(device);
 	down_write(&fw_device_rwsem);
-	ret = idr_pre_get(&fw_device_idr, GFP_KERNEL) ?
-	      idr_get_new(&fw_device_idr, device, &minor) :
-	      -ENOMEM;
+	ret = idr_alloc(&fw_device_idr, device, 0, 0, GFP_KERNEL);
 	up_write(&fw_device_rwsem);
 
 	if (ret < 0)
 		goto error;
+	minor = ret;
 
 	device->device.bus = &fw_bus_type;
 	device->device.type = &fw_device_type;
-- 
1.8.1

