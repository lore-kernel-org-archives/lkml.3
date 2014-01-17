Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176AbaAQJRw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 04:17:52 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38302 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbaAQJRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 04:17:48 -0500
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: LMML <linux-media@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH] media: i2c: mt9p031: Check return value of clk_prepare_enable/clk_set_rate
Date: Fri, 17 Jan 2014 14:47:33 +0530
Message-Id: <1389950253-31251-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

clk_set_rate(), clk_prepare_enable() functions can fail, so check the return
values to avoid surprises.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/i2c/mt9p031.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/mt9p031.c b/drivers/media/i2c/mt9p031.c
index e5ddf47..dbe34d7 100644
--- a/drivers/media/i2c/mt9p031.c
+++ b/drivers/media/i2c/mt9p031.c
@@ -222,12 +222,15 @@ static int mt9p031_clk_setup(struct mt9p031 *mt9p031)
 
 	struct i2c_client *client = v4l2_get_subdevdata(&mt9p031->subdev);
 	struct mt9p031_platform_data *pdata = mt9p031->pdata;
+	int ret;
 
 	mt9p031->clk = devm_clk_get(&client->dev, NULL);
 	if (IS_ERR(mt9p031->clk))
 		return PTR_ERR(mt9p031->clk);
 
-	clk_set_rate(mt9p031->clk, pdata->ext_freq);
+	ret = clk_set_rate(mt9p031->clk, pdata->ext_freq);
+	if (ret < 0)
+		return ret;
 
 	mt9p031->pll.ext_clock = pdata->ext_freq;
 	mt9p031->pll.pix_clock = pdata->target_freq;
@@ -286,8 +289,11 @@ static int mt9p031_power_on(struct mt9p031 *mt9p031)
 		return ret;
 
 	/* Emable clock */
-	if (mt9p031->clk)
-		clk_prepare_enable(mt9p031->clk);
+	if (mt9p031->clk) {
+		ret = clk_prepare_enable(mt9p031->clk);
+		if (ret)
+			return ret;
+	}
 
 	/* Now RESET_BAR must be high */
 	if (gpio_is_valid(mt9p031->reset)) {
-- 
1.7.9.5

