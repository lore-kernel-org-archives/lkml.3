Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047Ab3AULMF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 06:12:05 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:58740 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752398Ab3AULMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 06:12:03 -0500
From: Roger Quadros <rogerq@ti.com>
To: <sameo@linux.intel.com>, <balbi@ti.com>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>
CC: <kishon@ti.com>, <sshtylyov@mvista.com>, <bjorn@mork.no>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <rogerq@ti.com>
Subject: [PATCH v9 16/22] mfd: omap-usb-host: Manage HSIC clocks for HSIC mode
Date: Mon, 21 Jan 2013 13:11:50 +0200
Message-ID: <1358766710-5694-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1358511445-26656-18-git-send-email-rogerq@ti.com>
References: <1358511445-26656-18-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable the optional HSIC clocks (60MHz and 480MHz) for the ports
that are configured in HSIC mode.

Signed-off-by: Roger Quadros <rogerq@ti.com>
Reviewed-by: Felipe Balbi <balbi@ti.com>
---
 drivers/mfd/omap-usb-host.c |   97 ++++++++++++++++++++++++++++++++++++------
 1 files changed, 83 insertions(+), 14 deletions(-)

diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index 9fa0215..bdfc8b7 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -93,6 +93,8 @@
 struct usbhs_hcd_omap {
 	int				nports;
 	struct clk			**utmi_clk;
+	struct clk			**hsic60m_clk;
+	struct clk			**hsic480m_clk;
 
 	struct clk			*xclk60mhsp1_ck;
 	struct clk			*xclk60mhsp2_ck;
@@ -286,13 +288,40 @@ static int usbhs_runtime_resume(struct device *dev)
 		clk_enable(omap->ehci_logic_fck);
 
 	for (i = 0; i < omap->nports; i++) {
-		if (!is_ehci_tll_mode(pdata->port_mode[i]) ||
-				IS_ERR(omap->utmi_clk[i]))
-			continue;
-
-		r = clk_enable(omap->utmi_clk[i]);
-		if (r)
-			dev_err(dev, "Can't enable port %d clk : %d\n", i, r);
+		switch (pdata->port_mode[i]) {
+		case OMAP_EHCI_PORT_MODE_HSIC:
+			if (!IS_ERR(omap->hsic60m_clk[i])) {
+				r = clk_enable(omap->hsic60m_clk[i]);
+				if (r) {
+					dev_err(dev,
+					 "Can't enable port %d hsic60m clk:%d\n",
+					 i, r);
+				}
+			}
+
+			if (!IS_ERR(omap->hsic480m_clk[i])) {
+				r = clk_enable(omap->hsic480m_clk[i]);
+				if (r) {
+					dev_err(dev,
+					 "Can't enable port %d hsic480m clk:%d\n",
+					 i, r);
+				}
+			}
+		/* Fall through as HSIC mode needs utmi_clk */
+
+		case OMAP_EHCI_PORT_MODE_TLL:
+			if (!IS_ERR(omap->utmi_clk[i])) {
+				r = clk_enable(omap->utmi_clk[i]);
+				if (r) {
+					dev_err(dev,
+					 "Can't enable port %d clk : %d\n",
+					 i, r);
+				}
+			}
+			break;
+		default:
+			break;
+		}
 	}
 
 	spin_unlock_irqrestore(&omap->lock, flags);
@@ -312,9 +341,22 @@ static int usbhs_runtime_suspend(struct device *dev)
 	spin_lock_irqsave(&omap->lock, flags);
 
 	for (i = 0; i < omap->nports; i++) {
-		if (is_ehci_tll_mode(pdata->port_mode[i]) &&
-				!IS_ERR(omap->utmi_clk[i]))
-			clk_disable(omap->utmi_clk[i]);
+		switch (pdata->port_mode[i]) {
+		case OMAP_EHCI_PORT_MODE_HSIC:
+			if (!IS_ERR(omap->hsic60m_clk[i]))
+				clk_disable(omap->hsic60m_clk[i]);
+
+			if (!IS_ERR(omap->hsic480m_clk[i]))
+				clk_disable(omap->hsic480m_clk[i]);
+		/* Fall through as utmi_clks were used in HSIC mode */
+
+		case OMAP_EHCI_PORT_MODE_TLL:
+			if (!IS_ERR(omap->utmi_clk[i]))
+				clk_disable(omap->utmi_clk[i]);
+			break;
+		default:
+			break;
+		}
 	}
 
 	if (!IS_ERR(omap->ehci_logic_fck))
@@ -520,7 +562,10 @@ static int usbhs_omap_probe(struct platform_device *pdev)
 
 	i = sizeof(struct clk *) * omap->nports;
 	omap->utmi_clk = devm_kzalloc(dev, i, GFP_KERNEL);
-	if (!omap->utmi_clk) {
+	omap->hsic480m_clk = devm_kzalloc(dev, i, GFP_KERNEL);
+	omap->hsic60m_clk = devm_kzalloc(dev, i, GFP_KERNEL);
+
+	if (!omap->utmi_clk || !omap->hsic480m_clk || !omap->hsic60m_clk) {
 		dev_err(dev, "Memory allocation failed\n");
 		ret = -ENOMEM;
 		goto err_mem;
@@ -578,7 +623,7 @@ static int usbhs_omap_probe(struct platform_device *pdev)
 	}
 
 	for (i = 0; i < omap->nports; i++) {
-		char clkname[] = "usb_host_hs_utmi_px_clk";
+		char clkname[30];
 
 		/* clock names are indexed from 1*/
 		snprintf(clkname, sizeof(clkname),
@@ -592,6 +637,20 @@ static int usbhs_omap_probe(struct platform_device *pdev)
 		if (IS_ERR(omap->utmi_clk[i]))
 			dev_dbg(dev, "Failed to get clock : %s : %ld\n",
 				clkname, PTR_ERR(omap->utmi_clk[i]));
+
+		snprintf(clkname, sizeof(clkname),
+				"usb_host_hs_hsic480m_p%d_clk", i + 1);
+		omap->hsic480m_clk[i] = clk_get(dev, clkname);
+		if (IS_ERR(omap->hsic480m_clk[i]))
+			dev_dbg(dev, "Failed to get clock : %s : %ld\n",
+				clkname, PTR_ERR(omap->hsic480m_clk[i]));
+
+		snprintf(clkname, sizeof(clkname),
+				"usb_host_hs_hsic60m_p%d_clk", i + 1);
+		omap->hsic60m_clk[i] = clk_get(dev, clkname);
+		if (IS_ERR(omap->hsic60m_clk[i]))
+			dev_dbg(dev, "Failed to get clock : %s : %ld\n",
+				clkname, PTR_ERR(omap->hsic60m_clk[i]));
 	}
 
 	if (is_ehci_phy_mode(pdata->port_mode[0])) {
@@ -635,9 +694,14 @@ static int usbhs_omap_probe(struct platform_device *pdev)
 err_alloc:
 	omap_usbhs_deinit(&pdev->dev);
 
-	for (i = 0; i < omap->nports; i++)
+	for (i = 0; i < omap->nports; i++) {
 		if (!IS_ERR(omap->utmi_clk[i]))
 			clk_put(omap->utmi_clk[i]);
+		if (!IS_ERR(omap->hsic60m_clk[i]))
+			clk_put(omap->hsic60m_clk[i]);
+		if (!IS_ERR(omap->hsic480m_clk[i]))
+			clk_put(omap->hsic480m_clk[i]);
+	}
 
 	clk_put(omap->init_60m_fclk);
 
@@ -676,9 +740,14 @@ static int usbhs_omap_remove(struct platform_device *pdev)
 
 	omap_usbhs_deinit(&pdev->dev);
 
-	for (i = 0; i < omap->nports; i++)
+	for (i = 0; i < omap->nports; i++) {
 		if (!IS_ERR(omap->utmi_clk[i]))
 			clk_put(omap->utmi_clk[i]);
+		if (!IS_ERR(omap->hsic60m_clk[i]))
+			clk_put(omap->hsic60m_clk[i]);
+		if (!IS_ERR(omap->hsic480m_clk[i]))
+			clk_put(omap->hsic480m_clk[i]);
+	}
 
 	clk_put(omap->init_60m_fclk);
 	clk_put(omap->utmi_p1_gfclk);
-- 
1.7.4.1

