Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965876Ab3GSMf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 08:35:29 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:53928 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760254Ab3GSMfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 08:35:11 -0400
From: George Cherian <george.cherian@ti.com>
To: <linux-usb@vger.kernel.org>
CC: <balbi@ti.com>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <linux-omap@vger.kernel.org>,
        <kishon@ti.com>, <bigeasy@linutronix.de>,
        George Cherian <george.cherian@ti.com>
Subject: [PATCH v2 4/4] usb: musb: dsps: Remove the phy control from glue and add phy driver APIs
Date: Fri, 19 Jul 2013 18:04:37 +0530
Message-ID: <1374237277-17769-5-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1374237277-17769-1-git-send-email-george.cherian@ti.com>
References: <1374237277-17769-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove usb phy control module access from platform glue.
The same is now done using amxxxx phy driver and phy-omap-control.
Adapt the driver to the split dt nodes.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: George Cherian <george.cherian@ti.com>
---
 drivers/usb/musb/musb_dsps.c | 150 ++++++++++++++++---------------------------
 1 file changed, 55 insertions(+), 95 deletions(-)

diff --git a/drivers/usb/musb/musb_dsps.c b/drivers/usb/musb/musb_dsps.c
index 41f135a..6bec458 100644
--- a/drivers/usb/musb/musb_dsps.c
+++ b/drivers/usb/musb/musb_dsps.c
@@ -43,6 +43,7 @@
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/of_address.h>
+#include <linux/of_irq.h>
 
 #include "musb_core.h"
 
@@ -110,8 +111,6 @@ struct dsps_musb_wrapper {
 	/* miscellaneous stuff */
 	u32		musb_core_offset;
 	u8		poll_seconds;
-	/* number of musb instances */
-	u8		instances;
 };
 
 /**
@@ -123,49 +122,11 @@ struct dsps_glue {
 	const struct dsps_musb_wrapper *wrp; /* wrapper register offsets */
 	struct timer_list timer[2];	/* otg_workaround timer */
 	unsigned long last_timer[2];    /* last timer data for each instance */
-	u32 __iomem *usb_ctrl[2];
 };
 
-#define	DSPS_AM33XX_CONTROL_MODULE_PHYS_0	0x44e10620
-#define	DSPS_AM33XX_CONTROL_MODULE_PHYS_1	0x44e10628
+#define glue_to_musb(g, i)		platform_get_drvdata(g->musb[i])
 
-static const resource_size_t dsps_control_module_phys[] = {
-	DSPS_AM33XX_CONTROL_MODULE_PHYS_0,
-	DSPS_AM33XX_CONTROL_MODULE_PHYS_1,
-};
-
-#define USBPHY_CM_PWRDN		(1 << 0)
-#define USBPHY_OTG_PWRDN	(1 << 1)
-#define USBPHY_OTGVDET_EN	(1 << 19)
-#define USBPHY_OTGSESSEND_EN	(1 << 20)
-
-/**
- * musb_dsps_phy_control - phy on/off
- * @glue: struct dsps_glue *
- * @id: musb instance
- * @on: flag for phy to be switched on or off
- *
- * This is to enable the PHY using usb_ctrl register in system control
- * module space.
- *
- * XXX: This function will be removed once we have a seperate driver for
- * control module
- */
-static void musb_dsps_phy_control(struct dsps_glue *glue, u8 id, u8 on)
-{
-	u32 usbphycfg;
-
-	usbphycfg = readl(glue->usb_ctrl[id]);
-
-	if (on) {
-		usbphycfg &= ~(USBPHY_CM_PWRDN | USBPHY_OTG_PWRDN);
-		usbphycfg |= USBPHY_OTGVDET_EN | USBPHY_OTGSESSEND_EN;
-	} else {
-		usbphycfg |= USBPHY_CM_PWRDN | USBPHY_OTG_PWRDN;
-	}
 
-	writel(usbphycfg, glue->usb_ctrl[id]);
-}
 /**
  * dsps_musb_enable - enable interrupts
  */
@@ -411,16 +372,28 @@ static int dsps_musb_init(struct musb *musb)
 	void __iomem *reg_base = musb->ctrl_base;
 	u32 rev, val;
 	int status;
+	char phyname[12];
 
 	/* mentor core register starts at offset of 0x400 from musb base */
 	musb->mregs += wrp->musb_core_offset;
 
