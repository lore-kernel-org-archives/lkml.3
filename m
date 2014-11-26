Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149AbaKZO1H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 09:27:07 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:44757 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaKZOYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 09:24:42 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-08-5475e2a77055
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Mike Turquette <mturquette@linaro.org>, Kukjin Kim <kgene@kernel.org>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, linux-gpio@vger.kernel.org,
        devicetree@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Kevin Hilman <khilman@kernel.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v2 2/5] clk: samsung: Fix clock disable failure because domain
 being gated
Date: Wed, 26 Nov 2014 15:24:14 +0100
Message-id: <1417011857-10419-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1417011857-10419-1-git-send-email-k.kozlowski@samsung.com>
References: <1417011857-10419-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHLMWRmVeSWpSXmKPExsVy+t/xK7rLH5WGGKxfpmKxccZ6Vov5R86x
	WrRdOchucfR3gcXrF4YW/Y9fM1s83fyYyeJs0xt2iyl/ljNZbHp8jdVi8/w/jBaXd81hs5hx
	fh+Txe3LvBZrj9xlt3g64SKbxeE37awWx2YsYbRYtesPo4OwR0tzD5vH3+fXWTx2zrrL7rFp
	VSebx51re9g8Ni+p9+jbsorR4/MmuQCOKC6blNSczLLUIn27BK6MCfN7mAqWp1Z83fGZvYFx
	RnAXIyeHhICJxJ++lewQtpjEhXvr2boYuTiEBJYyStzZew3K6WOSePhuCRtIFZuAscTm5UvA
	EiICK1gkdi36xQziMAu8Y5RYf2Y9C0iVsECMxJXLj8FsFgFViS17G4FsDg5eAXeJxQfrIdbJ
	SZw8NpkVxOYU8JBoe3+eGcQWAir5vu8w4wRG3gWMDKsYRVNLkwuKk9JzjfSKE3OLS/PS9ZLz
	czcxQsL86w7GpcesDjEKcDAq8fDeiCsJEWJNLCuuzD3EKMHBrCTCm3qnNESINyWxsiq1KD++
	qDQntfgQIxMHp1QDo3AG2x3H2yXhh9frvb/odUFe+QDTvECh78XBdzc84c/6tr1+6ZK9O9vs
	39xKj5rwr/bs4+tC9ge/WR62nXJ61pE5Lj5OASZrjqz9xmVq8afoMke5hPYiZeNP3KJdNjP/
	6U9VPL6h1+TO3eN9B+rzMhpara/VcvlbhjFMOCxp8Je3QHvhhaAuTiWW4oxEQy3mouJEABUm
	QNRRAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Audio subsystem clocks are located in separate block. If clock for this
block (from main clock domain) 'mau_epll' is gated then any read or
write to audss registers will block.

This was observed on Exynos 5420 platforms (Arndale Octa and Peach
Pi/Pit) after introducing runtime PM to pl330 DMA driver. After that
commit the 'mau_epll' was gated, because the "amba" clock was disabled
and there were no more users of mau_epll. The system hang on disabling
unused clocks from audss block.

Unfortunately the 'mau_epll' clock is not parent of some of audss clocks.

Whenever system wants to operate on audss clocks it has to enable epll
clock. The solution reuses common clk-gate/divider/mux code and duplicates
clk_register_*() functions. In the same time the patch tries to limit
functional changes of the driver so it does not fix minor issues with existing
code (like leaking memory allocated for clk-gate/clk-mux/clk-divider code).
This is addressed later.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Reported-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Reported-by: Kevin Hilman <khilman@kernel.org>
---
 drivers/clk/samsung/clk-exynos-audss.c | 346 +++++++++++++++++++++++++++++----
 1 file changed, 311 insertions(+), 35 deletions(-)

diff --git a/drivers/clk/samsung/clk-exynos-audss.c b/drivers/clk/samsung/clk-exynos-audss.c
index 7c4368e75ede..9ec7de866ab4 100644
--- a/drivers/clk/samsung/clk-exynos-audss.c
+++ b/drivers/clk/samsung/clk-exynos-audss.c
@@ -29,6 +29,7 @@ static DEFINE_SPINLOCK(lock);
 static struct clk **clk_table;
 static void __iomem *reg_base;
 static struct clk_onecell_data clk_data;
