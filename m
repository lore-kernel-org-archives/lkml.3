Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933694Ab3LIPQx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 10:16:53 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:57613 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932291Ab3LIPQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 10:16:52 -0500
From: Jonas Jensen <jonas.jensen@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org, mturquette@linaro.org,
        mark.rutland@arm.com, tomasz.figa@gmail.com, adam.jaremko@gmail.com,
        sylvester.nawrocki@gmail.com, Jonas Jensen <jonas.jensen@gmail.com>
Subject: [PATCH v8] clk: add MOXA ART SoCs clock driver
Date: Mon,  9 Dec 2013 16:16:03 +0100
Message-Id: <1386602163-28479-1-git-send-email-jonas.jensen@gmail.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1381330482-13846-1-git-send-email-jonas.jensen@gmail.com>
References: <1381330482-13846-1-git-send-email-jonas.jensen@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds MOXA ART SoCs clock driver support.

Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
---

Notes:
    Thanks for the replies.
    
    As indicated by Sylwester, that it's discouraged to use hardware
    to register DT properties (multiplier-* divisor-*),
    I decided to remove them.
    
    They were only added as extra safety in cases where the
    implementation must be changed.
    Code readability is better of without them, and when something
    needs to change, it's probably better to do it directly.
    
    Changes since v7:
    
    1. remove hardware to register properties (multiplier-* divisor-*)
    2. remove redundant parentheses
    3. check clk_register_fixed_rate() return value
    
    Applies to next-20131209

 .../bindings/clock/moxa,moxart-clock.txt           |  37 +++++++
 drivers/clk/Makefile                               |   1 +
 drivers/clk/clk-moxart.c                           | 112 +++++++++++++++++++++
 3 files changed, 150 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/moxa,moxart-clock.txt
 create mode 100644 drivers/clk/clk-moxart.c

diff --git a/Documentation/devicetree/bindings/clock/moxa,moxart-clock.txt b/Documentation/devicetree/bindings/clock/moxa,moxart-clock.txt
new file mode 100644
index 0000000..bc59ceb
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/moxa,moxart-clock.txt
@@ -0,0 +1,37 @@
+Device Tree Clock bindings for arch-moxart
+
+This binding uses the common clock binding[1].
+
+[1] Documentation/devicetree/bindings/clock/clock-bindings.txt
+
+MOXA ART SoCs allow to determine PLL output and APB frequencies
+by reading registers holding multiplier and divisor information.
+
+Required properties:
+- compatible : Must be "moxa,moxart-pll-clock" or "moxa,moxart-apb-clock"
+- #clock-cells : Should be 0
+- reg : Should contain registers location and length
+- clocks : Should contain phandle to parent clock
+
+Optional properties for "moxa,moxart-pll-clock":
+- clock-output-names : Should contain clock name
+
+Optional properties for "moxa,moxart-apb-clock":
+- clock-output-names : Should contain clock name
+
+
+For example:
+
+	clk_pll: clk_pll@98100000 {
+		compatible = "moxa,moxart-pll-clock";
+		#clock-cells = <0>;
+		reg = <0x98100000 0x34>;
+		clocks = <&ref12>;
+	};
+
+	clk_apb: clk_apb@98100000 {
+		compatible = "moxa,moxart-apb-clock";
+		#clock-cells = <0>;
+		reg = <0x98100000 0x34>;
+		clocks = <&pll0>;
+	};
diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index ace7309..f07eb3b 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -12,6 +12,7 @@ obj-$(CONFIG_COMMON_CLK)	+= clk-composite.o
 # SoCs specific
 obj-$(CONFIG_ARCH_BCM2835)	+= clk-bcm2835.o
 obj-$(CONFIG_ARCH_EFM32)	+= clk-efm32gg.o
