Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933030AbaLAXXr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 18:23:47 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:58565 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932872AbaLAXUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 18:20:52 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mike Turquette <mturquette@linaro.org>, linux-metag@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Heiko Stuebner <heiko@sntech.de>, James Hogan <james.hogan@imgtec.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH v2 07/16] dt: binding: add binding for TZ1090 PDC clocks
Date: Mon,  1 Dec 2014 23:19:57 +0000
Message-Id: <1417476006-10407-8-git-send-email-james.hogan@imgtec.com>
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

Create a clock binding for the provider of these clocks, and a header
file in <dt-bindings/clock/> for enumerating the provided clocks.

It essentially has just two clock inputs (xtal1 and xtal3), and two
clock outputs, of which only "32khz" is likely to be used.

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
Changes since v1 (patch 11):
- Change the binding to conceptually represent all clocks provided by
  the PDC in TZ1090 rather than the same generic arrangement of clocks
  as the PDC in TZ1090, since the driver will use the common TZ1090
  specific clock provider helpers to provide specific clocks.
- Change compatible string from "img,tz1090-pdc-clock" to
  "img,tz1090-pdc-clocks" to match the intended purpose.
- Add header in <dt-bindings/clock/> to enumerate the provided clocks.
- Add clock-names as required property as used by common TZ1090 clock
  provider code.
- Mention standard clock-indices and clock-output-names optional
  properties for when the clocks may be used by other clock providers
  and should match the names used in the driver.
---
 .../bindings/clock/img,tz1090-pdc-clocks.txt       | 59 ++++++++++++++++++++++
 include/dt-bindings/clock/tz1090-pdc.h             | 18 +++++++
 2 files changed, 77 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/img,tz1090-pdc-clocks.txt
 create mode 100644 include/dt-bindings/clock/tz1090-pdc.h

diff --git a/Documentation/devicetree/bindings/clock/img,tz1090-pdc-clocks.txt b/Documentation/devicetree/bindings/clock/img,tz1090-pdc-clocks.txt
new file mode 100644
index 0000000..2f3b4c9
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/img,tz1090-pdc-clocks.txt
@@ -0,0 +1,59 @@
+Binding for TZ1090 PDC clocks.
+
+This binding uses the common clock binding[1]. It represents the clocks
+required to generate the 32KHz PDC clock used by the devices in the low power
+domain:
+
+          ___________
+xtal1 ___| xtal1_div |____________________________
+         |___________|  |    ________   xtal1_div
+                        `--o| rtc_sw \____________
+xtal3 ----------------------|________/  32khz
+
+xtal1_div = xtal1 / (reg[26:16] + 1)
+xtal3 = reg[30] ? xtal3 : xtal1_div
+
+
+[1] Documentation/devicetree/bindings/clock/clock-bindings.txt
+
+Required properties:
+- compatible         : Shall be "img,tz1090-pdc-clocks".
+- #clock-cells       : From common clock binding; shall be set to 1.
+- reg                : Base address for registers controlling PDC clocks.
+- clocks             : Clock specifiers for each input clock.
+- clock-names        : Labels for each input clock specified in clocks.
+                       Can contain the following entries:
+                       "xtal1" : XTAL1 oscillator.
+                       "xtal3" : XTAL3 32KHz oscillator.
+
+Optional properties:
+- clock-indices      : From common clock binding. Allows clock-output-names to
+                       be sparse.
+- clock-output-names : From common clock binding. May be used to name specific
+                       output clocks so that other clock providers can find
+                       the clocks by name before the provider has been
+                       instantiated. Can contain:
+                       "32khz"     : 32khz PDC clock.
+
+Clock Specifier Definition:
+- <1st-cell>: Output clock number. Use constants from
+              <dt-bindings/clock/tz1090-pdc.h>.
+
+Examples:
+	pdc_clks: pdc_clks {
+		compatible = "img,tz1090-pdc-clocks";
+		#clock-cells = <1>;
+		reg = <0x02006500 0x4>;	/* SOC_GPIO_CONTROL0 */
+		clocks = <&xtal1>,
+			 <&xtal3>;
+		clock-names = "xtal1",
+			      "xtal3";
+	};
+
+	ir {
+		...
+		clocks = <&pdc_clks CLK_PDC_32KHZ>,
+			 <&top_clks CLK_TOP_PDC>;
+		clock-names = "core", "sys";
+		...
+	};
diff --git a/include/dt-bindings/clock/tz1090-pdc.h b/include/dt-bindings/clock/tz1090-pdc.h
new file mode 100644
index 0000000..fa9a11c
--- /dev/null
+++ b/include/dt-bindings/clock/tz1090-pdc.h
@@ -0,0 +1,18 @@
+/*
+ * Copyright (C) 2013-2014 Imagination Technologies Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _DT_BINDINGS_CLK_TZ1090_PDC_H
+#define _DT_BINDINGS_CLK_TZ1090_PDC_H
+
+/* Powerdown Controller clocks */
+#define CLK_PDC_XTAL1_DIV	0
+#define CLK_PDC_32KHZ		1
+
+#define CLK_PDC_MAX		2
+
+#endif
-- 
2.0.4

