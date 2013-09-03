Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932864Ab3ICNcn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 09:32:43 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:17688 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759959Ab3ICNcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 09:32:41 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 03 Sep 2013 06:32:40 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: <linux-tegra@vger.kernel.org>, Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>, Joseph Lo <josephl@nvidia.com>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] clk: tegra114: table driven audio clock init
Date: Tue, 3 Sep 2013 16:31:33 +0300
Message-ID: <1378215105-12145-4-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1378215105-12145-1-git-send-email-pdeschrijver@nvidia.com>
References: <1378215105-12145-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the Tegra114 audio clock registration to be table driven
like the periph clocks.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/clk-tegra114.c |  262 +++++++++++---------------------------
 drivers/clk/tegra/clk.h          |   73 +++++++++++
 2 files changed, 150 insertions(+), 185 deletions(-)

diff --git a/drivers/clk/tegra/clk-tegra114.c b/drivers/clk/tegra/clk-tegra114.c
index 9100e62..9f8d534 100644
--- a/drivers/clk/tegra/clk-tegra114.c
+++ b/drivers/clk/tegra/clk-tegra114.c
@@ -1500,195 +1500,87 @@ static const char *clk_out3_parents[] = { "clk_m", "clk_m_div2",
 	"clk_m_div4", "extern3",
 };
 
