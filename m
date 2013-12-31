Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932458Ab3LaB3G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 20:29:06 -0500
Received: from nasmtp01.atmel.com ([192.199.1.245]:47379 "EHLO
	DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932365Ab3LaB3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 20:29:05 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <broonie@kernel.org>
CC: <lgirdwood@gmail.com>, <nicolas.ferre@atmel.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <wenyou.yang@atmel.com>
Subject: [PATCH v2] regulator: act8865: register all regulators regardless of how many are used
Date: Tue, 31 Dec 2013 09:27:52 +0800
Message-ID: <1388453272-5287-1-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2 changlog:
 1./ Rebased on the latest code of for-next branch.

As Mark pointed out, the driver should register all regulators
regardless of how many are used in the system in order to aid diagnostics.

But in the previous patch, only register the regulators that are used.

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
---
 drivers/regulator/act8865-regulator.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/regulator/act8865-regulator.c b/drivers/regulator/act8865-regulator.c
index f816ad8..5e3e1d2 100644
--- a/drivers/regulator/act8865-regulator.c
+++ b/drivers/regulator/act8865-regulator.c
@@ -225,8 +225,8 @@ static int act8865_pdata_from_dt(struct device *dev,
 		return matched;
 
 	pdata->regulators = devm_kzalloc(dev,
-				sizeof(struct act8865_regulator_data) * matched,
-				GFP_KERNEL);
+				sizeof(struct act8865_regulator_data) *
+				ARRAY_SIZE(act8865_matches), GFP_KERNEL);
 	if (!pdata->regulators) {
 		dev_err(dev, "%s: failed to allocate act8865 registor\n",
 						__func__);
@@ -236,10 +236,7 @@ static int act8865_pdata_from_dt(struct device *dev,
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
@@ -306,7 +303,7 @@ static int act8865_pmic_probe(struct i2c_client *client,
 	}
 
 	/* Finally register devices */
-	for (i = 0; i < pdata->num_regulators; i++) {
+	for (i = 0; i < ARRAY_SIZE(act8865_matches); i++) {
 
 		id = pdata->regulators[i].id;
 
-- 
1.7.9.5

