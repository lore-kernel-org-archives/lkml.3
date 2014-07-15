Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098AbaGOP3B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 11:29:01 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:50656 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754461AbaGOPWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 11:22:48 -0400
From: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
To: mturquette@linaro.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@stlinux.com, Lee Jones <lee.jones@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>
Subject: [PATCH v3 05/15] clk: st: Adds Flexgen clock binding
Date: Tue, 15 Jul 2014 17:20:21 +0200
Message-Id: <1405437631-23623-6-git-send-email-gabriel.fernandez@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405437631-23623-1-git-send-email-gabriel.fernandez@linaro.org>
References: <1405437631-23623-1-git-send-email-gabriel.fernandez@linaro.org>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-07-15_05:2014-07-15,2014-07-15,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A Flexgen structure is composed by:
- a clock cross bar (represented by a mux element)
- a pre and final dividers (represented by a divider and gate elements)

Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
Acked-by: Peter Griffin <peter.griffin@linaro.org>
---
 .../devicetree/bindings/clock/st/st,clkgen.txt     |   5 +
 .../devicetree/bindings/clock/st/st,flexgen.txt    | 119 +++++++++++++++++++++
 2 files changed, 124 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/st/st,flexgen.txt

diff --git a/Documentation/devicetree/bindings/clock/st/st,clkgen.txt b/Documentation/devicetree/bindings/clock/st/st,clkgen.txt
index 427bad8..78978f1 100644
--- a/Documentation/devicetree/bindings/clock/st/st,clkgen.txt
+++ b/Documentation/devicetree/bindings/clock/st/st,clkgen.txt
@@ -32,6 +32,10 @@ address is common of all subnode.
 		vcc_node {
 			...
 		};
+
+		flexgen_node {
+			...
+		};
 		...
 	};
 
@@ -45,6 +49,7 @@ Each subnode should use the binding discribe in [2]..[7]
 [5] Documentation/devicetree/bindings/clock/st,clkgen-prediv.txt
 [6] Documentation/devicetree/bindings/clock/st,vcc.txt
 [7] Documentation/devicetree/bindings/clock/st,quadfs.txt
+[8] Documentation/devicetree/bindings/clock/st,flexgen.txt
 
 
 Required properties:
