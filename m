Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab3AWLmD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 06:42:03 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:49110 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755388Ab3AWLmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 06:42:01 -0500
From: Afzal Mohammed <afzal@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Tony Lindgren <tony@atomide.com>, Paul Walmsley <paul@pwsan.com>,
        Mike Turquette <mturquette@linaro.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH v2 1/4] ARM: OMAP2+: dpll: round rate to closest value
Date: Wed, 23 Jan 2013 17:11:52 +0530
Message-ID: <871e6890897534b6c3669e252f23bef5ff1247b6.1358937533.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <cover.1358937533.git.afzal@ti.com>
References: <cover.1358937533.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently round rate function would return proper rate iff requested
rate exactly matches the PLL lockable rate. This causes set_rate to
fail if exact rate could not be set. Instead round rate may return
closest rate possible (less than the requested). And if any user is
badly in need of exact rate, then return value of round rate could
be used to decide whether to invoke set rate or not.

Modify round rate so that it return closest possible rate.

This was required to get display working on am335x. Without this
display rate could not be set (taking help of SET_RATE_PARENT). Couple
of the downstream clocks of display PLL are basic clock dividers and
they do MULT_ROUND_UP before requesting rate on PLL causing values
that mostly could not be locked by PLL. And even otherwise, if
requested rate for a particular pixel clock could not be satisfied by
PLL, display would not work. This change will resolve the issue.

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---
 arch/arm/mach-omap2/clkt_dpll.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-omap2/clkt_dpll.c b/arch/arm/mach-omap2/clkt_dpll.c
index 924c230..15e6d41 100644
--- a/arch/arm/mach-omap2/clkt_dpll.c
+++ b/arch/arm/mach-omap2/clkt_dpll.c
@@ -345,20 +345,22 @@ long omap2_dpll_round_rate(struct clk_hw *hw, unsigned long target_rate,
 		pr_debug("clock: %s: m = %d: n = %d: new_rate = %ld\n",
 			 clk_name, m, n, new_rate);
 
-		if (target_rate == new_rate) {
+		if ((new_rate <= target_rate) &&
+		    (new_rate > dd->last_rounded_rate)) {
 			dd->last_rounded_m = m;
 			dd->last_rounded_n = n;
-			dd->last_rounded_rate = target_rate;
-			break;
+			dd->last_rounded_rate = new_rate;
+			if (new_rate == target_rate)
+				break;
 		}
 	}
 
-	if (target_rate != new_rate) {
+	if (!dd->last_rounded_rate) {
 		pr_debug("clock: %s: cannot round to rate %ld\n",
 			 clk_name, target_rate);
 		return ~0;
 	}
 
-	return target_rate;
+	return dd->last_rounded_rate;
 }
 
-- 
1.7.12

