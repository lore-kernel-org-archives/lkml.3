Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966402AbaCUAjE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:39:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37094 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965875AbaCUAIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:08:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Markus Pargmann <mpa@pengutronix.de>, Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.10 36/85] regulator: core: Replace direct ops->enable usage
Date: Thu, 20 Mar 2014 17:09:39 -0700
Message-Id: <20140321000603.890191952@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000558.606667505@linuxfoundation.org>
References: <20140321000558.606667505@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/regulator/core.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -919,6 +919,8 @@ static int machine_constraints_voltage(s
 	return 0;
 }
 
+static int _regulator_do_enable(struct regulator_dev *rdev);
+
 /**
  * set_machine_constraints - sets regulator constraints
  * @rdev: regulator source
@@ -975,10 +977,9 @@ static int set_machine_constraints(struc
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
@@ -3790,9 +3791,8 @@ int regulator_suspend_finish(void)
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


