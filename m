Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535Ab3GDNkA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 09:40:00 -0400
Received: from softlayer.compulab.co.il ([50.23.254.55]:39817 "EHLO
	compulab.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751781Ab3GDNj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 09:39:58 -0400
X-Greylist: delayed 3511 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Jul 2013 09:39:58 EDT
Message-ID: <51D56D70.3000700@compulab.co.il>
Date: Thu, 04 Jul 2013 15:41:20 +0300
From: Denis Turischev <denis.turischev@compulab.co.il>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: gpio: introduce gpio-fch driver for AMD A45/A50M/A55E Fusion Controller
 Hub
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - softlayer.compulab.co.il
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Get-Message-Sender-Via: softlayer.compulab.co.il: acl_c_relayhosts_text_entry: -unknown-@compulab.co.il|compulab.co.il
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Denis Turischev <denis.turischev@compulab.co.il>

diff -uprN linux-3.10.orig/drivers/gpio/gpio-fch.c linux-3.10/drivers/gpio/gpio-fch.c
--- linux-3.10.orig/drivers/gpio/gpio-fch.c	1970-01-01 02:00:00.000000000 +0200
+++ linux-3.10/drivers/gpio/gpio-fch.c	2013-07-04 15:35:50.020672040 +0300
@@ -0,0 +1,247 @@
+/*
+ *  gpio-fch.c - GPIO interface for AMD Fusion Controller Hub
+ *
+ *  Copyright (c) 2013 CompuLab Ltd
+ *  Author: Denis Turischev <denis.turischev@compulab.co.il>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License 2 as published
+ *  by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; see the file COPYING.  If not, write to
+ *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/errno.h>
+#include <linux/pci.h>
+#include <linux/gpio.h>
+
+static void __iomem *gpio_ba;
+u32 acpimmioaddr;
+
+#define GPIO_SPACE_OFFSET		0x100
+#define GPIO_SPACE_SIZE			0x100
+
+static DEFINE_SPINLOCK(gpio_lock);
+
+static DEFINE_PCI_DEVICE_TABLE(gpio_fch_tbl) = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_SBX00_SMBUS) },
+	{ 0, }
+};
+MODULE_DEVICE_TABLE(pci, gpio_fch_tbl);
+
+static int gpio_fch_direction_in(struct gpio_chip *gc, unsigned  gpio_num)
+{
+	u8 curr_state;
+
+	spin_lock(&gpio_lock);
+
+	curr_state = ioread8(gpio_ba + gpio_num);
+	if (!(curr_state & (1 << 5)))
+		iowrite8(curr_state | (1 << 5), gpio_ba + gpio_num);
+
+	spin_unlock(&gpio_lock);
+	return 0;
+}
+
+static int gpio_fch_get(struct gpio_chip *gc, unsigned gpio_num)
+{
+	u8 curr_state, bit;
+	int res;
+
+	curr_state = ioread8(gpio_ba + gpio_num);
+
+	bit = 6;
+	if (curr_state & (1 << 5))
+		bit = 7;
+
+	res = !!((curr_state) & (1 << bit));
+	return res;
+}
+
+static void gpio_fch_set(struct gpio_chip *gc, unsigned gpio_num, int val)
+{
+	u8 curr_state;
+
+	spin_lock(&gpio_lock);
+
+	curr_state = ioread8(gpio_ba + gpio_num);
+	iowrite8((curr_state & ~(1 << 5)), gpio_ba + gpio_num);
+
+	if (val)
+		iowrite8(curr_state | (1 << 6), gpio_ba + gpio_num);
+	else
+		iowrite8(curr_state & ~(1 << 6), gpio_ba + gpio_num);
+
+	spin_unlock(&gpio_lock);
+}
+
+static int gpio_fch_direction_out(struct gpio_chip *gc,
+					unsigned gpio_num, int val)
+{
+	u8 curr_state;
+
+	spin_lock(&gpio_lock);
+
+	curr_state = ioread8(gpio_ba + gpio_num);
+
+	if (curr_state & (1 << 5))
+		iowrite8(curr_state & ~(1 << 5), gpio_ba + gpio_num);
+
+	spin_unlock(&gpio_lock);
+	return 0;
+}
+
+u32 read_pm_reg(u8 port)
+{
+	u32 res;
+
+	outb(port + 3, 0xCD6);
+	res = inb(0xCD7);
+	res = res << 8;
+
+	outb(port + 2, 0xCD6);
+	res = res + inb(0xCD7);
+	res = res << 8;
+
+	outb(port + 1, 0xCD6);
+	res = res + inb(0xCD7);
+	res = res << 8;
+
+	outb(port, 0xCD6);
+	res = res + inb(0xCD7);
+
+	return res;
+}
+
+static struct gpio_chip fch_gpio_chip0 = {
+	.label			= "gpio_fch",
+	.owner			= THIS_MODULE,
+	.get			= gpio_fch_get,
+	.direction_input	= gpio_fch_direction_in,
+	.set			= gpio_fch_set,
+	.direction_output	= gpio_fch_direction_out,
+};
+
+static struct gpio_chip fch_gpio_chip128 = {
+	.label			= "gpio_fch",
+	.owner			= THIS_MODULE,
+	.get			= gpio_fch_get,
+	.direction_input	= gpio_fch_direction_in,
+	.set			= gpio_fch_set,
+	.direction_output	= gpio_fch_direction_out,
+};
+
+static struct gpio_chip fch_gpio_chip160 = {
+	.label			= "gpio_fch",
+	.owner			= THIS_MODULE,
+	.get			= gpio_fch_get,
+	.direction_input	= gpio_fch_direction_in,
+	.set			= gpio_fch_set,
+	.direction_output	= gpio_fch_direction_out,
+};
+
+static int gpio_fch_probe(struct pci_dev *pdev,	const struct pci_device_id *id)
+{
+	int ret;
+
+	acpimmioaddr = read_pm_reg(0x24) & 0xFFFFF000;
+
+	if (!request_mem_region(acpimmioaddr + GPIO_SPACE_OFFSET,
+				GPIO_SPACE_SIZE, fch_gpio_chip0.label))
+		return -EBUSY;
+
+	gpio_ba = ioremap(acpimmioaddr + GPIO_SPACE_OFFSET, GPIO_SPACE_SIZE);
+	if (!gpio_ba) {
+		ret = -ENOMEM;
+		goto err_no_ioremap;
+	}
+
+	fch_gpio_chip0.base = 0;
+	fch_gpio_chip0.ngpio = 68;
+
+	fch_gpio_chip128.base = 128;
+	fch_gpio_chip128.ngpio = 23;
+
+	fch_gpio_chip160.base = 160;
+	fch_gpio_chip160.ngpio = 69;
+
+	ret = gpiochip_add(&fch_gpio_chip0);
+	if (ret < 0)
+		goto err_no_gpiochip0_add;
+
+	ret = gpiochip_add(&fch_gpio_chip128);
+	if (ret < 0)
+		goto err_no_gpiochip128_add;
+
+	ret = gpiochip_add(&fch_gpio_chip160);
+	if (ret < 0)
+		goto err_no_gpiochip160_add;
+
+	return 0;
+
+err_no_gpiochip160_add:
+	ret = gpiochip_remove(&fch_gpio_chip128);
+	if (ret)
+		dev_err(&pdev->dev, "%s failed, %d\n",
+				"gpiochip_remove()", ret);
+
+err_no_gpiochip128_add:
+	ret = gpiochip_remove(&fch_gpio_chip0);
+	if (ret)
+		dev_err(&pdev->dev, "%s failed, %d\n",
+				"gpiochip_remove()", ret);
+
+err_no_gpiochip0_add:
+	iounmap(gpio_ba);
+
+err_no_ioremap:
+	release_mem_region(acpimmioaddr + GPIO_SPACE_OFFSET, GPIO_SPACE_SIZE);
+	return ret;
+}
+
+static void gpio_fch_remove(struct pci_dev *pdev)
+{
+	int ret;
+
+	ret = gpiochip_remove(&fch_gpio_chip160);
+	if (ret < 0)
+		dev_err(&pdev->dev, "%s failed, %d\n",
+				"gpiochip_remove()", ret);
+
+	ret = gpiochip_remove(&fch_gpio_chip128);
+	if (ret < 0)
+		dev_err(&pdev->dev, "%s failed, %d\n",
+				"gpiochip_remove()", ret);
+
+	ret = gpiochip_remove(&fch_gpio_chip0);
+	if (ret < 0)
+		dev_err(&pdev->dev, "%s failed, %d\n",
+				"gpiochip_remove()", ret);
+
+	iounmap(gpio_ba);
+	release_mem_region(acpimmioaddr + GPIO_SPACE_OFFSET, GPIO_SPACE_SIZE);
+}
+
+static struct pci_driver gpio_fch_driver = {
+	.name		= "gpio_fch",
+	.id_table	= gpio_fch_tbl,
+	.probe		= gpio_fch_probe,
+	.remove		= gpio_fch_remove,
+};
+
+module_pci_driver(gpio_fch_driver);
+
+MODULE_AUTHOR("Denis Turischev <denis@compulab.co.il>");
+MODULE_DESCRIPTION("GPIO interface for AMD Fusion Controller Hub");
+MODULE_LICENSE("GPL");
+
diff -uprN linux-3.10.orig/drivers/gpio/Kconfig linux-3.10/drivers/gpio/Kconfig
--- linux-3.10.orig/drivers/gpio/Kconfig	2013-07-01 01:13:29.000000000 +0300
+++ linux-3.10/drivers/gpio/Kconfig	2013-07-04 14:12:15.412806610 +0300
@@ -135,6 +135,17 @@ config GPIO_EP93XX
 	depends on ARCH_EP93XX
 	select GPIO_GENERIC

+config GPIO_FCH
+	tristate "AMD A45/A50M/A55E Fusion Controller Hub GPIO"
+	depends on PCI && X86
+	default m
+	help
+	  GPIO interface for AMD A45/A50M/A55E Fusion Controller Hub.
+	  Available GPIOs are 0-67, 128-150, 160-228.
+
+	  Part of GPIOs is usually occupied by BIOS for it's internal needs, so
+	  use them with care.
+
 config GPIO_MM_LANTIQ
 	bool "Lantiq Memory mapped GPIOs"
 	depends on LANTIQ && SOC_XWAY
diff -uprN linux-3.10.orig/drivers/gpio/Makefile linux-3.10/drivers/gpio/Makefile
--- linux-3.10.orig/drivers/gpio/Makefile	2013-07-01 01:13:29.000000000 +0300
+++ linux-3.10/drivers/gpio/Makefile	2013-07-04 09:39:38.605245556 +0300
@@ -24,6 +24,7 @@ obj-$(CONFIG_GPIO_DA9055)	+= gpio-da9055
 obj-$(CONFIG_ARCH_DAVINCI)	+= gpio-davinci.o
 obj-$(CONFIG_GPIO_EM)		+= gpio-em.o
 obj-$(CONFIG_GPIO_EP93XX)	+= gpio-ep93xx.o
+obj-$(CONFIG_GPIO_FCH)		+= gpio-fch.o
 obj-$(CONFIG_GPIO_GE_FPGA)	+= gpio-ge.o
 obj-$(CONFIG_GPIO_GRGPIO)	+= gpio-grgpio.o
 obj-$(CONFIG_GPIO_ICH)		+= gpio-ich.o
