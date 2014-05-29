Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530AbaE2OHD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 10:07:03 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:57697 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965128AbaE2OGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 10:06:07 -0400
From: Alex Elder <elder@linaro.org>
To: mturquette@linaro.org, mporter@linaro.org, bcm@fixthebug.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/5] clk: bcm281xx: implement prerequisite clocks
Date: Thu, 29 May 2014 09:05:58 -0500
Message-Id: <1401372361-18842-3-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401372361-18842-1-git-send-email-elder@linaro.org>
References: <1401372361-18842-1-git-send-email-elder@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow a clock to specify a "prerequisite" clock.  The prerequisite
clock must be initialized before the clock that depends on it.  A
prerequisite clock is defined initially by its name; as that clock
gets initialized the name gets replaced with a pointer to its clock
structure pointer.

Rework the KONA_CLK() macro, and define a new KONA_CLK_PREREQ()
variant that allows a prerequisite clock to be specified.

There exist clocks that could specify more than one prequisite, but
almost all clocks only ever use one.  We can add support for more
than one if we find we need it at some point.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/clk/bcm/clk-kona.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/clk/bcm/clk-kona.h | 19 ++++++++++++++++---
 2 files changed, 61 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/bcm/clk-kona.c b/drivers/clk/bcm/clk-kona.c
index 9691b62..d08b3e9 100644
--- a/drivers/clk/bcm/clk-kona.c
+++ b/drivers/clk/bcm/clk-kona.c
@@ -1247,6 +1247,48 @@ static bool __peri_clk_init(struct kona_clk *bcm_clk)
 	return true;
 }
 
+static bool __kona_clk_init(struct kona_clk *bcm_clk);
+static bool __kona_prereq_init(struct kona_clk *bcm_clk)
+{
+	struct clk *clk;
+	struct clk_hw *hw;
+	struct kona_clk *prereq;
+
+	BUG_ON(clk_is_initialized(bcm_clk));
+
+	if (!bcm_clk->p.prereq)
+		return true;
+
+	clk = clk_get(NULL, bcm_clk->p.prereq);
+	if (IS_ERR(clk)) {
+		pr_err("%s: unable to get prereq clock %s for %s\n",
+			__func__, bcm_clk->p.prereq, bcm_clk->init_data.name);
+		return false;
+	}
+	hw = __clk_get_hw(clk);
+	if (!hw) {
+		pr_err("%s: null hw pointer for clock %s\n", __func__,
+			bcm_clk->init_data.name);
+		return false;
+	}
+	prereq = to_kona_clk(hw);
+	if (prereq->ccu != bcm_clk->ccu) {
+		pr_err("%s: prereq clock %s CCU different for clock %s\n",
+			__func__, bcm_clk->p.prereq, bcm_clk->init_data.name);
+		return false;
+	}
+
+	/* Initialize the prerequisite clock first */
+	if (!__kona_clk_init(prereq)) {
+		pr_err("%s: failed to init prereq %s for clock %s\n",
+			__func__, bcm_clk->p.prereq, bcm_clk->init_data.name);
+		return false;
+	}
+	bcm_clk->p.prereq_clk = clk;
+
+	return true;
+}
+
 static bool __kona_clk_init(struct kona_clk *bcm_clk)
 {
 	bool ret;
@@ -1254,6 +1296,9 @@ static bool __kona_clk_init(struct kona_clk *bcm_clk)
 	if (clk_is_initialized(bcm_clk))
 		return true;
 
+	if (!__kona_prereq_init(bcm_clk))
+		return false;
+
 	switch (bcm_clk->type) {
 	case bcm_clk_peri:
 		ret = __peri_clk_init(bcm_clk);
diff --git a/drivers/clk/bcm/clk-kona.h b/drivers/clk/bcm/clk-kona.h
index 10e238d..be00767 100644
--- a/drivers/clk/bcm/clk-kona.h
+++ b/drivers/clk/bcm/clk-kona.h
@@ -22,6 +22,8 @@
 #include <linux/device.h>
 #include <linux/of.h>
 #include <linux/clk-provider.h>
+#include <linux/clkdev.h>
+#include <linux/debugfs.h>
 
 #define	BILLION		1000000000
 
@@ -408,6 +410,10 @@ struct kona_clk {
 	enum bcm_clk_type type;
 	u32 flags;		/* BCM_CLK_KONA_FLAGS_* below */
 	union {
+		const char *prereq;
+		struct clk *prereq_clk;
+	} p;
+	union {
 		void *data;
 		struct peri_clk_data *peri;
 	} u;
@@ -422,15 +428,22 @@ struct kona_clk {
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
+#define KONA_CLK_PREREQ(_ccu_name, _clk_name, _type, _prereq)		\
+	{								\
+		.p.prereq	= #_prereq,				\
+		___KONA_CLK_COMMON(_ccu_name, _clk_name, _type),	\
+	}
+#define KONA_CLK(_ccu_name, _clk_name, _type)				\
+	{								\
+		___KONA_CLK_COMMON(_ccu_name, _clk_name, _type),	\
 	}
 #define LAST_KONA_CLK	{ .type = bcm_clk_none }
 
-- 
1.9.1

