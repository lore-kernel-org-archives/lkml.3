Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750924Ab3FVUL2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 16:11:28 -0400
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:58708 "EHLO
	qmta02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750746Ab3FVULZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 16:11:25 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: pavel@ucw.cz, rjw@sisk.pl, len.brown@intel.com, gregkh@linuxfoundation.org,
        airlied@linux.ie
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        shuahkhan@gmail.com
Subject: [PATCH 1/2] power: add new interface to return pm_transition state
Date: Sat, 22 Jun 2013 14:11:14 -0600
Message-Id: <1371931874-3220-1-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new interface get_pm_transition() to return pm_transition state.
This interface is intended to be used from dev_pm_ops class and type
suspend interfaces that call legacy pm ops driver suspend interfaces.
Legacy suspend pm_ops take pm_message_t as a parameter.

e.g: drm_class_suspend() calls into driver suspend routines
via drm_dev->driver->suspend(drm_dev, state).

Once drm_class_suspend() is converted to dev_pm_ops, it will no longer
have access to pm_transition which it has to pass into driver legacy
suspend calls. get_pm_transition() interface addresses this need.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/base/power/main.c |   17 +++++++++++++++++
 include/linux/pm.h        |    3 +++
 2 files changed, 20 insertions(+)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index c2132b8..3e2e09d 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -57,6 +57,23 @@ static pm_message_t pm_transition;
 static int async_error;
 
 /**
+ * get_pm_transition - return pm_transition state.
+ * This interface is intended to be used from dev_pm_ops class and type
+ * suspend interfaces that call legacy pm ops driver suspend interfaces.
+ * Legacy suspend pm_ops take pm_message_t as a parameter.
+ * e.g: drm_class_suspend() calls into driver suspend routines
+ * via drm_dev->driver->suspend(drm_dev, state).
+ * Once drm_class_suspend() is converted to dev_pm_ops, it will no longer
+ * have access to pm_transition which it has to pass into driver legacy
+ * suspend calls. get_pm_transition() interface addresses this need.
+*/
+pm_message_t get_pm_transition()
+{
+	return pm_transition;
+}
+EXPORT_SYMBOL_GPL(get_pm_transition);
+
+/**
  * device_pm_sleep_init - Initialize system suspend-related device fields.
  * @dev: Device object being initialized.
  */
diff --git a/include/linux/pm.h b/include/linux/pm.h
index a224c7f..46f3252 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -63,6 +63,9 @@ typedef struct pm_message {
 	int event;
 } pm_message_t;
 
+/* drivers/base/power/main.c */
+extern pm_message_t get_pm_transition(void);
+
 /**
  * struct dev_pm_ops - device PM callbacks
  *
-- 
1.7.10.4

