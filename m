Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044AbaDSOev (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 10:34:51 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:38770 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754172AbaDSOeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 10:34:25 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH v2 4/7] of: configure the platform device dma parameters
Date: Sat, 19 Apr 2014 10:32:49 -0400
Message-ID: <1397917972-6293-5-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397917972-6293-1-git-send-email-santosh.shilimkar@ti.com>
References: <1397917972-6293-1-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Retrieve DMA configuration from DT and setup platform device's DMA
parameters. The DMA configuration in DT has to be specified using
"dma-ranges" and "dma-coherent" properties if supported.

We setup dma_pfn_offset using "dma-ranges" and dma_coherent_ops
using "dma-coherent" device tree properties.

The set_arch_dma_coherent_ops macro has to be defined by arch if
it supports coherent dma_ops. Otherwise, set_arch_dma_coherent_ops() is
declared as nop.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Olof Johansson <olof@lixom.net>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 drivers/of/platform.c       |   43 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/dma-mapping.h |    7 +++++++
 2 files changed, 50 insertions(+)

diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index 573db15..7e4a43b 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -187,6 +187,47 @@ struct platform_device *of_device_alloc(struct device_node *np,
 EXPORT_SYMBOL(of_device_alloc);
 
 /**
+ * of_dma_configure - Setup DMA configuration
+ * @dev:	Device to apply DMA configuration
+ *
+ * Try to get devices's DMA configuration from DT and update it
+ * accordingly.
+ *
+ * In case if platform code need to use own special DMA configuration,it
+ * can use Platform bus notifier and handle BUS_NOTIFY_ADD_DEVICE event
+ * to fix up DMA configuration.
+ */
+static void of_dma_configure(struct device *dev)
+{
+	dma_addr_t dma_addr;
+	phys_addr_t paddr, size;
+	int ret;
+
+	/*
+	 * if dma-coherent property exist, call arch hook to setup
+	 * dma coherent operations.
+	 */
+	if (of_dma_is_coherent(dev->of_node)) {
+		set_arch_dma_coherent_ops(dev);
+		dev_dbg(dev, "device is dma coherent\n");
+	}
+
+	/*
+	 * if dma-ranges property doesn't exist - just return else
+	 * setup the dma offset
+	 */
+	ret = of_dma_get_range(dev->of_node, &dma_addr, &paddr, &size);
+	if (ret < 0) {
+		dev_dbg(dev, "no dma range information to setup\n");
+		return;
+	} else {
+		/* DMA ranges found. Calculate and set dma_pfn_offset */
+		dev->dma_pfn_offset = PFN_DOWN(paddr - dma_addr);
+		dev_dbg(dev, "dma_pfn_offset(%#08lx)\n", dev->dma_pfn_offset);
+	}
+}
+
+/**
  * of_platform_device_create_pdata - Alloc, initialize and register an of_device
  * @np: pointer to node to create device for
  * @bus_id: name to assign device
@@ -217,6 +258,8 @@ static struct platform_device *of_platform_device_create_pdata(
 	dev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
 	if (!dev->dev.dma_mask)
 		dev->dev.dma_mask = &dev->dev.coherent_dma_mask;
+
+	of_dma_configure(&dev->dev);
 	dev->dev.bus = &platform_bus_type;
 	dev->dev.platform_data = platform_data;
 
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index fd4aee2..c7d9b1b 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -123,6 +123,13 @@ static inline int dma_coerce_mask_and_coherent(struct device *dev, u64 mask)
 
 extern u64 dma_get_required_mask(struct device *dev);
 
+#ifndef set_arch_dma_coherent_ops
+static inline int set_arch_dma_coherent_ops(struct device *dev)
+{
+	return 0;
+}
+#endif
+
 static inline unsigned int dma_get_max_seg_size(struct device *dev)
 {
 	return dev->dma_parms ? dev->dma_parms->max_segment_size : 65536;
-- 
1.7.9.5