+static struct clk *pll_in;
 
 #define ASS_CLK_SRC 0x0
 #define ASS_CLK_DIV 0x4
@@ -75,6 +76,276 @@ static const struct of_device_id exynos_audss_clk_of_match[] = {
 	{},
 };
 
+static int pll_clk_enable(void)
+{
+	if (!IS_ERR(pll_in))
+		return clk_enable(pll_in);
+
+	return 0;
+}
+
+static void pll_clk_disable(void)
+{
+	if (!IS_ERR(pll_in))
+		clk_disable(pll_in);
+}
+
+static int audss_clk_gate_enable(struct clk_hw *hw)
+{
+	int ret;
+
+	ret = pll_clk_enable();
+	if (ret)
+		return ret;
+
+	ret = clk_gate_ops.enable(hw);
+
+	pll_clk_disable();
+
+	return ret;
+}
+
+static void audss_clk_gate_disable(struct clk_hw *hw)
+{
+	int ret;
+
+	ret = pll_clk_enable();
+	if (ret)
+		return;
+
+	clk_gate_ops.disable(hw);
+
+	pll_clk_disable();
+}
+
+static int audss_clk_gate_is_enabled(struct clk_hw *hw)
+{
+	int ret;
+
+	ret = pll_clk_enable();
+	if (ret)
+		return ret;
+
+	ret = clk_gate_ops.is_enabled(hw);
+
+	pll_clk_disable();
+
+	return ret;
+}
+
+static const struct clk_ops audss_clk_gate_ops = {
+	.enable = audss_clk_gate_enable,
+	.disable = audss_clk_gate_disable,
+	.is_enabled = audss_clk_gate_is_enabled,
+};
+
+/*
+ * A simplified copy of clk-gate.c:clk_register_gate() to mimic
+ * clk-gate behavior while using customized ops.
+ *
+ * TODO: just like clk-gate it leaks memory for struct clk_gate.
+ */
+static struct clk *audss_clk_register_gate(struct device *dev, const char *name,
+		const char *parent_name, unsigned long flags, u8 bit_idx)
+{
+	struct clk_gate *gate;
+	struct clk *clk;
+	struct clk_init_data init;
+
+	/* allocate the gate */
+	gate = kzalloc(sizeof(struct clk_gate), GFP_KERNEL);
+	if (!gate)
+		return ERR_PTR(-ENOMEM);
+
+	init.name = name;
+	init.ops = &audss_clk_gate_ops;
+	init.flags = flags | CLK_IS_BASIC;
+	init.parent_names = (parent_name ? &parent_name : NULL);
+	init.num_parents = (parent_name ? 1 : 0);
+
+	/* struct clk_gate assignments */
+	gate->reg = reg_base + ASS_CLK_GATE;
+	gate->bit_idx = bit_idx;
+	gate->flags = 0;
+	gate->lock = &lock;
+	gate->hw.init = &init;
+
+	clk = clk_register(dev, &gate->hw);
+
+	if (IS_ERR(clk))
+		kfree(gate);
+
+	return clk;
+}
+
+static unsigned long audss_clk_divider_recalc_rate(struct clk_hw *hw,
+		unsigned long parent_rate)
+{
+	unsigned long ret;
+
+	ret = pll_clk_enable();
+	if (ret) {
+		WARN(ret, "Could not enable pll_in clock\n");
+		return parent_rate;
+	}
+
+	ret = clk_divider_ops.recalc_rate(hw, parent_rate);
+
+	pll_clk_disable();
+
+	return ret;
+}
+
+static long audss_clk_divider_round_rate(struct clk_hw *hw, unsigned long rate,
+				unsigned long *prate)
+{
+	return clk_divider_ops.round_rate(hw, rate, prate);
+}
+
+static int audss_clk_divider_set_rate(struct clk_hw *hw, unsigned long rate,
+				unsigned long parent_rate)
+{
+	int ret;
+
+	ret = pll_clk_enable();
+	if (ret)
+		return ret;
+
+	ret = clk_divider_ops.set_rate(hw, rate, parent_rate);
+
+	pll_clk_disable();
+
+	return ret;
+}
+
+static const struct clk_ops audss_clk_divider_ops = {
+	.recalc_rate = audss_clk_divider_recalc_rate,
+	.round_rate = audss_clk_divider_round_rate,
+	.set_rate = audss_clk_divider_set_rate,
+};
+
+/*
+ * A simplified copy of clk-divider.c:clk_register_divider() to mimic
+ * clk-divider behavior while using customized ops.
+ */
+static struct clk *audss_clk_register_divider(struct device *dev,
+		const char *name,
+		const char *parent_name, unsigned long flags,
+		u8 shift, u8 width)
+{
+	struct clk_divider *div;
+	struct clk *clk;
+	struct clk_init_data init;
+
+	/* allocate the divider */
+	div = kzalloc(sizeof(struct clk_divider), GFP_KERNEL);
+	if (!div)
+		return ERR_PTR(-ENOMEM);
+
+	init.name = name;
+	init.ops = &audss_clk_divider_ops;
+	init.flags = flags | CLK_IS_BASIC;
+	init.parent_names = (parent_name ? &parent_name : NULL);
+	init.num_parents = (parent_name ? 1 : 0);
+
+	/* struct clk_divider assignments */
+	div->reg = reg_base + ASS_CLK_DIV;
+	div->shift = shift;
+	div->width = width;
+	div->flags = 0;
+	div->lock = &lock;
+	div->hw.init = &init;
+	div->table = NULL;
+
+	/* register the clock */
+	clk = clk_register(dev, &div->hw);
+
+	if (IS_ERR(clk))
+		kfree(div);
+
+	return clk;
+}
+
+static u8 audss_clk_mux_get_parent(struct clk_hw *hw)
+{
+	u8 parent;
+	int ret;
+
+	ret = pll_clk_enable();
+	if (ret) {
+		WARN(ret, "Could not enable pll_in clock\n");
+		return -EINVAL; /* Just like clk_mux_get_parent() */
+	}
+
+	parent = clk_mux_ops.get_parent(hw);
+
+	pll_clk_disable();
+
+	return parent;
+}
+
+static int audss_clk_mux_set_parent(struct clk_hw *hw, u8 index)
+{
+	int ret;
+
+	ret = pll_clk_enable();
+	if (ret)
+		return ret;
+
+	ret = clk_mux_ops.set_parent(hw, index);
+
+	pll_clk_disable();
+
+	return ret;
+}
+
+static const struct clk_ops audss_clk_mux_ops = {
+	.get_parent = audss_clk_mux_get_parent,
+	.set_parent = audss_clk_mux_set_parent,
+	.determine_rate = __clk_mux_determine_rate,
+};
+
+/*
+ * A simplified copy of clk-mux.c:clk_register_mux_table() to mimic
+ * clk-mux behavior while using customized ops.
+ */
+static struct clk *audss_clk_register_mux(struct device *dev, const char *name,
+		const char **parent_names, u8 num_parents, unsigned long flags,
+		u8 shift, u8 width)
+{
+	struct clk_mux *mux;
+	struct clk *clk;
+	struct clk_init_data init;
+	u32 mask = BIT(width) - 1;
+
+	/* allocate the mux */
+	mux = kzalloc(sizeof(struct clk_mux), GFP_KERNEL);
+	if (!mux)
+		return ERR_PTR(-ENOMEM);
+
+	init.name = name;
+	init.ops = &audss_clk_mux_ops;
+	init.flags = flags | CLK_IS_BASIC;
+	init.parent_names = parent_names;
+	init.num_parents = num_parents;
+
+	/* struct clk_mux assignments */
+	mux->reg = reg_base + ASS_CLK_SRC;
+	mux->shift = shift;
+	mux->mask = mask;
+	mux->flags = 0;
+	mux->lock = &lock;
+	mux->table = NULL;
+	mux->hw.init = &init;
+
+	clk = clk_register(dev, &mux->hw);
+
+	if (IS_ERR(clk))
+		kfree(mux);
+
+	return clk;
+}
+
 /* register exynos_audss clocks */
 static int exynos_audss_clk_probe(struct platform_device *pdev)
 {
@@ -83,7 +354,7 @@ static int exynos_audss_clk_probe(struct platform_device *pdev)
 	const char *mout_audss_p[] = {"fin_pll", "fout_epll"};
 	const char *mout_i2s_p[] = {"mout_audss", "cdclk0", "sclk_audio0"};
 	const char *sclk_pcm_p = "sclk_pcm0";
-	struct clk *pll_ref, *pll_in, *cdclk, *sclk_audio, *sclk_pcm_in;
+	struct clk *pll_ref, *cdclk, *sclk_audio, *sclk_pcm_in;
 	const struct of_device_id *match;
 	enum exynos_audss_clk_type variant;
 
@@ -115,12 +386,21 @@ static int exynos_audss_clk_probe(struct platform_device *pdev)
 	pll_in = devm_clk_get(&pdev->dev, "pll_in");
 	if (!IS_ERR(pll_ref))
 		mout_audss_p[0] = __clk_get_name(pll_ref);
-	if (!IS_ERR(pll_in))
+	if (!IS_ERR(pll_in)) {
 		mout_audss_p[1] = __clk_get_name(pll_in);
-	clk_table[EXYNOS_MOUT_AUDSS] = clk_register_mux(NULL, "mout_audss",
+
+		ret = clk_prepare(pll_in);
+		if (ret) {
+			dev_err(&pdev->dev,
+				"failed to prepare the pll_in clock\n");
+			return ret;
+		}
+
+	}
+
+	clk_table[EXYNOS_MOUT_AUDSS] = audss_clk_register_mux(NULL, "mout_audss",
 				mout_audss_p, ARRAY_SIZE(mout_audss_p),
-				CLK_SET_RATE_NO_REPARENT,
-				reg_base + ASS_CLK_SRC, 0, 1, 0, &lock);
+				CLK_SET_RATE_NO_REPARENT, 0, 1);
 
 	cdclk = devm_clk_get(&pdev->dev, "cdclk");
 	sclk_audio = devm_clk_get(&pdev->dev, "sclk_audio");
@@ -128,50 +408,40 @@ static int exynos_audss_clk_probe(struct platform_device *pdev)
 		mout_i2s_p[1] = __clk_get_name(cdclk);
 	if (!IS_ERR(sclk_audio))
 		mout_i2s_p[2] = __clk_get_name(sclk_audio);
-	clk_table[EXYNOS_MOUT_I2S] = clk_register_mux(NULL, "mout_i2s",
+	clk_table[EXYNOS_MOUT_I2S] = audss_clk_register_mux(NULL, "mout_i2s",
 				mout_i2s_p, ARRAY_SIZE(mout_i2s_p),
-				CLK_SET_RATE_NO_REPARENT,
-				reg_base + ASS_CLK_SRC, 2, 2, 0, &lock);
+				CLK_SET_RATE_NO_REPARENT, 2, 2);
 
-	clk_table[EXYNOS_DOUT_SRP] = clk_register_divider(NULL, "dout_srp",
-				"mout_audss", 0, reg_base + ASS_CLK_DIV, 0, 4,
-				0, &lock);
+	clk_table[EXYNOS_DOUT_SRP] = audss_clk_register_divider(NULL, "dout_srp",
+				"mout_audss", 0, 0, 4);
 
-	clk_table[EXYNOS_DOUT_AUD_BUS] = clk_register_divider(NULL,
-				"dout_aud_bus", "dout_srp", 0,
-				reg_base + ASS_CLK_DIV, 4, 4, 0, &lock);
+	clk_table[EXYNOS_DOUT_AUD_BUS] = audss_clk_register_divider(NULL,
+				"dout_aud_bus", "dout_srp", 0, 4, 4);
 
-	clk_table[EXYNOS_DOUT_I2S] = clk_register_divider(NULL, "dout_i2s",
-				"mout_i2s", 0, reg_base + ASS_CLK_DIV, 8, 4, 0,
-				&lock);
+	clk_table[EXYNOS_DOUT_I2S] = audss_clk_register_divider(NULL, "dout_i2s",
+				"mout_i2s", 0, 8, 4);
 
-	clk_table[EXYNOS_SRP_CLK] = clk_register_gate(NULL, "srp_clk",
-				"dout_srp", CLK_SET_RATE_PARENT,
-				reg_base + ASS_CLK_GATE, 0, 0, &lock);
+	clk_table[EXYNOS_SRP_CLK] = audss_clk_register_gate(NULL, "srp_clk",
+				"dout_srp", CLK_SET_RATE_PARENT, 0);
 
-	clk_table[EXYNOS_I2S_BUS] = clk_register_gate(NULL, "i2s_bus",
-				"dout_aud_bus", CLK_SET_RATE_PARENT,
-				reg_base + ASS_CLK_GATE, 2, 0, &lock);
+	clk_table[EXYNOS_I2S_BUS] = audss_clk_register_gate(NULL, "i2s_bus",
+				"dout_aud_bus", CLK_SET_RATE_PARENT, 2);
 
-	clk_table[EXYNOS_SCLK_I2S] = clk_register_gate(NULL, "sclk_i2s",
-				"dout_i2s", CLK_SET_RATE_PARENT,
-				reg_base + ASS_CLK_GATE, 3, 0, &lock);
+	clk_table[EXYNOS_SCLK_I2S] = audss_clk_register_gate(NULL, "sclk_i2s",
+				"dout_i2s", CLK_SET_RATE_PARENT, 3);
 
-	clk_table[EXYNOS_PCM_BUS] = clk_register_gate(NULL, "pcm_bus",
-				 "sclk_pcm", CLK_SET_RATE_PARENT,
-				reg_base + ASS_CLK_GATE, 4, 0, &lock);
+	clk_table[EXYNOS_PCM_BUS] = audss_clk_register_gate(NULL, "pcm_bus",
+				 "sclk_pcm", CLK_SET_RATE_PARENT, 4);
 
 	sclk_pcm_in = devm_clk_get(&pdev->dev, "sclk_pcm_in");
 	if (!IS_ERR(sclk_pcm_in))
 		sclk_pcm_p = __clk_get_name(sclk_pcm_in);
-	clk_table[EXYNOS_SCLK_PCM] = clk_register_gate(NULL, "sclk_pcm",
-				sclk_pcm_p, CLK_SET_RATE_PARENT,
-				reg_base + ASS_CLK_GATE, 5, 0, &lock);
+	clk_table[EXYNOS_SCLK_PCM] = audss_clk_register_gate(NULL, "sclk_pcm",
+				sclk_pcm_p, CLK_SET_RATE_PARENT, 5);
 
 	if (variant == TYPE_EXYNOS5420) {
-		clk_table[EXYNOS_ADMA] = clk_register_gate(NULL, "adma",
-				"dout_srp", CLK_SET_RATE_PARENT,
-				reg_base + ASS_CLK_GATE, 9, 0, &lock);
+		clk_table[EXYNOS_ADMA] = audss_clk_register_gate(NULL, "adma",
+				"dout_srp", CLK_SET_RATE_PARENT, 9);
 	}
 
 	for (i = 0; i < clk_data.clk_num; i++) {
@@ -198,6 +468,9 @@ static int exynos_audss_clk_probe(struct platform_device *pdev)
 	return 0;
 
 unregister:
+	if (!IS_ERR(pll_in))
+		clk_unprepare(pll_in);
+
 	for (i = 0; i < clk_data.clk_num; i++) {
 		if (!IS_ERR(clk_table[i]))
 			clk_unregister(clk_table[i]);
@@ -214,6 +487,9 @@ static int exynos_audss_clk_remove(struct platform_device *pdev)
 	unregister_syscore_ops(&exynos_audss_clk_syscore_ops);
 #endif
 
+	if (!IS_ERR(pll_in))
+		clk_unprepare(pll_in);
+
 	of_clk_del_provider(pdev->dev.of_node);
 
 	for (i = 0; i < clk_data.clk_num; i++) {
-- 
1.9.1

