Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759321Ab3CZKXk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 06:23:40 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:55509 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757177Ab3CZKXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 06:23:38 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>
CC: <rnayak@ti.com>, <b-cousson@ti.com>, <santosh.shilimkar@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [PATCH v2] ARM: OMAP4: clock: Add device tree support for AUXCLKs
Date: Tue, 26 Mar 2013 12:23:27 +0200
Message-ID: <1364293408-20677-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1363703220-4777-2-git-send-email-rogerq@ti.com>
References: <1363703220-4777-2-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register a device tree clock provider for the clocks
on the OMAP4 SoC. Also provide the binding information.

For now we only provide AUXCLKs.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 .../devicetree/bindings/clock/omap4-clock.txt      |   33 ++++++++++++++++
 arch/arm/boot/dts/omap4.dtsi                       |    5 ++
 arch/arm/mach-omap2/cclock44xx_data.c              |   41 ++++++++++++++++++++
 3 files changed, 79 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/omap4-clock.txt

diff --git a/Documentation/devicetree/bindings/clock/omap4-clock.txt b/Documentation/devicetree/bindings/clock/omap4-clock.txt
new file mode 100644
index 0000000..2845a3f
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/omap4-clock.txt
@@ -0,0 +1,33 @@
+* Clock bindings for Texas Instruments OMAP4 clocks
+
+Required properties:
+- compatible: Should be "ti,omap4-clock"
+- #clock-cells: Should be <1>
+
+The clock consumer should specify the desired clock by having the clock
+ID in its "clocks" phandle cell.  The following is a list of OMAP4 clocks
+and IDs.
+
+	Clock		ID
+	------------------
+	auxclk0_ck	0
+	auxclk1_ck	1
+	auxclk2_ck	2
+	auxclk3_ck	3
+	auxclk4_ck	4
+	auxclk5_ck	5
+
+Example:
+
+aux_clks: scrmclks {
+	compatible = "ti,omap4-clock";
+	#clock-cells = <1>;
+};
+
+hsusb1_phy: hsusb1_phy {
+	compatible = "usb-nop-xceiv";
+	reset-supply = <&hsusb1_reset>;
+	clocks = <&aux_clks 3>;
+	clock-names = "main_clk";
+	clock-frequency = <19200000>;
+};
diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
index 739bb79..f27548a 100644
--- a/arch/arm/boot/dts/omap4.dtsi
+++ b/arch/arm/boot/dts/omap4.dtsi
@@ -101,6 +101,11 @@
 			ti,hwmods = "counter_32k";
 		};
 
+		clks: clocks {
+			compatible = "ti,omap4-clock";
+			#clock-cells = <1>;
+		};
+
 		omap4_pmx_core: pinmux@4a100040 {
 			compatible = "ti,omap4-padconf", "pinctrl-single";
 			reg = <0x4a100040 0x0196>;
diff --git a/arch/arm/mach-omap2/cclock44xx_data.c b/arch/arm/mach-omap2/cclock44xx_data.c
index 3d58f33..a93617b 100644
--- a/arch/arm/mach-omap2/cclock44xx_data.c
+++ b/arch/arm/mach-omap2/cclock44xx_data.c
@@ -27,6 +27,7 @@
 #include <linux/clk-private.h>
 #include <linux/clkdev.h>
 #include <linux/io.h>
+#include <linux/of.h>
 
 #include "soc.h"
 #include "iomap.h"
@@ -1663,6 +1664,44 @@ static struct omap_clk omap44xx_clks[] = {
 	CLK(NULL,	"cpufreq_ck",	&dpll_mpu_ck,	CK_443X),
 };
 
+/*
+ * List of clocks that can be referenced in device tree
+ * Must match with Documentation/devicetree/bindings/clock/omap4-clock.txt
+ */
+static struct clk *dt_clks[] = {
+	&auxclk0_ck,
+	&auxclk1_ck,
+	&auxclk2_ck,
+	&auxclk3_ck,
+	&auxclk4_ck,
+	&auxclk5_ck,
+};
+
+static struct clk_onecell_data clock_data;
+
+#ifdef CONFIG_OF
+int __init omap4_clk_init_dt(void)
+{
+	struct device_node *np;
+
+	np = of_find_compatible_node(NULL, NULL, "ti,omap4-clock");
+	if (np) {
+		clock_data.clks = dt_clks;
+		clock_data.clk_num = ARRAY_SIZE(dt_clks);
+		of_clk_add_provider(np, of_clk_src_onecell_get,	&clock_data);
+	}
+
+	return 0;
+}
+
+#else
+
+int __init omap4_clk_init_dt(void)
+{
+	return 0;
+}
+#endif /* CONFIG_OF */
+
 int __init omap4xxx_clk_init(void)
 {
 	u32 cpu_clkflg;
@@ -1693,6 +1732,8 @@ int __init omap4xxx_clk_init(void)
 
 	omap2_clk_disable_autoidle_all();
 
+	omap4_clk_init_dt();
+
 	/*
 	 * On OMAP4460 the ABE DPLL fails to turn on if in idle low-power
 	 * state when turning the ABE clock domain. Workaround this by
-- 
1.7.4.1

