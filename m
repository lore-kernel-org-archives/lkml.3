Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756457Ab3EaTGQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 15:06:16 -0400
Received: from mail-qe0-f74.google.com ([209.85.128.74]:49057 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780Ab3EaTGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 15:06:05 -0400
From: Doug Anderson <dianders@chromium.org>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Olof Johansson <olof@lixom.net>,
        Vikas Sajjan <vikas.sajjan@linaro.org>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Doug Anderson <dianders@chromium.org>,
        Tomasz Figa <t.figa@samsung.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] clk: samsung: Fix pll36xx_recalc_rate to handle kdiv properly
Date: Fri, 31 May 2013 11:58:45 -0700
Message-Id: <1370026725-22910-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The KDIV value is often listed as unsigned but it needs to be treated
as a 16-bit signed value when using it in calculations.  Fix our rate
recalculation to do this correctly.

Before doing this, I tried setting EPLL on exynos5250 to:
  rate, m, p, s, k = 80000000, 107, 2, 4, 43691

This rate is exactly from the table in the exynos5250 user manual.

I read this back as 80750003 with:
  cat /sys/kernel/debug/clk/fin_pll/fout_epll/clk_rate

After this patch, it reads back as 80000003

  mw 0x10020130 a06b0204
  mw 0x10020134 0000aaab

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
This patch is based upon another in-flight patch to avoid conflicts:
  clk: samsung: Use clk->base instead of directly using clk->con0 for PLL3xxx
  https://patchwork.kernel.org/patch/2629751/

 drivers/clk/samsung/clk-pll.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/samsung/clk-pll.c b/drivers/clk/samsung/clk-pll.c
index 01f17cf..26416bb 100644
--- a/drivers/clk/samsung/clk-pll.c
+++ b/drivers/clk/samsung/clk-pll.c
@@ -115,7 +115,8 @@ static unsigned long samsung_pll36xx_recalc_rate(struct clk_hw *hw,
 				unsigned long parent_rate)
 {
 	struct samsung_clk_pll *pll = to_clk_pll(hw);
-	u32 mdiv, pdiv, sdiv, kdiv, pll_con0, pll_con1;
+	u32 mdiv, pdiv, sdiv, pll_con0, pll_con1;
+	s16 kdiv;
 	u64 fvco = parent_rate;
 
 	pll_con0 = pll_readl(pll, PLL36XX_CON0_OFFSET);
@@ -123,7 +124,7 @@ static unsigned long samsung_pll36xx_recalc_rate(struct clk_hw *hw,
 	mdiv = (pll_con0 >> PLL36XX_MDIV_SHIFT) & PLL36XX_MDIV_MASK;
 	pdiv = (pll_con0 >> PLL36XX_PDIV_SHIFT) & PLL36XX_PDIV_MASK;
 	sdiv = (pll_con0 >> PLL36XX_SDIV_SHIFT) & PLL36XX_SDIV_MASK;
-	kdiv = pll_con1 & PLL36XX_KDIV_MASK;
+	kdiv = (s16)(pll_con1 & PLL36XX_KDIV_MASK);
 
 	fvco *= (mdiv << 16) + kdiv;
 	do_div(fvco, (pdiv << sdiv));
-- 
1.8.2.1

