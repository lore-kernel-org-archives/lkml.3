Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762324Ab3DCIrv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 04:47:51 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:46329 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760582Ab3DCIro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 04:47:44 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Praveena Nadahally <praveen.nadahally@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@linaro.org>,
        Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>,
        Sakethram Bommisetti <sakethram.bommisetti@stericsson.com>
Subject: [PATCH 07/12] usb: phy: ab8500-usb: enable/disable regulator on phy events
Date: Wed,  3 Apr 2013 10:45:08 +0200
Message-Id: <1364978713-19612-8-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1364978713-19612-1-git-send-email-fabio.baltieri@linaro.org>
References: <1364978713-19612-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ab8500_usb_regulator_{enable,disable} functions to control USB phy
regulators on corresponding ab8500_usb_phy_{enable,disable} events.

This contains some workaround and optimization for specific AB8500
versions.

Signed-off-by: Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>
Signed-off-by: Sakethram Bommisetti <sakethram.bommisetti@stericsson.com>
Signed-off-by: Praveena Nadahally <praveen.nadahally@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/usb/phy/phy-ab8500-usb.c | 68 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 66 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/phy/phy-ab8500-usb.c b/drivers/usb/phy/phy-ab8500-usb.c
index 1c6eec9..803ad93 100644
--- a/drivers/usb/phy/phy-ab8500-usb.c
+++ b/drivers/usb/phy/phy-ab8500-usb.c
@@ -130,6 +130,7 @@ struct ab8500_usb {
 	struct regulator *v_ape;
 	struct regulator *v_musb;
 	struct regulator *v_ulpi;
+	int saved_v_ulpi;
 	int previous_link_status_state;
 };
 
@@ -161,6 +162,67 @@ static void ab8500_usb_wd_workaround(struct ab8500_usb *ab)
 		0);
 }
 
+static void ab8500_usb_regulator_enable(struct ab8500_usb *ab)
+{
+	int ret, volt;
+
+	regulator_enable(ab->v_ape);
+
+	if (!is_ab8500_2p0_or_earlier(ab->ab8500)) {
+		ab->saved_v_ulpi = regulator_get_voltage(ab->v_ulpi);
+		if (ab->saved_v_ulpi < 0)
+			dev_err(ab->dev, "Failed to get v_ulpi voltage\n");
+
+		ret = regulator_set_voltage(ab->v_ulpi, 1300000, 1350000);
+		if (ret < 0)
+			dev_err(ab->dev, "Failed to set the Vintcore to 1.3V, ret=%d\n",
+					ret);
+
+		ret = regulator_set_optimum_mode(ab->v_ulpi, 28000);
+		if (ret < 0)
+			dev_err(ab->dev, "Failed to set optimum mode (ret=%d)\n",
+					ret);
+	}
+
+	regulator_enable(ab->v_ulpi);
+
+	if (!is_ab8500_2p0_or_earlier(ab->ab8500)) {
+		volt = regulator_get_voltage(ab->v_ulpi);
+		if ((volt != 1300000) && (volt != 1350000))
+			dev_err(ab->dev, "Vintcore is not set to 1.3V volt=%d\n",
+					volt);
+	}
+
+	regulator_enable(ab->v_musb);
+}
+
+static void ab8500_usb_regulator_disable(struct ab8500_usb *ab)
+{
+	int ret;
+
+	regulator_disable(ab->v_musb);
+
+	regulator_disable(ab->v_ulpi);
+
+	/* USB is not the only consumer of Vintcore, restore old settings */
+	if (!is_ab8500_2p0_or_earlier(ab->ab8500)) {
+		if (ab->saved_v_ulpi > 0) {
+			ret = regulator_set_voltage(ab->v_ulpi,
+					ab->saved_v_ulpi, ab->saved_v_ulpi);
+			if (ret < 0)
+				dev_err(ab->dev, "Failed to set the Vintcore to %duV, ret=%d\n",
+						ab->saved_v_ulpi, ret);
+		}
+
+		ret = regulator_set_optimum_mode(ab->v_ulpi, 0);
+		if (ret < 0)
+			dev_err(ab->dev, "Failed to set optimum mode (ret=%d)\n",
+					ret);
+	}
+
+	regulator_disable(ab->v_ape);
+}
+
 static void ab8500_usb_wd_linkstatus(struct ab8500_usb *ab, u8 bit)
 {
 	/* Workaround for v2.0 bug # 31952 */
@@ -178,6 +240,8 @@ static void ab8500_usb_phy_enable(struct ab8500_usb *ab, bool sel_host)
 	bit = sel_host ? AB8500_BIT_PHY_CTRL_HOST_EN :
 		AB8500_BIT_PHY_CTRL_DEVICE_EN;
 
+	ab8500_usb_regulator_enable(ab);
+
 	abx500_mask_and_set_register_interruptible(ab->dev,
 			AB8500_USB, AB8500_USB_PHY_CTRL_REG,
 			bit, bit);
@@ -197,6 +261,8 @@ static void ab8500_usb_phy_disable(struct ab8500_usb *ab, bool sel_host)
 
 	/* Needed to disable the phy.*/
 	ab8500_usb_wd_workaround(ab);
+
+	ab8500_usb_regulator_disable(ab);
 }
 
 #define ab8500_usb_host_phy_en(ab)	ab8500_usb_phy_enable(ab, true)
@@ -543,7 +609,6 @@ static int ab8500_usb_set_peripheral(struct usb_otg *otg,
 	 */
 
 	if (!gadget) {
-		/* TODO: Disable regulators. */
 		otg->gadget = NULL;
 		schedule_work(&ab->phy_dis_work);
 	} else {
@@ -575,7 +640,6 @@ static int ab8500_usb_set_host(struct usb_otg *otg, struct usb_bus *host)
 	 */
 
 	if (!host) {
-		/* TODO: Disable regulators. */
 		otg->host = NULL;
 		schedule_work(&ab->phy_dis_work);
 	} else {
-- 
1.8.1.3

