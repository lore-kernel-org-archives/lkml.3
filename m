Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751183AbaDOI36 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 04:29:58 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:47464 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbaDOI34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 04:29:56 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] clk: impd1: add pclk clocks
Date: Tue, 15 Apr 2014 10:29:45 +0200
Message-Id: <1397550585-7248-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IM-PD1 PrimeCells all have pclk assignments though this clock
cannot be controlled, and we need to provide this as a dummy
clock for the PL061 GPIO driver to probe, so let's assign it to
all the cells on the board.

Cc: Mike Turquette <mturquette@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/clk/versatile/clk-impd1.c | 36 +++++++++++++++++++++++++++++-------
 1 file changed, 29 insertions(+), 7 deletions(-)

diff --git a/drivers/clk/versatile/clk-impd1.c b/drivers/clk/versatile/clk-impd1.c
index 31b44f025f9e..8d7d4d5a514c 100644
--- a/drivers/clk/versatile/clk-impd1.c
+++ b/drivers/clk/versatile/clk-impd1.c
@@ -20,6 +20,8 @@
 #define IMPD1_LOCK	0x08
 
 struct impd1_clk {
+	char *pclkname;
+	struct clk *pclk;
 	char *vco1name;
 	struct clk *vco1clk;
 	char *vco2name;
@@ -31,7 +33,7 @@ struct impd1_clk {
 	struct clk *spiclk;
 	char *scname;
 	struct clk *scclk;
-	struct clk_lookup *clks[6];
+	struct clk_lookup *clks[15];
 };
 
 /* One entry for each connected IM-PD1 LM */
@@ -86,6 +88,7 @@ void integrator_impd1_clk_init(void __iomem *base, unsigned int id)
 {
 	struct impd1_clk *imc;
 	struct clk *clk;
+	struct clk *pclk;
 	int i;
 
 	if (id > 3) {
@@ -94,11 +97,18 @@ void integrator_impd1_clk_init(void __iomem *base, unsigned int id)
 	}
 	imc = &impd1_clks[id];
 
+	/* Register the fixed rate PCLK */
+	imc->pclkname = kasprintf(GFP_KERNEL, "lm%x-pclk", id);
+	pclk = clk_register_fixed_rate(NULL, imc->pclkname, NULL,
+				      CLK_IS_ROOT, 0);
+	imc->pclk = pclk;
+
 	imc->vco1name = kasprintf(GFP_KERNEL, "lm%x-vco1", id);
 	clk = icst_clk_register(NULL, &impd1_icst1_desc, imc->vco1name, NULL,
 				base);
 	imc->vco1clk = clk;
-	imc->clks[0] = clkdev_alloc(clk, NULL, "lm%x:01000", id);
+	imc->clks[0] = clkdev_alloc(pclk, "apb_pclk", "lm%x:01000", id);
+	imc->clks[1] = clkdev_alloc(clk, NULL, "lm%x:01000", id);
 
 	/* VCO2 is also called "CLK2" */
 	imc->vco2name = kasprintf(GFP_KERNEL, "lm%x-vco2", id);
@@ -107,28 +117,38 @@ void integrator_impd1_clk_init(void __iomem *base, unsigned int id)
 	imc->vco2clk = clk;
 
 	/* MMCI uses CLK2 right off */
-	imc->clks[1] = clkdev_alloc(clk, NULL, "lm%x:00700", id);
+	imc->clks[2] = clkdev_alloc(pclk, "apb_pclk", "lm%x:00700", id);
+	imc->clks[3] = clkdev_alloc(clk, NULL, "lm%x:00700", id);
 
 	/* UART reference clock divides CLK2 by a fixed factor 4 */
 	imc->uartname = kasprintf(GFP_KERNEL, "lm%x-uartclk", id);
 	clk = clk_register_fixed_factor(NULL, imc->uartname, imc->vco2name,
 				   CLK_IGNORE_UNUSED, 1, 4);
 	imc->uartclk = clk;
-	imc->clks[2] = clkdev_alloc(clk, NULL, "lm%x:00100", id);
-	imc->clks[3] = clkdev_alloc(clk, NULL, "lm%x:00200", id);
+	imc->clks[4] = clkdev_alloc(pclk, "apb_pclk", "lm%x:00100", id);
+	imc->clks[5] = clkdev_alloc(clk, NULL, "lm%x:00100", id);
+	imc->clks[6] = clkdev_alloc(pclk, "apb_pclk", "lm%x:00200", id);
+	imc->clks[7] = clkdev_alloc(clk, NULL, "lm%x:00200", id);
 
 	/* SPI PL022 clock divides CLK2 by a fixed factor 64 */
 	imc->spiname = kasprintf(GFP_KERNEL, "lm%x-spiclk", id);
 	clk = clk_register_fixed_factor(NULL, imc->spiname, imc->vco2name,
 				   CLK_IGNORE_UNUSED, 1, 64);
-	imc->clks[4] = clkdev_alloc(clk, NULL, "lm%x:00300", id);
+	imc->clks[8] = clkdev_alloc(pclk, "apb_pclk", "lm%x:00300", id);
+	imc->clks[9] = clkdev_alloc(clk, NULL, "lm%x:00300", id);
+
+	/* The GPIO blocks and AACI have only PCLK */
+	imc->clks[10] = clkdev_alloc(pclk, "apb_pclk", "lm%x:00400", id);
+	imc->clks[11] = clkdev_alloc(pclk, "apb_pclk", "lm%x:00500", id);
+	imc->clks[12] = clkdev_alloc(pclk, "apb_pclk", "lm%x:00800", id);
 
 	/* Smart Card clock divides CLK2 by a fixed factor 4 */
 	imc->scname = kasprintf(GFP_KERNEL, "lm%x-scclk", id);
 	clk = clk_register_fixed_factor(NULL, imc->scname, imc->vco2name,
 				   CLK_IGNORE_UNUSED, 1, 4);
 	imc->scclk = clk;
-	imc->clks[5] = clkdev_alloc(clk, NULL, "lm%x:00600", id);
+	imc->clks[13] = clkdev_alloc(pclk, "apb_pclk", "lm%x:00600", id);
+	imc->clks[14] = clkdev_alloc(clk, NULL, "lm%x:00600", id);
 
 	for (i = 0; i < ARRAY_SIZE(imc->clks); i++)
 		clkdev_add(imc->clks[i]);
@@ -149,9 +169,11 @@ void integrator_impd1_clk_exit(unsigned int id)
 	clk_unregister(imc->uartclk);
 	clk_unregister(imc->vco2clk);
 	clk_unregister(imc->vco1clk);
+	clk_unregister(imc->pclk);
 	kfree(imc->scname);
 	kfree(imc->spiname);
 	kfree(imc->uartname);
 	kfree(imc->vco2name);
 	kfree(imc->vco1name);
+	kfree(imc->pclkname);
 }
-- 
1.9.0

