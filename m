Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751398Ab3IJJzV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 05:55:21 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:10369 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab3IJJzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 05:55:19 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 10 Sep 2013 02:52:17 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@kernel.org>
CC: <lgirdwood@gmail.com>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 1/2] regulator: core: provide fixed voltage in desc for single voltage rail
Date: Tue, 10 Sep 2013 15:45:05 +0530
Message-ID: <1378808106-29865-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If given rail has the single voltage (n_voltages = 1) then provide the
rail voltage through regulator descriptor so that core can use this
value for finding voltage.

This will avoid the implementation of the callback for get_voltage() or
list_voltage() callback on regulator driver.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/regulator/core.c         |    5 ++++-
 include/linux/regulator/driver.h |    2 ++
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index a01b8b3..abc899e 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2489,6 +2489,8 @@ static int _regulator_get_voltage(struct regulator_dev *rdev)
 		ret = rdev->desc->ops->get_voltage(rdev);
 	} else if (rdev->desc->ops->list_voltage) {
 		ret = rdev->desc->ops->list_voltage(rdev, 0);
+	} else if (rdev->desc->fixed_uV && (rdev->desc->n_voltages == 1)) {
+		ret = rdev->desc->fixed_uV;
 	} else {
 		return -EINVAL;
 	}
@@ -3170,7 +3172,8 @@ static int add_regulator_attributes(struct regulator_dev *rdev)
 	/* some attributes need specific methods to be displayed */
 	if ((ops->get_voltage && ops->get_voltage(rdev) >= 0) ||
 	    (ops->get_voltage_sel && ops->get_voltage_sel(rdev) >= 0) ||
-	    (ops->list_voltage && ops->list_voltage(rdev, 0) >= 0)) {
+	    (ops->list_voltage && ops->list_voltage(rdev, 0) >= 0) ||
+		(rdev->desc->fixed_uV && (rdev->desc->n_voltages == 1))) {
 		status = device_create_file(dev, &dev_attr_microvolts);
 		if (status < 0)
 			return status;
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index 67e13aa..9e8241a 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -207,6 +207,7 @@ enum regulator_type {
  * @min_uV: Voltage given by the lowest selector (if linear mapping)
  * @uV_step: Voltage increase with each selector (if linear mapping)
  * @linear_min_sel: Minimal selector for starting linear mapping
+ * @fixed_uV: Fixed voltage of rails.
  * @ramp_delay: Time to settle down after voltage change (unit: uV/us)
  * @volt_table: Voltage mapping table (if table based mapping)
  *
@@ -239,6 +240,7 @@ struct regulator_desc {
 	unsigned int min_uV;
 	unsigned int uV_step;
 	unsigned int linear_min_sel;
+	int fixed_uV;
 	unsigned int ramp_delay;
 
 	const struct regulator_linear_range *linear_ranges;
-- 
1.7.1.1

