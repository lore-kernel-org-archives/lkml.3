Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab3FNXSr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 19:18:47 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:43841 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095Ab3FNXSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 19:18:44 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        David Daney <david.daney@cavium.com>
Subject: [PATCH] gpio MIPS/OCTEON: Add a driver for OCTEON's on-chip GPIO pins.
Date: Fri, 14 Jun 2013 16:18:35 -0700
Message-Id: <1371251915-18271-1-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

The SOCs in the OCTEON family have 16 (or in some cases 20) on-chip
GPIO pins, this driver handles them all.  Configuring the pins as
interrupt sources is handled elsewhere (OCTEON's irq handling code).

Signed-off-by: David Daney <david.daney@cavium.com>
---

This patch depends somewhat on patches in Ralf's MIPS/Linux -next tree
where we have patches that enable the Kconfig CAVIUM_OCTEON_SOC and
ARCH_REQUIRE_GPIOLIB symbols.  Apart from that it is stand-alone and
is probably suitable for merging via the GPIO tree.

Device tree binding defintions already exist for this device in
Documentation/devicetree/bindings/gpio/cavium-octeon-gpio.txt

 drivers/gpio/Kconfig       |   8 +++
 drivers/gpio/Makefile      |   1 +
 drivers/gpio/gpio-octeon.c | 153 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 162 insertions(+)
 create mode 100644 drivers/gpio/gpio-octeon.c

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 573c449..7b5df9a 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -190,6 +190,14 @@ config GPIO_MXS
 	select GPIO_GENERIC
 	select GENERIC_IRQ_CHIP
 
+config GPIO_OCTEON
+	tristate "Cavium OCTEON GPIO"
+	depends on GPIOLIB && CAVIUM_OCTEON_SOC
+	default y
+	help
+	  Say yes here to support the on-chip GPIO lines on the OCTEON
+	  family of SOCs.
+
 config GPIO_PL061
 	bool "PrimeCell PL061 GPIO support"
 	depends on ARM && ARM_AMBA
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 0cb2d65..b8487b6 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -50,6 +50,7 @@ obj-$(CONFIG_GPIO_MSM_V2)	+= gpio-msm-v2.o
 obj-$(CONFIG_GPIO_MVEBU)        += gpio-mvebu.o
 obj-$(CONFIG_GPIO_MXC)		+= gpio-mxc.o
 obj-$(CONFIG_GPIO_MXS)		+= gpio-mxs.o
+obj-$(CONFIG_GPIO_OCTEON)	+= gpio-octeon.o
 obj-$(CONFIG_ARCH_OMAP)		+= gpio-omap.o
 obj-$(CONFIG_GPIO_PCA953X)	+= gpio-pca953x.o
 obj-$(CONFIG_GPIO_PCF857X)	+= gpio-pcf857x.o
diff --git a/drivers/gpio/gpio-octeon.c b/drivers/gpio/gpio-octeon.c
new file mode 100644
index 0000000..f5bd127
--- /dev/null
+++ b/drivers/gpio/gpio-octeon.c
@@ -0,0 +1,153 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2011, 2012 Cavium Inc.
+ */
+
+#include <linux/platform_device.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/gpio.h>
+#include <linux/io.h>
+
+#include <asm/octeon/octeon.h>
+#include <asm/octeon/cvmx-gpio-defs.h>
+
+#define RX_DAT 0x80
+#define TX_SET 0x88
+#define TX_CLEAR 0x90
+/*
+ * The address offset of the GPIO configuration register for a given
+ * line.
+ */
+static unsigned int bit_cfg_reg(unsigned int gpio)
+{
+	if (gpio < 16)
+		return 8 * gpio;
+	else
+		return 8 * (gpio - 16) + 0x100;
+}
+
+struct octeon_gpio {
+	struct gpio_chip chip;
+	u64 register_base;
+};
+
+static int octeon_gpio_dir_in(struct gpio_chip *chip, unsigned offset)
+{
+	struct octeon_gpio *gpio = container_of(chip, struct octeon_gpio, chip);
+
+	cvmx_write_csr(gpio->register_base + bit_cfg_reg(offset), 0);
+	return 0;
+}
+
+static void octeon_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
+{
+	struct octeon_gpio *gpio = container_of(chip, struct octeon_gpio, chip);
+	u64 mask = 1ull << offset;
+	u64 reg = gpio->register_base + (value ? TX_SET : TX_CLEAR);
+	cvmx_write_csr(reg, mask);
+}
+
+static int octeon_gpio_dir_out(struct gpio_chip *chip, unsigned offset,
+			       int value)
+{
+	struct octeon_gpio *gpio = container_of(chip, struct octeon_gpio, chip);
+	union cvmx_gpio_bit_cfgx cfgx;
+
+	octeon_gpio_set(chip, offset, value);
+
+	cfgx.u64 = 0;
+	cfgx.s.tx_oe = 1;
+
+	cvmx_write_csr(gpio->register_base + bit_cfg_reg(offset), cfgx.u64);
+	return 0;
+}
+
+static int octeon_gpio_get(struct gpio_chip *chip, unsigned offset)
+{
+	struct octeon_gpio *gpio = container_of(chip, struct octeon_gpio, chip);
+	u64 read_bits = cvmx_read_csr(gpio->register_base + RX_DAT);
+
+	return ((1ull << offset) & read_bits) != 0;
+}
+
+static int octeon_gpio_probe(struct platform_device *pdev)
+{
+	struct octeon_gpio *gpio;
+	struct gpio_chip *chip;
+	struct resource *res_mem;
+	int err = 0;
+
+	gpio = devm_kzalloc(&pdev->dev, sizeof(*gpio), GFP_KERNEL);
+	if (!gpio)
+		return -ENOMEM;
+	chip = &gpio->chip;
+
+	res_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (res_mem == NULL) {
+		dev_err(&pdev->dev, "found no memory resource\n");
+		err = -ENXIO;
+		goto out;
+	}
+	if (!devm_request_mem_region(&pdev->dev, res_mem->start,
+					resource_size(res_mem),
+				     res_mem->name)) {
+		dev_err(&pdev->dev, "request_mem_region failed\n");
+		err = -ENXIO;
+		goto out;
+	}
+	gpio->register_base = (u64)devm_ioremap(&pdev->dev, res_mem->start,
+						resource_size(res_mem));
+
+	pdev->dev.platform_data = chip;
+	chip->label = "octeon-gpio";
+	chip->dev = &pdev->dev;
+	chip->owner = THIS_MODULE;
+	chip->base = 0;
+	chip->can_sleep = 0;
+	chip->ngpio = 20;
+	chip->direction_input = octeon_gpio_dir_in;
+	chip->get = octeon_gpio_get;
+	chip->direction_output = octeon_gpio_dir_out;
+	chip->set = octeon_gpio_set;
+	err = gpiochip_add(chip);
+	if (err)
+		goto out;
+
+	dev_info(&pdev->dev, "OCTEON GPIO\n");
+out:
+	return err;
+}
+
+static int octeon_gpio_remove(struct platform_device *pdev)
+{
+	struct gpio_chip *chip = pdev->dev.platform_data;
+	return gpiochip_remove(chip);
+}
+
+static struct of_device_id octeon_gpio_match[] = {
+	{
+		.compatible = "cavium,octeon-3860-gpio",
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(of, octeon_gpio_match);
+
+static struct platform_driver octeon_gpio_driver = {
+	.driver = {
+		.name		= "octeon_gpio",
+		.owner		= THIS_MODULE,
+		.of_match_table = octeon_gpio_match,
+	},
+	.probe		= octeon_gpio_probe,
+	.remove		= octeon_gpio_remove,
+};
+
+module_platform_driver(octeon_gpio_driver);
+
+MODULE_DESCRIPTION("Cavium Inc. OCTEON GPIO Driver");
+MODULE_AUTHOR("David Daney");
+MODULE_LICENSE("GPL");
-- 
1.7.11.7

