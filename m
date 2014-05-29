Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933007AbaE2VWa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 17:22:30 -0400
Received: from mail-ie0-f201.google.com ([209.85.223.201]:59544 "EHLO
	mail-ie0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932611AbaE2VW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 17:22:28 -0400
From: Doug Anderson <dianders@chromium.org>
To: Tomasz Figa <t.figa@samsung.com>, Mike Turquette <mturquette@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Cc: olof@lixom.net, javier.martinez@collabora.co.uk,
        Doug Anderson <dianders@chromium.org>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] clk: exynos5420: Keep aclk66_peric enabled during boot
Date: Thu, 29 May 2014 14:21:36 -0700
Message-Id: <1401398496-4624-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.9.1.423.g4596e3a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Right now if you've got earlyprintk enabled on exynos5420-peach-pit
then you'll get a hang on boot.  Here's why:

1. The i2c-s3c2410 driver will probe at subsys_initcall.  It will
   enable its clock and disable it.  This is the clock "i2c2".
2. The act of disabling "i2c2" will disable its parents.  In this case
   the parent is "aclk66_peric".  There are no other children of
   "aclk66_peric" officially enabled, so "aclk66_peric" will be turned
   off (despite being CLK_IGNORE_UNUSED, but that's by design).
3. The next time you try to earlyprintk you'll do so without the UART
   clock enabled.  That's because the UART clocks are also children of
   "aclk66_peric".  You'll hang.

There's no good place to put a clock enable for earlyprintk, which is
handled by a bunch of assembly code.  The best we can do is to handle
this in the clock driver.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 drivers/clk/samsung/clk-exynos5420.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/clk/samsung/clk-exynos5420.c b/drivers/clk/samsung/clk-exynos5420.c
index 9d7d7ee..1e586be 100644
--- a/drivers/clk/samsung/clk-exynos5420.c
+++ b/drivers/clk/samsung/clk-exynos5420.c
@@ -1172,11 +1172,17 @@ static struct of_device_id ext_clk_match[] __initdata = {
 	{ },
 };
 
+/* Keep these clocks on until late_initcall */
+static const char *boot_clocks[] __initconst = {
+	"aclk66_peric",
+};
+
 /* register exynos5420 clocks */
 static void __init exynos5x_clk_init(struct device_node *np,
 		enum exynos5x_soc soc)
 {
 	struct samsung_clk_provider *ctx;
+	int i;
 
 	if (np) {
 		reg_base = of_iomap(np, 0);
@@ -1226,6 +1232,12 @@ static void __init exynos5x_clk_init(struct device_node *np,
 	}
 
 	exynos5420_clk_sleep_init();
+
+	for (i = 0; i < ARRAY_SIZE(boot_clocks); i++) {
+		struct clk *to_enable = __clk_lookup(boot_clocks[i]);
+
+		clk_prepare_enable(to_enable);
+	}
 }
 
 static void __init exynos5420_clk_init(struct device_node *np)
@@ -1239,3 +1251,15 @@ static void __init exynos5800_clk_init(struct device_node *np)
 	exynos5x_clk_init(np, EXYNOS5800);
 }
 CLK_OF_DECLARE(exynos5800_clk, "samsung,exynos5800-clock", exynos5800_clk_init);
+
+static int __init exynos5420_clk_late_init(void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(boot_clocks); i++) {
+		struct clk *to_disable = __clk_lookup(boot_clocks[i]);
+
+		clk_disable_unprepare(to_disable);
+	}
+}
+late_initcall(exynos5420_clk_late_init);
-- 
1.9.1.423.g4596e3a

