Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757154AbaDHXo2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 19:44:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:37945 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756232AbaDHXo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 19:44:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,820,1389772800"; 
   d="scan'208";a="517106780"
From: David Cohen <david.a.cohen@linux.intel.com>
To: wim@iguana.be, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        gnomes@lxorguk.ukuu.org.uk, david.a.cohen@linux.intel.com,
        Eric Ernst <eric.ernst@intel.com>
Subject: [PATCH 1/2] watchdog: add Intel MID watchdog driver support
Date: Tue,  8 Apr 2014 13:59:03 -0700
Message-Id: <1396990744-10695-2-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1396990744-10695-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1396990744-10695-1-git-send-email-david.a.cohen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add initial Intel MID watchdog driver support.

This driver is an initial implementation of generic Intel MID watchdog
driver. Currently it supports Intel Merrifield platform.

Signed-off-by: Eric Ernst <eric.ernst@intel.com>
Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
---
 drivers/watchdog/Kconfig         |  12 +++
 drivers/watchdog/Makefile        |   1 +
 drivers/watchdog/intel-mid_wdt.c | 209 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 222 insertions(+)
 create mode 100644 drivers/watchdog/intel-mid_wdt.c

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 79d25894343a..4da09b8b2f11 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -643,6 +643,18 @@ config INTEL_SCU_WATCHDOG
 
 	  To compile this driver as a module, choose M here.
 
+config INTEL_MID_WATCHDOG
+	bool "Intel MID SCU Watchdog Mobile Platforms"
+	depends on X86_INTEL_MID && WATCHDOG_CORE
+	---help---
+	  Watchdog timer driver built into the Intel SCU for Intel MID
+	  Platforms.
+
+	  This driver currently supports only the watchdog evolution
+	  implementation in SCU, available for Merrifield generation.
+
+	  To compile this driver as a module, choose M here.
+
 config ITCO_WDT
 	tristate "Intel TCO Timer/Watchdog"
 	depends on (X86 || IA64) && PCI
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index 985a66cda76f..b927e7496eb4 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -113,6 +113,7 @@ obj-$(CONFIG_W83977F_WDT) += w83977f_wdt.o
 obj-$(CONFIG_MACHZ_WDT) += machzwd.o
 obj-$(CONFIG_SBC_EPX_C3_WATCHDOG) += sbc_epx_c3.o
 obj-$(CONFIG_INTEL_SCU_WATCHDOG) += intel_scu_watchdog.o
+obj-$(CONFIG_INTEL_MID_WATCHDOG) += intel-mid_wdt.o
 
 # M32R Architecture
 
