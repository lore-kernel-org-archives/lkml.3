Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965908Ab3E2Lpk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 07:45:40 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:35023 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965530Ab3E2Lpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 07:45:36 -0400
From: Nikolay Balandin <n.a.balandin@gmail.com>
To: Eric Piel <eric.piel@tremplin-utc.net>, linux-kernel@vger.kernel.org
Cc: Nikolay Balandin <nbalandin@dev.rtsoft.ru>
Subject: [PATCH v1 1/1] drivers/misc: lis3lv02d: convert to use devm_regulator_bulk_get
Date: Wed, 29 May 2013 15:45:13 +0400
Message-Id: <1369827913-31033-1-git-send-email-n.a.balandin@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nikolay Balandin <nbalandin@dev.rtsoft.ru>

Use devm_regulator_bulk_get to make cleanup paths simpler

Signed-off-by: Nikolay Balandin <nbalandin@dev.rtsoft.ru>
---
 drivers/misc/lis3lv02d/lis3lv02d_i2c.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/misc/lis3lv02d/lis3lv02d_i2c.c b/drivers/misc/lis3lv02d/lis3lv02d_i2c.c
index 7c97550..01ddcf0 100644
--- a/drivers/misc/lis3lv02d/lis3lv02d_i2c.c
+++ b/drivers/misc/lis3lv02d/lis3lv02d_i2c.c
@@ -154,7 +154,7 @@ static int lis3lv02d_i2c_probe(struct i2c_client *client,
 
 	lis3_dev.regulators[0].supply = reg_vdd;
 	lis3_dev.regulators[1].supply = reg_vdd_io;
-	ret = regulator_bulk_get(&client->dev,
+	ret = devm_regulator_bulk_get(&client->dev,
 				 ARRAY_SIZE(lis3_dev.regulators),
 				 lis3_dev.regulators);
 	if (ret < 0)
@@ -179,12 +179,9 @@ static int lis3lv02d_i2c_probe(struct i2c_client *client,
 	lis3_reg_ctrl(&lis3_dev, LIS3_REG_OFF);
 
 	if (ret)
-		goto fail2;
+		goto fail;
 	return 0;
 
-fail2:
-	regulator_bulk_free(ARRAY_SIZE(lis3_dev.regulators),
-				lis3_dev.regulators);
 fail:
 	if (pdata && pdata->release_resources)
 		pdata->release_resources();
@@ -202,8 +199,6 @@ static int lis3lv02d_i2c_remove(struct i2c_client *client)
 	lis3lv02d_joystick_disable(lis3);
 	lis3lv02d_remove_fs(&lis3_dev);
 
-	regulator_bulk_free(ARRAY_SIZE(lis3->regulators),
-			    lis3_dev.regulators);
 	return 0;
 }
 
-- 
1.7.9.5

