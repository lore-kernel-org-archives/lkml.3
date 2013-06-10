Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048Ab3FJJZJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 05:25:09 -0400
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:47575 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752511Ab3FJJZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 05:25:06 -0400
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, linux@arm.linux.org.uk,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Olof Johansson <olof@lixom.net>, Rob Herring <rob.herring@calxeda.com>,
        Rob Landley <rob@landley.net>, Samuel Ortiz <sameo@linux.intel.com>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Stephen Gallimore <stephen.gallimore@st.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCH v2 04/11] mfd:stixxxx-syscfg: Add ST System Configuration support.
Date: Mon, 10 Jun 2013 10:22:27 +0100
Message-Id: <1370856147-6552-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1370855828-5318-1-git-send-email-srinivas.kandagatla@st.com>
References: <1370855828-5318-1-git-send-email-srinivas.kandagatla@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

System configuration(aka syscfg) registers are very basic configuration
registers arranged in groups across ST Settop Box parts.

The SOCs are assembled from existing IP blocks, which don't change very
often. However these blocks are assembled in different configurations to
meet the device requirements. So most IP blocks as well as having a bus
interface through which their own registers are accessible, will also
have a number of bristles(wires) which are signals that are going in and
out of the IP for configuration and status. To make these signals
accessible to software they are wired to "System Configuration
Registers".

Drivers target the IP blocks, which don't change much. Where as the
mapping of IP specific bristles(wires) to "System Configuration
Registers" do change per each SOC, and therefore we do not want this
information to be part of the driver.

Having a System Configuration infrastructure gives much flexibility and
abstraction to drivers to configure them. Typically in a SOC there will
be more than hundreds of these registers, which are again divided into
groups. The IP related config registers tend to much regular in latest
ST SOCs, so having a common place for configuring these registers makes
sense and avoid lot of code duplication.

This mfd driver provides higher level inialization routines for various
IPs like Ethernet, USB, PCIE, SATA and so on. Also it provides way to
get to syscfg registers via standard regmap api which is usefull for
drivers like pinctrl.

This patch adds support to ST System Configuration registers, which can
be configured by the drivers.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
CC: Stuart Menefy <stuart.menefy@st.com>
CC: Stephen Gallimore <stephen.gallimore@st.com>
CC: Linus Walleij <linus.walleij@linaro.org>
CC: Mark Brown <broonie@kernel.org>
---
 .../devicetree/bindings/mfd/stixxxx-syscfg.txt     |   18 ++
 drivers/mfd/Kconfig                                |   10 ++
 drivers/mfd/Makefile                               |    1 +
 drivers/mfd/stixxxx-syscfg.c                       |  168 ++++++++++++++++++++
 include/linux/mfd/stixxxx-syscfg.h                 |   15 ++
 5 files changed, 212 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/stixxxx-syscfg.txt
 create mode 100644 drivers/mfd/stixxxx-syscfg.c
 create mode 100644 include/linux/mfd/stixxxx-syscfg.h

diff --git a/Documentation/devicetree/bindings/mfd/stixxxx-syscfg.txt b/Documentation/devicetree/bindings/mfd/stixxxx-syscfg.txt
new file mode 100644
index 0000000..428c751
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/stixxxx-syscfg.txt
@@ -0,0 +1,18 @@
+*STixxxx SYSCFG
+
+- compatible : should be "st,<SOC>-syscfg" like "st,stih415-syscfg"
+			or "st,stih416-syscfg".
+- reg, reg-names, interrupts, interrupt-names	: Standard way to define device
+			resources with names. look in
+			Documentation/devicetree/bindings/resource-names.txt
+- syscfg-range <start size> : Should be syscfg number range for this bank.
+- syscfg-name		    : Should be name of the syscfg, will be used in debugfs.
+
+Example of a SBC_SYSCFG bank node:
+
+syscfg_sbc: syscfg@fe600000{
+	compatible      = "st,stih415-syscfg";
+	reg		= <0xfe600000 0xb4>;
+	syscfg-range	= <0 44>;
+	syscfg-name	= "SYSCFG_SBC";
+};
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index d54e985..af49b58 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -649,6 +649,16 @@ config MFD_STA2X11
 	select MFD_CORE
 	select REGMAP_MMIO
 
