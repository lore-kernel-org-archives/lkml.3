Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932809Ab3CLLZm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 07:25:42 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:38826 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754970Ab3CLLZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 07:25:39 -0400
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>
CC: <tony@atomide.com>, <mark.rutland@arm.com>, <mkl@pengutronix.de>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <rogerq@ti.com>
Subject: [PATCH 3/8] usb: phy: nop: Manage PHY clock
Date: Tue, 12 Mar 2013 13:24:21 +0200
Message-ID: <1363087466-32444-4-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1363087466-32444-1-git-send-email-rogerq@ti.com>
References: <1363087466-32444-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the PHY has a clock associated to it then manage the clock.
We just enable the clock in .init() and disable it in .shutdown().

Add clk_rate parameter in platform data and configure the
clock rate during probe if supplied.

Signed-off-by: Roger Quadros <rogerq@ti.com>
Acked-by: Felipe Balbi <balbi@ti.com>
---
 drivers/usb/otg/nop-usb-xceiv.c |   54 ++++++++++++++++++++++++++++++++++++++-
 1 files changed, 53 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/otg/nop-usb-xceiv.c b/drivers/usb/otg/nop-usb-xceiv.c
index af52870..17c174f 100644
--- a/drivers/usb/otg/nop-usb-xceiv.c
+++ b/drivers/usb/otg/nop-usb-xceiv.c
@@ -32,10 +32,12 @@
 #include <linux/usb/otg.h>
 #include <linux/usb/nop-usb-xceiv.h>
 #include <linux/slab.h>
+#include <linux/clk.h>
 
 struct nop_usb_xceiv {
 	struct usb_phy		phy;
 	struct device		*dev;
+	struct clk		*clk;
 };
 
 static struct platform_device *pd;
@@ -64,6 +66,24 @@ static int nop_set_suspend(struct usb_phy *x, int suspend)
 	return 0;
 }
 
+static int nop_init(struct usb_phy *phy)
+{
+	struct nop_usb_xceiv *nop = dev_get_drvdata(phy->dev);
+
+	if (!IS_ERR(nop->clk))
+		clk_enable(nop->clk);
+
+	return 0;
+}
+
+static void nop_shutdown(struct usb_phy *phy)
+{
+	struct nop_usb_xceiv *nop = dev_get_drvdata(phy->dev);
+
+	if (!IS_ERR(nop->clk))
+		clk_disable(nop->clk);
+}
+
 static int nop_set_peripheral(struct usb_otg *otg, struct usb_gadget *gadget)
 {
 	if (!otg)
@@ -112,10 +132,34 @@ static int nop_usb_xceiv_probe(struct platform_device *pdev)
 	if (pdata)
 		type = pdata->type;
 
+	nop->clk = devm_clk_get(&pdev->dev, "main_clk");
+	if (IS_ERR(nop->clk)) {
+		dev_dbg(&pdev->dev, "Can't get phy clock: %ld\n",
+					PTR_ERR(nop->clk));
+	}
+
+	if (!IS_ERR(nop->clk) && pdata && pdata->clk_rate) {
+		err = clk_set_rate(nop->clk, pdata->clk_rate);
+		if (err) {
+			dev_err(&pdev->dev, "Error setting clock rate\n");
+			return err;
+		}
+	}
+
+	if (!IS_ERR(nop->clk)) {
+		err = clk_prepare(nop->clk);
+		if (err) {
+			dev_err(&pdev->dev, "Error preparing clock\n");
+			return err;
+		}
+	}
+
 	nop->dev		= &pdev->dev;
 	nop->phy.dev		= nop->dev;
 	nop->phy.label		= "nop-xceiv";
 	nop->phy.set_suspend	= nop_set_suspend;
+	nop->phy.init		= nop_init;
+	nop->phy.shutdown	= nop_shutdown;
 	nop->phy.state		= OTG_STATE_UNDEFINED;
 
 	nop->phy.otg->phy		= &nop->phy;
@@ -126,7 +170,7 @@ static int nop_usb_xceiv_probe(struct platform_device *pdev)
 	if (err) {
 		dev_err(&pdev->dev, "can't register transceiver, err: %d\n",
 			err);
-		return err;
+		goto err_add;
 	}
 
 	platform_set_drvdata(pdev, nop);
@@ -134,12 +178,20 @@ static int nop_usb_xceiv_probe(struct platform_device *pdev)
 	ATOMIC_INIT_NOTIFIER_HEAD(&nop->phy.notifier);
 
 	return 0;
+
+err_add:
+	if (!IS_ERR(nop->clk))
+		clk_unprepare(nop->clk);
+	return err;
 }
 
 static int nop_usb_xceiv_remove(struct platform_device *pdev)
 {
 	struct nop_usb_xceiv *nop = platform_get_drvdata(pdev);
 
+	if (!IS_ERR(nop->clk))
+		clk_unprepare(nop->clk);
+
 	usb_remove_phy(&nop->phy);
 
 	platform_set_drvdata(pdev, NULL);
-- 
1.7.4.1

