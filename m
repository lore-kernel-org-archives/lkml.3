Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822AbaEOKSt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 06:18:49 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54480 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751802AbaEOKSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 06:18:46 -0400
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH v6 04/17] usb: ehci-orion: add optional PHY support
Date: Thu, 15 May 2014 12:17:29 +0200
Message-Id: <1400149062-32661-5-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1400149062-32661-1-git-send-email-gregory.clement@free-electrons.com>
References: <1400149062-32661-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit extends the ehci-orion so that it can optionally be passed
a reference to a PHY through the Device Tree. It will be useful for
the Armada 375 SoCs. If no PHY is provided then the behavior of the
driver is unchanged.

[Thomas: use devm_phy_optional_get() so that we handle -EPROBE_DEFER
properly. Also call phy_power_off() when needed, and rename goto
labels.]

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
---
 drivers/usb/host/ehci-orion.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/usb/host/ehci-orion.c b/drivers/usb/host/ehci-orion.c
index 9c98bac0a5bc..22e15cab8ea5 100644
--- a/drivers/usb/host/ehci-orion.c
+++ b/drivers/usb/host/ehci-orion.c
@@ -15,6 +15,7 @@
 #include <linux/clk.h>
 #include <linux/platform_data/usb-ehci-orion.h>
 #include <linux/of.h>
+#include <linux/phy/phy.h>
 #include <linux/of_device.h>
 #include <linux/of_irq.h>
 #include <linux/usb.h>
@@ -46,6 +47,7 @@
 
 struct orion_ehci_hcd {
 	struct clk *clk;
+	struct phy *phy;
 };
 
 static const char hcd_name[] = "ehci-orion";
@@ -221,6 +223,20 @@ static int ehci_orion_drv_probe(struct platform_device *pdev)
 	if (!IS_ERR(priv->clk))
 		clk_prepare_enable(priv->clk);
 
+	priv->phy = devm_phy_optional_get(&pdev->dev, "usb");
+	if (IS_ERR(priv->phy)) {
+		err = PTR_ERR(priv->phy);
+		goto err_phy_get;
+	} else {
+		err = phy_init(priv->phy);
+		if (err)
+			goto err_phy_init;
+
+		err = phy_power_on(priv->phy);
+		if (err)
+			goto err_phy_power_on;
+	}
+
 	/*
 	 * (Re-)program MBUS remapping windows if we are asked to.
 	 */
@@ -256,6 +272,13 @@ static int ehci_orion_drv_probe(struct platform_device *pdev)
 	return 0;
 
 err_add_hcd:
+	if (!IS_ERR(priv->phy))
+		phy_power_off(priv->phy);
+err_phy_power_on:
+	if (!IS_ERR(priv->phy))
+		phy_exit(priv->phy);
+err_phy_init:
+err_phy_get:
 	if (!IS_ERR(priv->clk))
 		clk_disable_unprepare(priv->clk);
 	usb_put_hcd(hcd);
@@ -273,6 +296,11 @@ static int ehci_orion_drv_remove(struct platform_device *pdev)
 
 	usb_remove_hcd(hcd);
 
+	if (!IS_ERR(priv->phy)) {
+		phy_power_off(priv->phy);
+		phy_exit(priv->phy);
+	}
+
 	if (!IS_ERR(priv->clk))
 		clk_disable_unprepare(priv->clk);
 
-- 
1.8.1.2

