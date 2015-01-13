Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711AbbAMOoO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 09:44:14 -0500
Received: from down.free-electrons.com ([37.187.137.238]:34632 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751190AbbAMOoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 09:44:11 -0500
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Mike Turquette <mturquette@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Bo Shen <voice.shen@atmel.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        stable@vger.kernel.org
Subject: [PATCH v2] clk: at91: keep slow clk enabled to prevent system hang
Date: Tue, 13 Jan 2015 15:44:06 +0100
Message-Id: <1421160246-29712-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All slow clk users are not properly claiming it (get + prepare + enable)
before using it.
If all users properly claiming this clock release it, the clock is
disabled, but faulty users still depends on it, and the system hangs.

This fix prevents the slow clock from being disabled, and should solve the
hanging issue, but offending drivers should be patched to properly claim
this clock.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
Reported-by: Bo Shen <voice.shen@atmel.com>
Cc: stable@vger.kernel.org
---
 drivers/clk/at91/clk-slow.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/clk/at91/clk-slow.c b/drivers/clk/at91/clk-slow.c
index 32f7c1b..2f13bd5 100644
--- a/drivers/clk/at91/clk-slow.c
+++ b/drivers/clk/at91/clk-slow.c
@@ -70,6 +70,7 @@ struct clk_sam9x5_slow {
 
 #define to_clk_sam9x5_slow(hw) container_of(hw, struct clk_sam9x5_slow, hw)
 
+static struct clk *slow_clk;
 
 static int clk_slow_osc_prepare(struct clk_hw *hw)
 {
@@ -357,6 +358,8 @@ at91_clk_register_sam9x5_slow(void __iomem *sckcr,
 	clk = clk_register(NULL, &slowck->hw);
 	if (IS_ERR(clk))
 		kfree(slowck);
+	else
+		slow_clk = clk;
 
 	return clk;
 }
@@ -433,6 +436,8 @@ at91_clk_register_sam9260_slow(struct at91_pmc *pmc,
 	clk = clk_register(NULL, &slowck->hw);
 	if (IS_ERR(clk))
 		kfree(slowck);
+	else
+		slow_clk = clk;
 
 	return clk;
 }
@@ -465,3 +470,25 @@ void __init of_at91sam9260_clk_slow_setup(struct device_node *np,
 
 	of_clk_add_provider(np, of_clk_src_simple_get, clk);
 }
+
+/*
+ * FIXME: All slow clk users are not properly claiming it (get + prepare +
+ * enable) before using it.
+ * If all users properly claiming this clock decide that they don't need it
+ * anymore (or are removed), it is disabled while faulty users are still
+ * requiring it, and the system hangs.
+ * Prevent this clock from being disabled until all users are properly
+ * requesting it.
+ * Once this is done we should remove this function and the slow_clk variable.
+ */
+static int __init of_at91_clk_slow_retain(void)
+{
+	if (!slow_clk)
+		return 0;
+
+	__clk_get(slow_clk);
+	clk_prepare_enable(slow_clk);
+
+	return 0;
+}
+arch_initcall(of_at91_clk_slow_retain);
-- 
1.9.1

