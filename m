Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932725AbaEEN5o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 09:57:44 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:65384 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932697AbaEEN5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 09:57:42 -0400
From: Alex Elder <elder@linaro.org>
To: mturquette@linaro.org, mporter@linaro.org, bcm@fixthebug.org,
        devicetree@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] clk: bcm281xx: implement prerequisite clocks
Date: Mon,  5 May 2014 08:57:33 -0500
Message-Id: <1399298256-10965-3-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399298256-10965-1-git-send-email-elder@linaro.org>
References: <1399298256-10965-1-git-send-email-elder@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow a clock to specify a "prerequisite" clock.  The prerequisite
clock must be initialized before the clock that depends on it.  A
prerequisite clock is defined initially by its name; as that clock
gets initialized the name gets replaced with a pointer to its clock
structure pointer.  In order to allow getting a reference to a clock
by its name we call clkdev_add() for each clock as it gets set up.
A new clk_lookup structure is added to the kona_clk type for this
purpose.

Rework the KONA_CLK() macro, and define a new KONA_CLK_PREREQ()
variant that allows a prerequisite clock to be specified.

There exist clocks that could specify more than one prequisite, but
almost all clocks only ever use one.  We can add support for more
than one if we find we need it at some point.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/clk/bcm/clk-kona-setup.c | 16 ++++++++++----
 drivers/clk/bcm/clk-kona.c       | 45 ++++++++++++++++++++++++++++++++++++++++
 drivers/clk/bcm/clk-kona.h       | 20 +++++++++++++++---
 3 files changed, 74 insertions(+), 7 deletions(-)

diff --git a/drivers/clk/bcm/clk-kona-setup.c b/drivers/clk/bcm/clk-kona-setup.c
index e5aeded..fcce22c 100644
--- a/drivers/clk/bcm/clk-kona-setup.c
+++ b/drivers/clk/bcm/clk-kona-setup.c
@@ -686,6 +686,9 @@ peri_clk_setup(struct peri_clk_data *data, struct clk_init_data *init_data)
 
 static void bcm_clk_teardown(struct kona_clk *bcm_clk)
 {
+	/* There is no function defined for this (yet) */
+	/* clkdev_remove(&bcm_clk->cl); */
+
 	switch (bcm_clk->type) {
 	case bcm_clk_peri:
 		peri_clk_teardown(bcm_clk->u.data, &bcm_clk->init_data);
@@ -719,6 +722,7 @@ static void kona_clk_teardown(struct clk *clk)
 struct clk *kona_clk_setup(struct kona_clk *bcm_clk)
 {
 	struct clk_init_data *init_data = &bcm_clk->init_data;
+	const char *name = init_data->name;
 	struct clk *clk = NULL;
 
 	switch (bcm_clk->type) {
@@ -728,14 +732,13 @@ struct clk *kona_clk_setup(struct kona_clk *bcm_clk)
 		break;
 	default:
 		pr_err("%s: clock type %d invalid for %s\n", __func__,
-			(int)bcm_clk->type, init_data->name);
+			(int)bcm_clk->type, name);
 		return NULL;
 	}
 
 	/* Make sure everything makes sense before we set it up */
 	if (!kona_clk_valid(bcm_clk)) {
-		pr_err("%s: clock data invalid for %s\n", __func__,
-			init_data->name);
+		pr_err("%s: clock data invalid for %s\n", __func__, name);
 		goto out_teardown;
 	}
 
@@ -743,11 +746,16 @@ struct clk *kona_clk_setup(struct kona_clk *bcm_clk)
 	clk = clk_register(NULL, &bcm_clk->hw);
 	if (IS_ERR(clk)) {
 		pr_err("%s: error registering clock %s (%ld)\n", __func__,
-			init_data->name, PTR_ERR(clk));
+			name, PTR_ERR(clk));
 		goto out_teardown;
 	}
 	BUG_ON(!clk);
 
+	/*  Make it so we can look the clock up using clk_find() */
+	bcm_clk->cl.con_id = name;
+	bcm_clk->cl.clk = clk;
+	clkdev_add(&bcm_clk->cl);
+
 	return clk;
 out_teardown:
 	bcm_clk_teardown(bcm_clk);
diff --git a/drivers/clk/bcm/clk-kona.c b/drivers/clk/bcm/clk-kona.c
index d8a7f38..de8047d 100644
--- a/drivers/clk/bcm/clk-kona.c
+++ b/drivers/clk/bcm/clk-kona.c
@@ -1195,6 +1195,48 @@ static bool __peri_clk_init(struct kona_clk *bcm_clk)
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
+	if (!bcm_clk->prereq)
+		return true;
+
+	clk = clk_get(NULL, bcm_clk->prereq);
+	if (IS_ERR(clk)) {
+		pr_err("%s: unable to get prereq clock %s for %s\n",
+			__func__, bcm_clk->prereq, bcm_clk->init_data.name);
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
+			__func__, bcm_clk->prereq, bcm_clk->init_data.name);
+		return false;
+	}
+
+	/* Initialize the prerequisite clock first */
+	if (!__kona_clk_init(prereq)) {
+		pr_err("%s: failed to init prereq %s for clock %s\n",
+			__func__, bcm_clk->prereq, bcm_clk->init_data.name);
+		return false;
+	}
+	bcm_clk->prereq_clk = clk;
+
+	return true;
+}
+
 static bool __kona_clk_init(struct kona_clk *bcm_clk)
 {
 	bool ret;
@@ -1202,6 +1244,9 @@ static bool __kona_clk_init(struct kona_clk *bcm_clk)
 	if (clk_is_initialized(bcm_clk))
 		return true;
 
+	if (!__kona_prereq_init(bcm_clk))
+		return false;
+
 	switch (bcm_clk->type) {
 	case bcm_clk_peri:
 		ret = __peri_clk_init(bcm_clk);
diff --git a/drivers/clk/bcm/clk-kona.h b/drivers/clk/bcm/clk-kona.h
index 10e238d..beac016 100644
--- a/drivers/clk/bcm/clk-kona.h
+++ b/drivers/clk/bcm/clk-kona.h
@@ -22,6 +22,8 @@
 #include <linux/device.h>
 #include <linux/of.h>
 #include <linux/clk-provider.h>
+#include <linux/clkdev.h>
+#include <linux/debugfs.h>
 
 #define	BILLION		1000000000
 
@@ -407,6 +409,11 @@ struct kona_clk {
 	struct ccu_data *ccu;	/* ccu this clock is associated with */
 	enum bcm_clk_type type;
 	u32 flags;		/* BCM_CLK_KONA_FLAGS_* below */
+	struct clk_lookup cl;
+	union {
+		const char *prereq;
+		struct clk *prereq_clk;
+	};
 	union {
 		void *data;
 		struct peri_clk_data *peri;
@@ -422,15 +429,22 @@ struct kona_clk {
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
+		.prereq		= #_prereq,				\
+		___KONA_CLK_COMMON(_ccu_name, _clk_name, _type),	\
+	}
+#define KONA_CLK(_ccu_name, _clk_name, _type)				\
+	{								\
+		___KONA_CLK_COMMON(_ccu_name, _clk_name, _type),	\
 	}
 #define LAST_KONA_CLK	{ .type = bcm_clk_none }
 
-- 
1.9.1

