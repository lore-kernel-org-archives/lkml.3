Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579Ab3FKHSK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 03:18:10 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36582 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751700Ab3FKHSG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 03:18:06 -0400
From: Ravi Babu <ravibabu@ti.com>
To: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <balbi@ti.com>, Ravi Babu <ravibabu@ti.com>
Subject: [PATCH v2 4/7] usb: musb: dsps: use usb-phy driver API for phy power on/off
Date: Tue, 11 Jun 2013 12:47:49 +0530
Message-ID: <1370935072-21056-5-git-send-email-ravibabu@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1370935072-21056-1-git-send-email-ravibabu@ti.com>
References: <1370935072-21056-1-git-send-email-ravibabu@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use usb-phy driver API for powering on/off phy and removed
usage of the phy control access in platform glue driver.

Signed-off-by: Ravi Babu <ravibabu@ti.com>
---
 drivers/usb/musb/musb_dsps.c |   22 +++++++++++++---------
 1 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/musb/musb_dsps.c b/drivers/usb/musb/musb_dsps.c
index 0ecedb3..0096aad 100644
--- a/drivers/usb/musb/musb_dsps.c
+++ b/drivers/usb/musb/musb_dsps.c
@@ -36,6 +36,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/pm_runtime.h>
 #include <linux/module.h>
+#include <linux/usb/phy.h>
 #include <linux/platform_data/usb-omap.h>
 #include <linux/sizes.h>
 
@@ -432,7 +433,7 @@ static int dsps_musb_init(struct musb *musb)
 	dsps_writel(reg_base, wrp->control, (1 << wrp->reset));
 
 	/* Start the on-chip PHY and its PLL. */
-	musb_dsps_phy_control(glue, pdev->id, 1);
+	usb_phy_init(musb->xceiv);
 
 	musb->isr = dsps_interrupt;
 
@@ -459,10 +460,7 @@ static int dsps_musb_exit(struct musb *musb)
 	del_timer_sync(&glue->timer[pdev->id]);
 
 	/* Shutdown the on-chip PHY and its PLL. */
-	musb_dsps_phy_control(glue, pdev->id, 0);
-
-	/* NOP driver needs change if supporting dual instance */
-	usb_put_phy(musb->xceiv);
+	usb_phy_shutdown(musb->xceiv);
 
 	return 0;
 }
@@ -690,10 +688,13 @@ static int dsps_suspend(struct device *dev)
 	struct platform_device *pdev = to_platform_device(dev->parent);
 	struct dsps_glue *glue = platform_get_drvdata(pdev);
 	const struct dsps_musb_wrapper *wrp = glue->wrp;
+	struct musb *musb;
 	int i;
 
-	for (i = 0; i < wrp->instances; i++)
-		musb_dsps_phy_control(glue, i, 0);
+	for (i = 0; i < wrp->instances; i++) {
+		musb = dev_get_drvdata(&glue->musb[i]->dev);
+		usb_phy_set_suspend(musb->xceiv, 1);
+	}
 
 	return 0;
 }
@@ -703,10 +704,13 @@ static int dsps_resume(struct device *dev)
 	struct platform_device *pdev = to_platform_device(dev->parent);
 	struct dsps_glue *glue = platform_get_drvdata(pdev);
 	const struct dsps_musb_wrapper *wrp = glue->wrp;
+	struct musb *musb;
 	int i;
 
-	for (i = 0; i < wrp->instances; i++)
-		musb_dsps_phy_control(glue, i, 1);
+	for (i = 0; i < wrp->instances; i++) {
+		musb = dev_get_drvdata(&glue->musb[i]->dev);
+		usb_phy_set_suspend(musb->xceiv, 0);
+	}
 
 	return 0;
 }
-- 
1.7.0.4

