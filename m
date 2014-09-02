Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110AbaIBHvN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 03:51:13 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35646 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752331AbaIBHuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 03:50:24 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Mike Turquette <mturquette@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Ga=C3=ABl=20PORTAY?= <gael.portay@gmail.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH 3/5] clk: at91: fix recalc_rate implementation of PLL driver
Date: Tue,  2 Sep 2014 09:50:16 +0200
Message-Id: <1409644218-13677-4-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409644218-13677-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1409644218-13677-1-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the cached values to calculate PLL rate instead of the register values.
This is required to prevent erroneous PLL rate return when the PLL rate
has been configured but the PLL is not prepared yet.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
Reported-by: Gaël PORTAY <gael.portay@gmail.com>
---
 drivers/clk/at91/clk-pll.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/clk/at91/clk-pll.c b/drivers/clk/at91/clk-pll.c
index a1adcf1..6ec79db 100644
--- a/drivers/clk/at91/clk-pll.c
+++ b/drivers/clk/at91/clk-pll.c
@@ -151,16 +151,11 @@ static unsigned long clk_pll_recalc_rate(struct clk_hw *hw,
 					 unsigned long parent_rate)
 {
 	struct clk_pll *pll = to_clk_pll(hw);
-	const struct clk_pll_layout *layout = pll->layout;
-	struct at91_pmc *pmc = pll->pmc;
-	int offset = PLL_REG(pll->id);
-	u32 tmp = pmc_read(pmc, offset) & layout->pllr_mask;
-	u8 div = PLL_DIV(tmp);
-	u16 mul = PLL_MUL(tmp, layout);
-	if (!div || !mul)
+
+	if (!pll->div || !pll->mul)
 		return 0;
 
-	return (parent_rate * (mul + 1)) / div;
+	return (parent_rate / pll->div) * (pll->mul + 1);
 }
 
 static long clk_pll_get_best_div_mul(struct clk_pll *pll, unsigned long rate,
-- 
1.9.1

