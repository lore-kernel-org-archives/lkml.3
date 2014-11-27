Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090AbaK0Gb7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 01:31:59 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:41701 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753328AbaK0G0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 01:26:32 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 08/25] phy: sun4i: add support for USB phy0
Date: Thu, 27 Nov 2014 11:56:00 +0530
Message-ID: <1417069577-1169-9-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1417069577-1169-1-git-send-email-kishon@ti.com>
References: <1417069577-1169-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roman Byshko <rbyshko@gmail.com>

The driver for sun4i USB phys currently supports
only phy1 and phy2 which are used for USB host
controllers. This patch adds support for USB phy0,
which is used by the musb hdrc USB controller.

Signed-off-by: Roman Byshko <rbyshko@gmail.com>
Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/phy-sun4i-usb.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/phy/phy-sun4i-usb.c b/drivers/phy/phy-sun4i-usb.c
index 0baf5ef..6bd2b0c 100644
--- a/drivers/phy/phy-sun4i-usb.c
+++ b/drivers/phy/phy-sun4i-usb.c
@@ -157,6 +157,10 @@ static int sun4i_usb_phy_init(struct phy *_phy)
 		return ret;
 	}
 
+	/* Enable USB 45 Ohm resistor calibration */
+	if (phy->index == 0)
+		sun4i_usb_phy_write(phy, PHY_RES45_CAL_EN, 0x01, 1);
+
 	/* Adjust PHY's magnitude and rate */
 	sun4i_usb_phy_write(phy, PHY_TX_AMPLITUDE_TUNE, 0x14, 5);
 
@@ -213,7 +217,7 @@ static struct phy *sun4i_usb_phy_xlate(struct device *dev,
 {
 	struct sun4i_usb_phy_data *data = dev_get_drvdata(dev);
 
-	if (WARN_ON(args->args[0] == 0 || args->args[0] >= data->num_phys))
+	if (args->args[0] >= data->num_phys)
 		return ERR_PTR(-ENODEV);
 
 	return data->phys[args->args[0]].phy;
@@ -255,8 +259,7 @@ static int sun4i_usb_phy_probe(struct platform_device *pdev)
 	if (IS_ERR(data->base))
 		return PTR_ERR(data->base);
 
-	/* Skip 0, 0 is the phy for otg which is not yet supported. */
-	for (i = 1; i < data->num_phys; i++) {
+	for (i = 0; i < data->num_phys; i++) {
 		struct sun4i_usb_phy *phy = data->phys + i;
 		char name[16];
 
-- 
1.7.9.5

