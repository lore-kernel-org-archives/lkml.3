Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349AbaGKJlz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 05:41:55 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:37816 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296AbaGKJlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 05:41:49 -0400
From: Tushar Behera <tushar.b@samsung.com>
To: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: robh+dt@kernel.org, grant.likely@linaro.org, kgene.kim@samsung.com,
        mturquette@linaro.org, t.figa@samsung.com, trblinux@gmail.com
Subject: [PATCH 2/2] clk: exynos-audss: Update as per existing framework
Date: Fri, 11 Jul 2014 15:07:55 +0530
Message-Id: <1405071475-31946-3-git-send-email-tushar.b@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1405071475-31946-1-git-send-email-tushar.b@samsung.com>
References: <1405071475-31946-1-git-send-email-tushar.b@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change exynos-audss clock driver as per existing clock framework from
the existing module driver framework.

Signed-off-by: Tushar Behera <tushar.b@samsung.com>
---
 drivers/clk/samsung/clk-exynos-audss.c |  239 ++++++++++++--------------------
 1 file changed, 87 insertions(+), 152 deletions(-)

diff --git a/drivers/clk/samsung/clk-exynos-audss.c b/drivers/clk/samsung/clk-exynos-audss.c
index ebfc5da..49f4163 100644
--- a/drivers/clk/samsung/clk-exynos-audss.c
+++ b/drivers/clk/samsung/clk-exynos-audss.c
@@ -19,26 +19,25 @@
 
 #include <dt-bindings/clock/exynos-audss-clk.h>
 
+#include "clk.h"
+
 enum exynos_audss_clk_type {
 	TYPE_EXYNOS4210,
 	TYPE_EXYNOS5250,
 	TYPE_EXYNOS5420,
 };
 
-static DEFINE_SPINLOCK(lock);
-static struct clk **clk_table;
 static void __iomem *reg_base;
-static struct clk_onecell_data clk_data;
 
-#define ASS_CLK_SRC 0x0
-#define ASS_CLK_DIV 0x4
-#define ASS_CLK_GATE 0x8
+#define ASS_CLK_SRC	0x0
+#define ASS_CLK_DIV	0x4
+#define ASS_CLK_GATE	0x8
 
 #ifdef CONFIG_PM_SLEEP
 static unsigned long reg_save[][2] = {
-	{ASS_CLK_SRC,  0},
-	{ASS_CLK_DIV,  0},
-	{ASS_CLK_GATE, 0},
+	{ASS_CLK_SRC,	0},
+	{ASS_CLK_DIV,	0},
+	{ASS_CLK_GATE,	0},
 };
 
 static int exynos_audss_clk_suspend(void)
@@ -65,21 +64,10 @@ static struct syscore_ops exynos_audss_clk_syscore_ops = {
 };
 #endif /* CONFIG_PM_SLEEP */
 
-static const struct of_device_id exynos_audss_clk_of_match[] = {
-	{ .compatible = "samsung,exynos4210-audss-clock",
-	  .data = (void *)TYPE_EXYNOS4210, },
-	{ .compatible = "samsung,exynos5250-audss-clock",
-	  .data = (void *)TYPE_EXYNOS5250, },
-	{ .compatible = "samsung,exynos5420-audss-clock",
-	  .data = (void *)TYPE_EXYNOS5420, },
-	{},
-};
-
-/* register exynos_audss clocks */
-static int exynos_audss_clk_probe(struct platform_device *pdev)
+static void __init exynos_audss_clk_init(struct device_node *np,
+				enum exynos_audss_clk_type variant)
 {
-	int i, ret = 0;
-	struct resource *res;
+	int i;
 	struct clk *tmp;
 	const char *clk_name_ref[] = {
 		"pll_ref", "pll_in", "cdclk", "sclk_audio", "sclk_pcm_in" };
@@ -87,163 +75,110 @@ static int exynos_audss_clk_probe(struct platform_device *pdev)
 		"fin_pll", "fout_epll", "cdclk0", "sclk_audio0", "sclk_pcm0"};
 	const char *mout_audss_p[] = {"fin_pll", "fout_epll"};
 	const char *mout_i2s_p[] = {"mout_audss", "cdclk0", "sclk_audio0"};