+config MFD_STIXXXX_SYSCFG
+	bool "ST System Configuration Registers(aka syscfg) via regmap"
+	select REGMAP_MMIO
+	help
+	  Select this option to enable accessing STMicroelectronics
+	  System Configuration Registers via standard regmap apis with
+	  lookup helper functions.
+
+	  If unsure, say N.
+
 config MFD_SYSCON
 	bool "System Controller Register R/W Based on Regmap"
 	select REGMAP_MMIO
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 718e94a..c1f6570 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -150,6 +150,7 @@ obj-$(CONFIG_MFD_PALMAS)	+= palmas.o
 obj-$(CONFIG_MFD_VIPERBOARD)    += viperboard.o
 obj-$(CONFIG_MFD_RC5T583)	+= rc5t583.o rc5t583-irq.o
 obj-$(CONFIG_MFD_SEC_CORE)	+= sec-core.o sec-irq.o
+obj-$(CONFIG_MFD_STIXXXX_SYSCFG)	+= stixxxx-syscfg.o
 obj-$(CONFIG_MFD_SYSCON)	+= syscon.o
 obj-$(CONFIG_MFD_LM3533)	+= lm3533-core.o lm3533-ctrlbank.o
 obj-$(CONFIG_VEXPRESS_CONFIG)	+= vexpress-config.o vexpress-sysreg.o
