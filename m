Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbaCGOaf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 09:30:35 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33105 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801AbaCGOae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 09:30:34 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Chen-Yu Tsai <wens@csie.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Barry Song <Baohua.Song@csr.com>,
        Stephen Warren <swarren@wwwdotorg.org>, Pavel Machek <pavel@ucw.cz>,
        Shawn Guo <shawn.guo@linaro.org>, Marek Vasut <marex@denx.de>,
        Stephen Warren <swarren@nvidia.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] reset: Add optional resets and stubs
Date: Fri,  7 Mar 2014 15:30:23 +0100
Message-Id: <1394202623-20229-1-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 1.9.0
X-SA-Exim-Connect-IP: 10.1.0.120
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device_reset_optional and (devm_)reset_control_get_optional
variants that drivers can use to indicate they can function without control
over the reset line. For those functions, stubs are added so the drivers can
be compiled with CONFIG_RESET_CONTROLLER disabled.
Also, device_reset is annotated with __must_check. Drivers ignoring the return
value should use device_reset_optional instead.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 include/linux/reset.h | 71 ++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 64 insertions(+), 7 deletions(-)

diff --git a/include/linux/reset.h b/include/linux/reset.h
index 10c44ab..c0eda50 100644
--- a/include/linux/reset.h
+++ b/include/linux/reset.h
@@ -1,23 +1,80 @@
 #ifndef _LINUX_RESET_H_
 #define _LINUX_RESET_H_
 
-#include <linux/of.h>
-
 struct device;
 struct reset_control;
 
+#ifdef CONFIG_RESET_CONTROLLER
+
 int reset_control_reset(struct reset_control *rstc);
-int reset_control_reset_udelay(struct reset_control *rstc, unsigned long usecs);
-int reset_control_reset_msleep(struct reset_control *rstc, unsigned long msecs);
 int reset_control_assert(struct reset_control *rstc);
 int reset_control_deassert(struct reset_control *rstc);
 
-struct reset_control *of_reset_control_get(struct device_node *node,
-					   const char *id);
 struct reset_control *reset_control_get(struct device *dev, const char *id);
 void reset_control_put(struct reset_control *rstc);
 struct reset_control *devm_reset_control_get(struct device *dev, const char *id);
 
-int device_reset(struct device *dev);
+int __must_check device_reset(struct device *dev);
+
+static inline int device_reset_optional(struct device *dev)
+{
+	return device_reset(dev);
+}
+
+static inline struct reset_control *reset_control_get_optional(
+					struct device *dev, const char *id)
+{
+	return reset_control_get(dev, id);
+}
+
+static inline struct reset_control *devm_reset_control_get_optional(
+					struct device *dev, const char *id)
+{
+	return devm_reset_control_get(dev, id);
+}
+
+#else
+
+static inline int reset_control_reset(struct reset_control *rstc)
+{
+	WARN_ON(1);
+	return 0;
+}
+
+static inline int reset_control_assert(struct reset_control *rstc)
+{
+	WARN_ON(1);
+	return 0;
+}
+
+static inline int reset_control_deassert(struct reset_control *rstc)
+{
+	WARN_ON(1);
+	return 0;
+}
+
+static inline void reset_control_put(struct reset_control *rstc)
+{
+	WARN_ON(1);
+}
+
+static inline int device_reset_optional(struct device *dev)
+{
+	return -ENOSYS;
+}
+
+static inline struct reset_control *reset_control_get_optional(
+					struct device *dev, const char *id)
+{
+	return ERR_PTR(-ENOSYS);
+}
+
+static inline struct reset_control *devm_reset_control_get_optional(
+					struct device *dev, const char *id)
+{
+	return ERR_PTR(-ENOSYS);
+}
+
+#endif /* CONFIG_RESET_CONTROLLER */
 
 #endif
-- 
1.9.0

