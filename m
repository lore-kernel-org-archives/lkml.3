Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615Ab3KTOcP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 09:32:15 -0500
Received: from mga02.intel.com ([134.134.136.20]:59118 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753119Ab3KTOcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 09:32:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="438546262"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        David Cohen <david.a.cohen@intel.com>,
        "linux-gpio @ vger . kernel . org" <linux-gpio@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>,
        Len Brown <lenb@kernel.org>,
        "linux-kernel @ vger . kernel . org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH v2 2/3] gpiolib: append SFI helpers for GPIO API
Date: Wed, 20 Nov 2013 16:31:35 +0200
Message-Id: <1384957896-3477-3-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1384957896-3477-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1384957896-3477-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To support some (legacy) firmwares and platforms let's make life easier for
their customers.

This patch extracts SFI GPIO API from arch/x86/platform/intel-mid/sfi.c and
moves it to GPIO descriptor API.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/gpio/Kconfig       |  4 +++
 drivers/gpio/Makefile      |  1 +
 drivers/gpio/gpiolib-sfi.c | 77 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/sfi/sfi_core.c     |  9 +++++-
 include/linux/gpio/sfi.h   | 37 ++++++++++++++++++++++
 5 files changed, 127 insertions(+), 1 deletion(-)
 create mode 100644 drivers/gpio/gpiolib-sfi.c
 create mode 100644 include/linux/gpio/sfi.h

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 0f04444..9a4fe9f 100644
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
index 7971e36..b6820bc 100644
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
index 0000000..5dc6314
--- /dev/null
+++ b/drivers/gpio/gpiolib-sfi.c
@@ -0,0 +1,77 @@
+/*
+ * Simple Firmware Interface (SFI) helpers for GPIO API
+ *
+ * Copyright (C) 2013, Intel Corporation
+ * Author: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
+ *
+ * Based on work done for Intel MID platform
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
+#include <linux/export.h>
+#include <linux/sfi.h>
+#include <linux/gpio/consumer.h>
+#include <linux/gpio/sfi.h>
+
+static struct sfi_gpio_table_entry *sfi_gpio_table;
+static int sfi_gpio_num_entry;
+
+struct gpio_desc *sfi_get_gpiod_by_name(const char *name)
+{
+	struct sfi_gpio_table_entry *pentry = sfi_gpio_table;
+	int i;
+
+	if (!pentry)
+		return ERR_PTR(-EINVAL);
+
+	for (i = 0; i < sfi_gpio_num_entry; i++, pentry++) {
+		if (!strncmp(name, pentry->pin_name, SFI_NAME_LEN))
+			return gpio_to_desc(pentry->pin_no);
+	}
+
+	return ERR_PTR(-ENODEV);
+}
+EXPORT_SYMBOL_GPL(sfi_get_gpiod_by_name);
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
index 296db7a..1fab93d 100644
--- a/drivers/sfi/sfi_core.c
+++ b/drivers/sfi/sfi_core.c
@@ -66,8 +66,9 @@
 #include <linux/types.h>
 #include <linux/acpi.h>
 #include <linux/init.h>
-#include <linux/sfi.h>
 #include <linux/slab.h>
+#include <linux/sfi.h>
+#include <linux/gpio/sfi.h>
 
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
diff --git a/include/linux/gpio/sfi.h b/include/linux/gpio/sfi.h
new file mode 100644
index 0000000..3e111ad
--- /dev/null
+++ b/include/linux/gpio/sfi.h
@@ -0,0 +1,37 @@
+#ifndef _LINUX_SFI_GPIO_H_
+#define _LINUX_SFI_GPIO_H_
+
+#include <linux/err.h>
+#include <linux/errno.h>
+#include <linux/gpio/consumer.h>
+#include <linux/sfi.h>
+
+#ifdef CONFIG_GPIO_SFI
+
+struct gpio_desc *sfi_get_gpiod_by_name(const char *name);
+int sfi_gpio_init(void);
+
+#else /* CONFIG_GPIO_SFI */
+
+static inline struct gpio_desc *sfi_get_gpiod_by_name(const char *name);
+{
+	return ERR_PTR(-ENODEV);
+}
+
+static inline int sfi_gpio_init(void)
+{
+	return -ENODEV;
+}
+
+#endif /* CONFIG_GPIO_SFI */
+
+static inline int sfi_get_gpio_by_name(const char *name)
+{
+	struct gpio_desc *desc = sfi_get_gpiod_by_name(name);
+
+	if (IS_ERR(desc))
+		return PTR_ERR(desc);
+	return desc_to_gpio(desc);
+}
+
+#endif /* _LINUX_SFI_GPIO_H_ */
-- 
1.8.4.3

