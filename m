Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490AbbALPM5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 10:12:57 -0500
Received: from down.free-electrons.com ([37.187.137.238]:54698 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751281AbbALPMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 10:12:55 -0500
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Bo Shen <voice.shen@atmel.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        stable@vger.kernel.org
Subject: [RESEND PATCH] clk: at91: keep slow clk enabled to prevent system hang
Date: Mon, 12 Jan 2015 16:12:50 +0100
Message-Id: <1421075570-31200-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All slow clk users are not properly requesting it (get + prepare + enable)
before using it.
If all users properly requesting this clock decide that they don't need it
anymore (or are removed), this lead to this clock being disabled while
faulty users are still requiring it, which in turn hangs the system.

Prevent slow oscillator clock from being disabled until all users are
properly requesting it.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
Reported-by: Bo Shen <voice.shen@atmel.com>
Cc: stable@vger.kernel.org
---
Hi Mike,

Sorry for the noise, but I forgot to add the LKML and LAKML in Cc.

Can you have a look at this fix and let me know if this is how you want this
problem addressed ?
I can also request (get + prepare + enable) the clk in the pmc probe function,
so that it can never be disabled.

If you're fine with the approach, can you queue it for the next -rc ?

Best Regards,

Boris

 drivers/clk/at91/clk-slow.c | 28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/at91/clk-slow.c b/drivers/clk/at91/clk-slow.c
index 32f7c1b..effe3b0 100644
--- a/drivers/clk/at91/clk-slow.c
+++ b/drivers/clk/at91/clk-slow.c
@@ -96,7 +96,19 @@ static void clk_slow_osc_unprepare(struct clk_hw *hw)
 	if (tmp & AT91_SCKC_OSC32BYP)
 		return;
 
-	writel(tmp & ~AT91_SCKC_OSC32EN, sckcr);
+	/*
+	 * FIXME: All slow clk users are not properly requesting it (get +
+	 * prepare + enable) before using it.
+	 * If all users properly requesting this clock decide that they don't
+	 * need it anymore (or are removed), this lead to this clock being
+	 * disabled while faulty users are still requiring it, which in turn
+	 * hangs the system.
+	 * Prevent this clock from being disabled until all users are properly
+	 * requesting it.
+	 * Once this is done we should re-introduce this line:
+	 *
+	 * writel(tmp & ~AT91_SCKC_OSC32EN, sckcr);
+	 */
 }
 
 static int clk_slow_osc_is_prepared(struct clk_hw *hw)
@@ -211,7 +223,19 @@ static void clk_slow_rc_osc_unprepare(struct clk_hw *hw)
 	struct clk_slow_rc_osc *osc = to_clk_slow_rc_osc(hw);
 	void __iomem *sckcr = osc->sckcr;
 
-	writel(readl(sckcr) & ~AT91_SCKC_RCEN, sckcr);
+	/*
+	 * FIXME: All slow clk users are not properly requesting it (get +
+	 * prepare + enable) before using it.
+	 * If all users properly requesting this clock decide that they don't
+	 * need it anymore (or are removed), this lead to this clock being
+	 * disabled while faulty users are still requiring it, which in turn
+	 * hangs the system.
+	 * Prevent this clock from being disabled until all users are properly
+	 * requesting it.
+	 * Once this is done we should re-introduce this line:
+	 *
+	 * writel(readl(sckcr) & ~AT91_SCKC_RCEN, sckcr);
+	 */
 }
 
 static int clk_slow_rc_osc_is_prepared(struct clk_hw *hw)
-- 
1.9.1

