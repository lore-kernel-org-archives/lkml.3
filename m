Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850AbaDUV2k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 17:28:40 -0400
Received: from mail-yk0-f175.google.com ([209.85.160.175]:65472 "EHLO
	mail-yk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754696AbaDUV0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 17:26:38 -0400
From: Alex Elder <elder@linaro.org>
To: mturquette@linaro.org, mporter@linaro.org, bcm@fixthebug.org,
        devicetree@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 RESEND 2/5] ARM: dts: revise kona clock binding document
Date: Mon, 21 Apr 2014 16:26:24 -0500
Message-Id: <1398115587-32529-3-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398115587-32529-1-git-send-email-elder@linaro.org>
References: <1398115587-32529-1-git-send-email-elder@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The next patch defines a binding for a new Broadcom SoC that uses
Kona style CCUs for its clocks.  Update the generic Kona clock
binding document so it's more natural to accomodate the definitions
of additional SoC families.

Specifically:
    - Define the compatible string values generically, referring
      to specific per-model values later in the document.
    - Put the device tree example immediately after the required
      properties listing, before the tables of SoC-specific values.
    - Clearly identify the start of the section defining specific
      values related to the BCM281XX family
    - Add a list of the specific BCM281XX family compatible strings.
    - Reword the description of the table slightly.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 .../devicetree/bindings/clock/bcm-kona-clock.txt   | 87 ++++++++++++----------
 1 file changed, 47 insertions(+), 40 deletions(-)

diff --git a/Documentation/devicetree/bindings/clock/bcm-kona-clock.txt b/Documentation/devicetree/bindings/clock/bcm-kona-clock.txt
index 56d1f49..ebe3ab6 100644
--- a/Documentation/devicetree/bindings/clock/bcm-kona-clock.txt
+++ b/Documentation/devicetree/bindings/clock/bcm-kona-clock.txt
@@ -10,12 +10,12 @@ This binding uses the common clock binding:
 
 Required properties:
 - compatible
-	Shall have one of the following values:
-	- "brcm,bcm11351-root-ccu"
-	- "brcm,bcm11351-aon-ccu"
-	- "brcm,bcm11351-hub-ccu"
-	- "brcm,bcm11351-master-ccu"
-	- "brcm,bcm11351-slave-ccu"
+	Shall have a value of the form "brcm,<model>-<which>-ccu",
+	where <model> is a Broadcom SoC model number and <which> is
+	the name of a defined CCU.  For example:
+	    "brcm,bcm11351-root-ccu"
+	The compatible strings used for each supported SoC family
+	are defined below.
 - reg
 	Shall define the base and range of the address space
 	containing clock control registers
@@ -26,12 +26,48 @@ Required properties:
 	Shall be an ordered list of strings defining the names of
 	the clocks provided by the CCU.
 
+Device tree example:
 
-BCM281XX family SoCs use Kona CCUs.  The following table defines
-the set of CCUs and clock specifiers for BCM281XX clocks.  When
-a clock consumer references a clocks, its symbolic specifier
-(rather than its numeric index value) should be used.  These
-specifiers are defined in "include/dt-bindings/clock/bcm281xx.h".
+	slave_ccu: slave_ccu {
+		compatible = "brcm,bcm11351-slave-ccu";
+		reg = <0x3e011000 0x0f00>;
+		#clock-cells = <1>;
+		clock-output-names = "uartb",
+				     "uartb2",
+				     "uartb3",
+				     "uartb4";
+	};
+
+	ref_crystal_clk: ref_crystal {
+		#clock-cells = <0>;
+		compatible = "fixed-clock";
+		clock-frequency = <26000000>;
+	};
+
+	uart@3e002000 {
+		compatible = "brcm,bcm11351-dw-apb-uart", "snps,dw-apb-uart";
+		status = "disabled";
+		reg = <0x3e002000 0x1000>;
+		clocks = <&slave_ccu BCM281XX_SLAVE_CCU_UARTB3>;
+		interrupts = <GIC_SPI 65 IRQ_TYPE_LEVEL_HIGH>;
+		reg-shift = <2>;
+		reg-io-width = <4>;
+	};
+
+BCM281XX family
+---------------
+CCU compatible string values for SoCs in the BCM281XX family are:
+    "brcm,bcm11351-root-ccu"
+    "brcm,bcm11351-aon-ccu"
+    "brcm,bcm11351-hub-ccu"
+    "brcm,bcm11351-master-ccu"
+    "brcm,bcm11351-slave-ccu"
+
+The following table defines the set of CCUs and clock specifiers for
+BCM281XX family clocks.  When a clock consumer references a clocks,
+its symbolic specifier (rather than its numeric index value) should
+be used.  These specifiers are defined in:
+    "include/dt-bindings/clock/bcm281xx.h"
 
     CCU     Clock           Type    Index   Specifier
     ---     -----           ----    -----   ---------
@@ -62,32 +98,3 @@ specifiers are defined in "include/dt-bindings/clock/bcm281xx.h".
     slave   bsc2            peri      7     BCM281XX_SLAVE_CCU_BSC2
     slave   bsc3            peri      8     BCM281XX_SLAVE_CCU_BSC3
     slave   pwm             peri      9     BCM281XX_SLAVE_CCU_PWM
-
-
-Device tree example:
-
-	slave_ccu: slave_ccu {
-		compatible = "brcm,bcm11351-slave-ccu";
-		reg = <0x3e011000 0x0f00>;
-		#clock-cells = <1>;
-		clock-output-names = "uartb",
-				     "uartb2",
-				     "uartb3",
-				     "uartb4";
-	};
-
-	ref_crystal_clk: ref_crystal {
-		#clock-cells = <0>;
-		compatible = "fixed-clock";
-		clock-frequency = <26000000>;
-	};
-
-	uart@3e002000 {
-		compatible = "brcm,bcm11351-dw-apb-uart", "snps,dw-apb-uart";
-		status = "disabled";
-		reg = <0x3e002000 0x1000>;
-		clocks = <&slave_ccu BCM281XX_SLAVE_CCU_UARTB3>;
-		interrupts = <GIC_SPI 65 IRQ_TYPE_LEVEL_HIGH>;
-		reg-shift = <2>;
-		reg-io-width = <4>;
-	};
-- 
1.9.1

