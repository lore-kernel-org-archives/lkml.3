Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012AbaBYKEP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 05:04:15 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37117 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971AbaBYKEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 05:04:11 -0500
From: Markus Pargmann <mpa@pengutronix.de>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@pengutronix.de, Markus Pargmann <mpa@pengutronix.de>
Subject: [PATCH 2/2] regulator: core: Error on not always_on dummy regulators
Date: Tue, 25 Feb 2014 11:03:47 +0100
Message-Id: <1393322627-26543-3-git-send-email-mpa@pengutronix.de>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393322627-26543-1-git-send-email-mpa@pengutronix.de>
References: <1393322627-26543-1-git-send-email-mpa@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: mpa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It does not make sense to have dummy/fixed regulators that are not
always_on. This patch adds a check in the set_machine_constraints
function for this case and returns -EINVAL if such a regulator is
registered.

This also removes the return -EINVAL from _regulator_do_enable() if the
regulator can not be enabled.

Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
---
 drivers/regulator/core.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 6f71985..cb10faf 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -954,6 +954,7 @@ static int machine_constraints_current(struct regulator_dev *rdev,
 }
 
 static int _regulator_do_enable(struct regulator_dev *rdev);
+static bool regulator_can_enable(struct regulator_dev *rdev);
 
 /**
  * set_machine_constraints - sets regulator constraints
@@ -1012,12 +1013,19 @@ static int set_machine_constraints(struct regulator_dev *rdev,
 		}
 	}
 
+	if (!rdev->constraints->always_on && !regulator_can_enable(rdev))
+	{
+		rdev_err(rdev, "dummy regulator without always_on constraints is not valid\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
 	/* If the constraints say the regulator should be on at this point
 	 * and we have control then make sure it is enabled.
 	 */
 	if (rdev->constraints->always_on || rdev->constraints->boot_on) {
 		ret = _regulator_do_enable(rdev);
-		if (ret < 0 && ret != -EINVAL) {
+		if (ret) {
 			rdev_err(rdev, "failed to enable\n");
 			goto out;
 		}
@@ -1739,6 +1747,21 @@ static int regulator_ena_gpio_ctrl(struct regulator_dev *rdev, bool enable)
 	return 0;
 }
 
+/*
+ * Returns true if the regulator can be enabled through ops->enable or
+ * enable gpios.
+ */
+static bool regulator_can_enable(struct regulator_dev *rdev)
+{
+	if (rdev->desc->ops->enable)
+		return true;
+
+	if (rdev->ena_pin)
+		return true;
+
+	return false;
+}
+
 static int _regulator_do_enable(struct regulator_dev *rdev)
 {
 	int ret, delay;
@@ -1763,8 +1786,6 @@ static int _regulator_do_enable(struct regulator_dev *rdev)
 		ret = rdev->desc->ops->enable(rdev);
 		if (ret < 0)
 			return ret;
-	} else {
-		return -EINVAL;
 	}
 
 	/* Allow the regulator to ramp; it would be useful to extend
-- 
1.8.5.3

