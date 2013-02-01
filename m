Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751671Ab3BAFGy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 00:06:54 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:37734 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048Ab3BAFGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 00:06:51 -0500
From: J Keerthy <j-keerthy@ti.com>
To: <linux-kernel@vger.kernel.org>, <lgirdwood@gmail.com>,
        <broonie@opensource.wolfsonmicro.com>
CC: <j-keerthy@ti.com>
Subject: [PATCH] Regulator: Reorder the min max assignment in the sequence of regulator_set_voltage function
Date: Fri, 1 Feb 2013 10:34:58 +0530
Message-ID: <1359695098-3630-1-git-send-email-j-keerthy@ti.com>
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

Signed-off-by: J Keerthy <j-keerthy@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com> 
---
 drivers/regulator/core.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 2785843..12140fb 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -81,6 +81,8 @@ struct regulator {
 	int uA_load;
 	int min_uV;
 	int max_uV;
+	int curr_min_uV;
+	int curr_max_uV;
 	char *supply_name;
 	struct device_attribute dev_attr;
 	struct regulator_dev *rdev;
@@ -2315,6 +2317,8 @@ int regulator_set_voltage(struct regulator *regulator, int min_uV, int max_uV)
 	ret = regulator_check_voltage(rdev, &min_uV, &max_uV);
 	if (ret < 0)
 		goto out;
+	regulator->curr_min_uV = regulator->min_uV;
+	regulator->curr_max_uV = regulator->max_uV;
 	regulator->min_uV = min_uV;
 	regulator->max_uV = max_uV;
 
@@ -2325,6 +2329,11 @@ int regulator_set_voltage(struct regulator *regulator, int min_uV, int max_uV)
 	ret = _regulator_do_set_voltage(rdev, min_uV, max_uV);
 
 out:
+	if (ret) {
+		regulator->min_uV = regulator->curr_min_uV;
+		regulator->max_uV = regulator->curr_max_uV;
+	}
+
 	mutex_unlock(&rdev->mutex);
 	return ret;
 }
-- 
1.7.5.4

