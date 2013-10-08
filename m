Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533Ab3JHFfv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 01:35:51 -0400
Received: from gw.cm.dream.jp ([59.157.128.2]:34692 "EHLO vsmtp02.cm.dti.ne.jp"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754456Ab3JHFfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 01:35:47 -0400
Date: Tue, 8 Oct 2013 14:32:17 +0900
From: takasi-y@ops.dti.ne.jp
To: SH-Linux <linux-sh@vger.kernel.org>
Cc: Magnus Damm <magnus.damm@gmail.com>, ben.dooks@codethink.co.uk,
        Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>,
        Mike Turquette <mturquette@linaro.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        devicetree@vger.kernel.org, Simon Horman <horms@verge.net.au>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] clk: emev2: Add support for emev2 SMU clocks with DT
Message-Id: <20131008143217.0611fba0c0d27d9c622759f3@ops.dti.ne.jp>
In-Reply-To: <20131008143040.52f36df8edb7ab63224d8433@ops.dti.ne.jp>
References: <20131008143040.52f36df8edb7ab63224d8433@ops.dti.ne.jp>
X-Mailer: Sylpheed 3.4.0beta3 (GTK+ 2.24.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Device tree clock binding document for EMMA Mobile EV2 SMU,
And Common clock framework based implementation of it.
Following nodes are defined to describe clock tree.
- renesas,emev2-smu
- renesas,emev2-smu-clkdiv
- renesas,emev2-smu-gclk

These bindings are designed manually based on
 19UH0037EJ1000_SMU : System Management Unit User's Manual

So far, reparent is not implemented, and is fixed to index #0.
Clock tree description is not included, and should be provided
by device-tree.

Signed-off-by: Takashi Yoshii <takasi-y@ops.dti.ne.jp>
---
 .../devicetree/bindings/clock/emev2-clock.txt      |  98 +++++++++++++++++++
 drivers/clk/Makefile                               |   1 +
 drivers/clk/shmobile/Makefile                      |   3 +
 drivers/clk/shmobile/clk-emev2.c                   | 104 +++++++++++++++++++++
 4 files changed, 206 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/emev2-clock.txt
 create mode 100644 drivers/clk/shmobile/Makefile
 create mode 100644 drivers/clk/shmobile/clk-emev2.c

diff --git a/Documentation/devicetree/bindings/clock/emev2-clock.txt b/Documentation/devicetree/bindings/clock/emev2-clock.txt
new file mode 100644
index 0000000..60bbb1a
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/emev2-clock.txt
@@ -0,0 +1,98 @@
+Device tree Clock bindings for Renesas EMMA Mobile EV2
+
+This binding uses the common clock binding.
+
+* SMU
+System Management Unit described in user's manual R19UH0037EJ1000_SMU.
+This is not a clock provider, but clocks under SMU depend on it.
+
+Required properties:
+- compatible: Should be "renesas,emev2-smu"
+- reg: Address and Size of SMU registers
+
+* SMU_CLKDIV
+Function block with an input mux and a divider, which corresponds to
+"Serial clock generator" in fig."Clock System Overview" of the manual,
+and "xxx frequency division setting register" (XXXCLKDIV) registers.
+This makes internal (neither input nor output) clock that is provided
+to input of xxxGCLK block.
+
+Required properties:
+- compatible: Should be "renesas,emev2-smu-clkdiv"
+- reg: Byte offset from SMU base and Bit position in the register
+- clocks: Parent clocks. Input clocks as described in clock-bindings.txt
+- #clock-cells: Should be <0>
+
+* SMU_GCLK
+Clock gating node shown as "Clock stop processing block" in the
+fig."Clock System Overview" of the manual.
+Registers are "xxx clock gate control register" (XXXGCLKCTRL).
+
+Required properties:
+- compatible: Should be "renesas,emev2-smu-gclk"
+- reg: Byte offset from SMU base and Bit position in the register
+- clocks: Input clock as described in clock-bindings.txt
+- #clock-cells: Should be <0>
+
+Example of provider:
+
+usia_u0_sclkdiv: usia_u0_sclkdiv {
+	compatible = "renesas,emev2-smu-clkdiv";
+	reg = <0x610 0>;
+	clocks = <&pll3_fo>, <&pll4_fo>, <&pll1_fo>, <&osc1_fo>;
+	#clock-cells = <0>;
+};
+
+usia_u0_sclk: usia_u0_sclk {
+	compatible = "renesas,emev2-smu-gclk";
+	reg = <0x4a0 1>;
+	clocks = <&usia_u0_sclkdiv>;
+	#clock-cells = <0>;
+};
+
+Example of consumer:
+
+uart@e1020000 {
+	compatible = "renesas,em-uart";
+	reg = <0xe1020000 0x38>;
+	interrupts = <0 8 0>;
+	clocks = <&usia_u0_sclk>;
+	clock-names = "sclk";
+};
+
+Example of clock-tree description:
+
+ This describes a clock path in the clock tree
+  c32ki -> pll3_fo -> usia_u0_sclkdiv -> usia_u0_sclk
+
+smu@e0110000 {
+	compatible = "renesas,emev2-smu";
+	reg = <0xe0110000 0x10000>;
+	#address-cells = <2>;
+	#size-cells = <0>;
+
+	c32ki: c32ki {
+		compatible = "fixed-clock";
+		clock-frequency = <32768>;
+		#clock-cells = <0>;
+	};
+	pll3_fo: pll3_fo {
+		compatible = "fixed-factor-clock";
+		clocks = <&c32ki>;
+		clock-div = <1>;
+		clock-mult = <7000>;
+		#clock-cells = <0>;
+	};
+	usia_u0_sclkdiv: usia_u0_sclkdiv {
+		compatible = "renesas,emev2-smu-clkdiv";
+		reg = <0x610 0>;
+		clocks = <&pll3_fo>;
+		#clock-cells = <0>;
+	};
+	usia_u0_sclk: usia_u0_sclk {
+		compatible = "renesas,emev2-smu-gclk";
+		reg = <0x4a0 1>;
+		clocks = <&usia_u0_sclkdiv>;
+		#clock-cells = <0>;
+	};
+};
diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index 7b11106..d25da26 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -32,6 +32,7 @@ obj-$(CONFIG_ARCH_VT8500)	+= clk-vt8500.o
 obj-$(CONFIG_ARCH_ZYNQ)		+= zynq/
 obj-$(CONFIG_ARCH_TEGRA)	+= tegra/
 obj-$(CONFIG_PLAT_SAMSUNG)	+= samsung/
+obj-$(CONFIG_ARCH_SHMOBILE_MULTI)	+= shmobile/
 
 obj-$(CONFIG_X86)		+= x86/
 
diff --git a/drivers/clk/shmobile/Makefile b/drivers/clk/shmobile/Makefile
new file mode 100644
index 0000000..2240730
--- /dev/null
+++ b/drivers/clk/shmobile/Makefile
@@ -0,0 +1,3 @@
+obj-$(CONFIG_ARCH_EMEV2)	+= clk-emev2.o
+# for emply built-in.o
+obj-n	:= dummy
diff --git a/drivers/clk/shmobile/clk-emev2.c b/drivers/clk/shmobile/clk-emev2.c
new file mode 100644
index 0000000..6c7c929
--- /dev/null
+++ b/drivers/clk/shmobile/clk-emev2.c
@@ -0,0 +1,104 @@
+/*
+ * EMMA Mobile EV2 common clock framework support
+ *
+ * Copyright (C) 2013 Takashi Yoshii <takashi.yoshii.ze@renesas.com>
+ * Copyright (C) 2012 Magnus Damm
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#include <linux/clk-provider.h>
+#include <linux/clkdev.h>
+#include <linux/io.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+
+/* EMEV2 SMU registers */
+#define USIAU0_RSTCTRL 0x094
+#define USIBU1_RSTCTRL 0x0ac
+#define USIBU2_RSTCTRL 0x0b0
+#define USIBU3_RSTCTRL 0x0b4
+#define STI_RSTCTRL 0x124
+#define STI_CLKSEL 0x688
+
+static DEFINE_SPINLOCK(lock);
+
+/* not pretty, but hey */
+void __iomem *smu_base;
+
+static void __init emev2_smu_write(unsigned long value, int offs)
+{
+	BUG_ON(!smu_base || (offs >= PAGE_SIZE));
+	writel_relaxed(value, smu_base + offs);
+}
+
+static const struct of_device_id smu_id[] __initconst = {
+	{ .compatible = "renesas,emev2-smu", },
+	{},
+};
+
+static void __init emev2_smu_init(void)
+{
+	struct device_node *np;
+
+	np = of_find_matching_node(NULL, smu_id);
+	BUG_ON(!np);
+	smu_base = of_iomap(np, 0);
+	BUG_ON(!smu_base);
+	of_node_put(np);
+
+	/* setup STI timer to run on 32.768 kHz and deassert reset */
+	emev2_smu_write(0, STI_CLKSEL);
+	emev2_smu_write(1, STI_RSTCTRL);
+
+	/* deassert reset for UART0->UART3 */
+	emev2_smu_write(2, USIAU0_RSTCTRL);
+	emev2_smu_write(2, USIBU1_RSTCTRL);
+	emev2_smu_write(2, USIBU2_RSTCTRL);
+	emev2_smu_write(2, USIBU3_RSTCTRL);
+}
+
+static void __init emev2_smu_clkdiv_init(struct device_node *np)
+{
+	u32 reg[2];
+	struct clk *clk;
+	const char *parent_name = of_clk_get_parent_name(np, 0);
+	if (WARN_ON(of_property_read_u32_array(np, "reg", reg, 2)))
+		return;
+	if (!smu_base)
+		emev2_smu_init();
+	clk = clk_register_divider(NULL, np->name, parent_name, 0,
+				   smu_base + reg[0], reg[1], 8, 0, &lock);
+	of_clk_add_provider(np, of_clk_src_simple_get, clk);
+	clk_register_clkdev(clk, np->name, NULL);
+	pr_debug("## %s %s %p\n", __func__, np->name, clk);
+}
+CLK_OF_DECLARE(emev2_smu_clkdiv, "renesas,emev2-smu-clkdiv",
+		emev2_smu_clkdiv_init);
+
+static void __init emev2_smu_gclk_init(struct device_node *np)
+{
+	u32 reg[2];
+	struct clk *clk;
+	const char *parent_name = of_clk_get_parent_name(np, 0);
+	if (WARN_ON(of_property_read_u32_array(np, "reg", reg, 2)))
+		return;
+	if (!smu_base)
+		emev2_smu_init();
+	clk = clk_register_gate(NULL, np->name, parent_name, 0,
+				smu_base + reg[0], reg[1], 0, &lock);
+	of_clk_add_provider(np, of_clk_src_simple_get, clk);
+	clk_register_clkdev(clk, np->name, NULL);
+	pr_debug("## %s %s %p\n", __func__, np->name, clk);
+}
+CLK_OF_DECLARE(emev2_smu_gclk, "renesas,emev2-smu-gclk", emev2_smu_gclk_init);
-- 
1.8.1.5
