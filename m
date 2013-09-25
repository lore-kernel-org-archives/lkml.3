Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165Ab3IYVND (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 17:13:03 -0400
Received: from mail-ve0-f202.google.com ([209.85.128.202]:58415 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756111Ab3IYVM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 17:12:58 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Tomasz Figa <t.figa@samsung.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        linux-samsung-soc@vger.kernel.org, Stephen Boyd <sboyd@codeaurora.org>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Sachin Kamat <sachin.kamat@linaro.org>, Jiri Kosina <jkosina@suse.cz>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        Tushar Behera <tushar.behera@linaro.org>,
        Doug Anderson <dianders@chromium.org>,
        Padmavathi Venna <padma.v@samsung.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Andrew Bresticker <abrestic@chromium.org>
Subject: [PATCH V4 5/6] clk: exynos-audss: add support for Exynos 5420
Date: Wed, 25 Sep 2013 14:12:51 -0700
Message-Id: <1380143572-11741-5-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1380143572-11741-1-git-send-email-abrestic@chromium.org>
References: <1380046016-5811-1-git-send-email-abrestic@chromium.org>
 <1380143572-11741-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AudioSS block on Exynos 5420 has an additional clock gate for the
ADMA bus clock.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
Changes since v3:
 - set clk_data.clk_num to correct value in non-5420 case
Changes since v1:
 - added type enum and made comparison against that instead of compatibility
   string
---
 .../devicetree/bindings/clock/clk-exynos-audss.txt |  7 ++--
 drivers/clk/samsung/clk-exynos-audss.c             | 40 ++++++++++++++++++----
 include/dt-bindings/clk/exynos-audss-clk.h         |  3 +-
 3 files changed, 40 insertions(+), 10 deletions(-)

diff --git a/Documentation/devicetree/bindings/clock/clk-exynos-audss.txt b/Documentation/devicetree/bindings/clock/clk-exynos-audss.txt
index 85b9e28..180e883 100644
--- a/Documentation/devicetree/bindings/clock/clk-exynos-audss.txt
+++ b/Documentation/devicetree/bindings/clock/clk-exynos-audss.txt
@@ -8,8 +8,10 @@ Required Properties:
 
 - compatible: should be one of the following:
   - "samsung,exynos4210-audss-clock" - controller compatible with all Exynos4 SoCs.
-  - "samsung,exynos5250-audss-clock" - controller compatible with all Exynos5 SoCs.
-
+  - "samsung,exynos5250-audss-clock" - controller compatible with Exynos5250
+    SoCs.
+  - "samsung,exynos5420-audss-clock" - controller compatible with Exynos5420
+    SoCs.
 - reg: physical base address and length of the controller's register set.
 
 - #clock-cells: should be 1.
@@ -49,6 +51,7 @@ i2s_bus         6
 sclk_i2s        7
 pcm_bus         8
 sclk_pcm        9
+adma            10      Exynos5420
 
 Example 1: An example of a clock controller node using the default input
 	   clock names is listed below.
diff --git a/drivers/clk/samsung/clk-exynos-audss.c b/drivers/clk/samsung/clk-exynos-audss.c
index 7cb10f2..e607176 100644
--- a/drivers/clk/samsung/clk-exynos-audss.c
+++ b/drivers/clk/samsung/clk-exynos-audss.c
@@ -19,6 +19,12 @@
 
 #include <dt-bindings/clk/exynos-audss-clk.h>
 
+enum exynos_audss_clk_type {
+	TYPE_EXYNOS4210,
+	TYPE_EXYNOS5250,
+	TYPE_EXYNOS5420,
+};
+
 static DEFINE_SPINLOCK(lock);
 static struct clk **clk_table;
 static void __iomem *reg_base;
@@ -59,6 +65,16 @@ static struct syscore_ops exynos_audss_clk_syscore_ops = {
 };
 #endif /* CONFIG_PM_SLEEP */
 
+static const struct of_device_id exynos_audss_clk_of_match[] = {
+	{ .compatible = "samsung,exynos4210-audss-clock",
+	  .data = (void *)TYPE_EXYNOS4210, },
+	{ .compatible = "samsung,exynos5250-audss-clock",
+	  .data = (void *)TYPE_EXYNOS5250, },
+	{ .compatible = "samsung,exynos5420-audss-clock",
+	  .data = (void *)TYPE_EXYNOS5420, },
+	{},
+};
+
 /* register exynos_audss clocks */
 static int exynos_audss_clk_probe(struct platform_device *pdev)
 {
@@ -68,6 +84,13 @@ static int exynos_audss_clk_probe(struct platform_device *pdev)
 	const char *mout_i2s_p[] = {"mout_audss", "cdclk0", "sclk_audio0"};
 	const char *sclk_pcm_p = "sclk_pcm0";
 	struct clk *pll_ref, *pll_in, *cdclk, *sclk_audio, *sclk_pcm_in;
+	const struct of_device_id *match;
+	enum exynos_audss_clk_type variant;
+
+	match = of_match_node(exynos_audss_clk_of_match, pdev->dev.of_node);
+	if (!match)
+		return -EINVAL;
+	variant = (enum exynos_audss_clk_type)match->data;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	reg_base = devm_ioremap_resource(&pdev->dev, res);
@@ -83,7 +106,10 @@ static int exynos_audss_clk_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	clk_data.clks = clk_table;
-	clk_data.clk_num = EXYNOS_AUDSS_MAX_CLKS;
+	if (variant == TYPE_EXYNOS5420)
+		clk_data.clk_num = EXYNOS_AUDSS_MAX_CLKS;
+	else
+		clk_data.clk_num = EXYNOS_AUDSS_MAX_CLKS - 1;
 
 	pll_ref = devm_clk_get(&pdev->dev, "pll_ref");
 	pll_in = devm_clk_get(&pdev->dev, "pll_in");
@@ -142,6 +168,12 @@ static int exynos_audss_clk_probe(struct platform_device *pdev)
 				sclk_pcm_p, CLK_SET_RATE_PARENT,
 				reg_base + ASS_CLK_GATE, 5, 0, &lock);
 
+	if (variant == TYPE_EXYNOS5420) {
+		clk_table[EXYNOS_ADMA] = clk_register_gate(NULL, "adma",
+				"dout_srp", CLK_SET_RATE_PARENT,
+				reg_base + ASS_CLK_GATE, 9, 0, &lock);
+	}
+
 	for (i = 0; i < clk_data.clk_num; i++) {
 		if (IS_ERR(clk_table[i])) {
 			dev_err(&pdev->dev, "failed to register clock %d\n", i);
@@ -188,12 +220,6 @@ static int exynos_audss_clk_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static const struct of_device_id exynos_audss_clk_of_match[] = {
-	{ .compatible = "samsung,exynos4210-audss-clock", },
-	{ .compatible = "samsung,exynos5250-audss-clock", },
-	{},
-};
-
 static struct platform_driver exynos_audss_clk_driver = {
 	.driver	= {
 		.name = "exynos-audss-clk",
diff --git a/include/dt-bindings/clk/exynos-audss-clk.h b/include/dt-bindings/clk/exynos-audss-clk.h
index 8279f42..0ae6f5a 100644
--- a/include/dt-bindings/clk/exynos-audss-clk.h
+++ b/include/dt-bindings/clk/exynos-audss-clk.h
@@ -19,7 +19,8 @@
 #define EXYNOS_SCLK_I2S	7
 #define EXYNOS_PCM_BUS		8
 #define EXYNOS_SCLK_PCM	9
+#define EXYNOS_ADMA		10
 
-#define EXYNOS_AUDSS_MAX_CLKS	10
+#define EXYNOS_AUDSS_MAX_CLKS	11
 
 #endif
-- 
1.8.4