+obj-$(CONFIG_ARCH_MOXART)	+= clk-moxart.o
 obj-$(CONFIG_ARCH_NOMADIK)	+= clk-nomadik.o
 obj-$(CONFIG_ARCH_HIGHBANK)	+= clk-highbank.o
 obj-$(CONFIG_ARCH_NSPIRE)	+= clk-nspire.o
diff --git a/drivers/clk/clk-moxart.c b/drivers/clk/clk-moxart.c
new file mode 100644
index 0000000..f0436a3
--- /dev/null
+++ b/drivers/clk/clk-moxart.c
@@ -0,0 +1,112 @@
+/*
+ * MOXA ART SoCs clock driver.
+ *
+ * Copyright (C) 2013 Jonas Jensen
+ *
+ * Jonas Jensen <jonas.jensen@gmail.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/clk-provider.h>
+#include <linux/io.h>
+#include <linux/of_address.h>
+#include <linux/clkdev.h>
+
+void __init moxart_of_pll_clk_init(struct device_node *node)
+{
+	static void __iomem *base;
+	struct clk *clk, *ref_clk;
+	unsigned long rate;
+	unsigned int mul;
+	const char *name = node->name;
+
+	of_property_read_string(node, "clock-output-names", &name);
+
+	base = of_iomap(node, 0);
+	if (!base) {
+		pr_err("%s: of_iomap failed\n", node->full_name);
+		return;
+	}
+
+	mul = readl(base + 0x30) >> 3 & 0x3f;
+	iounmap(base);
+
+	ref_clk = of_clk_get(node, 0);
+	if (IS_ERR(ref_clk)) {
+		pr_err("%s: of_clk_get failed\n", node->full_name);
+		return;
+	}
+
+	rate = mul * clk_get_rate(ref_clk);
+
+	clk = clk_register_fixed_rate(NULL, name, NULL, CLK_IS_ROOT, rate);
+	if (IS_ERR(clk)) {
+		pr_err("%s: clk_register_fixed_rate failed\n", node->full_name);
+		return;
+	}
+
+	clk_register_clkdev(clk, NULL, name);
+	of_clk_add_provider(node, of_clk_src_simple_get, clk);
+}
+CLK_OF_DECLARE(moxart_pll_clock, "moxa,moxart-pll-clock",
+	       moxart_of_pll_clk_init);
+
+void __init moxart_of_apb_clk_init(struct device_node *node)
+{
+	static void __iomem *base;
+	struct clk *clk, *pll_clk;
+	unsigned long rate;
+	unsigned int div, val;
+	const char *name = node->name;
+
+	of_property_read_string(node, "clock-output-names", &name);
+
+	base = of_iomap(node, 0);
+	if (!base) {
+		pr_err("%s: of_iomap failed\n", node->full_name);
+		return;
+	}
+
+	val = readl(base + 0xc) >> 4 & 0x7;
+	iounmap(base);
+
+	switch (val) {
+	case 1:
+		div = 3;
+		break;
+	case 2:
+		div = 4;
+		break;
+	case 3:
+		div = 6;
+		break;
+	case 4:
+		div = 8;
+		break;
+	default:
+		div = 2;
+		break;
+	}
+
+	pll_clk = of_clk_get(node, 0);
+	if (IS_ERR(pll_clk)) {
+		pr_err("%s: of_clk_get failed\n", node->full_name);
+		return;
+	}
+
+	rate = clk_get_rate(pll_clk) / (div * 2);
+
+	clk = clk_register_fixed_rate(NULL, name, NULL, CLK_IS_ROOT, rate);
+	if (IS_ERR(clk)) {
+		pr_err("%s: clk_register_fixed_rate failed\n", node->full_name);
+		return;
+	}
+
+	clk_register_clkdev(clk, NULL, name);
+	of_clk_add_provider(node, of_clk_src_simple_get, clk);
+}
+CLK_OF_DECLARE(moxart_apb_clock, "moxa,moxart-apb-clock",
+	       moxart_of_apb_clk_init);
-- 
1.8.2.1

