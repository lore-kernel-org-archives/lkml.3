Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010Ab3LQX4k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 18:56:40 -0500
Received: from seketeli.net ([91.121.166.71]:35498 "EHLO ms.seketeli.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752273Ab3LQX4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 18:56:03 -0500
From: Apelete Seketeli <apelete@seketeli.net>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v2 2/3] usb: musb: add support for JZ4740 usb device controller
Date: Wed, 18 Dec 2013 00:56:00 +0100
Message-Id: <1387324561-21578-3-git-send-email-apelete@seketeli.net>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1387324561-21578-1-git-send-email-apelete@seketeli.net>
References: <1387324561-21578-1-git-send-email-apelete@seketeli.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for Ingenic JZ4740 USB Device Controller through a
specific musb glue layer.

The platform data already available in tree for that USB Device
Controller was previously used by an out-of-tree USB gadget driver
which was not relying on the musb driver and was written by Ingenic
and the Qi-Hardware community.

JZ4740 UDC not being OTG compatible and missing some hardware
registers, this musb glue layer is written from scratch to be used in
gadget mode only and take silicon design specifics into account.

Signed-off-by: Apelete Seketeli <apelete@seketeli.net>
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 arch/mips/include/asm/mach-jz4740/platform.h |    1 +
 arch/mips/jz4740/board-qi_lb60.c             |    1 +
 arch/mips/jz4740/platform.c                  |   40 +++--
 drivers/usb/musb/Kconfig                     |    8 +-
 drivers/usb/musb/Makefile                    |    1 +
 drivers/usb/musb/jz4740.c                    |  201 ++++++++++++++++++++++++++
 6 files changed, 235 insertions(+), 17 deletions(-)
 create mode 100644 drivers/usb/musb/jz4740.c

diff --git a/arch/mips/include/asm/mach-jz4740/platform.h b/arch/mips/include/asm/mach-jz4740/platform.h
index 05988c2..069b43a 100644
--- a/arch/mips/include/asm/mach-jz4740/platform.h
+++ b/arch/mips/include/asm/mach-jz4740/platform.h
@@ -21,6 +21,7 @@
 
 extern struct platform_device jz4740_usb_ohci_device;
 extern struct platform_device jz4740_udc_device;
+extern struct platform_device jz4740_udc_xceiv_device;
 extern struct platform_device jz4740_mmc_device;
 extern struct platform_device jz4740_rtc_device;
 extern struct platform_device jz4740_i2c_device;
