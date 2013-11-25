Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421Ab3KYTjs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 14:39:48 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:57996 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593Ab3KYTjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 14:39:46 -0500
From: Olof Johansson <olof@lixom.net>
To: linux-kernel@vger.kernel.org
Cc: keescook@chromium.org, bleung@chromium.org,
        Olof Johansson <olof@lixom.net>
Subject: [PATCH] platform/chrome: Add pstore platform_device
Date: Mon, 25 Nov 2013 11:37:06 -0800
Message-Id: <1385408226-22369-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.8.4.1.601.g02b3b1d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the ramoops pstore device so that we get logs of panics across reboots.

Signed-off-by: Olof Johansson <olof@lixom.net>
---

 drivers/platform/chrome/Kconfig           |  14 +++++
 drivers/platform/chrome/Makefile          |   1 +
 drivers/platform/chrome/chromeos_pstore.c | 101 ++++++++++++++++++++++++++++++
 3 files changed, 116 insertions(+)
 create mode 100644 drivers/platform/chrome/chromeos_pstore.c

diff --git a/drivers/platform/chrome/Kconfig b/drivers/platform/chrome/Kconfig
index b13303e75a34..06c53c8132ad 100644
--- a/drivers/platform/chrome/Kconfig
+++ b/drivers/platform/chrome/Kconfig
@@ -25,4 +25,18 @@ config CHROMEOS_LAPTOP
 	  If you have a supported Chromebook, choose Y or M here.
 	  The module will be called chromeos_laptop.
 
+config CHROMEOS_PSTORE
+	tristate "Chrome OS pstore support"
+	---help---
+	  This module instantiates the persistent storage on x86 ChromeOS
+	  devices. It can be used to store away console logs and crash
+	  information across reboots.
+
+	  The range of memory used is 0xf00000-0x1000000, tradionally the
+	  memory used to back VGA controller memory.
+
+	  If you have a supported Chromebook, choose Y or M here.
+	  The module will be called chromeos_pstore.
+
+
 endif # CHROMEOS_PLATFORMS
diff --git a/drivers/platform/chrome/Makefile b/drivers/platform/chrome/Makefile
index 015e9195e226..2b860ca7450f 100644
--- a/drivers/platform/chrome/Makefile
+++ b/drivers/platform/chrome/Makefile
@@ -1,2 +1,3 @@
 
 obj-$(CONFIG_CHROMEOS_LAPTOP)	+= chromeos_laptop.o
+obj-$(CONFIG_CHROMEOS_PSTORE)	+= chromeos_pstore.o
diff --git a/drivers/platform/chrome/chromeos_pstore.c b/drivers/platform/chrome/chromeos_pstore.c
new file mode 100644
index 000000000000..e0e0e65cf442
--- /dev/null
+++ b/drivers/platform/chrome/chromeos_pstore.c
@@ -0,0 +1,101 @@
+/*
+ *  chromeos_pstore.c - Driver to instantiate Chromebook ramoops device
+ *
+ *  Copyright (C) 2013 Google, Inc.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation, version 2 of the License.
+ */
+
+#include <linux/dmi.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/pstore_ram.h>
+
+static struct dmi_system_id chromeos_pstore_dmi_table[] __initdata = {
+	{
+		/*
+		 * Today all Chromebooks/boxes ship with GOOGLE as vendor and
+		 * coreboot as bios vendor. No other systems with this
+		 * combination are known to date.
+		 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "GOOGLE"),
+			DMI_MATCH(DMI_BIOS_VENDOR, "coreboot"),
+		},
+	},
+	{
+		/*
+		 * The first Samsung Chromebox and Chromebook Series 5 550 use
+		 * coreboot but with Samsung as the system vendor.
+		 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG"),
+			DMI_MATCH(DMI_BIOS_VENDOR, "coreboot"),
+		},
+	},
+	{
+		/* x86-alex, the first Samsung Chromebook. */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Alex"),
+		},
+	},
+	{
+		/* x86-mario, the Cr-48 pilot device from Google. */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "IEC"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Mario"),
+		},
+	},
+	{
+		/* x86-zgb, the first Acer Chromebook. */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ACER"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ZGB"),
+		},
+	},
+	{ }
+};
+MODULE_DEVICE_TABLE(dmi, chromeos_pstore_dmi_table);
+
+/*
+ * On x86 chromebooks/boxes, the firmware will keep the legacy VGA memory
+ * range untouched across reboots, so we use that to store our pstore
+ * contents for panic logs, etc.
+ */
+static struct ramoops_platform_data chromeos_ramoops_data = {
+	.mem_size	= 0x100000,
+	.mem_address	= 0xf00000,
+	.record_size	= 0x20000,
+	.console_size	= 0x20000,
+	.ftrace_size	= 0x20000,
+	.dump_oops	= 1,
+};
+
+static struct platform_device chromeos_ramoops = {
+	.name = "ramoops",
+	.dev = {
+		.platform_data = &chromeos_ramoops_data,
+	},
+};
+
+static int __init chromeos_pstore_init(void)
+{
+	if (dmi_check_system(chromeos_pstore_dmi_table))
+		return platform_device_register(&chromeos_ramoops);
+
+	return -ENODEV;
+}
+
+static void __exit chromeos_pstore_exit(void)
+{
+	platform_device_unregister(&chromeos_ramoops);
+}
+
+module_init(chromeos_pstore_init);
+module_exit(chromeos_pstore_exit);
+
+MODULE_DESCRIPTION("Chrome OS pstore module");
+MODULE_LICENSE("GPL");
-- 
1.8.4.1.601.g02b3b1d

