Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933018AbaLAXWD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 18:22:03 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:57166 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932949AbaLAXVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 18:21:06 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mike Turquette <mturquette@linaro.org>, linux-metag@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Heiko Stuebner <heiko@sntech.de>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH v2 14/16] clk: tz1090: add PERIP clock provider driver
Date: Mon,  1 Dec 2014 23:20:04 +0000
Message-Id: <1417476006-10407-15-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1417476006-10407-1-git-send-email-james.hogan@imgtec.com>
References: <1417476006-10407-1-git-send-email-james.hogan@imgtec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TZ1090 peripheral (PERIP) register region controls a bank of system
clock gates for individual peripherals.

The set up is pretty straight forward, with only a clock gate bank
(PERIP_CLKEN) needing to be configured, with all the gates using the
same external system clock as input.

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
 drivers/clk/tz1090/Makefile           |  1 +
 drivers/clk/tz1090/clk-tz1090-perip.c | 57 +++++++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+)
 create mode 100644 drivers/clk/tz1090/clk-tz1090-perip.c

diff --git a/drivers/clk/tz1090/Makefile b/drivers/clk/tz1090/Makefile
index 1d3cd32..1df6b8a 100644
--- a/drivers/clk/tz1090/Makefile
+++ b/drivers/clk/tz1090/Makefile
@@ -9,4 +9,5 @@ obj-y		+= clk-tz1090-pll.o
 
 obj-y		+= clk-tz1090-hep.o
 obj-y		+= clk-tz1090-pdc.o
+obj-y		+= clk-tz1090-perip.o
 obj-y		+= clk-tz1090-top.o
diff --git a/drivers/clk/tz1090/clk-tz1090-perip.c b/drivers/clk/tz1090/clk-tz1090-perip.c
new file mode 100644
index 0000000..dbf8a25
--- /dev/null
+++ b/drivers/clk/tz1090/clk-tz1090-perip.c
@@ -0,0 +1,57 @@
+/*
+ * Copyright (C) 2013-2014 Imagination Technologies Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU General Public License version 2 as published by the
+ * Free Software Foundation.
+ *
+ * TZ1090 Peripheral Clocks
+ */
+
+#include <dt-bindings/clock/tz1090-perip.h>
+
+#include "clk.h"
+
+/* Register offsets into peripheral memory region */
+#define PERIP_SRST		0x00
+#define PERIP_CLKEN		0x10
+#define PERIP_CLKSTATUS		0x14
+
+/*
+ *            CR_PERIP_CLKEN
+ *            ==============
+ *
+ * sys ---[CR_PERIP_*_SYS_CLK_EN]--- sys_*
+ */
+GATE_BANK(tz1090_perip_clken, 0, PERIP_CLKEN,
+	/*   bit in      out */
+	GATE( 0, "@sys", "sys_scb0")
+	GATE( 1, "@sys", "sys_scb1")
+	GATE( 2, "@sys", "sys_scb2")
+	GATE( 3, "@sys", "sys_sdio")
+	GATE( 4, "@sys", "sys_uart0")
+	GATE( 5, "@sys", "sys_uart1")
+	GATE( 6, "@sys", "sys_spim")
+	GATE( 7, "@sys", "sys_spis")
+	GATE( 8, "@sys", "sys_spim1")
+	GATE( 9, "@sys", "sys_i2sout")
+	GATE(10, "@sys", "sys_i2sin")
+	GATE(11, "@sys", "sys_lcd")
+	GATE(12, "@sys", "sys_sdhost")
+	GATE(13, "@sys", "sys_usb")
+	/* bits 14..31 unused */
+);
+
+static void __init tz1090_perip_cru_init(struct device_node *np)
+{
+	struct tz1090_clk_provider *p;
+
+	p = tz1090_clk_alloc_provider(np, CLK_PERIP_MAX);
+	if (!p)
+		return;
+
+	tz1090_clk_register_gate_bank(p, &tz1090_perip_clken);
+
+	tz1090_clk_register_provider(p);
+}
+CLK_OF_DECLARE(tz1090_perip_cru, "img,tz1090-perip-cru", tz1090_perip_cru_init);
-- 
2.0.4

