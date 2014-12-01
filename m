Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932972AbaLAXVH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 18:21:07 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:37979 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932948AbaLAXVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 18:21:02 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mike Turquette <mturquette@linaro.org>, linux-metag@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Heiko Stuebner <heiko@sntech.de>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH v2 12/16] clk: tz1090: add HEP clock provider driver
Date: Mon,  1 Dec 2014 23:20:02 +0000
Message-Id: <1417476006-10407-13-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1417476006-10407-1-git-send-email-james.hogan@imgtec.com>
References: <1417476006-10407-1-git-send-email-james.hogan@imgtec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TZ1090 High End Peripheral (HEP) register region controls several
clocks for the HEP peripherals.

The set up is pretty straight forward, with only a clock gate bank
(HEP_CLK_EN) needing to be configured.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: linux-metag@vger.kernel.org
---
Changes since v1 (patch 15):
- New patch.
- Convert explicit DT representation of clock infrastructure using
  generic bindings to several TZ1090 specific bindings representing
  groups of TZ1090 clocks.
---
 drivers/clk/tz1090/Makefile         |  1 +
 drivers/clk/tz1090/clk-tz1090-hep.c | 46 +++++++++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+)
 create mode 100644 drivers/clk/tz1090/clk-tz1090-hep.c

diff --git a/drivers/clk/tz1090/Makefile b/drivers/clk/tz1090/Makefile
index 873a8f6..1d3cd32 100644
--- a/drivers/clk/tz1090/Makefile
+++ b/drivers/clk/tz1090/Makefile
@@ -7,5 +7,6 @@ obj-y		+= clk-tz1090-gate-bank.o
 obj-y		+= clk-tz1090-mux-bank.o
 obj-y		+= clk-tz1090-pll.o
 
+obj-y		+= clk-tz1090-hep.o
 obj-y		+= clk-tz1090-pdc.o
 obj-y		+= clk-tz1090-top.o
diff --git a/drivers/clk/tz1090/clk-tz1090-hep.c b/drivers/clk/tz1090/clk-tz1090-hep.c
new file mode 100644
index 0000000..e5585b4
--- /dev/null
+++ b/drivers/clk/tz1090/clk-tz1090-hep.c
@@ -0,0 +1,46 @@
+/*
+ * Copyright (C) 2013-2014 Imagination Technologies Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU General Public License version 2 as published by the
+ * Free Software Foundation.
+ *
+ * TZ1090 High End Peripheral (HEP) Clocks
+ */
+
+#include <dt-bindings/clock/tz1090-hep.h>
+
+#include "clk.h"
+
+/* Register offsets into high end peripheral memory region */
+#define HEP_CLK_EN		0x04
+
+/*
+ *                      CR_HEP_CLK_EN
+ *                      =============
+ *
+ * sys              -+--[ 2d_en      ]--- 0 sys_2d
+ * sys_x2_undeleted -|--[ ddr_en     ]--- 1 ddr_en
+ * sys               `--[ pdp_pdi_en ]--- 2 sys_pdp
+ */
+GATE_BANK(tz1090_hep_clken, 0, HEP_CLK_EN,
+	/*   bit in			out	*/
+	GATE( 0, "@sys",		"sys_2d")
+	GATE( 1, "@sys_x2_undeleted",	"ddr_en")
+	GATE( 2, "@sys",		"sys_pdp")
+	/* bits 3..31 unused */
+);
+
+static void __init tz1090_hep_cru_init(struct device_node *np)
+{
+	struct tz1090_clk_provider *p;
+
+	p = tz1090_clk_alloc_provider(np, CLK_HEP_MAX);
+	if (!p)
+		return;
+
+	tz1090_clk_register_gate_bank(p, &tz1090_hep_clken);
+
+	tz1090_clk_register_provider(p);
+}
+CLK_OF_DECLARE(tz1090_hep_cru, "img,tz1090-hep-cru", tz1090_hep_cru_init);
-- 
2.0.4

