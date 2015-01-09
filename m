Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228AbbAIJyk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 04:54:40 -0500
Received: from down.free-electrons.com ([37.187.137.238]:38081 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756239AbbAIJvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 04:51:39 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-watchdog@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH v2 2/8] mfd: Add atmel-st driver
Date: Fri,  9 Jan 2015 10:51:28 +0100
Message-Id: <1420797094-9444-3-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420797094-9444-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1420797094-9444-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Atmel System Timer IP available on the at91rm9200 exposes both a timer and a
watchdog.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 drivers/mfd/Kconfig          |  7 ++++
 drivers/mfd/Makefile         |  1 +
 drivers/mfd/atmel-st.c       | 76 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/atmel-st.h | 47 +++++++++++++++++++++++++++
 4 files changed, 131 insertions(+)
 create mode 100644 drivers/mfd/atmel-st.c
 create mode 100644 include/linux/mfd/atmel-st.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 2e6b7311fabc..3c5185c0cf06 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -78,6 +78,13 @@ config MFD_BCM590XX
 	help
 	  Support for the BCM590xx PMUs from Broadcom
 
+config MFD_ATMEL_ST
+	bool "Atmel System Timer"
+	select MFD_CORE
+	default SOC_AT91RM9200
+	help
+	  If you say Y here you get support for the Atmel System Timer.
+
 config MFD_AXP20X
 	bool "X-Powers AXP20X"
 	select MFD_CORE
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 53467e211381..1ecd416f25c5 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -104,6 +104,7 @@ obj-$(CONFIG_PMIC_DA9052)	+= da9052-core.o
 obj-$(CONFIG_MFD_DA9052_SPI)	+= da9052-spi.o
 obj-$(CONFIG_MFD_DA9052_I2C)	+= da9052-i2c.o
 obj-$(CONFIG_MFD_AXP20X)	+= axp20x.o
+obj-$(CONFIG_MFD_ATMEL_ST)	+= atmel-st.o
 
 obj-$(CONFIG_MFD_LP3943)	+= lp3943.o
 obj-$(CONFIG_MFD_LP8788)	+= lp8788.o lp8788-irq.o
diff --git a/drivers/mfd/atmel-st.c b/drivers/mfd/atmel-st.c
new file mode 100644
index 000000000000..5af83cbfe404
--- /dev/null
+++ b/drivers/mfd/atmel-st.c
@@ -0,0 +1,76 @@
+/*
+ * Copyright (C) 2014 Free Electrons
+ * Copyright (C) 2014 Atmel
+ *
+ * Author: Alexandre Belloni <alexandre.belloni@free-electrons.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/mfd/atmel-st.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/syscon.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/regmap.h>
+
+static const struct mfd_cell atmel_st_cells[] = {
+	{
+		.name = "atmel_st_timer",
+	},
+	{
+		.name = "atmel_st_watchdog",
+	},
+};
+
+static int atmel_st_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct regmap *regmap_st;
+
+	regmap_st = syscon_node_to_regmap(dev->of_node);
+	if (IS_ERR(regmap_st))
+		return PTR_ERR(regmap_st);
+	dev_set_drvdata(dev, regmap_st);
+
+	return mfd_add_devices(dev, -1, atmel_st_cells,
+			       ARRAY_SIZE(atmel_st_cells),
+			       NULL, 0, NULL);
+}
+
+static int atmel_st_remove(struct platform_device *pdev)
+{
+	mfd_remove_devices(&pdev->dev);
+
+	return 0;
+}
+
+static const struct of_device_id atmel_st_match[] = {
+	{ .compatible = "atmel,at91rm9200-st" },
+	{ /* sentinel */ },
+};
+
+static struct platform_driver atmel_st_driver = {
+	.probe = atmel_st_probe,
+	.remove = atmel_st_remove,
+	.driver = {
+		.name = "atmel-system-timer",
+		.of_match_table = atmel_st_match,
+	},
+};
+module_platform_driver(atmel_st_driver);
+
+MODULE_ALIAS("platform:atmel-st");
+MODULE_AUTHOR("Alexandre Belloni <alexandre.belloni@free-electrons.com>");
+MODULE_DESCRIPTION("Atmel ST (System Timer) driver");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/mfd/atmel-st.h b/include/linux/mfd/atmel-st.h
new file mode 100644
index 000000000000..88c6cf8eeb2b
--- /dev/null
+++ b/include/linux/mfd/atmel-st.h
@@ -0,0 +1,47 @@
+/*
+ * Copyright (C) 2005 Ivan Kokshaysky
+ * Copyright (C) SAN People
+ *
+ * System Timer (ST) - System peripherals registers.
+ * Based on AT91RM9200 datasheet revision E.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __LINUX_MFD_ATMEL_ST_H
+#define __LINUX_MFD_ATMEL_ST_H
+
+#define	AT91_ST_CR		0x00			/* Control Register */
+#define 	AT91_ST_WDRST		(1 << 0)		/* Watchdog Timer Restart */
+
+#define	AT91_ST_PIMR		0x04			/* Period Interval Mode Register */
+#define		AT91_ST_PIV		(0xffff <<  0)		/* Period Interval Value */
+
+#define	AT91_ST_WDMR		0x08			/* Watchdog Mode Register */
+#define		AT91_ST_WDV		(0xffff <<  0)		/* Watchdog Counter Value */
+#define		AT91_ST_RSTEN		(1	<< 16)		/* Reset Enable */
+#define		AT91_ST_EXTEN		(1	<< 17)		/* External Signal Assertion Enable */
+
+#define	AT91_ST_RTMR		0x0c			/* Real-time Mode Register */
+#define		AT91_ST_RTPRES		(0xffff <<  0)		/* Real-time Prescalar Value */
+
+#define	AT91_ST_SR		0x10			/* Status Register */
+#define		AT91_ST_PITS		(1 << 0)		/* Period Interval Timer Status */
+#define		AT91_ST_WDOVF		(1 << 1) 		/* Watchdog Overflow */
+#define		AT91_ST_RTTINC		(1 << 2) 		/* Real-time Timer Increment */
+#define		AT91_ST_ALMS		(1 << 3) 		/* Alarm Status */
+
+#define	AT91_ST_IER		0x14			/* Interrupt Enable Register */
+#define	AT91_ST_IDR		0x18			/* Interrupt Disable Register */
+#define	AT91_ST_IMR		0x1c			/* Interrupt Mask Register */
+
+#define	AT91_ST_RTAR		0x20			/* Real-time Alarm Register */
+#define		AT91_ST_ALMV		(0xfffff << 0)		/* Alarm Value */
+
+#define	AT91_ST_CRTR		0x24			/* Current Real-time Register */
+#define		AT91_ST_CRTV		(0xfffff << 0)		/* Current Real-Time Value */
+
+#endif /* __LINUX_MFD_ATMEL_ST_H */
-- 
2.1.0

