Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632AbaCYLQl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 07:16:41 -0400
Received: from albert.telenet-ops.be ([195.130.137.90]:58379 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbaCYLQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 07:16:29 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] clk: Neaten clk_summary output
Date: Tue, 25 Mar 2014 12:16:24 +0100
Message-Id: <1395746185-16686-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

  - Limit ruler to 80 characters (was: 81),
  - Widen rate column by 1 for nicer spacing,
  - Right-align numbers and their column headers,
  - Move a newline to reduce the number of seq_printf() calls,
  - Use set_puts() for fixed strings.

Before:

   clock                        enable_cnt  prepare_cnt  rate        accuracy
---------------------------------------------------------------------------------
 extal                          2           2            20000000   0
    thermal                     1           1            20000000   0
    cp                          0           0            10000000   0
       tpu0                     0           0            10000000   0
       tmu0                     0           0            10000000   0
    main                        1           1            20000000   0
       pll3                     0           0            1600000000 0
          ddr                   0           0            200000000  0
          zb3d2                 0           0            200000000  0
          zb3                   0           0            400000000  0
       pll1                     4           4            1560000000 0
          oscclk                0           0            126953     0
          rclk                  1           1            31738      0
             cmt1               0           0            31738      0
             cmt0               1           1            31738      0
          imp                   0           0            390000000  0

After:

   clock                         enable_cnt  prepare_cnt        rate   accuracy
--------------------------------------------------------------------------------
 extal                                    2            2    20000000          0
    thermal                               1            1    20000000          0
    cp                                    0            0    10000000          0
       tpu0                               0            0    10000000          0
       tmu0                               0            0    10000000          0
    main                                  1            1    20000000          0
       pll3                               0            0  1600000000          0
          ddr                             0            0   200000000          0
          zb3d2                           0            0   200000000          0
          zb3                             0            0   400000000          0
       pll1                               4            4  1560000000          0
          oscclk                          0            0      126953          0
          rclk                            1            1       31738          0
             cmt1                         0            0       31738          0
             cmt0                         1            1       31738          0
          imp                             0            0   390000000          0

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/clk/clk.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index fb3c40b4fbe2..73fe1fade11f 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -106,12 +106,11 @@ static void clk_summary_show_one(struct seq_file *s, struct clk *c, int level)
 	if (!c)
 		return;
 
-	seq_printf(s, "%*s%-*s %-11d %-12d %-10lu %-11lu",
+	seq_printf(s, "%*s%-*s %11d %12d %11lu %10lu\n",
 		   level * 3 + 1, "",
 		   30 - level * 3, c->name,
 		   c->enable_count, c->prepare_count, clk_get_rate(c),
 		   clk_get_accuracy(c));
-	seq_printf(s, "\n");
 }
 
 static void clk_summary_show_subtree(struct seq_file *s, struct clk *c,
@@ -132,8 +131,8 @@ static int clk_summary_show(struct seq_file *s, void *data)
 {
 	struct clk *c;
 
-	seq_printf(s, "   clock                        enable_cnt  prepare_cnt  rate        accuracy\n");
-	seq_printf(s, "---------------------------------------------------------------------------------\n");
+	seq_puts(s, "   clock                         enable_cnt  prepare_cnt        rate   accuracy\n");
+	seq_puts(s, "--------------------------------------------------------------------------------\n");
 
 	clk_prepare_lock();
 
-- 
1.7.9.5

