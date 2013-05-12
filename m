Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092Ab3ELEXx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 00:23:53 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:52815 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab3ELEXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 00:23:48 -0400
From: Daniel Tang <dt.tangr@gmail.com>
To: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk
Cc: Daniel Tang <dt.tangr@gmail.com>, Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "fabian@ritter-vogt.de Vogt" <fabian@ritter-vogt.de>,
        Lionel Debroux <lionel_debroux@yahoo.fr>, linux-kernel@vger.kernel.org
Subject: [RFC PATCHv3 3/6] clk: Add TI-Nspire clock drivers
Date: Sun, 12 May 2013 14:22:58 +1000
Message-Id: <1368332581-94691-4-git-send-email-dt.tangr@gmail.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1368332581-94691-1-git-send-email-dt.tangr@gmail.com>
References: <1368332581-94691-1-git-send-email-dt.tangr@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Daniel Tang <dt.tangr@gmail.com>
---
 drivers/clk/Makefile     |   1 +
 drivers/clk/clk-nspire.c | 141 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 142 insertions(+)
 create mode 100644 drivers/clk/clk-nspire.c

diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index 137d3e7..72ebbe1 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -13,6 +13,7 @@ obj-$(CONFIG_COMMON_CLK)	+= clk-composite.o
 obj-$(CONFIG_ARCH_BCM2835)	+= clk-bcm2835.o
 obj-$(CONFIG_ARCH_NOMADIK)	+= clk-nomadik.o
 obj-$(CONFIG_ARCH_HIGHBANK)	+= clk-highbank.o
+obj-$(CONFIG_ARCH_NSPIRE)	+= clk-nspire.o
 obj-$(CONFIG_ARCH_MXS)		+= mxs/
 obj-$(CONFIG_ARCH_SOCFPGA)	+= socfpga/
 obj-$(CONFIG_PLAT_SPEAR)	+= spear/
diff --git a/drivers/clk/clk-nspire.c b/drivers/clk/clk-nspire.c
new file mode 100644
index 0000000..2a8d14c
--- /dev/null
+++ b/drivers/clk/clk-nspire.c
@@ -0,0 +1,141 @@
+/*
+ *  linux/drivers/clk/clk-nspire.c
+ *
+ *  Copyright (C) 2013 Daniel Tang <tangrs@tangrs.id.au>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/clk-provider.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+
+#define MHZ (1000 * 1000)
+
+#define BASE_CPU_SHIFT		1
+#define BASE_CPU_MASK		0x7F
+
+#define CPU_AHB_SHIFT		12
+#define CPU_AHB_MASK		0x07
+
+#define FIXED_BASE_SHIFT	8
+#define FIXED_BASE_MASK		0x01
+
+#define CLASSIC_BASE_SHIFT	16
+#define CLASSIC_BASE_MASK	0x1F
+
+#define CX_BASE_SHIFT		15
+#define CX_BASE_MASK		0x3F
+
+#define CX_UNKNOWN_SHIFT	21
+#define CX_UNKNOWN_MASK		0x03
+
+#define EXTRACT(var, prop) (((var)>>prop##_SHIFT) & prop##_MASK)
+
+struct nspire_clk_info {
+	u32 base_clock;
+	u16 base_cpu_ratio;
+	u16 base_ahb_ratio;
+};
+
+static int nspire_clk_read(struct device_node *node,
+		struct nspire_clk_info *clk)
+{
+	u32 val;
+	int ret;
+	void __iomem *io;
+	const char *type = NULL;
+
+	ret = of_property_read_string(node, "io-type", &type);
+	if (ret)
+		return ret;
+
+	io = of_iomap(node, 0);
+	if (!io)
+		return -ENOMEM;
+	val = readl(io);
+	iounmap(io);
+
+	if (!strcmp(type, "cx")) {
+		if (EXTRACT(val, FIXED_BASE)) {
+			clk->base_clock = 48 * MHZ;
+		} else {
+			clk->base_clock = 6 * EXTRACT(val, CX_BASE) * MHZ;
+		}
+
+		clk->base_cpu_ratio = EXTRACT(val, BASE_CPU) *
+					EXTRACT(val, CX_UNKNOWN);
+		clk->base_ahb_ratio = clk->base_cpu_ratio *
+					(EXTRACT(val, CPU_AHB) + 1);
+	} else if (!strcmp(type, "classic")) {
+		if (EXTRACT(val, FIXED_BASE)) {
+			clk->base_clock = 27 * MHZ;
+		} else {
+			clk->base_clock = (300 -
+					6 * EXTRACT(val, CLASSIC_BASE)) * MHZ;
+		}
+
+		clk->base_cpu_ratio = EXTRACT(val, BASE_CPU) * 2;
+		clk->base_ahb_ratio = clk->base_cpu_ratio *
+					(EXTRACT(val, CPU_AHB) + 1);
+	} else {
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static void __init nspire_ahbdiv_setup(struct device_node *node)
+{
+	int ret;
+	struct clk *clk;
+	const char *clk_name = node->name;
+	const char *parent_name;
+	struct nspire_clk_info info;
+
+	ret = nspire_clk_read(node, &info);
+	if (WARN_ON(ret))
+		return;
+
+	of_property_read_string(node, "clock-output-names", &clk_name);
+	parent_name = of_clk_get_parent_name(node, 0);
+
+	clk = clk_register_fixed_factor(NULL, clk_name, parent_name, 0,
+					1, info.base_ahb_ratio);
+	if (!IS_ERR(clk))
+		of_clk_add_provider(node, of_clk_src_simple_get, clk);
+}
+
+static void __init nspire_clk_setup(struct device_node *node)
+{
+	int ret;
+	struct clk *clk;
+	const char *clk_name = node->name;
+	struct nspire_clk_info info;
+
+	ret = nspire_clk_read(node, &info);
+	if (WARN_ON(ret))
+		return;
+
+	of_property_read_string(node, "clock-output-names", &clk_name);
+
+	clk = clk_register_fixed_rate(NULL, clk_name, NULL, CLK_IS_ROOT,
+			info.base_clock);
+	if (!IS_ERR(clk))
+		of_clk_add_provider(node, of_clk_src_simple_get, clk);
+	else
+		return;
+
+	pr_info("TI-NSPIRE Base: %uMHz CPU: %uMHz AHB: %uMHz\n",
+		info.base_clock / MHZ,
+		info.base_clock / info.base_cpu_ratio / MHZ,
+		info.base_clock / info.base_ahb_ratio / MHZ);
+}
+
+CLK_OF_DECLARE(nspire_clk, "nspire-clock", nspire_clk_setup);
+CLK_OF_DECLARE(nspire_ahbdiv, "nspire-ahb-divider", nspire_ahbdiv_setup);
-- 
1.8.1.3

