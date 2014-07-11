Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495AbaGKMEi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 08:04:38 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:57006 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454AbaGKMEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 08:04:33 -0400
From: Tushar Behera <tushar.b@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com, mturquette@linaro.org, t.figa@samsung.com,
        trblinux@gmail.com
Subject: [PATCH V2 3/3] clk: exynos-audss: Use samsung clock APIs to register/unregister clocks
Date: Fri, 11 Jul 2014 17:30:35 +0530
Message-Id: <1405080036-6651-4-git-send-email-tushar.b@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1405080036-6651-1-git-send-email-tushar.b@samsung.com>
References: <1405080036-6651-1-git-send-email-tushar.b@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using samsung clock APIs to register/unregister clocks will save some
lines of code.

Signed-off-by: Tushar Behera <tushar.b@samsung.com>
---
Changes of v2:
* Retain platform driver structure.

 drivers/clk/samsung/clk-exynos-audss.c |  146 ++++++++++++--------------------
 1 file changed, 56 insertions(+), 90 deletions(-)

diff --git a/drivers/clk/samsung/clk-exynos-audss.c b/drivers/clk/samsung/clk-exynos-audss.c
index 1a5294c..2b90967 100644
--- a/drivers/clk/samsung/clk-exynos-audss.c
+++ b/drivers/clk/samsung/clk-exynos-audss.c
@@ -19,16 +19,16 @@
 
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
+static struct samsung_clk_provider *ctx;
 static void __iomem *reg_base;
-static struct clk_onecell_data clk_data;
 
 #define ASS_CLK_SRC 0x0
 #define ASS_CLK_DIV 0x4
@@ -78,7 +78,7 @@ static const struct of_device_id exynos_audss_clk_of_match[] = {
 /* register exynos_audss clocks */
 static int exynos_audss_clk_probe(struct platform_device *pdev)
 {
-	int i, ret = 0;
+	int i;
 	struct resource *res;
 	struct clk *tmp;
 	const char *clk_name_ref[] = {
@@ -87,14 +87,51 @@ static int exynos_audss_clk_probe(struct platform_device *pdev)
 		"fin_pll", "fout_epll", "cdclk0", "sclk_audio0", "sclk_pcm0"};
 	const char *mout_audss_p[] = {"fin_pll", "fout_epll"};
 	const char *mout_i2s_p[] = {"mout_audss", "cdclk0", "sclk_audio0"};
-	const char *sclk_pcm_p = "sclk_pcm0";
+	char sclk_pcm_p[32];
 	const struct of_device_id *match;
 	enum exynos_audss_clk_type variant;
 
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
+	int nr_clks = EXYNOS_AUDSS_MAX_CLKS;
+
 	match = of_match_node(exynos_audss_clk_of_match, pdev->dev.of_node);
 	if (!match)
 		return -EINVAL;
 	variant = (enum exynos_audss_clk_type)match->data;
+	if (variant != TYPE_EXYNOS5420)
+			nr_clks--;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	reg_base = devm_ioremap_resource(&pdev->dev, res);
@@ -103,17 +140,11 @@ static int exynos_audss_clk_probe(struct platform_device *pdev)
 		return PTR_ERR(reg_base);
 	}
 
-	clk_table = devm_kzalloc(&pdev->dev,
-				sizeof(struct clk *) * EXYNOS_AUDSS_MAX_CLKS,
-				GFP_KERNEL);
-	if (!clk_table)
+	ctx = samsung_clk_init(pdev->dev.of_node, reg_base, nr_clks);
+	if (!ctx) {
+		dev_err(&pdev->dev, "failed to get clock provier context\n");
 		return -ENOMEM;
-
-	clk_data.clks = clk_table;
-	if (variant == TYPE_EXYNOS5420)
-		clk_data.clk_num = EXYNOS_AUDSS_MAX_CLKS;
-	else
-		clk_data.clk_num = EXYNOS_AUDSS_MAX_CLKS - 1;
+	}
 
 	for (i = 0; i < ARRAY_SIZE(clk_name_ref); i++) {
 		tmp = clk_get(&pdev->dev, clk_name_ref[i]);
@@ -127,69 +158,20 @@ static int exynos_audss_clk_probe(struct platform_device *pdev)
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
@@ -199,27 +181,11 @@ static int exynos_audss_clk_probe(struct platform_device *pdev)
 	dev_info(&pdev->dev, "setup completed\n");
 
 	return 0;
-
-unregister:
-	for (i = 0; i < clk_data.clk_num; i++) {
-		if (!IS_ERR(clk_table[i]))
-			clk_unregister(clk_table[i]);
-	}
-
-	return ret;
 }
 
 static int exynos_audss_clk_remove(struct platform_device *pdev)
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
+	samsung_clk_exit(pdev->dev.of_node, ctx);
 	return 0;
 }
 
-- 
1.7.9.5

