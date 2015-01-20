Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506AbbATPlN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 10:41:13 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:41309 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726AbbATPlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 10:41:09 -0500
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
        patrice.chotard@st.com, mturquette@linaro.org, sboyd@codeaurora.org,
        chris@printf.net, ulf.hansson@linaro.org
Cc: peter.griffin@linaro.org, lee.jones@linaro.org, peppe.cavallaro@st.com,
        olivier.bideau@st.com, gabriel.fernandez@st.com,
        linux-mmc@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH 1/4] clk: st: STiH410: Fix pdiv and fdiv divisor when setting rate
Date: Tue, 20 Jan 2015 15:32:41 +0000
Message-Id: <1421767964-8798-2-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421767964-8798-1-git-send-email-peter.griffin@linaro.org>
References: <1421767964-8798-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Debugging eMMC on upstream kernels it has been noticed that when the
targetpack configures MMC0 clock to 200Mhz (required to switch to
HS200) then everything works OK. However if the kernel sets the
clock rate using clk_set_rate, then the eMMC card initialisation
fails with timeouts. Lower clock speeds (the default being 50Mhz)
work ok, but they we fail to get good eMMC transfer rates.

Looking through the vendor kernel clock driver reveals Giuseppe
had already fixed this issue, but the patch hasn't made its way
upstream.

The issue is fixed by changing the logic to manage the pdiv and
fdiv divisors used for setting the rate inside the flexgen driver code.

Pdiv is mainly targeted for low freq results, while fdiv should be
used for divs =< 64. The other way can lead to 'duty cycle'
issues.

I have changed the original patch to keep the original behaviour
in cases where the div is >64 which matches the original comment
and patch description more closely. Although no clocks appear to hit
this case currently when booting an upstream kernel.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
---
 drivers/clk/st/clk-flexgen.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/st/clk-flexgen.c b/drivers/clk/st/clk-flexgen.c
index 2282cef..3a484b3 100644
--- a/drivers/clk/st/clk-flexgen.c
+++ b/drivers/clk/st/clk-flexgen.c
@@ -138,16 +138,27 @@ static int flexgen_set_rate(struct clk_hw *hw, unsigned long rate,
 	struct flexgen *flexgen = to_flexgen(hw);
 	struct clk_hw *pdiv_hw = &flexgen->pdiv.hw;
 	struct clk_hw *fdiv_hw = &flexgen->fdiv.hw;
-	unsigned long primary_div = 0;
+	unsigned long div = 0;
 	int ret = 0;
 
 	pdiv_hw->clk = hw->clk;
 	fdiv_hw->clk = hw->clk;
 
-	primary_div = clk_best_div(parent_rate, rate);
+	div = clk_best_div(parent_rate, rate);
 
-	clk_divider_ops.set_rate(fdiv_hw, parent_rate, parent_rate);
-	ret = clk_divider_ops.set_rate(pdiv_hw, rate, rate * primary_div);
+	/*
+	* pdiv is mainly targeted for low freq results, while fdiv
+	* should be used for div <= 64. The other way round can
+	* lead to 'duty cycle' issues.
+	*/
+
+	if (div <= 64) {
+		clk_divider_ops.set_rate(pdiv_hw, parent_rate, parent_rate);
+		ret = clk_divider_ops.set_rate(fdiv_hw, rate, rate * div);
+	} else {
+		clk_divider_ops.set_rate(fdiv_hw, parent_rate, parent_rate);
+		ret = clk_divider_ops.set_rate(pdiv_hw, rate, rate * div);
+	}
 
 	return ret;
 }
-- 
1.9.1

