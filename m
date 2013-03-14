Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627Ab3CNJrg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 05:47:36 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:15791 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755813Ab3CNJrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 05:47:35 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 14 Mar 2013 02:40:49 -0700
From: Bill Huang <bilhuang@nvidia.com>
To: <mturquette@linaro.org>, <patches@linaro.org>,
        <linux-kernel@vger.kernel.org>, <linaro-dev@lists.linaro.org>,
        <linux-arm-kernel@lists.infradead.org>
CC: Bill Huang <bilhuang@nvidia.com>
Subject: [RFC v3 1/1] clk: Add notifier support in clk_prepare/clk_unprepare
Date: Thu, 14 Mar 2013 02:51:49 -0700
Message-ID: <1363254709-9209-1-git-send-email-bilhuang@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the below two notifier events so drivers which are interested in
knowing the clock status can act accordingly. This is extremely useful
in some of the DVFS (Dynamic Voltage Frequency Scaling) design.

CLK_PREPARED
CLK_UNPREPARED

Signed-off-by: Bill Huang <bilhuang@nvidia.com>
---
 drivers/clk/clk.c   |   75 ++++++++++++++++++++++++++-------------------------
 include/linux/clk.h |    2 ++
 2 files changed, 41 insertions(+), 36 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index ed87b24..d78ed16 100644
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
@@ -550,6 +586,7 @@ void clk_unprepare(struct clk *clk)
 {
 	mutex_lock(&prepare_lock);
 	__clk_unprepare(clk);
+	__clk_notify(clk, CLK_UNPREPARED, clk->rate, clk->rate);
 	mutex_unlock(&prepare_lock);
 }
 EXPORT_SYMBOL_GPL(clk_unprepare);
@@ -598,6 +635,8 @@ int clk_prepare(struct clk *clk)
 
 	mutex_lock(&prepare_lock);
 	ret = __clk_prepare(clk);
+	if (!ret)
+		__clk_notify(clk, CLK_PREPARED, clk->rate, clk->rate);
 	mutex_unlock(&prepare_lock);
 
 	return ret;
@@ -749,42 +788,6 @@ long clk_round_rate(struct clk *clk, unsigned long rate)
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
index b3ac22d..16c1d92 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -43,6 +43,8 @@ struct clk;
 #define PRE_RATE_CHANGE			BIT(0)
 #define POST_RATE_CHANGE		BIT(1)
 #define ABORT_RATE_CHANGE		BIT(2)
+#define CLK_PREPARED			BIT(3)
+#define CLK_UNPREPARED			BIT(4)
 
 /**
  * struct clk_notifier - associate a clk with a notifier
-- 
1.7.9.5