diff --git a/drivers/watchdog/intel-mid_wdt.c b/drivers/watchdog/intel-mid_wdt.c
new file mode 100644
index 000000000000..6339c6351454
--- /dev/null
+++ b/drivers/watchdog/intel-mid_wdt.c
@@ -0,0 +1,209 @@
+/*
+ *      intel-mid_wdt: generic Intel MID SCU watchdog driver
+ *
+ *      Platforms supported so far:
+ *      - Merrifield only
+ *
+ *      Copyright (C) 2014 Intel Corporation. All rights reserved.
+ *      Contact: David Cohen <david.a.cohen@linux.intel.com>
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of version 2 of the GNU General
+ *      Public License as published by the Free Software Foundation.
+ */
+
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/nmi.h>
+#include <linux/platform_device.h>
+#include <linux/watchdog.h>
+
+#include <asm/intel_scu_ipc.h>
+#include <asm/intel-mid.h>
+
+#define IPC_WATCHDOG 0xf8
+
+#define MID_WDT_PRETIMEOUT		15
+#define MID_WDT_TIMEOUT_MIN		(1 + MID_WDT_PRETIMEOUT)
+#define MID_WDT_TIMEOUT_MAX		170
+#define MID_WDT_DEFAULT_TIMEOUT		90
+
+/* SCU watchdog messages */
+enum {
+	SCU_WATCHDOG_START = 0,
+	SCU_WATCHDOG_STOP,
+	SCU_WATCHDOG_KEEPALIVE,
+};
+
+static inline int wdt_command(int sub, u32 *in, int inlen)
+{
+	return intel_scu_ipc_command(IPC_WATCHDOG, sub, in, inlen, NULL, 0);
+}
+
+static int wdt_start(struct watchdog_device *wd)
+{
+	int ret, in_size;
+	int timeout = wd->timeout;
+	struct ipc_wd_start {
+		u32 pretimeout;
+		u32 timeout;
+	} ipc_wd_start = { timeout - MID_WDT_PRETIMEOUT, timeout };
+
+	/*
+	 * SCU expects the input size for watchdog IPC to
+	 * be based on double-word
+	 */
+	in_size = (sizeof(ipc_wd_start) + 3) / 4;
+
+	ret = wdt_command(SCU_WATCHDOG_START, (u32 *)&ipc_wd_start, in_size);
+	if (ret) {
+		struct device *dev = watchdog_get_drvdata(wd);
+		dev_crit(dev, "error starting watchdog: %d\n", ret);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int wdt_ping(struct watchdog_device *wd)
+{
+	int ret;
+
+	ret = wdt_command(SCU_WATCHDOG_KEEPALIVE, NULL, 0);
+	if (ret) {
+		struct device *dev = watchdog_get_drvdata(wd);
+		dev_crit(dev, "Error executing keepalive: 0x%x\n", ret);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int wdt_stop(struct watchdog_device *wd)
+{
+	int ret;
+
+	ret = wdt_command(SCU_WATCHDOG_STOP, NULL, 0);
+	if (ret) {
+		struct device *dev = watchdog_get_drvdata(wd);
+		dev_crit(dev, "Error stopping watchdog: 0x%x\n", ret);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static irqreturn_t mid_wdt_warning_irq(int irq, void *dev_id)
+{
+	/* Let's dump some data before panic */
+	trigger_all_cpu_backtrace();
+	panic("Kernel Watchdog");
+
+	/* This code should not be reached */
+	return IRQ_HANDLED;
+}
+
+/*
+ * Current driver supports Merrifield only.
+ * This function will get more generic when necessary.
+ */
+static int handle_dev_ioapic(struct device *dev, int irq)
+{
+	int ioapic;
+	struct io_apic_irq_attr irq_attr;
+
+	ioapic = mp_find_ioapic(irq);
+	if (ioapic >= 0) {
+		irq_attr.ioapic = ioapic;
+		irq_attr.ioapic_pin = irq;
+		irq_attr.trigger = 1;
+		irq_attr.polarity = 0; /* Active high */
+		io_apic_set_pci_routing(NULL, irq, &irq_attr);
+	} else {
+		dev_warn(dev, "can not find interrupt %d in ioapic\n", irq);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static const struct watchdog_info mid_wdt_info = {
+	.identity = "Intel MID SCU watchdog",
+	.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT,
+};
+
+static const struct watchdog_ops mid_wdt_ops = {
+	.owner = THIS_MODULE,
+	.start = wdt_start,
+	.stop = wdt_stop,
+	.ping = wdt_ping,
+};
+
+static int mid_wdt_probe(struct platform_device *pdev)
+{
+	struct watchdog_device *wdt_dev;
+	struct resource *res;
+	int ret;
+	int irq;
+
+	wdt_dev = devm_kzalloc(&pdev->dev, sizeof(*wdt_dev), GFP_KERNEL);
+	if (!wdt_dev)
+		return -ENOMEM;
+
+	wdt_dev->info = &mid_wdt_info;
+	wdt_dev->ops = &mid_wdt_ops;
+	wdt_dev->min_timeout = MID_WDT_TIMEOUT_MIN;
+	wdt_dev->max_timeout = MID_WDT_TIMEOUT_MAX;
+	wdt_dev->timeout = MID_WDT_DEFAULT_TIMEOUT;
+
+	watchdog_set_drvdata(wdt_dev, &pdev->dev);
+	platform_set_drvdata(pdev, wdt_dev);
+
+	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (!res) {
+		dev_err(&pdev->dev, "missing IRQ resource\n");
+		return -EINVAL;
+	}
+	irq = res->start;
+
+	handle_dev_ioapic(&pdev->dev, irq);
+	ret = devm_request_irq(&pdev->dev, irq, mid_wdt_warning_irq,
+			       IRQF_SHARED | IRQF_NO_SUSPEND, "watchdog",
+			       wdt_dev);
+	if (ret) {
+		dev_err(&pdev->dev, "error requesting warning irq %d\n", irq);
+		return ret;
+	}
+
+	ret = watchdog_register_device(wdt_dev);
+	if (ret) {
+		dev_err(&pdev->dev, "error registering watchdog device\n");
+		return ret;
+	}
+
+	dev_info(&pdev->dev, "Intel MID watchdog device probed\n");
+
+	return 0;
+}
+
+static int mid_wdt_remove(struct platform_device *pdev)
+{
+	struct watchdog_device *wd = platform_get_drvdata(pdev);
+	watchdog_unregister_device(wd);
+	return 0;
+}
+
+static struct platform_driver mid_wdt_driver = {
+	.probe		= mid_wdt_probe,
+	.remove		= mid_wdt_remove,
+	.driver		= {
+		.owner	= THIS_MODULE,
+		.name	= "intel_mid_wdt",
+	},
+};
+
+module_platform_driver(mid_wdt_driver);
+
+MODULE_AUTHOR("David Cohen <david.a.cohen@linux.intel.com>");
+MODULE_DESCRIPTION("Watchdog Driver for Intel MID platform");
+MODULE_LICENSE("GPL");
-- 
1.9.0