diff --git a/Documentation/devicetree/bindings/clock/st/st,flexgen.txt b/Documentation/devicetree/bindings/clock/st/st,flexgen.txt
new file mode 100644
index 0000000..1d3ace0
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/st/st,flexgen.txt
@@ -0,0 +1,119 @@
+Binding for a type of flexgen structure found on certain
+STMicroelectronics consumer electronics SoC devices
+
+This structure includes:
+- a clock cross bar (represented by a mux element)
+- a pre and final dividers (represented by a divider and gate elements)
+
+Flexgen structure is a part of Clockgen[1].
+
+Please find an example below:
+
+    Clockgen block diagram
+    -------------------------------------------------------------------
+   |                     Flexgen stucture                              |
+   |                  ---------------------------------------------    |
+   |                 |    -------       --------       --------    |   |
+clk_sysin            |   |       |     |        |     |        |   |   |
+---|-----------------|-->|       |     |        |     |        |   |   |
+   | |               |   |       |     |        |     |        |   |   |
+   | |   -------     |   |       |     |Pre     |     |Final   |   |   |
+   | |  |PLL0   |    |   |       |     |Dividers|     |Dividers|   |   |
+   | |->|       |    |   |       |     |  x32   |     |  x32   |   |   |
+   | |  |  odf_0|----|-->|       |     |        |     |        |   |   |
+   | |  |       |    |   |       |     |        |     |        |   |   |
+   | |  |       |    |   |       |     |        |     |        |   |   |
+   | |  |       |    |   |       |     |        |     |        |   |   |
+   | |  |       |    |   |       |     |        |     |        |   |   |
+   | |   -------     |   |       |     |        |     |        |   |   |
+   | |               |   |       |     |        |     |        |   |   |
+   | |   -------     |   | Clock |     |        |     |        |   |   |
+   | |  |PLL1   |    |   |       |     |        |     |        |   |   |
+   | |->|       |    |   | Cross |     |        |     |        |   |   |
+   | |  |  odf_0|----|-->|       |     |        |     |        | CLK_DIV[31:0]
+   | |  |       |    |   | Bar   |====>|        |====>|        |===|=========>
+   | |  |       |    |   |       |     |        |     |        |   |   |
+   | |  |       |    |   |       |     |        |     |        |   |   |
+   | |  |       |    |   |       |     |        |     |        |   |   |
+   | |   -------     |   |       |     |        |     |        |   |   |
+   | |               |   |       |     |        |     |        |   |   |
+   | |   -------     |   |       |     |        |     |        |   |   |
+   | |  |QUADFS |    |   |       |     |        |     |        |   |   |
+   | |->|    ch0|----|-->|       |     |        |     |        |   |   |
+   |    |       |    |   |       |     |        |     |        |   |   |
+   |    |    ch1|----|-->|       |     |        |     |        |   |   |
+   |    |       |    |   |       |     |        |     |        |   |   |
+   |    |    ch2|----|-->|       |     | DIV    |     | DIV    |   |   |
+   |    |       |    |   |       |     |  1 to  |     |  1 to  |   |   |
+   |    |    ch3|----|-->|       |     |   1024 |     |     64 |   |   |
+   |     -------     |   |       |     |        |     |        |   |   |
+   |                 |    -------       --------       --------    |   |
+   |                   --------------------------------------------    |
+   |                                                                   |
+    -------------------------------------------------------------------
+
+This binding uses the common clock binding[2].
+
+[1] Documentation/devicetree/bindings/clock/st/st,clkgen.txt
+[2] Documentation/devicetree/bindings/clock/clock-bindings.txt
+
+Required properties:
+- compatible : shall be:
+  "st,flexgen"
+
+- #clock-cells : from common clock binding; shall be set to 1 (multiple clock
+  outputs).
+
+- clocks : must be set to the parent's phandle. it's could be output clocks of
+  a quadsfs or/and a pll or/and clk_sysin (up to 7 clocks)
+
+- clock-output-names : List of strings used to name the clock outputs.
+
+Example:
+
+	clk_s_c0_flexgen: clk-s-c0-flexgen {
+
+		#clock-cells = <1>;
+		compatible = "st,flexgen";
+
+		clocks = <&clk_s_c0_pll0 0>,
+			 <&clk_s_c0_pll1 0>,
+			 <&clk_s_c0_quadfs 0>,
+			 <&clk_s_c0_quadfs 1>,
+			 <&clk_s_c0_quadfs 2>,
+			 <&clk_s_c0_quadfs 3>,
+			 <&clk_sysin>;
+
+		clock-output-names = "clk-icn-gpu",
+				     "clk-fdma",
+				     "clk-nand",
+				     "clk-hva",
+				     "clk-proc-stfe",
+				     "clk-proc-tp",
+				     "clk-rx-icn-dmu",
+				     "clk-rx-icn-hva",
+				     "clk-icn-cpu",
+				     "clk-tx-icn-dmu",
+				     "clk-mmc-0",
+				     "clk-mmc-1",
+				     "clk-jpegdec",
+				     "clk-ext2fa9",
+				     "clk-ic-bdisp-0",
+				     "clk-ic-bdisp-1",
+				     "clk-pp-dmu",
+				     "clk-vid-dmu",
+				     "clk-dss-lpc",
+				     "clk-st231-aud-0",
+				     "clk-st231-gp-1",
+				     "clk-st231-dmu",
+				     "clk-icn-lmi",
+				     "clk-tx-icn-disp-1",
+				     "clk-icn-sbc",
+				     "clk-stfe-frc2",
+				     "clk-eth-phy",
+				     "clk-eth-ref-phyclk",
+				     "clk-flash-promip",
+				     "clk-main-disp",
+				     "clk-aux-disp",
+				     "clk-compo-dvp";
+	};
-- 
1.9.1

