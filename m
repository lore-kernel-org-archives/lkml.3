Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745AbaKLKMO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 05:12:14 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:55376 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679AbaKLKML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 05:12:11 -0500
From: Thierry Reding <thierry.reding@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Allen Martin <amartin@nvidia.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] regulator: Ensure voltages are within the allowed range
Date: Wed, 12 Nov 2014 11:12:05 +0100
Message-Id: <1415787125-31218-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

Unless a regulator has a fixed output voltage the core will not attempt
to modify the output voltage. This can cause a situation where a driver
enables the regulator but the currently configured voltage is outside
the valid range.

Fix this by constraining the current voltage to the allowed range upon
regulator registration.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/regulator/core.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index bbf93c9caca3..97851f39b4c0 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -876,6 +876,7 @@ static int machine_constraints_voltage(struct regulator_dev *rdev,
 		int	max_uV = INT_MIN;
 		int	cmin = constraints->min_uV;
 		int	cmax = constraints->max_uV;
+		int	value;
 
 		/* it's safe to autoconfigure fixed-voltage supplies
 		   and the constraints are used by list_voltage. */
@@ -898,8 +899,6 @@ static int machine_constraints_voltage(struct regulator_dev *rdev,
 
 		/* initial: [cmin..cmax] valid, [min_uV..max_uV] not */
 		for (i = 0; i < count; i++) {
-			int	value;
-
 			value = ops->list_voltage(rdev, i);
 			if (value <= 0)
 				continue;
@@ -930,6 +929,24 @@ static int machine_constraints_voltage(struct regulator_dev *rdev,
 				 constraints->max_uV, max_uV);
 			constraints->max_uV = max_uV;
 		}
+
+		/*
+		 * Now that the voltage range has been determined, make sure
+		 * that the regulator's current voltage is within that range.
+		 */
+		value = _regulator_get_voltage(rdev);
+
+		if (value < constraints->min_uV ||
+		    value > constraints->max_uV) {
+			ret = _regulator_do_set_voltage(rdev,
+							constraints->min_uV,
+							constraints->max_uV);
+			if (ret < 0) {
+				rdev_err(rdev, "failed to set voltage to within %d-%d\n",
+					 constraints->min_uV, constraints->max_uV);
+				return ret;
+			}
+		}
 	}
 
 	return 0;
-- 
2.1.3

