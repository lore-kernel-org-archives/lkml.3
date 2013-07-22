Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757521Ab3GVSOt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 14:14:49 -0400
Received: from www.linutronix.de ([62.245.132.108]:41799 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932347Ab3GVSKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 14:10:15 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: balbi@ti.com, george.cherian@ti.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 02/16] usb: phy: phy-nop: add support for am335x PHY
Date: Mon, 22 Jul 2013 20:09:53 +0200
Message-Id: <1374516607-2705-3-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1374516607-2705-1-git-send-email-bigeasy@linutronix.de>
References: <1374516607-2705-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The am335x PHY code is well hidden in multiple places. The glue layer
uses the nop and does up/down in the background. This patch copies the
power on / power off part out of dsps so it can be removed later in
dsps. At this point I am not sure if it is better to write a new phy
driver for am335x or just add the missing pieces to this one.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/usb/phy/phy-nop.c | 114 +++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 102 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/phy/phy-nop.c b/drivers/usb/phy/phy-nop.c
index 55445e5d..7c84eec 100644
--- a/drivers/usb/phy/phy-nop.c
+++ b/drivers/usb/phy/phy-nop.c
@@ -35,6 +35,7 @@
 #include <linux/clk.h>
 #include <linux/regulator/consumer.h>
 #include <linux/of.h>
+#include <linux/of_address.h>
 
 struct nop_usb_xceiv {
 	struct usb_phy phy;
@@ -42,6 +43,14 @@ struct nop_usb_xceiv {
 	struct clk *clk;
 	struct regulator *vcc;
 	struct regulator *reset;
+
+	void __iomem *priv_reg;
+};
+
+struct phy_data {
+	int	(*phy_init)(struct usb_phy *x);
+	void	(*phy_shutdown)(struct usb_phy *x);
+	int	(*reg_init)(struct platform_device *pdev);
 };
 
 static struct platform_device *pd;
@@ -139,10 +148,85 @@ static int nop_set_host(struct usb_otg *otg, struct usb_bus *host)
 	return 0;
 }
 
+static int am335x_reg_init(struct platform_device *pdev)
+{
+	struct device_node *node = pdev->dev.of_node;
+	struct nop_usb_xceiv *nop;
+	struct resource res;
+	int ret;
+
+	nop = platform_get_drvdata(pdev);
+	ret = of_address_to_resource(node, 0, &res);
+	if (ret)
+		return ret;
+
+	nop->priv_reg = devm_request_and_ioremap(&pdev->dev, &res);
+	if (!nop->priv_reg)
+		return -EINVAL;
+	return 0;
+}
+
+#define AM335X_USB_CTRL	0x00
+#define AM335x_USB_STS	0x04
+
+#define USBPHY_CM_PWRDN		(1 << 0)
+#define USBPHY_OTG_PWRDN	(1 << 1)
+#define USBPHY_OTGVDET_EN	(1 << 19)
+#define USBPHY_OTGSESSEND_EN	(1 << 20)
+
+static void am335x_phy_power(struct nop_usb_xceiv *nop, bool on)
+{
+	u32 val;
+
+	val = readl(nop->priv_reg);
+	if (on) {
+		val &= ~(USBPHY_CM_PWRDN | USBPHY_OTG_PWRDN);
+		val |= USBPHY_OTGVDET_EN | USBPHY_OTGSESSEND_EN;
+	} else {
+		val |= USBPHY_CM_PWRDN | USBPHY_OTG_PWRDN;
+	}
+
+	writel(val, nop->priv_reg);
+}
+
+static int am335x_phy_init(struct usb_phy *phy)
+{
+	struct nop_usb_xceiv *nop = dev_get_drvdata(phy->dev);
+	int ret;
+
+	ret = nop_init(phy);
+	if (ret)
+		return ret;
+	am335x_phy_power(nop, true);
+	return 0;
+}
+
+static void am335x_phy_shutdown(struct usb_phy *phy)
+{
+	struct nop_usb_xceiv *nop = dev_get_drvdata(phy->dev);
+
+	am335x_phy_power(nop, false);
+	nop_shutdown(phy);
+}
+
+struct phy_data am335x_phy_data = {
+	.reg_init	= am335x_reg_init,
+	.phy_init	= am335x_phy_init,
+	.phy_shutdown	= am335x_phy_shutdown,
+};
+
+static const struct of_device_id nop_xceiv_dt_ids[] = {
+	{ .compatible = "usb-nop-xceiv" },
+	{ .compatible = "ti,am335x-usb-phy", .data = &am335x_phy_data },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, nop_xceiv_dt_ids);
+
 static int nop_usb_xceiv_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct nop_usb_xceiv_platform_data *pdata = pdev->dev.platform_data;
