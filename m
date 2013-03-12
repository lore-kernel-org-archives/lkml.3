Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932623Ab3CLMQu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 08:16:50 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5168 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143Ab3CLMQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 08:16:49 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 12 Mar 2013 05:10:08 -0700
From: Bill Huang <bilhuang@nvidia.com>
To: <mturquette@linaro.org>, <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <patches@linaro.org>,
        <linaro-dev@lists.linaro.org>, Bill Huang <bilhuang@nvidia.com>
Subject: [RFC 1/1] clk: Add notifier support in clk_prepare_enable/clk_disable_unprepare
Date: Tue, 12 Mar 2013 05:37:41 -0700
Message-ID: <1363091861-21534-1-git-send-email-bilhuang@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the below four notifier events so drivers which are interested in
knowing the clock status can act accordingly. This is extremely useful
in some of the DVFS (Dynamic Voltage Frequency Scaling) design.

PRE_CLK_ENABLE
POST_CLK_ENABLE
PRE_CLK_DISABLE
POST_CLK_DISABLE

Signed-off-by: Bill Huang <bilhuang@nvidia.com>
---
 drivers/clk/clk.c   |   58 +++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/clk.h |   40 ++++++++++++++++++++---------------
 2 files changed, 81 insertions(+), 17 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index ed87b24..720a16a 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1104,6 +1104,64 @@ struct clk *clk_get_parent(struct clk *clk)
 }
 EXPORT_SYMBOL_GPL(clk_get_parent);
 
+/**
+ * clk_prepare_enable - call clk_enable in non-atomic context.
+ * @clk: the clk to enable
+ *
+ * Send PRE_CLK_ENABLE/POST_CLK_ENABLE before/after calling
+ * clk_enalbe respectively
+ *
+ * Return success (0) or errno.
+ */
+int clk_prepare_enable(struct clk *clk)
+{
+	int ret;
+
+	mutex_lock(&prepare_lock);
+	ret = __clk_prepare(clk);
+	if (ret)
+		return ret;
+
+	if (clk->notifier_count)
+		__clk_notify(clk, PRE_CLK_ENABLE, clk->rate, clk->rate);
+
+	ret = clk_enable(clk);
+	if (ret)
+		__clk_unprepare(clk);
+
+	if (clk->notifier_count)
+		__clk_notify(clk, POST_CLK_ENABLE, clk->rate, clk->rate);
+
+	mutex_unlock(&prepare_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(clk_prepare_enable);
+
+/**
+ * clk_disable_unprepare - call clk_disable in non-atomic context.
+ * @clk: the clk to enable
+ *
+ * Send PRE_CLK_DISABLE/POST_CLK_DISABLE before/after calling
+ * clk_disalbe respectively
+ */
+void clk_disable_unprepare(struct clk *clk)
+{
+	mutex_lock(&prepare_lock);
+
+	if (clk->notifier_count)
+		__clk_notify(clk, PRE_CLK_DISABLE, clk->rate, clk->rate);
+
+	clk_disable(clk);
+	__clk_unprepare(clk);
+
+	if (clk->notifier_count)
+		__clk_notify(clk, POST_CLK_DISABLE, clk->rate, clk->rate);
+
+	mutex_unlock(&prepare_lock);
+}
+EXPORT_SYMBOL_GPL(clk_disable_unprepare);
+
 /*
  * .get_parent is mandatory for clocks with multiple possible parents.  It is
  * optional for single-parent clocks.  Always call .get_parent if it is
diff --git a/include/linux/clk.h b/include/linux/clk.h
index b3ac22d..4bbe1903 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -43,6 +43,10 @@ struct clk;
 #define PRE_RATE_CHANGE			BIT(0)
 #define POST_RATE_CHANGE		BIT(1)
 #define ABORT_RATE_CHANGE		BIT(2)
+#define PRE_CLK_ENABLE			BIT(3)
+#define POST_CLK_ENABLE			BIT(4)
+#define PRE_CLK_DISABLE			BIT(5)
+#define POST_CLK_DISABLE		BIT(6)
 
 /**
  * struct clk_notifier - associate a clk with a notifier
@@ -276,6 +280,20 @@ struct clk *clk_get_parent(struct clk *clk);
  */
 struct clk *clk_get_sys(const char *dev_id, const char *con_id);
 
+/**
+ * clk_prepare_enable - helps cases using clk_enable in non-atomic context.
+ * @clk: clock source
+ *
+ * Return success (0) or nagative errno.
+ */
+int clk_prepare_enable(struct clk *clk);
+
+/**
+ * clk_disable_unprepare - helps cases using clk_disable in non-atomic context.
+ * @clk: clock source
+ */
+void clk_disable_unprepare(struct clk *clk);
+
 #else /* !CONFIG_HAVE_CLK */
 
 static inline struct clk *clk_get(struct device *dev, const char *id)
@@ -324,30 +342,18 @@ static inline struct clk *clk_get_parent(struct clk *clk)
 	return NULL;
 }
 
-#endif
-
-/* clk_prepare_enable helps cases using clk_enable in non-atomic context. */
 static inline int clk_prepare_enable(struct clk *clk)
 {
-	int ret;
-
-	ret = clk_prepare(clk);
-	if (ret)
-		return ret;
-	ret = clk_enable(clk);
-	if (ret)
-		clk_unprepare(clk);
-
-	return ret;
+	return 0;
 }
 
-/* clk_disable_unprepare helps cases using clk_disable in non-atomic context. */
-static inline void clk_disable_unprepare(struct clk *clk)
+static inline int clk_disable_unprepare(struct clk *clk)
 {
-	clk_disable(clk);
-	clk_unprepare(clk);
+	return 0;
 }
 
+#endif
+
 /**
  * clk_add_alias - add a new clock alias
  * @alias: name for clock alias
-- 
1.7.9.5

