Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187Ab3IMSyP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 14:54:15 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58857 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab3IMSyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 14:54:14 -0400
From: Mark Brown <broonie@kernel.org>
To: Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Mark Brown <broonie@linaro.org>
Date: Fri, 13 Sep 2013 19:54:04 +0100
Message-Id: <1379098445-22163-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.4.rc3
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH 1/2] regulator: core: Provide a dummy regulator with full constraints
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

When a system has said that it has fully specified constraints for its
regulators it is still possible that some supplies may be missing,
especially if regulator support has been added to a driver after the
board was integrated. We can handle such situations more gracefully by
providing a dummy regulator.

Unless the caller has specifically indicated that the system design may
not include a given regulator by using regulator_get_optional() or that
it needs its interactions to have an effect using regulator_get_exclusive()
provide a dummy regulator if we can't locate a real one.

The kconfig option REGULATOR_DUMMY that provided similar behaviour for all
regulators has been removed, systems that need it should flag that they
have full constraints instead.  Some more thought is needed for a more
elegant way of handling non-DT systems.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/regulator/Kconfig | 10 ----------
 drivers/regulator/core.c  | 36 +++++++++++++++++++-----------------
 2 files changed, 19 insertions(+), 27 deletions(-)

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index dfe5809..0417ce3 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -28,16 +28,6 @@ config REGULATOR_DEBUG
 	help
 	  Say yes here to enable debugging support.
 
-config REGULATOR_DUMMY
-	bool "Provide a dummy regulator if regulator lookups fail"
-	help
-	  If this option is enabled then when a regulator lookup fails
-	  and the board has not specified that it has provided full
-	  constraints the regulator core will provide an always
-	  enabled dummy regulator, allowing consumer drivers to continue.
-
-	  A warning will be generated when this substitution is done.
-
 config REGULATOR_FIXED_VOLTAGE
 	tristate "Fixed voltage regulator support"
 	help
diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 02af90e..c9740b5 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1225,7 +1225,7 @@ static struct regulator_dev *regulator_dev_lookup(struct device *dev,
 
 /* Internal regulator request function */
 static struct regulator *_regulator_get(struct device *dev, const char *id,
-					bool exclusive)
+					bool exclusive, bool allow_dummy)
 {
 	struct regulator_dev *rdev;
 	struct regulator *regulator = ERR_PTR(-EPROBE_DEFER);
@@ -1250,30 +1250,32 @@ static struct regulator *_regulator_get(struct device *dev, const char *id,
 	 * If we have return value from dev_lookup fail, we do not expect to
 	 * succeed, so, quit with appropriate error value
 	 */
-	if (ret) {
+	if (ret && ret != -ENODEV) {
 		regulator = ERR_PTR(ret);
 		goto out;
 	}
 
-	if (board_wants_dummy_regulator) {
-		rdev = dummy_regulator_rdev;
-		goto found;
-	}
-
-#ifdef CONFIG_REGULATOR_DUMMY
 	if (!devname)
 		devname = "deviceless";
 
-	/* If the board didn't flag that it was fully constrained then
-	 * substitute in a dummy regulator so consumers can continue.
+	/*
+	 * Assume that a regulator is physically present and enabled
+	 * even if it isn't hooked up and just provide a dummy.
 	 */
-	if (!has_full_constraints) {
-		pr_warn("%s supply %s not found, using dummy regulator\n",
-			devname, id);
+	if (has_full_constraints && allow_dummy) {
+		/*
+		 * Log the substitution if regulator configuration is
+		 * not complete to help development.
+		 */
+		if (!has_full_constraints)
+			pr_warn("%s supply %s not found, using dummy regulator\n",
+				devname, id);
+
 		rdev = dummy_regulator_rdev;
 		goto found;
+	} else {
+		dev_err(dev, "dummy supplies not allowed\n");
 	}
-#endif
 
 	mutex_unlock(&regulator_list_mutex);
 	return regulator;
@@ -1331,7 +1333,7 @@ out:
  */
 struct regulator *regulator_get(struct device *dev, const char *id)
 {
-	return _regulator_get(dev, id, false);
+	return _regulator_get(dev, id, false, true);
 }
 EXPORT_SYMBOL_GPL(regulator_get);
 
@@ -1358,7 +1360,7 @@ EXPORT_SYMBOL_GPL(regulator_get);
  */
 struct regulator *regulator_get_exclusive(struct device *dev, const char *id)
 {
-	return _regulator_get(dev, id, true);
+	return _regulator_get(dev, id, true, false);
 }
 EXPORT_SYMBOL_GPL(regulator_get_exclusive);
 
@@ -1387,7 +1389,7 @@ EXPORT_SYMBOL_GPL(regulator_get_exclusive);
  */
 struct regulator *regulator_get_optional(struct device *dev, const char *id)
 {
-	return _regulator_get(dev, id, 0);
+	return _regulator_get(dev, id, false, false);
 }
 EXPORT_SYMBOL_GPL(regulator_get_optional);
 
-- 
1.8.4.rc3

