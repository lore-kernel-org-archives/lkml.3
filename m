Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933233AbaKMNVW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 08:21:22 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:46324 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932637AbaKMNVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 08:21:20 -0500
From: Kever Yang <kever.yang@rock-chips.com>
To: Mike Turquette <mturquette@linaro.org>, Heiko Stuebner <heiko@sntech.de>
Cc: dianders@chromium.org, sonnyrao@chromium.org, addy.ke@rock-chips.com,
        cf@rock-chips.com, dkl@rock-chips.com, huangtao@rock-chips.com,
        linux-rockchip@lists.infradead.org,
        Kever Yang <kever.yang@rock-chips.com>, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 1/2] clk: add property for force to update clock setting
Date: Thu, 13 Nov 2014 21:20:25 +0800
Message-Id: <1415884826-7877-2-git-send-email-kever.yang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415884826-7877-1-git-send-email-kever.yang@rock-chips.com>
References: <1415884826-7877-1-git-send-email-kever.yang@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Usually we assigned a clock to a default rate in dts,
there is a situation that the clock already initialized to the rate
we intend to set before kernel(hardware default or init in uboot etc).
For the PLLs we can get a rate from different PLL parameter configure,
we can't change the PLL parameter if the rate is not changed by now.

This patch adds a option property 'assigned-clock-force-rates'
to make sure we update all the setting even if we don't need to
update the clock rate.

Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
---

 drivers/clk/clk-conf.c | 33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/clk-conf.c b/drivers/clk/clk-conf.c
index aad4796..0c9df48 100644
--- a/drivers/clk/clk-conf.c
+++ b/drivers/clk/clk-conf.c
@@ -84,7 +84,7 @@ static int __set_clk_rates(struct device_node *node, bool clk_supplier)
 	struct clk *clk;
 	u32 rate;
 
-	of_property_for_each_u32(node, "assigned-clock-rates", prop, cur, rate) {
+	of_property_for_each_u32(node, "assigned-force-rates", prop, cur, rate) {
 		if (rate) {
 			rc = of_parse_phandle_with_args(node, "assigned-clocks",
 					"#clock-cells",	index, &clkspec);
@@ -104,7 +104,38 @@ static int __set_clk_rates(struct device_node *node, bool clk_supplier)
 					index, node->full_name);
 				return PTR_ERR(clk);
 			}
+			/* change the old rate to 0 to make sure we can get into
+			 * clk_change_rate */
+			clk->rate = 0;
+			rc = clk_set_rate(clk, rate);
+			if (rc < 0)
+				pr_err("clk: couldn't set %s clock rate: %d\n",
+				       __clk_get_name(clk), rc);
+			clk_put(clk);
+		}
+		index++;
+	}
 
+	of_property_for_each_u32(node, "assigned-clock-rates", prop, cur, rate) {
+		if (rate) {
+			rc = of_parse_phandle_with_args(node, "assigned-clocks",
+					"#clock-cells",	index, &clkspec);
+			if (rc < 0) {
+				/* skip empty (null) phandles */
+				if (rc == -ENOENT)
+					continue;
+				else
+					return rc;
+			}
+			if (clkspec.np == node && !clk_supplier)
+				return 0;
+
+			clk = of_clk_get_by_clkspec(&clkspec);
+			if (IS_ERR(clk)) {
+				pr_warn("clk: couldn't get clock %d for %s\n",
+					index, node->full_name);
+				return PTR_ERR(clk);
+			}
 			rc = clk_set_rate(clk, rate);
 			if (rc < 0)
 				pr_err("clk: couldn't set %s clock rate: %d\n",
-- 
1.9.1