-	/* NOP driver needs change if supporting dual instance */
-	usb_nop_xceiv_register();
-	musb->xceiv = usb_get_phy(USB_PHY_TYPE_USB2);
+	snprintf(phyname , 12, "am335x-usb%d", pdev->id);
+
+	if (dev->of_node) {
+		musb->phy = devm_phy_get(dev, phyname);
+		musb->xceiv = devm_usb_get_phy_by_phandle(dev,
+							"phys", 0);
+	} else {
+		musb->phy = devm_phy_get(dev, musb->phy_label);
+		musb->xceiv = devm_usb_get_phy_dev(dev, pdev->id);
+	}
+
 	if (IS_ERR_OR_NULL(musb->xceiv))
 		return -EPROBE_DEFER;
 
+	if (IS_ERR_OR_NULL(musb->phy))
+		return -EPROBE_DEFER;
+
 	/* Returns zero if e.g. not clocked */
 	rev = dsps_readl(reg_base, wrp->revision);
 	if (!rev) {
@@ -434,7 +407,8 @@ static int dsps_musb_init(struct musb *musb)
 	dsps_writel(reg_base, wrp->control, (1 << wrp->reset));
 
 	/* Start the on-chip PHY and its PLL. */
-	musb_dsps_phy_control(glue, pdev->id, 1);
+	phy_init(musb->phy);
+	phy_power_on(musb->phy);
 
 	musb->isr = dsps_interrupt;
 
@@ -448,8 +422,7 @@ static int dsps_musb_init(struct musb *musb)
 
 	return 0;
 err0:
-	usb_put_phy(musb->xceiv);
-	usb_nop_xceiv_unregister();
+	devm_phy_put(dev->parent, musb->phy);
 	return status;
 }
 
@@ -462,11 +435,8 @@ static int dsps_musb_exit(struct musb *musb)
 	del_timer_sync(&glue->timer[pdev->id]);
 
 	/* Shutdown the on-chip PHY and its PLL. */
-	musb_dsps_phy_control(glue, pdev->id, 0);
-
-	/* NOP driver needs change if supporting dual instance */
-	usb_put_phy(musb->xceiv);
-	usb_nop_xceiv_unregister();
+	phy_power_off(musb->phy);
+	phy_exit(musb->phy);
 
 	return 0;
 }
