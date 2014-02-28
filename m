Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924AbaB1QkN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 11:40:13 -0500
Received: from top.free-electrons.com ([176.31.233.9]:52968 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752554AbaB1QkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 11:40:08 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Emilio Lopez <emilio@elopez.com.ar>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-sunxi@googlegroups.com, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v2 2/5] clk: sun6i: Reparent AHB clock on PLL6
Date: Fri, 28 Feb 2014 17:37:17 +0100
Message-Id: <1393605440-14643-3-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393605440-14643-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1393605440-14643-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order for the DMA controller to work for SDRAM to devices transfers, the AHB
clock should be reparented on the PLL6.

Force that parenting in the clock driver.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/clk/sunxi/clk-sunxi.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi.c
index f6f61cc..a5c5882 100644
--- a/drivers/clk/sunxi/clk-sunxi.c
+++ b/drivers/clk/sunxi/clk-sunxi.c
@@ -1286,7 +1286,7 @@ static void __init of_sunxi_table_clock_setup(const struct of_device_id *clk_mat
  */
 static void __init sunxi_clock_protect(void)
 {
-	struct clk *clk;
+	struct clk *clk, *parent;
 
 	/* memory bus clock - sun5i+ */
 	clk = clk_get(NULL, "mbus");
@@ -1307,6 +1307,22 @@ static void __init sunxi_clock_protect(void)
 	if (!IS_ERR(clk))
 		clk_prepare_enable(clk);
 
+	clk = clk_get(NULL, "ahb1_mux");
+	if (IS_ERR(clk)) {
+		pr_err("Couldn't get AHB1 Mux\n");
+		return;
+	}
+
+	parent = clk_get(NULL, "pll6");
+	if (IS_ERR(clk)) {
+		pr_err("Couldn't get PLL6\n");
+		return;
+	}
+
+	clk_set_parent(clk, parent);
+
+	clk_put(clk);
+	clk_put(parent);
 }
 
 static void __init sunxi_init_clocks(void)
-- 
1.9.0

