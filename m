Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411Ab3FEN6b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 09:58:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:1228 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803Ab3FEN6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 09:58:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,807,1363158000"; 
   d="scan'208";a="324645097"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>,
        Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        David Cohen <david.a.cohen@intel.com>,
        Grant Likely <grant.likely@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1.2] gpiolib: append SFI helpers for GPIO API
Date: Wed,  5 Jun 2013 16:58:10 +0300
Message-Id: <1370440690-21898-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To support some (legacy) firmwares and platforms let's make life easier for
their customers.

This patch extracts SFI GPIO API from arch/x86/platform/mrst/mrst.c.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Len Brown <len.brown@intel.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
---
Since v1.1:
 - use container_of
 - switch to kmemdup

 drivers/gpio/Kconfig       |  4 +++
 drivers/gpio/Makefile      |  1 +
 drivers/gpio/gpiolib-sfi.c | 77 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/sfi/sfi_core.c     |  7 +++++
 include/linux/sfi_gpio.h   | 27 ++++++++++++++++
 5 files changed, 116 insertions(+)
 create mode 100644 drivers/gpio/gpiolib-sfi.c
 create mode 100644 include/linux/sfi_gpio.h

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index f471fe8..a615d47 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -51,6 +51,10 @@ config OF_GPIO
 	def_bool y
 	depends on OF
 
+config GPIO_SFI
+	def_bool y
+	depends on SFI
+
 config GPIO_ACPI
 	def_bool y
 	depends on ACPI
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 0cb2d65..63d2abd 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -5,6 +5,7 @@ ccflags-$(CONFIG_DEBUG_GPIO)	+= -DDEBUG
 obj-$(CONFIG_GPIO_DEVRES)	+= devres.o
 obj-$(CONFIG_GPIOLIB)		+= gpiolib.o
 obj-$(CONFIG_OF_GPIO)		+= gpiolib-of.o
+obj-$(CONFIG_GPIO_SFI)		+= gpiolib-sfi.o
 obj-$(CONFIG_GPIO_ACPI)		+= gpiolib-acpi.o
 
 # Device drivers. Generally keep list sorted alphabetically
diff --git a/drivers/gpio/gpiolib-sfi.c b/drivers/gpio/gpiolib-sfi.c
new file mode 100644
index 0000000..32e8605
--- /dev/null
+++ b/drivers/gpio/gpiolib-sfi.c
@@ -0,0 +1,77 @@
+/*
+ * Simple Firmware Interface (SFI) helpers for GPIO API
+ *
+ * Copyright (C) 2013, Intel Corporation
+ * Author: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
+ *
+ * Based on work done for Intel MID platforms (mrst.c)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#define pr_fmt(fmt) "SFI: GPIO: " fmt
+
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/slab.h>
+#include <linux/gpio.h>
+#include <linux/export.h>
+#include <linux/sfi_gpio.h>
+#include <linux/sfi.h>
+
+static struct sfi_gpio_table_entry *sfi_gpio_table;
+static int sfi_gpio_num_entry;
+
+int sfi_get_gpio_by_name(const char *name)
+{
+	struct sfi_gpio_table_entry *pentry = sfi_gpio_table;
+	int i;
+
+	if (!pentry)
+		return -EINVAL;
+
+	for (i = 0; i < sfi_gpio_num_entry; i++, pentry++) {
+		if (!strncmp(name, pentry->pin_name, SFI_NAME_LEN))
+			return pentry->pin_no;
+	}
+
+	return -ENODEV;
+}
+EXPORT_SYMBOL_GPL(sfi_get_gpio_by_name);
+
+static int __init sfi_gpio_parse(struct sfi_table_header *table)
+{
+	struct sfi_table_simple *sb;
+	struct sfi_gpio_table_entry *pentry;
+	int num, i;
+
+	if (sfi_gpio_table)
+		return 0;
+
+	sb = container_of(table, struct sfi_table_simple, header);
+
+	num = SFI_GET_NUM_ENTRIES(sb, struct sfi_gpio_table_entry);
+	pentry = (struct sfi_gpio_table_entry *)sb->pentry;
+
+	sfi_gpio_table = kmemdup(pentry, num * sizeof(*pentry), GFP_KERNEL);
+	if (!sfi_gpio_table)
+		return -ENOMEM;
+
+	sfi_gpio_num_entry = num;
+
+	pr_debug("Pin info:\n");
+	for (i = 0; i < num; i++, pentry++)
+		pr_debug("[%2d] chip = %16.16s, name = %16.16s, pin=%d\n", i,
+			 pentry->controller_name, pentry->pin_name,
+			 pentry->pin_no);
+
+	return 0;
+}
+
+int __init sfi_gpio_init(void)
+{
+	return sfi_table_parse(SFI_SIG_GPIO, NULL, NULL, sfi_gpio_parse);
+}
diff --git a/drivers/sfi/sfi_core.c b/drivers/sfi/sfi_core.c
index 296db7a..2828da0 100644
--- a/drivers/sfi/sfi_core.c
+++ b/drivers/sfi/sfi_core.c
@@ -67,6 +67,7 @@
 #include <linux/acpi.h>
 #include <linux/init.h>
 #include <linux/sfi.h>
+#include <linux/sfi_gpio.h>
 #include <linux/slab.h>
 
 #include "sfi_core.h"
@@ -512,6 +513,12 @@ void __init sfi_init_late(void)
 	syst_va = sfi_map_memory(syst_pa, length);
 
 	sfi_acpi_init();
+
+	/*
+	 * Parsing GPIO table first, since the DEVS table will need this table
+	 * to map the pin name to the actual pin.
+	 */
+	sfi_gpio_init();
 }
 
 /*
diff --git a/include/linux/sfi_gpio.h b/include/linux/sfi_gpio.h
new file mode 100644
index 0000000..02ae6df
--- /dev/null
+++ b/include/linux/sfi_gpio.h
@@ -0,0 +1,27 @@
+#ifndef _LINUX_SFI_GPIO_H_
+#define _LINUX_SFI_GPIO_H_
+
+#include <linux/errno.h>
+#include <linux/gpio.h>
+#include <linux/sfi.h>
+
+#ifdef CONFIG_GPIO_SFI
+
+int sfi_get_gpio_by_name(const char *name);
+int sfi_gpio_init(void);
+
+#else /* CONFIG_GPIO_SFI */
+
+static inline int sfi_get_gpio_by_name(const char *name);
+{
+	return -ENODEV;
+}
+
+static inline int sfi_gpio_init(void)
+{
+	return -ENODEV;
+}
+
+#endif /* CONFIG_GPIO_SFI */
+
+#endif /* _LINUX_SFI_GPIO_H_ */
-- 
1.8.2.rc0.22.gb3600c3

