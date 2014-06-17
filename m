Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933402AbaFQOyJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 10:54:09 -0400
Received: from mirror2.csie.ntu.edu.tw ([140.112.30.76]:41464 "EHLO
	mirror2.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933379AbaFQOyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 10:54:07 -0400
From: Chen-Yu Tsai <wens@csie.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Chen-Yu Tsai <wens@csie.org>, linux-serial@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Luc Verhaegen <libv@skynet.be>
Subject: [PATCH v2 05/20] clk: sunxi: Support factor clocks with N multiplier factor starting from 1
Date: Tue, 17 Jun 2014 22:52:42 +0800
Message-Id: <1403016777-15121-6-git-send-email-wens@csie.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1403016777-15121-1-git-send-email-wens@csie.org>
References: <1403016777-15121-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PLLs on newer Allwinner SoC's, such as the A31 and A23, have a
N multiplier factor that starts from 1, not 0.

This patch adds an option to the clock driver's config data structures
to define the difference.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/clk/sunxi/clk-factors.c | 5 ++++-
 drivers/clk/sunxi/clk-factors.h | 1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/sunxi/clk-factors.c b/drivers/clk/sunxi/clk-factors.c
index 3806d97..399cf4d 100644
--- a/drivers/clk/sunxi/clk-factors.c
+++ b/drivers/clk/sunxi/clk-factors.c
@@ -62,7 +62,10 @@ static unsigned long clk_factors_recalc_rate(struct clk_hw *hw,
 		p = FACTOR_GET(config->pshift, config->pwidth, reg);
 
 	/* Calculate the rate */
-	rate = (parent_rate * n * (k + 1) >> p) / (m + 1);
+	if (config->n_from_one)
+		rate = (parent_rate * (n + 1) * (k + 1) >> p) / (m + 1);
+	else
+		rate = (parent_rate * n * (k + 1) >> p) / (m + 1);
 
 	return rate;
 }
diff --git a/drivers/clk/sunxi/clk-factors.h b/drivers/clk/sunxi/clk-factors.h
index 02e1a43..0484a48 100644
--- a/drivers/clk/sunxi/clk-factors.h
+++ b/drivers/clk/sunxi/clk-factors.h
@@ -15,6 +15,7 @@ struct clk_factors_config {
 	u8 mwidth;
 	u8 pshift;
 	u8 pwidth;
+	u8 n_from_one;
 };
 
 struct clk_factors {
-- 
2.0.0

