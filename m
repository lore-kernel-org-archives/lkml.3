Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934511AbaE3UxR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 16:53:17 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:59509 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754460AbaE3UxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 16:53:15 -0400
From: Alex Elder <elder@linaro.org>
To: mturquette@linaro.org, mporter@linaro.org, bcm@fixthebug.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 4/7] clk: bcm281xx: implement prerequisite clocks
Date: Fri, 30 May 2014 15:53:05 -0500
Message-Id: <1401483188-5395-5-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401483188-5395-1-git-send-email-elder@linaro.org>
References: <1401483188-5395-1-git-send-email-elder@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow a clock to specify a "prerequisite" clock, identified by its
name.  The prerequisite clock must be prepared and enabled before a
clock that depends on it is used.  In order to simplify locking, we
require a clock and its prerequisite to be associated with the same
CCU.  (We'll just trust--but not verify--that nobody defines a cycle
of prerequisite clocks.)

Rework the KONA_CLK() macro, and define a new KONA_CLK_PREREQ()
variant that allows a prerequisite clock to be specified.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/clk/bcm/clk-kona-setup.c | 24 ++++++++++++
 drivers/clk/bcm/clk-kona.c       | 84 +++++++++++++++++++++++++++++++++++++++-
 drivers/clk/bcm/clk-kona.h       | 20 ++++++++--
 3 files changed, 123 insertions(+), 5 deletions(-)

diff --git a/drivers/clk/bcm/clk-kona-setup.c b/drivers/clk/bcm/clk-kona-setup.c
index 317f7dd..36a99b9 100644
--- a/drivers/clk/bcm/clk-kona-setup.c
+++ b/drivers/clk/bcm/clk-kona-setup.c
@@ -796,6 +796,28 @@ static bool ccu_data_valid(struct ccu_data *ccu)
 }
 
 /*
+ * If a clock specifies a prerequisite clock, they must both be on
+ * the same CCU.  Check if the named prerequisite clock matches one
+ * of the ones provided by CCU.  A null name means no prerequisite.
+ */
+static bool kona_prereq_valid(struct ccu_data *ccu, const char *prereq_name)
+{
+	unsigned int i;
+
+	if (!prereq_name)
+		return true;
+
+	for (i = 0; i < ccu->clk_data.clk_num; i++)
+		if (!strcmp(prereq_name, ccu->kona_clks[i].init_data.name))
+			return true;
+
+	pr_err("%s: prereq clock %s not defined for ccu %s\n", __func__,
+		prereq_name, ccu->name);
+
+	return false;
+}
+
+/*
  * Set up a CCU.  Call the provided ccu_clks_setup callback to
  * initialize the array of clocks provided by the CCU.
  */
