Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987Ab3HBTZn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 15:25:43 -0400
Received: from www.linutronix.de ([62.245.132.108]:50741 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755819Ab3HBTYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 15:24:17 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Felipe Balbi <balbi@ti.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        george.cherian@ti.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 1/5] usb: phy: phy-generic: export init functions
Date: Fri,  2 Aug 2013 21:24:06 +0200
Message-Id: <1375471450-31154-2-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375471450-31154-1-git-send-email-bigeasy@linutronix.de>
References: <1375471450-31154-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch exports the mostly generic functions so they can be used from
other phy driver instead of duplicating the code.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/usb/phy/phy-generic.c | 130 ++++++++++++++++++++++++------------------
 drivers/usb/phy/phy-generic.h |  20 +++++++
 2 files changed, 93 insertions(+), 57 deletions(-)
 create mode 100644 drivers/usb/phy/phy-generic.h

diff --git a/drivers/usb/phy/phy-generic.c b/drivers/usb/phy/phy-generic.c
index f379b7d..8808974 100644
--- a/drivers/usb/phy/phy-generic.c
+++ b/drivers/usb/phy/phy-generic.c
@@ -36,13 +36,7 @@
 #include <linux/regulator/consumer.h>
 #include <linux/of.h>
 
-struct usb_phy_gen_xceiv {
-	struct usb_phy phy;
-	struct device *dev;
-	struct clk *clk;
-	struct regulator *vcc;
-	struct regulator *reset;
-};
+#include "phy-generic.h"
 
 static struct platform_device *pd;
 
@@ -70,7 +64,7 @@ static int nop_set_suspend(struct usb_phy *x, int suspend)
 	return 0;
 }
 
-static int nop_init(struct usb_phy *phy)
+int usb_gen_phy_init(struct usb_phy *phy)
 {
 	struct usb_phy_gen_xceiv *nop = dev_get_drvdata(phy->dev);
 
@@ -90,8 +84,9 @@ static int nop_init(struct usb_phy *phy)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(usb_gen_phy_init);
 
-static void nop_shutdown(struct usb_phy *phy)
+void usb_gen_phy_shutdown(struct usb_phy *phy)
 {
 	struct usb_phy_gen_xceiv *nop = dev_get_drvdata(phy->dev);
 
@@ -109,6 +104,7 @@ static void nop_shutdown(struct usb_phy *phy)
 			dev_err(phy->dev, "Failed to disable power\n");
 	}
 }
+EXPORT_SYMBOL_GPL(usb_gen_phy_shutdown);
 
 static int nop_set_peripheral(struct usb_otg *otg, struct usb_gadget *gadget)
 {
@@ -139,52 +135,27 @@ static int nop_set_host(struct usb_otg *otg, struct usb_bus *host)
 	return 0;
 }
 
