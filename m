Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221AbaEFAOb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 20:14:31 -0400
Received: from top.free-electrons.com ([176.31.233.9]:41441 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757153AbaEFAO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 20:14:29 -0400
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
Subject: [PATCH v3 02/20] usb: ehci-orion: Add the optional PHY support
Date: Tue,  6 May 2014 02:13:57 +0200
Message-Id: <1399335255-589-3-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1399335255-589-1-git-send-email-gregory.clement@free-electrons.com>
References: <1399335255-589-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit allows to use the PHY provided through the device tree. It
will be useful for the Armada 375 SoCs. if no PHY is provided then the
behavior of the driver is unchanged.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 drivers/usb/host/ehci-orion.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/ehci-orion.c b/drivers/usb/host/ehci-orion.c
index d6c19c37c76b..f6d9eb2e33cd 100644
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
@@ -224,6 +226,18 @@ static int ehci_orion_drv_probe(struct platform_device *pdev)
 	if (!IS_ERR(priv->clk))
 		clk_prepare_enable(priv->clk);
 
+
+	priv->phy = devm_phy_get(&pdev->dev, "usb");
+	if (!IS_ERR(priv->phy)) {
+		err = phy_init(priv->phy);
+		if (err)
+			goto err2;
+
+		err = phy_power_on(priv->phy);
+		if (err)
+			goto err3;
+	}
+
 	/*
 	 * (Re-)program MBUS remapping windows if we are asked to.
 	 */
@@ -253,14 +267,18 @@ static int ehci_orion_drv_probe(struct platform_device *pdev)
 
 	err = usb_add_hcd(hcd, irq, IRQF_SHARED);
 	if (err)
-		goto err2;
+		goto err4;
 
 	device_wakeup_enable(hcd->self.controller);
 	return 0;
 
-err2:
+err4:
 	usb_put_hcd(hcd);
 
+err3:
+	phy_exit(priv->phy);
+
+err2:
 	if (!IS_ERR(priv->clk))
 		clk_disable_unprepare(priv->clk);
 err1:
@@ -278,6 +296,9 @@ static int ehci_orion_drv_remove(struct platform_device *pdev)
 	usb_remove_hcd(hcd);
 	usb_put_hcd(hcd);
 
+	if (!IS_ERR(priv->phy))
+		phy_exit(priv->phy);
+
 	if (!IS_ERR(priv->clk))
 		clk_disable_unprepare(priv->clk);
 
-- 
1.8.1.2

