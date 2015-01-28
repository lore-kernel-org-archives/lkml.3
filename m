Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933249AbbA1Cqs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 21:46:48 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:18526 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754542AbbA1Cqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 21:46:45 -0500
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
CC: <agross@codeaurora.org>, <linux-arm-msm@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <patches@opensource.wolfsonmicro.com>
Subject: [PATCH 1/9] regulator: core: Consolidate drms update handling
Date: Tue, 27 Jan 2015 18:46:31 -0800
Message-ID: <1422413199-17273-2-git-send-email-bjorn.andersson@sonymobile.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422413199-17273-1-git-send-email-bjorn.andersson@sonymobile.com>
References: <1422413199-17273-1-git-send-email-bjorn.andersson@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refactor drms_uA_update() slightly to allow regulator_set_optimum_mode()
to utilize the same logic instead of duplicating it.

Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
---
 drivers/regulator/core.c | 112 +++++++++++++++--------------------------------
 1 file changed, 35 insertions(+), 77 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index e225711..0e0d829 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -658,23 +658,32 @@ static struct class regulator_class = {
 
 /* Calculate the new optimum regulator operating mode based on the new total
  * consumer load. All locks held by caller */
-static void drms_uA_update(struct regulator_dev *rdev)
+static int drms_uA_update(struct regulator_dev *rdev)
 {
 	struct regulator *sibling;
 	int current_uA = 0, output_uV, input_uV, err;
 	unsigned int mode;
 
+	/*
+	 * first check to see if we can set modes at all, otherwise just
+	 * tell the consumer everything is OK.
+	 */
 	err = regulator_check_drms(rdev);
-	if (err < 0 || !rdev->desc->ops->get_optimum_mode ||
-	    (!rdev->desc->ops->get_voltage &&
-	     !rdev->desc->ops->get_voltage_sel) ||
-	    !rdev->desc->ops->set_mode)
-		return;
+	if (err < 0)
+		return 0;
+
+	if (!rdev->desc->ops->get_optimum_mode)
+		return 0;
+
+	if (!rdev->desc->ops->set_mode)
+		return -EINVAL;
 
 	/* get output voltage */
 	output_uV = _regulator_get_voltage(rdev);
-	if (output_uV <= 0)
-		return;
+	if (output_uV <= 0) {
+		rdev_err(rdev, "invalid output voltage found\n");
+		return -EINVAL;
+	}
 
 	/* get input voltage */
 	input_uV = 0;
@@ -682,8 +691,10 @@ static void drms_uA_update(struct regulator_dev *rdev)
 		input_uV = regulator_get_voltage(rdev->supply);
 	if (input_uV <= 0)
 		input_uV = rdev->constraints->input_uV;
-	if (input_uV <= 0)
-		return;
+	if (input_uV <= 0) {
+		rdev_err(rdev, "invalid input voltage found\n");
+		return -EINVAL;
+	}
 
 	/* calc total requested load */
 	list_for_each_entry(sibling, &rdev->consumer_list, list)
@@ -695,8 +706,17 @@ static void drms_uA_update(struct regulator_dev *rdev)
 
 	/* check the new mode is allowed */
 	err = regulator_mode_constrain(rdev, &mode);
-	if (err == 0)
-		rdev->desc->ops->set_mode(rdev, mode);
+	if (err < 0) {
+		rdev_err(rdev, "failed to get optimum mode @ %d uA %d -> %d uV\n",
+			 current_uA, input_uV, output_uV);
+		return err;
+	}
+
+	err = rdev->desc->ops->set_mode(rdev, mode);
+	if (err < 0)
+		rdev_err(rdev, "failed to set optimum mode %x\n", mode);
+
+	return err;
 }
 
 static int suspend_set_state(struct regulator_dev *rdev,
@@ -3024,75 +3044,13 @@ EXPORT_SYMBOL_GPL(regulator_get_mode);
 int regulator_set_optimum_mode(struct regulator *regulator, int uA_load)
 {
 	struct regulator_dev *rdev = regulator->rdev;
-	struct regulator *consumer;
-	int ret, output_uV, input_uV = 0, total_uA_load = 0;
-	unsigned int mode;
-
-	if (rdev->supply)
-		input_uV = regulator_get_voltage(rdev->supply);
+	int ret;
 
 	mutex_lock(&rdev->mutex);
-
-	/*
-	 * first check to see if we can set modes at all, otherwise just
-	 * tell the consumer everything is OK.
-	 */
 	regulator->uA_load = uA_load;
-	ret = regulator_check_drms(rdev);
-	if (ret < 0) {
-		ret = 0;
-		goto out;
-	}
-
-	if (!rdev->desc->ops->get_optimum_mode)
-		goto out;
-
-	/*
-	 * we can actually do this so any errors are indicators of
-	 * potential real failure.
-	 */
-	ret = -EINVAL;
-
-	if (!rdev->desc->ops->set_mode)
-		goto out;
-
-	/* get output voltage */
-	output_uV = _regulator_get_voltage(rdev);
-	if (output_uV <= 0) {
-		rdev_err(rdev, "invalid output voltage found\n");
-		goto out;
-	}
-
-	/* No supply? Use constraint voltage */
-	if (input_uV <= 0)
-		input_uV = rdev->constraints->input_uV;
-	if (input_uV <= 0) {
-		rdev_err(rdev, "invalid input voltage found\n");
-		goto out;
-	}
-
-	/* calc total requested load for this regulator */
-	list_for_each_entry(consumer, &rdev->consumer_list, list)
-		total_uA_load += consumer->uA_load;
-
-	mode = rdev->desc->ops->get_optimum_mode(rdev,
-						 input_uV, output_uV,
-						 total_uA_load);
-	ret = regulator_mode_constrain(rdev, &mode);
-	if (ret < 0) {
-		rdev_err(rdev, "failed to get optimum mode @ %d uA %d -> %d uV\n",
-			 total_uA_load, input_uV, output_uV);
-		goto out;
-	}
-
-	ret = rdev->desc->ops->set_mode(rdev, mode);
-	if (ret < 0) {
-		rdev_err(rdev, "failed to set optimum mode %x\n", mode);
-		goto out;
-	}
-	ret = mode;
-out:
+	ret = drms_uA_update(rdev);
 	mutex_unlock(&rdev->mutex);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(regulator_set_optimum_mode);
-- 
1.9.1

