Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842AbaDXKN4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 06:13:56 -0400
Received: from xavier.telenet-ops.be ([195.130.132.52]:60420 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755571AbaDXKNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 06:13:46 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Magnus Damm <magnus.damm@gmail.com>, Simon Horman <horms@verge.net.au>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>, Felipe Balbi <balbi@ti.com>,
        Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-sh@vger.kernel.org,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH/RFC 3/4] of/clk: Register clocks suitable for Runtime PM with the PM core
Date: Thu, 24 Apr 2014 12:13:22 +0200
Message-Id: <1398334403-26181-4-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398334403-26181-1-git-send-email-geert+renesas@glider.be>
References: <1398334403-26181-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When adding a device from DT, check if its clocks are suitable for Runtime
PM, and register them with the PM core.
If Runtime PM is disabled, just enable the clock.

This allows the PM core to automatically manage gate clocks of devices for
Runtime PM.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/of/Makefile    |    1 +
 drivers/of/of_clk.c    |  103 ++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/of/platform.c  |    3 ++
 include/linux/of_clk.h |   18 +++++++++
 4 files changed, 125 insertions(+)
 create mode 100644 drivers/of/of_clk.c
 create mode 100644 include/linux/of_clk.h

diff --git a/drivers/of/Makefile b/drivers/of/Makefile
index ed9660adad77..49bcd413906f 100644
--- a/drivers/of/Makefile
+++ b/drivers/of/Makefile
@@ -10,3 +10,4 @@ obj-$(CONFIG_OF_PCI)	+= of_pci.o
 obj-$(CONFIG_OF_PCI_IRQ)  += of_pci_irq.o
 obj-$(CONFIG_OF_MTD)	+= of_mtd.o
 obj-$(CONFIG_OF_RESERVED_MEM) += of_reserved_mem.o
+obj-$(CONFIG_COMMON_CLK) += of_clk.o
diff --git a/drivers/of/of_clk.c b/drivers/of/of_clk.c
new file mode 100644
index 000000000000..35f5e9f3dd42
--- /dev/null
+++ b/drivers/of/of_clk.c
@@ -0,0 +1,103 @@
+/*
+ *  Copyright (C) 2014 Glider bvba
+ */
+
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/of.h>
+#include <linux/of_clk.h>
+#include <linux/platform_device.h>
+#include <linux/pm_clock.h>
+#include <linux/pm_runtime.h>
+
+
+#ifdef CONFIG_PM_RUNTIME
+
+static int of_clk_pm_runtime_suspend(struct device *dev)
+{
+	int ret;
+
+	ret = pm_generic_runtime_suspend(dev);
+	if (ret)
+		return ret;
+
+	ret = pm_clk_suspend(dev);
+	if (ret) {
+		pm_generic_runtime_resume(dev);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int of_clk_pm_runtime_resume(struct device *dev)
+{
+	pm_clk_resume(dev);
+	return pm_generic_runtime_resume(dev);
+}
+
+static struct dev_pm_domain of_clk_pm_domain = {
+	.ops = {
+		.runtime_suspend = of_clk_pm_runtime_suspend,
+		.runtime_resume = of_clk_pm_runtime_resume,
+		USE_PLATFORM_PM_SLEEP_OPS
+	},
+};
+
+static int of_clk_register(struct device *dev, struct clk *clk)
+{
+	int error;
+
+	if (!dev->pm_domain) {
+		error = pm_clk_create(dev);
+		if (error)
+			return error;
+
+		dev->pm_domain = &of_clk_pm_domain;
+	}
+
+	dev_dbg(dev, "Setting up clock for runtime PM management\n");
+	return pm_clk_add_clk(dev, clk);
+}
+
+#else /* !CONFIG_PM_RUNTIME */
+
+static int of_clk_register(struct device *dev, struct clk *clk)
+{
+	dev_dbg(dev, "Runtime PM disabled, enabling clock\n");
+	return clk_prepare_enable(clk);
+}
+
+#endif /* !CONFIG_PM_RUNTIME */
+
+
+/**
+ * of_clk_register_runtime_pm_clocks - Register clocks suitable for Runtime PM
+ *                                     with the PM core
+ * @np: pointer to device tree node
+ * @pdev: pointer to corresponding device to register suitable clocks for
+ *
+ * Returns an error code
+ */
+int of_clk_register_runtime_pm_clocks(struct device_node *np,
+				      struct device *dev)
+{
+	unsigned int i;
+	struct clk *clk;
+	int error;
+
+	for (i = 0; (clk = of_clk_get(np, i)) && !IS_ERR(clk); i++) {
+		if (!clk_may_runtime_pm(clk)) {
+			clk_put(clk);
+			continue;
+		}
+
+		error = of_clk_register(dev, clk);
+		if (error) {
+			clk_put(clk);
+			return error;
+		}
+	}
+
+	return 0;
+}
diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index 404d1daebefa..29145302b6f8 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -18,6 +18,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/slab.h>
 #include <linux/of_address.h>
+#include <linux/of_clk.h>
 #include <linux/of_device.h>
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
@@ -182,6 +183,8 @@ struct platform_device *of_device_alloc(struct device_node *np,
 	else
 		of_device_make_bus_id(&dev->dev);
 
+	of_clk_register_runtime_pm_clocks(np, &dev->dev);
+
 	return dev;
 }
 EXPORT_SYMBOL(of_device_alloc);
diff --git a/include/linux/of_clk.h b/include/linux/of_clk.h
new file mode 100644
index 000000000000..b9b15614e39b
--- /dev/null
+++ b/include/linux/of_clk.h
@@ -0,0 +1,18 @@
+#ifndef _LINUX_OF_CLK_H
+#define _LINUX_OF_CLK_H
+
+struct device_node;
+struct device;
+
+#if defined(CONFIG_OF) && defined(CONFIG_COMMON_CLK)
+int of_clk_register_runtime_pm_clocks(struct device_node *np,
+				      struct device *dev);
+#else
+static inline int of_clk_register_runtime_pm_clocks(struct device_node *np,
+						    struct device *dev)
+{
+	return 0;
+}
+#endif /* CONFIG_OF && CONFIG_COMMON_CLK */
+
+#endif /* _LINUX_OF_CLK_H */
-- 
1.7.9.5

