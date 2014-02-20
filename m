Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248AbaBTLIp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 06:08:45 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35967 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034AbaBTLIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 06:08:42 -0500
From: Markus Pargmann <mpa@pengutronix.de>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@pengutronix.de, Markus Pargmann <mpa@pengutronix.de>,
        <stable@vger.kernel.org>
Subject: [PATCH v2 1/2] regulator: core: Replace direct ops->enable usage
Date: Thu, 20 Feb 2014 12:07:51 +0100
Message-Id: <1392894472-11956-2-git-send-email-mpa@pengutronix.de>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1392894472-11956-1-git-send-email-mpa@pengutronix.de>
References: <1392894472-11956-1-git-send-email-mpa@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: mpa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are some direct ops->enable in the regulator core driver. This is
a potential issue as the function _regulator_do_enable() handles gpio
regulators and the normal ops->enable calls. These gpio regulators are
simply ignored when ops->enable is called directly.

One possible bug is that boot-on and always-on gpio regulators are not
enabled on registration.

This patch replaces all ops->enable calls by _regulator_do_enable.

Cc: <stable@vger.kernel.org> # 3.10+
Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
---
 drivers/regulator/core.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 16a309e..017f5cb 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -953,6 +953,8 @@ static int machine_constraints_current(struct regulator_dev *rdev,
 	return 0;
 }
 
+static int _regulator_do_enable(struct regulator_dev *rdev);
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
+		ret = _regulator_do_enable(rdev);
 		if (ret < 0) {
 			rdev_err(rdev, "failed to enable\n");
 			goto out;
@@ -3633,9 +3634,8 @@ int regulator_suspend_finish(void)
 		struct regulator_ops *ops = rdev->desc->ops;
 
 		mutex_lock(&rdev->mutex);
-		if ((rdev->use_count > 0  || rdev->constraints->always_on) &&
-				ops->enable) {
-			error = ops->enable(rdev);
+		if (rdev->use_count > 0  || rdev->constraints->always_on) {
+			error = _regulator_do_enable(rdev);
 			if (error)
 				ret = error;
 		} else {
-- 
1.8.5.3

