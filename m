Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855Ab3FKHSZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 03:18:25 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:47207 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753625Ab3FKHSM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 03:18:12 -0400
From: Ravi Babu <ravibabu@ti.com>
To: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <balbi@ti.com>, Ravi Babu <ravibabu@ti.com>
Subject: [PATCH v2 7/7] usb: musb: dsp: remove the usb-phy control acess from platform glue
Date: Tue, 11 Jun 2013 12:47:52 +0530
Message-ID: <1370935072-21056-8-git-send-email-ravibabu@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1370935072-21056-1-git-send-email-ravibabu@ti.com>
References: <1370935072-21056-1-git-send-email-ravibabu@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove usb-phy control access from platform glue, after moving
usb-phy controls to saperate phy-dsps-usb driver.

Signed-off-by: Ravi Babu <ravibabu@ti.com>
---
 drivers/usb/musb/musb_dsps.c |   51 ------------------------------------------
 1 files changed, 0 insertions(+), 51 deletions(-)

diff --git a/drivers/usb/musb/musb_dsps.c b/drivers/usb/musb/musb_dsps.c
index 0d8581b..958c6b6 100644
--- a/drivers/usb/musb/musb_dsps.c
+++ b/drivers/usb/musb/musb_dsps.c
@@ -123,49 +123,8 @@ struct dsps_glue {
 	const struct dsps_musb_wrapper *wrp; /* wrapper register offsets */
 	struct timer_list timer[2];	/* otg_workaround timer */
 	unsigned long last_timer[2];    /* last timer data for each instance */
-	u32 __iomem *usb_ctrl[2];
 };
 
-#define	DSPS_AM33XX_CONTROL_MODULE_PHYS_0	0x44e10620
-#define	DSPS_AM33XX_CONTROL_MODULE_PHYS_1	0x44e10628
-
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
-
-	writel(usbphycfg, glue->usb_ctrl[id]);
-}
 /**
  * dsps_musb_enable - enable interrupts
  */
@@ -494,16 +453,6 @@ static int dsps_create_musb_pdev(struct dsps_glue *glue, u8 id)
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
-- 
1.7.0.4

