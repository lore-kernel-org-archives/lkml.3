Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551Ab3KPAH6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 19:07:58 -0500
Received: from mga09.intel.com ([134.134.136.24]:17217 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753894Ab3KPAHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 19:07:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="436111657"
From: David Cohen <david.a.cohen@linux.intel.com>
To: mingo@kernel.org, hch@infradead.org, hpa@zytor.com
Cc: tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org,
        lenb@kernel.org, David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH v1.1] x86: intel-mid: add test module for sfi_device()
Date: Fri, 15 Nov 2013 16:09:18 -0800
Message-Id: <1384560558-10462-1-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1384370961-30847-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1384370961-30847-1-git-send-email-david.a.cohen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a test module to validate sfi_device() when used from a
driver module.

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
---

v1 to v1.1:
 - Fixed typos on comment.
 - No functional changes

Br, David

---
 arch/x86/Kconfig                                   |  9 +++++
 arch/x86/platform/intel-mid/device_libs/Makefile   |  2 ++
 .../intel-mid/device_libs/platform_sfi_test.c      | 41 ++++++++++++++++++++++
 3 files changed, 52 insertions(+)
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_sfi_test.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 00fa3b7d2abe..140e1de64d81 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -456,6 +456,15 @@ config X86_INTEL_MID
 	  systems which do not have the PCI legacy interfaces (Moorestown,
 	  Medfield). If you are building for a PC class system say N here.
 
+config SFI_TEST_MODULE
+	tristate "Intel MID sfi test module"
+	depends on SFI && X86_INTEL_MID && m
+	---help---
+	  Select to build a test module to validate SFI devices on Intel MID
+	  platforms from driver modules.
+
+	  This module will be called platform_sfi_test.ko
+
 config X86_INTEL_LPSS
 	bool "Intel Low Power Subsystem Support"
 	depends on ACPI
diff --git a/arch/x86/platform/intel-mid/device_libs/Makefile b/arch/x86/platform/intel-mid/device_libs/Makefile
index 097e7a7940d8..b4e858e5c6e9 100644
--- a/arch/x86/platform/intel-mid/device_libs/Makefile
+++ b/arch/x86/platform/intel-mid/device_libs/Makefile
@@ -20,3 +20,5 @@ obj-$(subst m,y,$(CONFIG_DRM_MEDFIELD)) += platform_tc35876x.o
 obj-$(subst m,y,$(CONFIG_SERIAL_MRST_MAX3110)) += platform_max3111.o
 # MISC Devices
 obj-$(subst m,y,$(CONFIG_KEYBOARD_GPIO)) += platform_gpio_keys.o
+# Test
+obj-$(CONFIG_SFI_TEST_MODULE) += platform_sfi_test.o
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_sfi_test.c b/arch/x86/platform/intel-mid/device_libs/platform_sfi_test.c
new file mode 100644
index 000000000000..dc146f4a2c18
--- /dev/null
+++ b/arch/x86/platform/intel-mid/device_libs/platform_sfi_test.c
@@ -0,0 +1,41 @@
+/*
+ * platform_sfi_test.c: test module for sfi_device()
+ *
+ * (C) Copyright 2013 Intel Corporation
+ * Author: David Cohen <david.a.cohen@linux.intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#include <linux/module.h>
+#include <asm/intel-mid.h>
+
+/*
+ * Even though we're implementing this device_handler callback, it should
+ * never be called when loading the module because the sfi device name
+ * "I'm_not_here" won't match to any entry on sfi table.
+ *
+ * This test validates sfi_device() compilation and usage in modules.
+ * Despite this sfi device test isn't found in the end, the module tests Intel
+ * MID sfi codes when trying to match this device with current sfi table.
+ */
+static void
+sfi_test_dev_handler(struct sfi_device_table_entry *pentry, struct devs_id *dev)
+{
+	pr_info("%s: This is a test for sfi_device() as module\n", __func__);
+}
+
+static const struct devs_id sfi_test_dev_id __initconst = {
+	.name = "I'm_not_here",
+	.type = SFI_DEV_TYPE_UART,
+	.device_handler = sfi_test_dev_handler,
+};
+
+sfi_device(sfi_test_dev_id);
+
+MODULE_AUTHOR("David Cohen <david.a.cohen@linux.intel.com>");
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("This module provides test for sfi_device() macro");
-- 
1.8.4.2

