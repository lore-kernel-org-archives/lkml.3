Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751223AbaB0P2b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 10:28:31 -0500
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:38705 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752831AbaB0P0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 10:26:49 -0500
From: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
To: mturquette@linaro.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rob@landley.net, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Lee Jones <lee.jones@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@st.com>,
        Pankaj Dev <pankaj.dev@st.com>
Subject: [PATCH v0 03/15] drivers: clk: st: Support for VCC-mux and MUX clocks
Date: Thu, 27 Feb 2014 16:24:16 +0100
Message-Id: <1393514668-17440-4-git-send-email-gabriel.fernandez@st.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393514668-17440-1-git-send-email-gabriel.fernandez@st.com>
References: <1393514668-17440-1-git-send-email-gabriel.fernandez@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch supports the VCC-mux and MUX clocks used by ClockGenC/F

VCC-mux clock : Divider-Multiplexer-Gate inside ClockGenC/F
It includes support for each channel : 4-parent Multiplexer, Post Divide
by 1, 2, 4 or 8, Gate to switch OFF the output channel. The clock is
implemented using generic clocks implemented in the kernel clk_divider, clk_mux,
clk_gate and clk_composite (to combine all)

MUX clock : 2-parent clock used inside ClockGenC/F. The clock is implemented
using generic clocks implemented in the kernel clk_mux.

Signed-off-by: Pankaj Dev <pankaj.dev@st.com>
Signed-off-by: Gabriel Fernandez <gabriel.fernandez@st.com>
---
 drivers/clk/st/clkgen-mux.c | 272 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 272 insertions(+)

diff --git a/drivers/clk/st/clkgen-mux.c b/drivers/clk/st/clkgen-mux.c
index 65d702c..7ccff62 100644
--- a/drivers/clk/st/clkgen-mux.c
+++ b/drivers/clk/st/clkgen-mux.c
@@ -18,6 +18,7 @@
 #include <linux/clk-provider.h>
 
 static DEFINE_SPINLOCK(clkgena_divmux_lock);
+static DEFINE_SPINLOCK(clkgenf_lock);
 
 static const char ** __init clkgen_mux_get_parents(struct device_node *np,
 						       int *num_parents)
@@ -527,3 +528,274 @@ void __init st_of_clkgena_prediv_setup(struct device_node *np)
 	return;
 }
 CLK_OF_DECLARE(clkgenaprediv, "st,clkgena-prediv", st_of_clkgena_prediv_setup);
