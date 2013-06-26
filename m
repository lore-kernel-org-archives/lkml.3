Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438Ab3FZMDy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 08:03:54 -0400
Received: from vm1.sequanux.org ([188.165.36.56]:60014 "EHLO vm1.sequanux.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752358Ab3FZMDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 08:03:53 -0400
X-Greylist: delayed 482 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Jun 2013 08:03:52 EDT
From: Simon Guinot <simon.guinot@sequanux.org>
To: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, Vincent Donnefort <vdonnefort@gmail.com>,
        Simon Guinot <simon.guinot@sequanux.org>
Subject: [PATCH] gpio: add GPIO support for F71882FG and F71889F
Date: Wed, 26 Jun 2013 13:56:56 +0200
Message-Id: <1372247816-5590-1-git-send-email-simon.guinot@sequanux.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the GPIOs found on the Fintek Super-I/O
chips F71882FG and F71889F.

Signed-off-by: Simon Guinot <simon.guinot@sequanux.org>
---
 drivers/gpio/Kconfig       |   10 +
 drivers/gpio/Makefile      |    1 +
 drivers/gpio/gpio-f7188x.c |  437 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 448 insertions(+)
 create mode 100644 drivers/gpio/gpio-f7188x.c

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 573c449..875cb45 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -143,6 +143,16 @@ config GPIO_MM_LANTIQ
 	  (EBU) found on Lantiq SoCs. The gpios are output only as they are
 	  created by attaching a 16bit latch to the bus.
 
+config GPIO_F7188X
+	tristate "F71882FG and F71889F GPIO support"
+	depends on X86
+	help
+	  This option enables support for GPIOs found on Fintek Super-I/O
+	  chips F71882FG and F71889F.
+
+	  To compile this driver as a module, choose M here: the module will
+	  be called f7188x-gpio.
+
 config GPIO_MPC5200
 	def_bool y
 	depends on PPC_MPC52xx
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 0cb2d65..bba1a55 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -24,6 +24,7 @@ obj-$(CONFIG_GPIO_DA9055)	+= gpio-da9055.o
 obj-$(CONFIG_ARCH_DAVINCI)	+= gpio-davinci.o
 obj-$(CONFIG_GPIO_EM)		+= gpio-em.o
 obj-$(CONFIG_GPIO_EP93XX)	+= gpio-ep93xx.o
+obj-$(CONFIG_GPIO_F7188X)	+= gpio-f7188x.o
 obj-$(CONFIG_GPIO_GE_FPGA)	+= gpio-ge.o
 obj-$(CONFIG_GPIO_GRGPIO)	+= gpio-grgpio.o
 obj-$(CONFIG_GPIO_ICH)		+= gpio-ich.o
diff --git a/drivers/gpio/gpio-f7188x.c b/drivers/gpio/gpio-f7188x.c
new file mode 100644
index 0000000..0dcc481
--- /dev/null
+++ b/drivers/gpio/gpio-f7188x.c
@@ -0,0 +1,437 @@
+/*
+ * GPIO driver for Fintek Super-I/O F71882 and F71889
+ *
+ * Copyright (C) 2010-2013 LaCie
+ *
+ * Author: Simon Guinot <simon.guinot@sequanux.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/io.h>
+#include <linux/gpio.h>
+#include <linux/acpi.h>
+
+#define DRVNAME "gpio-f7188x"
+
+/*
+ * Super-I/O registers
+ */
+#define SIO_LDSEL		0x07	/* Logical device select */
+#define SIO_DEVID		0x20	/* Device ID (2 bytes) */
+#define SIO_DEVREV		0x22	/* Device revision */
+#define SIO_MANID		0x23	/* Fintek ID (2 bytes) */
+
+#define SIO_LD_GPIO		0x06	/* GPIO logical device */
+#define SIO_UNLOCK_KEY		0x87	/* Key to enable Super-I/O */
+#define SIO_LOCK_KEY		0xAA	/* Key to disable Super-I/O */
+
+#define SIO_FINTEK_ID		0x1934	/* Manufacturer ID */
+#define SIO_F71882_ID		0x0541	/* F71882 chipset ID */
+#define SIO_F71889_ID		0x0909	/* F71889 chipset ID */
+
+enum chips { f71882fg, f71889f };
+
+static const char * const f7188x_names[] = {
+	"f71882fg",
+	"f71889f",
+};
+
+struct f7188x_sio {
+	int addr;
+	enum chips type;
+};
+
+struct f7188x_gpio_bank {
+	struct gpio_chip chip;
+	unsigned int regbase;
+	struct f7188x_gpio_data *data;
+};
+
+struct f7188x_gpio_data {
+	struct f7188x_sio *sio;
+	int nr_bank;
+	struct f7188x_gpio_bank *bank;
+};
+
+/*
+ * Super-I/O functions.
+ */
+
+static inline int superio_inb(int base, int reg)
+{
+	outb(reg, base);
+	return inb(base + 1);
+}
+
+static int superio_inw(int base, int reg)
+{
+	int val;
+
+	outb(reg++, base);
+	val = inb(base + 1) << 8;
+	outb(reg, base);
+	val |= inb(base + 1);
+
+	return val;
+}
+
+static inline void superio_outb(int base, int reg, int val)
+{
+	outb(reg, base);
+	outb(val, base + 1);
+}
+
+static inline void superio_enter(int base)
+{
+	/* According to the datasheet the key must be send twice. */
+	outb(SIO_UNLOCK_KEY, base);
+	outb(SIO_UNLOCK_KEY, base);
+}
+
+static inline void superio_select(int base, int ld)
+{
+	outb(SIO_LDSEL, base);
+	outb(ld, base + 1);
+}
+
+static inline void superio_exit(int base)
+{
+	outb(SIO_LOCK_KEY, base);
+}
+
+/*
+ * GPIO chip.
+ */
+
+static int f7188x_gpio_direction_in(struct gpio_chip *chip, unsigned offset);
+static int f7188x_gpio_get(struct gpio_chip *chip, unsigned offset);
+static int f7188x_gpio_direction_out(struct gpio_chip *chip,
+				     unsigned offset, int value);
+static void f7188x_gpio_set(struct gpio_chip *chip, unsigned offset, int value);
+
+#define F7188X_GPIO_BANK(_base, _ngpio, _regbase)			\
+	{								\
+		.chip = {						\
+			.label            = DRVNAME,			\
+			.owner            = THIS_MODULE,		\
+			.direction_input  = f7188x_gpio_direction_in,	\
+			.get              = f7188x_gpio_get,		\
+			.direction_output = f7188x_gpio_direction_out,	\
+			.set              = f7188x_gpio_set,		\
+			.base             = _base,			\
+			.ngpio            = _ngpio,			\
+		},							\
+		.regbase = _regbase,					\
+	}
+
+#define gpio_oe_reg(base) (base + 0)
+#define gpio_od_reg(base) (base + 1)
+#define gpio_st_reg(base) (base + 2)
+#define gpio_de_reg(base) (base + 3)
+
+static struct f7188x_gpio_bank f71882_gpio_bank[] = {
+	F7188X_GPIO_BANK(0 , 8, 0xF0),
+	F7188X_GPIO_BANK(10, 8, 0xE0),
+	F7188X_GPIO_BANK(20, 8, 0xD0),
+	F7188X_GPIO_BANK(30, 4, 0xC0),
+	F7188X_GPIO_BANK(40, 4, 0xB0),
+};
+
+static struct f7188x_gpio_bank f71889_gpio_bank[] = {
+	F7188X_GPIO_BANK(0 , 7, 0xF0),
+	F7188X_GPIO_BANK(10, 7, 0xE0),
+	F7188X_GPIO_BANK(20, 8, 0xD0),
+	F7188X_GPIO_BANK(30, 8, 0xC0),
+	F7188X_GPIO_BANK(40, 8, 0xB0),
+	F7188X_GPIO_BANK(50, 5, 0xA0),
+	F7188X_GPIO_BANK(60, 8, 0x90),
+	F7188X_GPIO_BANK(70, 8, 0x80),
+};
+
+static int f7188x_gpio_direction_in(struct gpio_chip *chip, unsigned offset)
+{
+	struct f7188x_gpio_bank *bank =
+		container_of(chip, struct f7188x_gpio_bank, chip);
+	struct f7188x_sio *sio = bank->data->sio;
+	u8 oe;
+
+	superio_enter(sio->addr);
+	superio_select(sio->addr, SIO_LD_GPIO);
+
+	oe = superio_inb(sio->addr, gpio_oe_reg(bank->regbase));
+	oe &= ~(1 << offset);
+	superio_outb(sio->addr, gpio_oe_reg(bank->regbase), oe);
+
+	superio_exit(sio->addr);
+
+	return 0;
+}
+
+static int f7188x_gpio_get(struct gpio_chip *chip, unsigned offset)
+{
+	struct f7188x_gpio_bank *bank =
+		container_of(chip, struct f7188x_gpio_bank, chip);
+	struct f7188x_sio *sio = bank->data->sio;
+	u8 od;
+
+	superio_enter(sio->addr);
+	superio_select(sio->addr, SIO_LD_GPIO);
+
+	od = superio_inb(sio->addr, gpio_od_reg(bank->regbase));
+
+	superio_exit(sio->addr);
+
+	return !!(od & 1 << offset);
+}
+
+static int f7188x_gpio_direction_out(struct gpio_chip *chip,
+				     unsigned offset, int value)
+{
+	struct f7188x_gpio_bank *bank =
+		container_of(chip, struct f7188x_gpio_bank, chip);
+	struct f7188x_sio *sio = bank->data->sio;
+	u8 oe;
+	u8 od;
+
+	superio_enter(sio->addr);
+	superio_select(sio->addr, SIO_LD_GPIO);
+
+	od = superio_inb(sio->addr, gpio_od_reg(bank->regbase));
+	if (value)
+		od |= (1 << offset);
+	else
+		od &= ~(1 << offset);
+	superio_outb(sio->addr, gpio_od_reg(bank->regbase), od);
+
+	oe = superio_inb(sio->addr, gpio_oe_reg(bank->regbase));
+	oe |= (1 << offset);
+	superio_outb(sio->addr, gpio_oe_reg(bank->regbase), oe);
+
+	superio_exit(sio->addr);
+
+	return 0;
+}
+
+static void f7188x_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
+{
+	struct f7188x_gpio_bank *bank =
+		container_of(chip, struct f7188x_gpio_bank, chip);
+	struct f7188x_sio *sio = bank->data->sio;
+	u8 od;
+
+	superio_enter(sio->addr);
+	superio_select(sio->addr, SIO_LD_GPIO);
+
+	od = superio_inb(sio->addr, gpio_od_reg(bank->regbase));
+	if (value)
+		od |= (1 << offset);
+	else
+		od &= ~(1 << offset);
+	superio_outb(sio->addr, gpio_od_reg(bank->regbase), od);
+
+	superio_exit(sio->addr);
+}
+
+/*
+ * Platform device and driver.
+ */
+
+static int f7188x_gpio_probe(struct platform_device *pdev)
+{
+	int err;
+	int i;
+	struct f7188x_sio *sio = pdev->dev.platform_data;
+	struct f7188x_gpio_data *data;
+
+	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	switch (sio->type) {
+	case f71882fg:
+		data->nr_bank = ARRAY_SIZE(f71882_gpio_bank);
+		data->bank = f71882_gpio_bank;
+		break;
+	case f71889f:
+		data->nr_bank = ARRAY_SIZE(f71889_gpio_bank);
+		data->bank = f71889_gpio_bank;
+		break;
+	default:
+		return -ENODEV;
+	}
+	data->sio = sio;
+
+	platform_set_drvdata(pdev, data);
+
+	/* For each GPIO bank, register a GPIO chip. */
+	for (i = 0; i < data->nr_bank; i++) {
+		struct f7188x_gpio_bank *bank = &data->bank[i];
+
+		bank->chip.dev = &pdev->dev;
+		bank->data = data;
+
+		err = gpiochip_add(&bank->chip);
+		if (err) {
+			dev_err(&pdev->dev,
+				"Failed to register gpiochip %d: %d\n",
+				i, err);
+			goto err_gpiochip;
+		}
+	}
+
+	return 0;
+
+err_gpiochip:
+	for (i = i - 1; i >= 0; i--) {
+		struct f7188x_gpio_bank *bank = &data->bank[i];
+		int tmp;
+
+		tmp = gpiochip_remove(&bank->chip);
+		if (tmp < 0)
+			dev_err(&pdev->dev,
+				"Failed to remove gpiochip %d: %d\n",
+				i, tmp);
+	}
+	platform_set_drvdata(pdev, NULL);
+
+	return err;
+}
+
+static int f7188x_gpio_remove(struct platform_device *pdev)
+{
+	int err;
+	int i;
+	struct f7188x_gpio_data *data = platform_get_drvdata(pdev);
+
+	for (i = 0; i < data->nr_bank; i++) {
+		struct f7188x_gpio_bank *bank = &data->bank[i];
+
+		err = gpiochip_remove(&bank->chip);
+		if (err) {
+			dev_err(&pdev->dev,
+				"Failed to remove GPIO gpiochip %d: %d\n",
+				i, err);
+			return err;
+		}
+	}
+	platform_set_drvdata(pdev, NULL);
+
+	return 0;
+}
+
+static int __init f7188x_find(int addr, struct f7188x_sio *sio)
+{
+	int err = -ENODEV;
+	u16 devid;
+
+	superio_enter(addr);
+
+	devid = superio_inw(addr, SIO_MANID);
+	if (devid != SIO_FINTEK_ID) {
+		pr_debug(DRVNAME ": Not a Fintek device at 0x%08x\n", addr);
+		goto err;
+	}
+
+	devid = superio_inw(addr, SIO_DEVID);
+	switch (devid) {
+	case SIO_F71882_ID:
+		sio->type = f71882fg;
+		break;
+	case SIO_F71889_ID:
+		sio->type = f71889f;
+		break;
+	default:
+		pr_info(DRVNAME ": Unsupported Fintek device 0x%04x\n", devid);
+		goto err;
+	}
+	sio->addr = addr;
+
+	pr_info(DRVNAME ": Found %s at %#x, revision %d\n",
+		f7188x_names[sio->type],
+		(unsigned int) addr,
+		(int) superio_inb(addr, SIO_DEVREV));
+
+	err = 0;
+err:
+	superio_exit(addr);
+	return err;
+}
+
+static struct platform_device *f7188x_gpio_pdev;
+
+static int __init
+f7188x_gpio_device_add(const struct f7188x_sio *sio)
+{
+	int err;
+
+	f7188x_gpio_pdev = platform_device_alloc(DRVNAME, -1);
+	if (!f7188x_gpio_pdev)
+		return -ENOMEM;
+
+	err = platform_device_add_data(f7188x_gpio_pdev,
+				       sio, sizeof(*sio));
+	if (err) {
+		pr_err(DRVNAME "Platform data allocation failed\n");
+		goto err;
+	}
+
+	err = platform_device_add(f7188x_gpio_pdev);
+	if (err) {
+		pr_err(DRVNAME "Device addition failed\n");
+		goto err;
+	}
+
+	return 0;
+
+err:
+	platform_device_put(f7188x_gpio_pdev);
+
+	return err;
+}
+
+static struct platform_driver f7188x_gpio_driver = {
+	.driver = {
+		.owner	= THIS_MODULE,
+		.name	= DRVNAME,
+	},
+	.probe		= f7188x_gpio_probe,
+	.remove		= f7188x_gpio_remove,
+};
+
+static int __init f7188x_gpio_init(void)
+{
+	int err;
+	struct f7188x_sio sio;
+
+	if (f7188x_find(0x2e, &sio) &&
+	    f7188x_find(0x4e, &sio))
+		return -ENODEV;
+
+	err = platform_driver_register(&f7188x_gpio_driver);
+	if (!err) {
+		err = f7188x_gpio_device_add(&sio);
+		if (err)
+			platform_driver_unregister(&f7188x_gpio_driver);
+	}
+
+	return err;
+}
+subsys_initcall(f7188x_gpio_init);
+
+static void __exit f7188x_gpio_exit(void)
+{
+	platform_device_unregister(f7188x_gpio_pdev);
+	platform_driver_unregister(&f7188x_gpio_driver);
+}
+module_exit(f7188x_gpio_exit);
+
+MODULE_DESCRIPTION("GPIO driver for Super-I/O chips F71882FG and F71889F");
+MODULE_AUTHOR("Simon Guinot <simon.guinot@sequanux.org>");
+MODULE_LICENSE("GPL");
-- 
1.7.10.4

