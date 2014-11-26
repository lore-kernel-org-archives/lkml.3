Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892AbaKZOYw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 09:24:52 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:10264 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbaKZOYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 09:24:44 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-0a-5475e2a8aa3f
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Mike Turquette <mturquette@linaro.org>, Kukjin Kim <kgene@kernel.org>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, linux-gpio@vger.kernel.org,
        devicetree@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Kevin Hilman <khilman@kernel.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v2 3/5] pinctrl: exynos: Fix GPIO setup failure because domain
 clock being gated
Date: Wed, 26 Nov 2014 15:24:15 +0100
Message-id: <1417011857-10419-4-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1417011857-10419-1-git-send-email-k.kozlowski@samsung.com>
References: <1417011857-10419-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPLMWRmVeSWpSXmKPExsVy+t/xK7orHpWGGLzdKmKxccZ6Vov5R86x
	WrRdOchucfR3gcXrF4YW/Y9fM1s83fyYyeJs0xt2iyl/ljNZbHp8jdVi8/w/jBaXd81hs5hx
	fh+Txe3LvBZrj9xlt3g64SKbxeE37awWx2YsYbRYtesPo4OwR0tzD5vH3+fXWTx2zrrL7rFp
	VSebx51re9g8Ni+p9+jbsorR4/MmuQCOKC6blNSczLLUIn27BK6M33PmsRX8c6lYseoAUwPj
	DosuRk4OCQETiZc7VzFC2GISF+6tZ+ti5OIQEljKKNH99wU7hNPHJLGp6S8rSBWbgLHE5uVL
	wKpEBFawSOxa9IsZxGEWeMcosf7MehaQKmGBJIm7D3rZQWwWAVWJ6ZffMYHYvALuEg+PzoDa
	Jydx8thksKmcAh4Sbe/PM4PYQkA13/cdZpzAyLuAkWEVo2hqaXJBcVJ6rpFecWJucWleul5y
	fu4mRkigf93BuPSY1SFGAQ5GJR7eG3ElIUKsiWXFlbmHGCU4mJVEeFPvlIYI8aYkVlalFuXH
	F5XmpBYfYmTi4JRqYMwUz1bozet8klzovGkP03p1/nof4dsxwWfSTgQcen0k2sHPUTijZ8aE
	CBvmvnNJL3iOnLybuV/h5py1TJ7R5/KaXkeylOilLFkv9IOz5VDOmfzv/bfne3LOzbvAtbY5
	5W7bjzsRxwSvRzJwq89wdb9dskzCZKV4kUPRnwc+GlnKE+adlNRNUWIpzkg01GIuKk4EAGQd
	Vg9SAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The audio subsystem on Exynos 5420 has separate clocks and GPIO. To
operate properly on GPIOs the main block clock 'mau_epll' must be
enabled.

This was observed on Peach Pi/Pit and Arndale Octa (after enabling i2s0)
after introducing runtime PM to pl330 DMA driver. After that commit the
'mau_epll' was gated, because the "amba" clock was disabled and there
were no more users of mau_epll.

The system hang just before probing i2s0 because
samsung_pinmux_setup() tried to access memory from audss block which was
gated.

Add a clock property to the pinctrl driver and enable the clock during
GPIO setup. During normal GPIO operations (set, get, set_direction) the
clock is not enabled.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 .../bindings/pinctrl/samsung-pinctrl.txt           |   6 ++
 drivers/pinctrl/samsung/pinctrl-samsung.c          | 110 +++++++++++++++++++--
 drivers/pinctrl/samsung/pinctrl-samsung.h          |   2 +
 3 files changed, 111 insertions(+), 7 deletions(-)

diff --git a/Documentation/devicetree/bindings/pinctrl/samsung-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/samsung-pinctrl.txt
index 8425838a6dff..eb121daabe9d 100644
--- a/Documentation/devicetree/bindings/pinctrl/samsung-pinctrl.txt
+++ b/Documentation/devicetree/bindings/pinctrl/samsung-pinctrl.txt
@@ -93,6 +93,12 @@ Required Properties:
   pin configuration should use the bindings listed in the "pinctrl-bindings.txt"
   file.
 
+Optional Properties:
+- clocks: Optional clock needed to access the block. Will be enabled/disabled
+  during GPIO configuration, suspend and resume but not during GPIO operations
+  (like set, get, set direction).
+- clock-names: Must be "block".
+
 External GPIO and Wakeup Interrupts:
 
 The controller supports two types of external interrupts over gpio. The first