@@ -483,49 +453,34 @@ static struct musb_platform_ops dsps_ops = {
 
 static u64 musb_dmamask = DMA_BIT_MASK(32);
 
-static int dsps_create_musb_pdev(struct dsps_glue *glue, u8 id)
+static int dsps_create_musb_pdev(struct dsps_glue *glue, u8 id,
+		struct device_node *np)
 {
 	struct device *dev = glue->dev;
 	struct platform_device *pdev = to_platform_device(dev);
 	struct musb_hdrc_platform_data  *pdata = dev->platform_data;
-	struct device_node *np = pdev->dev.of_node;
 	struct musb_hdrc_config	*config;
 	struct platform_device	*musb;
-	struct resource *res;
 	struct resource	resources[2];
 	char res_name[11];
 	int ret;
 
-	resources[0].start = dsps_control_module_phys[id];
-	resources[0].end = resources[0].start + SZ_4 - 1;
-	resources[0].flags = IORESOURCE_MEM;
-
-	glue->usb_ctrl[id] = devm_ioremap_resource(&pdev->dev, resources);
-	if (IS_ERR(glue->usb_ctrl[id])) {
-		ret = PTR_ERR(glue->usb_ctrl[id]);
-		goto err0;
-	}
-
-	/* first resource is for usbss, so start index from 1 */
-	res = platform_get_resource(pdev, IORESOURCE_MEM, id + 1);
-	if (!res) {
+	ret = of_address_to_resource(np, 0, &resources[0]);
+	if (ret) {
 		dev_err(dev, "failed to get memory for instance %d\n", id);
-		ret = -ENODEV;
 		goto err0;
 	}
-	res->parent = NULL;
-	resources[0] = *res;
 
 	/* first resource is for usbss, so start index from 1 */
-	res = platform_get_resource(pdev, IORESOURCE_IRQ, id + 1);
-	if (!res) {
+	ret = of_irq_to_resource(np, 0, &resources[1]);
+	if (ret == 0) {
 		dev_err(dev, "failed to get irq for instance %d\n", id);
-		ret = -ENODEV;
+		ret = -EINVAL;
 		goto err0;
 	}
-	res->parent = NULL;
-	resources[1] = *res;
-	resources[1].name = "mc";
+	resources[0].parent = NULL;
+	resources[1].parent = NULL;
+
 
 	/* allocate the child platform device */
 	musb = platform_device_alloc("musb-hdrc", PLATFORM_DEVID_AUTO);
@@ -538,6 +493,7 @@ static int dsps_create_musb_pdev(struct dsps_glue *glue, u8 id)
 	musb->dev.parent		= dev;
 	musb->dev.dma_mask		= &musb_dmamask;
 	musb->dev.coherent_dma_mask	= musb_dmamask;
+	musb->dev.of_node               = of_node_get(np);
 
 	glue->musb[id]			= musb;
 
@@ -566,8 +522,7 @@ static int dsps_create_musb_pdev(struct dsps_glue *glue, u8 id)
 
 		of_property_read_u32(np, "num-eps", (u32 *)&config->num_eps);
 		of_property_read_u32(np, "ram-bits", (u32 *)&config->ram_bits);
-		snprintf(res_name, sizeof(res_name), "port%d-mode", id);
-		of_property_read_u32(np, res_name, (u32 *)&pdata->mode);
+		of_property_read_u32(np, "port-mode", (u32 *)&pdata->mode);
 		of_property_read_u32(np, "power", (u32 *)&pdata->power);
 		config->multipoint = of_property_read_bool(np, "multipoint");
 
@@ -602,6 +557,7 @@ static int dsps_probe(struct platform_device *pdev)
 	const struct dsps_musb_wrapper *wrp;
 	struct dsps_glue *glue;
 	struct resource *iomem;
+	struct device_node *child;
 	int ret, i;
 
 	match = of_match_node(musb_dsps_of_match, pdev->dev.of_node);
@@ -648,8 +604,9 @@ static int dsps_probe(struct platform_device *pdev)
 	}
 
 	/* create the child platform device for all instances of musb */
-	for (i = 0; i < wrp->instances ; i++) {
-		ret = dsps_create_musb_pdev(glue, i);
+	i = 0;
+	for_each_available_child_of_node(pdev->dev.of_node, child) {
+		ret = dsps_create_musb_pdev(glue, i, child);
 		if (ret != 0) {
 			dev_err(&pdev->dev, "failed to create child pdev\n");
 			/* release resources of previously created instances */
@@ -657,6 +614,7 @@ static int dsps_probe(struct platform_device *pdev)
 				platform_device_unregister(glue->musb[i]);
 			goto err3;
 		}
+		i++;
 	}
 
 	return 0;
@@ -674,12 +632,13 @@ err0:
 static int dsps_remove(struct platform_device *pdev)
 {
 	struct dsps_glue *glue = platform_get_drvdata(pdev);
-	const struct dsps_musb_wrapper *wrp = glue->wrp;
 	int i;
 
 	/* delete the child platform device */
-	for (i = 0; i < wrp->instances ; i++)
-		platform_device_unregister(glue->musb[i]);
+	for (i = 0; i < ARRAY_SIZE(glue->musb); i++) {
+		if (glue->musb[i])
+			platform_device_unregister(glue->musb[i]);
+	}
 
 	/* disable usbss clocks */
 	pm_runtime_put(&pdev->dev);
@@ -692,26 +651,28 @@ static int dsps_remove(struct platform_device *pdev)
 #ifdef CONFIG_PM_SLEEP
 static int dsps_suspend(struct device *dev)
 {
-	struct platform_device *pdev = to_platform_device(dev->parent);
-	struct dsps_glue *glue = platform_get_drvdata(pdev);
-	const struct dsps_musb_wrapper *wrp = glue->wrp;
+	struct dsps_glue *glue = dev_get_drvdata(dev);
+	struct musb *musb;
 	int i;
 
-	for (i = 0; i < wrp->instances; i++)
-		musb_dsps_phy_control(glue, i, 0);
+	for (i = 0; i < ARRAY_SIZE(glue->musb); i++) {
+		musb = glue_to_musb(glue, i);
+		phy_power_off(musb->phy);
+	}
 
 	return 0;
 }
 
 static int dsps_resume(struct device *dev)
 {
-	struct platform_device *pdev = to_platform_device(dev->parent);
-	struct dsps_glue *glue = platform_get_drvdata(pdev);
-	const struct dsps_musb_wrapper *wrp = glue->wrp;
+	struct dsps_glue *glue = dev_get_drvdata(dev);
+	struct musb *musb;
 	int i;
 
-	for (i = 0; i < wrp->instances; i++)
-		musb_dsps_phy_control(glue, i, 1);
+	for (i = 0; i < ARRAY_SIZE(glue->musb); i++) {
+		musb = glue_to_musb(glue, i);
+		phy_power_off(musb->phy);
+	}
 
 	return 0;
 }
@@ -747,7 +708,6 @@ static const struct dsps_musb_wrapper ti81xx_driver_data = {
 	.rxep_bitmap		= (0xfffe << 16),
 	.musb_core_offset	= 0x400,
 	.poll_seconds		= 2,
-	.instances		= 2,
 };
 
 static const struct platform_device_id musb_dsps_id_table[] = {
-- 
1.8.1.4

