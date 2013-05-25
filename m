Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758164Ab3EYVvU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 17:51:20 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:38809 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758137Ab3EYVvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 17:51:19 -0400
From: Nikolay Balandin <n.a.balandin@gmail.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, Nikolay Balandin <nbalandin@dev.rtsoft.ru>
Subject: [PATCH 1/1] regulator: lp397x: use devm_kzalloc() to make cleanup paths simpler
Date: Sat, 25 May 2013 14:50:40 -0700
Message-Id: <1369518640-7480-1-git-send-email-n.a.balandin@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nikolay Balandin <nbalandin@dev.rtsoft.ru>

Signed-off-by: Nikolay Balandin <nbalandin@dev.rtsoft.ru>
---
 drivers/regulator/lp3971.c |   11 +++--------
 drivers/regulator/lp3972.c |   11 +++--------
 2 files changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/regulator/lp3971.c b/drivers/regulator/lp3971.c
index d8af9e7..3809b43 100644
--- a/drivers/regulator/lp3971.c
+++ b/drivers/regulator/lp3971.c
@@ -434,7 +434,7 @@ static int lp3971_i2c_probe(struct i2c_client *i2c,
 		return -ENODEV;
 	}
 
-	lp3971 = kzalloc(sizeof(struct lp3971), GFP_KERNEL);
+	lp3971 = devm_kzalloc(&i2c->dev, sizeof(struct lp3971), GFP_KERNEL);
 	if (lp3971 == NULL)
 		return -ENOMEM;
 
@@ -449,19 +449,15 @@ static int lp3971_i2c_probe(struct i2c_client *i2c,
 		ret = -ENODEV;
 	if (ret < 0) {
 		dev_err(&i2c->dev, "failed to detect device\n");
-		goto err_detect;
+		return ret;
 	}
 
 	ret = setup_regulators(lp3971, pdata);
 	if (ret < 0)
-		goto err_detect;
+		return ret;
 
 	i2c_set_clientdata(i2c, lp3971);
 	return 0;
-
-err_detect:
-	kfree(lp3971);
-	return ret;
 }
 
 static int lp3971_i2c_remove(struct i2c_client *i2c)
@@ -473,7 +469,6 @@ static int lp3971_i2c_remove(struct i2c_client *i2c)
 		regulator_unregister(lp3971->rdev[i]);
 
 	kfree(lp3971->rdev);
-	kfree(lp3971);
 
 	return 0;
 }
diff --git a/drivers/regulator/lp3972.c b/drivers/regulator/lp3972.c
index 61e4cf9..5730240 100644
--- a/drivers/regulator/lp3972.c
+++ b/drivers/regulator/lp3972.c
@@ -528,7 +528,7 @@ static int lp3972_i2c_probe(struct i2c_client *i2c,
 		return -ENODEV;
 	}
 
-	lp3972 = kzalloc(sizeof(struct lp3972), GFP_KERNEL);
+	lp3972 = devm_kzalloc(&i2c->dev, sizeof(struct lp3972), GFP_KERNEL);
 	if (!lp3972)
 		return -ENOMEM;
 
@@ -546,19 +546,15 @@ static int lp3972_i2c_probe(struct i2c_client *i2c,
 	}
 	if (ret < 0) {
 		dev_err(&i2c->dev, "failed to detect device. ret = %d\n", ret);
-		goto err_detect;
+		return ret;
 	}
 
 	ret = setup_regulators(lp3972, pdata);
 	if (ret < 0)
-		goto err_detect;
+		return ret;
 
 	i2c_set_clientdata(i2c, lp3972);
 	return 0;
-
-err_detect:
-	kfree(lp3972);
-	return ret;
 }
 
 static int lp3972_i2c_remove(struct i2c_client *i2c)
@@ -569,7 +565,6 @@ static int lp3972_i2c_remove(struct i2c_client *i2c)
 	for (i = 0; i < lp3972->num_regulators; i++)
 		regulator_unregister(lp3972->rdev[i]);
 	kfree(lp3972->rdev);
-	kfree(lp3972);
 
 	return 0;
 }
-- 
1.7.9.5

