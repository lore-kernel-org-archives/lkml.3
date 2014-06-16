Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758AbaFPNj5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 09:39:57 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:41176 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbaFPNjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 09:39:54 -0400
From: Alex Elder <elder@linaro.org>
To: mturquette@linaro.org, mporter@linaro.org, bcm@fixthebug.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 4/7] clk: bcm281xx: implement prerequisite clocks
Date: Mon, 16 Jun 2014 08:40:04 -0500
Message-Id: <1402926007-4436-5-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402926007-4436-1-git-send-email-elder@linaro.org>
References: <1402926007-4436-1-git-send-email-elder@linaro.org>
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
 drivers/clk/bcm/clk-kona.c | 70 ++++++++++++++++++++++++++++++++++++++++++++--
 drivers/clk/bcm/clk-kona.h | 20 +++++++++++--
 2 files changed, 85 insertions(+), 5 deletions(-)

diff --git a/drivers/clk/bcm/clk-kona.c b/drivers/clk/bcm/clk-kona.c
index 2e27924..51b4edb 100644
--- a/drivers/clk/bcm/clk-kona.c
+++ b/drivers/clk/bcm/clk-kona.c
@@ -1037,6 +1037,42 @@ static bool __peri_clk_init(struct kona_clk *bcm_clk)
 
 /* Clock operations */
 
+static int kona_prereq_prepare_enable(struct kona_clk *bcm_clk)
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
+		if (WARN_ON_ONCE(!prereq_clk))
+			return -ENOENT;
+		bcm_clk->prereq.clk = prereq_clk;
+	}
+
+	/* Dependent clock already holds the prepare lock */
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
@@ -1044,6 +1080,13 @@ static int kona_clk_prepare(struct clk_hw *hw)
 	unsigned long flags;
 	int ret = 0;
 
+	/* Prepare the prerequisite clock first */
+	if (bcm_clk->prereq.name) {
+		ret = kona_prereq_prepare_enable(bcm_clk);
+		if (ret)
+			goto out;
+	}
+
 	if (clk_is_initialized(bcm_clk))
 		return 0;
 
@@ -1062,19 +1105,42 @@ static int kona_clk_prepare(struct clk_hw *hw)
 
 	__ccu_write_disable(ccu);
 	ccu_unlock(ccu, flags);
-
+out:
 	if (!ret)
 		clk_set_initialized(bcm_clk);
 
 	return ret;
 }
 
+/*
+ * Disable and unprepare a prerequisite clock, and drop our
+ * reference to it.
+ */
+static void kona_prereq_disable_unprepare(struct kona_clk *bcm_clk)
+{
+	struct clk *prereq_clk = bcm_clk->prereq.clk;
+
+	BUG_ON(!bcm_clk->prereq.name);
+	WARN_ON_ONCE(!prereq_clk);
+
+	clk_disable(prereq_clk);
+	__clk_unprepare(prereq_clk);
+}
+
 static void kona_clk_unprepare(struct clk_hw *hw)
 {
 	struct kona_clk *bcm_clk = to_kona_clk(hw);
 
 	WARN_ON(!clk_is_initialized(bcm_clk));
-	/* Nothing to do. */
+
+	/*
+	 * We don't do anything to unprepare Kona clocks themselves,
+	 * but if there's a prerequisite we'll need to unprepare it.
+	 */
+	if (!bcm_clk->prereq.name)
+		return;
+
+	kona_prereq_disable_unprepare(bcm_clk);
 }
 
 static int kona_peri_clk_enable(struct clk_hw *hw)
diff --git a/drivers/clk/bcm/clk-kona.h b/drivers/clk/bcm/clk-kona.h
index ea77ec1..98b6fa1 100644
--- a/drivers/clk/bcm/clk-kona.h
+++ b/drivers/clk/bcm/clk-kona.h
@@ -407,6 +407,10 @@ struct kona_clk {
 	struct ccu_data *ccu;	/* ccu this clock is associated with */
 	enum bcm_clk_type type;
 	u32 flags;		/* BCM_CLK_KONA_FLAGS_* below */
+	struct {
+		const char *name;
+		struct clk *clk;
+	} prereq;
 	union {
 		void *data;
 		struct peri_clk_data *peri;
@@ -422,16 +426,26 @@ struct kona_clk {
 #define BCM_CLK_KONA_FLAGS_INITIALIZED	((u32)1 << 0)	/* Clock initialized */
 
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

