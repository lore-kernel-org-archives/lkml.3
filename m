Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932568Ab3DCIrZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 04:47:25 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:35713 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761712Ab3DCIrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 04:47:21 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Praveena Nadahally <praveen.nadahally@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 05/12] usb: phy: ab8500-usb: add regulator support
Date: Wed,  3 Apr 2013 10:45:06 +0200
Message-Id: <1364978713-19612-6-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1364978713-19612-1-git-send-email-fabio.baltieri@linaro.org>
References: <1364978713-19612-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add initial regulator support to ab8500-usb by introducing necessary
devm_regulator_get().

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/usb/phy/phy-ab8500-usb.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/usb/phy/phy-ab8500-usb.c b/drivers/usb/phy/phy-ab8500-usb.c
index 1fd0780..4caa820 100644
--- a/drivers/usb/phy/phy-ab8500-usb.c
+++ b/drivers/usb/phy/phy-ab8500-usb.c
@@ -32,6 +32,7 @@
 #include <linux/mfd/abx500.h>
 #include <linux/mfd/abx500/ab8500.h>
 #include <linux/usb/musb-ux500.h>
+#include <linux/regulator/consumer.h>
 
 /* Bank AB8500_SYS_CTRL2_BLOCK */
 #define AB8500_MAIN_WD_CTRL_REG 0x01
@@ -126,6 +127,9 @@ struct ab8500_usb {
 	struct work_struct phy_dis_work;
 	unsigned long link_status_wait;
 	enum ab8500_usb_mode mode;
+	struct regulator *v_ape;
+	struct regulator *v_musb;
+	struct regulator *v_ulpi;
 	int previous_link_status_state;
 };
 
@@ -589,6 +593,34 @@ static int ab8500_usb_set_host(struct usb_otg *otg, struct usb_bus *host)
 	return 0;
 }
 
+static int ab8500_usb_regulator_get(struct ab8500_usb *ab)
+{
+	int err;
+
+	ab->v_ape = devm_regulator_get(ab->dev, "v-ape");
+	if (IS_ERR(ab->v_ape)) {
+		dev_err(ab->dev, "Could not get v-ape supply\n");
+		err = PTR_ERR(ab->v_ape);
+		return err;
+	}
+
+	ab->v_ulpi = devm_regulator_get(ab->dev, "vddulpivio18");
+	if (IS_ERR(ab->v_ulpi)) {
+		dev_err(ab->dev, "Could not get vddulpivio18 supply\n");
+		err = PTR_ERR(ab->v_ulpi);
+		return err;
+	}
+
+	ab->v_musb = devm_regulator_get(ab->dev, "musb_1v8");
+	if (IS_ERR(ab->v_musb)) {
+		dev_err(ab->dev, "Could not get musb_1v8 supply\n");
+		err = PTR_ERR(ab->v_musb);
+		return err;
+	}
+
+	return 0;
+}
+
 static int ab8500_usb_irq_setup(struct platform_device *pdev,
 		struct ab8500_usb *ab)
 {
@@ -686,6 +718,10 @@ static int ab8500_usb_probe(struct platform_device *pdev)
 	/* all: Disable phy when called from set_host and set_peripheral */
 	INIT_WORK(&ab->phy_dis_work, ab8500_usb_phy_disable_work);
 
+	err = ab8500_usb_regulator_get(ab);
+	if (err)
+		return err;
+
 	err = ab8500_usb_irq_setup(pdev, ab);
 	if (err < 0)
 		return err;
-- 
1.8.1.3

