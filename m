Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465Ab3GHKoD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 06:44:03 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:49544 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752334Ab3GHKn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 06:43:59 -0400
From: George Cherian <george.cherian@ti.com>
To: <linux-usb@vger.kernel.org>
CC: <balbi@ti.com>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <linux-omap@vger.kernel.org>,
        <kishon@ti.com>, <bigeasy@linutronix.de>,
        George Cherian <george.cherian@ti.com>
Subject: [PATCH 5/5] usb: musb: dsps: Remove the phy control from glue and add phy driver APIs
Date: Mon, 8 Jul 2013 16:13:21 +0530
Message-ID: <1373280201-31785-6-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1373280201-31785-1-git-send-email-george.cherian@ti.com>
References: <1373280201-31785-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove usb phy control module access from platform glue.
The same is now done using amxxxx phy driver and phy-omap-control.

Signed-off-by: George Cherian <george.cherian@ti.com>
---
 drivers/usb/musb/musb_dsps.c | 105 +++++++++++++++----------------------------
 1 file changed, 36 insertions(+), 69 deletions(-)

diff --git a/drivers/usb/musb/musb_dsps.c b/drivers/usb/musb/musb_dsps.c
index 41f135a..8f4e04a 100644
--- a/drivers/usb/musb/musb_dsps.c
+++ b/drivers/usb/musb/musb_dsps.c
@@ -123,49 +123,11 @@ struct dsps_glue {
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
 
-	usbphycfg = readl(glue->usb_ctrl[id]);
-
-	if (on) {
-		usbphycfg &= ~(USBPHY_CM_PWRDN | USBPHY_OTG_PWRDN);
-		usbphycfg |= USBPHY_OTGVDET_EN | USBPHY_OTGSESSEND_EN;
-	} else {
-		usbphycfg |= USBPHY_CM_PWRDN | USBPHY_OTG_PWRDN;
-	}
-
-	writel(usbphycfg, glue->usb_ctrl[id]);
-}
 /**
  * dsps_musb_enable - enable interrupts
  */
@@ -411,16 +373,31 @@ static int dsps_musb_init(struct musb *musb)
 	void __iomem *reg_base = musb->ctrl_base;
 	u32 rev, val;
 	int status;
+	char phyname[12];
 
 	/* mentor core register starts at offset of 0x400 from musb base */
 	musb->mregs += wrp->musb_core_offset;
 
-	/* NOP driver needs change if supporting dual instance */
-	usb_nop_xceiv_register();
-	musb->xceiv = usb_get_phy(USB_PHY_TYPE_USB2);
+	if (dev->parent->of_node) {
+		snprintf(phyname , 12, "am335x-usb%d", pdev->id);
+		musb->phy = devm_phy_get(dev->parent, phyname);
+		musb->xceiv = devm_usb_get_phy_by_phandle(dev->parent,
+							"phys", pdev->id);
+	} else {
+		snprintf(phyname , 12, "am335x-usb%d", pdev->id);
+		musb->phy = devm_phy_get(dev, musb->phy_label);
+		musb->xceiv = devm_usb_get_phy_dev(dev, pdev->id);
+	}
+
 	if (IS_ERR_OR_NULL(musb->xceiv))
 		return -EPROBE_DEFER;
 
+	if (IS_ERR_OR_NULL(musb->phy)) {
+		pr_err("no PHY configured\n");
+		return -EPROBE_DEFER;
+	}
+
+
 	/* Returns zero if e.g. not clocked */
 	rev = dsps_readl(reg_base, wrp->revision);
 	if (!rev) {
@@ -434,7 +411,8 @@ static int dsps_musb_init(struct musb *musb)
 	dsps_writel(reg_base, wrp->control, (1 << wrp->reset));
 
 	/* Start the on-chip PHY and its PLL. */
-	musb_dsps_phy_control(glue, pdev->id, 1);
+	phy_init(musb->phy);
+	phy_power_on(musb->phy);
 
 	musb->isr = dsps_interrupt;
 
@@ -448,8 +426,7 @@ static int dsps_musb_init(struct musb *musb)
 
 	return 0;
 err0:
-	usb_put_phy(musb->xceiv);
-	usb_nop_xceiv_unregister();
+	devm_phy_put(dev->parent, musb->phy);
 	return status;
 }
 
@@ -462,11 +439,8 @@ static int dsps_musb_exit(struct musb *musb)
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
@@ -496,16 +470,6 @@ static int dsps_create_musb_pdev(struct dsps_glue *glue, u8 id)
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
 	/* first resource is for usbss, so start index from 1 */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, id + 1);
 	if (!res) {
@@ -692,26 +656,29 @@ static int dsps_remove(struct platform_device *pdev)
 #ifdef CONFIG_PM_SLEEP
 static int dsps_suspend(struct device *dev)
 {
-	struct platform_device *pdev = to_platform_device(dev->parent);
-	struct dsps_glue *glue = platform_get_drvdata(pdev);
+	struct dsps_glue *glue = dev_get_drvdata(dev);
 	const struct dsps_musb_wrapper *wrp = glue->wrp;
+	struct musb			*musb;
 	int i;
 
-	for (i = 0; i < wrp->instances; i++)
-		musb_dsps_phy_control(glue, i, 0);
-
+	for (i = 0; i < wrp->instances; i++) {
+		musb = glue_to_musb(glue, i);
+		phy_power_off(musb->phy);
+	}
 	return 0;
 }
 
 static int dsps_resume(struct device *dev)
 {
-	struct platform_device *pdev = to_platform_device(dev->parent);
-	struct dsps_glue *glue = platform_get_drvdata(pdev);
+	struct dsps_glue *glue = dev_get_drvdata(dev);
 	const struct dsps_musb_wrapper *wrp = glue->wrp;
+	struct musb			*musb;
 	int i;
 
-	for (i = 0; i < wrp->instances; i++)
-		musb_dsps_phy_control(glue, i, 1);
+	for (i = 0; i < wrp->instances; i++) {
+		musb = glue_to_musb(glue, i);
+		phy_power_on(musb->phy);
+	}
 
 	return 0;
 }
-- 
1.8.1.4