+static struct tegra_sync_source_initdata __initdata sync_source_clks[] = {
+	{ .name = "spdif_in_sync", .rate = 24000000, .max_rate = 24000000, .clk_id = TEGRA114_CLK_SPDIF_IN_SYNC},
+	{ .name = "i2s0_sync", .rate = 24000000, .max_rate = 24000000, .clk_id = TEGRA114_CLK_I2S0_SYNC},
+	{ .name = "i2s1_sync", .rate = 24000000, .max_rate = 24000000, .clk_id = TEGRA114_CLK_I2S1_SYNC},
+	{ .name = "i2s2_sync", .rate = 24000000, .max_rate = 24000000, .clk_id = TEGRA114_CLK_I2S2_SYNC},
+	{ .name = "i2s3_sync", .rate = 24000000, .max_rate = 24000000, .clk_id = TEGRA114_CLK_I2S3_SYNC},
+	{ .name = "i2s4_sync", .rate = 24000000, .max_rate = 24000000, .clk_id = TEGRA114_CLK_I2S4_SYNC},
+	{ .name = "vimclk_sync", .rate = 24000000, .max_rate = 24000000, .clk_id = TEGRA114_CLK_VIMCLK_SYNC},
+};
+
+static struct tegra_audio_clk_initdata audio_clks[] = {
+	TEGRA_INIT_AUDIO("audio0", mux_audio_sync_clk, AUDIO_SYNC_CLK_I2S0, TEGRA114_CLK_AUDIO0),
+	TEGRA_INIT_AUDIO("audio1", mux_audio_sync_clk, AUDIO_SYNC_CLK_I2S1, TEGRA114_CLK_AUDIO1),
+	TEGRA_INIT_AUDIO("audio2", mux_audio_sync_clk, AUDIO_SYNC_CLK_I2S2, TEGRA114_CLK_AUDIO2),
+	TEGRA_INIT_AUDIO("audio3", mux_audio_sync_clk, AUDIO_SYNC_CLK_I2S3, TEGRA114_CLK_AUDIO3),
+	TEGRA_INIT_AUDIO("audio4", mux_audio_sync_clk, AUDIO_SYNC_CLK_I2S4, TEGRA114_CLK_AUDIO4),
+	TEGRA_INIT_AUDIO("spdif", mux_audio_sync_clk, AUDIO_SYNC_CLK_SPDIF, TEGRA114_CLK_SPDIF),
+};
+
+static struct tegra_audio2x_clk_initdata audio2x_clks[] = {
+	TEGRA_INIT_AUDIO2X("audio0", TEGRA114_CLK_AUDIO0_2X, 113, 24),
+	TEGRA_INIT_AUDIO2X("audio1", TEGRA114_CLK_AUDIO1_2X, 114, 25),
+	TEGRA_INIT_AUDIO2X("audio2", TEGRA114_CLK_AUDIO2_2X, 115, 26),
+	TEGRA_INIT_AUDIO2X("audio3", TEGRA114_CLK_AUDIO3_2X, 116, 27),
+	TEGRA_INIT_AUDIO2X("audio4", TEGRA114_CLK_AUDIO4_2X, 117, 28),
+	TEGRA_INIT_AUDIO2X("spdif", TEGRA114_CLK_SPDIF_2X, 118, 29),
+};
+
 static void __init tegra114_audio_clk_init(void __iomem *clk_base)
 {
 	struct clk *clk;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(sync_source_clks); i++) {
+		struct tegra_sync_source_initdata *data;
+
+		data = &sync_source_clks[i];
+		clk = tegra_clk_register_sync_source(data->name, data->rate,
+							data->max_rate);
+		clks[data->clk_id] = clk;
+		clk_register_clkdev(clk, data->name, NULL);
+	}
+
+	for (i = 0; i < ARRAY_SIZE(audio_clks); i++) {
+		struct tegra_audio_clk_initdata *data;
+
+		data = &audio_clks[i];
+		clk = clk_register_mux(NULL, data->mux_name, data->parents,
+					data->num_parents, 0,
+					clk_base + data->offset, 0, 3, 0,
+					NULL);
+		clks[data->mux_clk_id] = clk;
+
+		clk = clk_register_gate(NULL, data->gate_name, data->mux_name,
+					0, clk_base + data->offset, 4,
+					CLK_GATE_SET_TO_DISABLE, NULL);
+		clk_register_clkdev(clk, data->gate_name, NULL);
+		clks[data->gate_clk_id] = clk;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(audio2x_clks); i++) {
+		struct tegra_audio2x_clk_initdata *data;
+		int reg_bank;
 
-	/* spdif_in_sync */
-	clk = tegra_clk_register_sync_source("spdif_in_sync", 24000000,
-					     24000000);
-	clk_register_clkdev(clk, "spdif_in_sync", NULL);
-	clks[TEGRA114_CLK_SPDIF_IN_SYNC] = clk;
-
-	/* i2s0_sync */
-	clk = tegra_clk_register_sync_source("i2s0_sync", 24000000, 24000000);
-	clk_register_clkdev(clk, "i2s0_sync", NULL);
-	clks[TEGRA114_CLK_I2S0_SYNC] = clk;
-
-	/* i2s1_sync */
-	clk = tegra_clk_register_sync_source("i2s1_sync", 24000000, 24000000);
-	clk_register_clkdev(clk, "i2s1_sync", NULL);
-	clks[TEGRA114_CLK_I2S1_SYNC] = clk;
-
-	/* i2s2_sync */
-	clk = tegra_clk_register_sync_source("i2s2_sync", 24000000, 24000000);
-	clk_register_clkdev(clk, "i2s2_sync", NULL);
-	clks[TEGRA114_CLK_I2S2_SYNC] = clk;
-
-	/* i2s3_sync */
-	clk = tegra_clk_register_sync_source("i2s3_sync", 24000000, 24000000);
-	clk_register_clkdev(clk, "i2s3_sync", NULL);
-	clks[TEGRA114_CLK_I2S3_SYNC] = clk;
-
-	/* i2s4_sync */
-	clk = tegra_clk_register_sync_source("i2s4_sync", 24000000, 24000000);
-	clk_register_clkdev(clk, "i2s4_sync", NULL);
-	clks[TEGRA114_CLK_I2S4_SYNC] = clk;
-
-	/* vimclk_sync */
-	clk = tegra_clk_register_sync_source("vimclk_sync", 24000000, 24000000);
-	clk_register_clkdev(clk, "vimclk_sync", NULL);
-	clks[TEGRA114_CLK_VIMCLK_SYNC] = clk;
-
-	/* audio0 */
-	clk = clk_register_mux(NULL, "audio0_mux", mux_audio_sync_clk,
-			       ARRAY_SIZE(mux_audio_sync_clk), 0,
-			       clk_base + AUDIO_SYNC_CLK_I2S0, 0, 3, 0,
-			       NULL);
-	clks[TEGRA114_CLK_AUDIO0_MUX] = clk;
-	clk = clk_register_gate(NULL, "audio0", "audio0_mux", 0,
-				clk_base + AUDIO_SYNC_CLK_I2S0, 4,
-				CLK_GATE_SET_TO_DISABLE, NULL);
-	clk_register_clkdev(clk, "audio0", NULL);
-	clks[TEGRA114_CLK_AUDIO0] = clk;
-
-	/* audio1 */
-	clk = clk_register_mux(NULL, "audio1_mux", mux_audio_sync_clk,
-			       ARRAY_SIZE(mux_audio_sync_clk), 0,
-			       clk_base + AUDIO_SYNC_CLK_I2S1, 0, 3, 0,
-			       NULL);
-	clks[TEGRA114_CLK_AUDIO1_MUX] = clk;
-	clk = clk_register_gate(NULL, "audio1", "audio1_mux", 0,
-				clk_base + AUDIO_SYNC_CLK_I2S1, 4,
-				CLK_GATE_SET_TO_DISABLE, NULL);
-	clk_register_clkdev(clk, "audio1", NULL);
-	clks[TEGRA114_CLK_AUDIO1] = clk;
-
-	/* audio2 */
-	clk = clk_register_mux(NULL, "audio2_mux", mux_audio_sync_clk,
-			       ARRAY_SIZE(mux_audio_sync_clk), 0,
-			       clk_base + AUDIO_SYNC_CLK_I2S2, 0, 3, 0,
-			       NULL);
-	clks[TEGRA114_CLK_AUDIO2_MUX] = clk;
-	clk = clk_register_gate(NULL, "audio2", "audio2_mux", 0,
-				clk_base + AUDIO_SYNC_CLK_I2S2, 4,
-				CLK_GATE_SET_TO_DISABLE, NULL);
-	clk_register_clkdev(clk, "audio2", NULL);
-	clks[TEGRA114_CLK_AUDIO2] = clk;
-
-	/* audio3 */
-	clk = clk_register_mux(NULL, "audio3_mux", mux_audio_sync_clk,
-			       ARRAY_SIZE(mux_audio_sync_clk), 0,
-			       clk_base + AUDIO_SYNC_CLK_I2S3, 0, 3, 0,
-			       NULL);
-	clks[TEGRA114_CLK_AUDIO3_MUX] = clk;
-	clk = clk_register_gate(NULL, "audio3", "audio3_mux", 0,
-				clk_base + AUDIO_SYNC_CLK_I2S3, 4,
-				CLK_GATE_SET_TO_DISABLE, NULL);
-	clk_register_clkdev(clk, "audio3", NULL);
-	clks[TEGRA114_CLK_AUDIO3] = clk;
-
-	/* audio4 */
-	clk = clk_register_mux(NULL, "audio4_mux", mux_audio_sync_clk,
-			       ARRAY_SIZE(mux_audio_sync_clk), 0,
-			       clk_base + AUDIO_SYNC_CLK_I2S4, 0, 3, 0,
-			       NULL);
-	clks[TEGRA114_CLK_AUDIO4_MUX] = clk;
-	clk = clk_register_gate(NULL, "audio4", "audio4_mux", 0,
-				clk_base + AUDIO_SYNC_CLK_I2S4, 4,
-				CLK_GATE_SET_TO_DISABLE, NULL);
-	clk_register_clkdev(clk, "audio4", NULL);
-	clks[TEGRA114_CLK_AUDIO4] = clk;
-
-	/* spdif */
-	clk = clk_register_mux(NULL, "spdif_mux", mux_audio_sync_clk,
-			       ARRAY_SIZE(mux_audio_sync_clk), 0,
-			       clk_base + AUDIO_SYNC_CLK_SPDIF, 0, 3, 0,
-			       NULL);
-	clks[TEGRA114_CLK_SPDIF_MUX] = clk;
-	clk = clk_register_gate(NULL, "spdif", "spdif_mux", 0,
-				clk_base + AUDIO_SYNC_CLK_SPDIF, 4,
-				CLK_GATE_SET_TO_DISABLE, NULL);
-	clk_register_clkdev(clk, "spdif", NULL);
-	clks[TEGRA114_CLK_SPDIF] = clk;
-
-	/* audio0_2x */
-	clk = clk_register_fixed_factor(NULL, "audio0_doubler", "audio0",
-					CLK_SET_RATE_PARENT, 2, 1);
-	clk = tegra_clk_register_divider("audio0_div", "audio0_doubler",
-				clk_base + AUDIO_SYNC_DOUBLER, 0, 0, 24, 1,
-				0, &clk_doubler_lock);
-	clk = tegra_clk_register_periph_gate("audio0_2x", "audio0_div",
-				  TEGRA_PERIPH_NO_RESET, clk_base,
-				  CLK_SET_RATE_PARENT, 113, &periph_regs[113 / 32],
-				  periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "audio0_2x", NULL);
-	clks[TEGRA114_CLK_AUDIO0_2X] = clk;
-
-	/* audio1_2x */
-	clk = clk_register_fixed_factor(NULL, "audio1_doubler", "audio1",
-					CLK_SET_RATE_PARENT, 2, 1);
-	clk = tegra_clk_register_divider("audio1_div", "audio1_doubler",
-				clk_base + AUDIO_SYNC_DOUBLER, 0, 0, 25, 1,
-				0, &clk_doubler_lock);
-	clk = tegra_clk_register_periph_gate("audio1_2x", "audio1_div",
-				  TEGRA_PERIPH_NO_RESET, clk_base,
-				  CLK_SET_RATE_PARENT, 114, &periph_regs[114 / 32],
-				  periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "audio1_2x", NULL);
-	clks[TEGRA114_CLK_AUDIO1_2X] = clk;
-
-	/* audio2_2x */
-	clk = clk_register_fixed_factor(NULL, "audio2_doubler", "audio2",
-					CLK_SET_RATE_PARENT, 2, 1);
-	clk = tegra_clk_register_divider("audio2_div", "audio2_doubler",
-				clk_base + AUDIO_SYNC_DOUBLER, 0, 0, 26, 1,
-				0, &clk_doubler_lock);
-	clk = tegra_clk_register_periph_gate("audio2_2x", "audio2_div",
-				  TEGRA_PERIPH_NO_RESET, clk_base,
-				  CLK_SET_RATE_PARENT, 115, &periph_regs[115 / 32],
-				  periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "audio2_2x", NULL);
-	clks[TEGRA114_CLK_AUDIO2_2X] = clk;
-
-	/* audio3_2x */
-	clk = clk_register_fixed_factor(NULL, "audio3_doubler", "audio3",
-					CLK_SET_RATE_PARENT, 2, 1);
-	clk = tegra_clk_register_divider("audio3_div", "audio3_doubler",
-				clk_base + AUDIO_SYNC_DOUBLER, 0, 0, 27, 1,
-				0, &clk_doubler_lock);
-	clk = tegra_clk_register_periph_gate("audio3_2x", "audio3_div",
-				  TEGRA_PERIPH_NO_RESET, clk_base,
-				  CLK_SET_RATE_PARENT, 116, &periph_regs[116 / 32],
-				  periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "audio3_2x", NULL);
-	clks[TEGRA114_CLK_AUDIO3_2X] = clk;
-
-	/* audio4_2x */
-	clk = clk_register_fixed_factor(NULL, "audio4_doubler", "audio4",
-					CLK_SET_RATE_PARENT, 2, 1);
-	clk = tegra_clk_register_divider("audio4_div", "audio4_doubler",
-				clk_base + AUDIO_SYNC_DOUBLER, 0, 0, 28, 1,
-				0, &clk_doubler_lock);
-	clk = tegra_clk_register_periph_gate("audio4_2x", "audio4_div",
-				  TEGRA_PERIPH_NO_RESET, clk_base,
-				  CLK_SET_RATE_PARENT, 117, &periph_regs[117 / 32],
-				  periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "audio4_2x", NULL);
-	clks[TEGRA114_CLK_AUDIO4_2X] = clk;
-
-	/* spdif_2x */
-	clk = clk_register_fixed_factor(NULL, "spdif_doubler", "spdif",
-					CLK_SET_RATE_PARENT, 2, 1);
-	clk = tegra_clk_register_divider("spdif_div", "spdif_doubler",
-				clk_base + AUDIO_SYNC_DOUBLER, 0, 0, 29, 1,
-				0, &clk_doubler_lock);
-	clk = tegra_clk_register_periph_gate("spdif_2x", "spdif_div",
-				  TEGRA_PERIPH_NO_RESET, clk_base,
-				  CLK_SET_RATE_PARENT, 118,
-				  &periph_regs[118 / 32], periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "spdif_2x", NULL);
-	clks[TEGRA114_CLK_SPDIF_2X] = clk;
+		data = &audio2x_clks[i];
+		reg_bank = get_reg_bank(data->clk_num);
+		if (reg_bank >= 0) {
+			clk = clk_register_fixed_factor(NULL, data->name_2x,
+				data->parent, CLK_SET_RATE_PARENT, 2, 1);
+			clk = tegra_clk_register_divider(data->div_name,
+					data->name_2x,
+					clk_base + AUDIO_SYNC_DOUBLER, 0, 0,
+					data->div_offset, 1, 0,
+					&clk_doubler_lock);
+			clk = tegra_clk_register_periph_gate(data->gate_name,
+					data->div_name, TEGRA_PERIPH_NO_RESET,
+					clk_base, CLK_SET_RATE_PARENT,
+					data->clk_num, &periph_regs[reg_bank],
+					periph_clk_enb_refcnt);
+		}
+	}
 }
 
 static void __init tegra114_pmc_clk_init(void __iomem *pmc_base)
