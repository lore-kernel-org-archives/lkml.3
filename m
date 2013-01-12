Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510Ab3ALG6p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 01:58:45 -0500
Received: from mail-da0-f50.google.com ([209.85.210.50]:41452 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab3ALG6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 01:58:44 -0500
Message-ID: <1357973915.16304.1.camel@phoenix>
Subject: [PATCH] regulator: lp8755: Don't show unrelated messags in
 lp8755_probe error paths
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Daniel Jeong <gshark.jeong@gmail.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Sat, 12 Jan 2013 14:58:35 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/lp8755.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/regulator/lp8755.c b/drivers/regulator/lp8755.c
index decb3ad..8c3f3f2 100644
--- a/drivers/regulator/lp8755.c
+++ b/drivers/regulator/lp8755.c
@@ -497,35 +497,36 @@ static int lp8755_probe(struct i2c_client *client,
 		if (!pchip->pdata)
 			return -ENOMEM;
 		ret = lp8755_init_data(pchip);
-		if (ret < 0)
-			goto err_chip_init;
+		if (ret < 0) {
+			dev_err(&client->dev, "fail to initialize chip\n");
+			return ret;
+		}
 	}
 
 	ret = lp8755_regulator_init(pchip);
-	if (ret < 0)
+	if (ret < 0) {
+		dev_err(&client->dev, "fail to initialize regulators\n");
 		goto err_regulator;
+	}
 
 	pchip->irq = client->irq;
 	ret = lp8755_int_config(pchip);
-	if (ret < 0)
+	if (ret < 0) {
+		dev_err(&client->dev, "fail to irq config\n");
 		goto err_irq;
+	}
 
 	return ret;
 
 err_irq:
-	dev_err(&client->dev, "fail to irq config\n");
-
 	for (icnt = 0; icnt < mphase_buck[pchip->mphase].nreg; icnt++)
 		regulator_unregister(pchip->rdev[icnt]);
 
 err_regulator:
-	dev_err(&client->dev, "fail to initialize regulators\n");
 	/* output disable */
 	for (icnt = 0; icnt < 0x06; icnt++)
 		lp8755_write(pchip, icnt, 0x00);
 
-err_chip_init:
-	dev_err(&client->dev, "fail to initialize chip\n");
 	return ret;
 }
 
-- 
1.7.9.5



