Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971AbaKXOM3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 09:12:29 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54139 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752679AbaKXOM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 09:12:28 -0500
From: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Subject: [PATCH] regulator: core: Add PRE_DISABLE notification
Date: Mon, 24 Nov 2014 14:10:52 +0000
Message-Id: <1416838252-15508-1-git-send-email-rf@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a PRE_DISABLE notification so that consumers can use a
notifier to run any steps required to prepare for the
regulator being switched off. Since the regulator disable
can fail an abort notification is also added.

Signed-off-by: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c           |   16 ++++++++++++++++
 include/linux/regulator/consumer.h |    4 ++++
 2 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index bbf93c9..8f48df4 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1976,9 +1976,18 @@ static int _regulator_disable(struct regulator_dev *rdev)
 
 		/* we are last user */
 		if (_regulator_can_change_status(rdev)) {
+			ret = _notifier_call_chain(rdev,
+						   REGULATOR_EVENT_PRE_DISABLE,
+						   NULL);
+			if (ret & NOTIFY_STOP_MASK)
+				return -EINVAL;
+
 			ret = _regulator_do_disable(rdev);
 			if (ret < 0) {
 				rdev_err(rdev, "failed to disable\n");
+				_notifier_call_chain(rdev,
+						REGULATOR_EVENT_ABORT_DISABLE,
+						NULL);
 				return ret;
 			}
 			_notifier_call_chain(rdev, REGULATOR_EVENT_DISABLE,
@@ -2035,9 +2044,16 @@ static int _regulator_force_disable(struct regulator_dev *rdev)
 {
 	int ret = 0;
 
+	ret = _notifier_call_chain(rdev, REGULATOR_EVENT_FORCE_DISABLE |
+			REGULATOR_EVENT_PRE_DISABLE, NULL);
+	if (ret & NOTIFY_STOP_MASK)
+		return -EINVAL;
+
 	ret = _regulator_do_disable(rdev);
 	if (ret < 0) {
 		rdev_err(rdev, "failed to force disable\n");
+		_notifier_call_chain(rdev, REGULATOR_EVENT_FORCE_DISABLE |
+				REGULATOR_EVENT_ABORT_DISABLE, NULL);
 		return ret;
 	}
 
diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
index 3c4fad5..d17e1ff 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -101,6 +101,8 @@ struct regmap;
  *                      Data passed is "struct pre_voltage_change_data"
  * ABORT_VOLTAGE_CHANGE Regulator voltage change failed for some reason.
  *                      Data passed is old voltage cast to (void *).
+ * PRE_DISABLE    Regulator is about to be disabled
+ * ABORT_DISABLE  Regulator disable failed for some reason
  *
  * NOTE: These events can be OR'ed together when passed into handler.
  */
@@ -115,6 +117,8 @@ struct regmap;
 #define REGULATOR_EVENT_DISABLE 		0x80
 #define REGULATOR_EVENT_PRE_VOLTAGE_CHANGE	0x100
 #define REGULATOR_EVENT_ABORT_VOLTAGE_CHANGE	0x200
+#define REGULATOR_EVENT_PRE_DISABLE		0x400
+#define REGULATOR_EVENT_ABORT_DISABLE		0x800
 
 /**
  * struct pre_voltage_change_data - Data sent with PRE_VOLTAGE_CHANGE event
-- 
1.7.2.5

