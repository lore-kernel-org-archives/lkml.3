Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933352AbbA1Cqv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 21:46:51 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:18540 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933217AbbA1Cqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 21:46:48 -0500
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
CC: <agross@codeaurora.org>, <linux-arm-msm@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <patches@opensource.wolfsonmicro.com>
Subject: [PATCH 2/9] regulator: core: Introduce set_optimum_mode op
Date: Tue, 27 Jan 2015 18:46:32 -0800
Message-ID: <1422413199-17273-3-git-send-email-bjorn.andersson@sonymobile.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422413199-17273-1-git-send-email-bjorn.andersson@sonymobile.com>
References: <1422413199-17273-1-git-send-email-bjorn.andersson@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Expose the requested load directly to the regulator implementation for
hardware that does not support the normal enum based set_mode().

Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
---

Note that the majority of the change to drms_uA_update is cancelled out in
patch 8, but I added this to keep it bisectable.

 drivers/regulator/core.c         | 42 ++++++++++++++++++++++++++--------------
 include/linux/regulator/driver.h |  5 +++++
 2 files changed, 32 insertions(+), 15 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 0e0d829..2a53515 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -672,10 +672,12 @@ static int drms_uA_update(struct regulator_dev *rdev)
 	if (err < 0)
 		return 0;
 
-	if (!rdev->desc->ops->get_optimum_mode)
+	if (!rdev->desc->ops->get_optimum_mode &&
+	    !rdev->desc->ops->set_optimum_mode)
 		return 0;
 
-	if (!rdev->desc->ops->set_mode)
+	if (!rdev->desc->ops->set_mode &&
+	    !rdev->desc->ops->set_optimum_mode)
 		return -EINVAL;
 
 	/* get output voltage */
@@ -700,22 +702,32 @@ static int drms_uA_update(struct regulator_dev *rdev)
 	list_for_each_entry(sibling, &rdev->consumer_list, list)
 		current_uA += sibling->uA_load;
 
-	/* now get the optimum mode for our new total regulator load */
-	mode = rdev->desc->ops->get_optimum_mode(rdev, input_uV,
-						  output_uV, current_uA);
+	if (rdev->desc->ops->set_optimum_mode) {
+		/* set the optimum mode for our new total regulator load */
+		err = rdev->desc->ops->set_optimum_mode(rdev,
+							input_uV, output_uV,
+							current_uA);
+		if (err < 0)
+			rdev_err(rdev, "failed to set optimum mode @ %d uA %d -> %d uV\n",
+				 current_uA, input_uV, output_uV);
+	} else {
+		/* now get the optimum mode for our new total regulator load */
+		mode = rdev->desc->ops->get_optimum_mode(rdev, input_uV,
+							 output_uV, current_uA);
+
+		/* check the new mode is allowed */
+		err = regulator_mode_constrain(rdev, &mode);
+		if (err < 0) {
+			rdev_err(rdev, "failed to get optimum mode @ %d uA %d -> %d uV\n",
+				 current_uA, input_uV, output_uV);
+			return err;
+		}
 
-	/* check the new mode is allowed */
-	err = regulator_mode_constrain(rdev, &mode);
-	if (err < 0) {
-		rdev_err(rdev, "failed to get optimum mode @ %d uA %d -> %d uV\n",
-			 current_uA, input_uV, output_uV);
-		return err;
+		err = rdev->desc->ops->set_mode(rdev, mode);
+		if (err < 0)
+			rdev_err(rdev, "failed to set optimum mode %x\n", mode);
 	}
 
-	err = rdev->desc->ops->set_mode(rdev, mode);
-	if (err < 0)
-		rdev_err(rdev, "failed to set optimum mode %x\n", mode);
-
 	return err;
 }
 
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index 5f1e9ca..837addb 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -97,6 +97,8 @@ struct regulator_linear_range {
  *	REGULATOR_STATUS value (or negative errno)
  * @get_optimum_mode: Get the most efficient operating mode for the regulator
  *                    when running with the specified parameters.
+ * @set_optimum_mode: Set the most efficient operating mode for the regulator
+ *                    when running with the specified parameters.
  *
  * @set_bypass: Set the regulator in bypass mode.
  * @get_bypass: Get the regulator bypass mode state.
@@ -166,6 +168,9 @@ struct regulator_ops {
 	/* get most efficient regulator operating mode for load */
 	unsigned int (*get_optimum_mode) (struct regulator_dev *, int input_uV,
 					  int output_uV, int load_uA);
+	/* set most efficient regulator operating mode for load */
+	int (*set_optimum_mode)(struct regulator_dev *, int input_uV,
+				int output_uV, int load_uA);
 
 	/* control and report on bypass mode */
 	int (*set_bypass)(struct regulator_dev *dev, bool enable);
-- 
1.9.1

