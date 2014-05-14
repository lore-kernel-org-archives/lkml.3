Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173AbaENL1Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 07:27:24 -0400
Received: from andre.telenet-ops.be ([195.130.132.53]:33521 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754955AbaENL0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 07:26:34 -0400
From: Bart Tanghe <bart.tanghe@thomasmore.be>
To: thierry.reding@gmail.com, michal.simek@xilinx.com
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        grant.likely@linaro.org, linux-pwm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bart Tanghe <bart.tanghe@thomasmore.be>
Subject: [rfc]pwm: add xilinx pwm driver 
Date: Wed, 14 May 2014 13:26:13 +0200
Message-Id: <1400066773-14393-1-git-send-email-bart.tanghe@thomasmore.be>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	add Xilinx PWM support - axi timer hardware block 

Signed-off-by: Bart Tanghe <bart.tanghe@thomasmore.be>
diff --git a/Documentation/devicetree/bindings/pwm/pwm-xlnx.txt b/Documentation/devicetree/bindings/pwm/pwm-xlnx.txt
new file mode 100644
index 0000000..cb48926
--- /dev/null
+++ b/Documentation/devicetree/bindings/pwm/pwm-xlnx.txt
@@ -0,0 +1,20 @@
+Xilinx PWM controller
+
+Required properties:
+- compatible: should be "xlnx,pwm-xlnx"
+- add a clock source to the description
+
+Examples:
+
+		axi_timer_0: timer@42800000 {
+			clock-frequency = <100000000>;
+			clocks = <&clkc 15>;
+			compatible = "xlnx,xlnx-pwm";
+			reg = <0x42800000 0x10000>;
+			xlnx,count-width = <0x20>;
+			xlnx,gen0-assert = <0x1>;
+			xlnx,gen1-assert = <0x1>;
+			xlnx,one-timer-only = <0x0>;
+			xlnx,trig0-assert = <0x1>;
+			xlnx,trig1-assert = <0x1>;
+		} ;
diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
index eece329..1d59b02 100644
--- a/drivers/pwm/Kconfig
+++ b/drivers/pwm/Kconfig
@@ -233,4 +233,17 @@ config PWM_VT8500
 	  To compile this driver as a module, choose M here: the module
 	  will be called pwm-vt8500.
 
+config PWM_XLNX
+	tristate "Xilinx PWM support"
+	help
+	  Generic PWM framework driver for xilinx axi timer.
+
+	  This driver implements the pwm channel of a xilinx axi timer hardware
+	  block.
+	  The hardware block has to be configured with generate output signal
+	  of timer 1 and timer 2 active high.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called pwm-xlnx.
+
 endif
diff --git a/drivers/pwm/Makefile b/drivers/pwm/Makefile
index 8b754e4..e0c5f59 100644
--- a/drivers/pwm/Makefile
+++ b/drivers/pwm/Makefile
@@ -21,3 +21,4 @@ obj-$(CONFIG_PWM_TIPWMSS)	+= pwm-tipwmss.o
 obj-$(CONFIG_PWM_TWL)		+= pwm-twl.o
 obj-$(CONFIG_PWM_TWL_LED)	+= pwm-twl-led.o
 obj-$(CONFIG_PWM_VT8500)	+= pwm-vt8500.o
+obj-$(CONFIG_PWM_XLNX)		+= pwm-xlnx.o
diff --git a/drivers/pwm/pwm-xlnx.c b/drivers/pwm/pwm-xlnx.c
new file mode 100644
index 0000000..9c1be71
--- /dev/null
+++ b/drivers/pwm/pwm-xlnx.c
@@ -0,0 +1,197 @@
+/*
+ * pwm-xlnx driver
+ * Tested on zedboard - axi timer v2.00a
+ *
+ * Copyright (C) 2014 Thomas more
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2.
+ */
+
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/pwm.h>
+
+/*mmio regiser mapping*/
+
+#define OFFSET		0x10
+#define DUTY		0x14
+#define PERIOD		0x04
+
+/* configure the counters as 32 bit counters */
+
+#define PWM_CONF	0x00000206
+#define PWM_ENABLE	0x00000080
+
+#define DRIVER_AUTHOR "Bart Tanghe <bart.tanghe@thomasmore.be>"
+#define DRIVER_DESC "A Xilinx pwm driver"
+
+struct xlnx_pwm_chip {
+	struct pwm_chip chip;
+	struct device *dev;
+	int scaler;
+	void __iomem *mmio_base;
+};
+
+static inline struct xlnx_pwm_chip *to_xlnx_pwm_chip(
+					struct pwm_chip *chip){
+
+	return container_of(chip, struct xlnx_pwm_chip, chip);
+}
+
+static int xlnx_pwm_config(struct pwm_chip *chip,
+			      struct pwm_device *pwm,
+			      int duty_ns, int period_ns){
+
+	struct xlnx_pwm_chip *pc;
+
+	pc = container_of(chip, struct xlnx_pwm_chip, chip);
+
+	iowrite32(duty_ns/pc->scaler - 2, pc->mmio_base + DUTY);
+	iowrite32(period_ns/pc->scaler - 2, pc->mmio_base + PERIOD);
+
+	return 0;
+}
+
+static int xlnx_pwm_enable(struct pwm_chip *chip,
+			      struct pwm_device *pwm){
+
+	struct xlnx_pwm_chip *pc;
+
+	pc = container_of(chip, struct xlnx_pwm_chip, chip);
+
+	iowrite32(ioread32(pc->mmio_base) | PWM_ENABLE, pc->mmio_base);
+	iowrite32(ioread32(pc->mmio_base + OFFSET) | PWM_ENABLE,
+						pc->mmio_base + OFFSET);
+	return 0;
+}
+
+static void xlnx_pwm_disable(struct pwm_chip *chip,
+				struct pwm_device *pwm)
+{
+	struct xlnx_pwm_chip *pc;
+
+	pc = to_xlnx_pwm_chip(chip);
+
+	iowrite32(ioread32(pc->mmio_base) & ~PWM_ENABLE, pc->mmio_base);
+	iowrite32(ioread32(pc->mmio_base + OFFSET) & ~PWM_ENABLE,
+						pc->mmio_base + OFFSET);
+}
+
+static int xlnx_set_polarity(struct pwm_chip *chip, struct pwm_device *pwm,
+				enum pwm_polarity polarity)
+{
+	struct xlnx_pwm_chip *pc;
+
+	pc = to_xlnx_pwm_chip(chip);
+
+	/* no implementation of polarity function
+	   the axi timer hw block doesn't support this
+	*/
+
+	return 0;
+}
+
+static const struct pwm_ops xlnx_pwm_ops = {
+	.config = xlnx_pwm_config,
+	.enable = xlnx_pwm_enable,
+	.disable = xlnx_pwm_disable,
+	.set_polarity = xlnx_set_polarity,
+	.owner = THIS_MODULE,
+};
+
+static int xlnx_pwm_probe(struct platform_device *pdev)
+{
+	struct xlnx_pwm_chip *pwm;
+
+	int ret;
+	struct resource *r;
+	u32 start, end;
+	struct clk *clk;
+
+	pwm = devm_kzalloc(&pdev->dev, sizeof(*pwm), GFP_KERNEL);
+	if (!pwm) {
+		dev_err(&pdev->dev, "failed to allocate memory\n");
+		return -ENOMEM;
+	}
+
+	pwm->dev = &pdev->dev;
+
+	clk = devm_clk_get(&pdev->dev, NULL);
+	if (IS_ERR(clk)) {
+		dev_err(&pdev->dev, "could not find clk: %ld\n", PTR_ERR(clk));
+		devm_kfree(&pdev->dev, pwm);
+		return PTR_ERR(clk);
+	}
+
+	pwm->scaler = (int)1000000000/clk_get_rate(clk);
+
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	pwm->mmio_base = devm_ioremap_resource(&pdev->dev, r);
+	if (IS_ERR(pwm->mmio_base)) {
+		devm_kfree(&pdev->dev, pwm);
+		return PTR_ERR(pwm->mmio_base);
+	}
+
+	start = r->start;
+	end = r->end;
+
+	pwm->chip.dev = &pdev->dev;
+	pwm->chip.ops = &xlnx_pwm_ops;
+	pwm->chip.base = (int)&pdev->id;
+	pwm->chip.npwm = 1;
+
+	ret = pwmchip_add(&pwm->chip);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "pwmchip_add() failed: %d\n", ret);
+		devm_kfree(&pdev->dev, pwm);
+		return -1;
+	}
+
+	/*set the pwm0 configuration*/
+	iowrite32(PWM_CONF, pwm->mmio_base);
+	iowrite32(PWM_CONF, pwm->mmio_base + OFFSET);
+
+	platform_set_drvdata(pdev, pwm);
+
+	return 0;
+}
+
+static int xlnx_pwm_remove(struct platform_device *pdev)
+{
+
+	struct xlnx_pwm_chip *pc;
+	pc  = platform_get_drvdata(pdev);
+
+	if (WARN_ON(!pc))
+		return -ENODEV;
+
+	return pwmchip_remove(&pc->chip);
+}
+
+static const struct of_device_id xlnx_pwm_of_match[] = {
+	{ .compatible = "xlnx,pwm-xlnx", },
+	{ /* sentinel */ }
+};
+
+MODULE_DEVICE_TABLE(of, xlnx_pwm_of_match);
+
+static struct platform_driver xlnx_pwm_driver = {
+	.driver = {
+		.name = "pwm-xlnx",
+		.owner = THIS_MODULE,
+		.of_match_table = xlnx_pwm_of_match,
+	},
+	.probe = xlnx_pwm_probe,
+	.remove = xlnx_pwm_remove,
+};
+module_platform_driver(xlnx_pwm_driver);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
