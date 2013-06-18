Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756392Ab3FRVNi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 17:13:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:63230 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756105Ab3FRVNe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 17:13:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,891,1363158000"; 
   d="scan'208";a="331744354"
From: Kevin Strasser <kevin.strasser@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Kevin Strasser <kevin.strasser@linux.intel.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Michael Brunner <Michael.Brunner@kontron.com>,
        Michael Brunner <mibru@gmx.de>, Chris Healy <chealy@imsco-us.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dirk Hohndel <Dirk.Hohndel@intel.com>,
        Wolfram Sang <wsa@the-dreams.de>, Ben Dooks <ben-linux@fluff.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wim Van Sebroeck <wim@iguana.be>, linux-i2c@vger.kernel.org,
        Michael Brunner <michael.brunner@kontron.com>
Subject: [PATCH v2 2/4] i2c: Kontron PLD i2c bus driver
Date: Tue, 18 Jun 2013 14:04:27 -0700
Message-Id: <1371589469-32700-3-git-send-email-kevin.strasser@linux.intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1371589469-32700-1-git-send-email-kevin.strasser@linux.intel.com>
References: <1365441321-21952-1-git-send-email-kevin.strasser@linux.intel.com>
 <1371589469-32700-1-git-send-email-kevin.strasser@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add i2c support for the on-board PLD found on some Kontron embedded
modules.

Signed-off-by: Kevin Strasser <kevin.strasser@linux.intel.com>
Signed-off-by: Michael Brunner <michael.brunner@kontron.com>
Acked-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Darren Hart <dvhart@linux.intel.com>
---
 drivers/i2c/busses/Kconfig      |   10 +
 drivers/i2c/busses/Makefile     |    1 +
 drivers/i2c/busses/i2c-kempld.c |  410 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 421 insertions(+)
 create mode 100644 drivers/i2c/busses/i2c-kempld.c

diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index adfee98..3e1457d 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -494,6 +494,16 @@ config I2C_IOP3XX
 	  This driver can also be built as a module.  If so, the module
 	  will be called i2c-iop3xx.
 
+config I2C_KEMPLD
+	tristate "Kontron COM I2C Controller"
+	depends on MFD_KEMPLD
+	help
+	  This enables support for the I2C bus interface on some Kontron ETX
+	  and COMexpress (ETXexpress) modules.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called i2c-kempld.
+
 config I2C_MPC
 	tristate "MPC107/824x/85xx/512x/52xx/83xx/86xx"
 	depends on PPC
diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
index 8f4fc23..150fa15 100644
--- a/drivers/i2c/busses/Makefile
+++ b/drivers/i2c/busses/Makefile
@@ -48,6 +48,7 @@ obj-$(CONFIG_I2C_IBM_IIC)	+= i2c-ibm_iic.o
 obj-$(CONFIG_I2C_IMX)		+= i2c-imx.o
 obj-$(CONFIG_I2C_INTEL_MID)	+= i2c-intel-mid.o
 obj-$(CONFIG_I2C_IOP3XX)	+= i2c-iop3xx.o
+obj-$(CONFIG_I2C_KEMPLD)	+= i2c-kempld.o
 obj-$(CONFIG_I2C_MPC)		+= i2c-mpc.o
 obj-$(CONFIG_I2C_MV64XXX)	+= i2c-mv64xxx.o
 obj-$(CONFIG_I2C_MXS)		+= i2c-mxs.o
