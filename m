Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932927AbaLAXWk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 18:22:40 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:52806 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932683AbaLAXVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 18:21:00 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mike Turquette <mturquette@linaro.org>, linux-metag@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Heiko Stuebner <heiko@sntech.de>, James Hogan <james.hogan@imgtec.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH v2 11/16] dt: binding: add binding for TZ1090 HEP clocks
Date: Mon,  1 Dec 2014 23:20:01 +0000
Message-Id: <1417476006-10407-12-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1417476006-10407-1-git-send-email-james.hogan@imgtec.com>
References: <1417476006-10407-1-git-send-email-james.hogan@imgtec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TZ1090 High End Peripheral (HEP) register region controls several
clocks for the HEP peripherals.

Create a clock binding for the provider of these clocks, and a header
file in <dt-bindings/clock/> for enumerating the provided clocks.

There are 3 clocks provided, the 2D block clock, the PDP/PDI clocks, and
the DDR enable clock which is fed back into the TOP clocks for dividing
down.

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
 .../bindings/clock/img,tz1090-hep-cru.txt          | 53 ++++++++++++++++++++++
 include/dt-bindings/clock/tz1090-hep.h             | 19 ++++++++
 2 files changed, 72 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/img,tz1090-hep-cru.txt
 create mode 100644 include/dt-bindings/clock/tz1090-hep.h

diff --git a/Documentation/devicetree/bindings/clock/img,tz1090-hep-cru.txt b/Documentation/devicetree/bindings/clock/img,tz1090-hep-cru.txt
new file mode 100644
index 0000000..e5acdd6
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/img,tz1090-hep-cru.txt
@@ -0,0 +1,53 @@
+Binding for TZ1090 High end peripheral clocks.
+
+This binding uses the common clock binding[1]. It represents the clocks
+controlled from the high end peripheral registers of the TZ1090:
+
+[1] Documentation/devicetree/bindings/clock/clock-bindings.txt
+
+Required properties:
+- compatible         : Shall be "img,tz1090-hep-cru".
+- #clock-cells       : From common clock binding; shall be set to 1.
+- reg                : Base address for clock registers in high end peripheral
+                       register region.
+- clocks             : Clock specifiers for each input clock.
+- clock-names        : Labels for each input clock specified in clocks.
+                       Can contain the following entries:
+                       "sys"              : Main system clock.
+                       "sys_x2_undeleted" : System clock before division and
+                                            deletion.
+
+Optional properties:
+- clock-indices      : From common clock binding. Allows clock-output-names to
+                       be sparse.
+- clock-output-names : From common clock binding. May be used to name specific
+                       output clocks so that other clock providers can find
+                       the clocks by name before the provider has been
+                       instantiated. Can contain:
+                       "sys_2d", "ddr_en", "sys_pdp"
+
+Clock Specifier Definition:
+- <1st-cell>: Output clock number. Use constants from
+              <dt-bindings/clock/tz1090-hep.h>.
+
+Examples:
+	hep_cru: hep_cru {
+		compatible = "img,tz1090-hep-cru";
+		#clock-cells = <1>;
+		reg = <0x02008c00 0x08>;
+		/* input clocks */
+		clocks = <&top_clks CLK_TOP_SYS>,
+			 <&top_clks CLK_TOP_SYS_X2_UNDELETED>;
+		clock-names = "sys",
+			      "sys_x2_undeleted";
+		/* output clocks for other clock providers */
+		clock-indices = <CLK_HEP_DDR_EN>;
+		clock-output-names = "ddr_en";
+	};
+
+	pdp {
+		...
+		clocks = <&hep_clks CLK_HEP_PDP>;
+		clock-names = "pdp";
+		...
+	};
diff --git a/include/dt-bindings/clock/tz1090-hep.h b/include/dt-bindings/clock/tz1090-hep.h
new file mode 100644
index 0000000..44398ef
--- /dev/null
+++ b/include/dt-bindings/clock/tz1090-hep.h
@@ -0,0 +1,19 @@
+/*
+ * Copyright (C) 2013-2014 Imagination Technologies Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _DT_BINDINGS_CLK_TZ1090_HEP_H
+#define _DT_BINDINGS_CLK_TZ1090_HEP_H
+
+/* CR_HEP_CLK_EN - High End Peripheral clocks */
+#define CLK_HEP_2D		0
+#define CLK_HEP_DDR_EN		1
+#define CLK_HEP_PDP		2
+
+#define CLK_HEP_MAX		3
+
+#endif
-- 
2.0.4

