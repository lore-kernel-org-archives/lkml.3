Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621AbaAJHAY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 02:00:24 -0500
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:34804 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaAJHAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 02:00:22 -0500
From: Chen-Yu Tsai <wens@csie.org>
To: Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc: Chen-Yu Tsai <wens@csie.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH v2 01/16] reset: add non CONFIG_RESET_CONTROLLER routines
Date: Fri, 10 Jan 2014 15:00:02 +0800
Message-Id: <1389337217-29032-2-git-send-email-wens@csie.org>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1389337217-29032-1-git-send-email-wens@csie.org>
References: <1389337217-29032-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some drivers are shared between platforms that may or may not
have RESET_CONTROLLER selected for them. Add dummy functions
when RESET_CONTROLLER is not selected, thereby eliminating the
need for drivers to enclose reset_control_*() calls within
#ifdef CONFIG_RESET_CONTROLLER, #endif

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 include/linux/reset.h | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/include/linux/reset.h b/include/linux/reset.h
index 6082247..38aa616 100644
--- a/include/linux/reset.h
+++ b/include/linux/reset.h
@@ -4,6 +4,8 @@
 struct device;
 struct reset_control;
 
+#ifdef CONFIG_RESET_CONTROLLER
+
 int reset_control_reset(struct reset_control *rstc);
 int reset_control_assert(struct reset_control *rstc);
 int reset_control_deassert(struct reset_control *rstc);
@@ -14,4 +16,41 @@ struct reset_control *devm_reset_control_get(struct device *dev, const char *id)
 
 int device_reset(struct device *dev);
 
+#else /* !CONFIG_RESET_CONTROLLER */
+
+static inline int reset_control_reset(struct reset_control *rstc)
+{
+	return 0;
+}
+
+static inline int reset_control_assert(struct reset_control *rstc)
+{
+	return 0;
+}
+
+static inline int reset_control_deassert(struct reset_control *rstc)
+{
+	return 0;
+}
+
+static inline struct reset_control *reset_control_get(struct device *dev,
+		const char *id)
+{
+	return NULL;
+}
+static inline void reset_control_put(struct reset_control *rstc) {}
+
+static inline struct reset_control *devm_reset_control_get(struct device *dev,
+		const char *id)
+{
+	return NULL;
+}
+
+static inline int device_reset(struct device *dev)
+{
+	return 0;
+}
+
+#endif
+
 #endif
-- 
1.8.5.2