diff --git a/drivers/mfd/stixxxx-syscfg.c b/drivers/mfd/stixxxx-syscfg.c
new file mode 100644
index 0000000..10ea4e4
--- /dev/null
+++ b/drivers/mfd/stixxxx-syscfg.c
@@ -0,0 +1,168 @@
+/*
+ * Copyright (C) 2013 STMicroelectronics Limited
+ * Author: Srinivas Kandagatla <srinivas.kandagatla@st.com>
+ *
+ * May be copied or modified under the terms of the GNU General Public
+ * License.  See linux/COPYING for more information.
+ *
+ * Syscfg driver is used to configure various devices like Ethernet,
+ * USB, PCIE, SATA and so on.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/io.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/platform_device.h>
+#include <linux/types.h>
+#include <linux/delay.h>
+#include <linux/slab.h>
+#include <linux/regmap.h>
+#include <linux/mfd/stixxxx-syscfg.h>
+
+#define DRIVER_NAME "stixxxx-syscfg"
+
+static struct platform_driver syscfg_driver;
+struct syscfg {
+	void __iomem *base;
+	struct regmap *regmap;
+	int	start, end;
+	const char *name;
+	struct device_node *of_node;
+};
+
+static int syscfg_match_name(struct device *dev, void *data)
+{
+	struct syscfg *syscfg = dev_get_drvdata(dev);
+
+	if (syscfg)
+		if (!strcmp(syscfg->name, (const char *)data))
+			return 1;
+	return 0;
+}
+
+struct regmap *syscfg_regmap_lookup_by_name(const char *name)
+{
+	struct syscfg *syscfg;
+	struct device *dev;
+
+	dev = driver_find_device(&syscfg_driver.driver, NULL, (void *)name,
+				 syscfg_match_name);
+	if (!dev)
+		return ERR_PTR(-EPROBE_DEFER);
+
+	syscfg = dev_get_drvdata(dev);
+
+	return syscfg->regmap;
+}
+
+static int syscfg_match_node(struct device *dev, void *data)
+{
+	struct device_node *dn = data;
+
+	return (dev->of_node == dn) ? 1 : 0;
+}
+
+struct regmap *syscfg_node_to_regmap(struct device_node *np)
+{
+	struct syscfg *syscfg;
+	struct device *dev;
+
+	dev = driver_find_device(&syscfg_driver.driver, NULL, np,
+				 syscfg_match_node);
+	if (!dev)
+		return ERR_PTR(-EPROBE_DEFER);
+
+	syscfg = dev_get_drvdata(dev);
+
+	return syscfg->regmap;
+}
+EXPORT_SYMBOL_GPL(syscfg_node_to_regmap);
+
+struct regmap *syscfg_regmap_lookup_by_phandle(struct device_node *np,
+					const char *property)
+{
+	struct device_node *syscfg_np;
+	struct regmap *regmap;
+
+	syscfg_np = of_parse_phandle(np, property, 0);
+	if (!syscfg_np)
+		return ERR_PTR(-ENODEV);
+
+	regmap = syscfg_node_to_regmap(syscfg_np);
+	of_node_put(syscfg_np);
+
+	return regmap;
+}
+EXPORT_SYMBOL_GPL(syscfg_regmap_lookup_by_phandle);
+
+static struct regmap_config syscfg_regmap_config = {
+	.reg_bits = 32,
+	.val_bits = 32,
+	.reg_stride = 4,
+};
+
+static int syscfg_probe(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	struct syscfg *syscfg;
+	struct resource *res;
+	u32 range[2];
+
+	if (!np)
+		return -EINVAL;
+
+	syscfg = devm_kzalloc(&pdev->dev, sizeof(*syscfg), GFP_KERNEL);
+	if (!syscfg)
+		return -ENOMEM;
+
+	syscfg->of_node = np;
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	syscfg->base = devm_request_and_ioremap(&pdev->dev, res);
+	if (!syscfg->base) {
+		dev_err(&pdev->dev, "Unable to ioremap registers|\n");
+		return -ENODATA;
+	}
+
+	of_property_read_u32_array(np, "syscfg-range", (u32 *)&range, 2);
+	syscfg->start = range[0];
+	syscfg->end = range[0] + range[1];
+	of_property_read_string(np, "syscfg-name", &syscfg->name);
+
+	syscfg_regmap_config.name = kasprintf(GFP_KERNEL, "%s", syscfg->name);
+	syscfg_regmap_config.max_register = res->end - res->start - 3;
+	syscfg->regmap = devm_regmap_init_mmio(&pdev->dev, syscfg->base,
+					&syscfg_regmap_config);
+	if (IS_ERR(syscfg->regmap)) {
+		dev_err(&pdev->dev, "regmap init failed\n");
+		return PTR_ERR(syscfg->regmap);
+	}
+
+	platform_set_drvdata(pdev, syscfg);
+	dev_info(&pdev->dev,
+		"%s[%d - %d] sucessfully intialized\n",
+		syscfg->name, syscfg->start, syscfg->end);
+	return 0;
+}
+
+static struct of_device_id syscfg_match[] = {
+	{ .compatible = "st,stih415-syscfg", },
+	{ .compatible = "st,stih416-syscfg", },
+	{},
+};
+
+static struct platform_driver syscfg_driver = {
+	.probe		= syscfg_probe,
+	.driver	= {
+		.name	= DRIVER_NAME,
+		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(syscfg_match),
+	},
+};
+
+static int __init syscfg_init(void)
+{
+	return platform_driver_register(&syscfg_driver);
+}
+postcore_initcall(syscfg_init);
diff --git a/include/linux/mfd/stixxxx-syscfg.h b/include/linux/mfd/stixxxx-syscfg.h
new file mode 100644
index 0000000..18ed6da7
--- /dev/null
+++ b/include/linux/mfd/stixxxx-syscfg.h
@@ -0,0 +1,15 @@
+/*
+ * Copyright (C) 2013 STMicroelectronics R&D Limited
+ *
+ * May be copied or modified under the terms of the GNU General Public
+ * License.  See linux/COPYING for more information.
+ */
+
+#ifndef __LINUX_MFD_STIXXXX_SYSCFG_H
+#define __LINUX_MFD_STIXXXX_SYSCFG_H
+
+struct regmap *syscfg_regmap_lookup_by_phandle(struct device_node *np,
+					const char *property);
+struct regmap *syscfg_regmap_lookup_by_name(const char *name);
+
+#endif /* __LINUX_MFD_STIXXXX_SYSCFG_H */
-- 
1.7.6.5