diff --git a/drivers/pinctrl/samsung/pinctrl-samsung.c b/drivers/pinctrl/samsung/pinctrl-samsung.c
index ec580af35856..96419aba7650 100644
--- a/drivers/pinctrl/samsung/pinctrl-samsung.c
+++ b/drivers/pinctrl/samsung/pinctrl-samsung.c
@@ -24,6 +24,7 @@
 #include <linux/platform_device.h>
 #include <linux/io.h>
 #include <linux/slab.h>
+#include <linux/clk.h>
 #include <linux/err.h>
 #include <linux/gpio.h>
 #include <linux/irqdomain.h>
@@ -55,6 +56,32 @@ static LIST_HEAD(drvdata_list);
 
 static unsigned int pin_base;
 
+static int pctl_clk_enable(struct pinctrl_dev *pctldev)
+{
+	struct samsung_pinctrl_drv_data *drvdata;
+	int ret;
+
+	drvdata = pinctrl_dev_get_drvdata(pctldev);
+	if (!drvdata->clk)
+		return 0;
+
+	ret = clk_enable(drvdata->clk);
+	if (ret)
+		dev_err(pctldev->dev, "failed to enable clock: %d\n", ret);
+
+	return ret;
+}
+
+static void pctl_clk_disable(struct pinctrl_dev *pctldev)
+{
+	struct samsung_pinctrl_drv_data *drvdata;
+
+	drvdata = pinctrl_dev_get_drvdata(pctldev);
+
+	/* clk/core.c does the check if clk != NULL */
+	clk_disable(drvdata->clk);
+}
+
 static inline struct samsung_pin_bank *gc_to_pin_bank(struct gpio_chip *gc)
 {
 	return container_of(gc, struct samsung_pin_bank, gpio_chip);
@@ -374,7 +401,9 @@ static void samsung_pinmux_setup(struct pinctrl_dev *pctldev, unsigned selector,
 	const struct samsung_pmx_func *func;
 	const struct samsung_pin_group *grp;
 
+	pctl_clk_enable(pctldev);
 	drvdata = pinctrl_dev_get_drvdata(pctldev);
+
 	func = &drvdata->pmx_functions[selector];
 	grp = &drvdata->pin_groups[group];
 
@@ -398,6 +427,8 @@ static void samsung_pinmux_setup(struct pinctrl_dev *pctldev, unsigned selector,
 	writel(data, reg + type->reg_offset[PINCFG_TYPE_FUNC]);
 
 	spin_unlock_irqrestore(&bank->slock, flags);
+
+	pctl_clk_disable(pctldev);
 }
 
 /* enable a specified pinmux by writing to registers */
@@ -469,20 +500,37 @@ static int samsung_pinconf_set(struct pinctrl_dev *pctldev, unsigned int pin,
 {
 	int i, ret;
 
+	ret = pctl_clk_enable(pctldev);
+	if (ret)
+		goto out;
+
 	for (i = 0; i < num_configs; i++) {
 		ret = samsung_pinconf_rw(pctldev, pin, &configs[i], true);
 		if (ret < 0)
-			return ret;
+			goto out;
 	} /* for each config */
 
-	return 0;
+out:
+	pctl_clk_disable(pctldev);
+
+	return ret;
 }
 
 /* get the pin config settings for a specified pin */
 static int samsung_pinconf_get(struct pinctrl_dev *pctldev, unsigned int pin,
 					unsigned long *config)
 {
-	return samsung_pinconf_rw(pctldev, pin, config, false);
+	int ret;
+
+	ret = pctl_clk_enable(pctldev);
+	if (ret)
+		return ret;
+
+	ret = samsung_pinconf_rw(pctldev, pin, config, false);
+
+	pctl_clk_disable(pctldev);
+
+	return ret;
 }
 
 /* set the pin config settings for a specified pin group */
@@ -1057,10 +1105,23 @@ static int samsung_pinctrl_probe(struct platform_device *pdev)
 	}
 	drvdata->dev = dev;
 
+	drvdata->clk = clk_get(&pdev->dev, "block");
+	if (!IS_ERR(drvdata->clk)) {
+		ret = clk_prepare_enable(drvdata->clk);
+		if (ret) {
+			dev_err(dev, "failed to enable clk: %d\n", ret);
+			return ret;
+		}
+	} else {
+		drvdata->clk = NULL;
+	}
+
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	drvdata->virt_base = devm_ioremap_resource(&pdev->dev, res);
-	if (IS_ERR(drvdata->virt_base))
-		return PTR_ERR(drvdata->virt_base);
+	if (IS_ERR(drvdata->virt_base)) {
+		ret = PTR_ERR(drvdata->virt_base);
+		goto err;
+	}
 
 	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (res)
@@ -1068,12 +1129,12 @@ static int samsung_pinctrl_probe(struct platform_device *pdev)
 
 	ret = samsung_gpiolib_register(pdev, drvdata);
 	if (ret)
-		return ret;
+		goto err;
 
 	ret = samsung_pinctrl_register(pdev, drvdata);
 	if (ret) {
 		samsung_gpiolib_unregister(pdev, drvdata);
-		return ret;
+		goto err;
 	}
 
 	if (ctrl->eint_gpio_init)
@@ -1085,6 +1146,22 @@ static int samsung_pinctrl_probe(struct platform_device *pdev)
 
 	/* Add to the global list */
 	list_add_tail(&drvdata->node, &drvdata_list);
+	clk_disable(drvdata->clk); /* Leave prepared */
+
+	return 0;
+
+err:
+	if (drvdata->clk)
+		clk_disable_unprepare(drvdata->clk);
+
+	return ret;
+}
+
+static int samsung_pinctrl_remove(struct platform_device *pdev)
+{
+	struct samsung_pinctrl_drv_data *drvdata = platform_get_drvdata(pdev);
+
+	clk_disable_unprepare(drvdata->clk);
 
 	return 0;
 }
@@ -1102,6 +1179,13 @@ static void samsung_pinctrl_suspend_dev(
 	void __iomem *virt_base = drvdata->virt_base;
 	int i;
 
+	if (drvdata->clk) {
+		if (clk_enable(drvdata->clk)) {
+			dev_err(drvdata->dev, "failed to enable clock\n");
+			return;
+		}
+	}
+
 	for (i = 0; i < drvdata->nr_banks; i++) {
 		struct samsung_pin_bank *bank = &drvdata->pin_banks[i];
 		void __iomem *reg = virt_base + bank->pctl_offset;
@@ -1133,6 +1217,8 @@ static void samsung_pinctrl_suspend_dev(
 
 	if (drvdata->suspend)
 		drvdata->suspend(drvdata);
+
+	clk_disable(drvdata->clk);
 }
 
 /**
@@ -1148,6 +1234,13 @@ static void samsung_pinctrl_resume_dev(struct samsung_pinctrl_drv_data *drvdata)
 	void __iomem *virt_base = drvdata->virt_base;
 	int i;
 
+	if (drvdata->clk) {
+		if (clk_enable(drvdata->clk)) {
+			dev_err(drvdata->dev, "failed to enable clock\n");
+			return;
+		}
+	}
+
 	if (drvdata->resume)
 		drvdata->resume(drvdata);
 
@@ -1181,6 +1274,8 @@ static void samsung_pinctrl_resume_dev(struct samsung_pinctrl_drv_data *drvdata)
 			if (widths[type])
 				writel(bank->pm_save[type], reg + offs[type]);
 	}
+
+	clk_disable(drvdata->clk);
 }
 
 /**
@@ -1264,6 +1359,7 @@ MODULE_DEVICE_TABLE(of, samsung_pinctrl_dt_match);
 
 static struct platform_driver samsung_pinctrl_driver = {
 	.probe		= samsung_pinctrl_probe,
+	.remove		= samsung_pinctrl_remove,
 	.driver = {
 		.name	= "samsung-pinctrl",
 		.of_match_table = samsung_pinctrl_dt_match,
diff --git a/drivers/pinctrl/samsung/pinctrl-samsung.h b/drivers/pinctrl/samsung/pinctrl-samsung.h
index 1b8c0139d604..666cb23eb9f2 100644
--- a/drivers/pinctrl/samsung/pinctrl-samsung.h
+++ b/drivers/pinctrl/samsung/pinctrl-samsung.h
@@ -201,6 +201,7 @@ struct samsung_pin_ctrl {
  * struct samsung_pinctrl_drv_data: wrapper for holding driver data together.
  * @node: global list node
  * @virt_base: register base address of the controller.
+ * @clk: Optional clock to enable/disable during setup. May be NULL.
  * @dev: device instance representing the controller.
  * @irq: interrpt number used by the controller to notify gpio interrupts.
  * @ctrl: pin controller instance managed by the driver.
@@ -218,6 +219,7 @@ struct samsung_pinctrl_drv_data {
 	void __iomem			*virt_base;
 	struct device			*dev;
 	int				irq;
+	struct clk			*clk;
 
 	struct pinctrl_desc		pctl;
 	struct pinctrl_dev		*pctl_dev;
-- 
1.9.1

