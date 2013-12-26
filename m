Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547Ab3LZB6S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Dec 2013 20:58:18 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:40944 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477Ab3LZB6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Dec 2013 20:58:16 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <broonie@kernel.org>
CC: <lgirdwood@gmail.com>, <plagnioj@jcrosoft.com>, <nicolas.ferre@atmel.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <wenyou.yang@atmel.com>
Subject: [PATCH] regulator: act8865: register all regulators regardless of how many are used
Date: Thu, 26 Dec 2013 09:57:21 +0800
Message-ID: <1388023041-25785-1-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Mark pointed out, the driver should register all regulators
regardless of how many are used in the system in order to aid diagnostics.

But in the previous patch, only register the regulators that are used.

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
---
 drivers/regulator/act8865-regulator.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/regulator/act8865-regulator.c b/drivers/regulator/act8865-regulator.c
index db048f2..f853353 100644
--- a/drivers/regulator/act8865-regulator.c
+++ b/drivers/regulator/act8865-regulator.c
@@ -227,8 +227,8 @@ static int act8865_pdata_from_dt(struct device *dev,
 		return matched;
 
 	pdata->regulators = devm_kzalloc(dev,
-				sizeof(struct act8865_regulator_data) * matched,
-				GFP_KERNEL);
+				sizeof(struct act8865_regulator_data) *
+				ARRAY_SIZE(act8865_matches), GFP_KERNEL);
 	if (!pdata->regulators) {
 		dev_err(dev, "%s: failed to allocate act8865 registor\n",
 						__func__);
@@ -238,10 +238,7 @@ static int act8865_pdata_from_dt(struct device *dev,
 	pdata->num_regulators = matched;
 	regulator = pdata->regulators;
 
-	for (i = 0; i < matched; i++) {
-		if (!act8865_matches[i].init_data)
-			continue;
-
+	for (i = 0; i < ARRAY_SIZE(act8865_matches); i++) {
 		regulator->id = i;
 		regulator->name = act8865_matches[i].name;
 		regulator->platform_data = act8865_matches[i].init_data;
@@ -310,7 +307,7 @@ static int act8865_pmic_probe(struct i2c_client *client,
 	}
 
 	/* Finally register devices */
-	for (i = 0; i < pdata->num_regulators; i++) {
+	for (i = 0; i < ARRAY_SIZE(act8865_matches); i++) {
 
 		id = pdata->regulators[i].id;
 
@@ -339,7 +336,7 @@ static int act8865_pmic_remove(struct i2c_client *client)
 	struct act8865 *act8865 = i2c_get_clientdata(client);
 	int i;
 
-	for (i = 0; i < ACT8865_REG_NUM; i++)
+	for (i = 0; i < ARRAY_SIZE(act8865_matches); i++)
 		regulator_unregister(act8865->rdev[i]);
 
 	return 0;
-- 
1.7.9.5

