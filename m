Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726AbaG1O6V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 10:58:21 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:51074 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233AbaG1O54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 10:57:56 -0400
From: Stefan Agner <stefan@agner.ch>
To: peter.chen@freescale.com, s.hauer@pengutronix.de, shawn.guo@freescale.com
Cc: b35083@freescale.com, jingchang.lu@freescale.com,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stefan@agner.ch
Subject: [PATCH v2 5/7] chipidea: usbmisc_imx: Add USB support for VF610 SoCs
Date: Mon, 28 Jul 2014 16:57:31 +0200
Message-Id: <4ec2e6b9477f346cc6e10f5c5079e0f4ca276a77.1406558450.git.stefan@agner.ch>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <cover.1406558450.git.stefan@agner.ch>
References: <cover.1406558450.git.stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds Vybrid VF610 SoC support. The IP is very similar to i.MX6,
however, the non-core registers are spread in two different register
areas. Hence we support multiple instances of the USB misc driver
and add the driver instance to the imx_usbmisc_data structure.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
In the end, I decieded against the advice of Peter to integrate the
multi-instance functionality in a second driver. To support multiple
instances, I needed to extend the imx_usbmisc_data to point to the
instance. Since this is part of the ci_hdrc_imx driver, I feel it's
cleaner to extend the current driver rather to add a second driver
and implement two different handlings in the ci_hdrc_imx driver.

Also, the current approach has a slight advantage for current users
too: EPROBE_DEFER is returned earlier, when initializing the
imx_usbmisc_data structure rather than later on, when accessing
the driver by using imx_usbmisc_init/imx_usbmisc_init_post.

As a free bonus, this driver would now also support the mixed case:
multiple non-core registers in different areas which each support
multiple USB controllers...

Tell me if this is ok for you too.

 .../devicetree/bindings/usb/usbmisc-imx.txt        |  1 +
 drivers/usb/chipidea/ci_hdrc_imx.c                 |  8 ++++
 drivers/usb/chipidea/ci_hdrc_imx.h                 |  1 +
 drivers/usb/chipidea/usbmisc_imx.c                 | 52 +++++++++++++++++-----
 4 files changed, 51 insertions(+), 11 deletions(-)

diff --git a/Documentation/devicetree/bindings/usb/usbmisc-imx.txt b/Documentation/devicetree/bindings/usb/usbmisc-imx.txt
index 97ce94e..c101a4b 100644
--- a/Documentation/devicetree/bindings/usb/usbmisc-imx.txt
+++ b/Documentation/devicetree/bindings/usb/usbmisc-imx.txt
@@ -4,6 +4,7 @@ Required properties:
 - #index-cells: Cells used to descibe usb controller index. Should be <1>
 - compatible: Should be one of below:
 	"fsl,imx6q-usbmisc" for imx6q
+	"fsl,vf610-usbmisc" for Vybrid vf610
 - reg: Should contain registers location and length
 
 Examples:
