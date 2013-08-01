Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757945Ab3HAWSm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 18:18:42 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39837 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757283Ab3HAWSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 18:18:41 -0400
In-Reply-To: <20130801213420.GL23006@n2100.arm.linux.org.uk>
References: <20130801213420.GL23006@n2100.arm.linux.org.uk>
From: Russell King <rmk+kernel@arm.linux.org.uk>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH RFC 44/51] DMA-API: dcdbas: update DMA mask handing
Message-Id: <E1V51CI-0006uA-3H@rmk-PC.arm.linux.org.uk>
Date: Thu, 01 Aug 2013 23:18:14 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dcdbas was explicitly initializing DMA masks thusly:
	dcdbas_pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
	dcdbas_pdev->dev.dma_mask = &dcdbas_pdev->dev.coherent_dma_mask;
which bypasses the architecture check.  Moreover, it is creating the
dcdbas_pdev device itself, and using the platform_device_register_full()
avoids some of this explicit initialization.

Convert the driver to use platform_device_register_full(), and as it
makes use of coherent DMA, also call dma_set_coherent_mask() to ensure
that the architecture gets to check the mask.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/firmware/dcdbas.c |   23 ++++++++++++-----------
 1 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/firmware/dcdbas.c b/drivers/firmware/dcdbas.c
index 8e77c02..61969cd 100644
--- a/drivers/firmware/dcdbas.c
+++ b/drivers/firmware/dcdbas.c
@@ -548,8 +548,9 @@ static int dcdbas_probe(struct platform_device *dev)
 	 * BIOS SMI calls require buffer addresses be in 32-bit address space.
 	 * This is done by setting the DMA mask below.
 	 */
-	dcdbas_pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
-	dcdbas_pdev->dev.dma_mask = &dcdbas_pdev->dev.coherent_dma_mask;
+	error = dma_set_coherent_mask(&dcdbas_pdev->dev, DMA_BIT_MASK(32));
+	if (error)
+		return error;
 
 	error = sysfs_create_group(&dev->dev.kobj, &dcdbas_attr_group);
 	if (error)
@@ -596,6 +597,12 @@ static struct platform_driver dcdbas_driver = {
 	.remove		= dcdbas_remove,
 };
 
+static const struct platform_device_info dcdbas_dev_info __initdata = {
+	.name		= DRIVER_NAME,
+	.id		= -1,
+	.dma_mask	= DMA_BIT_MASK(32),
+};
+
 /**
  * dcdbas_init: initialize driver
  */
@@ -607,20 +614,14 @@ static int __init dcdbas_init(void)
 	if (error)
 		return error;
 
-	dcdbas_pdev = platform_device_alloc(DRIVER_NAME, -1);
-	if (!dcdbas_pdev) {
-		error = -ENOMEM;
+	dcdbas_pdev = platform_device_register_full(&dcdbas_dev_info);
+	if (IS_ERR(dcdbas_pdev)) {
+		error = PTR_ERR(dcdbas_pdev);
 		goto err_unregister_driver;
 	}
 
-	error = platform_device_add(dcdbas_pdev);
-	if (error)
-		goto err_free_device;
-
 	return 0;
 
- err_free_device:
-	platform_device_put(dcdbas_pdev);
  err_unregister_driver:
 	platform_driver_unregister(&dcdbas_driver);
 	return error;
-- 
1.7.4.4

