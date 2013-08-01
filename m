Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757753Ab3HAV4i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 17:56:38 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39771 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757492Ab3HAV4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 17:56:36 -0400
In-Reply-To: <20130801213420.GL23006@n2100.arm.linux.org.uk>
References: <20130801213420.GL23006@n2100.arm.linux.org.uk>
From: Russell King <rmk+kernel@arm.linux.org.uk>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH RFC 22/51] DMA-API: amba: get rid of separate dma_mask
Message-Id: <E1V50qu-0006ra-IT@rmk-PC.arm.linux.org.uk>
Date: Thu, 01 Aug 2013 22:56:08 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AMBA Primecell devices always treat streaming and coherent DMA exactly
the same, so there's no point in having the masks separated.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/amba/bus.c       |    6 +-----
 drivers/of/platform.c    |    3 ---
 include/linux/amba/bus.h |    2 --
 3 files changed, 1 insertions(+), 10 deletions(-)

diff --git a/drivers/amba/bus.c b/drivers/amba/bus.c
index c670727..c4876ac 100644
--- a/drivers/amba/bus.c
+++ b/drivers/amba/bus.c
@@ -552,7 +552,6 @@ amba_aphb_device_add(struct device *parent, const char *name,
 	if (!dev)
 		return ERR_PTR(-ENOMEM);
 
-	dev->dma_mask = dma_mask;
 	dev->dev.coherent_dma_mask = dma_mask;
 	dev->irq[0] = irq1;
 	dev->irq[1] = irq2;
@@ -619,7 +618,7 @@ static void amba_device_initialize(struct amba_device *dev, const char *name)
 		dev_set_name(&dev->dev, "%s", name);
 	dev->dev.release = amba_device_release;
 	dev->dev.bus = &amba_bustype;
-	dev->dev.dma_mask = &dev->dma_mask;
+	dev->dev.dma_mask = &dev->dev.coherent_dma_mask;
 	dev->res.name = dev_name(&dev->dev);
 }
 
@@ -663,9 +662,6 @@ int amba_device_register(struct amba_device *dev, struct resource *parent)
 	amba_device_initialize(dev, dev->dev.init_name);
 	dev->dev.init_name = NULL;
 
-	if (!dev->dev.coherent_dma_mask && dev->dma_mask)
-		dev_warn(&dev->dev, "coherent dma mask is unset\n");
-
 	return amba_device_add(dev, parent);
 }
 
diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index e0a6514..ef31c5d 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -277,9 +277,6 @@ static struct amba_device *of_amba_device_create(struct device_node *node,
 	else
 		of_device_make_bus_id(&dev->dev);
 
-	/* setup amba-specific device info */
-	dev->dma_mask = ~0;
-
 	/* Allow the HW Peripheral ID to be overridden */
 	prop = of_get_property(node, "arm,primecell-periphid", NULL);
 	if (prop)
diff --git a/include/linux/amba/bus.h b/include/linux/amba/bus.h
index 43ec7e2..682df0e 100644
--- a/include/linux/amba/bus.h
+++ b/include/linux/amba/bus.h
@@ -30,7 +30,6 @@ struct amba_device {
 	struct device		dev;
 	struct resource		res;
 	struct clk		*pclk;
-	u64			dma_mask;
 	unsigned int		periphid;
 	unsigned int		irq[AMBA_NR_IRQS];
 };
@@ -131,7 +130,6 @@ struct amba_device name##_device = {				\
 struct amba_device name##_device = {				\
 	.dev = __AMBA_DEV(busid, data, ~0ULL),			\
 	.res = DEFINE_RES_MEM(base, SZ_4K),			\
-	.dma_mask = ~0ULL,					\
 	.irq = irqs,						\
 	.periphid = id,						\
 }
-- 
1.7.4.4

