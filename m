Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932080Ab3EGIPx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 04:15:53 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:61022 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757993Ab3EGIPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 04:15:10 -0400
From: Marek Belisko <marek.belisko@gmail.com>
To: mturquette@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        daniel@zonque.org, sebastian.hesselbarth@gmail.com,
        Marek Belisko <marek.belisko@streamunlimited.com>
Subject: [PATCH 2/2] clk: si5351: Powerdown output when clock rate is 0.
Date: Tue,  7 May 2013 10:14:51 +0200
Message-Id: <1367914491-17445-2-git-send-email-marek.belisko@streamunlimited.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1367914491-17445-1-git-send-email-marek.belisko@streamunlimited.com>
References: <1367914491-17445-1-git-send-email-marek.belisko@streamunlimited.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When rate is 0 powerdown clock output.

Signed-off-by: Marek Belisko <marek.belisko@streamunlimited.com>
---
 drivers/clk/clk-si5351.c |   32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/drivers/clk/clk-si5351.c b/drivers/clk/clk-si5351.c
index a8fc0f4..e254e76 100644
--- a/drivers/clk/clk-si5351.c
+++ b/drivers/clk/clk-si5351.c
@@ -1042,20 +1042,22 @@ static int si5351_clkout_set_rate(struct clk_hw *hw, unsigned long rate,
 	struct si5351_hw_data *hwdata =
 		container_of(hw, struct si5351_hw_data, hw);
 	unsigned long new_rate, new_err, err;
-	unsigned char rdiv;
+	unsigned char rdiv, pdn = 0;
 
 	/* round to closed rdiv */
 	rdiv = SI5351_OUTPUT_CLK_DIV_1;
-	new_rate = parent_rate;
-	err = abs(new_rate - rate);
-	do {
-		new_rate >>= 1;
-		new_err = abs(new_rate - rate);
-		if (new_err > err || rdiv == SI5351_OUTPUT_CLK_DIV_128)
-			break;
-		rdiv++;
-		err = new_err;
-	} while (1);
+	if (rate) {
+		new_rate = parent_rate;
+		err = abs(new_rate - rate);
+		do {
+			new_rate >>= 1;
+			new_err = abs(new_rate - rate);
+			if (new_err > err || rdiv == SI5351_OUTPUT_CLK_DIV_128)
+				break;
+			rdiv++;
+			err = new_err;
+		} while (1);
+	}
 
 	/* write output divider */
 	switch (hwdata->num) {
@@ -1075,9 +1077,13 @@ static int si5351_clkout_set_rate(struct clk_hw *hw, unsigned long rate,
 				rdiv << SI5351_OUTPUT_CLK_DIV_SHIFT);
 	}
 
-	/* powerup clkout */
+	/* when rate is 0 powerdown output */
+	if (rate == 0)
+		pdn = SI5351_CLK_POWERDOWN;
+
+	/* powerup/down clkout */
 	si5351_set_bits(hwdata->drvdata, SI5351_CLK0_CTRL + hwdata->num,
-			SI5351_CLK_POWERDOWN, 0);
+			SI5351_CLK_POWERDOWN, pdn);
 
 	dev_dbg(&hwdata->drvdata->client->dev,
 		"%s - %s: rdiv = %u, parent_rate = %lu, rate = %lu\n",
-- 
1.7.9.5

