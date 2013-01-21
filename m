Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010Ab3AULKz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 06:10:55 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:45539 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751404Ab3AULKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 06:10:53 -0500
From: Roger Quadros <rogerq@ti.com>
To: <sameo@linux.intel.com>, <balbi@ti.com>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>
CC: <kishon@ti.com>, <sshtylyov@mvista.com>, <bjorn@mork.no>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <rogerq@ti.com>
Subject: [PATCH v9 15/22] mfd: omap-usb-host: cleanup clock management code
Date: Mon, 21 Jan 2013 13:10:29 +0200
Message-ID: <1358766629-5656-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1358511445-26656-16-git-send-email-rogerq@ti.com>
References: <1358511445-26656-16-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All ports have similarly named port clocks so we can
bunch them into a port data structure and use for loop
to enable/disable the clocks.

Dynamically allocate and get clocks based on number of ports
available on the platform

Signed-off-by: Roger Quadros <rogerq@ti.com>
Reviewed-by: Felipe Balbi <balbi@ti.com>
---
 drivers/mfd/omap-usb-host.c |  186 ++++++++++++++++++++++++------------------
 1 files changed, 106 insertions(+), 80 deletions(-)

diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index 779588b..9fa0215 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -92,13 +92,12 @@
 
 struct usbhs_hcd_omap {
 	int				nports;
+	struct clk			**utmi_clk;
 
 	struct clk			*xclk60mhsp1_ck;
 	struct clk			*xclk60mhsp2_ck;
-	struct clk			*utmi_p1_fck;
-	struct clk			*usbhost_p1_fck;
-	struct clk			*utmi_p2_fck;
-	struct clk			*usbhost_p2_fck;
+	struct clk			*utmi_p1_gfclk;
+	struct clk			*utmi_p2_gfclk;
 	struct clk			*init_60m_fclk;
 	struct clk			*ehci_logic_fck;
 
@@ -276,22 +275,25 @@ static int usbhs_runtime_resume(struct device *dev)
 	struct usbhs_hcd_omap		*omap = dev_get_drvdata(dev);
 	struct usbhs_omap_platform_data	*pdata = omap->pdata;
 	unsigned long			flags;
+	int i, r;
 
 	dev_dbg(dev, "usbhs_runtime_resume\n");
 
 	omap_tll_enable();
 	spin_lock_irqsave(&omap->lock, flags);
 
-	if (omap->ehci_logic_fck && !IS_ERR(omap->ehci_logic_fck))
+	if (!IS_ERR(omap->ehci_logic_fck))
 		clk_enable(omap->ehci_logic_fck);
 
-	if (is_ehci_tll_mode(pdata->port_mode[0]))
-		clk_enable(omap->usbhost_p1_fck);
-	if (is_ehci_tll_mode(pdata->port_mode[1]))
-		clk_enable(omap->usbhost_p2_fck);
+	for (i = 0; i < omap->nports; i++) {
+		if (!is_ehci_tll_mode(pdata->port_mode[i]) ||
+				IS_ERR(omap->utmi_clk[i]))
+			continue;
 
-	clk_enable(omap->utmi_p1_fck);
-	clk_enable(omap->utmi_p2_fck);
+		r = clk_enable(omap->utmi_clk[i]);
+		if (r)
+			dev_err(dev, "Can't enable port %d clk : %d\n", i, r);
+	}
 
 	spin_unlock_irqrestore(&omap->lock, flags);
 
@@ -303,20 +305,19 @@ static int usbhs_runtime_suspend(struct device *dev)
 	struct usbhs_hcd_omap		*omap = dev_get_drvdata(dev);
 	struct usbhs_omap_platform_data	*pdata = omap->pdata;
 	unsigned long			flags;
+	int i;
 
 	dev_dbg(dev, "usbhs_runtime_suspend\n");
 
 	spin_lock_irqsave(&omap->lock, flags);
 
-	if (is_ehci_tll_mode(pdata->port_mode[0]))
-		clk_disable(omap->usbhost_p1_fck);
-	if (is_ehci_tll_mode(pdata->port_mode[1]))
-		clk_disable(omap->usbhost_p2_fck);
-
-	clk_disable(omap->utmi_p2_fck);
-	clk_disable(omap->utmi_p1_fck);
+	for (i = 0; i < omap->nports; i++) {
+		if (is_ehci_tll_mode(pdata->port_mode[i]) &&
+				!IS_ERR(omap->utmi_clk[i]))
+			clk_disable(omap->utmi_clk[i]);
+	}
 
-	if (omap->ehci_logic_fck && !IS_ERR(omap->ehci_logic_fck))
+	if (!IS_ERR(omap->ehci_logic_fck))
 		clk_disable(omap->ehci_logic_fck);
 
 	spin_unlock_irqrestore(&omap->lock, flags);
@@ -458,6 +459,7 @@ static int usbhs_omap_probe(struct platform_device *pdev)
 	struct resource			*res;
 	int				ret = 0;
 	int				i;
+	bool				need_logic_fck;
 
 	if (!pdata) {
 		dev_err(dev, "Missing platform data\n");
@@ -516,76 +518,91 @@ static int usbhs_omap_probe(struct platform_device *pdev)
 		}
 	}
 
