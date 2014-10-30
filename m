Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759530AbaJ3Lg6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 07:36:58 -0400
Received: from down.free-electrons.com ([37.187.137.238]:49949 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759469AbaJ3Lg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 07:36:56 -0400
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: Peter.Chen@freescale.com
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] usb: chipidea: remove obsolete ci_get_platdata function
Date: Thu, 30 Oct 2014 12:36:47 +0100
Message-Id: <1414669007-9850-7-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1414669007-9850-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1414669007-9850-1-git-send-email-antoine.tenart@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The addition of the ci_hdrc_get_platdata function makes the use of
ci_get_platdata obsolete. Remove it.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 drivers/usb/chipidea/core.c | 41 -----------------------------------------
 1 file changed, 41 deletions(-)

diff --git a/drivers/usb/chipidea/core.c b/drivers/usb/chipidea/core.c
index 0ad55c10a903..8562a9c6154d 100644
--- a/drivers/usb/chipidea/core.c
+++ b/drivers/usb/chipidea/core.c
@@ -498,43 +498,6 @@ static irqreturn_t ci_irq(int irq, void *data)
 	return ret;
 }
 
-static int ci_get_platdata(struct device *dev,
-		struct ci_hdrc_platform_data *platdata)
-{
-	if (!platdata->phy_mode)
-		platdata->phy_mode = of_usb_get_phy_mode(dev->of_node);
-
-	if (!platdata->dr_mode)
-		platdata->dr_mode = of_usb_get_dr_mode(dev->of_node);
-
-	if (platdata->dr_mode == USB_DR_MODE_UNKNOWN)
-		platdata->dr_mode = USB_DR_MODE_OTG;
-
-	if (platdata->dr_mode != USB_DR_MODE_PERIPHERAL) {
-		/* Get the vbus regulator */
-		platdata->reg_vbus = devm_regulator_get(dev, "vbus");
-		if (PTR_ERR(platdata->reg_vbus) == -EPROBE_DEFER) {
-			return -EPROBE_DEFER;
-		} else if (PTR_ERR(platdata->reg_vbus) == -ENODEV) {
-			/* no vbus regualator is needed */
-			platdata->reg_vbus = NULL;
-		} else if (IS_ERR(platdata->reg_vbus)) {
-			dev_err(dev, "Getting regulator error: %ld\n",
-				PTR_ERR(platdata->reg_vbus));
-			return PTR_ERR(platdata->reg_vbus);
-		}
-		/* Get TPL support */
-		if (!platdata->tpl_support)
-			platdata->tpl_support =
-				of_usb_host_tpl_support(dev->of_node);
-	}
-
-	if (of_usb_get_maximum_speed(dev->of_node) == USB_SPEED_FULL)
-		platdata->flags |= CI_HDRC_FORCE_FULLSPEED;
-
-	return 0;
-}
-
 /*
  * Getting a PHY or an USB PHY is optional:
  * If no PHY or USB PHY is found, or if their subsystems aren't enabled,
@@ -673,10 +636,6 @@ struct platform_device *ci_hdrc_add_device(struct device *dev,
 	struct platform_device *pdev;
 	int id, ret;
 
-	ret = ci_get_platdata(dev, platdata);
-	if (ret)
-		return ERR_PTR(ret);
-
 	id = ida_simple_get(&ci_ida, 0, 0, GFP_KERNEL);
 	if (id < 0)
 		return ERR_PTR(id);
-- 
2.1.0

