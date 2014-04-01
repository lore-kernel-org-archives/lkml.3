Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529AbaDAMWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 08:22:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42121 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbaDALQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:16:13 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Markus Pargmann <mpa@pengutronix.de>, Mark Brown <broonie@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 014/144] regulator: core: Replace direct ops->enable usage
Date: Tue,  1 Apr 2014 12:13:38 +0100
Message-Id: <1396350948-29910-15-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Pargmann <mpa@pengutronix.de>

commit 30c219710358c5cca2f8bd2e9e547c6aadf7cf8b upstream.

There are some direct ops->enable in the regulator core driver. This is
a potential issue as the function _regulator_do_enable() handles gpio
regulators and the normal ops->enable calls. These gpio regulators are
simply ignored when ops->enable is called directly.

One possible bug is that boot-on and always-on gpio regulators are not
enabled on registration.

This patch replaces all ops->enable calls by _regulator_do_enable.

[Handle missing enable operations -- broonie]

Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
Signed-off-by: Mark Brown <broonie@linaro.org>

regulator: Handle invalid enable operation for always/boot on regulators

Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/regulator/core.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 288c75a..b94784e 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -919,6 +919,8 @@ static int machine_constraints_voltage(struct regulator_dev *rdev,
 	return 0;
 }
 
+static int _regulator_do_enable(struct regulator_dev *rdev);
+
 /**
  * set_machine_constraints - sets regulator constraints
  * @rdev: regulator source
@@ -975,10 +977,9 @@ static int set_machine_constraints(struct regulator_dev *rdev,
 	/* If the constraints say the regulator should be on at this point
 	 * and we have control then make sure it is enabled.
 	 */
-	if ((rdev->constraints->always_on || rdev->constraints->boot_on) &&
-	    ops->enable) {
-		ret = ops->enable(rdev);
-		if (ret < 0) {
+	if (rdev->constraints->always_on || rdev->constraints->boot_on) {
+		ret = _regulator_do_enable(rdev);
+		if (ret < 0 && ret != -EINVAL) {
 			rdev_err(rdev, "failed to enable\n");
 			goto out;
 		}
@@ -3805,9 +3806,8 @@ int regulator_suspend_finish(void)
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
1.9.1

