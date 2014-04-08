Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084AbaDHXob (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 19:44:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:37956 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756630AbaDHXo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 19:44:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,820,1389772800"; 
   d="scan'208";a="517106779"
From: David Cohen <david.a.cohen@linux.intel.com>
To: wim@iguana.be, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        gnomes@lxorguk.ukuu.org.uk, david.a.cohen@linux.intel.com
Subject: [PATCH 2/2] x86: intel-mid: add watchdog platform code for Merrifield
Date: Tue,  8 Apr 2014 13:59:04 -0700
Message-Id: <1396990744-10695-3-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1396990744-10695-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1396990744-10695-1-git-send-email-david.a.cohen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds platform code for Intel Merrifield.
Since the watchdog is not part of SFI table, we have no other option but
to manually register watchdog's platform device (argh!).

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
---
 arch/x86/platform/intel-mid/device_libs/Makefile   |  1 +
 .../platform/intel-mid/device_libs/platform_wdt.c  | 43 ++++++++++++++++++++++
 2 files changed, 44 insertions(+)
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_wdt.c

diff --git a/arch/x86/platform/intel-mid/device_libs/Makefile b/arch/x86/platform/intel-mid/device_libs/Makefile
index 097e7a7940d8..af9307f2cc28 100644
--- a/arch/x86/platform/intel-mid/device_libs/Makefile
+++ b/arch/x86/platform/intel-mid/device_libs/Makefile
@@ -20,3 +20,4 @@ obj-$(subst m,y,$(CONFIG_DRM_MEDFIELD)) += platform_tc35876x.o
 obj-$(subst m,y,$(CONFIG_SERIAL_MRST_MAX3110)) += platform_max3111.o
 # MISC Devices
 obj-$(subst m,y,$(CONFIG_KEYBOARD_GPIO)) += platform_gpio_keys.o
+obj-$(subst m,y,$(CONFIG_INTEL_MID_WATCHDOG)) += platform_wdt.o
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_wdt.c b/arch/x86/platform/intel-mid/device_libs/platform_wdt.c
new file mode 100644
index 000000000000..be4fc66fbe1b
--- /dev/null
+++ b/arch/x86/platform/intel-mid/device_libs/platform_wdt.c
@@ -0,0 +1,43 @@
+/*
+ * platform_wdt.c: Watchdog platform library file
+ *
+ * (C) Copyright 2014 Intel Corporation
+ * Author: David Cohen <david.a.cohen@linux.intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <asm/intel-mid.h>
+
+#define EXT_TIMER0_MSI 15
+
+static const struct resource tangier_wdt_res[] = {
+	{
+		.start = EXT_TIMER0_MSI,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device mid_wdt_dev = {
+	.name = "intel_mid_wdt",
+	.id = -1,
+};
+
+static int __init register_mid_wdt(void)
+{
+	if (intel_mid_identify_cpu() == INTEL_MID_CPU_CHIP_TANGIER) {
+		platform_device_add_resources(&mid_wdt_dev,
+					      tangier_wdt_res,
+					      ARRAY_SIZE(tangier_wdt_res));
+		return platform_device_register(&mid_wdt_dev);
+	}
+
+	return -ENODEV;
+}
+
+rootfs_initcall(register_mid_wdt);
-- 
1.9.0

