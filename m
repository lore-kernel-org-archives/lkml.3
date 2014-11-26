Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141AbaKZO0d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 09:26:33 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:32993 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732AbaKZOYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 09:24:50 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-14-5475e2a923a3
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
Subject: [PATCH v2 5/5] clk: samsung: Fix memory leak of clock gate/divider/mux
 structures
Date: Wed, 26 Nov 2014 15:24:17 +0100
Message-id: <1417011857-10419-6-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1417011857-10419-1-git-send-email-k.kozlowski@samsung.com>
References: <1417011857-10419-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsVy+t/xK7orH5WGGHx/Ym6xccZ6Vov5R86x
	WrRdOchucfR3gcXrF4YW/Y9fM1s83fyYyeJs0xt2iyl/ljNZbHp8jdVi8/w/jBaXd81hs5hx
	fh+Txe3LvBZrj9xlt3g64SKbxeE37awWx2YsYbRYtesPo4OwR0tzD5vH3+fXWTx2zrrL7rFp
	VSebx51re9g8Ni+p9+jbsorR4/MmuQCOKC6blNSczLLUIn27BK6MQ83/mQvOGFTMmNjF2MD4
	RaOLkZNDQsBE4vGnk+wQtpjEhXvr2boYuTiEBJYySrTeWc0CkhAS6GOSePc4AMRmEzCW2Lx8
	CViRiMAKFoldi34xgzjMAu8YJdafWQ/WISwQIzHl2SagKg4OFgFViUfzA0HCvALuEiv62xkh
	tslJnDw2mRXE5hTwkGh7f54ZYpm7xPd9hxknMPIuYGRYxSiaWppcUJyUnmukV5yYW1yal66X
	nJ+7iRES5F93MC49ZnWIUYCDUYmH90ZcSYgQa2JZcWXuIUYJDmYlEd7UO6UhQrwpiZVVqUX5
	8UWlOanFhxiZODilGhg7L/VvWiQ8gT92doGIQuD2XUb3Ztvu/LGfYdrrHSfEhLSWFCoYCRcG
	vZi5dBvrHv+jL18Xel9UW83XveBVD3PuVh5l9/MmUexKC5oOqCQEM1aX7lnxr+nGxcV/i9W/
	b0ji2vKhxUNRYtrixA07xH7x1x+8xqj9LXpZWzND1ryd83+bta/S1xNXYinOSDTUYi4qTgQA
	jF8JXVACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While fixing audss clock access when domain is gated (commit "clk:
samsung: Fix clock disable failure because domain being gated") generic
code from clk-gate/divider/mux was taken and modified.

This generic code leaks memory allocated for internal structures (struct
clk_gate/clk_divider/clk_mux). Fix the leak by using resourced managed
allocations.

The audss clocks are now attached to platform device.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/clk/samsung/clk-exynos-audss.c | 63 ++++++++++++++--------------------
 1 file changed, 26 insertions(+), 37 deletions(-)

diff --git a/drivers/clk/samsung/clk-exynos-audss.c b/drivers/clk/samsung/clk-exynos-audss.c
index 9ec7de866ab4..229d54981825 100644
--- a/drivers/clk/samsung/clk-exynos-audss.c
+++ b/drivers/clk/samsung/clk-exynos-audss.c
@@ -142,8 +142,6 @@ static const struct clk_ops audss_clk_gate_ops = {
 /*
  * A simplified copy of clk-gate.c:clk_register_gate() to mimic
  * clk-gate behavior while using customized ops.
- *
- * TODO: just like clk-gate it leaks memory for struct clk_gate.
  */
 static struct clk *audss_clk_register_gate(struct device *dev, const char *name,
 		const char *parent_name, unsigned long flags, u8 bit_idx)
@@ -153,7 +151,7 @@ static struct clk *audss_clk_register_gate(struct device *dev, const char *name,
 	struct clk_init_data init;
 
 	/* allocate the gate */
-	gate = kzalloc(sizeof(struct clk_gate), GFP_KERNEL);
+	gate = devm_kzalloc(dev, sizeof(struct clk_gate), GFP_KERNEL);
 	if (!gate)
 		return ERR_PTR(-ENOMEM);
 
@@ -172,9 +170,6 @@ static struct clk *audss_clk_register_gate(struct device *dev, const char *name,
 
 	clk = clk_register(dev, &gate->hw);
 
-	if (IS_ERR(clk))
-		kfree(gate);
-
 	return clk;
 }
 
@@ -238,7 +233,7 @@ static struct clk *audss_clk_register_divider(struct device *dev,
 	struct clk_init_data init;
 
 	/* allocate the divider */
-	div = kzalloc(sizeof(struct clk_divider), GFP_KERNEL);
+	div = devm_kzalloc(dev, sizeof(struct clk_divider), GFP_KERNEL);
 	if (!div)
 		return ERR_PTR(-ENOMEM);
 
@@ -260,9 +255,6 @@ static struct clk *audss_clk_register_divider(struct device *dev,
 	/* register the clock */
 	clk = clk_register(dev, &div->hw);
 
-	if (IS_ERR(clk))
-		kfree(div);
-
 	return clk;
 }
 
@@ -319,7 +311,7 @@ static struct clk *audss_clk_register_mux(struct device *dev, const char *name,
 	u32 mask = BIT(width) - 1;
 
 	/* allocate the mux */
-	mux = kzalloc(sizeof(struct clk_mux), GFP_KERNEL);
+	mux = devm_kzalloc(dev, sizeof(struct clk_mux), GFP_KERNEL);
 	if (!mux)
 		return ERR_PTR(-ENOMEM);
 
@@ -340,9 +332,6 @@ static struct clk *audss_clk_register_mux(struct device *dev, const char *name,
 
 	clk = clk_register(dev, &mux->hw);
 
-	if (IS_ERR(clk))
-		kfree(mux);
-
 	return clk;
 }
 
@@ -398,9 +387,9 @@ static int exynos_audss_clk_probe(struct platform_device *pdev)
 
 	}
 
-	clk_table[EXYNOS_MOUT_AUDSS] = audss_clk_register_mux(NULL, "mout_audss",
-				mout_audss_p, ARRAY_SIZE(mout_audss_p),
-				CLK_SET_RATE_NO_REPARENT, 0, 1);
+	clk_table[EXYNOS_MOUT_AUDSS] = audss_clk_register_mux(&pdev->dev,
+			"mout_audss", mout_audss_p, ARRAY_SIZE(mout_audss_p),
+			CLK_SET_RATE_NO_REPARENT, 0, 1);
 
 	cdclk = devm_clk_get(&pdev->dev, "cdclk");
 	sclk_audio = devm_clk_get(&pdev->dev, "sclk_audio");
@@ -408,40 +397,40 @@ static int exynos_audss_clk_probe(struct platform_device *pdev)
 		mout_i2s_p[1] = __clk_get_name(cdclk);
 	if (!IS_ERR(sclk_audio))
 		mout_i2s_p[2] = __clk_get_name(sclk_audio);
-	clk_table[EXYNOS_MOUT_I2S] = audss_clk_register_mux(NULL, "mout_i2s",
-				mout_i2s_p, ARRAY_SIZE(mout_i2s_p),
-				CLK_SET_RATE_NO_REPARENT, 2, 2);
+	clk_table[EXYNOS_MOUT_I2S] = audss_clk_register_mux(&pdev->dev,
+			"mout_i2s", mout_i2s_p, ARRAY_SIZE(mout_i2s_p),
+			CLK_SET_RATE_NO_REPARENT, 2, 2);
 
-	clk_table[EXYNOS_DOUT_SRP] = audss_clk_register_divider(NULL, "dout_srp",
-				"mout_audss", 0, 0, 4);
+	clk_table[EXYNOS_DOUT_SRP] = audss_clk_register_divider(&pdev->dev,
+			"dout_srp", "mout_audss", 0, 0, 4);
 
-	clk_table[EXYNOS_DOUT_AUD_BUS] = audss_clk_register_divider(NULL,
+	clk_table[EXYNOS_DOUT_AUD_BUS] = audss_clk_register_divider(&pdev->dev,
 				"dout_aud_bus", "dout_srp", 0, 4, 4);
 
-	clk_table[EXYNOS_DOUT_I2S] = audss_clk_register_divider(NULL, "dout_i2s",
-				"mout_i2s", 0, 8, 4);
+	clk_table[EXYNOS_DOUT_I2S] = audss_clk_register_divider(&pdev->dev,
+			"dout_i2s", "mout_i2s", 0, 8, 4);
 
-	clk_table[EXYNOS_SRP_CLK] = audss_clk_register_gate(NULL, "srp_clk",
-				"dout_srp", CLK_SET_RATE_PARENT, 0);
+	clk_table[EXYNOS_SRP_CLK] = audss_clk_register_gate(&pdev->dev,
+			"srp_clk", "dout_srp", CLK_SET_RATE_PARENT, 0);
 
-	clk_table[EXYNOS_I2S_BUS] = audss_clk_register_gate(NULL, "i2s_bus",
-				"dout_aud_bus", CLK_SET_RATE_PARENT, 2);
+	clk_table[EXYNOS_I2S_BUS] = audss_clk_register_gate(&pdev->dev,
+			"i2s_bus", "dout_aud_bus", CLK_SET_RATE_PARENT, 2);
 
-	clk_table[EXYNOS_SCLK_I2S] = audss_clk_register_gate(NULL, "sclk_i2s",
-				"dout_i2s", CLK_SET_RATE_PARENT, 3);
+	clk_table[EXYNOS_SCLK_I2S] = audss_clk_register_gate(&pdev->dev,
+			"sclk_i2s", "dout_i2s", CLK_SET_RATE_PARENT, 3);
 
-	clk_table[EXYNOS_PCM_BUS] = audss_clk_register_gate(NULL, "pcm_bus",
-				 "sclk_pcm", CLK_SET_RATE_PARENT, 4);
+	clk_table[EXYNOS_PCM_BUS] = audss_clk_register_gate(&pdev->dev,
+			"pcm_bus", "sclk_pcm", CLK_SET_RATE_PARENT, 4);
 
 	sclk_pcm_in = devm_clk_get(&pdev->dev, "sclk_pcm_in");
 	if (!IS_ERR(sclk_pcm_in))
 		sclk_pcm_p = __clk_get_name(sclk_pcm_in);
-	clk_table[EXYNOS_SCLK_PCM] = audss_clk_register_gate(NULL, "sclk_pcm",
-				sclk_pcm_p, CLK_SET_RATE_PARENT, 5);
+	clk_table[EXYNOS_SCLK_PCM] = audss_clk_register_gate(&pdev->dev,
+			"sclk_pcm", sclk_pcm_p, CLK_SET_RATE_PARENT, 5);
 
 	if (variant == TYPE_EXYNOS5420) {
-		clk_table[EXYNOS_ADMA] = audss_clk_register_gate(NULL, "adma",
-				"dout_srp", CLK_SET_RATE_PARENT, 9);
+		clk_table[EXYNOS_ADMA] = audss_clk_register_gate(&pdev->dev,
+				"adma", "dout_srp", CLK_SET_RATE_PARENT, 9);
 	}
 
 	for (i = 0; i < clk_data.clk_num; i++) {
-- 
1.9.1