-	const char *sclk_pcm_p = "sclk_pcm0";
-	const struct of_device_id *match;
-	enum exynos_audss_clk_type variant;
-
-	match = of_match_node(exynos_audss_clk_of_match, pdev->dev.of_node);
-	if (!match)
-		return -EINVAL;
-	variant = (enum exynos_audss_clk_type)match->data;
-
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	reg_base = devm_ioremap_resource(&pdev->dev, res);
-	if (IS_ERR(reg_base)) {
-		dev_err(&pdev->dev, "failed to map audss registers\n");
-		return PTR_ERR(reg_base);
-	}
 
-	clk_table = devm_kzalloc(&pdev->dev,
-				sizeof(struct clk *) * EXYNOS_AUDSS_MAX_CLKS,
-				GFP_KERNEL);
-	if (!clk_table)
-		return -ENOMEM;
-
-	clk_data.clks = clk_table;
-	if (variant == TYPE_EXYNOS5420)
-		clk_data.clk_num = EXYNOS_AUDSS_MAX_CLKS;
-	else
-		clk_data.clk_num = EXYNOS_AUDSS_MAX_CLKS - 1;
+	char sclk_pcm_p[32];
+
+	struct samsung_mux_clock exynos_audss_mux_clks[] = {
+		MUX(EXYNOS_MOUT_AUDSS, "mout_audss", mout_audss_p,
+				ASS_CLK_SRC, 0, 1),
+		MUX(EXYNOS_MOUT_I2S, "mout_i2s", mout_i2s_p,
+				ASS_CLK_SRC, 2, 2),
+	};
+
+	struct samsung_div_clock exynos_audss_div_clks[] = {
+		DIV(EXYNOS_DOUT_SRP, "dout_srp", "mout_audss",
+				ASS_CLK_DIV, 0, 4),
+		DIV(EXYNOS_DOUT_AUD_BUS, "dout_aud_bus", "dout_srp",
+				ASS_CLK_DIV, 4, 4),
+		DIV(EXYNOS_DOUT_I2S, "dout_i2s", "mout_i2s", ASS_CLK_DIV, 8, 4),
+	};
+
+	struct samsung_gate_clock exynos_audss_gate_clks[] = {
+		GATE(EXYNOS_SRP_CLK, "srp_clk", "dout_srp",
+				ASS_CLK_GATE, 0, CLK_SET_RATE_PARENT, 0),
+		GATE(EXYNOS_I2S_BUS, "i2s_bus", "dout_aud_bus",
+				ASS_CLK_GATE, 2, CLK_SET_RATE_PARENT, 0),
+		GATE(EXYNOS_SCLK_I2S, "sclk_i2s", "dout_i2s",
+				ASS_CLK_GATE, 3, CLK_SET_RATE_PARENT, 0),
+		GATE(EXYNOS_PCM_BUS, "pcm_bus", "sclk_pcm",
+				ASS_CLK_GATE, 4, CLK_SET_RATE_PARENT, 0),
+		GATE(EXYNOS_SCLK_PCM, "sclk_pcm", sclk_pcm_p,
+				ASS_CLK_GATE, 5, CLK_SET_RATE_PARENT, 0),
+	};
+
+	struct samsung_gate_clock exynos5420_audss_gate_clks[] = {
+		GATE(EXYNOS_ADMA, "adma", "dout_srp",
+				ASS_CLK_GATE, 9, CLK_SET_RATE_PARENT, 0),
+	};
+
+	struct samsung_clk_provider *ctx;
+	int nr_clks = (variant == TYPE_EXYNOS5420) ?
+			EXYNOS_AUDSS_MAX_CLKS : EXYNOS_AUDSS_MAX_CLKS - 1;
+
+	if (!np)
+		panic("%s: failed to get device node for clock provider\n",
+				__func__);
+
+	reg_base = of_iomap(np, 0);
+	if (!reg_base)
+		panic("%s: failed to map registers\n", __func__);
+
+	ctx = samsung_clk_init(np, reg_base, nr_clks);
+	if (!ctx)
+		panic("%s: failed to get clock provier context\n", __func__);
 
 	for (i = 0; i < ARRAY_SIZE(clk_name_ref); i++) {
-		tmp = devm_clk_get(&pdev->dev, clk_name_ref[i]);
-		if (!IS_ERR(tmp))
+		tmp = of_clk_get_by_name(np, clk_name_ref[i]);
+		if (!IS_ERR(tmp)) {
 			clk_name_actual[i] = __clk_get_name(tmp);
+			clk_put(tmp);
+		}
 	}
 
 	mout_audss_p[0] = clk_name_actual[0];
 	mout_audss_p[1] = clk_name_actual[1];
 	mout_i2s_p[1] = clk_name_actual[2];
 	mout_i2s_p[2] = clk_name_actual[3];
