Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141AbaKUSeh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 13:34:37 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:29726 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921AbaKUSef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 13:34:35 -0500
From: Alban Bedel <albeu@free.fr>
To: linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org, Alban Bedel <albeu@free.fr>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH 3/4] devicetree: add binding documentation for a generic clock controller
Date: Fri, 21 Nov 2014 19:34:02 +0100
Message-Id: <1416594843-12352-3-git-send-email-albeu@free.fr>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1416594843-12352-1-git-send-email-albeu@free.fr>
References: <1416594843-12352-1-git-send-email-albeu@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alban Bedel <albeu@free.fr>
---
 .../bindings/clock/mmio-clock-controller.txt       | 127 +++++++++++++++++++++
 1 file changed, 127 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/mmio-clock-controller.txt

diff --git a/Documentation/devicetree/bindings/clock/mmio-clock-controller.txt b/Documentation/devicetree/bindings/clock/mmio-clock-controller.txt
new file mode 100644
index 0000000..5a5f752
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/mmio-clock-controller.txt
@@ -0,0 +1,127 @@
+Binding for a generic MMIO clock controller
+
+This binding allow describing simple MMIO clock controllers using a few
+primitive blocks like dividers and gates.
+
+Required properties:
+- compatible : shall be "mmio-clock-controller"
+- reg : address and size of the register area
+- #address-cells : shall be 1
+- #size-cells : shall be 0
+
+Children nodes are used to represent the blocks found in the controller.
+Beside the children types described here it is also possible to use fixed
+clocks[1] and dividers[2].
+
+All the following bindings use the common clock binding[3].
+
+[1] Documentation/devicetree/bindings/clock/fixed-clock.txt
+[2] Documentation/devicetree/bindings/clock/fixed-factor-clock.txt
+[3] Documentation/devicetree/bindings/clock/clock-bindings.txt
+
+- gate
+
+  Required properties:
+  - compatible : shall be "gate-clock"
+  - reg : offset of the register
+  - #clock-cells : from common clock binding; shall be set to 0
+  - clocks : from common clock binding; the parent clock
+  - clock-gate-bit : position of the gating bit inside the register
+
+  Optional properties:
+  - clock-output-names : from common clock binding
+  - high-word-mask : set if the high word is a write mask
+  - low-active : set if the bit should be cleared to enable the clock
+
+- mux
+
+  Required properties:
+  - compatible : shall be "mux-clock"
+  - reg : offset of the register
+  - #clock-cells : from common clock binding; shall be set to 0
+  - clocks : from common clock binding; the parent clocks
+  - clock-mux-shift : position of the mux field inside the register
+  - clock-mux-width : width of the mux field in bits
+
+  Optional properties:
+  - clock-output-names : from common clock binding
+  - read-only : set if the muxer should not be writable
+  - index-plus-one : set if the clock index should be offset by one
+  - index-bitmask : set if the mux field is a bit mask
+  - high-word-mask : set if the high word is a write mask
+
+- divider
+
+  Required properties:
+  - compatible : shall be "divider-clock"
+  - reg : offset of the register
+  - #clock-cells : from common clock binding; shall be set to 0
+  - clocks : from common clock binding; the parent clock
+  - clock-div-shift : position of the divider field inside the register
+  - clock-div-width : width of the divider field in bits
+
+  Optional properties:
+  - clock-output-names : from common clock binding
+  - clock-mult-shift : position of the multiplier field inside the register
+  - clock-mult-width : width of the multiplier field in bits
+  - read-only : set if the divider should not be writable
+  - divider-plus-one : set if the divider should be offset by one
+
+  Optional properties only supported without multiplier:
+  - divider-power-two : if set the divisor is 2 raised to the value read from
+			the hardware register
+  - divider-allow-zero : set to allow setting the divider to zero
+  - high-word-mask : set if the high word is a write mask
+
+Example:
+	clkctrl@8ABC0000 {
+		compatible = "mmio-clock-controller";
+		reg = <0x8ABC0000 0x10>;
+
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		pll: pll {
+			compatible = "divider-clock";
+			reg = <0>;
+
+			clock-names = "external-oscillator";
+			clocks = <&ext_osc>;
+
+			#clock-cells = <0>;
+			clock-output-names = "pll";
+
+			clock-mult-shift = <0>;
+			clock-mult-width = <10>;
+
+			clock-div-shift = <10>;
+			clock-div-width = <6>;
+		};
+
+		pll_bypass: pll_bypass {
+			compatible = "mux-clock";
+			reg = <0>;
+
+			clock-names = "pll", "external-oscillator";
+			clocks = <&pll>, <&ext_osc>;
+
+			#clock-cells = <0>;
+			clock-output-names = "pll-bypass";
+
+			clock-mux-shift = <16>;
+			clock-mux-width = <1>;
+		};
+
+		clk1: pll_gate {
+			compatible = "gate-clock";
+			reg = <0>;
+
+			clock-names = "pll-bypass";
+			clocks = <&pll_bypass>;
+
+			#clock-cells = <0>;
+			clock-output-names = "clk1";
+
+			clock-gate-bit = <17>;
+		};
+	};
-- 
2.0.0

