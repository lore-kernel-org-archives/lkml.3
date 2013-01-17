Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882Ab3AQLb1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 06:31:27 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:47447 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340Ab3AQLbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 06:31:16 -0500
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>, <sameo@linux.intel.com>, <tony@atomide.com>
CC: <kishon@ti.com>, <sshtylyov@mvista.com>, <bjorn@mork.no>,
        <linux@arm.linux.org.uk>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <rogerq@ti.com>
Subject: [PATCH v7 04/22] mfd: omap-usb-tll: Clean up clock handling
Date: Thu, 17 Jan 2013 13:30:13 +0200
Message-ID: <1358422231-24736-5-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1358422231-24736-1-git-send-email-rogerq@ti.com>
References: <1358422231-24736-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Every channel has a functional clock that is similarly named.
It makes sense to use a for loop to manage these clocks as OMAPs
can come with up to 3 channels.

Dynamically allocate and get channel clocks depending on the
number of clocks avaiable on the platform.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/mfd/omap-usb-tll.c |   89 +++++++++++++++++++++++++++----------------
 1 files changed, 56 insertions(+), 33 deletions(-)

diff --git a/drivers/mfd/omap-usb-tll.c b/drivers/mfd/omap-usb-tll.c
index 9a19cc7..4ce134b 100644
--- a/drivers/mfd/omap-usb-tll.c
+++ b/drivers/mfd/omap-usb-tll.c
@@ -96,10 +96,9 @@
 #define is_ehci_tll_mode(x)	(x == OMAP_EHCI_PORT_MODE_TLL)
 
 struct usbtll_omap {
-	struct clk				*usbtll_p1_fck;
-	struct clk				*usbtll_p2_fck;
 	int					nch;	/* num. of channels */
 	struct usbhs_omap_platform_data		*pdata;
+	struct clk				**ch_clk;
 	/* secure the register updates */
 	spinlock_t				lock;
 };
@@ -225,26 +224,12 @@ static int usbtll_omap_probe(struct platform_device *pdev)
 
 	tll->pdata = pdata;
 
-	tll->usbtll_p1_fck = clk_get(dev, "usb_tll_hs_usb_ch0_clk");
-	if (IS_ERR(tll->usbtll_p1_fck)) {
-		ret = PTR_ERR(tll->usbtll_p1_fck);
-		dev_err(dev, "usbtll_p1_fck failed error:%d\n", ret);
-		return ret;
-	}
-
-	tll->usbtll_p2_fck = clk_get(dev, "usb_tll_hs_usb_ch1_clk");
-	if (IS_ERR(tll->usbtll_p2_fck)) {
-		ret = PTR_ERR(tll->usbtll_p2_fck);
-		dev_err(dev, "usbtll_p2_fck failed error:%d\n", ret);
-		goto err_p2_fck;
-	}
-
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	base = devm_request_and_ioremap(dev, res);
 	if (!base) {
 		ret = -EADDRNOTAVAIL;
 		dev_err(dev, "Resource request/ioremap failed:%d\n", ret);
-		goto err_res;
+		return ret;
 	}
 
 	platform_set_drvdata(pdev, tll);
@@ -270,6 +255,32 @@ static int usbtll_omap_probe(struct platform_device *pdev)
 		break;
 	}
 