-	for (i = 0; i < omap->nports; i++)
+	i = sizeof(struct clk *) * omap->nports;
+	omap->utmi_clk = devm_kzalloc(dev, i, GFP_KERNEL);
+	if (!omap->utmi_clk) {
+		dev_err(dev, "Memory allocation failed\n");
+		ret = -ENOMEM;
+		goto err_mem;
+	}
+
+	need_logic_fck = false;
+	for (i = 0; i < omap->nports; i++) {
 		if (is_ehci_phy_mode(i) || is_ehci_tll_mode(i) ||
-			is_ehci_hsic_mode(i)) {
-			omap->ehci_logic_fck = clk_get(dev, "ehci_logic_fck");
-			if (IS_ERR(omap->ehci_logic_fck)) {
-				ret = PTR_ERR(omap->ehci_logic_fck);
-				dev_warn(dev, "ehci_logic_fck failed:%d\n",
-					 ret);
-			}
-			break;
+			is_ehci_hsic_mode(i))
+				need_logic_fck |= true;
+	}
+
+	omap->ehci_logic_fck = ERR_PTR(-EINVAL);
+	if (need_logic_fck) {
+		omap->ehci_logic_fck = clk_get(dev, "ehci_logic_fck");
+		if (IS_ERR(omap->ehci_logic_fck)) {
+			ret = PTR_ERR(omap->ehci_logic_fck);
+			dev_dbg(dev, "ehci_logic_fck failed:%d\n", ret);
 		}
+	}
 