+
+struct clkgen_mux_data {
+	u32 offset;
+	u8 shift;
+	u8 width;
+	spinlock_t *lock;
+	unsigned long clk_flags;
+	u8 mux_flags;
+};
+
+static struct clkgen_mux_data clkgen_mux_c_vcc_hd_416 = {
+	.offset = 0,
+	.shift = 0,
+	.width = 1,
+};
+
+static struct clkgen_mux_data clkgen_mux_f_vcc_fvdp_416 = {
+	.offset = 0,
+	.shift = 0,
+	.width = 1,
+};
+
+static struct clkgen_mux_data clkgen_mux_f_vcc_hva_416 = {
+	.offset = 0,
+	.shift = 0,
+	.width = 1,
+};
+
+static struct clkgen_mux_data clkgen_mux_f_vcc_hd_416 = {
+	.offset = 0,
+	.shift = 16,
+	.width = 1,
+	.lock = &clkgenf_lock,
+};
+
+static struct clkgen_mux_data clkgen_mux_c_vcc_sd_416 = {
+	.offset = 0,
+	.shift = 17,
+	.width = 1,
+	.lock = &clkgenf_lock,
+};
+
+static struct of_device_id mux_of_match[] = {
+	{
+		.compatible = "st,stih416-clkgenc-vcc-hd",
+		.data = &clkgen_mux_c_vcc_hd_416,
+	},
+	{
+		.compatible = "st,stih416-clkgenf-vcc-fvdp",
+		.data = &clkgen_mux_f_vcc_fvdp_416,
+	},
+	{
+		.compatible = "st,stih416-clkgenf-vcc-hva",
+		.data = &clkgen_mux_f_vcc_hva_416,
+	},
+	{
+		.compatible = "st,stih416-clkgenf-vcc-hd",
+		.data = &clkgen_mux_f_vcc_hd_416,
+	},
+	{
+		.compatible = "st,stih416-clkgenf-vcc-sd",
+		.data = &clkgen_mux_c_vcc_sd_416,
+	},
+	{}
+};
+
+void __init st_of_clkgen_mux_setup(struct device_node *np)
+{
+	const struct of_device_id *match;
+	struct clk *clk;
+	void __iomem *reg;
+	const char **parents;
+	int num_parents;
+	struct clkgen_mux_data *data;
+
+	match = of_match_node(mux_of_match, np);
+	if (!match) {
+		pr_err("%s: No matching data\n", __func__);
+		return;
+	}
+
+	data = (struct clkgen_mux_data *)match->data;
+
+	reg = of_iomap(np, 0);
+	if (!reg) {
+		pr_err("%s: Failed to get base address\n", __func__);
+		return;
+	}
+
+	parents = clkgen_mux_get_parents(np, &num_parents);
+	if (IS_ERR(parents)) {
+		pr_err("%s: Failed to get parents (%ld)\n",
+				__func__, PTR_ERR(parents));
+		return;
+	}
+
+	clk = clk_register_mux(NULL, np->name, parents, num_parents,
+				data->clk_flags | CLK_SET_RATE_PARENT,
+				reg + data->offset,
+				data->shift, data->width, data->mux_flags,
+				data->lock);
+	if (IS_ERR(clk))
+		goto err;
+
+	pr_debug("%s: parent %s rate %u\n",
+			__clk_get_name(clk),
+			__clk_get_name(clk_get_parent(clk)),
+			(unsigned int)clk_get_rate(clk));
+
+	of_clk_add_provider(np, of_clk_src_simple_get, clk);
+
+err:
+	kfree(parents);
+
+	return;
+}
+CLK_OF_DECLARE(clkgen_mux, "st,clkgen-mux", st_of_clkgen_mux_setup);
+
+#define VCC_MAX_CHANNELS 16
+
+#define VCC_GATE_OFFSET 0x0
+#define VCC_MUX_OFFSET 0x4
+#define VCC_DIV_OFFSET 0x8
+
+struct clkgen_vcc_data {
+	spinlock_t *lock;
+	unsigned long clk_flags;
+};
+
+static struct clkgen_vcc_data st_clkgenc_vcc_416 = {
+	.clk_flags = CLK_SET_RATE_PARENT,
+};
+
+static struct clkgen_vcc_data st_clkgenf_vcc_416 = {
+	.lock = &clkgenf_lock,
+};
+
+static struct of_device_id vcc_of_match[] = {
+	{ .compatible = "st,stih416-clkgenc", .data = &st_clkgenc_vcc_416 },
+	{ .compatible = "st,stih416-clkgenf", .data = &st_clkgenf_vcc_416 },
+	{}
+};
+
+void __init st_of_clkgen_vcc_setup(struct device_node *np)
+{
+	const struct of_device_id *match;
+	void __iomem *reg;
+	const char **parents;
+	int num_parents, i;
+	struct clk_onecell_data *clk_data;
+	struct clkgen_vcc_data *data;
+
+	match = of_match_node(vcc_of_match, np);
+	if (WARN_ON(!match))
+		return;
+	data = (struct clkgen_vcc_data *)match->data;
+
+	reg = of_iomap(np, 0);
+	if (!reg)
+		return;
+
+	parents = clkgen_mux_get_parents(np, &num_parents);
+	if (IS_ERR(parents))
+		return;
+
+	clk_data = kzalloc(sizeof(*clk_data), GFP_KERNEL);
+	if (!clk_data)
+		goto err;
+
+	clk_data->clk_num = VCC_MAX_CHANNELS;
+	clk_data->clks = kzalloc(clk_data->clk_num * sizeof(struct clk *),
+				 GFP_KERNEL);
+
+	if (!clk_data->clks)
+		goto err;
+
+	for (i = 0; i < clk_data->clk_num; i++) {
+		struct clk *clk;
+		const char *clk_name;
+		struct clk_gate *gate;
+		struct clk_divider *div;
+		struct clk_mux *mux;
+
+		if (of_property_read_string_index(np, "clock-output-names",
+						  i, &clk_name))
+			break;
+
+		/*
+		 * If we read an empty clock name then the output is unused
+		 */
+		if (*clk_name == '\0')
+			continue;
+
+		gate = kzalloc(sizeof(struct clk_gate), GFP_KERNEL);
+		if (!gate)
+			break;
+
+		div = kzalloc(sizeof(struct clk_divider), GFP_KERNEL);
+		if (!div) {
+			kfree(gate);
+			break;
+		}
+
+		mux = kzalloc(sizeof(struct clk_mux), GFP_KERNEL);
+		if (!mux) {
+			kfree(gate);
+			kfree(div);
+			break;
+		}
+
+		gate->reg = reg + VCC_GATE_OFFSET;
+		gate->bit_idx = i;
+		gate->flags = CLK_GATE_SET_TO_DISABLE;
+		gate->lock = data->lock;
+
+		div->reg = reg + VCC_DIV_OFFSET;
+		div->shift = 2 * i;
+		div->width = 2;
+		div->flags = CLK_DIVIDER_POWER_OF_TWO;
+
+		mux->reg = reg + VCC_MUX_OFFSET;
+		mux->shift = 2 * i;
+		mux->mask = 0x3;
+
+		clk = clk_register_composite(NULL, clk_name, parents,
+					     num_parents,
+					     &mux->hw, &clk_mux_ops,
+					     &div->hw, &clk_divider_ops,
+					     &gate->hw, &clk_gate_ops,
+					     data->clk_flags);
+		if (IS_ERR(clk)) {
+			kfree(gate);
+			kfree(div);
+			kfree(mux);
+			goto err;
+		}
+
+		pr_debug("%s: parent %s rate %u\n",
+			__clk_get_name(clk),
+			__clk_get_name(clk_get_parent(clk)),
+			(unsigned int)clk_get_rate(clk));
+
+		clk_data->clks[i] = clk;
+	}
+
+	kfree(parents);
+
+	of_clk_add_provider(np, of_clk_src_onecell_get, clk_data);
+	return;
+
+err:
+	for (i = 0; i < clk_data->clk_num; i++) {
+		struct clk_composite *composite;
+
+		if (!clk_data->clks[i])
+			continue;
+
+		composite = container_of(__clk_get_hw(clk_data->clks[i]),
+					 struct clk_composite, hw);
+		kfree(container_of(composite->gate_hw, struct clk_gate, hw));
+		kfree(container_of(composite->rate_hw, struct clk_divider, hw));
+		kfree(container_of(composite->mux_hw, struct clk_mux, hw));
+	}
+
+	if (clk_data)
+		kfree(clk_data->clks);
+
+	kfree(clk_data);
+	kfree(parents);
+}
+CLK_OF_DECLARE(clkgen_vcc, "st,clkgen-vcc", st_of_clkgen_vcc_setup);
-- 
1.9.0

