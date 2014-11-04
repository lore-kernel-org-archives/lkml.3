Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531AbaKDHzb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 02:55:31 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:39995 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbaKDHz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 02:55:27 -0500
From: Kever Yang <kever.yang@rock-chips.com>
To: Mike Turquette <mturquette@linaro.org>, Heiko Stuebner <heiko@sntech.de>
Cc: dianders@chromium.org, sonnyrao@chromium.org, addy.ke@rock-chips.com,
        cf@rock-chips.com, fzf@rock-chips.com, ykk@rock-chips.com,
        yzq@rock-chips.com, dkl@rock-chips.com, huangtao@rock-chips.com,
        Kever Yang <kever.yang@rock-chips.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] clk: rockchip: add the vop_determine_rate for vop dclock
Date: Tue,  4 Nov 2014 15:52:38 +0800
Message-Id: <1415087559-19444-5-git-send-email-kever.yang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415087559-19444-1-git-send-email-kever.yang@rock-chips.com>
References: <1415087559-19444-1-git-send-email-kever.yang@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rk3288 has 5 PLLs(APLL, DPLL, CPLL, GPLL, NPLL),
APLL is for CPU clock only and DPLL is for DRAM clock only,
and other 3 PLls used for all other peripherals.
We have to make a total solution for how to campatible all
kinds of clock requirement by on chip peripheral controllers.

Some controllers like I2S and HDMI need accurate frequency while
others controllers accept clock rate with margin.

According to our experience on rk3288, we prefer to use CPLL and GPLL fixed
at 400MHz and 594MHz for general use for most peripheral.

The fraction divider should be enough for I2S controller.

The HDMI is the most diffical one if we have to support all the
resolution requirement for frequency. Most people use 720p and
1080 i/p resolution with 74.25MHz/148.5MHz, which can get clock
rate from 594MHz(maybe from GPLL). some other resolution like
640*480 will use 25.175MHz, which is hard to get from general
used PLLs.

So it is better to make HDMI controller has the right to change
the PLL frequency and get the clock rate it wants.

We set NPLL to 500MHz as default, if HDMI can get what it need
from existent clock provider, then change its divider and switch
to that parent; if not, we have to change the NPLL's output
and always make CPLL&GPLL not change.

This patch add vop_determinate_rate as a div_ops to handle
the HDMI clock things.

Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
---

 drivers/clk/rockchip/clk-rk3288.c | 69 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 69 insertions(+)

diff --git a/drivers/clk/rockchip/clk-rk3288.c b/drivers/clk/rockchip/clk-rk3288.c
index 48412e9..0151140 100644
--- a/drivers/clk/rockchip/clk-rk3288.c
+++ b/drivers/clk/rockchip/clk-rk3288.c
@@ -14,6 +14,7 @@
  */
 
 #include <linux/clk-provider.h>
+#include <linux/clk-private.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <dt-bindings/clock/rk3288-cru.h>
@@ -25,6 +26,7 @@
 enum rk3288_plls {
 	apll, dpll, cpll, gpll, npll,
 };
+const struct clk_ops dclk_vop_ops;
 
 struct rockchip_pll_rate_table rk3288_pll_rates[] = {
 	RK3066_PLL_RATE(2208000000, 1, 92, 1),
@@ -766,6 +768,73 @@ static const char *rk3288_critical_clocks[] __initconst = {
 	"aclk_peri",
 	"hclk_peri",
 };
+#define DCLK_VOP_PARENT_NPLL 2
+
+long dclk_vop_determine_rate(struct clk_hw *hw, unsigned long rate,
+					unsigned long *best_parent_rate,
+					struct clk **best_parent_p)
+{
+	struct clk *clk = hw->clk, *parent;
+	unsigned long parent_rate, best = 0;
+	int num_parents = clk->num_parents;
+	int i;
+
+	/*
+	 * check if one of the generic plls can provide a cleanly dividable
+	 * rate without changing them.
+	 */
+	for (i = 0; i < (num_parents - 1); i++) {
+		parent = clk_get_parent_by_index(clk, i);
+		parent_rate = __clk_get_rate(parent);
+		if (parent_rate % rate == 0) {
+			*best_parent_p = parent;
+			*best_parent_rate = parent_rate;
+			return rate;
+		}
+	}
+
+	/* take the npll and set its rate to something suitable */
+	for (i = 0; rk3288_pll_rates[i].rate != 0; i++) {
+		if (rk3288_pll_rates[i].rate % rate == 0) {
+			*best_parent_p = clk_get_parent_by_index(clk,
+						DCLK_VOP_PARENT_NPLL);
+			*best_parent_rate = rk3288_pll_rates[i].rate;
+			return rk3288_pll_rates[i].rate;
+		}
+	}
+
+	/*
+	 * We were not able to find a matching rate, so falling back
+	 * to finding the fastest rate < rate.
+	 * We allow the npll to change its rate while the other plls
+	 * are not allowed to change.
+	 */
+	for (i = 0; i < num_parents; i++) {
+		parent = clk_get_parent_by_index(clk, i);
+		if (!parent)
+			continue;
+
+		if (i == DCLK_VOP_PARENT_NPLL)
+			parent_rate = __clk_round_rate(parent, rate);
+		else
+			parent_rate = __clk_get_rate(parent);
+		if (parent_rate <= rate && parent_rate > best) {
+			int div = DIV_ROUND_UP(parent_rate, rate);
+			*best_parent_p = parent;
+			*best_parent_rate = parent_rate;
+			best = DIV_ROUND_UP(parent_rate, div);
+		}
+	}
+
+	return best;
+}
+
+
+const struct clk_ops dclk_vop_ops = {
+	.recalc_rate = clk_divider_recalc_rate,
+	.set_rate = clk_divider_set_rate,
+	.determine_rate = dclk_vop_determine_rate,
+};
 
 static void __init rk3288_clk_init(struct device_node *np)
 {
-- 
1.9.1

