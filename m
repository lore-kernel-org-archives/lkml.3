Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908AbaLEWvn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 17:51:43 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54127 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879AbaLEWvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:51:38 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        James Hogan <james.hogan@imgtec.com>,
        Thomas Abraham <thomas.ab@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>, Max Schwarz <max.schwarz@online.de>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Michael Turquette <mturquette@linaro.org>
Subject: [PATCH 3.17 106/122] clk-divider: Fix READ_ONLY when divider > 1
Date: Fri,  5 Dec 2014 14:44:40 -0800
Message-Id: <20141205223322.001696407@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205223305.514276242@linuxfoundation.org>
References: <20141205223305.514276242@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Hogan <james.hogan@imgtec.com>

commit e6d5e7d90be92cee626d7ec16ca9b06f1eed710b upstream.

Commit 79c6ab509558 (clk: divider: add CLK_DIVIDER_READ_ONLY flag) in
v3.16 introduced the CLK_DIVIDER_READ_ONLY flag which caused the
recalc_rate() and round_rate() clock callbacks to be omitted.

However using this flag has the unfortunate side effect of causing the
clock recalculation code when a clock rate change is attempted to always
treat it as a pass-through clock, i.e. with a fixed divide of 1, which
may not be the case. Child clock rates are then recalculated using the
wrong parent rate.

Therefore instead of dropping the recalc_rate() and round_rate()
callbacks, alter clk_divider_bestdiv() to always report the current
divider as the best divider so that it is never altered.

For me the read only clock was the system clock, which divided the PLL
rate by 2, from which both the UART and the SPI clocks were divided.
Initial setting of the UART rate set it correctly, but when the SPI
clock was set, the other child clocks were miscalculated. The UART clock
was recalculated using the PLL rate as the parent rate, resulting in a
UART new_rate of double what it should be, and a UART which spewed forth
garbage when the rate changes were propagated.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Thomas Abraham <thomas.ab@samsung.com>
Cc: Tomasz Figa <t.figa@samsung.com>
Cc: Max Schwarz <max.schwarz@online.de>
Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>
Signed-off-by: Michael Turquette <mturquette@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/clk-divider.c    |   18 +++++++++---------
 drivers/clk/rockchip/clk.c   |    4 +---
 include/linux/clk-provider.h |    1 -
 3 files changed, 10 insertions(+), 13 deletions(-)

--- a/drivers/clk/clk-divider.c
+++ b/drivers/clk/clk-divider.c
@@ -263,6 +263,14 @@ static int clk_divider_bestdiv(struct cl
 	if (!rate)
 		rate = 1;
 
+	/* if read only, just return current value */
+	if (divider->flags & CLK_DIVIDER_READ_ONLY) {
+		bestdiv = readl(divider->reg) >> divider->shift;
+		bestdiv &= div_mask(divider);
+		bestdiv = _get_div(divider, bestdiv);
+		return bestdiv;
+	}
+
 	maxdiv = _get_maxdiv(divider);
 
 	if (!(__clk_get_flags(hw->clk) & CLK_SET_RATE_PARENT)) {
@@ -361,11 +369,6 @@ const struct clk_ops clk_divider_ops = {
 };
 EXPORT_SYMBOL_GPL(clk_divider_ops);
 
-const struct clk_ops clk_divider_ro_ops = {
-	.recalc_rate = clk_divider_recalc_rate,
-};
-EXPORT_SYMBOL_GPL(clk_divider_ro_ops);
-
 static struct clk *_register_divider(struct device *dev, const char *name,
 		const char *parent_name, unsigned long flags,
 		void __iomem *reg, u8 shift, u8 width,
@@ -391,10 +394,7 @@ static struct clk *_register_divider(str
 	}
 
 	init.name = name;
-	if (clk_divider_flags & CLK_DIVIDER_READ_ONLY)
-		init.ops = &clk_divider_ro_ops;
-	else
-		init.ops = &clk_divider_ops;
+	init.ops = &clk_divider_ops;
 	init.flags = flags | CLK_IS_BASIC;
 	init.parent_names = (parent_name ? &parent_name: NULL);
 	init.num_parents = (parent_name ? 1 : 0);
--- a/drivers/clk/rockchip/clk.c
+++ b/drivers/clk/rockchip/clk.c
@@ -89,9 +89,7 @@ struct clk *rockchip_clk_register_branch
 		div->width = div_width;
 		div->lock = lock;
 		div->table = div_table;
-		div_ops = (div_flags & CLK_DIVIDER_READ_ONLY)
-						? &clk_divider_ro_ops
-						: &clk_divider_ops;
+		div_ops = &clk_divider_ops;
 	}
 
 	clk = clk_register_composite(NULL, name, parent_names, num_parents,
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -341,7 +341,6 @@ struct clk_divider {
 #define CLK_DIVIDER_READ_ONLY		BIT(5)
 
 extern const struct clk_ops clk_divider_ops;
-extern const struct clk_ops clk_divider_ro_ops;
 struct clk *clk_register_divider(struct device *dev, const char *name,
 		const char *parent_name, unsigned long flags,
 		void __iomem *reg, u8 shift, u8 width,


