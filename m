Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932919AbaLAXU6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 18:20:58 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:38423 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932885AbaLAXUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 18:20:54 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mike Turquette <mturquette@linaro.org>, linux-metag@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Heiko Stuebner <heiko@sntech.de>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH v2 08/16] clk: tz1090: add PDC clock provider driver
Date: Mon,  1 Dec 2014 23:19:58 +0000
Message-Id: <1417476006-10407-9-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1417476006-10407-1-git-send-email-james.hogan@imgtec.com>
References: <1417476006-10407-1-git-send-email-james.hogan@imgtec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TZ1090 PDC (PowerDown Controller) has a couple of clock components
in order to generate its main 32.768KHz clock which the peripherals in
the low power domain run off, especially while the SoC is otherwise
powered down.

It is generated either directly from the XTAL3 clock or by dividing the
XTAL1 clock. Both the divide and the mux are in a single register which
also contains GPIO output data, and may need to be used by other
non-Linux cores and threads.

Two clocks are created, a divider and a mux, both which use the TZ1090
specific wrapped versions of the generic clock drivers in order to use
the Meta exclusive lock when reconfiguring.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: linux-metag@vger.kernel.org
---
Changes since v1 (patch 12):
- Split out wrapped (meta exclusive locked) divider into patch 5.
- Switch to using common TZ1090 specific clock provider helpers,
  including for initialising divider data, changing driver to
  conceptually represent all clocks provided by the PDC in TZ1090 rather
  than the same generic arrangement of clocks as the PDC.
---
 drivers/clk/tz1090/Makefile         |  2 ++
 drivers/clk/tz1090/clk-tz1090-pdc.c | 52 +++++++++++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+)
 create mode 100644 drivers/clk/tz1090/clk-tz1090-pdc.c

diff --git a/drivers/clk/tz1090/Makefile b/drivers/clk/tz1090/Makefile
index a28a5bb..a762cdf 100644
--- a/drivers/clk/tz1090/Makefile
+++ b/drivers/clk/tz1090/Makefile
@@ -6,3 +6,5 @@ obj-y		+= clk-tz1090-divider.o
 obj-y		+= clk-tz1090-gate-bank.o
 obj-y		+= clk-tz1090-mux-bank.o
 obj-y		+= clk-tz1090-pll.o
+
+obj-y		+= clk-tz1090-pdc.o
diff --git a/drivers/clk/tz1090/clk-tz1090-pdc.c b/drivers/clk/tz1090/clk-tz1090-pdc.c
new file mode 100644
index 0000000..a309eef
--- /dev/null
+++ b/drivers/clk/tz1090/clk-tz1090-pdc.c
@@ -0,0 +1,52 @@
+/*
+ * Copyright (C) 2013-2014 Imagination Technologies Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU General Public License version 2 as published by the
+ * Free Software Foundation.
+ *
+ * TZ1090 PDC Clocks.
+ */
+
+#include <dt-bindings/clock/tz1090-pdc.h>
+
+#include "clk.h"
+
+/* Register offsets into PDC SoC region */
+#define PDC_SOC0		0x00
+
+/*
+ *                  SOC_GPIO_CONTROL 0
+ *                  ==================
+ *           ___________
+ * xtal1 ___| xtal1_div |____________________________
+ *          |___________|  |    ________   xtal1_div
+ *                         `--o| rtc_sw \____________
+ * xtal3 ----------------------|________/  32khz
+ */
+
+static const struct tz1090_clk_divider tz1090_pdc_dividers[] __initconst = {
+	/*         id                  in        out         reg  width shift */
+	DIV_SHARED(CLK_PDC_XTAL1_DIV, "@xtal1", "xtal1_div", PDC_SOC0, 11, 16),
+};
+
+MUX_BANK(tz1090_pdc_mux, CLK_PDC_32KHZ, PDC_SOC0,
+	/*  bit in[0]		 in[1]		out	*/
+	MUX(30, "xtal1_div",	 "@xtal3",	"32khz")
+);
+
+static void __init tz1090_pdc_clocks_init(struct device_node *np)
+{
+	struct tz1090_clk_provider *p;
+
+	p = tz1090_clk_alloc_provider(np, CLK_PDC_MAX);
+	if (!p)
+		return;
+
+	tz1090_clk_register_dividers(p, tz1090_pdc_dividers,
+				     ARRAY_SIZE(tz1090_pdc_dividers));
+	tz1090_clk_register_mux_bank(p, &tz1090_pdc_mux);
+
+	tz1090_clk_register_provider(p);
+}
+CLK_OF_DECLARE(tz1090_pdc_clk, "img,tz1090-pdc-clocks", tz1090_pdc_clocks_init);
-- 
2.0.4

