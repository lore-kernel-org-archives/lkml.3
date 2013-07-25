Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627Ab3GYRG1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 13:06:27 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:8382 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756520Ab3GYRGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 13:06:25 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 25 Jul 2013 10:06:25 -0700
From: Rhyland Klein <rklein@nvidia.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
CC: Joseph Lo <josephl@nvidia.com>, Stephen Warren <swarren@wwwdotorg.org>,
        <linux-kernel@vger.kernel.org>, Rhyland Klein <rklein@nvidia.com>
Subject: [v2 PATCH] regulator: palmas: Store pdata pointer in palmas struct
Date: Thu, 25 Jul 2013 13:04:59 -0400
Message-ID: <1374771899-5037-1-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Store a pointer to the pdata so that if it needs to be used after
probe it can be. In the case of booting from DeviceTree, the
dev.platform_data may be null, so we need to store this pointer
explicitly.

Based on work by Joseph Lo.

Cc: Joseph Lo <josephl@nvidia.com>
Signed-off-by: Rhyland Klein <rklein@nvidia.com>
---

v2:
 - Renamed patch from "regulator: palmas: fix pdata ptr not be updated
   after it has been allocated" to be appropriate to the current change.
 - Instead of updating dev.platform_data, store the pdata pointer in the
   pmic struct which we already have access to via drvdata.

 drivers/regulator/palmas-regulator.c |    2 +-
 include/linux/mfd/palmas.h           |    2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index d0c8785..750ce55 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -761,7 +761,6 @@ static void palmas_dt_to_pdata(struct device *dev,
 	pdata->ldo6_vibrator = of_property_read_bool(node, "ti,ldo6-vibrator");
 }
 
-
 static int palmas_regulators_probe(struct platform_device *pdev)
 {
 	struct palmas *palmas = dev_get_drvdata(pdev->dev.parent);
@@ -789,6 +788,7 @@ static int palmas_regulators_probe(struct platform_device *pdev)
 
 	pmic->dev = &pdev->dev;
 	pmic->palmas = palmas;
+	pmic->pdata = pdata;
 	palmas->pmic = pmic;
 	platform_set_drvdata(pdev, pmic);
 
diff --git a/include/linux/mfd/palmas.h b/include/linux/mfd/palmas.h
index 1a8dd7a..1703f18 100644
--- a/include/linux/mfd/palmas.h
+++ b/include/linux/mfd/palmas.h
@@ -352,6 +352,8 @@ struct palmas_pmic {
 	struct regulator_dev *rdev[PALMAS_NUM_REGS];
 	struct mutex mutex;
 
+	struct palmas_pmic_platform_data *pdata;
+
 	int smps123;
 	int smps457;
 
-- 
1.7.9.5

