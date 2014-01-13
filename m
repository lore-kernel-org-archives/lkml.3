Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751684AbaAMJDi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 04:03:38 -0500
Received: from mail.aswsp.com ([193.34.35.150]:35151 "EHLO mail.aswsp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751659AbaAMJDe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 04:03:34 -0500
Message-ID: <52D3ABE2.10701@parrot.com>
Date: Mon, 13 Jan 2014 10:03:30 +0100
From: Damien Riegel <damien.riegel.ext@parrot.com>
Reply-To: <damien.riegel.ext@parrot.com>
Organization: Parrot
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Damien Riegel <damien.riegel.ext@parrot.com>
Subject: [PATCH v2] clk: clk-divider: round divider to a valid value when
 a table is used
References: <1389277515-26444-1-git-send-email-damien.riegel.ext@parrot.com>
In-Reply-To: <1389277515-26444-1-git-send-email-damien.riegel.ext@parrot.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [46.218.109.88]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clk_divider_bestdiv computes the bestdiv without taking into account if
it is a valid value when CLK_SET_RATE_PARENT is not set, and it may not
be if a table is used. round_rate then returns a rate that is not
reachable by the clock, leading to a set_rate that does nothing but
reports no error.
This patch makes round_rate return a valid rate.

Signed-off-by: Damien Riegel <damien.riegel.ext@parrot.com>
---
The previous version of this patch luckily worked with the clk_div_table
I had. It might return a divider that was less than the computed div. This
patch should now work in every case.
---
 drivers/clk/clk-divider.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
index 8d3009e44fba..658afbc39964 100644
--- a/drivers/clk/clk-divider.c
+++ b/drivers/clk/clk-divider.c
@@ -144,6 +144,22 @@ static bool _is_valid_div(struct clk_divider *divider, unsigned int div)
 	return true;
 }
 
+static int _round_to_valid_div(struct clk_divider *divider, int div, int maxdiv)
+{
+	const struct clk_div_table *clkt = divider->table;
+	int bestdiv = maxdiv;
+
+	if (!clkt)
+		return div;
+
+	for (; clkt->div; clkt++) {
+		if (clkt->div >= div && bestdiv > clkt->div)
+			bestdiv = clkt->div;
+	}
+
+	return bestdiv;
+}
+
 static int clk_divider_bestdiv(struct clk_hw *hw, unsigned long rate,
 		unsigned long *best_parent_rate)
 {
@@ -161,7 +177,8 @@ static int clk_divider_bestdiv(struct clk_hw *hw, unsigned long rate,
 		parent_rate = *best_parent_rate;
 		bestdiv = DIV_ROUND_UP(parent_rate, rate);
 		bestdiv = bestdiv == 0 ? 1 : bestdiv;
-		bestdiv = bestdiv > maxdiv ? maxdiv : bestdiv;
+		bestdiv = bestdiv > maxdiv ? maxdiv :
+			_round_to_valid_div(divider, bestdiv, maxdiv);
 		return bestdiv;
 	}
 
-- 
1.7.10.4

