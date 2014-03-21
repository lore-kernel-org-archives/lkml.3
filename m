Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967050AbaCUBTY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 21:19:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36575 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760418AbaCUADr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:03:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Markus Pargmann <mpa@pengutronix.de>, Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.13 060/149] regulator: core: Replace direct ops->enable usage
Date: Thu, 20 Mar 2014 17:03:43 -0700
Message-Id: <20140321000439.040176499@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -953,6 +953,8 @@ static int machine_constraints_current(s
 	return 0;
 }
 
+static int _regulator_do_enable(struct regulator_dev *rdev);
+
 /**
  * set_machine_constraints - sets regulator constraints
  * @rdev: regulator source
@@ -1013,10 +1015,9 @@ static int set_machine_constraints(struc
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