+	const struct phy_data	*phy_data = NULL;
 	struct nop_usb_xceiv	*nop;
 	enum usb_phy_type	type = USB_PHY_TYPE_USB2;
 	int err;
@@ -154,6 +238,7 @@ static int nop_usb_xceiv_probe(struct platform_device *pdev)
 	if (!nop)
 		return -ENOMEM;
 
+	platform_set_drvdata(pdev, nop);
 	nop->phy.otg = devm_kzalloc(&pdev->dev, sizeof(*nop->phy.otg),
 							GFP_KERNEL);
 	if (!nop->phy.otg)
@@ -161,13 +246,20 @@ static int nop_usb_xceiv_probe(struct platform_device *pdev)
 
 	if (dev->of_node) {
 		struct device_node *node = dev->of_node;
+		const struct of_device_id *of_id;
 
 		if (of_property_read_u32(node, "clock-frequency", &clk_rate))
 			clk_rate = 0;
 
 		needs_vcc = of_property_read_bool(node, "vcc-supply");
 		needs_reset = of_property_read_bool(node, "reset-supply");
-
+		of_id = of_match_node(nop_xceiv_dt_ids, node);
+		if (of_id) {
+			phy_data = of_id->data;
+			err = phy_data->reg_init(pdev);
+			if (err)
+				return err;
+		}
 	} else if (pdata) {
 		type = pdata->type;
 		clk_rate = pdata->clk_rate;
@@ -217,8 +309,15 @@ static int nop_usb_xceiv_probe(struct platform_device *pdev)
 	nop->phy.dev		= nop->dev;
 	nop->phy.label		= "nop-xceiv";
 	nop->phy.set_suspend	= nop_set_suspend;
-	nop->phy.init		= nop_init;
-	nop->phy.shutdown	= nop_shutdown;
+	if (phy_data && phy_data->phy_init)
+		nop->phy.init	= phy_data->phy_init;
+	else
+		nop->phy.init	= nop_init;
+
+	if (phy_data && phy_data->phy_shutdown)
+		nop->phy.shutdown = phy_data->phy_shutdown;
+	else
+		nop->phy.shutdown	= nop_shutdown;
 	nop->phy.state		= OTG_STATE_UNDEFINED;
 	nop->phy.type		= type;
 
@@ -233,8 +332,6 @@ static int nop_usb_xceiv_probe(struct platform_device *pdev)
 		goto err_add;
 	}
 
-	platform_set_drvdata(pdev, nop);
-
 	ATOMIC_INIT_NOTIFIER_HEAD(&nop->phy.notifier);
 
 	return 0;
@@ -257,13 +354,6 @@ static int nop_usb_xceiv_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static const struct of_device_id nop_xceiv_dt_ids[] = {
-	{ .compatible = "usb-nop-xceiv" },
-	{ }
-};
-
-MODULE_DEVICE_TABLE(of, nop_xceiv_dt_ids);
-
 static struct platform_driver nop_usb_xceiv_driver = {
 	.probe		= nop_usb_xceiv_probe,
 	.remove		= nop_usb_xceiv_remove,
-- 
1.8.3.2