@@ -857,6 +879,8 @@ void __init kona_dt_ccu_setup(struct ccu_data *ccu,
 	for (i = 0; i < ccu->clk_data.clk_num; i++) {
 		if (!ccu->kona_clks[i].ccu)
 			continue;
+		if (!kona_prereq_valid(ccu, ccu->kona_clks[i].prereq.name))
+			continue;
 		ccu->clk_data.clks[i] = kona_clk_setup(&ccu->kona_clks[i]);
 	}
 
diff --git a/drivers/clk/bcm/clk-kona.c b/drivers/clk/bcm/clk-kona.c
index 9a69a01..a6a45cd 100644
--- a/drivers/clk/bcm/clk-kona.c
+++ b/drivers/clk/bcm/clk-kona.c
@@ -1028,6 +1028,44 @@ static bool __peri_clk_init(struct kona_clk *bcm_clk)
 
 /* Clock operations */
 
+static int __kona_prereq_prepare_enable(struct kona_clk *bcm_clk)
+{
+	const char *clk_name = bcm_clk->init_data.name;
+	const char *prereq_name = bcm_clk->prereq.name;
+	struct clk *prereq_clk = bcm_clk->prereq.clk;
+	int ret;
+
+	BUG_ON(!clk_name);
+
+	/* Look up the prerequisite clock if we haven't already */
+	if (!prereq_clk) {
+		prereq_clk = __clk_lookup(prereq_name);
+		if (!prereq_clk) {
+			pr_err("%s: prereq clock %s for %s not found\n",
+				__func__, prereq_name, clk_name);
+			return -ENOENT;
+		}
+		bcm_clk->prereq.clk = prereq_clk;
+	}
+
+	ret = __clk_prepare(prereq_clk);
+	if (ret) {
+		pr_err("%s: unable to prepare prereq clock %s for %s\n",
+			__func__, prereq_name, clk_name);
+		return ret;
+	}
+
+	ret = clk_enable(prereq_clk);
+	if (ret) {
+		__clk_unprepare(prereq_clk);
+		pr_err("%s: unable to enable prereq clock %s for %s\n",
+			__func__, prereq_name, clk_name);
+		return ret;
+	}
+
+	return 0;
+}
+
 static int kona_clk_prepare(struct clk_hw *hw)
 {
 	struct kona_clk *bcm_clk = to_kona_clk(hw);
@@ -1038,6 +1076,13 @@ static int kona_clk_prepare(struct clk_hw *hw)
 	flags = ccu_lock(ccu);
 	__ccu_write_enable(ccu);
 
+	/* Prepare the prerequisite clock first */
+	if (bcm_clk->prereq.name) {
+		ret = __kona_prereq_prepare_enable(bcm_clk);
+		if (ret)
+			goto out;
+	}
+
 	switch (bcm_clk->type) {
 	case bcm_clk_peri:
 		if (!__peri_clk_init(bcm_clk))
@@ -1046,16 +1091,51 @@ static int kona_clk_prepare(struct clk_hw *hw)
 	default:
 		BUG();
 	}
-
+out:
 	__ccu_write_disable(ccu);
 	ccu_unlock(ccu, flags);
 
 	return ret;
 }
 
+/*
+ * Disable and unprepare a prerequisite clock, and drop our
+ * reference to it.
+ */
+static void __kona_prereq_disable_unprepare(struct kona_clk *bcm_clk)
+{
+	struct clk *prereq_clk = bcm_clk->prereq.clk;
+
+	BUG_ON(!bcm_clk->prereq.name);
+	WARN_ON_ONCE(!prereq_clk);
+
+	bcm_clk->prereq.clk = NULL;
+
+	clk_disable(prereq_clk);
+	__clk_unprepare(prereq_clk);
+}
+
 static void kona_clk_unprepare(struct clk_hw *hw)
 {
-	/* Nothing to do. */
+	struct kona_clk *bcm_clk = to_kona_clk(hw);
+	struct ccu_data *ccu;
+	unsigned long flags;
+
+	/*
+	 * We don't do anything to unprepare Kona clocks themselves,
+	 * but if there's a prerequisite we'll need to unprepare it.
+	 */
+	if (!bcm_clk->prereq.name)
+		return;
+
+	ccu = bcm_clk->ccu;
+	flags = ccu_lock(ccu);
+	__ccu_write_enable(ccu);
+
+	__kona_prereq_disable_unprepare(bcm_clk);
+
+	__ccu_write_disable(ccu);
+	ccu_unlock(ccu, flags);
 }
 
 static int kona_peri_clk_enable(struct clk_hw *hw)
diff --git a/drivers/clk/bcm/clk-kona.h b/drivers/clk/bcm/clk-kona.h
index 3409111..0a845a0 100644
--- a/drivers/clk/bcm/clk-kona.h
+++ b/drivers/clk/bcm/clk-kona.h
@@ -406,6 +406,10 @@ struct kona_clk {
 	struct clk_init_data init_data;	/* includes name of this clock */
 	struct ccu_data *ccu;	/* ccu this clock is associated with */
 	enum bcm_clk_type type;
+	struct {
+		const char *name;
+		struct clk *clk;
+	} prereq;
 	union {
 		void *data;
 		struct peri_clk_data *peri;
@@ -415,16 +419,26 @@ struct kona_clk {
 	container_of(_hw, struct kona_clk, hw)
 
 /* Initialization macro for an entry in a CCU's kona_clks[] array. */
-#define KONA_CLK(_ccu_name, _clk_name, _type)				\
-	{								\
+#define ___KONA_CLK_COMMON(_ccu_name, _clk_name, _type)			\
 		.init_data	= {					\
 			.name = #_clk_name,				\
 			.ops = &kona_ ## _type ## _clk_ops,		\
 		},							\
 		.ccu		= &_ccu_name ## _ccu_data,		\
 		.type		= bcm_clk_ ## _type,			\
-		.u.data		= &_clk_name ## _data,			\
+		.u.data		= &_clk_name ## _data
+
+#define KONA_CLK_PREREQ(_ccu_name, _clk_name, _type, _prereq)		\
+	{								\
+		.prereq.name	= #_prereq,				\
+		___KONA_CLK_COMMON(_ccu_name, _clk_name, _type),	\
 	}
+
+#define KONA_CLK(_ccu_name, _clk_name, _type)				\
+	{								\
+		___KONA_CLK_COMMON(_ccu_name, _clk_name, _type),	\
+	}
+
 #define LAST_KONA_CLK	{ .type = bcm_clk_none }
 
 /*
-- 
1.9.1

