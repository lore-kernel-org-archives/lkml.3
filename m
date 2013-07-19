Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759965Ab3GSIR4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 04:17:56 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:56221 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab3GSIRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 04:17:44 -0400
From: Jonas Jensen <jonas.jensen@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org, mturquette@linaro.org,
        mark.rutland@arm.com, Jonas Jensen <jonas.jensen@gmail.com>
Subject: [PATCH v5] clk: add MOXA ART SoCs clock driver
Date: Fri, 19 Jul 2013 10:17:17 +0200
Message-Id: <1374221837-23773-1-git-send-email-jonas.jensen@gmail.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1374221278-18204-1-git-send-email-jonas.jensen@gmail.com>
References: <1374221278-18204-1-git-send-email-jonas.jensen@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds MOXA ART SoCs clock driver support.

Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
---

Notes:
    Changes since v4:
    
    1. remove unnecessary header includes
    
    Applies to next-20130716

 .../bindings/clock/moxa,moxart-core-clock.txt      | 23 ++++++++
 drivers/clk/Makefile                               |  1 +
 drivers/clk/clk-moxart.c                           | 69 ++++++++++++++++++++++
 3 files changed, 93 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/moxa,moxart-core-clock.txt
 create mode 100644 drivers/clk/clk-moxart.c

diff --git a/Documentation/devicetree/bindings/clock/moxa,moxart-core-clock.txt b/Documentation/devicetree/bindings/clock/moxa,moxart-core-clock.txt
new file mode 100644
index 0000000..528c8b0
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/moxa,moxart-core-clock.txt
@@ -0,0 +1,23 @@
+Device Tree Clock bindings for arch-moxart
+
+This binding uses the common clock binding[1].
+
+[1] Documentation/devicetree/bindings/clock/clock-bindings.txt
+
+MOXA ART SoCs allow to determine core clock frequencies by reading
+a register.
+
+Required properties:
+- compatible : Should be "moxa,moxart-core-clock"
+- #clock-cells : Should be 0
+- reg : Should contain registers location and length
+- clock-output-names : Should be "coreclk"
+
+For example:
+
+	coreclk: core-clock@98100000 {
+		compatible = "moxa,moxart-core-clock";
+		#clock-cells = <0>;
+		reg = <0x98100000 0x34>;
+		clock-output-names = "coreclk";
+	};
diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index 4038c2b..933622f 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -11,6 +11,7 @@ obj-$(CONFIG_COMMON_CLK)	+= clk-composite.o
 
 # SoCs specific
 obj-$(CONFIG_ARCH_BCM2835)	+= clk-bcm2835.o
+obj-$(CONFIG_ARCH_MOXART)	+= clk-moxart.o
 obj-$(CONFIG_ARCH_NOMADIK)	+= clk-nomadik.o
 obj-$(CONFIG_ARCH_HIGHBANK)	+= clk-highbank.o
 obj-$(CONFIG_ARCH_NSPIRE)	+= clk-nspire.o
diff --git a/drivers/clk/clk-moxart.c b/drivers/clk/clk-moxart.c
new file mode 100644
index 0000000..5559371
--- /dev/null
+++ b/drivers/clk/clk-moxart.c
@@ -0,0 +1,69 @@
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
+void __init moxart_of_clk_init(struct device_node *node)
+{
+	static void __iomem *base;
+	struct clk *clk;
+	unsigned long rate;
+	unsigned int mul, val, div;
+	const char *name;
+
+	base = of_iomap(node, 0);
+	if (IS_ERR(base))
+		panic("%s: of_iomap failed\n", node->full_name);
+
+	mul = (readl(base + 0x30) >> 3) & 0x1ff;
+	val = (readl(base + 0x0c) >> 4) & 0x7;
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
+	/*
+	 * the rate calculation below is only tested and proven
+	 * to be true for UC-7112-LX
+	 *
+	 * UC-7112-LX: mul=80 val=0
+	 *
+	 * to support other moxart SoC hardware, this may need
+	 * a change, though it's possible it works there too
+	 */
+	rate = (mul * 1200000 / div);
+
+	of_property_read_string(node, "clock-output-names", &name);
+	clk = clk_register_fixed_rate(NULL, name, NULL, CLK_IS_ROOT, rate);
+	clk_register_clkdev(clk, NULL, name);
+	of_clk_add_provider(node, of_clk_src_simple_get, clk);
+
+	iounmap(base);
+}
+CLK_OF_DECLARE(moxart_core_clock, "moxa,moxart-core-clock", moxart_of_clk_init);
-- 
1.8.2.1