diff --git a/drivers/clk/tegra/clk.h b/drivers/clk/tegra/clk.h
index 3a8e168..262ed2b 100644
--- a/drivers/clk/tegra/clk.h
+++ b/drivers/clk/tegra/clk.h
@@ -40,6 +40,79 @@ extern const struct clk_ops tegra_clk_sync_source_ops;
 struct clk *tegra_clk_register_sync_source(const char *name,
 		unsigned long fixed_rate, unsigned long max_rate);
 
+struct tegra_sync_source_initdata {
+	char		*name;
+	unsigned long	rate;
+	unsigned long	max_rate;
+	int		clk_id;
+};
+
+struct tegra_audio_clk_initdata {
+	char		*gate_name;
+	char		*mux_name;
+	const char	**parents;
+	int		num_parents;
+	u32		offset;
+	int		gate_clk_id;
+	int		mux_clk_id;
+};
+
+#define TEGRA_INIT_AUDIO(_name, _parents, _offset, _id) \
+	{\
+		.gate_name	= _name,\
+		.mux_name	= _name"_mux",\
+		.parents	= _parents,\
+		.num_parents	= ARRAY_SIZE(_parents),\
+		.offset		= _offset,\
+		.gate_clk_id	= _id,\
+		.mux_clk_id	= _id ## _MUX,\
+	}
+
+struct tegra_audio2x_clk_initdata {
+	char		*parent;
+	char		*gate_name;
+	char		*name_2x;
+	char		*div_name;
+	int		clk_id;
+	int		clk_num;
+	u8		div_offset;
+};
+
+#define TEGRA_INIT_AUDIO2X(_name, _id, _num, _offset) \
+	{\
+		.parent		= _name,\
+		.gate_name	= _name"_2x",\
+		.name_2x	= _name"_doubler",\
+		.div_name	= _name"_div",\
+		.clk_id		= _id,\
+		.clk_num	= _num,\
+	}
+
+struct pmc_clk_init_data {
+	char		*mux_name;
+	char		*gate_name;
+	char		*dev_name;
+	const char	**parents;
+	int		num_parents;
+	int		mux_id;
+	int		gate_id;
+	u8		mux_shift;
+	u8		gate_shift;
+};
+
+#define TEGRA_INIT_PMC_CLK(_name, _dev_name, _parents, _mux_shift, _gate_shift, _id) \
+	{\
+		.mux_name	= _name"_mux",\
+		.gate_name	= _name,\
+		.parents	= _parents,\
+		.num_parents	= ARRAY_SIZE(_parents),\
+		.mux_id		= _id##_MUX,\
+		.gate_id	= _id,\
+		.dev_name	= _dev_name,\
+		.mux_shift	= _mux_shift,\
+		.gate_shift	= _gate_shift,\
+	}
+
 /**
  * struct tegra_clk_frac_div - fractional divider clock
  *
-- 
1.7.7.rc0.72.g4b5ea.dirty

