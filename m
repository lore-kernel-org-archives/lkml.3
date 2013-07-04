Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662Ab3GDNI1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 09:08:27 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:49599 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755321Ab3GDNIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 09:08:25 -0400
From: Jonas Jensen <jonas.jensen@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org, mturquette@linaro.org,
        Jonas Jensen <jonas.jensen@gmail.com>
Subject: [PATCH v2] clk: add MOXA ART SoCs clock driver
Date: Thu,  4 Jul 2013 15:08:12 +0200
Message-Id: <1372943292-6960-1-git-send-email-jonas.jensen@gmail.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1372341834-6557-1-git-send-email-jonas.jensen@gmail.com>
References: <1372341834-6557-1-git-send-email-jonas.jensen@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds MOXA ART SoCs clock driver support.

Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
---

Notes:
    of_clk_init(NULL) is now called from moxart machine descriptor
    .init_time hook. clocksource now depend on this to be loaded first.
    
    Applies to next-20130703
    
    Changes since v1:
    1. rewritten to register one fixed rate clock "clkapb"
    2. use CLK_OF_DECLARE

 drivers/clk/Makefile     |  1 +
 drivers/clk/clk-moxart.c | 82 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 83 insertions(+)
 create mode 100644 drivers/clk/clk-moxart.c

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
index 0000000..d61e305
--- /dev/null
+++ b/drivers/clk/clk-moxart.c
@@ -0,0 +1,82 @@
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
+#include <linux/platform_device.h>
+#include <linux/clk.h>
+#include <linux/clk-provider.h>
+#include <linux/slab.h>
+#include <linux/delay.h>
+#include <linux/module.h>
+#include <linux/io.h>
+#include <linux/of_address.h>
+#include <linux/clkdev.h>
+
+static const struct of_device_id moxart_tclk_match[] = {
+	{ .compatible = "moxa,moxart-apb-clock" },
+	{ }
+};
+
+void __init moxart_of_clk_init(struct device_node *node)
+{
+	static void __iomem *base;
+	struct device_node *clk_node;
+	struct clk *clk;
+	unsigned long rate;
+	unsigned int mul, val, div;
+
+	base = of_iomap(node, 0);
+	if (IS_ERR(base))
+		panic("%s: of_iomap failed\n", node->full_name);
+
+	clk_node = of_find_matching_node(NULL, moxart_tclk_match);
+	if (!clk_node)
+		panic("%s: can't find clock DT node\n", node->full_name);
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
+	clk = clk_register_fixed_rate(NULL, "clkapb", NULL, CLK_IS_ROOT, rate);
+	clk_register_clkdev(clk, NULL, "clkapb");
+	of_clk_add_provider(clk_node, of_clk_src_simple_get, clk);
+
+	iounmap(base);
+}
+CLK_OF_DECLARE(moxart_core_clock, "moxa,moxart-core-clock", moxart_of_clk_init);
-- 
1.8.2.1