-	sclk_pcm_p = clk_name_actual[4];
-
-	clk_table[EXYNOS_MOUT_AUDSS] = clk_register_mux(NULL, "mout_audss",
-				mout_audss_p, ARRAY_SIZE(mout_audss_p),
-				CLK_SET_RATE_NO_REPARENT,
-				reg_base + ASS_CLK_SRC, 0, 1, 0, &lock);
-
-	clk_table[EXYNOS_MOUT_I2S] = clk_register_mux(NULL, "mout_i2s",
-				mout_i2s_p, ARRAY_SIZE(mout_i2s_p),
-				CLK_SET_RATE_NO_REPARENT,
-				reg_base + ASS_CLK_SRC, 2, 2, 0, &lock);
+	strncpy(sclk_pcm_p, clk_name_actual[4], strlen(clk_name_actual[4]));
 
-	clk_table[EXYNOS_DOUT_SRP] = clk_register_divider(NULL, "dout_srp",
-				"mout_audss", 0, reg_base + ASS_CLK_DIV, 0, 4,
-				0, &lock);
+	samsung_clk_register_mux(ctx, exynos_audss_mux_clks,
+				ARRAY_SIZE(exynos_audss_mux_clks));
 
-	clk_table[EXYNOS_DOUT_AUD_BUS] = clk_register_divider(NULL,
-				"dout_aud_bus", "dout_srp", 0,
-				reg_base + ASS_CLK_DIV, 4, 4, 0, &lock);
+	samsung_clk_register_div(ctx, exynos_audss_div_clks,
+				ARRAY_SIZE(exynos_audss_div_clks));
 
-	clk_table[EXYNOS_DOUT_I2S] = clk_register_divider(NULL, "dout_i2s",
-				"mout_i2s", 0, reg_base + ASS_CLK_DIV, 8, 4, 0,
-				&lock);
-
-	clk_table[EXYNOS_SRP_CLK] = clk_register_gate(NULL, "srp_clk",
-				"dout_srp", CLK_SET_RATE_PARENT,
-				reg_base + ASS_CLK_GATE, 0, 0, &lock);
-
-	clk_table[EXYNOS_I2S_BUS] = clk_register_gate(NULL, "i2s_bus",
-				"dout_aud_bus", CLK_SET_RATE_PARENT,
-				reg_base + ASS_CLK_GATE, 2, 0, &lock);
-
-	clk_table[EXYNOS_SCLK_I2S] = clk_register_gate(NULL, "sclk_i2s",
-				"dout_i2s", CLK_SET_RATE_PARENT,
-				reg_base + ASS_CLK_GATE, 3, 0, &lock);
-
-	clk_table[EXYNOS_PCM_BUS] = clk_register_gate(NULL, "pcm_bus",
-				 "sclk_pcm", CLK_SET_RATE_PARENT,
-				reg_base + ASS_CLK_GATE, 4, 0, &lock);
-
-	clk_table[EXYNOS_SCLK_PCM] = clk_register_gate(NULL, "sclk_pcm",
-				sclk_pcm_p, CLK_SET_RATE_PARENT,
-				reg_base + ASS_CLK_GATE, 5, 0, &lock);
+	samsung_clk_register_gate(ctx, exynos_audss_gate_clks,
+				ARRAY_SIZE(exynos_audss_gate_clks));
 
 	if (variant == TYPE_EXYNOS5420) {
-		clk_table[EXYNOS_ADMA] = clk_register_gate(NULL, "adma",
-				"dout_srp", CLK_SET_RATE_PARENT,
-				reg_base + ASS_CLK_GATE, 9, 0, &lock);
-	}
-
-	for (i = 0; i < clk_data.clk_num; i++) {
-		if (IS_ERR(clk_table[i])) {
-			dev_err(&pdev->dev, "failed to register clock %d\n", i);
-			ret = PTR_ERR(clk_table[i]);
-			goto unregister;
-		}
-	}
-
-	ret = of_clk_add_provider(pdev->dev.of_node, of_clk_src_onecell_get,
-					&clk_data);
-	if (ret) {
-		dev_err(&pdev->dev, "failed to add clock provider\n");
-		goto unregister;
+		samsung_clk_register_gate(ctx, exynos5420_audss_gate_clks,
+					ARRAY_SIZE(exynos5420_audss_gate_clks));
 	}
 
 #ifdef CONFIG_PM_SLEEP
 	register_syscore_ops(&exynos_audss_clk_syscore_ops);
 #endif
 
