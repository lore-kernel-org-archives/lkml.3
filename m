Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757931Ab3ANShP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 13:37:15 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:54432 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756282Ab3ANShN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 13:37:13 -0500
From: Tony Prisk <linux@prisktech.co.nz>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linux Walleij <linux.walleij@linaro.org>
Cc: vt8500-wm8505-linux-kernel@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCH v2] gpio: vt8500: memory cleanup missing
Date: Tue, 15 Jan 2013 07:37:24 +1300
Message-Id: <1358188644-23838-1-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver is missing a .remove callback, and the fail path on
probe is incomplete.

If an error occurs in vt8500_add_chips, gpio_base is not unmapped.
The driver is also ignoring the return value from this function so
if a chip fails to register it completes as successful.

Replaced pr_err with dev_err in vt8500_add_chips since the device is
available.

There is also no .remove callback defined. To allow removing the
registered chips, I have moved *vtchip to be a static global.

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
---
Hi Grant,

Let me know what you think of these changes.

v2:
Removed unnecessary whitespace change.
Removed test against pdev->dev.of_node (np). Replaced code with a
  devm_request_and_ioremap so np is now unneccessary. This also removes the need
  for cleanup in the fail path.
Move struct vt8500_gpio_chip within vt8500_data and store the iobase and
  num_banks in vt8500_data.


 drivers/gpio/gpio-vt8500.c |   61 +++++++++++++++++++++++++++++++++++---------
 1 file changed, 49 insertions(+), 12 deletions(-)

diff --git a/drivers/gpio/gpio-vt8500.c b/drivers/gpio/gpio-vt8500.c
index b53320a..5c8cd7c 100644
--- a/drivers/gpio/gpio-vt8500.c
+++ b/drivers/gpio/gpio-vt8500.c
@@ -127,6 +127,12 @@ struct vt8500_gpio_chip {
 	void __iomem	*base;
 };
 
+struct vt8500_data {
+	struct vt8500_gpio_chip *chip;
+	void __iomem *iobase;
+	int num_banks;
+};
+
 
 #define to_vt8500(__chip) container_of(__chip, struct vt8500_gpio_chip, chip)
 
@@ -224,19 +230,32 @@ static int vt8500_of_xlate(struct gpio_chip *gc,
 static int vt8500_add_chips(struct platform_device *pdev, void __iomem *base,
 				const struct vt8500_gpio_data *data)
 {
+	struct vt8500_data *priv;
 	struct vt8500_gpio_chip *vtchip;
 	struct gpio_chip *chip;
 	int i;
 	int pin_cnt = 0;
 
-	vtchip = devm_kzalloc(&pdev->dev,
+	priv = devm_kzalloc(&pdev->dev, sizeof(struct vt8500_data), GFP_KERNEL);
+	if (!priv) {
+		dev_err(&pdev->dev, "failed to allocate memory\n");
+		return -ENOMEM;
+	}
+
+	priv->chip = devm_kzalloc(&pdev->dev,
 			sizeof(struct vt8500_gpio_chip) * data->num_banks,
 			GFP_KERNEL);
-	if (!vtchip) {
-		pr_err("%s: failed to allocate chip memory\n", __func__);
+	if (!priv->chip) {
+		dev_err(&pdev->dev, "failed to allocate chip memory\n");
 		return -ENOMEM;
 	}
 
+	priv->iobase = base;
+	priv->num_banks = data->num_banks;
+	platform_set_drvdata(pdev, priv);
+
+	vtchip = priv->chip;
+
 	for (i = 0; i < data->num_banks; i++) {
 		vtchip[i].base = base;
 		vtchip[i].regs = &data->banks[i];
@@ -273,36 +292,54 @@ static struct of_device_id vt8500_gpio_dt_ids[] = {
 
 static int vt8500_gpio_probe(struct platform_device *pdev)
 {
+	int ret;
 	void __iomem *gpio_base;
-	struct device_node *np;
+	struct resource *res;
 	const struct of_device_id *of_id =
 				of_match_device(vt8500_gpio_dt_ids, &pdev->dev);
 
 	if (!of_id) {
-		dev_err(&pdev->dev, "Failed to find gpio controller\n");
+		dev_err(&pdev->dev, "No matching driver data\n");
 		return -ENODEV;
 	}
 
-	np = pdev->dev.of_node;
-	if (!np) {
-		dev_err(&pdev->dev, "Missing GPIO description in devicetree\n");
-		return -EFAULT;
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(&pdev->dev, "Unable to get IO resource\n");
+		return -ENODEV;
 	}
 
-	gpio_base = of_iomap(np, 0);
+	gpio_base = devm_request_and_ioremap(&pdev->dev, res);
 	if (!gpio_base) {
 		dev_err(&pdev->dev, "Unable to map GPIO registers\n");
-		of_node_put(np);
 		return -ENOMEM;
 	}
 
-	vt8500_add_chips(pdev, gpio_base, of_id->data);
+	ret = vt8500_add_chips(pdev, gpio_base, of_id->data);
+
+	return ret;
+}
+
+static int vt8500_gpio_remove(struct platform_device *pdev)
+{
+	int i;
+	int ret;
+	struct vt8500_data *priv = platform_get_drvdata(pdev);
+	struct vt8500_gpio_chip *vtchip = priv->chip;
+
+	for (i = 0; i < priv->num_banks; i++) {
+		ret = gpiochip_remove(&vtchip[i].chip);
+		if (ret)
+			dev_warn(&pdev->dev, "gpiochip_remove returned %d\n",
+				 ret);
+	}
 
 	return 0;
 }
 
 static struct platform_driver vt8500_gpio_driver = {
 	.probe		= vt8500_gpio_probe,
+	.remove		= vt8500_gpio_remove,
 	.driver		= {
 		.name	= "vt8500-gpio",
 		.owner	= THIS_MODULE,
-- 
1.7.9.5

