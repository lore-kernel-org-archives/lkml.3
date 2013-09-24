Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582Ab3IXSHM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 14:07:12 -0400
Received: from mail-ve0-f202.google.com ([209.85.128.202]:58827 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754262Ab3IXSHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 14:07:00 -0400
X-Greylist: delayed 62503 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Sep 2013 14:07:00 EDT
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
Subject: [PATCH V3 1/6] clk: exynos-audss: convert to platform device
Date: Tue, 24 Sep 2013 11:06:51 -0700
Message-Id: <1380046016-5811-1-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1379982078-23381-1-git-send-email-abrestic@chromium.org>
References: <1379982078-23381-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Exynos AudioSS clock controller will later be modified to allow
input clocks to be specified via device-tree in order to support
multiple Exynos SoCs.  This will introduce a dependency on the core
SoC clock controller being initialized first so that the AudioSS driver
can look up its input clocks, but the order in which clock providers
are probed in of_clk_init() is not guaranteed.  Since deferred probing
is not supported in of_clk_init() and the AudioSS block is not the core
controller, we can initialize it later as a platform device.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
Changes since v2:
 - add error handling to probe callback
 - fixed ordering of of_clk_{add,del}_provider
 - fixed nits from Tomasz and Sylwester
Changes since v1:
 - add clk_unregister() calls to remove callback
 - fixed minor nits from Tomasz
---
 drivers/clk/samsung/clk-exynos-audss.c | 109 +++++++++++++++++++++++++++------
 1 file changed, 90 insertions(+), 19 deletions(-)

diff --git a/drivers/clk/samsung/clk-exynos-audss.c b/drivers/clk/samsung/clk-exynos-audss.c
index 39b40aa..319c6e4 100644
--- a/drivers/clk/samsung/clk-exynos-audss.c
+++ b/drivers/clk/samsung/clk-exynos-audss.c
@@ -14,6 +14,8 @@
 #include <linux/clk-provider.h>
 #include <linux/of_address.h>
 #include <linux/syscore_ops.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
 
 #include <dt-bindings/clk/exynos-audss-clk.h>
 
@@ -62,24 +64,23 @@ static struct syscore_ops exynos_audss_clk_syscore_ops = {
 #endif /* CONFIG_PM_SLEEP */
 
 /* register exynos_audss clocks */
-static void __init exynos_audss_clk_init(struct device_node *np)
+static int exynos_audss_clk_probe(struct platform_device *pdev)
 {
-	reg_base = of_iomap(np, 0);
-	if (!reg_base) {
-		pr_err("%s: failed to map audss registers\n", __func__);
-		return;
+	int i, ret = 0;
+	struct resource *res;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	reg_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(reg_base)) {
+		dev_err(&pdev->dev, "failed to map audss registers\n");
+		return PTR_ERR(reg_base);
 	}
 
-	clk_table = kzalloc(sizeof(struct clk *) * EXYNOS_AUDSS_MAX_CLKS,
+	clk_table = devm_kzalloc(&pdev->dev,
+				sizeof(struct clk *) * EXYNOS_AUDSS_MAX_CLKS,
 				GFP_KERNEL);
-	if (!clk_table) {
-		pr_err("%s: could not allocate clk lookup table\n", __func__);
-		return;
-	}
-
-	clk_data.clks = clk_table;
-	clk_data.clk_num = EXYNOS_AUDSS_MAX_CLKS;
-	of_clk_add_provider(np, of_clk_src_onecell_get, &clk_data);
+	if (!clk_table)
+		return -ENOMEM;
 
 	clk_table[EXYNOS_MOUT_AUDSS] = clk_register_mux(NULL, "mout_audss",
 				mout_audss_p, ARRAY_SIZE(mout_audss_p),
@@ -123,13 +124,83 @@ static void __init exynos_audss_clk_init(struct device_node *np)
 				"div_pcm0", CLK_SET_RATE_PARENT,
 				reg_base + ASS_CLK_GATE, 5, 0, &lock);
 
+	for (i = 0; i < EXYNOS_AUDSS_MAX_CLKS; i++) {
+		if (IS_ERR(clk_table[i])) {
+			dev_err(&pdev->dev, "failed to regsiter clock %d\n", i);
+			ret = PTR_ERR(clk_table[i]);
+			goto unregister;
+		}
+	}
+
+	clk_data.clks = clk_table;
+	clk_data.clk_num = EXYNOS_AUDSS_MAX_CLKS;
+	ret = of_clk_add_provider(pdev->dev.of_node, of_clk_src_onecell_get,
+					&clk_data);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to add clock provider\n");
+		goto unregister;
+	}
+
 #ifdef CONFIG_PM_SLEEP
 	register_syscore_ops(&exynos_audss_clk_syscore_ops);
 #endif
 
-	pr_info("Exynos: Audss: clock setup completed\n");
+	dev_info(&pdev->dev, "setup completed\n");
+
+	return 0;
+
+unregister:
+	for (i = 0; i < EXYNOS_AUDSS_MAX_CLKS; i++) {
+		if (!IS_ERR_OR_NULL(clk_table[i]))
+			clk_unregister(clk_table[i]);
+	}
+
+	return ret;
 }
-CLK_OF_DECLARE(exynos4210_audss_clk, "samsung,exynos4210-audss-clock",
-		exynos_audss_clk_init);
-CLK_OF_DECLARE(exynos5250_audss_clk, "samsung,exynos5250-audss-clock",
-		exynos_audss_clk_init);
+
+static int exynos_audss_clk_remove(struct platform_device *pdev)
+{
+	int i;
+
+	of_clk_del_provider(pdev->dev.of_node);
+
+	for (i = 0; i < EXYNOS_AUDSS_MAX_CLKS; i++) {
+		if (!IS_ERR_OR_NULL(clk_table[i]))
+			clk_unregister(clk_table[i]);
+	}
+
+	return 0;
+}
+
+static const struct of_device_id exynos_audss_clk_of_match[] = {
+	{ .compatible = "samsung,exynos4210-audss-clock", },
+	{ .compatible = "samsung,exynos5250-audss-clock", },
+	{},
+};
+
+static struct platform_driver exynos_audss_clk_driver = {
+	.driver	= {
+		.name = "exynos-audss-clk",
+		.owner = THIS_MODULE,
+		.of_match_table = exynos_audss_clk_of_match,
+	},
+	.probe = exynos_audss_clk_probe,
+	.remove = exynos_audss_clk_remove,
+};
+
+static int __init exynos_audss_clk_init(void)
+{
+	return platform_driver_register(&exynos_audss_clk_driver);
+}
+core_initcall(exynos_audss_clk_init);
+
+static void __init exynos_audss_clk_exit(void)
+{
+	platform_driver_unregister(&exynos_audss_clk_driver);
+}
+module_exit(exynos_audss_clk_exit);
+
+MODULE_AUTHOR("Padmavathi Venna <padma.v@samsung.com>");
+MODULE_DESCRIPTION("Exynos Audio Subsystem Clock Controller");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:exynos-audss-clk");
-- 
1.8.4