-	dev_info(&pdev->dev, "setup completed\n");
-
-	return 0;
-
-unregister:
-	for (i = 0; i < clk_data.clk_num; i++) {
-		if (!IS_ERR(clk_table[i]))
-			clk_unregister(clk_table[i]);
-	}
-
-	return ret;
+	pr_info("%s setup completed\n", __func__);
 }
 
-static int exynos_audss_clk_remove(struct platform_device *pdev)
+static void exynos4210_audss_clk_init(struct device_node *np)
 {
-	int i;
-
-	of_clk_del_provider(pdev->dev.of_node);
-
-	for (i = 0; i < clk_data.clk_num; i++) {
-		if (!IS_ERR(clk_table[i]))
-			clk_unregister(clk_table[i]);
-	}
-
-	return 0;
+	exynos_audss_clk_init(np, TYPE_EXYNOS4210);
 }
+CLK_OF_DECLARE(exynos4210_audss_clk, "samsung,exynos4210-audss-clock",
+		exynos4210_audss_clk_init);
 
-static struct platform_driver exynos_audss_clk_driver = {
-	.driver	= {
-		.name = "exynos-audss-clk",
-		.owner = THIS_MODULE,
-		.of_match_table = exynos_audss_clk_of_match,
-	},
-	.probe = exynos_audss_clk_probe,
-	.remove = exynos_audss_clk_remove,
-};
-
-static int __init exynos_audss_clk_init(void)
+static void exynos5250_audss_clk_init(struct device_node *np)
 {
-	return platform_driver_register(&exynos_audss_clk_driver);
+	exynos_audss_clk_init(np, TYPE_EXYNOS5250);
 }
-core_initcall(exynos_audss_clk_init);
+CLK_OF_DECLARE(exynos5250_audss_clk, "samsung,exynos5250-audss-clock",
+		exynos5250_audss_clk_init);
 
-static void __exit exynos_audss_clk_exit(void)
+static void exynos5420_audss_clk_init(struct device_node *np)
 {
-	platform_driver_unregister(&exynos_audss_clk_driver);
+	exynos_audss_clk_init(np, TYPE_EXYNOS5420);
 }
-module_exit(exynos_audss_clk_exit);
-
-MODULE_AUTHOR("Padmavathi Venna <padma.v@samsung.com>");
-MODULE_DESCRIPTION("Exynos Audio Subsystem Clock Controller");
-MODULE_LICENSE("GPL v2");
-MODULE_ALIAS("platform:exynos-audss-clk");
+CLK_OF_DECLARE(exynos5420_audss_clk, "samsung,exynos5420-audss-clock",
+		exynos5420_audss_clk_init);
-- 
1.7.9.5