+	spin_unlock_irqrestore(&tll->lock, flags);
+
+	tll->ch_clk = devm_kzalloc(dev, sizeof(struct clk * [tll->nch]),
+						GFP_KERNEL);
+	if (!tll->ch_clk) {
+		ret = -ENOMEM;
+		dev_err(dev, "Couldn't allocate memory for channel clocks\n");
+		goto err_clk_alloc;
+	}
+
+	for (i = 0; i < tll->nch; i++) {
+		char clkname[] = "usb_tll_hs_usb_chx_clk";
+		struct clk *fck;
+
+		snprintf(clkname, sizeof(clkname),
+					"usb_tll_hs_usb_ch%d_clk", i);
+		fck = clk_get(dev, clkname);
+
+		if (IS_ERR(fck))
+			dev_dbg(dev, "can't get clock : %s\n", clkname);
+		else
+			tll->ch_clk[i] = fck;
+	}
+
+	spin_lock_irqsave(&tll->lock, flags);
+
 	if (is_ehci_tll_mode(pdata->port_mode[0]) ||
 	    is_ehci_tll_mode(pdata->port_mode[1]) ||
 	    is_ehci_tll_mode(pdata->port_mode[2]) ||
@@ -321,11 +332,9 @@ static int usbtll_omap_probe(struct platform_device *pdev)
 
 	return 0;
 
-err_res:
-	clk_put(tll->usbtll_p2_fck);
-
-err_p2_fck:
-	clk_put(tll->usbtll_p1_fck);
+err_clk_alloc:
+	pm_runtime_put_sync(dev);
+	pm_runtime_disable(dev);
 
 	return ret;
 }
@@ -339,9 +348,11 @@ err_p2_fck:
 static int usbtll_omap_remove(struct platform_device *pdev)
 {
 	struct usbtll_omap *tll = platform_get_drvdata(pdev);
+	int i;
+
+	for (i = 0; i < tll->nch; i++)
+		clk_put(tll->ch_clk[i]);
 
-	clk_put(tll->usbtll_p2_fck);
-	clk_put(tll->usbtll_p1_fck);
 	pm_runtime_disable(&pdev->dev);
 	return 0;
 }
@@ -351,6 +362,7 @@ static int usbtll_runtime_resume(struct device *dev)
 	struct usbtll_omap			*tll = dev_get_drvdata(dev);
 	struct usbhs_omap_platform_data		*pdata = tll->pdata;
 	unsigned long				flags;
+	int i;
 
 	dev_dbg(dev, "usbtll_runtime_resume\n");
 
@@ -361,11 +373,20 @@ static int usbtll_runtime_resume(struct device *dev)
 
 	spin_lock_irqsave(&tll->lock, flags);
 
-	if (is_ehci_tll_mode(pdata->port_mode[0]))
-		clk_enable(tll->usbtll_p1_fck);
+	for (i = 0; i < tll->nch; i++) {
+		if (is_ehci_tll_mode(pdata->port_mode[i])) {
+			int r;
 
-	if (is_ehci_tll_mode(pdata->port_mode[1]))
-		clk_enable(tll->usbtll_p2_fck);
+			if (!tll->ch_clk[i])
+				continue;
+
+			r = clk_enable(tll->ch_clk[i]);
+			if (r) {
+				dev_err(dev,
+				 "Error enabling ch %d clock: %d\n", i, r);
+			}
+		}
+	}
 
 	spin_unlock_irqrestore(&tll->lock, flags);
 
@@ -377,6 +398,7 @@ static int usbtll_runtime_suspend(struct device *dev)
 	struct usbtll_omap			*tll = dev_get_drvdata(dev);
 	struct usbhs_omap_platform_data		*pdata = tll->pdata;
 	unsigned long				flags;
+	int i;
 
 	dev_dbg(dev, "usbtll_runtime_suspend\n");
 
@@ -387,11 +409,12 @@ static int usbtll_runtime_suspend(struct device *dev)
 
 	spin_lock_irqsave(&tll->lock, flags);
 
-	if (is_ehci_tll_mode(pdata->port_mode[0]))
-		clk_disable(tll->usbtll_p1_fck);
-
-	if (is_ehci_tll_mode(pdata->port_mode[1]))
-		clk_disable(tll->usbtll_p2_fck);
+	for (i = 0; i < tll->nch; i++) {
+		if (is_ehci_tll_mode(pdata->port_mode[i])) {
+			if (tll->ch_clk[i])
+				clk_disable(tll->ch_clk[i]);
+		}
+	}
 
 	spin_unlock_irqrestore(&tll->lock, flags);
 
-- 
1.7.4.1