-static int usb_phy_gen_xceiv_probe(struct platform_device *pdev)
+int usb_phy_gen_create_phy(struct device *dev, struct usb_phy_gen_xceiv *nop,
+		enum usb_phy_type type, u32 clk_rate, bool needs_vcc,
+		bool needs_reset)
 {
-	struct device *dev = &pdev->dev;
-	struct usb_phy_gen_xceiv_platform_data *pdata = pdev->dev.platform_data;
-	struct usb_phy_gen_xceiv	*nop;
-	enum usb_phy_type	type = USB_PHY_TYPE_USB2;
 	int err;
-	u32 clk_rate = 0;
-	bool needs_vcc = false;
-	bool needs_reset = false;
-
-	nop = devm_kzalloc(&pdev->dev, sizeof(*nop), GFP_KERNEL);
-	if (!nop)
-		return -ENOMEM;
 
-	nop->phy.otg = devm_kzalloc(&pdev->dev, sizeof(*nop->phy.otg),
-							GFP_KERNEL);
+	nop->phy.otg = devm_kzalloc(dev, sizeof(*nop->phy.otg),
+			GFP_KERNEL);
 	if (!nop->phy.otg)
 		return -ENOMEM;
 
-	if (dev->of_node) {
-		struct device_node *node = dev->of_node;
-
-		if (of_property_read_u32(node, "clock-frequency", &clk_rate))
-			clk_rate = 0;
-
-		needs_vcc = of_property_read_bool(node, "vcc-supply");
-		needs_reset = of_property_read_bool(node, "reset-supply");
-
-	} else if (pdata) {
-		type = pdata->type;
-		clk_rate = pdata->clk_rate;
-		needs_vcc = pdata->needs_vcc;
-		needs_reset = pdata->needs_reset;
-	}
-
-	nop->clk = devm_clk_get(&pdev->dev, "main_clk");
+	nop->clk = devm_clk_get(dev, "main_clk");
 	if (IS_ERR(nop->clk)) {
-		dev_dbg(&pdev->dev, "Can't get phy clock: %ld\n",
+		dev_dbg(dev, "Can't get phy clock: %ld\n",
 					PTR_ERR(nop->clk));
 	}
 
 	if (!IS_ERR(nop->clk) && clk_rate) {
 		err = clk_set_rate(nop->clk, clk_rate);
 		if (err) {
-			dev_err(&pdev->dev, "Error setting clock rate\n");
+			dev_err(dev, "Error setting clock rate\n");
 			return err;
 		}
 	}
@@ -192,33 +163,31 @@ static int usb_phy_gen_xceiv_probe(struct platform_device *pdev)
 	if (!IS_ERR(nop->clk)) {
 		err = clk_prepare(nop->clk);
 		if (err) {
-			dev_err(&pdev->dev, "Error preparing clock\n");
+			dev_err(dev, "Error preparing clock\n");
 			return err;
 		}
 	}
 
-	nop->vcc = devm_regulator_get(&pdev->dev, "vcc");
+	nop->vcc = devm_regulator_get(dev, "vcc");
 	if (IS_ERR(nop->vcc)) {
-		dev_dbg(&pdev->dev, "Error getting vcc regulator: %ld\n",
+		dev_dbg(dev, "Error getting vcc regulator: %ld\n",
 					PTR_ERR(nop->vcc));
 		if (needs_vcc)
 			return -EPROBE_DEFER;
 	}
 
-	nop->reset = devm_regulator_get(&pdev->dev, "reset");
+	nop->reset = devm_regulator_get(dev, "reset");
 	if (IS_ERR(nop->reset)) {
-		dev_dbg(&pdev->dev, "Error getting reset regulator: %ld\n",
+		dev_dbg(dev, "Error getting reset regulator: %ld\n",
 					PTR_ERR(nop->reset));
 		if (needs_reset)
 			return -EPROBE_DEFER;
 	}
 
-	nop->dev		= &pdev->dev;
+	nop->dev		= dev;
 	nop->phy.dev		= nop->dev;
 	nop->phy.label		= "nop-xceiv";
 	nop->phy.set_suspend	= nop_set_suspend;
-	nop->phy.init		= nop_init;
-	nop->phy.shutdown	= nop_shutdown;
 	nop->phy.state		= OTG_STATE_UNDEFINED;
 	nop->phy.type		= type;
 
@@ -226,6 +195,58 @@ static int usb_phy_gen_xceiv_probe(struct platform_device *pdev)
 	nop->phy.otg->set_host		= nop_set_host;
 	nop->phy.otg->set_peripheral	= nop_set_peripheral;
 
+	ATOMIC_INIT_NOTIFIER_HEAD(&nop->phy.notifier);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(usb_phy_gen_create_phy);
+
+void usb_phy_gen_cleanup_phy(struct usb_phy_gen_xceiv *nop)
+{
+	if (!IS_ERR(nop->clk))
+		clk_unprepare(nop->clk);
+}
+EXPORT_SYMBOL_GPL(usb_phy_gen_cleanup_phy);
+
+static int usb_phy_gen_xceiv_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct usb_phy_gen_xceiv_platform_data *pdata = pdev->dev.platform_data;
+	struct usb_phy_gen_xceiv	*nop;
+	enum usb_phy_type	type = USB_PHY_TYPE_USB2;
+	int err;
+	u32 clk_rate = 0;
+	bool needs_vcc = false;
+	bool needs_reset = false;
+
+	if (dev->of_node) {
+		struct device_node *node = dev->of_node;
+
+		if (of_property_read_u32(node, "clock-frequency", &clk_rate))
+			clk_rate = 0;
+
+		needs_vcc = of_property_read_bool(node, "vcc-supply");
+		needs_reset = of_property_read_bool(node, "reset-supply");
+
+	} else if (pdata) {
+		type = pdata->type;
+		clk_rate = pdata->clk_rate;
+		needs_vcc = pdata->needs_vcc;
+		needs_reset = pdata->needs_reset;
+	}
+
+	nop = devm_kzalloc(dev, sizeof(*nop), GFP_KERNEL);
+	if (!nop)
+		return -ENOMEM;
+
+
+	err = usb_phy_gen_create_phy(dev, nop, type, clk_rate, needs_vcc,
+			needs_reset);
+	if (err)
+		return err;
+
+	nop->phy.init		= usb_gen_phy_init;
+	nop->phy.shutdown	= usb_gen_phy_shutdown;
+
 	err = usb_add_phy_dev(&nop->phy);
 	if (err) {
 		dev_err(&pdev->dev, "can't register transceiver, err: %d\n",
@@ -235,13 +256,10 @@ static int usb_phy_gen_xceiv_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, nop);
 
-	ATOMIC_INIT_NOTIFIER_HEAD(&nop->phy.notifier);
-
 	return 0;
 
 err_add:
-	if (!IS_ERR(nop->clk))
-		clk_unprepare(nop->clk);
+	usb_phy_gen_cleanup_phy(nop);
 	return err;
 }
 
@@ -249,9 +267,7 @@ static int usb_phy_gen_xceiv_remove(struct platform_device *pdev)
 {
 	struct usb_phy_gen_xceiv *nop = platform_get_drvdata(pdev);
 
-	if (!IS_ERR(nop->clk))
-		clk_unprepare(nop->clk);
-
+	usb_phy_gen_cleanup_phy(nop);
 	usb_remove_phy(&nop->phy);
 
 	return 0;
diff --git a/drivers/usb/phy/phy-generic.h b/drivers/usb/phy/phy-generic.h
new file mode 100644
index 0000000..61687d5
--- /dev/null
+++ b/drivers/usb/phy/phy-generic.h
@@ -0,0 +1,20 @@
+#ifndef _PHY_GENERIC_H_
+#define _PHY_GENERIC_H_
+
+struct usb_phy_gen_xceiv {
+	struct usb_phy phy;
+	struct device *dev;
+	struct clk *clk;
+	struct regulator *vcc;
+	struct regulator *reset;
+};
+
+int usb_gen_phy_init(struct usb_phy *phy);
+void usb_gen_phy_shutdown(struct usb_phy *phy);
+
+int usb_phy_gen_create_phy(struct device *dev, struct usb_phy_gen_xceiv *nop,
+		enum usb_phy_type type, u32 clk_rate, bool needs_vcc,
+		bool needs_reset);
+void usb_phy_gen_cleanup_phy(struct usb_phy_gen_xceiv *nop);
+
+#endif
-- 
1.8.3.2

