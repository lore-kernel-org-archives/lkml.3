Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152Ab3BDQ6N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 11:58:13 -0500
Received: from mail-vb0-f54.google.com ([209.85.212.54]:41411 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176Ab3BDQ6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 11:58:08 -0500
Date: Mon, 4 Feb 2013 08:58:03 -0800
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, bfields@fieldses.org,
        skinsbursky@parallels.com, ebiederm@xmission.com, jmorris@namei.org,
        axboe@kernel.dk, Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net
Subject: [PATCH v2 13/62] firewire: convert to idr_alloc()
Message-ID: <20130204165803.GH27963@mtj.dyndns.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
 <1359854463-2538-14-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359854463-2538-14-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

v2: Stefan pointed out that add_client_resource() may be called from
    non-process context.  Preload iff @gfp_mask contains __GFP_WAIT.
    Also updated to include minor upper limit check.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net
---
 drivers/firewire/core-cdev.c   |   19 ++++++++++---------
 drivers/firewire/core-device.c |    8 +-------
 2 files changed, 11 insertions(+), 16 deletions(-)

--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -487,27 +487,28 @@ static int ioctl_get_info(struct client
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
--- a/drivers/firewire/core-device.c
+++ b/drivers/firewire/core-device.c
@@ -1017,13 +1017,7 @@ static void fw_device_init(struct work_s
 
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
