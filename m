Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314AbaGKJlt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 05:41:49 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:40972 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854AbaGKJlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 05:41:46 -0400
From: Tushar Behera <tushar.b@samsung.com>
To: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: robh+dt@kernel.org, grant.likely@linaro.org, kgene.kim@samsung.com,
        mturquette@linaro.org, t.figa@samsung.com, trblinux@gmail.com
Subject: [PATCH 1/2] clk: exynos-audss: Simplify code to get clock names
Date: Fri, 11 Jul 2014 15:07:54 +0530
Message-Id: <1405071475-31946-2-git-send-email-tushar.b@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1405071475-31946-1-git-send-email-tushar.b@samsung.com>
References: <1405071475-31946-1-git-send-email-tushar.b@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of getting the clock names individually, it would be good to put
the logic within a loop.

Signed-off-by: Tushar Behera <tushar.b@samsung.com>
---
 drivers/clk/samsung/clk-exynos-audss.c |   33 ++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/drivers/clk/samsung/clk-exynos-audss.c b/drivers/clk/samsung/clk-exynos-audss.c
index 13eae14c..ebfc5da 100644
--- a/drivers/clk/samsung/clk-exynos-audss.c
+++ b/drivers/clk/samsung/clk-exynos-audss.c
@@ -80,10 +80,14 @@ static int exynos_audss_clk_probe(struct platform_device *pdev)
 {
 	int i, ret = 0;
 	struct resource *res;
+	struct clk *tmp;
+	const char *clk_name_ref[] = {
+		"pll_ref", "pll_in", "cdclk", "sclk_audio", "sclk_pcm_in" };
+	const char *clk_name_actual[] = {
+		"fin_pll", "fout_epll", "cdclk0", "sclk_audio0", "sclk_pcm0"};
 	const char *mout_audss_p[] = {"fin_pll", "fout_epll"};
 	const char *mout_i2s_p[] = {"mout_audss", "cdclk0", "sclk_audio0"};
 	const char *sclk_pcm_p = "sclk_pcm0";
-	struct clk *pll_ref, *pll_in, *cdclk, *sclk_audio, *sclk_pcm_in;
 	const struct of_device_id *match;
 	enum exynos_audss_clk_type variant;
 
@@ -111,23 +115,23 @@ static int exynos_audss_clk_probe(struct platform_device *pdev)
 	else
 		clk_data.clk_num = EXYNOS_AUDSS_MAX_CLKS - 1;
 
-	pll_ref = devm_clk_get(&pdev->dev, "pll_ref");
-	pll_in = devm_clk_get(&pdev->dev, "pll_in");
-	if (!IS_ERR(pll_ref))
-		mout_audss_p[0] = __clk_get_name(pll_ref);
-	if (!IS_ERR(pll_in))
-		mout_audss_p[1] = __clk_get_name(pll_in);
+	for (i = 0; i < ARRAY_SIZE(clk_name_ref); i++) {
+		tmp = devm_clk_get(&pdev->dev, clk_name_ref[i]);
+		if (!IS_ERR(tmp))
+			clk_name_actual[i] = __clk_get_name(tmp);
+	}
+
+	mout_audss_p[0] = clk_name_actual[0];
+	mout_audss_p[1] = clk_name_actual[1];
+	mout_i2s_p[1] = clk_name_actual[2];
+	mout_i2s_p[2] = clk_name_actual[3];
+	sclk_pcm_p = clk_name_actual[4];
+
 	clk_table[EXYNOS_MOUT_AUDSS] = clk_register_mux(NULL, "mout_audss",
 				mout_audss_p, ARRAY_SIZE(mout_audss_p),
 				CLK_SET_RATE_NO_REPARENT,
 				reg_base + ASS_CLK_SRC, 0, 1, 0, &lock);
 
-	cdclk = devm_clk_get(&pdev->dev, "cdclk");
-	sclk_audio = devm_clk_get(&pdev->dev, "sclk_audio");
-	if (!IS_ERR(cdclk))
-		mout_i2s_p[1] = __clk_get_name(cdclk);
-	if (!IS_ERR(sclk_audio))
-		mout_i2s_p[2] = __clk_get_name(sclk_audio);
 	clk_table[EXYNOS_MOUT_I2S] = clk_register_mux(NULL, "mout_i2s",
 				mout_i2s_p, ARRAY_SIZE(mout_i2s_p),
 				CLK_SET_RATE_NO_REPARENT,
@@ -161,9 +165,6 @@ static int exynos_audss_clk_probe(struct platform_device *pdev)
 				 "sclk_pcm", CLK_SET_RATE_PARENT,
 				reg_base + ASS_CLK_GATE, 4, 0, &lock);
 
-	sclk_pcm_in = devm_clk_get(&pdev->dev, "sclk_pcm_in");
-	if (!IS_ERR(sclk_pcm_in))
-		sclk_pcm_p = __clk_get_name(sclk_pcm_in);
 	clk_table[EXYNOS_SCLK_PCM] = clk_register_gate(NULL, "sclk_pcm",
 				sclk_pcm_p, CLK_SET_RATE_PARENT,
 				reg_base + ASS_CLK_GATE, 5, 0, &lock);
-- 
1.7.9.5

