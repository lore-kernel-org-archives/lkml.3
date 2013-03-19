Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902Ab3CSNbi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 09:31:38 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:4592 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755610Ab3CSNbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 09:31:37 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 19 Mar 2013 06:31:22 -0700
From: Bill Huang <bilhuang@nvidia.com>
To: <mturquette@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <patches@linaro.org>, <linaro-dev@lists.linaro.org>,
        Bill Huang <bilhuang@nvidia.com>
Subject: [PATCH 1/1] clk: Add notifier support in clk_prepare/clk_unprepare
Date: Tue, 19 Mar 2013 06:28:32 -0700
Message-ID: <1363699712-8124-1-git-send-email-bilhuang@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add notifier calls in clk_prepare and clk_unprepare so drivers which are
interested in knowing that clk_prepare/unprepare call can act accordingly.

The existing "clk_set_rate" notifier is not enough for normal DVFS
inplementation since clock might be enabled/disabled at runtime. Adding
these notifiers is useful on DVFS core which take clk_prepare as a hint
on that the notified clock might be enabled later so it can raise voltage
to a safe level before enabling the clock, and take clk_unprepare as a
hint that the clock has been disabled and is safe to lower the voltage.

The added notifier events are:

PRE_CLK_PREPARE
POST_CLK_PREPARE
ABORT_CLK_PREPARE
PRE_CLK_UNPREPARE
POST_CLK_UNPREPARE

Signed-off-by: Bill Huang <bilhuang@nvidia.com>
---
 drivers/clk/clk.c   |   88 ++++++++++++++++++++++++++++++---------------------
 include/linux/clk.h |    5 +++
 2 files changed, 57 insertions(+), 36 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index ed87b24..ac07c6e 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -516,6 +516,42 @@ struct clk *__clk_lookup(const char *name)
 
 /***        clk api        ***/
 
+/**
+ * __clk_notify - call clk notifier chain
+ * @clk: struct clk * that is changing rate
+ * @msg: clk notifier type (see include/linux/clk.h)
+ * @old_rate: old clk rate
+ * @new_rate: new clk rate
+ *
+ * Triggers a notifier call chain on the clk rate-change notification
+ * for 'clk'.  Passes a pointer to the struct clk and the previous
+ * and current rates to the notifier callback.  Intended to be called by
+ * internal clock code only.  Returns NOTIFY_DONE from the last driver
+ * called if all went well, or NOTIFY_STOP or NOTIFY_BAD immediately if
+ * a driver returns that.
+ */
+static int __clk_notify(struct clk *clk, unsigned long msg,
+		unsigned long old_rate, unsigned long new_rate)
+{
+	struct clk_notifier *cn;
+	struct clk_notifier_data cnd;
+	int ret = NOTIFY_DONE;
+
+	cnd.clk = clk;
+	cnd.old_rate = old_rate;
+	cnd.new_rate = new_rate;
+
+	list_for_each_entry(cn, &clk_notifier_list, node) {
+		if (cn->clk == clk) {
+			ret = srcu_notifier_call_chain(&cn->notifier_head, msg,
+					&cnd);
+			break;
+		}
+	}
+
+	return ret;
+}
+
 void __clk_unprepare(struct clk *clk)
 {
 	if (!clk)
@@ -549,7 +585,14 @@ void __clk_unprepare(struct clk *clk)
 void clk_unprepare(struct clk *clk)
 {
 	mutex_lock(&prepare_lock);
+
+	if (clk->notifier_count)
+		__clk_notify(clk, PRE_CLK_UNPREPARE, clk->rate, clk->rate);
+
 	__clk_unprepare(clk);
+	if (clk->notifier_count)
+		__clk_notify(clk, POST_CLK_UNPREPARE, clk->rate, clk->rate);
+
 	mutex_unlock(&prepare_lock);
 }
 EXPORT_SYMBOL_GPL(clk_unprepare);
@@ -597,7 +640,16 @@ int clk_prepare(struct clk *clk)
 	int ret;
 
 	mutex_lock(&prepare_lock);
+
+	if (clk->notifier_count)
+		__clk_notify(clk, PRE_CLK_PREPARE, clk->rate, clk->rate);
+
 	ret = __clk_prepare(clk);
+	if (!ret && clk->notifier_count)
+		__clk_notify(clk, POST_CLK_PREPARE, clk->rate, clk->rate);
+	else if (clk->notifier_count)
+		__clk_notify(clk, ABORT_CLK_PREPARE, clk->rate, clk->rate);
+
 	mutex_unlock(&prepare_lock);
 
 	return ret;
@@ -749,42 +801,6 @@ long clk_round_rate(struct clk *clk, unsigned long rate)
 EXPORT_SYMBOL_GPL(clk_round_rate);
 
 /**
- * __clk_notify - call clk notifier chain
- * @clk: struct clk * that is changing rate
- * @msg: clk notifier type (see include/linux/clk.h)
- * @old_rate: old clk rate
- * @new_rate: new clk rate
- *
- * Triggers a notifier call chain on the clk rate-change notification
- * for 'clk'.  Passes a pointer to the struct clk and the previous
- * and current rates to the notifier callback.  Intended to be called by
- * internal clock code only.  Returns NOTIFY_DONE from the last driver
- * called if all went well, or NOTIFY_STOP or NOTIFY_BAD immediately if
- * a driver returns that.
- */
-static int __clk_notify(struct clk *clk, unsigned long msg,
-		unsigned long old_rate, unsigned long new_rate)
-{
-	struct clk_notifier *cn;
-	struct clk_notifier_data cnd;
-	int ret = NOTIFY_DONE;
-
-	cnd.clk = clk;
-	cnd.old_rate = old_rate;
-	cnd.new_rate = new_rate;
-
-	list_for_each_entry(cn, &clk_notifier_list, node) {
-		if (cn->clk == clk) {
-			ret = srcu_notifier_call_chain(&cn->notifier_head, msg,
-					&cnd);
-			break;
-		}
-	}
-
-	return ret;
-}
-
-/**
  * __clk_recalc_rates
  * @clk: first clk in the subtree
  * @msg: notification type (see include/linux/clk.h)
diff --git a/include/linux/clk.h b/include/linux/clk.h
index b3ac22d..41d567d 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -43,6 +43,11 @@ struct clk;
 #define PRE_RATE_CHANGE			BIT(0)
 #define POST_RATE_CHANGE		BIT(1)
 #define ABORT_RATE_CHANGE		BIT(2)
+#define PRE_CLK_PREPARE			BIT(3)
+#define POST_CLK_PREPARE		BIT(4)
+#define ABORT_CLK_PREPARE		BIT(5)
+#define PRE_CLK_UNPREPARE		BIT(6)
+#define POST_CLK_UNPREPARE		BIT(7)
 
 /**
  * struct clk_notifier - associate a clk with a notifier
-- 
1.7.9.5

