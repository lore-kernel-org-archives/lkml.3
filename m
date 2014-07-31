Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042AbaGaLXm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 07:23:42 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:65428 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382AbaGaLWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 07:22:31 -0400
From: Humberto Silva Naves <hsnaves@gmail.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        Thomas Abraham <ta.omasab@gmail.com>,
        Andreas Farber <afaerber@suse.de>,
        Randy Dunlap <rdunlap@infradead.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Humberto Silva Naves <hsnaves@gmail.com>
Subject: [PATCHv2 1/5] clk: samsung: exynos5410: Add NULL pointer checks in clock init
Date: Thu, 31 Jul 2014 13:22:08 +0200
Message-Id: <1406805732-17372-2-git-send-email-hsnaves@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1406805732-17372-1-git-send-email-hsnaves@gmail.com>
References: <1406805732-17372-1-git-send-email-hsnaves@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added NULL pointer checks for device_node input parameter and
for the samsung_clk_provider context returned by samsung_clk_init.
Even though the *current* samsung_clk_init function never returns
a NULL pointer, it is good to keep this check in place to avoid
possible problems in the future due to changes in implementation.
That way, we also improve the consistency of the code that performs
clock initialization across the different SoCs.

Signed-off-by: Humberto Silva Naves <hsnaves@gmail.com>
---
 drivers/clk/samsung/clk-exynos5410.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/samsung/clk-exynos5410.c b/drivers/clk/samsung/clk-exynos5410.c
index 231475b..bf57c80 100644
--- a/drivers/clk/samsung/clk-exynos5410.c
+++ b/drivers/clk/samsung/clk-exynos5410.c
@@ -188,11 +188,17 @@ static void __init exynos5410_clk_init(struct device_node *np)
 	struct samsung_clk_provider *ctx;
 	void __iomem *reg_base;
 
-	reg_base = of_iomap(np, 0);
-	if (!reg_base)
-		panic("%s: failed to map registers\n", __func__);
+	if (np) {
+		reg_base = of_iomap(np, 0);
+		if (!reg_base)
+			panic("%s: failed to map registers\n", __func__);
+	} else {
+		panic("%s: unable to determine soc\n", __func__);
+	}
 
 	ctx = samsung_clk_init(np, reg_base, CLK_NR_CLKS);
+	if (!ctx)
+		panic("%s: unable to allocate context.\n", __func__);
 
 	samsung_clk_register_pll(ctx, exynos5410_plls,
 			ARRAY_SIZE(exynos5410_plls), reg_base);
-- 
1.7.10.4

