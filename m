Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593AbaFHL0k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 07:26:40 -0400
Received: from smtp40.i.mail.ru ([94.100.177.100]:49929 "EHLO smtp40.i.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753496AbaFHL0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 07:26:37 -0400
From: Alexander Shiyan <shc_work@mail.ru>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH 2/2] regulator: mc13xxx: Remove unnecessary locks
Date: Sun,  8 Jun 2014 15:26:29 +0400
Message-Id: <1402226789-25928-2-git-send-email-shc_work@mail.ru>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1402226789-25928-1-git-send-email-shc_work@mail.ru>
References: <1402226789-25928-1-git-send-email-shc_work@mail.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Read-modify-write sequence is already protected by regmap, so no
additional locks need. This patch remove such locks from mc13xxx
regulator driver.

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 drivers/regulator/mc13xxx-regulator-core.c | 37 +++++++-----------------------
 1 file changed, 8 insertions(+), 29 deletions(-)

diff --git a/drivers/regulator/mc13xxx-regulator-core.c b/drivers/regulator/mc13xxx-regulator-core.c
index 05b9717..afba024 100644
--- a/drivers/regulator/mc13xxx-regulator-core.c
+++ b/drivers/regulator/mc13xxx-regulator-core.c
@@ -33,17 +33,12 @@ static int mc13xxx_regulator_enable(struct regulator_dev *rdev)
 	struct mc13xxx_regulator_priv *priv = rdev_get_drvdata(rdev);
 	struct mc13xxx_regulator *mc13xxx_regulators = priv->mc13xxx_regulators;
 	int id = rdev_get_id(rdev);
-	int ret;
 
 	dev_dbg(rdev_get_dev(rdev), "%s id: %d\n", __func__, id);
 
-	mc13xxx_lock(priv->mc13xxx);
-	ret = mc13xxx_reg_rmw(priv->mc13xxx, mc13xxx_regulators[id].reg,
-			mc13xxx_regulators[id].enable_bit,
-			mc13xxx_regulators[id].enable_bit);
-	mc13xxx_unlock(priv->mc13xxx);
-
-	return ret;
+	return mc13xxx_reg_rmw(priv->mc13xxx, mc13xxx_regulators[id].reg,
+			       mc13xxx_regulators[id].enable_bit,
+			       mc13xxx_regulators[id].enable_bit);
 }
 
 static int mc13xxx_regulator_disable(struct regulator_dev *rdev)
@@ -51,16 +46,11 @@ static int mc13xxx_regulator_disable(struct regulator_dev *rdev)
 	struct mc13xxx_regulator_priv *priv = rdev_get_drvdata(rdev);
 	struct mc13xxx_regulator *mc13xxx_regulators = priv->mc13xxx_regulators;
 	int id = rdev_get_id(rdev);
-	int ret;
 
 	dev_dbg(rdev_get_dev(rdev), "%s id: %d\n", __func__, id);
 
-	mc13xxx_lock(priv->mc13xxx);
-	ret = mc13xxx_reg_rmw(priv->mc13xxx, mc13xxx_regulators[id].reg,
-			mc13xxx_regulators[id].enable_bit, 0);
-	mc13xxx_unlock(priv->mc13xxx);
-
-	return ret;
+	return mc13xxx_reg_rmw(priv->mc13xxx, mc13xxx_regulators[id].reg,
+			       mc13xxx_regulators[id].enable_bit, 0);
 }
 
 static int mc13xxx_regulator_is_enabled(struct regulator_dev *rdev)
@@ -70,10 +60,7 @@ static int mc13xxx_regulator_is_enabled(struct regulator_dev *rdev)
 	int ret, id = rdev_get_id(rdev);
 	unsigned int val;
 
-	mc13xxx_lock(priv->mc13xxx);
 	ret = mc13xxx_reg_read(priv->mc13xxx, mc13xxx_regulators[id].reg, &val);
-	mc13xxx_unlock(priv->mc13xxx);
-
 	if (ret)
 		return ret;
 
@@ -86,15 +73,10 @@ static int mc13xxx_regulator_set_voltage_sel(struct regulator_dev *rdev,
 	struct mc13xxx_regulator_priv *priv = rdev_get_drvdata(rdev);
 	struct mc13xxx_regulator *mc13xxx_regulators = priv->mc13xxx_regulators;
 	int id = rdev_get_id(rdev);
-	int ret;
 
-	mc13xxx_lock(priv->mc13xxx);
-	ret = mc13xxx_reg_rmw(priv->mc13xxx, mc13xxx_regulators[id].vsel_reg,
-			mc13xxx_regulators[id].vsel_mask,
-			selector << mc13xxx_regulators[id].vsel_shift);
-	mc13xxx_unlock(priv->mc13xxx);
-
-	return ret;
+	return mc13xxx_reg_rmw(priv->mc13xxx, mc13xxx_regulators[id].vsel_reg,
+			       mc13xxx_regulators[id].vsel_mask,
+			       selector << mc13xxx_regulators[id].vsel_shift);
 }
 
 static int mc13xxx_regulator_get_voltage(struct regulator_dev *rdev)
@@ -106,11 +88,8 @@ static int mc13xxx_regulator_get_voltage(struct regulator_dev *rdev)
 
 	dev_dbg(rdev_get_dev(rdev), "%s id: %d\n", __func__, id);
 
-	mc13xxx_lock(priv->mc13xxx);
 	ret = mc13xxx_reg_read(priv->mc13xxx,
 				mc13xxx_regulators[id].vsel_reg, &val);
-	mc13xxx_unlock(priv->mc13xxx);
-
 	if (ret)
 		return ret;
 
-- 
1.8.5.5

