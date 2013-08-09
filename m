Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030733Ab3HISvv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 14:51:51 -0400
Received: from nbd.name ([46.4.11.11]:33055 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030353Ab3HISvt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 14:51:49 -0400
From: John Crispin <blogic@openwrt.org>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: John Crispin <blogic@openwrt.org>, linux-kernel@vger.kernel.org,
        Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH] reset: Fix compile when reset RESET_CONTROLLER is not selected
Date: Fri,  9 Aug 2013 20:44:37 +0200
Message-Id: <1376073877-28988-1-git-send-email-blogic@openwrt.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drivers need to protect their reset api calls with #ifdef to avoid compile
errors. This patch adds dummy wrappers in the same way that linux/of.h does
it. This results in the nasty ifdefs no longer being needed.

Cc: linux-kernel@vger.kernel.org
Cc: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Gabor Juhos <juhosg@openwrt.org>
---
 include/linux/reset-controller.h |   16 ++++++++++++++
 include/linux/reset.h            |   43 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+)

diff --git a/include/linux/reset-controller.h b/include/linux/reset-controller.h
index 2f61311..068f073 100644
--- a/include/linux/reset-controller.h
+++ b/include/linux/reset-controller.h
@@ -45,7 +45,23 @@ struct reset_controller_dev {
 	unsigned int nr_resets;
 };
 
+#if defined(CONFIG_RESET_CONTROLLER)
+
 int reset_controller_register(struct reset_controller_dev *rcdev);
 void reset_controller_unregister(struct reset_controller_dev *rcdev);
 
+#else
+
+static inline int reset_controller_register(struct reset_controller_dev *rcdev)
+{
+	return -ENOSYS;
+}
+
+void reset_controller_unregister(struct reset_controller_dev *rcdev)
+{
+
+}
+
+#endif
+
 #endif
diff --git a/include/linux/reset.h b/include/linux/reset.h
index 6082247..1b36c9e 100644
--- a/include/linux/reset.h
+++ b/include/linux/reset.h
@@ -1,9 +1,13 @@
 #ifndef _LINUX_RESET_H_
 #define _LINUX_RESET_H_
 
+#include <linux/err.h>
+
 struct device;
 struct reset_control;
 
+#if defined(CONFIG_RESET_CONTROLLER)
+
 int reset_control_reset(struct reset_control *rstc);
 int reset_control_assert(struct reset_control *rstc);
 int reset_control_deassert(struct reset_control *rstc);
@@ -14,4 +18,43 @@ struct reset_control *devm_reset_control_get(struct device *dev, const char *id)
 
 int device_reset(struct device *dev);
 
+#else /* CONFIG_RESET_CONTROLLER */
+
+static inline int reset_control_reset(struct reset_control *rstc)
+{
+	return -ENOSYS;
+}
+
+static inline int reset_control_assert(struct reset_control *rstc)
+{
+	return -ENOSYS;
+}
+
+static inline int reset_control_deassert(struct reset_control *rstc)
+{
+	return -ENOSYS;
+}
+
+static inline struct reset_control *reset_control_get(struct device *dev, const char *id)
+{
+	return ERR_PTR(-ENOSYS);
+}
+
+static inline void reset_control_put(struct reset_control *rstc)
+{
+
+}
+
+static inline struct reset_control *devm_reset_control_get(struct device *dev, const char *id)
+{
+	return ERR_PTR(-ENOSYS);
+}
+
+static inline int device_reset(struct device *dev)
+{
+	return -ENOSYS;
+}
+
+#endif
+
 #endif
-- 
1.7.10.4

