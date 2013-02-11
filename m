Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564Ab3BKGy3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 01:54:29 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:50560 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752245Ab3BKGy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 01:54:28 -0500
From: J Keerthy <j-keerthy@ti.com>
To: <linux-kernel@vger.kernel.org>, <lgirdwood@gmail.com>,
        <broonie@opensource.wolfsonmicro.com>
CC: <j-keerthy@ti.com>
Subject: [PATCH V2] Regulator: Reorder the min max assignment in the sequence of regulator_set_voltage function
Date: Mon, 11 Feb 2013 12:19:34 +0530
Message-ID: <1360565374-1553-1-git-send-email-j-keerthy@ti.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The min and max values for regulators are getting assigned before actually
the voltage is set. So making sure that min and max values are assigned
only if the voltage is successfully set else keeping the last successfully
set voltage's min and max values.

This is boot tested on OMAP4430 and OMAP4460 boards.

V2: Fixed comment from Mark. Introduced local variables to hold current
min and max values.
 
Signed-off-by: J Keerthy <j-keerthy@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 2785843..44a9b84 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2293,7 +2293,7 @@ static int _regulator_do_set_voltage(struct regulator_dev *rdev,
 int regulator_set_voltage(struct regulator *regulator, int min_uV, int max_uV)
 {
 	struct regulator_dev *rdev = regulator->rdev;
-	int ret = 0;
+	int ret = 0, curr_min, curr_max;
 
 	mutex_lock(&rdev->mutex);
 
@@ -2315,15 +2315,23 @@ int regulator_set_voltage(struct regulator *regulator, int min_uV, int max_uV)
 	ret = regulator_check_voltage(rdev, &min_uV, &max_uV);
 	if (ret < 0)
 		goto out;
+	curr_min = regulator->min_uV;
+	curr_max = regulator->max_uV;
 	regulator->min_uV = min_uV;
 	regulator->max_uV = max_uV;
 
 	ret = regulator_check_consumers(rdev, &min_uV, &max_uV);
 	if (ret < 0)
-		goto out;
+		goto err;
 
 	ret = _regulator_do_set_voltage(rdev, min_uV, max_uV);
 
+err:
+	if (ret) {
+		regulator->min_uV = curr_min;
+		regulator->max_uV = curr_max;
+	}
+
 out:
 	mutex_unlock(&rdev->mutex);
 	return ret;
-- 
1.7.5.4

