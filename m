Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751491Ab3IJJzX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 05:55:23 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:10111 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353Ab3IJJzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 05:55:21 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 10 Sep 2013 02:52:18 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@kernel.org>
CC: <lgirdwood@gmail.com>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 2/2] regulator: fixed: get rid of {get|list}_voltage()
Date: Tue, 10 Sep 2013 15:45:06 +0530
Message-ID: <1378808106-29865-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1378808106-29865-1-git-send-email-ldewangan@nvidia.com>
References: <1378808106-29865-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide the rail supply voltage through descriptor to the
core and remove the callbacks which implement the get_voltage
and list_voltage.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/regulator/fixed.c |   28 ++--------------------------
 1 files changed, 2 insertions(+), 26 deletions(-)

diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index 7610920..de811f3 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -34,7 +34,6 @@
 struct fixed_voltage_data {
 	struct regulator_desc desc;
 	struct regulator_dev *dev;
-	int microvolts;
 };
 
 
@@ -108,30 +107,7 @@ of_get_fixed_voltage_config(struct device *dev)
 	return config;
 }
 
-static int fixed_voltage_get_voltage(struct regulator_dev *dev)
-{
-	struct fixed_voltage_data *data = rdev_get_drvdata(dev);
-
-	if (data->microvolts)
-		return data->microvolts;
-	else
-		return -EINVAL;
-}
-
-static int fixed_voltage_list_voltage(struct regulator_dev *dev,
-				      unsigned selector)
-{
-	struct fixed_voltage_data *data = rdev_get_drvdata(dev);
-
-	if (selector != 0)
-		return -EINVAL;
-
-	return data->microvolts;
-}
-
 static struct regulator_ops fixed_voltage_ops = {
-	.get_voltage = fixed_voltage_get_voltage,
-	.list_voltage = fixed_voltage_list_voltage,
 };
 
 static int reg_fixed_voltage_probe(struct platform_device *pdev)
@@ -186,7 +162,7 @@ static int reg_fixed_voltage_probe(struct platform_device *pdev)
 	if (config->microvolts)
 		drvdata->desc.n_voltages = 1;
 
-	drvdata->microvolts = config->microvolts;
+	drvdata->desc.fixed_uV = config->microvolts;
 
 	if (config->gpio >= 0)
 		cfg.ena_gpio = config->gpio;
@@ -222,7 +198,7 @@ static int reg_fixed_voltage_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, drvdata);
 
 	dev_dbg(&pdev->dev, "%s supplying %duV\n", drvdata->desc.name,
-		drvdata->microvolts);
+		drvdata->desc.fixed_uV);
 
 	return 0;
 
-- 
1.7.1.1