-	omap->utmi_p1_fck = clk_get(dev, "utmi_p1_gfclk");
-	if (IS_ERR(omap->utmi_p1_fck)) {
-		ret = PTR_ERR(omap->utmi_p1_fck);
-		dev_err(dev, "utmi_p1_gfclk failed error:%d\n",	ret);
-		goto err_end;
+	omap->utmi_p1_gfclk = clk_get(dev, "utmi_p1_gfclk");
+	if (IS_ERR(omap->utmi_p1_gfclk)) {
+		ret = PTR_ERR(omap->utmi_p1_gfclk);
+		dev_err(dev, "utmi_p1_gfclk failed error:%d\n", ret);
+		goto err_p1_gfclk;
+	}
+
+	omap->utmi_p2_gfclk = clk_get(dev, "utmi_p2_gfclk");
+	if (IS_ERR(omap->utmi_p2_gfclk)) {
+		ret = PTR_ERR(omap->utmi_p2_gfclk);
+		dev_err(dev, "utmi_p2_gfclk failed error:%d\n", ret);
+		goto err_p2_gfclk;
 	}
 
 	omap->xclk60mhsp1_ck = clk_get(dev, "xclk60mhsp1_ck");
 	if (IS_ERR(omap->xclk60mhsp1_ck)) {
 		ret = PTR_ERR(omap->xclk60mhsp1_ck);
 		dev_err(dev, "xclk60mhsp1_ck failed error:%d\n", ret);
-		goto err_utmi_p1_fck;
-	}
-
-	omap->utmi_p2_fck = clk_get(dev, "utmi_p2_gfclk");
-	if (IS_ERR(omap->utmi_p2_fck)) {
-		ret = PTR_ERR(omap->utmi_p2_fck);
-		dev_err(dev, "utmi_p2_gfclk failed error:%d\n", ret);
-		goto err_xclk60mhsp1_ck;
+		goto err_xclk60mhsp1;
 	}
 
 	omap->xclk60mhsp2_ck = clk_get(dev, "xclk60mhsp2_ck");
 	if (IS_ERR(omap->xclk60mhsp2_ck)) {
 		ret = PTR_ERR(omap->xclk60mhsp2_ck);
 		dev_err(dev, "xclk60mhsp2_ck failed error:%d\n", ret);
-		goto err_utmi_p2_fck;
-	}
-
-	omap->usbhost_p1_fck = clk_get(dev, "usb_host_hs_utmi_p1_clk");
-	if (IS_ERR(omap->usbhost_p1_fck)) {
-		ret = PTR_ERR(omap->usbhost_p1_fck);
-		dev_err(dev, "usbhost_p1_fck failed error:%d\n", ret);
-		goto err_xclk60mhsp2_ck;
-	}
-
-	omap->usbhost_p2_fck = clk_get(dev, "usb_host_hs_utmi_p2_clk");
-	if (IS_ERR(omap->usbhost_p2_fck)) {
-		ret = PTR_ERR(omap->usbhost_p2_fck);
-		dev_err(dev, "usbhost_p2_fck failed error:%d\n", ret);
-		goto err_usbhost_p1_fck;
+		goto err_xclk60mhsp2;
 	}
 
 	omap->init_60m_fclk = clk_get(dev, "init_60m_fclk");
 	if (IS_ERR(omap->init_60m_fclk)) {
 		ret = PTR_ERR(omap->init_60m_fclk);
 		dev_err(dev, "init_60m_fclk failed error:%d\n", ret);
-		goto err_usbhost_p2_fck;
+		goto err_init60m;
+	}
+
+	for (i = 0; i < omap->nports; i++) {
+		char clkname[] = "usb_host_hs_utmi_px_clk";
+
+		/* clock names are indexed from 1*/
+		snprintf(clkname, sizeof(clkname),
+				"usb_host_hs_utmi_p%d_clk", i + 1);
+
+		/* If a clock is not found we won't bail out as not all
+		 * platforms have all clocks and we can function without
+		 * them
+		 */
+		omap->utmi_clk[i] = clk_get(dev, clkname);
+		if (IS_ERR(omap->utmi_clk[i]))
+			dev_dbg(dev, "Failed to get clock : %s : %ld\n",
+				clkname, PTR_ERR(omap->utmi_clk[i]));
 	}
 
 	if (is_ehci_phy_mode(pdata->port_mode[0])) {
 		/* for OMAP3 , the clk set paretn fails */
-		ret = clk_set_parent(omap->utmi_p1_fck,
+		ret = clk_set_parent(omap->utmi_p1_gfclk,
 					omap->xclk60mhsp1_ck);
 		if (ret != 0)
 			dev_err(dev, "xclk60mhsp1_ck set parent"
 				"failed error:%d\n", ret);
 	} else if (is_ehci_tll_mode(pdata->port_mode[0])) {
-		ret = clk_set_parent(omap->utmi_p1_fck,
+		ret = clk_set_parent(omap->utmi_p1_gfclk,
 					omap->init_60m_fclk);
 		if (ret != 0)
 			dev_err(dev, "init_60m_fclk set parent"
@@ -593,13 +610,13 @@ static int usbhs_omap_probe(struct platform_device *pdev)
 	}
 
 	if (is_ehci_phy_mode(pdata->port_mode[1])) {
-		ret = clk_set_parent(omap->utmi_p2_fck,
+		ret = clk_set_parent(omap->utmi_p2_gfclk,
 					omap->xclk60mhsp2_ck);
 		if (ret != 0)
 			dev_err(dev, "xclk60mhsp2_ck set parent"
 					"failed error:%d\n", ret);
 	} else if (is_ehci_tll_mode(pdata->port_mode[1])) {
-		ret = clk_set_parent(omap->utmi_p2_fck,
+		ret = clk_set_parent(omap->utmi_p2_gfclk,
 						omap->init_60m_fclk);
 		if (ret != 0)
 			dev_err(dev, "init_60m_fclk set parent"
@@ -617,28 +634,30 @@ static int usbhs_omap_probe(struct platform_device *pdev)
 
 err_alloc:
 	omap_usbhs_deinit(&pdev->dev);
-	clk_put(omap->init_60m_fclk);
 
-err_usbhost_p2_fck:
-	clk_put(omap->usbhost_p2_fck);
+	for (i = 0; i < omap->nports; i++)
+		if (!IS_ERR(omap->utmi_clk[i]))
+			clk_put(omap->utmi_clk[i]);
 
-err_usbhost_p1_fck:
-	clk_put(omap->usbhost_p1_fck);
+	clk_put(omap->init_60m_fclk);
 
-err_xclk60mhsp2_ck:
+err_init60m:
 	clk_put(omap->xclk60mhsp2_ck);
 
-err_utmi_p2_fck:
-	clk_put(omap->utmi_p2_fck);
-
-err_xclk60mhsp1_ck:
+err_xclk60mhsp2:
 	clk_put(omap->xclk60mhsp1_ck);
 
-err_utmi_p1_fck:
-	clk_put(omap->utmi_p1_fck);
+err_xclk60mhsp1:
+	clk_put(omap->utmi_p2_gfclk);
 
-err_end:
-	clk_put(omap->ehci_logic_fck);
+err_p2_gfclk:
+	clk_put(omap->utmi_p1_gfclk);
+
+err_p1_gfclk:
+	if (!IS_ERR(omap->ehci_logic_fck))
+		clk_put(omap->ehci_logic_fck);
+
+err_mem:
 	pm_runtime_disable(dev);
 
 	return ret;
@@ -653,16 +672,23 @@ err_end:
 static int usbhs_omap_remove(struct platform_device *pdev)
 {
 	struct usbhs_hcd_omap *omap = platform_get_drvdata(pdev);
+	int i;
 
 	omap_usbhs_deinit(&pdev->dev);
+
+	for (i = 0; i < omap->nports; i++)
+		if (!IS_ERR(omap->utmi_clk[i]))
+			clk_put(omap->utmi_clk[i]);
+
 	clk_put(omap->init_60m_fclk);
-	clk_put(omap->usbhost_p2_fck);
-	clk_put(omap->usbhost_p1_fck);
+	clk_put(omap->utmi_p1_gfclk);
+	clk_put(omap->utmi_p2_gfclk);
 	clk_put(omap->xclk60mhsp2_ck);
-	clk_put(omap->utmi_p2_fck);
 	clk_put(omap->xclk60mhsp1_ck);
-	clk_put(omap->utmi_p1_fck);
-	clk_put(omap->ehci_logic_fck);
+
+	if (!IS_ERR(omap->ehci_logic_fck))
+		clk_put(omap->ehci_logic_fck);
+
 	pm_runtime_disable(&pdev->dev);
 
 	return 0;
-- 
1.7.4.1