diff --git a/drivers/usb/chipidea/ci_hdrc_imx.c b/drivers/usb/chipidea/ci_hdrc_imx.c
index 2e58f8d..9af12b4 100644
--- a/drivers/usb/chipidea/ci_hdrc_imx.c
+++ b/drivers/usb/chipidea/ci_hdrc_imx.c
@@ -54,6 +54,7 @@ struct ci_hdrc_imx_data {
 
 static struct imx_usbmisc_data *usbmisc_get_init_data(struct device *dev)
 {
+	struct platform_device *misc_pdev;
 	struct device_node *np = dev->of_node;
 	struct of_phandle_args args;
 	struct imx_usbmisc_data *data;
@@ -79,8 +80,15 @@ static struct imx_usbmisc_data *usbmisc_get_init_data(struct device *dev)
 	}
 
 	data->index = args.args[0];
+
+	misc_pdev = of_find_device_by_node(args.np);
 	of_node_put(args.np);
 
+	if (!misc_pdev)
+		return ERR_PTR(-EPROBE_DEFER);
+
+	data->dev = &misc_pdev->dev;
+
 	if (of_find_property(np, "disable-over-current", NULL))
 		data->disable_oc = 1;
 
diff --git a/drivers/usb/chipidea/ci_hdrc_imx.h b/drivers/usb/chipidea/ci_hdrc_imx.h
index 996ec93..4ed828f 100644
--- a/drivers/usb/chipidea/ci_hdrc_imx.h
+++ b/drivers/usb/chipidea/ci_hdrc_imx.h
@@ -13,6 +13,7 @@
 #define __DRIVER_USB_CHIPIDEA_CI_HDRC_IMX_H
 
 struct imx_usbmisc_data {
+	struct device *dev;
 	int index;
 
 	unsigned int disable_oc:1; /* over current detect disabled */
diff --git a/drivers/usb/chipidea/usbmisc_imx.c b/drivers/usb/chipidea/usbmisc_imx.c
index 85293b8..926c997 100644
--- a/drivers/usb/chipidea/usbmisc_imx.c
+++ b/drivers/usb/chipidea/usbmisc_imx.c
@@ -57,6 +57,8 @@
 
 #define MX6_BM_OVER_CUR_DIS		BIT(7)
 
+#define VF610_OVER_CUR_DIS		BIT(7)
+
 struct usbmisc_ops {
 	/* It's called once when probe a usb device */
 	int (*init)(struct imx_usbmisc_data *data);
@@ -71,10 +73,9 @@ struct imx_usbmisc {
 	const struct usbmisc_ops *ops;
 };
 
-static struct imx_usbmisc *usbmisc;
-
 static int usbmisc_imx25_init(struct imx_usbmisc_data *data)
 {
+	struct imx_usbmisc *usbmisc = dev_get_drvdata(data->dev);
 	unsigned long flags;
 	u32 val = 0;
 
@@ -108,6 +109,7 @@ static int usbmisc_imx25_init(struct imx_usbmisc_data *data)
 
 static int usbmisc_imx25_post(struct imx_usbmisc_data *data)
 {
+	struct imx_usbmisc *usbmisc = dev_get_drvdata(data->dev);
 	void __iomem *reg;
 	unsigned long flags;
 	u32 val;
@@ -130,6 +132,7 @@ static int usbmisc_imx25_post(struct imx_usbmisc_data *data)
 
 static int usbmisc_imx27_init(struct imx_usbmisc_data *data)
 {
+	struct imx_usbmisc *usbmisc = dev_get_drvdata(data->dev);
 	unsigned long flags;
 	u32 val;
 
@@ -160,6 +163,7 @@ static int usbmisc_imx27_init(struct imx_usbmisc_data *data)
 
 static int usbmisc_imx53_init(struct imx_usbmisc_data *data)
 {
+	struct imx_usbmisc *usbmisc = dev_get_drvdata(data->dev);
 	void __iomem *reg = NULL;
 	unsigned long flags;
 	u32 val = 0;
@@ -204,6 +208,7 @@ static int usbmisc_imx53_init(struct imx_usbmisc_data *data)
 
 static int usbmisc_imx6q_init(struct imx_usbmisc_data *data)
 {
+	struct imx_usbmisc *usbmisc = dev_get_drvdata(data->dev);
 	unsigned long flags;
 	u32 reg;
 
@@ -221,6 +226,26 @@ static int usbmisc_imx6q_init(struct imx_usbmisc_data *data)
 	return 0;
 }
 
+static int usbmisc_vf610_init(struct imx_usbmisc_data *data)
+{
+	struct imx_usbmisc *usbmisc = dev_get_drvdata(data->dev);
+	u32 reg;
+
+	/*
+	 * Vybrid only has one misc register set, but in two different
+	 * areas. These is reflected in two instances of this driver.
+	 */
+	if (data->index >= 1)
+		return -EINVAL;
+
+	if (data->disable_oc) {
+		reg = readl(usbmisc->base);
+		writel(reg | VF610_OVER_CUR_DIS, usbmisc->base);
+	}
+
+	return 0;
+}
+
 static const struct usbmisc_ops imx25_usbmisc_ops = {
 	.init = usbmisc_imx25_init,
 	.post = usbmisc_imx25_post,
@@ -238,10 +263,14 @@ static const struct usbmisc_ops imx6q_usbmisc_ops = {
 	.init = usbmisc_imx6q_init,
 };
 
+static const struct usbmisc_ops vf610_usbmisc_ops = {
+	.init = usbmisc_vf610_init,
+};
+
 int imx_usbmisc_init(struct imx_usbmisc_data *data)
 {
-	if (!usbmisc)
-		return -EPROBE_DEFER;
+	struct imx_usbmisc *usbmisc = dev_get_drvdata(data->dev);
+
 	if (!usbmisc->ops->init)
 		return 0;
 	return usbmisc->ops->init(data);
@@ -250,8 +279,8 @@ EXPORT_SYMBOL_GPL(imx_usbmisc_init);
 
 int imx_usbmisc_init_post(struct imx_usbmisc_data *data)
 {
-	if (!usbmisc)
-		return -EPROBE_DEFER;
+	struct imx_usbmisc *usbmisc = dev_get_drvdata(data->dev);
+
 	if (!usbmisc->ops->post)
 		return 0;
 	return usbmisc->ops->post(data);
@@ -283,6 +312,10 @@ static const struct of_device_id usbmisc_imx_dt_ids[] = {
 		.compatible = "fsl,imx6q-usbmisc",
 		.data = &imx6q_usbmisc_ops,
 	},
+	{
+		.compatible = "fsl,vf610-usbmisc",
+		.data = &vf610_usbmisc_ops,
+	},
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, usbmisc_imx_dt_ids);
@@ -294,9 +327,6 @@ static int usbmisc_imx_probe(struct platform_device *pdev)
 	int ret;
 	struct of_device_id *tmp_dev;
 
-	if (usbmisc)
-		return -EBUSY;
-
 	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
@@ -325,15 +355,15 @@ static int usbmisc_imx_probe(struct platform_device *pdev)
 	tmp_dev = (struct of_device_id *)
 		of_match_device(usbmisc_imx_dt_ids, &pdev->dev);
 	data->ops = (const struct usbmisc_ops *)tmp_dev->data;
-	usbmisc = data;
+	platform_set_drvdata(pdev, data);
 
 	return 0;
 }
 
 static int usbmisc_imx_remove(struct platform_device *pdev)
 {
+	struct imx_usbmisc *usbmisc = dev_get_drvdata(&pdev->dev);
 	clk_disable_unprepare(usbmisc->clk);
-	usbmisc = NULL;
 	return 0;
 }
 
-- 
2.0.2

