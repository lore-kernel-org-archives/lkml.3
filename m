Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986AbaGaVno (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 17:43:44 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:54199 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbaGaVnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 17:43:42 -0400
From: Humberto Silva Naves <hsnaves@gmail.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        Andreas Farber <afaerber@suse.de>,
        Humberto Silva Naves <hsnaves@gmail.com>
Subject: [PATCH] clk: samsung: Changed return behavior of samsung_clk_init
Date: Thu, 31 Jul 2014 23:43:21 +0200
Message-Id: <1406843002-15652-1-git-send-email-hsnaves@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of invoking panic, the samsung_clk_init returns a NULL
pointer to indicate that an error has occurred. All the drivers
using this function were changed appropriately (in this case
just the clk-exynos5410).

This patch was suggested by Tomasz Figa in
http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg34982.html

Signed-off-by: Humberto Silva Naves <hsnaves@gmail.com>
---
 drivers/clk/samsung/clk-exynos5410.c |    2 ++
 drivers/clk/samsung/clk.c            |    8 +++++---
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/samsung/clk-exynos5410.c b/drivers/clk/samsung/clk-exynos5410.c
index 231475b..19657b4 100644
--- a/drivers/clk/samsung/clk-exynos5410.c
+++ b/drivers/clk/samsung/clk-exynos5410.c
@@ -193,6 +193,8 @@ static void __init exynos5410_clk_init(struct device_node *np)
 		panic("%s: failed to map registers\n", __func__);
 
 	ctx = samsung_clk_init(np, reg_base, CLK_NR_CLKS);
+	if (!ctx)
+		panic("%s: unable to allocate context.\n", __func__);
 
 	samsung_clk_register_pll(ctx, exynos5410_plls,
 			ARRAY_SIZE(exynos5410_plls), reg_base);
diff --git a/drivers/clk/samsung/clk.c b/drivers/clk/samsung/clk.c
index deab84d..0cf0ec6 100644
--- a/drivers/clk/samsung/clk.c
+++ b/drivers/clk/samsung/clk.c
@@ -57,11 +57,13 @@ struct samsung_clk_provider *__init samsung_clk_init(struct device_node *np,
 
 	ctx = kzalloc(sizeof(struct samsung_clk_provider), GFP_KERNEL);
 	if (!ctx)
-		panic("could not allocate clock provider context.\n");
+		return NULL;
 
 	clk_table = kcalloc(nr_clks, sizeof(struct clk *), GFP_KERNEL);
-	if (!clk_table)
-		panic("could not allocate clock lookup table\n");
+	if (!clk_table) {
+		kfree(ctx);
+		return NULL;
+	}
 
 	for (i = 0; i < nr_clks; ++i)
 		clk_table[i] = ERR_PTR(-ENOENT);
-- 
1.7.10.4

