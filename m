Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519AbaBPTBN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 14:01:13 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:32873 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256AbaBPTBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 14:01:11 -0500
From: Markus Pargmann <mpa@pengutronix.de>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@pengutronix.de, Markus Pargmann <mpa@pengutronix.de>,
        stable@vger.kernel.org
Subject: [PATCH] regulator: core bugfix: Use normal enable for always_on regulators
Date: Sun, 16 Feb 2014 20:00:56 +0100
Message-Id: <1392577256-20475-1-git-send-email-mpa@pengutronix.de>
X-Mailer: git-send-email 1.8.5.3
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: mpa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

always_on regulators are currently enabled at registration using the
enable function of struct regulator_ops.

The regulator framework does support gpios to enable/disable regulators.
gpios are not handled through struct regulator_ops functions as they are
a basic component of the framework. Instead they are handled within
_regulator_do_enable(). Unfortunately always-on regulator do not use
this function, to gpio-controlled always-on regulators which are not
enabled on boot. Furthermore they are disabled the whole time because
regulator_enable() does not call _regulator_do_enable() for always-on
regulator.

This patch seperates _regulator_do_enable_no_delay from the
_regulator_do_enable function to be able to call the enable function
without delays. It then fixes the always_on behaviour by using this
function.

Cc: stable@vger.kernel.org
Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
---
 drivers/regulator/core.c | 45 +++++++++++++++++++++++++++------------------
 1 file changed, 27 insertions(+), 18 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 16a309e..8469244 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -953,6 +953,8 @@ static int machine_constraints_current(struct regulator_dev *rdev,
 	return 0;
 }
 
+static int _regulator_do_enable_no_delay(struct regulator_dev *rdev);
+
 /**
  * set_machine_constraints - sets regulator constraints
  * @rdev: regulator source
@@ -1013,9 +1015,8 @@ static int set_machine_constraints(struct regulator_dev *rdev,
 	/* If the constraints say the regulator should be on at this point
 	 * and we have control then make sure it is enabled.
 	 */
-	if ((rdev->constraints->always_on || rdev->constraints->boot_on) &&
-	    ops->enable) {
-		ret = ops->enable(rdev);
+	if (rdev->constraints->always_on || rdev->constraints->boot_on) {
+		ret = _regulator_do_enable_no_delay(rdev);
 		if (ret < 0) {
 			rdev_err(rdev, "failed to enable\n");
 			goto out;
@@ -1745,6 +1746,24 @@ static int regulator_ena_gpio_ctrl(struct regulator_dev *rdev, bool enable)
 	return 0;
 }
 
+static int _regulator_do_enable_no_delay(struct regulator_dev *rdev)
+{
+	int ret;
+
+	if (rdev->ena_pin) {
+		ret = regulator_ena_gpio_ctrl(rdev, true);
+		if (ret < 0)
+			return ret;
+		rdev->ena_gpio_state = 1;
+	} else if (rdev->desc->ops->enable) {
+		ret = rdev->desc->ops->enable(rdev);
+	} else {
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
 static int _regulator_do_enable(struct regulator_dev *rdev)
 {
 	int ret, delay;
@@ -1760,18 +1779,9 @@ static int _regulator_do_enable(struct regulator_dev *rdev)
 
 	trace_regulator_enable(rdev_get_name(rdev));
 
-	if (rdev->ena_pin) {
-		ret = regulator_ena_gpio_ctrl(rdev, true);
-		if (ret < 0)
-			return ret;
-		rdev->ena_gpio_state = 1;
-	} else if (rdev->desc->ops->enable) {
-		ret = rdev->desc->ops->enable(rdev);
-		if (ret < 0)
-			return ret;
-	} else {
-		return -EINVAL;
-	}
+	ret = _regulator_do_enable_no_delay(rdev);
+	if (ret)
+		return ret;
 
 	/* Allow the regulator to ramp; it would be useful to extend
 	 * this for bulk operations so that the regulators can ramp
@@ -3633,9 +3643,8 @@ int regulator_suspend_finish(void)
 		struct regulator_ops *ops = rdev->desc->ops;
 
 		mutex_lock(&rdev->mutex);
-		if ((rdev->use_count > 0  || rdev->constraints->always_on) &&
-				ops->enable) {
-			error = ops->enable(rdev);
+		if (rdev->use_count > 0  || rdev->constraints->always_on) {
+			error = _regulator_do_enable_no_delay(rdev);
 			if (error)
 				ret = error;
 		} else {
-- 
1.8.5.3

