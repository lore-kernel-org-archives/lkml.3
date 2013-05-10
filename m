Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757789Ab3EJRcE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 13:32:04 -0400
Received: from mail-da0-f43.google.com ([209.85.210.43]:63533 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757538Ab3EJRcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 13:32:00 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH RFC] clk: Introduce userspace clock driver
Date: Fri, 10 May 2013 10:31:31 -0700
Message-Id: <1368207091-32538-2-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <1368207091-32538-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1368207091-32538-1-git-send-email-soren.brinkmann@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The userspace clock driver can be used to expose clock controls through
sysfs to userspace. The driver creates entries in /sys/class/clk.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 .../devicetree/bindings/clock/clk-userspace.txt    |   7 +
 drivers/clk/Kconfig                                |   9 ++
 drivers/clk/Makefile                               |   1 +
 drivers/clk/clk-userspace.c                        | 169 +++++++++++++++++++++
 4 files changed, 186 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/clk-userspace.txt
 create mode 100644 drivers/clk/clk-userspace.c

diff --git a/Documentation/devicetree/bindings/clock/clk-userspace.txt b/Documentation/devicetree/bindings/clock/clk-userspace.txt
new file mode 100644
index 0000000..2d153c7
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/clk-userspace.txt
@@ -0,0 +1,7 @@
+
+Example:
+	usclk: usclk {
+		compatible = "clk-userspace";
+		clocks = <&foo 15>, <&bar>;
+		clock-count = <2>;
+	};
diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index 0357ac4..b35b62c 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -81,6 +81,15 @@ config COMMON_CLK_AXI_CLKGEN
 	  Support for the Analog Devices axi-clkgen pcore clock generator for Xilinx
 	  FPGAs. It is commonly used in Analog Devices' reference designs.
 
+config COMMON_CLK_USERSPACE
+	bool "Userspace Clock Controls"
+	depends on OF
+	depends on SYSFS
+	help
+	---help---
+	  Expose clock controls through sysfs to userspace. Clocks are selected
+	  through the device tree and the controls are exposed in
+	  /sys/class/clk.
 endmenu
 
 source "drivers/clk/mvebu/Kconfig"
diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index fa435bc..f2f68c8 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -8,6 +8,7 @@ obj-$(CONFIG_COMMON_CLK)	+= clk-fixed-rate.o
 obj-$(CONFIG_COMMON_CLK)	+= clk-gate.o
 obj-$(CONFIG_COMMON_CLK)	+= clk-mux.o
 obj-$(CONFIG_COMMON_CLK)	+= clk-composite.o
+obj-$(CONFIG_COMMON_CLK_USERSPACE) += clk-userspace.o
 
 # SoCs specific
 obj-$(CONFIG_ARCH_BCM2835)	+= clk-bcm2835.o