diff --git a/drivers/i2c/busses/i2c-kempld.c b/drivers/i2c/busses/i2c-kempld.c
new file mode 100644
index 0000000..ccec916
--- /dev/null
+++ b/drivers/i2c/busses/i2c-kempld.c
@@ -0,0 +1,410 @@
+/*
+ * I2C bus driver for Kontron COM modules
+ *
+ * Copyright (c) 2010-2013 Kontron Europe GmbH
+ * Author: Michael Brunner <michael.brunner@kontron.com>
+ *
+ * The driver is based on the i2c-ocores driver by Peter Korsgaard.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License 2 as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/i2c.h>
+#include <linux/delay.h>
+#include <linux/mfd/kempld.h>
+
+#define KEMPLD_I2C_PRELOW	0x0b
+#define KEMPLD_I2C_PREHIGH	0x0c
+#define KEMPLD_I2C_DATA		0x0e
+
+#define KEMPLD_I2C_CTRL		0x0d
+#define I2C_CTRL_IEN		0x40
+#define I2C_CTRL_EN		0x80
+
+#define KEMPLD_I2C_STAT		0x0f
+#define I2C_STAT_IF		0x01
+#define I2C_STAT_TIP		0x02
+#define I2C_STAT_ARBLOST	0x20
+#define I2C_STAT_BUSY		0x40
+#define I2C_STAT_NACK		0x80
+
+#define KEMPLD_I2C_CMD		0x0f
+#define I2C_CMD_START		0x91
+#define I2C_CMD_STOP		0x41
+#define I2C_CMD_READ		0x21
+#define I2C_CMD_WRITE		0x11
+#define I2C_CMD_READ_ACK	0x21
+#define I2C_CMD_READ_NACK	0x29
+#define I2C_CMD_IACK		0x01
+
+#define KEMPLD_I2C_FREQ_MAX	2700	/* 2.7 mHz */
+#define KEMPLD_I2C_FREQ_STD	100	/* 100 kHz */
+
+enum {
+	STATE_DONE = 0,
+	STATE_INIT,
+	STATE_ADDR,
+	STATE_ADDR10,
+	STATE_START,
+	STATE_WRITE,
+	STATE_READ,
+	STATE_ERROR,
+};
+
+struct kempld_i2c_data {
+	struct device			*dev;
+	struct kempld_device_data	*pld;
+	struct i2c_adapter		adap;
+	struct i2c_msg			*msg;
+	int				pos;
+	int				nmsgs;
+	int				state;
+	bool				was_active;
+};
+
+static unsigned int bus_frequency = KEMPLD_I2C_FREQ_STD;
+module_param(bus_frequency, uint, 0);
+MODULE_PARM_DESC(bus_frequency, "Set I2C bus frequency in kHz (default="
+				__MODULE_STRING(KEMPLD_I2C_FREQ_STD)")");
+
+static int i2c_bus = -1;
+module_param(i2c_bus, int, 0);
+MODULE_PARM_DESC(i2c_bus, "Set I2C bus number (default=-1 for dynamic assignment)");
+
+static bool i2c_gpio_mux;
+module_param(i2c_gpio_mux, bool, 0);
+MODULE_PARM_DESC(i2c_gpio_mux, "Enable I2C port on GPIO out (default=false)");
+
+/*
+ * kempld_get_mutex must be called prior to calling this function.
+ */
+static int kempld_i2c_process(struct kempld_i2c_data *i2c)
+{
+	struct kempld_device_data *pld = i2c->pld;
+	u8 stat = kempld_read8(pld, KEMPLD_I2C_STAT);
+	struct i2c_msg *msg = i2c->msg;
+	u8 addr;
+
+	/* Ready? */
+	if (stat & I2C_STAT_TIP)
+		return -EBUSY;
+
+	if (i2c->state == STATE_DONE || i2c->state == STATE_ERROR) {
+		/* Stop has been sent */
+		kempld_write8(pld, KEMPLD_I2C_CMD, I2C_CMD_IACK);
+		if (i2c->state == STATE_ERROR)
+			return -EIO;
+		return 0;
+	}
+
+	/* Error? */
+	if (stat & I2C_STAT_ARBLOST) {
+		i2c->state = STATE_ERROR;
+		kempld_write8(pld, KEMPLD_I2C_CMD, I2C_CMD_STOP);
+		return -EAGAIN;
+	}
+
+	if (i2c->state == STATE_INIT) {
+		if (stat & I2C_STAT_BUSY)
+			return -EBUSY;
+
+		i2c->state = STATE_ADDR;
+	}
+
+	if (i2c->state == STATE_ADDR) {
+		/* 10 bit address? */
+		if (i2c->msg->flags & I2C_M_TEN) {
+			addr = 0xf0 | ((i2c->msg->addr >> 7) & 0x6);
+			i2c->state = STATE_ADDR10;
+		} else {
+			addr = (i2c->msg->addr << 1);
+			i2c->state = STATE_START;
+		}
+
+		/* Set read bit if necessary */
+		addr |= (i2c->msg->flags & I2C_M_RD) ? 1 : 0;
+
+		kempld_write8(pld, KEMPLD_I2C_DATA, addr);
+		kempld_write8(pld, KEMPLD_I2C_CMD, I2C_CMD_START);
+
+		return 0;
+	}
+
+	/* Second part of 10 bit addressing */
+	if (i2c->state == STATE_ADDR10) {
+		kempld_write8(pld, KEMPLD_I2C_DATA, i2c->msg->addr & 0xff);
+		kempld_write8(pld, KEMPLD_I2C_CMD, I2C_CMD_WRITE);
+
+		i2c->state = STATE_START;
+		return 0;
+	}
+
+	if (i2c->state == STATE_START || i2c->state == STATE_WRITE) {
+		i2c->state = (msg->flags & I2C_M_RD) ? STATE_READ : STATE_WRITE;
+
+		if (stat & I2C_STAT_NACK) {
+			i2c->state = STATE_ERROR;
+			kempld_write8(pld, KEMPLD_I2C_CMD, I2C_CMD_STOP);
+			return -ENXIO;
+		}
+	} else {
+		msg->buf[i2c->pos++] = kempld_read8(pld, KEMPLD_I2C_DATA);
+	}
+
+	if (i2c->pos >= msg->len) {
+		i2c->nmsgs--;
+		i2c->msg++;
+		i2c->pos = 0;
+		msg = i2c->msg;
+
+		if (i2c->nmsgs) {
+			if (!(msg->flags & I2C_M_NOSTART)) {
+				i2c->state = STATE_ADDR;
+				return 0;
+			} else {
+				i2c->state = (msg->flags & I2C_M_RD)
+					? STATE_READ : STATE_WRITE;
+			}
+		} else {
+			i2c->state = STATE_DONE;
+			kempld_write8(pld, KEMPLD_I2C_CMD, I2C_CMD_STOP);
+			return 0;
+		}
+	}
+
+	if (i2c->state == STATE_READ) {
+		kempld_write8(pld, KEMPLD_I2C_CMD, i2c->pos == (msg->len - 1) ?
+			      I2C_CMD_READ_NACK : I2C_CMD_READ_ACK);
+	} else {
+		kempld_write8(pld, KEMPLD_I2C_DATA, msg->buf[i2c->pos++]);
+		kempld_write8(pld, KEMPLD_I2C_CMD, I2C_CMD_WRITE);
+	}
+
+	return 0;
+}
+
+static int kempld_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs,
+				int num)
+{
+	struct kempld_i2c_data *i2c = i2c_get_adapdata(adap);
+	struct kempld_device_data *pld = i2c->pld;
+	unsigned long timeout = jiffies + HZ;
+	int ret;
+
+	i2c->msg = msgs;
+	i2c->pos = 0;
+	i2c->nmsgs = num;
+	i2c->state = STATE_INIT;
+
+	/* Handle the transfer */
+	while (time_before(jiffies, timeout)) {
+		kempld_get_mutex(pld);
+		ret = kempld_i2c_process(i2c);
+		kempld_release_mutex(pld);
+
+		if (i2c->state == STATE_DONE || i2c->state == STATE_ERROR)
+			return (i2c->state == STATE_DONE) ? num : ret;
+
+		if (ret == 0)
+			timeout = jiffies + HZ;
+
+		usleep_range(5, 15);
+	}
+
+	i2c->state = STATE_ERROR;
+
+	return -ETIMEDOUT;
+}
+
+/*
+ * kempld_get_mutex must be called prior to calling this function.
+ */
+static void kempld_i2c_device_init(struct kempld_i2c_data *i2c)
+{
+	struct kempld_device_data *pld = i2c->pld;
+	u16 prescale_corr;
+	long prescale;
+	u8 ctrl;
+	u8 stat;
+	u8 cfg;
+
+	/* Make sure the device is disabled */
+	ctrl = kempld_read8(pld, KEMPLD_I2C_CTRL);
+	ctrl &= ~(I2C_CTRL_EN | I2C_CTRL_IEN);
+	kempld_write8(pld, KEMPLD_I2C_CTRL, ctrl);
+
+	if (bus_frequency > KEMPLD_I2C_FREQ_MAX)
+		bus_frequency = KEMPLD_I2C_FREQ_MAX;
+
+	if (pld->info.spec_major == 1)
+		prescale = pld->pld_clock / bus_frequency * 5 - 1000;
+	else
+		prescale = pld->pld_clock / bus_frequency * 4 - 3000;
+
+	if (prescale < 0)
+		prescale = 0;
+
+	/* Round to the best matching value */
+	prescale_corr = prescale / 1000;
+	if (prescale % 1000 >= 500)
+		prescale_corr++;
+
+	kempld_write8(pld, KEMPLD_I2C_PRELOW, prescale_corr & 0xff);
+	kempld_write8(pld, KEMPLD_I2C_PREHIGH, prescale_corr >> 8);
+
+	/* Activate I2C bus output on GPIO pins */
+	cfg = kempld_read8(pld, KEMPLD_CFG);
+	if (i2c_gpio_mux)
+		cfg |= KEMPLD_CFG_GPIO_I2C_MUX;
+	else
+		cfg &= ~KEMPLD_CFG_GPIO_I2C_MUX;
+	kempld_write8(pld, KEMPLD_CFG, cfg);
+
+	/* Enable the device */
+	kempld_write8(pld, KEMPLD_I2C_CMD, I2C_CMD_IACK);
+	ctrl |= I2C_CTRL_EN;
+	kempld_write8(pld, KEMPLD_I2C_CTRL, ctrl);
+
+	stat = kempld_read8(pld, KEMPLD_I2C_STAT);
+	if (stat & I2C_STAT_BUSY)
+		kempld_write8(pld, KEMPLD_I2C_CMD, I2C_CMD_STOP);
+}
+
+static u32 kempld_i2c_func(struct i2c_adapter *adap)
+{
+	return I2C_FUNC_I2C | I2C_FUNC_10BIT_ADDR | I2C_FUNC_SMBUS_EMUL;
+}
+
+static const struct i2c_algorithm kempld_i2c_algorithm = {
+	.master_xfer	= kempld_i2c_xfer,
+	.functionality	= kempld_i2c_func,
+};
+
+static struct i2c_adapter kempld_i2c_adapter = {
+	.owner		= THIS_MODULE,
+	.name		= "i2c-kempld",
+	.class		= I2C_CLASS_HWMON | I2C_CLASS_SPD,
+	.algo		= &kempld_i2c_algorithm,
+};
+
+static int kempld_i2c_probe(struct platform_device *pdev)
+{
+	struct kempld_device_data *pld = dev_get_drvdata(pdev->dev.parent);
+	struct kempld_i2c_data *i2c;
+	int ret;
+	u8 ctrl;
+
+	i2c = devm_kzalloc(&pdev->dev, sizeof(*i2c), GFP_KERNEL);
+	if (!i2c)
+		return -ENOMEM;
+
+	i2c->pld = pld;
+	i2c->dev = &pdev->dev;
+	i2c->adap = kempld_i2c_adapter;
+	i2c->adap.dev.parent = i2c->dev;
+	i2c_set_adapdata(&i2c->adap, i2c);
+	platform_set_drvdata(pdev, i2c);
+
+	kempld_get_mutex(pld);
+	ctrl = kempld_read8(pld, KEMPLD_I2C_CTRL);
+
+	if (ctrl & I2C_CTRL_EN)
+		i2c->was_active = true;
+
+	kempld_i2c_device_init(i2c);
+	kempld_release_mutex(pld);
+
+	/* Add I2C adapter to I2C tree */
+	if (i2c_bus >= -1)
+		i2c->adap.nr = i2c_bus;
+	ret = i2c_add_numbered_adapter(&i2c->adap);
+	if (ret)
+		return ret;
+
+	dev_info(i2c->dev, "I2C bus initialized at %dkHz\n",
+		 bus_frequency);
+
+	return 0;
+}
+
+static int kempld_i2c_remove(struct platform_device *pdev)
+{
+	struct kempld_i2c_data *i2c = platform_get_drvdata(pdev);
+	struct kempld_device_data *pld = i2c->pld;
+	u8 ctrl;
+
+	kempld_get_mutex(pld);
+	/*
+	 * Disable I2C logic if it was not activated before the
+	 * driver loaded
+	 */
+	if (!i2c->was_active) {
+		ctrl = kempld_read8(pld, KEMPLD_I2C_CTRL);
+		ctrl &= ~I2C_CTRL_EN;
+		kempld_write8(pld, KEMPLD_I2C_CTRL, ctrl);
+	}
+	kempld_release_mutex(pld);
+
+	i2c_del_adapter(&i2c->adap);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int kempld_i2c_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	struct kempld_i2c_data *i2c = platform_get_drvdata(pdev);
+	struct kempld_device_data *pld = i2c->pld;
+	u8 ctrl;
+
+	kempld_get_mutex(pld);
+	ctrl = kempld_read8(pld, KEMPLD_I2C_CTRL);
+	ctrl &= ~I2C_CTRL_EN;
+	kempld_write8(pld, KEMPLD_I2C_CTRL, ctrl);
+	kempld_release_mutex(pld);
+
+	return 0;
+}
+
+static int kempld_i2c_resume(struct platform_device *pdev)
+{
+	struct kempld_i2c_data *i2c = platform_get_drvdata(pdev);
+	struct kempld_device_data *pld = i2c->pld;
+
+	kempld_get_mutex(pld);
+	kempld_i2c_device_init(i2c);
+	kempld_release_mutex(pld);
+
+	return 0;
+}
+#else
+#define kempld_i2c_suspend	NULL
+#define kempld_i2c_resume	NULL
+#endif
+
+static struct platform_driver kempld_i2c_driver = {
+	.driver = {
+		.name = "kempld-i2c",
+		.owner = THIS_MODULE,
+	},
+	.probe		= kempld_i2c_probe,
+	.remove		= kempld_i2c_remove,
+	.suspend	= kempld_i2c_suspend,
+	.resume		= kempld_i2c_resume,
+};
+
+module_platform_driver(kempld_i2c_driver);
+
+MODULE_DESCRIPTION("KEM PLD I2C Driver");
+MODULE_AUTHOR("Michael Brunner <michael.brunner@kontron.com>");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:kempld_i2c");
-- 
1.7.9.5

