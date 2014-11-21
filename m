Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090AbaKUSeV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 13:34:21 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:28881 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932AbaKUSeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 13:34:18 -0500
From: Alban Bedel <albeu@free.fr>
To: linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org, Alban Bedel <albeu@free.fr>,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH 2/4] clk: fractional-divider: add support for m/(n+1) dividers
Date: Fri, 21 Nov 2014 19:34:01 +0100
Message-Id: <1416594843-12352-2-git-send-email-albeu@free.fr>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1416594843-12352-1-git-send-email-albeu@free.fr>
References: <1416594843-12352-1-git-send-email-albeu@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many divider hardware use a (n+1) scheme to prevent a zero divider.

Signed-off-by: Alban Bedel <albeu@free.fr>
---
 drivers/clk/clk-fractional-divider.c | 4 ++++
 include/linux/clk-provider.h         | 1 +
 2 files changed, 5 insertions(+)

diff --git a/drivers/clk/clk-fractional-divider.c b/drivers/clk/clk-fractional-divider.c
index b562281..bcee7f7d3 100644
--- a/drivers/clk/clk-fractional-divider.c
+++ b/drivers/clk/clk-fractional-divider.c
@@ -35,6 +35,8 @@ static unsigned long clk_fd_recalc_rate(struct clk_hw *hw,
 
 	m = (val & fd->mmask) >> fd->mshift;
 	n = (val & fd->nmask) >> fd->nshift;
+	if (fd->flags & CLK_FRACTIONAL_DIVIDER_DIVISOR_PLUS_ONE)
+		n += 1;
 
 	ret = (u64)parent_rate * m;
 	do_div(ret, n);
@@ -74,6 +76,8 @@ static int clk_fd_set_rate(struct clk_hw *hw, unsigned long rate,
 	div = gcd(parent_rate, rate);
 	m = rate / div;
 	n = parent_rate / div;
+	if (fd->flags & CLK_FRACTIONAL_DIVIDER_DIVISOR_PLUS_ONE)
+		n -= 1;
 
 	if (fd->lock)
 		spin_lock_irqsave(fd->lock, flags);
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 29ea77a..00013b1 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -463,6 +463,7 @@ struct clk_fractional_divider {
 };
 
 #define CLK_FRACTIONAL_DIVIDER_READ_ONLY		BIT(0)
+#define CLK_FRACTIONAL_DIVIDER_DIVISOR_PLUS_ONE		BIT(1)
 
 extern const struct clk_ops clk_fractional_divider_ops;
 extern const struct clk_ops clk_fractional_divider_ro_ops;
-- 
2.0.0

