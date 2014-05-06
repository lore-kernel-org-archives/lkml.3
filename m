Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbaEFU1U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 16:27:20 -0400
Received: from mail-yh0-f51.google.com ([209.85.213.51]:46314 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbaEFU1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 16:27:19 -0400
From: Fabio Estevam <festevam@gmail.com>
To: mturquette@linaro.org
Cc: linux-kernel@vger.kernel.org, shawn.guo@freescale.com,
        kernel@pengutronix.de, maxime.coquelin@st.com,
        linux-arm-kernel@lists.infradead.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] clk: clk-divider: Fix infinite loop for table divider
Date: Tue,  6 May 2014 17:26:45 -0300
Message-Id: <1399408005-4209-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

Since commit e7489693b3 (clk: divider: Optimize clk_divider_bestdiv loop) we 
notice a system hang on mx6qboard.

The cause for the hang is well explained by Sascha Hauer [1]:

"This cannot work. _round_up_table is implemented like this:

static int _round_up_table(const struct clk_div_table *table, int div)
{
        const struct clk_div_table *clkt;
        int up = _get_table_maxdiv(table);

        for (clkt = table; clkt->div; clkt++) {
                if (clkt->div == div)
                        return clkt->div;
                ...
        }
        ...
}

Here when a table entry matches the input div this function will return
exactly the input div. This means _next_div() will always return the
same value and clk_divider_bestdiv() has an infinite loop:

        for (i = 1; i <= maxdiv; i = _next_div(divider, i)) {
                ...
        } 
"
[1] http://marc.info/?l=linux-arm-kernel&m=139940658726253&w=2

Remove the 'return _round_up_table' so that the system can work normally again.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/clk/clk-divider.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
index b3c8396..fc3e344 100644
--- a/drivers/clk/clk-divider.c
+++ b/drivers/clk/clk-divider.c
@@ -246,8 +246,6 @@ static int _next_div(struct clk_divider *divider, int div)
 
 	if (divider->flags & CLK_DIVIDER_POWER_OF_TWO)
 		return __roundup_pow_of_two(div);
-	if (divider->table)
-		return _round_up_table(divider->table, div);
 
 	return div;
 }
-- 
1.8.3.2

