Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803Ab3IMAfG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 20:35:06 -0400
Received: from zetta.elopez.com.ar ([199.30.59.35]:51998 "EHLO
	zetta.elopez.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab3IMAfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 20:35:03 -0400
From: =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>
To: Mike Turquette <mturquette@linaro.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        grant.likely@linaro.org, rob.herring@calxeda.com,
        gregkh@linuxfoundation.org
Cc: <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        david.lanzendoerfer@o2s.ch, <linux-kernel@vger.kernel.org>,
        =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>
Subject: [PATCH] memory: add a basic OF-based memory driver
Date: Thu, 12 Sep 2013 21:30:25 -0300
Message-Id: <1379032225-6425-1-git-send-email-emilio@elopez.com.ar>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1378863781-4235-1-git-send-email-emilio@elopez.com.ar>
References: <1378863781-4235-1-git-send-email-emilio@elopez.com.ar>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver's only job is to claim and ensure the necessary clock
for memory operation on a DT-powered machine remains enabled.

Signed-off-by: Emilio López <emilio@elopez.com.ar>
---

I believe this new patch should resolve all the concerns raised; as
always, all feedback is welcome :)

Changes from RFC:
- Move from drivers/of to drivers/memory
- Make a proper driver instead of using an initcall
- Binding document for the new "simple-memory-controller"

 .../simple-memory-controller.txt                   | 19 ++++++++
 drivers/memory/Kconfig                             | 11 +++++
 drivers/memory/Makefile                            |  1 +
 drivers/memory/simple-mc.c                         | 57 ++++++++++++++++++++++
 4 files changed, 88 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/memory-controllers/simple-memory-controller.txt
 create mode 100644 drivers/memory/simple-mc.c

diff --git a/Documentation/devicetree/bindings/memory-controllers/simple-memory-controller.txt b/Documentation/devicetree/bindings/memory-controllers/simple-memory-controller.txt
new file mode 100644
index 0000000..d37683b
--- /dev/null
+++ b/Documentation/devicetree/bindings/memory-controllers/simple-memory-controller.txt
@@ -0,0 +1,19 @@
+Device Tree Clock binding for a simple memory controller.
+
+Required properties:
+- compatible : shall be "simple-memory-controller"
+
+Optional properties:
+- reg        : may contain the register space for the controller. This
+               property is currently ignored by the driver
+- clocks     : may contain a phandle to the clock that is currently being
+               used on the controller. This clock shall remain enabled
+               during system operation.
+
+Example:
+
+mc: mc@0123000 {
+	compatible = "simple-memory-controller";
+	reg = <0x0123000 0x400>;
+	clocks = <&pll5 1>;
+};
diff --git a/drivers/memory/Kconfig b/drivers/memory/Kconfig
index 29a11db..4a6df65 100644
--- a/drivers/memory/Kconfig
+++ b/drivers/memory/Kconfig
@@ -50,4 +50,15 @@ config TEGRA30_MC
 	  analysis, especially for IOMMU/SMMU(System Memory Management
 	  Unit) module.
 
+config SIMPLE_MC
+	bool "Simple memory controller"
+	default y
+	depends on OF && COMMON_CLK
+	help
+	  This driver is able to manage a simple memory controller whose
+	  only needs consist of keeping one clock enabled. The
+	  controller must be defined on the device tree as compatible
+	  with "simple-memory-controller"; see the corresponding binding
+	  document for more details.
+
 endif
diff --git a/drivers/memory/Makefile b/drivers/memory/Makefile
index 969d923..e0953e5 100644
--- a/drivers/memory/Makefile
+++ b/drivers/memory/Makefile
@@ -9,3 +9,4 @@ obj-$(CONFIG_TI_EMIF)		+= emif.o
 obj-$(CONFIG_MVEBU_DEVBUS)	+= mvebu-devbus.o
 obj-$(CONFIG_TEGRA20_MC)	+= tegra20-mc.o
 obj-$(CONFIG_TEGRA30_MC)	+= tegra30-mc.o
+obj-$(CONFIG_SIMPLE_MC)		+= simple-mc.o
diff --git a/drivers/memory/simple-mc.c b/drivers/memory/simple-mc.c
new file mode 100644
index 0000000..e58371d
--- /dev/null
+++ b/drivers/memory/simple-mc.c
@@ -0,0 +1,57 @@
+/*
+ * Simple memory controller driver
+ *
+ * Copyright 2013 Emilio López <emilio@elopez.com.ar>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/of.h>
+#include <linux/clk.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+
+static int simple_mc_probe(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	struct clk *clk;
+
+	if (!np)
+		return -ENODEV;
+
+	clk = of_clk_get(np, 0);
+	if (!IS_ERR(clk)) {
+		clk_prepare_enable(clk);
+		clk_put(clk);
+	}
+
+	return 0;
+}
+
+static const struct of_device_id simple_mc_of_match[] = {
+	{ .compatible = "simple-memory-controller", },
+	{ /* sentinel */ },
+};
+
+static struct platform_driver simple_mc_driver = {
+	.probe = simple_mc_probe,
+	.driver = {
+		.name = "simple-mc",
+		.owner = THIS_MODULE,
+		.of_match_table = of_match_ptr(simple_mc_of_match),
+	},
+};
+
+module_platform_driver(simple_mc_driver);
+
+MODULE_AUTHOR("Emilio López <emilio@elopez.com.ar>");
+MODULE_DESCRIPTION("Simple memory controller driver");
+MODULE_LICENSE("GPL");
-- 
1.8.4

