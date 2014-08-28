Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350AbaH1Ukq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 16:40:46 -0400
Received: from mail-qg0-f74.google.com ([209.85.192.74]:41724 "EHLO
	mail-qg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbaH1Ukp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 16:40:45 -0400
From: Doug Anderson <dianders@chromium.org>
To: Mark Brown <broonie@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        olof@lixom.net
Cc: Addy Ke <addy.ke@rock-chips.com>, Sonny Rao <sonnyrao@chromium.org>,
        Doug Anderson <dianders@chromium.org>, lgirdwood@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] regulator: core: Add REGULATOR_EVENT_PRE_VOLTAGE_CHANGE (and ABORT)
Date: Thu, 28 Aug 2014 12:19:20 -0700
Message-Id: <1409253562-8907-2-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1409253562-8907-1-git-send-email-dianders@chromium.org>
References: <1409253562-8907-1-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Stübner <heiko@sntech.de>

In some cases we need to know when a regulator is about to be changed.
Add a way for clients to be notified.  Note that for set_voltage() we
don't necessarily know what voltage we'll end up with, so we tell the
client what the range will be so they can prepare.

Signed-off-by: Heiko Stübner <heiko@sntech.de>
Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 drivers/regulator/core.c           | 63 +++++++++++++++++++++++++++++++++-----
 include/linux/regulator/consumer.h | 20 ++++++++++++
 2 files changed, 76 insertions(+), 7 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 7bce715..b31d706 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -102,7 +102,7 @@ static int _regulator_disable(struct regulator_dev *rdev);
 static int _regulator_get_voltage(struct regulator_dev *rdev);
 static int _regulator_get_current_limit(struct regulator_dev *rdev);
 static unsigned int _regulator_get_mode(struct regulator_dev *rdev);
-static void _notifier_call_chain(struct regulator_dev *rdev,
+static int _notifier_call_chain(struct regulator_dev *rdev,
 				  unsigned long event, void *data);
 static int _regulator_do_set_voltage(struct regulator_dev *rdev,
 				     int min_uV, int max_uV);
@@ -2406,6 +2406,55 @@ int regulator_is_supported_voltage(struct regulator *regulator,
 }
 EXPORT_SYMBOL_GPL(regulator_is_supported_voltage);
 
+static int _regulator_call_set_voltage(struct regulator_dev *rdev,
+				       int min_uV, int max_uV,
+				       unsigned *selector)
+{
+	struct pre_voltage_change_data data;
+	int ret;
+
+	data.old_uV = _regulator_get_voltage(rdev);
+	data.min_uV = min_uV;
+	data.max_uV = max_uV;
+	ret = _notifier_call_chain(rdev, REGULATOR_EVENT_PRE_VOLTAGE_CHANGE,
+				   &data);
+	if (ret & NOTIFY_STOP_MASK)
+		return -EINVAL;
+
+	ret = rdev->desc->ops->set_voltage(rdev, min_uV, max_uV, selector);
+	if (ret >= 0)
+		return ret;
+
+	_notifier_call_chain(rdev, REGULATOR_EVENT_ABORT_VOLTAGE_CHANGE,
+			     (void *)data.old_uV);
+
+	return ret;
+}
+
+static int _regulator_call_set_voltage_sel(struct regulator_dev *rdev,
+					   int uV, unsigned selector)
+{
+	struct pre_voltage_change_data data;
+	int ret;
+
+	data.old_uV = _regulator_get_voltage(rdev);
+	data.min_uV = uV;
+	data.max_uV = uV;
+	ret = _notifier_call_chain(rdev, REGULATOR_EVENT_PRE_VOLTAGE_CHANGE,
+				   &data);
+	if (ret & NOTIFY_STOP_MASK)
+		return -EINVAL;
+
+	ret = rdev->desc->ops->set_voltage_sel(rdev, selector);
+	if (ret >= 0)
+		return ret;
+
+	_notifier_call_chain(rdev, REGULATOR_EVENT_ABORT_VOLTAGE_CHANGE,
+			     (void *)data.old_uV);
+
+	return ret;
+}
+
 static int _regulator_do_set_voltage(struct regulator_dev *rdev,
 				     int min_uV, int max_uV)
 {
@@ -2433,8 +2482,8 @@ static int _regulator_do_set_voltage(struct regulator_dev *rdev,
 	}
 
 	if (rdev->desc->ops->set_voltage) {
-		ret = rdev->desc->ops->set_voltage(rdev, min_uV, max_uV,
-						   &selector);
+		ret = _regulator_call_set_voltage(rdev, min_uV, max_uV,
+						  &selector);
 
 		if (ret >= 0) {
 			if (rdev->desc->ops->list_voltage)
@@ -2469,8 +2518,8 @@ static int _regulator_do_set_voltage(struct regulator_dev *rdev,
 				if (old_selector == selector)
 					ret = 0;
 				else
-					ret = rdev->desc->ops->set_voltage_sel(
-								rdev, ret);
+					ret = _regulator_call_set_voltage_sel(
+						rdev, best_val, selector);
 			} else {
 				ret = -EINVAL;
 			}
@@ -3116,11 +3165,11 @@ EXPORT_SYMBOL_GPL(regulator_unregister_notifier);
 /* notify regulator consumers and downstream regulator consumers.
  * Note mutex must be held by caller.
  */
-static void _notifier_call_chain(struct regulator_dev *rdev,
+static int _notifier_call_chain(struct regulator_dev *rdev,
 				  unsigned long event, void *data)
 {
 	/* call rdev chain first */
-	blocking_notifier_call_chain(&rdev->notifier, event, data);
+	return blocking_notifier_call_chain(&rdev->notifier, event, data);
 }
 
 /**
diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
index f8a8733..d347c80 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -93,7 +93,12 @@ struct regmap;
  * OVER_TEMP      Regulator over temp.
  * FORCE_DISABLE  Regulator forcibly shut down by software.
  * VOLTAGE_CHANGE Regulator voltage changed.
+ *                Data passed is old voltage cast to (void *).
  * DISABLE        Regulator was disabled.
+ * PRE_VOLTAGE_CHANGE   Regulator is about to have voltage changed.
+ *                      Data passed is "struct pre_voltage_change_data"
+ * ABORT_VOLTAGE_CHANGE Regulator voltage change failed for some reason.
+ *                      Data passed is old voltage cast to (void *).
  *
  * NOTE: These events can be OR'ed together when passed into handler.
  */
@@ -106,6 +111,21 @@ struct regmap;
 #define REGULATOR_EVENT_FORCE_DISABLE		0x20
 #define REGULATOR_EVENT_VOLTAGE_CHANGE		0x40
 #define REGULATOR_EVENT_DISABLE 		0x80
+#define REGULATOR_EVENT_PRE_VOLTAGE_CHANGE	0x100
+#define REGULATOR_EVENT_ABORT_VOLTAGE_CHANGE	0x200
+
+/**
+ * struct pre_voltage_change_data - Data sent with PRE_VOLTAGE_CHANGE event
+ *
+ * @old_uV: Current voltage before change.
+ * @min_uV: Min voltage we'll change to.
+ * @max_uV: Max voltage we'll change to.
+ */
+struct pre_voltage_change_data {
+	unsigned long old_uV;
+	unsigned long min_uV;
+	unsigned long max_uV;
+};
 
 struct regulator;
 
-- 
2.1.0.rc2.206.gedb03e5

