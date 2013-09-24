Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140Ab3IXA2L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 20:28:11 -0400
Received: from mail-qa0-f73.google.com ([209.85.216.73]:58289 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671Ab3IXA2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 20:28:09 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: linux-samsung-soc@vger.kernel.org, Tomasz Figa <t.figa@samsung.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
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
        Stephen Boyd <sboyd@codeaurora.org>,
        Tushar Behera <tushar.behera@linaro.org>,
        Doug Anderson <dianders@chromium.org>,
        Padmavathi Venna <padma.v@samsung.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Andrew Bresticker <abrestic@chromium.org>
Subject: [PATCH V2 5/6] clk: exynos-audss: add support for Exynos 5420
Date: Mon, 23 Sep 2013 17:21:17 -0700
Message-Id: <1379982078-23381-5-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1379982078-23381-1-git-send-email-abrestic@chromium.org>
References: <1379711637-5226-1-git-send-email-abrestic@chromium.org>
 <1379982078-23381-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AudioSS block on Exynos 5420 has an additional clock gate for the
ADMA bus clock.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
Changes since v1:
 - added type enum and made comparison against that instead of compatibility
   string
---
 .../devicetree/bindings/clock/clk-exynos-audss.txt |  7 +++--
 drivers/clk/samsung/clk-exynos-audss.c             | 35 ++++++++++++++++++----
 include/dt-bindings/clk/exynos-audss-clk.h         |  3 +-
 3 files changed, 36 insertions(+), 9 deletions(-)

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
index afb53de..8ccf3788 100644
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
@@ -67,6 +83,13 @@ static int exynos_audss_clk_probe(struct platform_device *pdev)
 	const char *sclk_pcm_p = "sclk_pcm0";
 	struct clk *pll_ref, *pll_in, *cdclk, *sclk_audio, *sclk_pcm_in;
 	struct resource *res;
+	const struct of_device_id *match;
+	enum exynos_audss_clk_type variant;
+
+	match = of_match_node(exynos_audss_clk_of_match, pdev->dev.of_node);
+	if (!match)
+		return -EINVAL;
+	variant = (enum exynos_audss_clk_type)match->data;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	reg_base = devm_ioremap_resource(&pdev->dev, res);
@@ -145,6 +168,12 @@ static int exynos_audss_clk_probe(struct platform_device *pdev)
 				sclk_pcm_p, CLK_SET_RATE_PARENT,
 				reg_base + ASS_CLK_GATE, 5, 0, &lock);
 
+	if (variant == TYPE_EXYNOS5420) {
+		clk_table[EXYNOS_ADMA] = clk_register_gate(NULL, "adma",
+				"dout_srp", CLK_SET_RATE_PARENT,
+				reg_base + ASS_CLK_GATE, 9, 0, &lock);
+	}
+
 #ifdef CONFIG_PM_SLEEP
 	register_syscore_ops(&exynos_audss_clk_syscore_ops);
 #endif
@@ -168,12 +197,6 @@ static int exynos_audss_clk_remove(struct platform_device *pdev)
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

