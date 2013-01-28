Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999Ab3A1LbB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 06:31:01 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:42738 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756950Ab3A1La4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 06:30:56 -0500
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>
CC: <linux@arm.linux.org.uk>, <sameo@linux.intel.com>, <balbi@ti.com>,
        <stern@rowland.harvard.edu>, <gregkh@linuxfoundation.org>,
        <eballetbo@gmail.com>, <javier@dowhile0.org>, <sshtylyov@mvista.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v2 03/30] usb: phy: nop: Manage PHY clock
Date: Mon, 28 Jan 2013 13:30:04 +0200
Message-ID: <1359372631-8180-4-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1359372631-8180-1-git-send-email-rogerq@ti.com>
References: <1359372631-8180-1-git-send-email-rogerq@ti.com>
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
---
 drivers/usb/otg/nop-usb-xceiv.c   |   54 ++++++++++++++++++++++++++++++++++++-
 include/linux/usb/nop-usb-xceiv.h |    1 +
 2 files changed, 54 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/otg/nop-usb-xceiv.c b/drivers/usb/otg/nop-usb-xceiv.c
index 7ffb0c8..849eb9d 100644
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
@@ -111,10 +131,34 @@ static int nop_usb_xceiv_probe(struct platform_device *pdev)
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
@@ -125,7 +169,7 @@ static int nop_usb_xceiv_probe(struct platform_device *pdev)
 	if (err) {
 		dev_err(&pdev->dev, "can't register transceiver, err: %d\n",
 			err);
-		return err;
+		goto err_add;
 	}
 
 	platform_set_drvdata(pdev, nop);
@@ -133,12 +177,20 @@ static int nop_usb_xceiv_probe(struct platform_device *pdev)
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
diff --git a/include/linux/usb/nop-usb-xceiv.h b/include/linux/usb/nop-usb-xceiv.h
index 28884c7..3265b61 100644
--- a/include/linux/usb/nop-usb-xceiv.h
+++ b/include/linux/usb/nop-usb-xceiv.h
@@ -5,6 +5,7 @@
 
 struct nop_usb_xceiv_platform_data {
 	enum usb_phy_type type;
+	unsigned long clk_rate;
 };
 
 #if defined(CONFIG_NOP_USB_XCEIV) || (defined(CONFIG_NOP_USB_XCEIV_MODULE) && defined(MODULE))
-- 
1.7.4.1

