Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933008AbaEGQtd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 12:49:33 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:43194 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932134AbaEGQtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 12:49:32 -0400
From: Maxime COQUELIN <maxime.coquelin@st.com>
To: Mike Turquette <mturquette@linaro.org>, Fabio Estevam <festevam@gmail.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: maxime.coquelin@st.com
Subject: [PATCH] clk: divider: Fix table round up function
Date: Wed,  7 May 2014 18:48:52 +0200
Message-Id: <1399481332-9550-1-git-send-email-maxime.coquelin@st.com>
X-Mailer: git-send-email 1.9.1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-05-07_05:2014-05-07,2014-05-07,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 1d9fe6b97 ("clk: divider: Fix best div calculation for power-of-two and
table dividers") introduces a regression in its _table_round_up function.

When the divider passed to this function is greater than the max divider
available in the table, this function returns table's max divider.
Problem is that it causes an infinite loop in clk_divider_bestdiv() because
_next_div() will never return a value greater than maxdiv.

Instead of returning table's max divider, this patch returns INT_MAX.

Reported-by: Fabio Estevam <festevam@gmail.com>
Reported-by: Shawn Guo <shawn.guo@freescale.com>
Tested-by: Fabio Estevam <festevam@gmail.com>
Cc: Mike Turquette <mike.turquette@linaro.org>
Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
---
 drivers/clk/clk-divider.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
index b3c8396..cf9114a 100644
--- a/drivers/clk/clk-divider.c
+++ b/drivers/clk/clk-divider.c
@@ -158,7 +158,7 @@ static bool _is_valid_div(struct clk_divider *divider, unsigned int div)
 static int _round_up_table(const struct clk_div_table *table, int div)
 {
 	const struct clk_div_table *clkt;
-	int up = _get_table_maxdiv(table);
+	int up = INT_MAX;
 
 	for (clkt = table; clkt->div; clkt++) {
 		if (clkt->div == div)
-- 
1.9.1

