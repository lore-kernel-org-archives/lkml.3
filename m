Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483AbaBTQg0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 11:36:26 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35630 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552AbaBTQgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 11:36:24 -0500
From: Markus Pargmann <mpa@pengutronix.de>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@pengutronix.de, Markus Pargmann <mpa@pengutronix.de>,
        <stable@vger.kernel.org>
Subject: [PATCH v3 2/2] regulator: core: Replace direct ops->disable usage
Date: Thu, 20 Feb 2014 17:36:04 +0100
Message-Id: <1392914164-28596-3-git-send-email-mpa@pengutronix.de>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1392914164-28596-1-git-send-email-mpa@pengutronix.de>
References: <1392914164-28596-1-git-send-email-mpa@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: mpa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are many places where ops->disable is called directly. Instead we
should use _regulator_do_disable() which also handles gpio regulators.

To be able to use the wrapper function from _regulator_force_disable(),
I moved the _notifier_call_chain() call from _regulator_do_disable() to
_regulator_disable(). This way, _regulator_force_disable() can use
different flags for _notifier_call_chain() without calling it twice.

Cc: <stable@vger.kernel.org> # 3.10+
Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
---
 drivers/regulator/core.c | 34 +++++++++++++---------------------
 1 file changed, 13 insertions(+), 21 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 017f5cb..e7a83e5 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1908,8 +1908,6 @@ static int _regulator_do_disable(struct regulator_dev *rdev)
 
 	trace_regulator_disable_complete(rdev_get_name(rdev));
 
-	_notifier_call_chain(rdev, REGULATOR_EVENT_DISABLE,
-			     NULL);
 	return 0;
 }
 
@@ -1933,6 +1931,8 @@ static int _regulator_disable(struct regulator_dev *rdev)
 				rdev_err(rdev, "failed to disable\n");
 				return ret;
 			}
+			_notifier_call_chain(rdev, REGULATOR_EVENT_DISABLE,
+					NULL);
 		}
 
 		rdev->use_count = 0;
@@ -1985,20 +1985,16 @@ static int _regulator_force_disable(struct regulator_dev *rdev)
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
@@ -3820,7 +3812,7 @@ static int __init regulator_init_complete(void)
 		ops = rdev->desc->ops;
 		c = rdev->constraints;
 
-		if (!ops->disable || (c && c->always_on))
+		if (c && c->always_on)
 			continue;
 
 		mutex_lock(&rdev->mutex);
@@ -3841,7 +3833,7 @@ static int __init regulator_init_complete(void)
 			/* We log since this may kill the system if it
 			 * goes wrong. */
 			rdev_info(rdev, "disabling\n");
-			ret = ops->disable(rdev);
+			ret = _regulator_do_disable(rdev);
 			if (ret != 0)
 				rdev_err(rdev, "couldn't disable: %d\n", ret);
 		} else {
-- 
1.8.5.3

