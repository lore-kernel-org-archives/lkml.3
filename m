Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443AbaGLUbH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 16:31:07 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:36712 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232AbaGLUaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 16:30:35 -0400
From: abdoulaye berthe <berthe.ab@gmail.com>
To: linus.walleij@linaro.org, gnurou@gmail.com, m@bues.ch,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: abdoulaye berthe <berthe.ab@gmail.com>
Subject: [PATCH 2/2] pinctrl: remove all usage of gpio_remove ret val in driver/pinctl
Date: Sat, 12 Jul 2014 22:30:13 +0200
Message-Id: <1405197014-25225-3-git-send-email-berthe.ab@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405197014-25225-1-git-send-email-berthe.ab@gmail.com>
References: <CACRpkda6mzVdaN0cvOxpbsxWyCv2nGyDXOjZg_5aT8u7SSQeUw@mail.gmail.com>
 <1405197014-25225-1-git-send-email-berthe.ab@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: abdoulaye berthe <berthe.ab@gmail.com>
---
 drivers/pinctrl/pinctrl-adi2.c         |  9 ++++-----
 drivers/pinctrl/pinctrl-as3722.c       | 11 ++---------
 drivers/pinctrl/pinctrl-baytrail.c     |  5 +----
 drivers/pinctrl/pinctrl-coh901.c       | 10 ++--------
 drivers/pinctrl/pinctrl-rockchip.c     | 16 ++++------------
 drivers/pinctrl/sh-pfc/gpio.c          |  9 +++------
 drivers/pinctrl/spear/pinctrl-plgpio.c |  3 +--
 drivers/pinctrl/sunxi/pinctrl-sunxi.c  |  3 +--
 drivers/pinctrl/vt8500/pinctrl-wmt.c   |  9 ++-------
 9 files changed, 20 insertions(+), 55 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-adi2.c b/drivers/pinctrl/pinctrl-adi2.c
index 46413e9..b092b93 100644
--- a/drivers/pinctrl/pinctrl-adi2.c
+++ b/drivers/pinctrl/pinctrl-adi2.c
@@ -949,7 +949,7 @@ static int adi_gpio_probe(struct platform_device *pdev)
 	struct gpio_port *port;
 	char pinctrl_devname[DEVNAME_SIZE];
 	static int gpio;
-	int ret = 0, ret1;
+	int ret = 0;
 
 	pdata = dev->platform_data;
 	if (!pdata)
@@ -1027,7 +1027,7 @@ static int adi_gpio_probe(struct platform_device *pdev)
 	return 0;
 
 out_remove_gpiochip:
-	ret1 = gpiochip_remove(&port->chip);
+	gpiochip_remove(&port->chip);
 out_remove_domain:
 	if (port->pint)
 		irq_domain_remove(port->domain);
