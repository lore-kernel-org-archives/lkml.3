Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757611Ab3HAWOk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 18:14:40 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39825 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507Ab3HAWOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 18:14:39 -0400
In-Reply-To: <20130801213420.GL23006@n2100.arm.linux.org.uk>
References: <20130801213420.GL23006@n2100.arm.linux.org.uk>
From: Russell King <rmk+kernel@arm.linux.org.uk>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH RFC 40/51] DMA-API: crypto: fix ixp4xx crypto platform device
 support
Message-Id: <E1V518O-0006te-9U@rmk-PC.arm.linux.org.uk>
Date: Thu, 01 Aug 2013 23:14:12 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't statically allocate struct device's in modules, and shut the
warning up with an empty release() function.  There's a reason that
warning is there and that's not for people to hide in this way.  It's
there to persuade people to use the correct APIs to allocate platform
devices.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/crypto/ixp4xx_crypto.c |   37 +++++++++++++++++--------------------
 1 files changed, 17 insertions(+), 20 deletions(-)

diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index 21180d6..8306185 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -218,23 +218,10 @@ static dma_addr_t crypt_phys;
 
 static int support_aes = 1;
 
-static void dev_release(struct device *dev)
-{
-	return;
-}
-
 #define DRIVER_NAME "ixp4xx_crypto"
-static struct platform_device pseudo_dev = {
-	.name = DRIVER_NAME,
-	.id   = 0,
-	.num_resources = 0,
-	.dev  = {
-		.coherent_dma_mask = DMA_BIT_MASK(32),
-		.release = dev_release,
-	}
-};
 
-static struct device *dev = &pseudo_dev.dev;
+static struct platform_device *pdev;
+static struct device *dev;
 
 static inline dma_addr_t crypt_virt2phys(struct crypt_ctl *virt)
 {
@@ -1418,20 +1405,30 @@ static struct ixp_alg ixp4xx_algos[] = {
 } };
 
 #define IXP_POSTFIX "-ixp4xx"
+
+static const struct platform_device_info ixp_dev_info __initdata = {
+	.name		= DRIVER_NAME,
+	.id		= 0,
+	.dma_mask	= DMA_BIT_MASK(32),
+};
+
 static int __init ixp_module_init(void)
 {
 	int num = ARRAY_SIZE(ixp4xx_algos);
-	int i,err ;
+	int i, err ;
 
-	if (platform_device_register(&pseudo_dev))
-		return -ENODEV;
+	pdev = platform_device_register_full(&ixp_dev_info);
+	if (IS_ERR(pdev))
+		return PTR_ERR(pdev);
+
+	dev = &pdev->dev;
 
 	spin_lock_init(&desc_lock);
 	spin_lock_init(&emerg_lock);
 
 	err = init_ixp_crypto();
 	if (err) {
-		platform_device_unregister(&pseudo_dev);
+		platform_device_unregister(pdev);
 		return err;
 	}
 	for (i=0; i< num; i++) {
@@ -1496,7 +1493,7 @@ static void __exit ixp_module_exit(void)
 			crypto_unregister_alg(&ixp4xx_algos[i].crypto);
 	}
 	release_ixp_crypto();
-	platform_device_unregister(&pseudo_dev);
+	platform_device_unregister(pdev);
 }
 
 module_init(ixp_module_init);
-- 
1.7.4.4