diff --git a/arch/mips/jz4740/board-qi_lb60.c b/arch/mips/jz4740/board-qi_lb60.c
index 8a5ec0e..c01900e 100644
--- a/arch/mips/jz4740/board-qi_lb60.c
+++ b/arch/mips/jz4740/board-qi_lb60.c
@@ -427,6 +427,7 @@ static struct platform_device qi_lb60_audio_device = {
 
 static struct platform_device *jz_platform_devices[] __initdata = {
 	&jz4740_udc_device,
+	&jz4740_udc_xceiv_device,
 	&jz4740_mmc_device,
 	&jz4740_nand_device,
 	&qi_lb60_keypad,
diff --git a/arch/mips/jz4740/platform.c b/arch/mips/jz4740/platform.c
index df65677..1be41e2 100644
--- a/arch/mips/jz4740/platform.c
+++ b/arch/mips/jz4740/platform.c
@@ -21,6 +21,8 @@
 
 #include <linux/dma-mapping.h>
 
+#include <linux/usb/musb.h>
+
 #include <asm/mach-jz4740/platform.h>
 #include <asm/mach-jz4740/base.h>
 #include <asm/mach-jz4740/irq.h>
@@ -56,29 +58,35 @@ struct platform_device jz4740_usb_ohci_device = {
 	.resource	= jz4740_usb_ohci_resources,
 };
 
-/* UDC (USB gadget controller) */
-static struct resource jz4740_usb_gdt_resources[] = {
-	{
-		.start	= JZ4740_UDC_BASE_ADDR,
-		.end	= JZ4740_UDC_BASE_ADDR + 0x1000 - 1,
-		.flags	= IORESOURCE_MEM,
+/* USB Device Controller */
+struct platform_device jz4740_udc_xceiv_device = {
+	.name = "usb_phy_gen_xceiv",
+	.id   = 0,
+};
+
+static struct resource jz4740_udc_resources[] = {
+	[0] = {
+		.start = JZ4740_UDC_BASE_ADDR,
+		.end   = JZ4740_UDC_BASE_ADDR + 0x10000 - 1,
+		.flags = IORESOURCE_MEM,
 	},
-	{
-		.start	= JZ4740_IRQ_UDC,
-		.end	= JZ4740_IRQ_UDC,
-		.flags	= IORESOURCE_IRQ,
+	[1] = {
+		.start = JZ4740_IRQ_UDC,
+		.end   = JZ4740_IRQ_UDC,
+		.flags = IORESOURCE_IRQ,
+		.name  = "mc",
 	},
 };
 
 struct platform_device jz4740_udc_device = {
-	.name		= "jz-udc",
-	.id		= -1,
-	.dev = {
-		.dma_mask = &jz4740_udc_device.dev.coherent_dma_mask,
+	.name = "musb-jz4740",
+	.id   = -1,
+	.dev  = {
+		.dma_mask          = &jz4740_udc_device.dev.coherent_dma_mask,
 		.coherent_dma_mask = DMA_BIT_MASK(32),
 	},
-	.num_resources	= ARRAY_SIZE(jz4740_usb_gdt_resources),
-	.resource	= jz4740_usb_gdt_resources,
+	.num_resources = ARRAY_SIZE(jz4740_udc_resources),
+	.resource      = jz4740_udc_resources,
 };
 
 /* MMC/SD controller */
diff --git a/drivers/usb/musb/Kconfig b/drivers/usb/musb/Kconfig
index 57dfc0c..a45ed15 100644
--- a/drivers/usb/musb/Kconfig
+++ b/drivers/usb/musb/Kconfig
@@ -93,6 +93,12 @@ config USB_MUSB_BLACKFIN
 config USB_MUSB_UX500
 	tristate "Ux500 platforms"
 
+config USB_MUSB_JZ4740
+	tristate "JZ4740"
+	depends on MACH_JZ4740
+	depends on USB_MUSB_GADGET
+	depends on USB_OTG_BLACKLIST_HUB
+
 endchoice
 
 config USB_MUSB_AM335X_CHILD
@@ -100,7 +106,7 @@ config USB_MUSB_AM335X_CHILD
 
 choice
 	prompt 'MUSB DMA mode'
-	default MUSB_PIO_ONLY if ARCH_MULTIPLATFORM
+	default MUSB_PIO_ONLY if ARCH_MULTIPLATFORM || USB_MUSB_JZ4740
 	default USB_UX500_DMA if USB_MUSB_UX500
 	default USB_INVENTRA_DMA if USB_MUSB_OMAP2PLUS || USB_MUSB_BLACKFIN
 	default USB_TI_CPPI_DMA if USB_MUSB_DAVINCI
diff --git a/drivers/usb/musb/Makefile b/drivers/usb/musb/Makefile
index c5ea5c6..ba49501 100644
--- a/drivers/usb/musb/Makefile
+++ b/drivers/usb/musb/Makefile
@@ -19,6 +19,7 @@ obj-$(CONFIG_USB_MUSB_DAVINCI)			+= davinci.o
 obj-$(CONFIG_USB_MUSB_DA8XX)			+= da8xx.o
 obj-$(CONFIG_USB_MUSB_BLACKFIN)			+= blackfin.o
 obj-$(CONFIG_USB_MUSB_UX500)			+= ux500.o
+obj-$(CONFIG_USB_MUSB_JZ4740)			+= jz4740.o
 
 
 obj-$(CONFIG_USB_MUSB_AM335X_CHILD)		+= musb_am335x.o
diff --git a/drivers/usb/musb/jz4740.c b/drivers/usb/musb/jz4740.c
new file mode 100644
index 0000000..5f30537
--- /dev/null
+++ b/drivers/usb/musb/jz4740.c
@@ -0,0 +1,201 @@
+/*
+ * Ingenic JZ4740 "glue layer"
+ *
+ * Copyright (C) 2013, Apelete Seketeli <apelete@seketeli.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/clk.h>
+#include <linux/dma-mapping.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+
+#include "musb_core.h"
+
+struct jz4740_glue {
+	struct device           *dev;
+	struct platform_device  *musb;
+	struct clk		*clk;
+};
+
+static irqreturn_t jz4740_musb_interrupt(int irq, void *__hci)
+{
+	unsigned long   flags;
+	irqreturn_t     retval = IRQ_NONE;
+	struct musb     *musb = __hci;
+
+	spin_lock_irqsave(&musb->lock, flags);
+
+	musb->int_usb = musb_readb(musb->mregs, MUSB_INTRUSB);
+	musb->int_tx = musb_readw(musb->mregs, MUSB_INTRTX);
+	musb->int_rx = musb_readw(musb->mregs, MUSB_INTRRX);
+
+	/*
+	 * The controller is gadget only, the state of the host mode IRQ bits is
+	 * undefined. Mask them to make sure that the musb driver core will
+	 * never see them set
+	 */
+	musb->int_usb &= MUSB_INTR_SUSPEND | MUSB_INTR_RESUME |
+	    MUSB_INTR_RESET | MUSB_INTR_SOF;
+
+	if (musb->int_usb || musb->int_tx || musb->int_rx)
+		retval = musb_interrupt(musb);
+
+	spin_unlock_irqrestore(&musb->lock, flags);
+
+	return retval;
+}
+
+static struct musb_fifo_cfg jz4740_musb_fifo_cfg[] = {
+{ .hw_ep_num = 1, .style = FIFO_TX, .maxpacket = 512, },
+{ .hw_ep_num = 1, .style = FIFO_RX, .maxpacket = 512, },
+{ .hw_ep_num = 2, .style = FIFO_TX, .maxpacket = 64, },
+};
+
+static struct musb_hdrc_config jz4740_musb_config = {
+	/* Silicon does not implement USB OTG. */
+	.multipoint = 0,
+	/* Max EPs scanned, driver will decide which EP can be used. */
+	.num_eps    = 4,
+	/* RAMbits needed to configure EPs from table */
+	.ram_bits   = 9,
+	.fifo_cfg = jz4740_musb_fifo_cfg,
+	.fifo_cfg_size = ARRAY_SIZE(jz4740_musb_fifo_cfg),
+};
+
+static struct musb_hdrc_platform_data jz4740_musb_platform_data = {
+	.mode   = MUSB_PERIPHERAL,
+	.config = &jz4740_musb_config,
+};
+
+static int jz4740_musb_init(struct musb *musb)
+{
+	musb->xceiv = usb_get_phy(USB_PHY_TYPE_USB2);
+	if (!musb->xceiv) {
+		pr_err("HS UDC: no transceiver configured\n");
+		return -ENODEV;
+	}
+
+	/* Silicon does not implement ConfigData register.
+	 * Set dyn_fifo to avoid reading EP config from hardware.
+	 */
+	musb->dyn_fifo = true;
+
+	musb->isr = jz4740_musb_interrupt;
+
+	return 0;
+}
+
+static int jz4740_musb_exit(struct musb *musb)
+{
+	usb_put_phy(musb->xceiv);
+
+	return 0;
+}
+
+static const struct musb_platform_ops jz4740_musb_ops = {
+	.init		= jz4740_musb_init,
+	.exit		= jz4740_musb_exit,
+};
+
+static int jz4740_probe(struct platform_device *pdev)
+{
+	struct musb_hdrc_platform_data	*pdata = &jz4740_musb_platform_data;
+	struct platform_device		*musb;
+	struct jz4740_glue		*glue;
+	struct clk                      *clk;
+	int				ret;
+
+	glue = devm_kzalloc(&pdev->dev, sizeof(*glue), GFP_KERNEL);
+	if (!glue)
+		return -ENOMEM;
+
+	musb = platform_device_alloc("musb-hdrc", PLATFORM_DEVID_AUTO);
+	if (!musb) {
+		dev_err(&pdev->dev, "failed to allocate musb device\n");
+		return -ENOMEM;
+	}
+
+	clk = devm_clk_get(&pdev->dev, "udc");
+	if (IS_ERR(clk)) {
+		dev_err(&pdev->dev, "failed to get clock\n");
+		ret = PTR_ERR(clk);
+		goto err_platform_device_put;
+	}
+
+	ret = clk_prepare_enable(clk);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to enable clock\n");
+		goto err_platform_device_put;
+	}
+
+	musb->dev.parent		= &pdev->dev;
+
+	glue->dev			= &pdev->dev;
+	glue->musb			= musb;
+	glue->clk			= clk;
+
+	pdata->platform_ops		= &jz4740_musb_ops;
+
+	platform_set_drvdata(pdev, glue);
+
+	ret = platform_device_add_resources(musb, pdev->resource,
+					    pdev->num_resources);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to add resources\n");
+		goto err_clk_disable;
+	}
+
+	ret = platform_device_add_data(musb, pdata, sizeof(*pdata));
+	if (ret) {
+		dev_err(&pdev->dev, "failed to add platform_data\n");
+		goto err_clk_disable;
+	}
+
+	ret = platform_device_add(musb);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to register musb device\n");
+		goto err_clk_disable;
+	}
+
+	return 0;
+
+err_clk_disable:
+	clk_disable_unprepare(clk);
+err_platform_device_put:
+	platform_device_put(musb);
+	return ret;
+}
+
+static int jz4740_remove(struct platform_device *pdev)
+{
+	struct jz4740_glue	*glue = platform_get_drvdata(pdev);
+
+	platform_device_unregister(glue->musb);
+	clk_disable_unprepare(glue->clk);
+
+	return 0;
+}
+
+static struct platform_driver jz4740_driver = {
+	.probe		= jz4740_probe,
+	.remove		= jz4740_remove,
+	.driver		= {
+		.name	= "musb-jz4740",
+	},
+};
+
+MODULE_DESCRIPTION("JZ4740 MUSB Glue Layer");
+MODULE_AUTHOR("Apelete Seketeli <apelete@seketeli.net>");
+MODULE_LICENSE("GPL v2");
+module_platform_driver(jz4740_driver);
-- 
1.7.10.4

