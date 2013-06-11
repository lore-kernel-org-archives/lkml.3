Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678Ab3FKPYN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 11:24:13 -0400
Received: from mail-ye0-f202.google.com ([209.85.213.202]:54413 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753705Ab3FKPYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 11:24:11 -0400
From: Doug Anderson <dianders@chromium.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <tomasz.figa@gmail.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Olof Johansson <olof@lixom.net>,
        Vikas Sajjan <vikas.sajjan@linaro.org>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Doug Anderson <dianders@chromium.org>,
        Tomasz Figa <t.figa@samsung.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2] clk: samsung: Fix pll36xx_recalc_rate to handle kdiv properly
Date: Tue, 11 Jun 2013 08:24:05 -0700
Message-Id: <1370964245-31005-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <1370026725-22910-1-git-send-email-dianders@chromium.org>
References: <1370026725-22910-1-git-send-email-dianders@chromium.org>
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

Signed-off-by: Doug Anderson <dianders@chromium.org>
Acked-by: Kukjin Kim <kgene.kim@samsung.com>
Reviewed-by: Vikas Sajjan <vikas.sajjan@linaro.org>
---
Changes in v2:
- Rebased against mturquette/linux.git clk-fixes

 drivers/clk/samsung/clk-pll.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/samsung/clk-pll.c b/drivers/clk/samsung/clk-pll.c
index 89135f6..362f12d 100644
--- a/drivers/clk/samsung/clk-pll.c
+++ b/drivers/clk/samsung/clk-pll.c
@@ -111,7 +111,8 @@ static unsigned long samsung_pll36xx_recalc_rate(struct clk_hw *hw,
 				unsigned long parent_rate)
 {
 	struct samsung_clk_pll36xx *pll = to_clk_pll36xx(hw);
-	u32 mdiv, pdiv, sdiv, kdiv, pll_con0, pll_con1;
+	u32 mdiv, pdiv, sdiv, pll_con0, pll_con1;
+	s16 kdiv;
 	u64 fvco = parent_rate;
 
 	pll_con0 = __raw_readl(pll->con_reg);
@@ -119,7 +120,7 @@ static unsigned long samsung_pll36xx_recalc_rate(struct clk_hw *hw,
 	mdiv = (pll_con0 >> PLL36XX_MDIV_SHIFT) & PLL36XX_MDIV_MASK;
 	pdiv = (pll_con0 >> PLL36XX_PDIV_SHIFT) & PLL36XX_PDIV_MASK;
 	sdiv = (pll_con0 >> PLL36XX_SDIV_SHIFT) & PLL36XX_SDIV_MASK;
-	kdiv = pll_con1 & PLL36XX_KDIV_MASK;
+	kdiv = (s16)(pll_con1 & PLL36XX_KDIV_MASK);
 
 	fvco *= (mdiv << 16) + kdiv;
 	do_div(fvco, (pdiv << sdiv));
-- 
1.8.3

