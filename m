Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071Ab3HaL3r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 07:29:47 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40122 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab3HaL3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 07:29:38 -0400
From: Mark Brown <broonie@kernel.org>
To: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, Mark Brown <broonie@linaro.org>
Date: Sat, 31 Aug 2013 12:29:20 +0100
Message-Id: <1377948564-8383-5-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1377948564-8383-1-git-send-email-broonie@kernel.org>
References: <1377948564-8383-1-git-send-email-broonie@kernel.org>
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH 05/11] regulator: s5m8767: Covert to devm_regulator_register()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/regulator/s5m8767.c | 24 +++---------------------
 1 file changed, 3 insertions(+), 21 deletions(-)

diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index c24448b..2297fdf 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -910,34 +910,17 @@ static int s5m8767_pmic_probe(struct platform_device *pdev)
 		config.regmap = iodev->regmap;
 		config.of_node = pdata->regulators[i].reg_node;
 
-		rdev[i] = regulator_register(&regulators[id], &config);
+		rdev[i] = devm_regulator_register(&pdev->dev, &regulators[id],
+						  &config);
 		if (IS_ERR(rdev[i])) {
 			ret = PTR_ERR(rdev[i]);
 			dev_err(s5m8767->dev, "regulator init failed for %d\n",
 					id);
-			rdev[i] = NULL;
-			goto err;
+			return ret;
 		}
 	}
 
 	return 0;
-err:
-	for (i = 0; i < s5m8767->num_regulators; i++)
-		regulator_unregister(rdev[i]);
-
-	return ret;
-}
-
-static int s5m8767_pmic_remove(struct platform_device *pdev)
-{
-	struct s5m8767_info *s5m8767 = platform_get_drvdata(pdev);
-	struct regulator_dev **rdev = s5m8767->rdev;
-	int i;
-
-	for (i = 0; i < s5m8767->num_regulators; i++)
-		regulator_unregister(rdev[i]);
-
-	return 0;
 }
 
 static const struct platform_device_id s5m8767_pmic_id[] = {
@@ -952,7 +935,6 @@ static struct platform_driver s5m8767_pmic_driver = {
 		.owner = THIS_MODULE,
 	},
 	.probe = s5m8767_pmic_probe,
-	.remove = s5m8767_pmic_remove,
 	.id_table = s5m8767_pmic_id,
 };
 
-- 
1.8.4.rc3