diff --git a/drivers/clk/clk-userspace.c b/drivers/clk/clk-userspace.c
new file mode 100644
index 0000000..931cf92
--- /dev/null
+++ b/drivers/clk/clk-userspace.c
@@ -0,0 +1,169 @@
+/*
+ * Userspace clock driver
+ *
+ *  Copyright (C) 2013 Xilinx
+ *
+ *  Sören Brinkmann <soren.brinkmann@xilinx.com>
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License v2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ * Expose clock controls through sysfs to userspace.
+ *
+ * By writing 0/1 to 'enable' the clock can be disabled/enabled. Reading
+ * that file returns the current state - 0 = disabled, 1 = enabled.
+ *
+ * Reading 'set_rate' returns the current clock frequency in Hz. Writing
+ * the file requests setting a new frequency in Hz.
+ */
+
+#include <linux/clk-provider.h>
+#include <linux/fs.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/device.h>
+#include <linux/slab.h>
+
+#define DRIVER_NAME	"clk-userspace"
+
+struct usclk_data {
+	struct clk *clk;
+	int enabled;
+};
+
+static ssize_t enable_show(struct device *dev, struct device_attribute *attr,
+		char *buf)
+{
+	struct usclk_data *pdata = dev_get_drvdata(dev);
+
+	return scnprintf(buf, PAGE_SIZE, "%u\n", pdata->enabled);
+}
+
+static ssize_t enable_store(struct device *dev, struct device_attribute *attr,
+		const char *buf, size_t count)
+{
+	unsigned long enable;
+	int ret;
+	struct usclk_data *pdata = dev_get_drvdata(dev);
+
+	ret = kstrtoul(buf, 0, &enable);
+	if (ret)
+		return -EINVAL;
+
+	enable = !!enable;
+	if (enable == pdata->enabled)
+		return count;
+
+	if (enable)
+		ret = clk_prepare_enable(pdata->clk);
+	else
+		clk_disable_unprepare(pdata->clk);
+
+	if (ret)
+		return -EBUSY;
+
+	pdata->enabled = enable;
+	return count;
+}
+
+static DEVICE_ATTR(enable, 0644, enable_show, enable_store);
+
+static ssize_t set_rate_show(struct device *dev, struct device_attribute *attr,
+		char *buf)
+{
+	struct usclk_data *pdata = dev_get_drvdata(dev);
+
+	return scnprintf(buf, PAGE_SIZE, "%lu\n", clk_get_rate(pdata->clk));
+}
+
+static ssize_t set_rate_store(struct device *dev, struct device_attribute *attr,
+		const char *buf, size_t count)
+{
+	int ret = 0;
+	unsigned long rate;
+	struct usclk_data *pdata = dev_get_drvdata(dev);
+
+	ret = kstrtoul(buf, 0, &rate);
+	if (ret)
+		return -EINVAL;
+
+	rate = clk_round_rate(pdata->clk, rate);
+	ret = clk_set_rate(pdata->clk, rate);
+	if (ret)
+		return -EBUSY;
+
+	return count;
+}
+
+static DEVICE_ATTR(set_rate, 0644, set_rate_show, set_rate_store);
+
+static const struct attribute *usclk_attrs[] = {
+	&dev_attr_enable.attr,
+	&dev_attr_set_rate.attr,
+	NULL
+};
+
+static const struct attribute_group usclk_attr_grp = {
+	.attrs = (struct attribute **)usclk_attrs,
+};
+
+static int usclk_setup(void)
+{
+	int ret;
+	int i;
+	struct usclk_data *pdata;
+	u32 clock_count;
+	struct class *clk_class;
+	struct device *dev;
+	struct device_node *np = of_find_compatible_node(NULL, NULL,
+			"clk-userspace");
+
+	ret = of_property_read_u32(np, "clock-count", &clock_count);
+	if (ret || !clock_count)
+		return ret;
+
+	pdata = kzalloc(clock_count * sizeof(*pdata), GFP_KERNEL);
+	if (!pdata)
+		return -ENOMEM;
+
+	clk_class = class_create(THIS_MODULE, "clk");
+	if (!clk_class) {
+		pr_err("unable to create class\n");
+		goto err_free;
+	}
+
+	for (i = 0; i < clock_count; i++) {
+		pdata[i].clk = of_clk_get(np, i);
+		if (IS_ERR(pdata[i].clk)) {
+			pr_warn("input clock #%u not found\n", i);
+			continue;
+		}
+
+		dev = device_create(clk_class, NULL, MKDEV(0, 0), NULL,
+				of_clk_get_parent_name(np, i));
+		if (!dev) {
+			pr_warn("unable to create device #%d\n", i);
+			continue;
+		}
+
+		dev_set_drvdata(dev, &pdata[i]);
+		sysfs_create_group(&dev->kobj, &usclk_attr_grp);
+	}
+
+	return 0;
+
+err_free:
+	kfree(pdata);
+
+	return ret;
+}
+late_initcall(usclk_setup);
-- 
1.8.2.3

