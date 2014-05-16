Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297AbaEPNGK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:06:10 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:51848 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754323AbaEPNDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:03:19 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 01/11] phy: omap-usb2: Use generic clock names "wkupclk" and "refclk"
Date: Fri, 16 May 2014 18:32:56 +0530
Message-ID: <1400245387-14445-2-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400245387-14445-1-git-send-email-kishon@ti.com>
References: <1400245387-14445-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roger Quadros <rogerq@ti.com>

As clocks might be named differently on multiple platforms, use a generic
name in the driver and allow device tree node to specify the platform
specific clock name.

Reviewed-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Roger Quadros <rogerq@ti.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/phy-omap-usb2.c |   30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/drivers/phy/phy-omap-usb2.c b/drivers/phy/phy-omap-usb2.c
index a2205a8..7007c11 100644
--- a/drivers/phy/phy-omap-usb2.c
+++ b/drivers/phy/phy-omap-usb2.c
@@ -275,18 +275,34 @@ static int omap_usb2_probe(struct platform_device *pdev)
 	if (IS_ERR(phy_provider))
 		return PTR_ERR(phy_provider);
 
-	phy->wkupclk = devm_clk_get(phy->dev, "usb_phy_cm_clk32k");
+	phy->wkupclk = devm_clk_get(phy->dev, "wkupclk");
 	if (IS_ERR(phy->wkupclk)) {
-		dev_err(&pdev->dev, "unable to get usb_phy_cm_clk32k\n");
-		return PTR_ERR(phy->wkupclk);
+		dev_warn(&pdev->dev, "unable to get wkupclk, trying old name\n");
+		phy->wkupclk = devm_clk_get(phy->dev, "usb_phy_cm_clk32k");
+		if (IS_ERR(phy->wkupclk)) {
+			dev_err(&pdev->dev, "unable to get usb_phy_cm_clk32k\n");
+			return PTR_ERR(phy->wkupclk);
+		} else {
+			dev_warn(&pdev->dev,
+				 "found usb_phy_cm_clk32k, please fix DTS\n");
+		}
 	}
 	clk_prepare(phy->wkupclk);
 
-	phy->optclk = devm_clk_get(phy->dev, "usb_otg_ss_refclk960m");
-	if (IS_ERR(phy->optclk))
-		dev_vdbg(&pdev->dev, "unable to get refclk960m\n");
-	else
+	phy->optclk = devm_clk_get(phy->dev, "refclk");
+	if (IS_ERR(phy->optclk)) {
+		dev_dbg(&pdev->dev, "unable to get refclk, trying old name\n");
+		phy->optclk = devm_clk_get(phy->dev, "usb_otg_ss_refclk960m");
+		if (IS_ERR(phy->optclk)) {
+			dev_dbg(&pdev->dev,
+				"unable to get usb_otg_ss_refclk960m\n");
+		} else {
+			dev_warn(&pdev->dev,
+				 "found usb_otg_ss_refclk960m, please fix DTS\n");
+		}
+	} else {
 		clk_prepare(phy->optclk);
+	}
 
 	usb_add_phy_dev(&phy->phy);
 
-- 
1.7.9.5

