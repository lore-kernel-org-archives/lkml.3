Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427AbaDOWUk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 18:20:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:14917 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305AbaDOWUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 18:20:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,867,1389772800"; 
   d="scan'208";a="521616893"
From: David Cohen <david.a.cohen@linux.intel.com>
To: wim@iguana.be, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org
Cc: david.a.cohen@linux.intel.com, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk,
        linux@roeck-us.net
Subject: [PATCH v4.1 2/2] x86: intel-mid: add watchdog platform code for Merrifield
Date: Tue, 15 Apr 2014 15:20:32 -0700
Message-Id: <1397600432-7243-1-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397592366-3899-3-git-send-email-david.a.cohen@linux.intel.com>
References: <1397592366-3899-3-git-send-email-david.a.cohen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds platform code for Intel Merrifield.
Since the watchdog is not part of SFI table, we have no other option but
to manually register watchdog's platform device (argh!).

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
---

changes from v4 to v4.1:
 - dropped hardcoded irq value on mrfl_probe() function in favor or pdata's irq
   value.
--
 arch/x86/platform/intel-mid/device_libs/Makefile   |  1 +
 .../platform/intel-mid/device_libs/platform_wdt.c  | 71 ++++++++++++++++++++++
 2 files changed, 72 insertions(+)
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
index 000000000000..a05315eb052d
--- /dev/null
+++ b/arch/x86/platform/intel-mid/device_libs/platform_wdt.c
@@ -0,0 +1,71 @@
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
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/platform_data/intel-mid_wdt.h>
+#include <asm/intel-mid.h>
+
+#define TANGIER_EXT_TIMER0_MSI 15
+
+static struct platform_device wdt_dev = {
+	.name = "intel_mid_wdt",
+	.id = -1,
+};
+
+static int tangier_probe(struct platform_device *pdev)
+{
+	int ioapic;
+	int irq;
+	struct intel_mid_wdt_pdata *pdata = pdev->dev.platform_data;
+	struct io_apic_irq_attr irq_attr = { 0 };
+
+	if (!pdata)
+		return -EINVAL;
+
+	irq = pdata->irq;
+	ioapic = mp_find_ioapic(irq);
+	if (ioapic >= 0) {
+		int ret;
+		irq_attr.ioapic = ioapic;
+		irq_attr.ioapic_pin = irq;
+		irq_attr.trigger = 1;
+		/* irq_attr.polarity = 0; -> Active high */
+		ret = io_apic_set_pci_routing(NULL, irq, &irq_attr);
+		if (ret)
+			return ret;
+	} else {
+		dev_warn(&pdev->dev, "cannot find interrupt %d in ioapic\n",
+			 irq);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static struct intel_mid_wdt_pdata tangier_pdata = {
+	.irq = TANGIER_EXT_TIMER0_MSI,
+	.probe = tangier_probe,
+};
+
+static int __init register_mid_wdt(void)
+{
+	if (intel_mid_identify_cpu() == INTEL_MID_CPU_CHIP_TANGIER) {
+		wdt_dev.dev.platform_data = &tangier_pdata;
+		return platform_device_register(&wdt_dev);
+	}
+
+	return -ENODEV;
+}
+
+rootfs_initcall(register_mid_wdt);
-- 
1.9.1

