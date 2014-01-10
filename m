Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060AbaAJHCj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 02:02:39 -0500
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:34870 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbaAJHAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 02:00:24 -0500
From: Chen-Yu Tsai <wens@csie.org>
To: Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Chen-Yu Tsai <wens@csie.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH v2 09/16] clk: sunxi: Add Allwinner A20/A31 GMAC clock unit
Date: Fri, 10 Jan 2014 15:00:10 +0800
Message-Id: <1389337217-29032-10-git-send-email-wens@csie.org>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1389337217-29032-1-git-send-email-wens@csie.org>
References: <1389337217-29032-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Allwinner A20/A31 clock module controls the transmit clock source
and interface type of the GMAC ethernet controller. Model this as
a single clock for GMAC drivers to use.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 Documentation/devicetree/bindings/clock/sunxi.txt | 26 ++++++++
 drivers/clk/sunxi/clk-sunxi.c                     | 74 +++++++++++++++++++++++
 2 files changed, 100 insertions(+)

diff --git a/Documentation/devicetree/bindings/clock/sunxi.txt b/Documentation/devicetree/bindings/clock/sunxi.txt
index 8a9147d..a1fbf53 100644
--- a/Documentation/devicetree/bindings/clock/sunxi.txt
+++ b/Documentation/devicetree/bindings/clock/sunxi.txt
@@ -37,6 +37,7 @@ Required properties:
 	"allwinner,sun6i-a31-apb2-gates-clk" - for the APB2 gates on A31
 	"allwinner,sun4i-mod0-clk" - for the module 0 family of clocks
 	"allwinner,sun7i-a20-out-clk" - for the external output clocks on A20
+	"allwinner,sun7i-a20-gmac-clk" - for the GMAC clock module on A20/A31
 
 Required properties for all clocks:
 - reg : shall be the control register address for the clock.
@@ -57,6 +58,9 @@ Additionally, most clocks require "clock-output-names":
   do not need "clock-output-names"
 - all others clocks : the corresponding module name of that clock
 
+For "allwinner,sun7i-a20-gmac-clk", the parent clocks shall be fixed rate
+dummy clocks at 25 MHz and 125 MHz, respectively. See example.
+
 Clock consumers should specify the desired clocks they use with a
 "clocks" phandle cell. Consumers that are using a gated clock should
 provide an additional ID in their clock property. This ID is the
@@ -102,3 +106,25 @@ mmc0_clk: clk@01c20088 {
 	clocks = <&osc24M>, <&pll6 1>, <&pll5 1>;
 	clock-output-names = "mmc0";
 };
+
+mii_phy_tx_clk: clk@2 {
+	#clock-cells = <0>;
+	compatible = "fixed-clock";
+	clock-frequency = <25000000>;
+	clock-output-names = "mii_phy_tx";
+};
+
+gmac_int_tx_clk: clk@3 {
+	#clock-cells = <0>;
+	compatible = "fixed-clock";
+	clock-frequency = <125000000>;
+	clock-output-names = "gmac_int_tx";
+};
+
+gmac_clk: clk@01c20164 {
+	#clock-cells = <0>;
+	compatible = "allwinner,sun7i-a20-gmac-clk";
+	reg = <0x01c20164 0x4>;
+	clocks = <&mii_phy_tx_clk>, <&gmac_int_tx_clk>;
+	clock-output-names = "gmac";
+};
diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi.c
index a741683..2ae2300 100644
--- a/drivers/clk/sunxi/clk-sunxi.c
+++ b/drivers/clk/sunxi/clk-sunxi.c
@@ -373,6 +373,80 @@ static void sun7i_a20_get_out_factors(u32 *freq, u32 parent_rate,
 
 
 /**
+ * sun7i_a20_gmac_clk_setup - Setup function for A20/A31 GMAC clock module
+ *
+ * This clock looks something like this
+ *                               ________________________
+ *  MII TX clock from PHY >-----|___________    _________|----> to GMAC core
+ *  GMAC Int. RGMII TX clk >----|___________\__/__gate---|----> to PHY
+ *  Ext. 125MHz RGMII TX clk >--|__divider__/            |
+ *                              |________________________|
+ *
+ * The external 125 MHz reference is optional, i.e. GMAC can use its
+ * internal TX clock just fine. The A31 GMAC clock module does not have
+ * the divider controls for the external reference.
+ *
+ * To keep it simple, let the GMAC use either the MII TX clock for MII mode,
+ * and its internal TX clock for GMII and RGMII modes. The GMAC driver should
+ * select the appropriate source and gate/ungate the output to the PHY.
+ */
+
+#define SUN7I_A20_GMAC_GPIT	2
+#define SUN7I_A20_GMAC_MASK	0x3
+
+static void __init sun7i_a20_gmac_clk_setup(struct device_node *node)
+{
+	struct clk *clk;
+	struct clk_mux *mux;
+	struct clk_gate *gate;
+	const char *clk_name = node->name;
+	const char *parents[2];
+	void *reg;
+	int i = 0;
+
+	/* allocate mux and gate clock structs */
+	mux = kzalloc(sizeof(struct clk_mux), GFP_KERNEL);
+	if (!mux)
+		return;
+	gate = kzalloc(sizeof(struct clk_gate), GFP_KERNEL);
+	if (!gate) {
+		kfree(mux);
+		return;
+	}
+
+	reg = of_iomap(node, 0);
+
+	of_property_read_string(node, "clock-output-names", &clk_name);
+
+	while (i < 2 && (parents[i] = of_clk_get_parent_name(node, i)) != NULL)
+		i++;
+
+	/* set up gate and fixed rate properties */
+	gate->reg = reg;
+	gate->bit_idx = SUN7I_A20_GMAC_GPIT;
+	gate->lock = &clk_lock;
+	mux->reg = reg;
+	mux->mask = SUN7I_A20_GMAC_MASK;
+	mux->flags = CLK_MUX_INDEX_BIT;
+	mux->lock = &clk_lock;
+
+	clk = clk_register_composite(NULL, clk_name,
+			parents, i,
+			&mux->hw, &clk_mux_ops,
+			NULL, NULL,
+			&gate->hw, &clk_gate_ops,
+			CLK_SET_PARENT_GATE);
+
+	if (!IS_ERR(clk)) {
+		of_clk_add_provider(node, of_clk_src_simple_get, clk);
+		clk_register_clkdev(clk, clk_name, NULL);
+	}
+}
+CLK_OF_DECLARE(sun7i_a20_gmac, "allwinner,sun7i-a20-gmac-clk", sun7i_a20_gmac_clk_setup);
+
+
+
+/**
  * sunxi_factors_clk_setup() - Setup function for factor clocks
  */
 
-- 
1.8.5.2

