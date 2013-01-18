Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888Ab3ARBkO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 20:40:14 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:49356 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446Ab3ARBkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 20:40:11 -0500
From: Grant Likely <grant.likely@secretlab.ca>
To: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 2/2] of: use platform_device_add
Date: Fri, 18 Jan 2013 01:40:00 +0000
Message-Id: <1358473200-17886-2-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358473200-17886-1-git-send-email-grant.likely@secretlab.ca>
References: <1358473200-17886-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows platform_device_add a chance to call insert_resource on all
of the resources from OF. At a minimum this fills in proc/iomem and
presumably makes resource tracking and conflict detection work better.
However, it has the side effect of moving all OF generated platform
devices from /sys/devices to /sys/devices/platform/. It /shouldn't/
break userspace because userspace is not supposed to depend on the full
path (because userspace always does what it is supposed to, right?).

This may cause breakage if either:
1) any two nodes in a given device tree have overlapping & staggered
   regions (ie. 0x80..0xbf and 0xa0..0xdf; where one is not contained
   within the other). In this case one of the devices will fail to
   register and an exception will be needed in platform_device_add() to
   complain but not fail.
2) any device calls request_mem_region() on a region larger than
   specified in the device tree. In this case the device node may be
   wrong, or the driver is overreaching. In either case I'd like to know
   about any problems and fix them.

Please test. Despite the above, I'm still fairly confident that this
patch is in good shape. I'd like to put it into linux-next, but would
appreciate some bench testing from others before I do; particularly on
PowerPC machines.

v2: Remove powerpc special-case

Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/of/platform.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index b80891b..3c3e3ca 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -203,6 +203,7 @@ struct platform_device *of_platform_device_create_pdata(
 					struct device *parent)
 {
 	struct platform_device *dev;
+	int rc;
 
 	if (!of_device_is_available(np))
 		return NULL;
@@ -214,16 +215,24 @@ struct platform_device *of_platform_device_create_pdata(
 #if defined(CONFIG_MICROBLAZE)
 	dev->archdata.dma_mask = 0xffffffffUL;
 #endif
+	dev->name = dev_name(&dev->dev);
 	dev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
-	dev->dev.bus = &platform_bus_type;
 	dev->dev.platform_data = platform_data;
+	dev->dev.id = PLATFORM_DEVID_NONE;
+	/* device_add will assume that this device is on the same node as
+	 * the parent. If there is no parent defined, set the node
+	 * explicitly */
+	if (!parent)
+		set_dev_node(&dev->dev, of_node_to_nid(np));
 
 	/* We do not fill the DMA ops for platform devices by default.
 	 * This is currently the responsibility of the platform code
 	 * to do such, possibly using a device notifier
 	 */
 
-	if (of_device_add(dev) != 0) {
+	rc = platform_device_add(dev);
+	if (rc) {
+		dev_err(&dev->dev, "device registration failed\n");
 		platform_device_put(dev);
 		return NULL;
 	}
-- 
1.7.10.4

