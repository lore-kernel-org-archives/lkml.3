Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933327AbaKSXQa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 18:16:30 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:60683 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933304AbaKSXQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 18:16:25 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mike Turquette <mturquette@linaro.org>, linux-metag@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 14/15] clk: tz1090: add divider clock driver
Date: Wed, 19 Nov 2014 23:15:42 +0000
Message-Id: <1416438943-11429-15-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1416438943-11429-1-git-send-email-james.hogan@imgtec.com>
References: <1416438943-11429-1-git-send-email-james.hogan@imgtec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add driver for TZ1090 clock divider, which divides an input clock by an
integer.

Two policy decisions are made depending on the MMIO address of the
divider:
- The UART clock divider sets CLK_SET_RATE_PARENT so that clock changes
  can propagate up to the CLK_UART_SW mux which allows more precision to
  be achieved.
- The Meta clock divider sets CLK_DIVIDER_READ_ONLY to prevent it being
  changed dynamically. This is normally set by the bootloader along with
  the system PLL and has a whole bunch of derivative peripheral clocks.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: linux-metag@vger.kernel.org
---
 drivers/clk/tz1090/Makefile             |  1 +
 drivers/clk/tz1090/clk-tz1090-divider.c | 96 +++++++++++++++++++++++++++++++++
 2 files changed, 97 insertions(+)
 create mode 100644 drivers/clk/tz1090/clk-tz1090-divider.c

diff --git a/drivers/clk/tz1090/Makefile b/drivers/clk/tz1090/Makefile
index 92e38a8..529c79c 100644
--- a/drivers/clk/tz1090/Makefile
+++ b/drivers/clk/tz1090/Makefile
@@ -1,5 +1,6 @@
 # Makefile for TZ1090-specific clocks
 obj-y		+= clk-tz1090-deleter.o
+obj-y		+= clk-tz1090-divider.o
 obj-y		+= clk-tz1090-gate-bank.o
 obj-y		+= clk-tz1090-mux-bank.o
 obj-y		+= clk-tz1090-pdc.o
diff --git a/drivers/clk/tz1090/clk-tz1090-divider.c b/drivers/clk/tz1090/clk-tz1090-divider.c
new file mode 100644
index 0000000..92788f1
--- /dev/null
+++ b/drivers/clk/tz1090/clk-tz1090-divider.c
@@ -0,0 +1,96 @@
+/*
+ * Copyright (C) 2011 Sascha Hauer, Pengutronix <s.hauer@pengutronix.de>
+ * Copyright (C) 2011 Richard Zhao, Linaro <richard.zhao@linaro.org>
+ * Copyright (C) 2011-2012 Mike Turquette, Linaro Ltd <mturquette@linaro.org>
+ * Copyright (C) 2014 Imagination Technologies Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Basic clock divider in TZ1090 SoC.
+ */
+
+#include <linux/clk-provider.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+
+#define CR_TOP_UARTCLK_DIV 0x02005928
+#define CR_TOP_META_CLKDIV 0x02005918
+
+/**
+ * tz1090_divider_policy() - Apply policy based on the specific divider.
+ * @res:		MMIO resource.
+ * @flags:		Clock flags to be modified depending on the divider.
+ * @divider_flags:	Divider flags to be modified depending on the divider.
+ */
+static void tz1090_divider_policy(const struct resource *res,
+				  unsigned long *flags, u8 *divider_flags)
+{
+	switch (res->start) {
+	case CR_TOP_UARTCLK_DIV:
+		/*
+		 * UART clock changes must propagate up to CLK_UART_SW, which
+		 * muxes between XTAL1 and sys_clk_undeleted, in order to get
+		 * enough precision.
+		 */
+		*flags |= CLK_SET_RATE_PARENT;
+		break;
+	case CR_TOP_META_CLKDIV:
+		/*
+		 * The output of this divider is sys_clk_undeleted. It is set up
+		 * by the bootloader along with the system PLL, and has a whole
+		 * bunch of derivative peripheral clocks. It would be a really
+		 * bad idea to allow it to change on the fly.
+		 */
+		*divider_flags |= CLK_DIVIDER_READ_ONLY;
+		break;
+	}
+}
+
+/**
+ * tz1090_divider_clk_setup() - Setup function for TZ1090 divider clock.
+ * @node:	DT node.
+ */
+static void tz1090_divider_clk_setup(struct device_node *node)
+{
+	struct clk *clk;
+	const char *clk_name = node->name;
+	void __iomem *reg;
+	const char *parent_name;
+	unsigned long flags = 0;
+	u8 divider_flags = 0;
+	u32 mask = 0;
+	u32 shift = 0;
+	struct resource res;
+
+	of_property_read_string(node, "clock-output-names", &clk_name);
+
+	parent_name = of_clk_get_parent_name(node, 0);
+
+	reg = of_iomap(node, 0);
+	if (!reg) {
+		pr_err("%s: no memory mapped for property reg\n", __func__);
+		return;
+	}
+
+	if (of_property_read_u32(node, "bit-mask", &mask)) {
+		pr_err("%s: missing bit-mask property for %s\n",
+		       __func__, node->name);
+		return;
+	}
+
+	/* Apply policy decisions depending on which divider this is */
+	if (of_address_to_resource(node, 0, &res))
+		return;
+	tz1090_divider_policy(&res, &flags, &divider_flags);
+
+	clk = clk_register_divider_mask(NULL, clk_name, parent_name, flags, reg,
+					shift, mask, divider_flags, NULL, NULL);
+
+	if (!IS_ERR(clk))
+		of_clk_add_provider(node, of_clk_src_simple_get, clk);
+}
+CLK_OF_DECLARE(divider_clk, "img,tz1090-divider", tz1090_divider_clk_setup);
-- 
2.0.4

