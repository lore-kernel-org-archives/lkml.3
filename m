Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308AbaD1GSP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 02:18:15 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:65266 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004AbaD1GSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 02:18:10 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        kishon@ti.com
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        gregkh@linuxfoundation.org, balbi@ti.com, kgene.kim@samsung.com,
        t.figa@samsung.com, k.debski@samsung.com, sylvester.nawrocki@gmail.com
Subject: [PATCH v7 2/2] phy: exynos5-usbdrd: Add facility for VBUS supply
Date: Mon, 28 Apr 2014 11:47:54 +0530
Message-Id: <1398665874-31238-2-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1398665874-31238-1-git-send-email-gautam.vivek@samsung.com>
References: <1398665874-31238-1-git-send-email-gautam.vivek@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding support to enable/disable VBUS controlled by a
regulator, to enable vbus supply on the port.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---

Changes from v6:
 - Rebased on top of [PATCH v7 1/2] phy: Add new Exynos5 USB 3.0 PHY driver.

 drivers/phy/phy-exynos5-usbdrd.c |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/phy/phy-exynos5-usbdrd.c b/drivers/phy/phy-exynos5-usbdrd.c
index bc381e3..6e8540e 100644
--- a/drivers/phy/phy-exynos5-usbdrd.c
+++ b/drivers/phy/phy-exynos5-usbdrd.c
@@ -23,6 +23,7 @@
 #include <linux/mutex.h>
 #include <linux/mfd/syscon.h>
 #include <linux/regmap.h>
+#include <linux/regulator/consumer.h>
 
 /* Exynos USB PHY registers */
 #define EXYNOS5_FSEL_9MHZ6		0x0
@@ -170,6 +171,7 @@ struct exynos5_usbdrd_phy {
 	} phys[EXYNOS5_DRDPHYS_NUM];
 	u32 extrefclk;
 	struct clk *ref_clk;
+	struct regulator *vbus;
 };
 
 static inline
@@ -438,6 +440,7 @@ static int exynos5_usbdrd_phy_exit(struct phy *phy)
 
 static int exynos5_usbdrd_phy_power_on(struct phy *phy)
 {
+	int ret;
 	struct phy_usb_instance *inst = phy_get_drvdata(phy);
 	struct exynos5_usbdrd_phy *phy_drd = to_usbdrd_phy(inst);
 
@@ -445,10 +448,24 @@ static int exynos5_usbdrd_phy_power_on(struct phy *phy)
 
 	clk_prepare_enable(phy_drd->ref_clk);
 
+	/* Enable VBUS supply */
+	if (phy_drd->vbus) {
+		ret = regulator_enable(phy_drd->vbus);
+		if (ret) {
+			dev_err(phy_drd->dev, "Failed to enable VBUS supply\n");
+			goto fail_vbus;
+		}
+	}
+
 	/* Power-on PHY*/
 	inst->phy_cfg->phy_isol(inst, 0);
 
 	return 0;
+
+fail_vbus:
+	clk_disable_unprepare(phy_drd->ref_clk);
+
+	return ret;
 }
 
 static int exynos5_usbdrd_phy_power_off(struct phy *phy)
@@ -461,6 +478,10 @@ static int exynos5_usbdrd_phy_power_off(struct phy *phy)
 	/* Power-off the PHY */
 	inst->phy_cfg->phy_isol(inst, 1);
 
+	/* Disable VBUS supply */
+	if (phy_drd->vbus)
+		regulator_disable(phy_drd->vbus);
+
 	clk_disable_unprepare(phy_drd->ref_clk);
 
 	return 0;
@@ -583,6 +604,17 @@ static int exynos5_usbdrd_phy_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	/* Get Vbus regulator */
+	phy_drd->vbus = devm_regulator_get(dev, "vbus");
+	if (IS_ERR(phy_drd->vbus)) {
+		ret = PTR_ERR(phy_drd->vbus);
+		if (ret == -EPROBE_DEFER)
+			return ret;
+
+		dev_warn(dev, "Failed to get VBUS supply regulator\n");
+		phy_drd->vbus = NULL;
+	}
+
 	dev_vdbg(dev, "Creating usbdrd_phy phy\n");
 
 	for (i = 0; i < EXYNOS5_DRDPHYS_NUM; i++) {
-- 
1.7.10.4

