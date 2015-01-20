Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330AbbATAFZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 19:05:25 -0500
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:51141 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974AbbATAFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 19:05:23 -0500
X-IronPort-AV: E=Sophos;i="5.09,430,1418112000"; 
   d="scan'208";a="55003181"
From: <arun.ramamurthy@broadcom.com>
To: <stern@rowland.harvard.edu>, <linux@prisktech.co.nz>,
        <gregkh@linuxfoundation.org>
CC: <linux-usb@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <sbranden@broadcom.com>,
        <rjui@broadcom.com>, Arun Ramamurthy <arunrama@broadcom.com>
Subject: [PATCHv3 2/2] usb: ohci-platform: add support for multiple phys per controller
Date: Mon, 19 Jan 2015 16:05:30 -0800
Message-ID: <1421712330-11089-3-git-send-email-arun.ramamurthy@broadcom.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1421712330-11089-1-git-send-email-arun.ramamurthy@broadcom.com>
References: <1421712330-11089-1-git-send-email-arun.ramamurthy@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arun Ramamurthy <arunrama@broadcom.com>

Added support for cases where one controller is connected
to multiple phys

Signed-off-by: Arun Ramamurthy <arunrama@broadcom.com>
Reviewed-by: Ray Jui <rjui@broadcom.com>
Reviewed-by: Scott Branden <sbranden@broadcom.com>
Tested-by: Scott Branden <sbranden@broadcom.com>
---
 drivers/usb/host/ohci-platform.c | 82 +++++++++++++++++++++++++++++-----------
 1 file changed, 60 insertions(+), 22 deletions(-)

diff --git a/drivers/usb/host/ohci-platform.c b/drivers/usb/host/ohci-platform.c
index b81d202..613d54e 100644
--- a/drivers/usb/host/ohci-platform.c
+++ b/drivers/usb/host/ohci-platform.c
@@ -38,7 +38,8 @@
 struct ohci_platform_priv {
 	struct clk *clks[OHCI_MAX_CLKS];
 	struct reset_control *rst;
-	struct phy *phy;
+	struct phy **phys;
+	int num_phys;
 };
 
 static const char hcd_name[] = "ohci-platform";
@@ -47,7 +48,7 @@ static int ohci_platform_power_on(struct platform_device *dev)
 {
 	struct usb_hcd *hcd = platform_get_drvdata(dev);
 	struct ohci_platform_priv *priv = hcd_to_ohci_priv(hcd);
-	int clk, ret;
+	int clk, ret, phy_num;
 
 	for (clk = 0; clk < OHCI_MAX_CLKS && priv->clks[clk]; clk++) {
 		ret = clk_prepare_enable(priv->clks[clk]);
@@ -55,20 +56,28 @@ static int ohci_platform_power_on(struct platform_device *dev)
 			goto err_disable_clks;
 	}
 
-	if (priv->phy) {
-		ret = phy_init(priv->phy);
-		if (ret)
-			goto err_disable_clks;
-
-		ret = phy_power_on(priv->phy);
-		if (ret)
-			goto err_exit_phy;
+	for (phy_num = 0; phy_num < priv->num_phys; phy_num++) {
+		if (priv->phys[phy_num]) {
+			ret = phy_init(priv->phys[phy_num]);
+			if (ret)
+				goto err_exit_phy;
+			ret = phy_power_on(priv->phys[phy_num]);
+			if (ret) {
+				phy_exit(priv->phys[phy_num]);
+				goto err_exit_phy;
+			}
+		}
 	}
 
 	return 0;
 
 err_exit_phy:
-	phy_exit(priv->phy);
+	while (--phy_num >= 0) {
+		if (priv->phys[phy_num]) {
+			phy_power_off(priv->phys[phy_num]);
+			phy_exit(priv->phys[phy_num]);
+		}
+	}
 err_disable_clks:
 	while (--clk >= 0)
 		clk_disable_unprepare(priv->clks[clk]);
@@ -80,11 +89,13 @@ static void ohci_platform_power_off(struct platform_device *dev)
 {
 	struct usb_hcd *hcd = platform_get_drvdata(dev);
 	struct ohci_platform_priv *priv = hcd_to_ohci_priv(hcd);
-	int clk;
+	int clk, phy_num;
 
-	if (priv->phy) {
-		phy_power_off(priv->phy);
-		phy_exit(priv->phy);
+	for (phy_num = 0; phy_num < priv->num_phys; phy_num++) {
+		if (priv->phys[phy_num]) {
+			phy_power_off(priv->phys[phy_num]);
+			phy_exit(priv->phys[phy_num]);
+		}
 	}
 
 	for (clk = OHCI_MAX_CLKS - 1; clk >= 0; clk--)
@@ -112,7 +123,8 @@ static int ohci_platform_probe(struct platform_device *dev)
 	struct usb_ohci_pdata *pdata = dev_get_platdata(&dev->dev);
 	struct ohci_platform_priv *priv;
 	struct ohci_hcd *ohci;
-	int err, irq, clk = 0;
+	const char *phy_name;
+	int err, irq, phy_num, clk = 0;
 
 	if (usb_disabled())
 		return -ENODEV;
@@ -160,12 +172,38 @@ static int ohci_platform_probe(struct platform_device *dev)
 		of_property_read_u32(dev->dev.of_node, "num-ports",
 				     &ohci->num_ports);
 
-		priv->phy = devm_phy_get(&dev->dev, "usb");
-		if (IS_ERR(priv->phy)) {
-			err = PTR_ERR(priv->phy);
-			if (err == -EPROBE_DEFER)
-				goto err_put_hcd;
-			priv->phy = NULL;
+		priv->num_phys = of_count_phandle_with_args(dev->dev.of_node,
+				"phys", "#phy-cells");
+		priv->num_phys = priv->num_phys > 0 ? priv->num_phys : 1;
+
+		priv->phys = devm_kcalloc(&dev->dev, priv->num_phys,
+				sizeof(struct phy *), GFP_KERNEL);
+		if (!priv->phys)
+			return -ENOMEM;
+
+		for (phy_num = 0; phy_num < priv->num_phys; phy_num++) {
+				err = of_property_read_string_index(
+						dev->dev.of_node,
+						"phy-names", phy_num,
+						&phy_name);
+
+				if (err < 0) {
+					if (priv->num_phys > 1) {
+						dev_err(&dev->dev, "phy-names not provided");
+						goto err_put_hcd;
+					} else
+						phy_name = "usb";
+				}
+
+				priv->phys[phy_num] = devm_phy_get(&dev->dev,
+						phy_name);
+				if (IS_ERR(priv->phys[phy_num])) {
+					err = PTR_ERR(priv->phys[phy_num]);
+					if ((priv->num_phys > 1) ||
+					    (err == -EPROBE_DEFER))
+						goto err_put_hcd;
+					priv->phys[phy_num] = NULL;
+				}
 		}
 
 		for (clk = 0; clk < OHCI_MAX_CLKS; clk++) {
-- 
2.2.2

