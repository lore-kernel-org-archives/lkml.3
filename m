Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933634AbbA1Crh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 21:47:37 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:18664 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933520AbbA1CrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 21:47:06 -0500
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
CC: <agross@codeaurora.org>, <linux-kernel@vger.kernel.org>,
        <patches@opensource.wolfsonmicro.com>, <linux-arm-msm@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 8/9] regulator: Drop now unused get_optimum_mode
Date: Tue, 27 Jan 2015 18:46:38 -0800
Message-ID: <1422413199-17273-9-git-send-email-bjorn.andersson@sonymobile.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422413199-17273-1-git-send-email-bjorn.andersson@sonymobile.com>
References: <1422413199-17273-1-git-send-email-bjorn.andersson@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
---
 drivers/regulator/core.c         | 40 ++++++++--------------------------------
 include/linux/regulator/driver.h |  5 -----
 2 files changed, 8 insertions(+), 37 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 2a53515..cfab6fc 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -662,7 +662,6 @@ static int drms_uA_update(struct regulator_dev *rdev)
 {
 	struct regulator *sibling;
 	int current_uA = 0, output_uV, input_uV, err;
-	unsigned int mode;
 
 	/*
 	 * first check to see if we can set modes at all, otherwise just
@@ -672,14 +671,9 @@ static int drms_uA_update(struct regulator_dev *rdev)
 	if (err < 0)
 		return 0;
 
-	if (!rdev->desc->ops->get_optimum_mode &&
-	    !rdev->desc->ops->set_optimum_mode)
+	if (!rdev->desc->ops->set_optimum_mode)
 		return 0;
 
-	if (!rdev->desc->ops->set_mode &&
-	    !rdev->desc->ops->set_optimum_mode)
-		return -EINVAL;
-
 	/* get output voltage */
 	output_uV = _regulator_get_voltage(rdev);
 	if (output_uV <= 0) {
@@ -702,31 +696,13 @@ static int drms_uA_update(struct regulator_dev *rdev)
 	list_for_each_entry(sibling, &rdev->consumer_list, list)
 		current_uA += sibling->uA_load;
 
-	if (rdev->desc->ops->set_optimum_mode) {
-		/* set the optimum mode for our new total regulator load */
-		err = rdev->desc->ops->set_optimum_mode(rdev,
-							input_uV, output_uV,
-							current_uA);
-		if (err < 0)
-			rdev_err(rdev, "failed to set optimum mode @ %d uA %d -> %d uV\n",
-				 current_uA, input_uV, output_uV);
-	} else {
-		/* now get the optimum mode for our new total regulator load */
-		mode = rdev->desc->ops->get_optimum_mode(rdev, input_uV,
-							 output_uV, current_uA);
-
-		/* check the new mode is allowed */
-		err = regulator_mode_constrain(rdev, &mode);
-		if (err < 0) {
-			rdev_err(rdev, "failed to get optimum mode @ %d uA %d -> %d uV\n",
-				 current_uA, input_uV, output_uV);
-			return err;
-		}
-
-		err = rdev->desc->ops->set_mode(rdev, mode);
-		if (err < 0)
-			rdev_err(rdev, "failed to set optimum mode %x\n", mode);
-	}
+	/* set the optimum mode for our new total regulator load */
+	err = rdev->desc->ops->set_optimum_mode(rdev,
+						input_uV, output_uV,
+						current_uA);
+	if (err < 0)
+		rdev_err(rdev, "failed to set optimum mode @ %d uA %d -> %d uV\n",
+			 current_uA, input_uV, output_uV);
 
 	return err;
 }
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index 837addb..f472cb5 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -95,8 +95,6 @@ struct regulator_linear_range {
  * @get_mode: Get the configured operating mode for the regulator.
  * @get_status: Return actual (not as-configured) status of regulator, as a
  *	REGULATOR_STATUS value (or negative errno)
- * @get_optimum_mode: Get the most efficient operating mode for the regulator
- *                    when running with the specified parameters.
  * @set_optimum_mode: Set the most efficient operating mode for the regulator
  *                    when running with the specified parameters.
  *
@@ -165,9 +163,6 @@ struct regulator_ops {
 	 */
 	int (*get_status)(struct regulator_dev *);
 
-	/* get most efficient regulator operating mode for load */
-	unsigned int (*get_optimum_mode) (struct regulator_dev *, int input_uV,
-					  int output_uV, int load_uA);
 	/* set most efficient regulator operating mode for load */
 	int (*set_optimum_mode)(struct regulator_dev *, int input_uV,
 				int output_uV, int load_uA);
-- 
1.9.1