@@ -1038,12 +1038,11 @@ out_remove_domain:
 static int adi_gpio_remove(struct platform_device *pdev)
 {
 	struct gpio_port *port = platform_get_drvdata(pdev);
-	int ret;
 	u8 offset;
 
 	list_del(&port->node);
 	gpiochip_remove_pin_ranges(&port->chip);
-	ret = gpiochip_remove(&port->chip);
+	gpiochip_remove(&port->chip);
 	if (port->pint) {
 		for (offset = 0; offset < port->width; offset++)
 			irq_dispose_mapping(irq_find_mapping(port->domain,
@@ -1051,7 +1050,7 @@ static int adi_gpio_remove(struct platform_device *pdev)
 		irq_domain_remove(port->domain);
 	}
 
-	return ret;
+	return 0;
 }
 
 static int adi_pinctrl_probe(struct platform_device *pdev)
diff --git a/drivers/pinctrl/pinctrl-as3722.c b/drivers/pinctrl/pinctrl-as3722.c
index c862f9c0..0e4ec91 100644
--- a/drivers/pinctrl/pinctrl-as3722.c
+++ b/drivers/pinctrl/pinctrl-as3722.c
@@ -565,7 +565,6 @@ static int as3722_pinctrl_probe(struct platform_device *pdev)
 {
 	struct as3722_pctrl_info *as_pci;
 	int ret;
-	int tret;
 
 	as_pci = devm_kzalloc(&pdev->dev, sizeof(*as_pci), GFP_KERNEL);
 	if (!as_pci)
@@ -611,10 +610,7 @@ static int as3722_pinctrl_probe(struct platform_device *pdev)
 	return 0;
 
 fail_range_add:
-	tret = gpiochip_remove(&as_pci->gpio_chip);
-	if (tret < 0)
-		dev_warn(&pdev->dev, "Couldn't remove gpio chip, %d\n", tret);
-
+	gpiochip_remove(&as_pci->gpio_chip);
 fail_chip_add:
 	pinctrl_unregister(as_pci->pctl);
 	return ret;
@@ -623,11 +619,8 @@ fail_chip_add:
 static int as3722_pinctrl_remove(struct platform_device *pdev)
 {
 	struct as3722_pctrl_info *as_pci = platform_get_drvdata(pdev);
-	int ret;
 
-	ret = gpiochip_remove(&as_pci->gpio_chip);
-	if (ret < 0)
-		return ret;
+	gpiochip_remove(&as_pci->gpio_chip);
 	pinctrl_unregister(as_pci->pctl);
 	return 0;
 }
diff --git a/drivers/pinctrl/pinctrl-baytrail.c b/drivers/pinctrl/pinctrl-baytrail.c
index 701a646..d8e9469 100644
--- a/drivers/pinctrl/pinctrl-baytrail.c
+++ b/drivers/pinctrl/pinctrl-baytrail.c
@@ -638,12 +638,9 @@ MODULE_DEVICE_TABLE(acpi, byt_gpio_acpi_match);
 static int byt_gpio_remove(struct platform_device *pdev)
 {
 	struct byt_gpio *vg = platform_get_drvdata(pdev);
-	int err;
 
 	pm_runtime_disable(&pdev->dev);
-	err = gpiochip_remove(&vg->chip);
-	if (err)
-		dev_warn(&pdev->dev, "failed to remove gpio_chip.\n");
+	gpiochip_remove(&vg->chip);
 
 	return 0;
 }
diff --git a/drivers/pinctrl/pinctrl-coh901.c b/drivers/pinctrl/pinctrl-coh901.c
index d182fdd..29cbbab 100644
--- a/drivers/pinctrl/pinctrl-coh901.c
+++ b/drivers/pinctrl/pinctrl-coh901.c
@@ -756,8 +756,7 @@ static int __init u300_gpio_probe(struct platform_device *pdev)
 
 err_no_range:
 err_no_irqchip:
-	if (gpiochip_remove(&gpio->chip))
-		dev_err(&pdev->dev, "failed to remove gpio chip\n");
+	gpiochip_remove(&gpio->chip);
 err_no_chip:
 	clk_disable_unprepare(gpio->clk);
 	dev_err(&pdev->dev, "module ERROR:%d\n", err);
@@ -767,16 +766,11 @@ err_no_chip:
 static int __exit u300_gpio_remove(struct platform_device *pdev)
 {
 	struct u300_gpio *gpio = platform_get_drvdata(pdev);
-	int err;
 
 	/* Turn off the GPIO block */
 	writel(0x00000000U, gpio->base + U300_GPIO_CR);
 
-	err = gpiochip_remove(&gpio->chip);
-	if (err < 0) {
-		dev_err(gpio->dev, "unable to remove gpiochip: %d\n", err);
-		return err;
-	}
+	gpiochip_remove(&gpio->chip);
 	clk_disable_unprepare(gpio->clk);
 	return 0;
 }
diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
index 192aaee..e2e66c8 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -1492,10 +1492,7 @@ fail:
 	for (--i, --bank; i >= 0; --i, --bank) {
 		if (!bank->valid)
 			continue;
-
-		if (gpiochip_remove(&bank->gpio_chip))
-			dev_err(&pdev->dev, "gpio chip %s remove failed\n",
-							bank->gpio_chip.label);
+		gpiochip_remove(&bank->gpio_chip);
 	}
 	return ret;
 }
@@ -1505,20 +1502,15 @@ static int rockchip_gpiolib_unregister(struct platform_device *pdev,
 {
 	struct rockchip_pin_ctrl *ctrl = info->ctrl;
 	struct rockchip_pin_bank *bank = ctrl->pin_banks;
-	int ret = 0;
 	int i;
 
-	for (i = 0; !ret && i < ctrl->nr_banks; ++i, ++bank) {
+	for (i = 0; i < ctrl->nr_banks; ++i, ++bank) {
 		if (!bank->valid)
 			continue;
-
-		ret = gpiochip_remove(&bank->gpio_chip);
+		gpiochip_remove(&bank->gpio_chip);
 	}
 
-	if (ret)
-		dev_err(&pdev->dev, "gpio chip remove failed\n");
-
-	return ret;
+	return 0;
 }
 
 static int rockchip_get_bank_data(struct rockchip_pin_bank *bank,
diff --git a/drivers/pinctrl/sh-pfc/gpio.c b/drivers/pinctrl/sh-pfc/gpio.c
index a9288ab..80f641e 100644
--- a/drivers/pinctrl/sh-pfc/gpio.c
+++ b/drivers/pinctrl/sh-pfc/gpio.c
@@ -409,11 +409,8 @@ int sh_pfc_register_gpiochip(struct sh_pfc *pfc)
 
 int sh_pfc_unregister_gpiochip(struct sh_pfc *pfc)
 {
-	int err;
-	int ret;
-
-	ret = gpiochip_remove(&pfc->gpio->gpio_chip);
-	err = gpiochip_remove(&pfc->func->gpio_chip);
+	gpiochip_remove(&pfc->gpio->gpio_chip);
+	gpiochip_remove(&pfc->func->gpio_chip);
 
-	return ret < 0 ? ret : err;
+	return 0;
 }
diff --git a/drivers/pinctrl/spear/pinctrl-plgpio.c b/drivers/pinctrl/spear/pinctrl-plgpio.c
index 3a20cdc..bddb791 100644
--- a/drivers/pinctrl/spear/pinctrl-plgpio.c
+++ b/drivers/pinctrl/spear/pinctrl-plgpio.c
@@ -606,8 +606,7 @@ static int plgpio_probe(struct platform_device *pdev)
 
 remove_gpiochip:
 	dev_info(&pdev->dev, "Remove gpiochip\n");
-	if (gpiochip_remove(&plgpio->chip))
-		dev_err(&pdev->dev, "unable to remove gpiochip\n");
+	gpiochip_remove(&plgpio->chip);
 unprepare_clk:
 	if (!IS_ERR(plgpio->clk))
 		clk_unprepare(plgpio->clk);
diff --git a/drivers/pinctrl/sunxi/pinctrl-sunxi.c b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
index 47f5e1b..96ee6bb 100644
--- a/drivers/pinctrl/sunxi/pinctrl-sunxi.c
+++ b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
@@ -983,8 +983,7 @@ int sunxi_pinctrl_init(struct platform_device *pdev,
 clk_error:
 	clk_disable_unprepare(clk);
 gpiochip_error:
-	if (gpiochip_remove(pctl->chip))
-		dev_err(&pdev->dev, "failed to remove gpio chip\n");
+	gpiochip_remove(pctl->chip);
 pinctrl_error:
 	pinctrl_unregister(pctl->pctl_dev);
 	return ret;
diff --git a/drivers/pinctrl/vt8500/pinctrl-wmt.c b/drivers/pinctrl/vt8500/pinctrl-wmt.c
index 8c976c2..8cea355 100644
--- a/drivers/pinctrl/vt8500/pinctrl-wmt.c
+++ b/drivers/pinctrl/vt8500/pinctrl-wmt.c
@@ -615,8 +615,7 @@ int wmt_pinctrl_probe(struct platform_device *pdev,
 	return 0;
 
 fail_range:
-	if (gpiochip_remove(&data->gpio_chip))
-		dev_err(&pdev->dev, "failed to remove gpio chip\n");
+	gpiochip_remove(&data->gpio_chip);
 fail_gpio:
 	pinctrl_unregister(data->pctl_dev);
 	return err;
@@ -625,12 +624,8 @@ fail_gpio:
 int wmt_pinctrl_remove(struct platform_device *pdev)
 {
 	struct wmt_pinctrl_data *data = platform_get_drvdata(pdev);
-	int err;
-
-	err = gpiochip_remove(&data->gpio_chip);
-	if (err)
-		dev_err(&pdev->dev, "failed to remove gpio chip\n");
 
+	gpiochip_remove(&data->gpio_chip);
 	pinctrl_unregister(data->pctl_dev);
 
 	return 0;
-- 
1.9.1

