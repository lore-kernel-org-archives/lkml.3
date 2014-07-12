Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372AbaGLUar (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 16:30:47 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:36214 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300AbaGLUai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 16:30:38 -0400
From: abdoulaye berthe <berthe.ab@gmail.com>
To: linus.walleij@linaro.org, gnurou@gmail.com, m@bues.ch,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: abdoulaye berthe <berthe.ab@gmail.com>
Subject: [PATCH 3/3] driver:gpio remove all usage of gpio_remove retval in driver
Date: Sat, 12 Jul 2014 22:30:14 +0200
Message-Id: <1405197014-25225-4-git-send-email-berthe.ab@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405197014-25225-1-git-send-email-berthe.ab@gmail.com>
References: <CACRpkda6mzVdaN0cvOxpbsxWyCv2nGyDXOjZg_5aT8u7SSQeUw@mail.gmail.com>
 <1405197014-25225-1-git-send-email-berthe.ab@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this remove all reference to gpio_remove retval in all driver
except pinctrl and gpio. the same thing is done for gpio and
pinctrl in two different patches.

Signed-off-by: abdoulaye berthe <berthe.ab@gmail.com>
---
 arch/arm/common/scoop.c                        | 10 ++--------
 arch/mips/txx9/generic/setup.c                 |  4 ++--
 arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c |  3 ++-
 arch/sh/boards/mach-x3proto/gpio.c             |  6 ++----
 drivers/bcma/driver_gpio.c                     |  3 ++-
 drivers/hid/hid-cp2112.c                       |  6 ++----
 drivers/input/keyboard/adp5588-keys.c          |  4 +---
 drivers/input/keyboard/adp5589-keys.c          |  4 +---
 drivers/input/touchscreen/ad7879.c             | 10 +++-------
 drivers/leds/leds-pca9532.c                    | 10 ++--------
 drivers/leds/leds-tca6507.c                    |  7 ++-----
 drivers/media/dvb-frontends/cxd2820r_core.c    | 10 +++-------
 drivers/mfd/asic3.c                            |  3 ++-
 drivers/mfd/htc-i2cpld.c                       |  8 +-------
 drivers/mfd/sm501.c                            | 17 +++--------------
 drivers/mfd/tc6393xb.c                         | 13 ++++---------
 drivers/mfd/ucb1x00-core.c                     |  8 ++------
 drivers/pinctrl/pinctrl-abx500.c               | 15 +++------------
 drivers/pinctrl/pinctrl-exynos5440.c           |  6 +-----
 drivers/pinctrl/pinctrl-msm.c                  | 10 +++-------
 drivers/pinctrl/pinctrl-nomadik.c              |  2 +-
 drivers/pinctrl/pinctrl-samsung.c              | 14 ++++----------
 drivers/platform/x86/intel_pmic_gpio.c         |  3 +--
 drivers/ssb/driver_gpio.c                      |  3 ++-
 drivers/staging/vme/devices/vme_pio2_gpio.c    |  4 +---
 drivers/tty/serial/max310x.c                   | 10 ++++------
 drivers/video/fbdev/via/via-gpio.c             | 10 +++-------
 sound/soc/codecs/wm5100.c                      |  5 +----
 sound/soc/codecs/wm8903.c                      |  6 +-----
 sound/soc/codecs/wm8962.c                      |  5 +----
 sound/soc/codecs/wm8996.c                      |  6 +-----
 31 files changed, 63 insertions(+), 162 deletions(-)

diff --git a/arch/arm/common/scoop.c b/arch/arm/common/scoop.c
index 6ef146e..5881c9c 100644
--- a/arch/arm/common/scoop.c
+++ b/arch/arm/common/scoop.c
@@ -244,18 +244,12 @@ err_ioremap:
 static int scoop_remove(struct platform_device *pdev)
 {
 	struct scoop_dev *sdev = platform_get_drvdata(pdev);
-	int ret;
 
 	if (!sdev)
 		return -EINVAL;
 
-	if (sdev->gpio.base != -1) {
-		ret = gpiochip_remove(&sdev->gpio);
-		if (ret) {
-			dev_err(&pdev->dev, "Can't remove gpio chip: %d\n", ret);
-			return ret;
-		}
-	}
+	if (sdev->gpio.base != -1)
+		gpiochip_remove(&sdev->gpio);
 
 	platform_set_drvdata(pdev, NULL);
 	iounmap(sdev->base);
diff --git a/arch/mips/txx9/generic/setup.c b/arch/mips/txx9/generic/setup.c
index dd2cf25..49be896 100644
--- a/arch/mips/txx9/generic/setup.c
+++ b/arch/mips/txx9/generic/setup.c
@@ -789,11 +789,11 @@ void __init txx9_iocled_init(unsigned long baseaddr,
 	if (platform_device_add(pdev))
 		goto out_pdev;
 	return;
+
 out_pdev:
 	platform_device_put(pdev);
 out_gpio:
-	if (gpiochip_remove(&iocled->chip))
-		return;
+	gpiochip_remove(&iocled->chip);
 out_unmap:
 	iounmap(iocled->mmioaddr);
 out_free:
diff --git a/arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c b/arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c
index e238b6a..7399702 100644
--- a/arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c
+++ b/arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c
@@ -141,7 +141,8 @@ static int mcu_gpiochip_add(struct mcu *mcu)
 
 static int mcu_gpiochip_remove(struct mcu *mcu)
 {
-	return gpiochip_remove(&mcu->gc);
+	gpiochip_remove(&mcu->gc);
+	return 0;
 }
 
 static int mcu_probe(struct i2c_client *client, const struct i2c_device_id *id)
diff --git a/arch/sh/boards/mach-x3proto/gpio.c b/arch/sh/boards/mach-x3proto/gpio.c
index 3ea65e9..f035a7a 100644
--- a/arch/sh/boards/mach-x3proto/gpio.c
+++ b/arch/sh/boards/mach-x3proto/gpio.c
@@ -128,10 +128,8 @@ int __init x3proto_gpio_setup(void)
 	return 0;
 
 err_irq:
-	ret = gpiochip_remove(&x3proto_gpio_chip);
-	if (unlikely(ret))
-		pr_err("Failed deregistering GPIO\n");
-
+	gpiochip_remove(&x3proto_gpio_chip);
+	ret = 0;
 err_gpio:
 	synchronize_irq(ilsel);
 
diff --git a/drivers/bcma/driver_gpio.c b/drivers/bcma/driver_gpio.c
index d7f81ad..7dd70a7 100644
--- a/drivers/bcma/driver_gpio.c
+++ b/drivers/bcma/driver_gpio.c
@@ -250,5 +250,6 @@ int bcma_gpio_init(struct bcma_drv_cc *cc)
 int bcma_gpio_unregister(struct bcma_drv_cc *cc)
 {
 	bcma_gpio_irq_domain_exit(cc);
-	return gpiochip_remove(&cc->gpio);
+	gpiochip_remove(&cc->gpio);
+	return 0;
 }
diff --git a/drivers/hid/hid-cp2112.c b/drivers/hid/hid-cp2112.c
index 56be85a..a7f1b4b 100644
--- a/drivers/hid/hid-cp2112.c
+++ b/drivers/hid/hid-cp2112.c
@@ -964,8 +964,7 @@ static int cp2112_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	return ret;
 
 err_gpiochip_remove:
-	if (gpiochip_remove(&dev->gc) < 0)
-		hid_err(hdev, "error removing gpio chip\n");
+	gpiochip_remove(&dev->gc);
 err_free_i2c:
 	i2c_del_adapter(&dev->adap);
 err_free_dev:
@@ -984,8 +983,7 @@ static void cp2112_remove(struct hid_device *hdev)
 	struct cp2112_device *dev = hid_get_drvdata(hdev);
 
 	sysfs_remove_group(&hdev->dev.kobj, &cp2112_attr_group);
-	if (gpiochip_remove(&dev->gc))
-		hid_err(hdev, "unable to remove gpio chip\n");
+	gpiochip_remove(&dev->gc);
 	i2c_del_adapter(&dev->adap);
 	/* i2c_del_adapter has finished removing all i2c devices from our
 	 * adapter. Well behaved devices should no longer call our cp2112_xfer
diff --git a/drivers/input/keyboard/adp5588-keys.c b/drivers/input/keyboard/adp5588-keys.c
index 5ef7fcf..b97ed44 100644
--- a/drivers/input/keyboard/adp5588-keys.c
+++ b/drivers/input/keyboard/adp5588-keys.c
@@ -251,9 +251,7 @@ static void adp5588_gpio_remove(struct adp5588_kpad *kpad)
 			dev_warn(dev, "teardown failed %d\n", error);
 	}
 
-	error = gpiochip_remove(&kpad->gc);
-	if (error)
-		dev_warn(dev, "gpiochip_remove failed %d\n", error);
+	gpiochip_remove(&kpad->gc);
 }
 #else
 static inline int adp5588_gpio_add(struct adp5588_kpad *kpad)
diff --git a/drivers/input/keyboard/adp5589-keys.c b/drivers/input/keyboard/adp5589-keys.c
index 6329549..a452677 100644
--- a/drivers/input/keyboard/adp5589-keys.c
+++ b/drivers/input/keyboard/adp5589-keys.c
@@ -567,9 +567,7 @@ static void adp5589_gpio_remove(struct adp5589_kpad *kpad)
 			dev_warn(dev, "teardown failed %d\n", error);
 	}
 
-	error = gpiochip_remove(&kpad->gc);
-	if (error)
-		dev_warn(dev, "gpiochip_remove failed %d\n", error);
+	gpiochip_remove(&kpad->gc);
 }
 #else
 static inline int adp5589_gpio_add(struct adp5589_kpad *kpad)
diff --git a/drivers/input/touchscreen/ad7879.c b/drivers/input/touchscreen/ad7879.c
index fce5906..1eb9d3c 100644
--- a/drivers/input/touchscreen/ad7879.c
+++ b/drivers/input/touchscreen/ad7879.c
@@ -470,14 +470,10 @@ static int ad7879_gpio_add(struct ad7879 *ts,
 static void ad7879_gpio_remove(struct ad7879 *ts)
 {
 	const struct ad7879_platform_data *pdata = dev_get_platdata(ts->dev);
-	int ret;
 
-	if (pdata->gpio_export) {
-		ret = gpiochip_remove(&ts->gc);
-		if (ret)
-			dev_err(ts->dev, "failed to remove gpio %d\n",
-				ts->gc.base);
-	}
+	if (pdata->gpio_export)
+		gpiochip_remove(&ts->gc);
+
 }
 #else
 static inline int ad7879_gpio_add(struct ad7879 *ts,
diff --git a/drivers/leds/leds-pca9532.c b/drivers/leds/leds-pca9532.c
index 4a0e786..5a6363d 100644
--- a/drivers/leds/leds-pca9532.c
+++ b/drivers/leds/leds-pca9532.c
@@ -319,14 +319,8 @@ static int pca9532_destroy_devices(struct pca9532_data *data, int n_devs)
 	}
 
 #ifdef CONFIG_LEDS_PCA9532_GPIO
-	if (data->gpio.dev) {
-		int err = gpiochip_remove(&data->gpio);
-		if (err) {
-			dev_err(&data->client->dev, "%s failed, %d\n",
-						"gpiochip_remove()", err);
-			return err;
-		}
-	}
+	if (data->gpio.dev)
+		gpiochip_remove(&data->gpio);
 #endif
 
 	return 0;
diff --git a/drivers/leds/leds-tca6507.c b/drivers/leds/leds-tca6507.c
index 3d9e267..20fa8e7 100644
--- a/drivers/leds/leds-tca6507.c
+++ b/drivers/leds/leds-tca6507.c
@@ -667,11 +667,8 @@ static int tca6507_probe_gpios(struct i2c_client *client,
 
 static void tca6507_remove_gpio(struct tca6507_chip *tca)
 {
-	if (tca->gpio.ngpio) {
-		int err = gpiochip_remove(&tca->gpio);
-		dev_err(&tca->client->dev, "%s failed, %d\n",
-			"gpiochip_remove()", err);
-	}
+	if (tca->gpio.ngpio)
+		gpiochip_remove(&tca->gpio);
 }
 #else /* CONFIG_GPIOLIB */
 static int tca6507_probe_gpios(struct i2c_client *client,
diff --git a/drivers/media/dvb-frontends/cxd2820r_core.c b/drivers/media/dvb-frontends/cxd2820r_core.c
index 03930d5..51ef8931 100644
--- a/drivers/media/dvb-frontends/cxd2820r_core.c
+++ b/drivers/media/dvb-frontends/cxd2820r_core.c
@@ -584,18 +584,14 @@ static int cxd2820r_get_frontend_algo(struct dvb_frontend *fe)
 static void cxd2820r_release(struct dvb_frontend *fe)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
-	int uninitialized_var(ret); /* silence compiler warning */
 
 	dev_dbg(&priv->i2c->dev, "%s\n", __func__);
 
 #ifdef CONFIG_GPIOLIB
 	/* remove GPIOs */
-	if (priv->gpio_chip.label) {
-		ret = gpiochip_remove(&priv->gpio_chip);
-		if (ret)
-			dev_err(&priv->i2c->dev, "%s: gpiochip_remove() " \
-					"failed=%d\n", KBUILD_MODNAME, ret);
-	}
+	if (priv->gpio_chip.label)
+		gpiochip_remove(&priv->gpio_chip);
+
 #endif
 	kfree(priv);
 	return;
diff --git a/drivers/mfd/asic3.c b/drivers/mfd/asic3.c
index 9f6294f..8a968f9 100644
--- a/drivers/mfd/asic3.c
+++ b/drivers/mfd/asic3.c
@@ -605,7 +605,8 @@ static int asic3_gpio_remove(struct platform_device *pdev)
 {
 	struct asic3 *asic = platform_get_drvdata(pdev);
 
-	return gpiochip_remove(&asic->gpio);
+	gpiochip_remove(&asic->gpio);
+	return 0;
 }
 
 static void asic3_clk_enable(struct asic3 *asic, struct asic3_clk *clk)
diff --git a/drivers/mfd/htc-i2cpld.c b/drivers/mfd/htc-i2cpld.c
index d7b2a75..4306329 100644
--- a/drivers/mfd/htc-i2cpld.c
+++ b/drivers/mfd/htc-i2cpld.c
@@ -486,15 +486,9 @@ static int htcpld_register_chip_gpio(
 
 	ret = gpiochip_add(&(chip->chip_in));
 	if (ret) {
-		int error;
-
 		dev_warn(dev, "Unable to register input GPIOs for 0x%x: %d\n",
 			 plat_chip_data->addr, ret);
-
-		error = gpiochip_remove(&(chip->chip_out));
-		if (error)
-			dev_warn(dev, "Error while trying to unregister gpio chip: %d\n", error);
-
+		gpiochip_remove(&(chip->chip_out));
 		return ret;
 	}
 
diff --git a/drivers/mfd/sm501.c b/drivers/mfd/sm501.c
index 81e6d09..02027b7 100644
--- a/drivers/mfd/sm501.c
+++ b/drivers/mfd/sm501.c
@@ -1047,7 +1047,6 @@ static int sm501_register_gpio(struct sm501_devdata *sm)
 	struct sm501_gpio *gpio = &sm->gpio;
 	resource_size_t iobase = sm->io_res->start + SM501_GPIO;
 	int ret;
-	int tmp;
 
 	dev_dbg(sm->dev, "registering gpio block %08llx\n",
 		(unsigned long long)iobase);
@@ -1086,11 +1085,7 @@ static int sm501_register_gpio(struct sm501_devdata *sm)
 	return 0;
 
  err_low_chip:
-	tmp = gpiochip_remove(&gpio->low.gpio);
-	if (tmp) {
-		dev_err(sm->dev, "cannot remove low chip, cannot tidy up\n");
-		return ret;
-	}
+	gpiochip_remove(&gpio->low.gpio);
 
  err_mapped:
 	iounmap(gpio->regs);
@@ -1105,18 +1100,12 @@ static int sm501_register_gpio(struct sm501_devdata *sm)
 static void sm501_gpio_remove(struct sm501_devdata *sm)
 {
 	struct sm501_gpio *gpio = &sm->gpio;
-	int ret;
 
 	if (!sm->gpio.registered)
 		return;
 
-	ret = gpiochip_remove(&gpio->low.gpio);
-	if (ret)
-		dev_err(sm->dev, "cannot remove low chip, cannot tidy up\n");
-
-	ret = gpiochip_remove(&gpio->high.gpio);
-	if (ret)
-		dev_err(sm->dev, "cannot remove high chip, cannot tidy up\n");
+	gpiochip_remove(&gpio->low.gpio);
+	gpiochip_remove(&gpio->high.gpio);
 
 	iounmap(gpio->regs);
 	release_resource(gpio->regs_res);
diff --git a/drivers/mfd/tc6393xb.c b/drivers/mfd/tc6393xb.c
index 11c19e5..4fac16b 100644
--- a/drivers/mfd/tc6393xb.c
+++ b/drivers/mfd/tc6393xb.c
@@ -607,7 +607,7 @@ static int tc6393xb_probe(struct platform_device *dev)
 	struct tc6393xb_platform_data *tcpd = dev_get_platdata(&dev->dev);
 	struct tc6393xb *tc6393xb;
 	struct resource *iomem, *rscr;
-	int ret, temp;
+	int ret;
 
 	iomem = platform_get_resource(dev, IORESOURCE_MEM, 0);
 	if (!iomem)
@@ -714,7 +714,7 @@ err_setup:
 
 err_gpio_add:
 	if (tc6393xb->gpio.base != -1)
-		temp = gpiochip_remove(&tc6393xb->gpio);
+		gpiochip_remove(&tc6393xb->gpio);
 	tcpd->disable(dev);
 err_enable:
 	clk_disable(tc6393xb->clk);
@@ -744,13 +744,8 @@ static int tc6393xb_remove(struct platform_device *dev)
 
 	tc6393xb_detach_irq(dev);
 
-	if (tc6393xb->gpio.base != -1) {
-		ret = gpiochip_remove(&tc6393xb->gpio);
-		if (ret) {
-			dev_err(&dev->dev, "Can't remove gpio chip: %d\n", ret);
-			return ret;
-		}
-	}
+	if (tc6393xb->gpio.base != -1)
+		gpiochip_remove(&tc6393xb->gpio);
 
 	ret = tcpd->disable(dev);
 	clk_disable(tc6393xb->clk);
diff --git a/drivers/mfd/ucb1x00-core.c b/drivers/mfd/ucb1x00-core.c
index 153d595..58ea9fd 100644
--- a/drivers/mfd/ucb1x00-core.c
+++ b/drivers/mfd/ucb1x00-core.c
@@ -621,7 +621,6 @@ static void ucb1x00_remove(struct mcp *mcp)
 	struct ucb1x00_plat_data *pdata = mcp->attached_device.platform_data;
 	struct ucb1x00 *ucb = mcp_get_drvdata(mcp);
 	struct list_head *l, *n;
-	int ret;
 
 	mutex_lock(&ucb1x00_mutex);
 	list_del(&ucb->node);
@@ -631,11 +630,8 @@ static void ucb1x00_remove(struct mcp *mcp)
 	}
 	mutex_unlock(&ucb1x00_mutex);
 
-	if (ucb->gpio.base != -1) {
-		ret = gpiochip_remove(&ucb->gpio);
-		if (ret)
-			dev_err(&ucb->dev, "Can't remove gpio chip: %d\n", ret);
-	}
+	if (ucb->gpio.base != -1)
+		gpiochip_remove(&ucb->gpio);
 
 	irq_set_chained_handler(ucb->irq, NULL);
 	irq_free_descs(ucb->irq_base, 16);
diff --git a/drivers/pinctrl/pinctrl-abx500.c b/drivers/pinctrl/pinctrl-abx500.c
index 163da9c..7dc9804 100644
--- a/drivers/pinctrl/pinctrl-abx500.c
+++ b/drivers/pinctrl/pinctrl-abx500.c
@@ -1221,7 +1221,7 @@ static int abx500_gpio_probe(struct platform_device *pdev)
 	const struct of_device_id *match;
 	struct abx500_pinctrl *pct;
 	unsigned int id = -1;
-	int ret, err;
+	int ret;
 	int i;
 
 	if (!np) {
@@ -1313,10 +1313,7 @@ static int abx500_gpio_probe(struct platform_device *pdev)
 	return 0;
 
 out_rem_chip:
-	err = gpiochip_remove(&pct->chip);
-	if (err)
-		dev_info(&pdev->dev, "failed to remove gpiochip\n");
-
+	gpiochip_remove(&pct->chip);
 	return ret;
 }
 
@@ -1327,14 +1324,8 @@ out_rem_chip:
 static int abx500_gpio_remove(struct platform_device *pdev)
 {
 	struct abx500_pinctrl *pct = platform_get_drvdata(pdev);
-	int ret;
 
-	ret = gpiochip_remove(&pct->chip);
-	if (ret < 0) {
-		dev_err(pct->dev, "unable to remove gpiochip: %d\n",
-			ret);
-		return ret;
-	}
+	gpiochip_remove(&pct->chip);
 
 	return 0;
 }
diff --git a/drivers/pinctrl/pinctrl-exynos5440.c b/drivers/pinctrl/pinctrl-exynos5440.c
index 8fe2ab0..648c600 100644
--- a/drivers/pinctrl/pinctrl-exynos5440.c
+++ b/drivers/pinctrl/pinctrl-exynos5440.c
@@ -881,11 +881,7 @@ static int exynos5440_gpiolib_register(struct platform_device *pdev,
 static int exynos5440_gpiolib_unregister(struct platform_device *pdev,
 				struct exynos5440_pinctrl_priv_data *priv)
 {
-	int ret = gpiochip_remove(priv->gc);
-	if (ret) {
-		dev_err(&pdev->dev, "gpio chip remove failed\n");
-		return ret;
-	}
+	gpiochip_remove(priv->gc);
 	return 0;
 }
 
diff --git a/drivers/pinctrl/pinctrl-msm.c b/drivers/pinctrl/pinctrl-msm.c
index df6dda4c..b4b941f 100644
--- a/drivers/pinctrl/pinctrl-msm.c
+++ b/drivers/pinctrl/pinctrl-msm.c
@@ -923,14 +923,10 @@ EXPORT_SYMBOL(msm_pinctrl_probe);
 int msm_pinctrl_remove(struct platform_device *pdev)
 {
 	struct msm_pinctrl *pctrl = platform_get_drvdata(pdev);
-	int ret;
-
-	ret = gpiochip_remove(&pctrl->chip);
-	if (ret) {
-		dev_err(&pdev->dev, "Failed to remove gpiochip\n");
-		return ret;
-	}
 
+	gpiochip_remove(&pctrl->chip);
+	irq_set_chained_handler(pctrl->irq, NULL);
+	irq_domain_remove(pctrl->domain);
 	pinctrl_unregister(pctrl->pctrl);
 
 	return 0;
diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c
index 8f6f16e..98c5ce2 100644
--- a/drivers/pinctrl/pinctrl-nomadik.c
+++ b/drivers/pinctrl/pinctrl-nomadik.c
@@ -1261,7 +1261,7 @@ static int nmk_gpio_probe(struct platform_device *dev)
 				   IRQ_TYPE_EDGE_FALLING);
 	if (ret) {
 		dev_err(&dev->dev, "could not add irqchip\n");
-		ret = gpiochip_remove(&nmk_chip->chip);
+		gpiochip_remove(&nmk_chip->chip);
 		return -ENODEV;
 	}
 	/* Then register the chain on the parent IRQ */
diff --git a/drivers/pinctrl/pinctrl-samsung.c b/drivers/pinctrl/pinctrl-samsung.c
index 3e61d0f..99ec2fe 100644
--- a/drivers/pinctrl/pinctrl-samsung.c
+++ b/drivers/pinctrl/pinctrl-samsung.c
@@ -841,9 +841,7 @@ static int samsung_gpiolib_register(struct platform_device *pdev,
 
 fail:
 	for (--i, --bank; i >= 0; --i, --bank)
-		if (gpiochip_remove(&bank->gpio_chip))
-			dev_err(&pdev->dev, "gpio chip %s remove failed\n",
-							bank->gpio_chip.label);
+		gpiochip_remove(&bank->gpio_chip);
 	return ret;
 }
 
@@ -853,16 +851,12 @@ static int samsung_gpiolib_unregister(struct platform_device *pdev,
 {
 	struct samsung_pin_ctrl *ctrl = drvdata->ctrl;
 	struct samsung_pin_bank *bank = ctrl->pin_banks;
-	int ret = 0;
 	int i;
 
-	for (i = 0; !ret && i < ctrl->nr_banks; ++i, ++bank)
-		ret = gpiochip_remove(&bank->gpio_chip);
+	for (i = 0; i < ctrl->nr_banks; ++i, ++bank)
+		gpiochip_remove(&bank->gpio_chip);
 
-	if (ret)
-		dev_err(&pdev->dev, "gpio chip remove failed\n");
-
-	return ret;
+	return 0;
 }
 
 static const struct of_device_id samsung_pinctrl_dt_match[];
diff --git a/drivers/platform/x86/intel_pmic_gpio.c b/drivers/platform/x86/intel_pmic_gpio.c
index 40929e4..04fed00 100644
--- a/drivers/platform/x86/intel_pmic_gpio.c
+++ b/drivers/platform/x86/intel_pmic_gpio.c
@@ -301,8 +301,7 @@ static int platform_pmic_gpio_probe(struct platform_device *pdev)
 	return 0;
 
 fail_request_irq:
-	if (gpiochip_remove(&pg->chip))
-		pr_err("gpiochip_remove failed\n");
+	gpiochip_remove(&pg->chip);
 err:
 	iounmap(pg->gpiointr);
 err2:
diff --git a/drivers/ssb/driver_gpio.c b/drivers/ssb/driver_gpio.c
index ba350d2..f92e266 100644
--- a/drivers/ssb/driver_gpio.c
+++ b/drivers/ssb/driver_gpio.c
@@ -475,7 +475,8 @@ int ssb_gpio_unregister(struct ssb_bus *bus)
 {
 	if (ssb_chipco_available(&bus->chipco) ||
 	    ssb_extif_available(&bus->extif)) {
-		return gpiochip_remove(&bus->gpio);
+		gpiochip_remove(&bus->gpio);
+		return 0;
 	} else {
 		SSB_WARN_ON(1);
 	}
diff --git a/drivers/staging/vme/devices/vme_pio2_gpio.c b/drivers/staging/vme/devices/vme_pio2_gpio.c
index 2a2d920..3068288 100644
--- a/drivers/staging/vme/devices/vme_pio2_gpio.c
+++ b/drivers/staging/vme/devices/vme_pio2_gpio.c
@@ -221,9 +221,7 @@ void pio2_gpio_exit(struct pio2_card *card)
 {
 	const char *label = card->gc.label;
 
-	if (gpiochip_remove(&(card->gc)))
-		dev_err(&card->vdev->dev, "Failed to remove GPIO");
-
+	gpiochip_remove(&(card->gc));
 	kfree(label);
 }
 
diff --git a/drivers/tty/serial/max310x.c b/drivers/tty/serial/max310x.c
index 2a99d0c..740171b 100644
--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -1249,7 +1249,7 @@ static int max310x_probe(struct device *dev, struct max310x_devtype *devtype,
 	mutex_destroy(&s->mutex);
 
 #ifdef CONFIG_GPIOLIB
-	WARN_ON(gpiochip_remove(&s->gpio));
+	gpiochip_remove(&s->gpio);
 
 out_uart:
 #endif
@@ -1264,12 +1264,10 @@ out_clk:
 static int max310x_remove(struct device *dev)
 {
 	struct max310x_port *s = dev_get_drvdata(dev);
-	int i, ret = 0;
+	int i;
 
 #ifdef CONFIG_GPIOLIB
-	ret = gpiochip_remove(&s->gpio);
-	if (ret)
-		return ret;
+	gpiochip_remove(&s->gpio);
 #endif
 
 	for (i = 0; i < s->uart.nr; i++) {
@@ -1283,7 +1281,7 @@ static int max310x_remove(struct device *dev)
 	uart_unregister_driver(&s->uart);
 	clk_disable_unprepare(s->clk);
 
-	return ret;
+	return 0;
 }
 
 static const struct of_device_id __maybe_unused max310x_dt_ids[] = {
diff --git a/drivers/video/fbdev/via/via-gpio.c b/drivers/video/fbdev/via/via-gpio.c
index e408679..6f433b8 100644
--- a/drivers/video/fbdev/via/via-gpio.c
+++ b/drivers/video/fbdev/via/via-gpio.c
@@ -270,7 +270,7 @@ static int viafb_gpio_probe(struct platform_device *platdev)
 static int viafb_gpio_remove(struct platform_device *platdev)
 {
 	unsigned long flags;
-	int ret = 0, i;
+	int i;
 
 #ifdef CONFIG_PM
 	viafb_pm_unregister(&viafb_gpio_pm_hooks);
@@ -280,11 +280,7 @@ static int viafb_gpio_remove(struct platform_device *platdev)
 	 * Get unregistered.
 	 */
 	if (viafb_gpio_config.gpio_chip.ngpio > 0) {
-		ret = gpiochip_remove(&viafb_gpio_config.gpio_chip);
-		if (ret) { /* Somebody still using it? */
-			printk(KERN_ERR "Viafb: GPIO remove failed\n");
-			return ret;
-		}
+		gpiochip_remove(&viafb_gpio_config.gpio_chip);
 	}
 	/*
 	 * Disable the ports.
@@ -294,7 +290,7 @@ static int viafb_gpio_remove(struct platform_device *platdev)
 		viafb_gpio_disable(viafb_gpio_config.active_gpios[i]);
 	viafb_gpio_config.gpio_chip.ngpio = 0;
 	spin_unlock_irqrestore(&viafb_gpio_config.vdev->reg_lock, flags);
-	return ret;
+	return 0;
 }
 
 static struct platform_driver via_gpio_driver = {
diff --git a/sound/soc/codecs/wm5100.c b/sound/soc/codecs/wm5100.c
index 91a9ea2..a75b7c1 100644
--- a/sound/soc/codecs/wm5100.c
+++ b/sound/soc/codecs/wm5100.c
@@ -2320,11 +2320,8 @@ static void wm5100_init_gpio(struct i2c_client *i2c)
 static void wm5100_free_gpio(struct i2c_client *i2c)
 {
 	struct wm5100_priv *wm5100 = i2c_get_clientdata(i2c);
-	int ret;
 
-	ret = gpiochip_remove(&wm5100->gpio_chip);
-	if (ret != 0)
-		dev_err(&i2c->dev, "Failed to remove GPIOs: %d\n", ret);
+	gpiochip_remove(&wm5100->gpio_chip);
 }
 #else
 static void wm5100_init_gpio(struct i2c_client *i2c)
diff --git a/sound/soc/codecs/wm8903.c b/sound/soc/codecs/wm8903.c
index b84940c..c87bc04 100644
--- a/sound/soc/codecs/wm8903.c
+++ b/sound/soc/codecs/wm8903.c
@@ -1878,11 +1878,7 @@ static void wm8903_init_gpio(struct wm8903_priv *wm8903)
 
 static void wm8903_free_gpio(struct wm8903_priv *wm8903)
 {
-	int ret;
-
-	ret = gpiochip_remove(&wm8903->gpio_chip);
-	if (ret != 0)
-		dev_err(wm8903->dev, "Failed to remove GPIOs: %d\n", ret);
+	gpiochip_remove(&wm8903->gpio_chip);
 }
 #else
 static void wm8903_init_gpio(struct wm8903_priv *wm8903)
diff --git a/sound/soc/codecs/wm8962.c b/sound/soc/codecs/wm8962.c
index ca2fda9..896650f 100644
--- a/sound/soc/codecs/wm8962.c
+++ b/sound/soc/codecs/wm8962.c
@@ -3397,11 +3397,8 @@ static void wm8962_init_gpio(struct snd_soc_codec *codec)
 static void wm8962_free_gpio(struct snd_soc_codec *codec)
 {
 	struct wm8962_priv *wm8962 = snd_soc_codec_get_drvdata(codec);
-	int ret;
 
-	ret = gpiochip_remove(&wm8962->gpio_chip);
-	if (ret != 0)
-		dev_err(codec->dev, "Failed to remove GPIOs: %d\n", ret);
+	gpiochip_remove(&wm8962->gpio_chip);
 }
 #else
 static void wm8962_init_gpio(struct snd_soc_codec *codec)
diff --git a/sound/soc/codecs/wm8996.c b/sound/soc/codecs/wm8996.c
index 6926633..35a2bb8 100644
--- a/sound/soc/codecs/wm8996.c
+++ b/sound/soc/codecs/wm8996.c
@@ -2220,11 +2220,7 @@ static void wm8996_init_gpio(struct wm8996_priv *wm8996)
 
 static void wm8996_free_gpio(struct wm8996_priv *wm8996)
 {
-	int ret;
-
-	ret = gpiochip_remove(&wm8996->gpio_chip);
-	if (ret != 0)
-		dev_err(wm8996->dev, "Failed to remove GPIOs: %d\n", ret);
+	gpiochip_remove(&wm8996->gpio_chip);
 }
 #else
 static void wm8996_init_gpio(struct wm8996_priv *wm8996)
-- 
1.9.1

