Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299AbaC1RbW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 13:31:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51409 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbaC1RbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 13:31:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Markus Pargmann <mpa@pengutronix.de>, Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.13 29/46] regulator: core: Replace direct ops->disable usage
Date: Fri, 28 Mar 2014 10:32:13 -0700
Message-Id: <20140328173138.614802884@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140328173134.630198216@linuxfoundation.org>
References: <20140328173134.630198216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Pargmann <mpa@pengutronix.de>

commit 66fda75f47dc583f1c187556e9a2c082dd64f8c6 upstream.

There are many places where ops->disable is called directly. Instead we
should use _regulator_do_disable() which also handles gpio regulators.

To be able to use the wrapper function from _regulator_force_disable(),
I moved the _notifier_call_chain() call from _regulator_do_disable() to
_regulator_disable(). This way, _regulator_force_disable() can use
different flags for _notifier_call_chain() without calling it twice.

Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/regulator/core.c |   34 +++++++++++++---------------------
 1 file changed, 13 insertions(+), 21 deletions(-)

--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1908,8 +1908,6 @@ static int _regulator_do_disable(struct
 
 	trace_regulator_disable_complete(rdev_get_name(rdev));
 
-	_notifier_call_chain(rdev, REGULATOR_EVENT_DISABLE,
-			     NULL);
 	return 0;
 }
 
@@ -1933,6 +1931,8 @@ static int _regulator_disable(struct reg
 				rdev_err(rdev, "failed to disable\n");
 				return ret;
 			}
+			_notifier_call_chain(rdev, REGULATOR_EVENT_DISABLE,
+					NULL);
 		}
 
 		rdev->use_count = 0;
@@ -1985,20 +1985,16 @@ static int _regulator_force_disable(stru
 {
 	int ret = 0;
 
-	/* force disable */
-	if (rdev->desc->ops->disable) {
-		/* ah well, who wants to live forever... */
-		ret = rdev->desc->ops->disable(rdev);
-		if (ret < 0) {
-			rdev_err(rdev, "failed to force disable\n");
-			return ret;
-		}
-		/* notify other consumers that power has been forced off */
-		_notifier_call_chain(rdev, REGULATOR_EVENT_FORCE_DISABLE |
-			REGULATOR_EVENT_DISABLE, NULL);
+	ret = _regulator_do_disable(rdev);
+	if (ret < 0) {
+		rdev_err(rdev, "failed to force disable\n");
+		return ret;
 	}
 
-	return ret;
+	_notifier_call_chain(rdev, REGULATOR_EVENT_FORCE_DISABLE |
+			REGULATOR_EVENT_DISABLE, NULL);
+
+	return 0;
 }
 
 /**
@@ -3631,8 +3627,6 @@ int regulator_suspend_finish(void)
 
 	mutex_lock(&regulator_list_mutex);
 	list_for_each_entry(rdev, &regulator_list, list) {
-		struct regulator_ops *ops = rdev->desc->ops;
-
 		mutex_lock(&rdev->mutex);
 		if (rdev->use_count > 0  || rdev->constraints->always_on) {
 			error = _regulator_do_enable(rdev);
@@ -3641,12 +3635,10 @@ int regulator_suspend_finish(void)
 		} else {
 			if (!have_full_constraints())
 				goto unlock;
-			if (!ops->disable)
-				goto unlock;
 			if (!_regulator_is_enabled(rdev))
 				goto unlock;
 
-			error = ops->disable(rdev);
+			error = _regulator_do_disable(rdev);
 			if (error)
 				ret = error;
 		}
@@ -3820,7 +3812,7 @@ static int __init regulator_init_complet
 		ops = rdev->desc->ops;
 		c = rdev->constraints;
 
-		if (!ops->disable || (c && c->always_on))
+		if (c && c->always_on)
 			continue;
 
 		mutex_lock(&rdev->mutex);
@@ -3841,7 +3833,7 @@ static int __init regulator_init_complet
 			/* We log since this may kill the system if it
 			 * goes wrong. */
 			rdev_info(rdev, "disabling\n");
-			ret = ops->disable(rdev);
+			ret = _regulator_do_disable(rdev);
 			if (ret != 0) {
 				rdev_err(rdev, "couldn't disable: %d\n", ret);
 			}


