Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932994AbaLAXVK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 18:21:10 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:33732 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932952AbaLAXVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 18:21:04 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mike Turquette <mturquette@linaro.org>, linux-metag@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Heiko Stuebner <heiko@sntech.de>, James Hogan <james.hogan@imgtec.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH v2 13/16] dt: binding: add binding for TZ1090 PERIP clocks
Date: Mon,  1 Dec 2014 23:20:03 +0000
Message-Id: <1417476006-10407-14-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1417476006-10407-1-git-send-email-james.hogan@imgtec.com>
References: <1417476006-10407-1-git-send-email-james.hogan@imgtec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TZ1090 peripheral (PERIP) register region controls a bank of system
clock gates for individual peripherals.

Create a clock binding for the provider of these clocks, and a header
file in <dt-bindings/clock/> for enumerating the provided clocks.

There is a single input clock, the main system clock, and multiple
peripheral specific system clocks provided which should be referenced by
the relevant peripheral device nodes.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: linux-metag@vger.kernel.org
Cc: devicetree@vger.kernel.org
---
Changes since v1 (patch 15):
- New patch.
- Convert explicit DT representation of clock infrastructure using
  generic bindings to several TZ1090 specific bindings representing
  groups of TZ1090 clocks.
---
 .../bindings/clock/img,tz1090-perip-cru.txt        | 49 ++++++++++++++++++++++
 include/dt-bindings/clock/tz1090-perip.h           | 30 +++++++++++++
 2 files changed, 79 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/img,tz1090-perip-cru.txt
 create mode 100644 include/dt-bindings/clock/tz1090-perip.h

diff --git a/Documentation/devicetree/bindings/clock/img,tz1090-perip-cru.txt b/Documentation/devicetree/bindings/clock/img,tz1090-perip-cru.txt
new file mode 100644
index 0000000..3517737
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/img,tz1090-perip-cru.txt
@@ -0,0 +1,49 @@
+Binding for TZ1090 Peripheral register clocks.
+
+This binding uses the common clock binding[1]. It represents the clocks
+controlled from the peripheral registers of the TZ1090:
+
+[1] Documentation/devicetree/bindings/clock/clock-bindings.txt
+
+Required properties:
+- compatible         : Shall be "img,tz1090-perip-cru".
+- #clock-cells       : From common clock binding; shall be set to 1.
+- reg                : Base address for clock registers in peripheral register
+                       region.
+- clocks             : Clock specifiers for each input clock.
+- clock-names        : Labels for each input clock specified in clocks.
+                       Can contain the following entries:
+                       "sys" : Main system clock.
+
+Optional properties:
+- clock-indices      : From common clock binding. Allows clock-output-names to
+                       be sparse.
+- clock-output-names : From common clock binding. May be used to name specific
+                       output clocks so that other clock providers can find
+                       the clocks by name before the provider has been
+                       instantiated. Can contain:
+                       "sys_scb0", "sys_scb1", "sys_scb2", "sys_sdio",
+                       "sys_uart0", "sys_uart1", "sys_spim", "sys_spis",
+                       "sys_spim1", "sys_i2sout", "sys_i2sin", "sys_lcd",
+                       "sys_sdhost", "sys_usb"
+
+Clock Specifier Definition:
+- <1st-cell>: Output clock number. Use constants from
+              <dt-bindings/clock/tz1090-perip.h>.
+
+Examples:
+	perip_cru: perip_cru {
+		compatible = "img,tz1090-perip-cru";
+		#clock-cells = <1>;
+		reg = <0x02004000 0x18>;
+		clocks = <&top_clks CLK_TOP_SYS>;
+		clock-names = "sys";
+	};
+
+	i2c {
+		...
+		clocks = <&top_clks CLK_TOP_SCB>,
+			 <&perip_cru CLK_PERIP_SCB0>;
+		clock-names = "scb", "sys";
+		...
+	};
diff --git a/include/dt-bindings/clock/tz1090-perip.h b/include/dt-bindings/clock/tz1090-perip.h
new file mode 100644
index 0000000..b2990ea
--- /dev/null
+++ b/include/dt-bindings/clock/tz1090-perip.h
@@ -0,0 +1,30 @@
+/*
+ * Copyright (C) 2013-2014 Imagination Technologies Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _DT_BINDINGS_CLK_TZ1090_PERIP_H
+#define _DT_BINDINGS_CLK_TZ1090_PERIP_H
+
+/* CR_PERIP_CLKEN - Peripheral system clocks */
+#define CLK_PERIP_SCB0		 0
+#define CLK_PERIP_SCB1		 1
+#define CLK_PERIP_SCB2		 2
+#define CLK_PERIP_SDIO		 3
+#define CLK_PERIP_UART0		 4
+#define CLK_PERIP_UART1		 5
+#define CLK_PERIP_SPIM		 6
+#define CLK_PERIP_SPIS		 7
+#define CLK_PERIP_SPIM1		 8
+#define CLK_PERIP_I2SOUT	 9
+#define CLK_PERIP_I2SIN		10
+#define CLK_PERIP_LCD		11
+#define CLK_PERIP_SDHOST	12
+#define CLK_PERIP_USB		13
+
+#define CLK_PERIP_MAX		14
+
+#endif
-- 
2.0.4

