Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757515AbaDBCGb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 22:06:31 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:42792 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757429AbaDBCEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 22:04:38 -0400
From: Alex Elder <elder@linaro.org>
To: mturquette@linaro.org, bcm@fixthebug.org, mporter@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 5/7] clk: bcm281xx: define CCU clock data statically
Date: Tue,  1 Apr 2014 21:04:53 -0500
Message-Id: <1396404296-9390-6-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1396404296-9390-1-git-send-email-elder@linaro.org>
References: <1396404296-9390-1-git-send-email-elder@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than "manually" setting up each CCU's clock entries at run
time, define a flexible array of generic Kona clock structures
within the CCU structure itself.  Each of these entries contains
generic kona clock information (like its CCU pointer and clock
framework initialization data).  Each also has a pointer to a
structure contianing clock type-dependent initialization data
(like register definitions).

Since we'll iterate over these arrays we need to be sure they have
slots for all potential clock index values.  (E.g. for the root CCU
we must have at least BCM281XX_ROOT_CCU_CLOCK_COUNT slots.)  To
ensure this we always define an extra entry and fill it using the
special initializer LAST_KONA_CLK.

Just about everything we need to know about a clock can be defined
statically.  As a result, kona_clk_setup() can be changed to take
just a kona_clk structure as its argument, and peri_clk_setup() can
be simplified.  With the information pre-defined we are also able
to handle most clock setup genericially.  We can do away with the
CCU-specific callback functions that previously were needed to set
up the entries in CCU's clock array.

Move the definition of the ccu_data structure down in "clk-kona.h"
to avoid a forward dependency.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/clk/bcm/clk-bcm281xx.c   |  132 ++++++++++++++++++--------------------
 drivers/clk/bcm/clk-kona-setup.c |   60 ++++++++---------
 drivers/clk/bcm/clk-kona.h       |   86 +++++++++++++------------
 3 files changed, 134 insertions(+), 144 deletions(-)

diff --git a/drivers/clk/bcm/clk-bcm281xx.c b/drivers/clk/bcm/clk-bcm281xx.c
index d72f2ae..71a65a4 100644
--- a/drivers/clk/bcm/clk-bcm281xx.c
+++ b/drivers/clk/bcm/clk-bcm281xx.c
@@ -41,6 +41,11 @@ static struct peri_clk_data frac_1m_data = {
 
 static struct ccu_data root_ccu_data = {
 	BCM281XX_CCU_COMMON(root, ROOT),
+	.kona_clks	= {
+		[BCM281XX_ROOT_CCU_FRAC_1M] =
+			KONA_CLK(root, frac_1m, peri),
+		[BCM281XX_ROOT_CCU_CLOCK_COUNT] = LAST_KONA_CLK,
+	},
 };
 
 /* AON CCU */
@@ -74,6 +79,15 @@ static struct peri_clk_data pmu_bsc_var_data = {
 
 static struct ccu_data aon_ccu_data = {
 	BCM281XX_CCU_COMMON(aon, AON),
+	.kona_clks	= {
+		[BCM281XX_AON_CCU_HUB_TIMER] =
+			KONA_CLK(aon, hub_timer, peri),
+		[BCM281XX_AON_CCU_PMU_BSC] =
+			KONA_CLK(aon, pmu_bsc, peri),
+		[BCM281XX_AON_CCU_PMU_BSC_VAR] =
+			KONA_CLK(aon, pmu_bsc_var, peri),
+		[BCM281XX_AON_CCU_CLOCK_COUNT] = LAST_KONA_CLK,
+	},
 };
 
 /* Hub CCU */
@@ -88,6 +102,11 @@ static struct peri_clk_data tmon_1m_data = {
 
 static struct ccu_data hub_ccu_data = {
 	BCM281XX_CCU_COMMON(hub, HUB),
+	.kona_clks	= {
+		[BCM281XX_HUB_CCU_TMON_1M] =
+			KONA_CLK(hub, tmon_1m, peri),
+		[BCM281XX_HUB_CCU_CLOCK_COUNT] = LAST_KONA_CLK,
+	},
 };
 
 /* Master CCU */
@@ -175,6 +194,23 @@ static struct peri_clk_data hsic2_12m_data = {
 
 static struct ccu_data master_ccu_data = {
 	BCM281XX_CCU_COMMON(master, MASTER),
+	.kona_clks	= {
+		[BCM281XX_MASTER_CCU_SDIO1] =
+			KONA_CLK(master, sdio1, peri),
+		[BCM281XX_MASTER_CCU_SDIO2] =
+			KONA_CLK(master, sdio2, peri),
+		[BCM281XX_MASTER_CCU_SDIO3] =
+			KONA_CLK(master, sdio3, peri),
+		[BCM281XX_MASTER_CCU_SDIO4] =
+			KONA_CLK(master, sdio4, peri),
+		[BCM281XX_MASTER_CCU_USB_IC] =
+			KONA_CLK(master, usb_ic, peri),
+		[BCM281XX_MASTER_CCU_HSIC2_48M] =
+			KONA_CLK(master, hsic2_48m, peri),
+		[BCM281XX_MASTER_CCU_HSIC2_12M] =
+			KONA_CLK(master, hsic2_12m, peri),
+		[BCM281XX_MASTER_CCU_CLOCK_COUNT] = LAST_KONA_CLK,
+	},
 };
 
 /* Slave CCU */
@@ -287,96 +323,56 @@ static struct peri_clk_data pwm_data = {
 
 static struct ccu_data slave_ccu_data = {
 	BCM281XX_CCU_COMMON(slave, SLAVE),
+	.kona_clks	= {
+		[BCM281XX_SLAVE_CCU_UARTB] =
+			KONA_CLK(slave, uartb, peri),
+		[BCM281XX_SLAVE_CCU_UARTB2] =
+			KONA_CLK(slave, uartb2, peri),
+		[BCM281XX_SLAVE_CCU_UARTB3] =
+			KONA_CLK(slave, uartb3, peri),
+		[BCM281XX_SLAVE_CCU_UARTB4] =
+			KONA_CLK(slave, uartb4, peri),
+		[BCM281XX_SLAVE_CCU_SSP0] =
+			KONA_CLK(slave, ssp0, peri),
+		[BCM281XX_SLAVE_CCU_SSP2] =
+			KONA_CLK(slave, ssp2, peri),
+		[BCM281XX_SLAVE_CCU_BSC1] =
+			KONA_CLK(slave, bsc1, peri),
+		[BCM281XX_SLAVE_CCU_BSC2] =
+			KONA_CLK(slave, bsc2, peri),
+		[BCM281XX_SLAVE_CCU_BSC3] =
+			KONA_CLK(slave, bsc3, peri),
+		[BCM281XX_SLAVE_CCU_PWM] =
+			KONA_CLK(slave, pwm, peri),
+		[BCM281XX_SLAVE_CCU_CLOCK_COUNT] = LAST_KONA_CLK,
+	},
 };
 
-/*
- * CCU setup routines
- *
- * These are called from kona_dt_ccu_setup() to initialize the array
- * of clocks provided by the CCU.  Once allocated, the entries in
- * the array are initialized by calling kona_clk_setup() with the
- * initialization data for each clock.  They return 0 if successful
- * or an error code otherwise.
- */
-static int __init bcm281xx_root_ccu_clks_setup(struct ccu_data *ccu)
-{
-	PERI_CLK_SETUP(ccu, BCM281XX_ROOT_CCU_FRAC_1M, frac_1m);
-
-	return 0;
-}
-
-static int __init bcm281xx_aon_ccu_clks_setup(struct ccu_data *ccu)
-{
-	PERI_CLK_SETUP(ccu, BCM281XX_AON_CCU_HUB_TIMER, hub_timer);
-	PERI_CLK_SETUP(ccu, BCM281XX_AON_CCU_PMU_BSC, pmu_bsc);
-	PERI_CLK_SETUP(ccu, BCM281XX_AON_CCU_PMU_BSC_VAR, pmu_bsc_var);
-
-	return 0;
-}
-
-static int __init bcm281xx_hub_ccu_clks_setup(struct ccu_data *ccu)
-{
-	PERI_CLK_SETUP(ccu, BCM281XX_HUB_CCU_TMON_1M, tmon_1m);
-
-	return 0;
-}
-
-static int __init bcm281xx_master_ccu_clks_setup(struct ccu_data *ccu)
-{
-	PERI_CLK_SETUP(ccu, BCM281XX_MASTER_CCU_SDIO1, sdio1);
-	PERI_CLK_SETUP(ccu, BCM281XX_MASTER_CCU_SDIO2, sdio2);
-	PERI_CLK_SETUP(ccu, BCM281XX_MASTER_CCU_SDIO3, sdio3);
-	PERI_CLK_SETUP(ccu, BCM281XX_MASTER_CCU_SDIO4, sdio4);
-	PERI_CLK_SETUP(ccu, BCM281XX_MASTER_CCU_USB_IC, usb_ic);
-	PERI_CLK_SETUP(ccu, BCM281XX_MASTER_CCU_HSIC2_48M, hsic2_48m);
-	PERI_CLK_SETUP(ccu, BCM281XX_MASTER_CCU_HSIC2_12M, hsic2_12m);
-
-	return 0;
-}
-
-static int __init bcm281xx_slave_ccu_clks_setup(struct ccu_data *ccu)
-{
-	PERI_CLK_SETUP(ccu, BCM281XX_SLAVE_CCU_UARTB, uartb);
-	PERI_CLK_SETUP(ccu, BCM281XX_SLAVE_CCU_UARTB2, uartb2);
-	PERI_CLK_SETUP(ccu, BCM281XX_SLAVE_CCU_UARTB3, uartb3);
-	PERI_CLK_SETUP(ccu, BCM281XX_SLAVE_CCU_UARTB4, uartb4);
-	PERI_CLK_SETUP(ccu, BCM281XX_SLAVE_CCU_SSP0, ssp0);
-	PERI_CLK_SETUP(ccu, BCM281XX_SLAVE_CCU_SSP2, ssp2);
-	PERI_CLK_SETUP(ccu, BCM281XX_SLAVE_CCU_BSC1, bsc1);
-	PERI_CLK_SETUP(ccu, BCM281XX_SLAVE_CCU_BSC2, bsc2);
-	PERI_CLK_SETUP(ccu, BCM281XX_SLAVE_CCU_BSC3, bsc3);
-	PERI_CLK_SETUP(ccu, BCM281XX_SLAVE_CCU_PWM, pwm);
-
-	return 0;
-}
-
 /* Device tree match table callback functions */
 
 static void __init kona_dt_root_ccu_setup(struct device_node *node)
 {
-	kona_dt_ccu_setup(&root_ccu_data, node, bcm281xx_root_ccu_clks_setup);
+	kona_dt_ccu_setup(&root_ccu_data, node);
 }
 
 static void __init kona_dt_aon_ccu_setup(struct device_node *node)
 {
-	kona_dt_ccu_setup(&aon_ccu_data, node, bcm281xx_aon_ccu_clks_setup);
+	kona_dt_ccu_setup(&aon_ccu_data, node);
 }
 
 static void __init kona_dt_hub_ccu_setup(struct device_node *node)
 {
-	kona_dt_ccu_setup(&hub_ccu_data, node, bcm281xx_hub_ccu_clks_setup);
+	kona_dt_ccu_setup(&hub_ccu_data, node);
 }
 
 static void __init kona_dt_master_ccu_setup(struct device_node *node)
 {
-	kona_dt_ccu_setup(&master_ccu_data, node,
-			bcm281xx_master_ccu_clks_setup);
+	kona_dt_ccu_setup(&master_ccu_data, node);
 }
 
 static void __init kona_dt_slave_ccu_setup(struct device_node *node)
 {
-	kona_dt_ccu_setup(&slave_ccu_data, node,
-			bcm281xx_slave_ccu_clks_setup);
+	kona_dt_ccu_setup(&slave_ccu_data, node);
 }
 
 CLK_OF_DECLARE(bcm281xx_root_ccu, BCM281XX_DT_ROOT_CCU_COMPAT,
diff --git a/drivers/clk/bcm/clk-kona-setup.c b/drivers/clk/bcm/clk-kona-setup.c
index 4468065..196922b 100644
--- a/drivers/clk/bcm/clk-kona-setup.c
+++ b/drivers/clk/bcm/clk-kona-setup.c
@@ -566,7 +566,6 @@ static void peri_clk_teardown(struct peri_clk_data *data,
 				struct clk_init_data *init_data)
 {
 	clk_sel_teardown(&data->sel, init_data);
-	init_data->ops = NULL;
 }
 
 /*
@@ -575,10 +574,9 @@ static void peri_clk_teardown(struct peri_clk_data *data,
  * that can be assigned if the clock has one or more parent clocks
  * associated with it.
  */
-static int peri_clk_setup(struct ccu_data *ccu, struct peri_clk_data *data,
-			struct clk_init_data *init_data)
+static int
+peri_clk_setup(struct peri_clk_data *data, struct clk_init_data *init_data)
 {
-	init_data->ops = &kona_peri_clk_ops;
 	init_data->flags = CLK_IGNORE_UNUSED;
 
 	return clk_sel_setup(data->clocks, &data->sel, init_data);
@@ -616,39 +614,26 @@ static void kona_clk_teardown(struct clk *clk)
 	bcm_clk_teardown(bcm_clk);
 }
 
-struct clk *kona_clk_setup(struct ccu_data *ccu, const char *name,
-			enum bcm_clk_type type, void *data)
+struct clk *kona_clk_setup(struct kona_clk *bcm_clk)
 {
-	struct kona_clk *bcm_clk;
-	struct clk_init_data *init_data;
+	struct clk_init_data *init_data = &bcm_clk->init_data;
 	struct clk *clk = NULL;
 
-	bcm_clk = kzalloc(sizeof(*bcm_clk), GFP_KERNEL);
-	if (!bcm_clk) {
-		pr_err("%s: failed to allocate bcm_clk for %s\n", __func__,
-			name);
-		return NULL;
-	}
-	bcm_clk->ccu = ccu;
-	bcm_clk->init_data.name = name;
-
-	init_data = &bcm_clk->init_data;
-	init_data->name = name;
-	switch (type) {
+	switch (bcm_clk->type) {
 	case bcm_clk_peri:
-		if (peri_clk_setup(ccu, data, init_data))
-			goto out_free;
+		if (peri_clk_setup(bcm_clk->data, init_data))
+			return NULL;
 		break;
 	default:
-		data = NULL;
-		break;
+		pr_err("%s: clock type %d invalid for %s\n", __func__,
+			(int)bcm_clk->type, init_data->name);
+		return NULL;
 	}
-	bcm_clk->type = type;
-	bcm_clk->data = data;
 
 	/* Make sure everything makes sense before we set it up */
 	if (!kona_clk_valid(bcm_clk)) {
-		pr_err("%s: clock data invalid for %s\n", __func__, name);
+		pr_err("%s: clock data invalid for %s\n", __func__,
+			init_data->name);
 		goto out_teardown;
 	}
 
@@ -656,7 +641,7 @@ struct clk *kona_clk_setup(struct ccu_data *ccu, const char *name,
 	clk = clk_register(NULL, &bcm_clk->hw);
 	if (IS_ERR(clk)) {
 		pr_err("%s: error registering clock %s (%ld)\n", __func__,
-				name, PTR_ERR(clk));
+			init_data->name, PTR_ERR(clk));
 		goto out_teardown;
 	}
 	BUG_ON(!clk);
@@ -664,8 +649,6 @@ struct clk *kona_clk_setup(struct ccu_data *ccu, const char *name,
 	return clk;
 out_teardown:
 	bcm_clk_teardown(bcm_clk);
-out_free:
-	kfree(bcm_clk);
 
 	return NULL;
 }
@@ -700,11 +683,11 @@ static void kona_ccu_teardown(struct ccu_data *ccu)
  * initialize the array of clocks provided by the CCU.
  */
 void __init kona_dt_ccu_setup(struct ccu_data *ccu,
-			struct device_node *node,
-			int (*ccu_clks_setup)(struct ccu_data *))
+			struct device_node *node)
 {
 	struct resource res = { 0 };
 	resource_size_t range;
+	unsigned int i;
 	int ret;
 
 	if (ccu->clk_data.clk_num) {
@@ -743,9 +726,16 @@ void __init kona_dt_ccu_setup(struct ccu_data *ccu,
 	ccu->node = of_node_get(node);
 	list_add_tail(&ccu->links, &ccu_list);
 
-	/* Set up clocks array (in ccu->clk_data) */
-	if (ccu_clks_setup(ccu))
-		goto out_err;
+	/*
+	 * Set up each defined kona clock and save the result in
+	 * the clock framework clock array (in ccu->data).  Then
+	 * register as a provider for these clocks.
+	 */
+	for (i = 0; i < ccu->clk_data.clk_num; i++) {
+		if (!ccu->kona_clks[i].ccu)
+			continue;
+		ccu->clk_data.clks[i] = kona_clk_setup(&ccu->kona_clks[i]);
+	}
 
 	ret = of_clk_add_provider(node, of_clk_src_onecell_get, &ccu->clk_data);
 	if (ret) {
diff --git a/drivers/clk/bcm/clk-kona.h b/drivers/clk/bcm/clk-kona.h
index 0748c9b..fba2740 100644
--- a/drivers/clk/bcm/clk-kona.h
+++ b/drivers/clk/bcm/clk-kona.h
@@ -71,35 +71,6 @@ enum bcm_clk_type {
 };
 
 /*
- * Each CCU defines a mapped area of memory containing registers
- * used to manage clocks implemented by the CCU.  Access to memory
- * within the CCU's space is serialized by a spinlock.  Before any
- * (other) address can be written, a special access "password" value
- * must be written to its WR_ACCESS register (located at the base
- * address of the range).  We keep track of the name of each CCU as
- * it is set up, and maintain them in a list.
- */
-struct ccu_data {
-	void __iomem *base;	/* base of mapped address space */
-	spinlock_t lock;	/* serialization lock */
-	bool write_enabled;	/* write access is currently enabled */
-	struct list_head links;	/* for ccu_list */
-	struct device_node *node;
-	struct clk_onecell_data clk_data;
-	const char *name;
-	u32 range;		/* byte range of address space */
-};
-
-/* Initialization for common fields in a Kona ccu_data structure */
-#define KONA_CCU_COMMON(_prefix, _name, _ucase_name)			    \
-	.name		= #_name "_ccu",				    \
-	.lock		= __SPIN_LOCK_UNLOCKED(_name ## _ccu_data.lock),    \
-	.links		= LIST_HEAD_INIT(_name ## _ccu_data.links),	    \
-	.clk_data	= {						    \
-		.clk_num = _prefix ## _ ## _ucase_name ## _CCU_CLOCK_COUNT, \
-	}
-
-/*
  * Gating control and status is managed by a 32-bit gate register.
  *
  * There are several types of gating available:
@@ -393,18 +364,53 @@ struct kona_clk {
 #define to_kona_clk(_hw) \
 	container_of(_hw, struct kona_clk, hw)
 
+/* Initialization macro for an entry in a CCU's kona_clks[] array. */
+#define KONA_CLK(_ccu_name, _clk_name, _type)				\
+	{								\
+		.init_data	= {					\
+			.name = #_clk_name,				\
+			.ops = &kona_ ## _type ## _clk_ops,		\
+		},							\
+		.ccu		= &_ccu_name ## _ccu_data,		\
+		.type		= bcm_clk_ ## _type,			\
+		.data		= &_clk_name ## _data,			\
+	}
+#define LAST_KONA_CLK	{ .type = bcm_clk_none }
+
+/*
+ * Each CCU defines a mapped area of memory containing registers
+ * used to manage clocks implemented by the CCU.  Access to memory
+ * within the CCU's space is serialized by a spinlock.  Before any
+ * (other) address can be written, a special access "password" value
+ * must be written to its WR_ACCESS register (located at the base
+ * address of the range).  We keep track of the name of each CCU as
+ * it is set up, and maintain them in a list.
+ */
+struct ccu_data {
+	void __iomem *base;	/* base of mapped address space */
+	spinlock_t lock;	/* serialization lock */
+	bool write_enabled;	/* write access is currently enabled */
+	struct list_head links;	/* for ccu_list */
+	struct device_node *node;
+	struct clk_onecell_data clk_data;
+	const char *name;
+	u32 range;		/* byte range of address space */
+	struct kona_clk kona_clks[];	/* must be last */
+};
+
+/* Initialization for common fields in a Kona ccu_data structure */
+#define KONA_CCU_COMMON(_prefix, _name, _ccuname)			    \
+	.name		= #_name "_ccu",				    \
+	.lock		= __SPIN_LOCK_UNLOCKED(_name ## _ccu_data.lock),    \
+	.links		= LIST_HEAD_INIT(_name ## _ccu_data.links),	    \
+	.clk_data	= {						    \
+		.clk_num = _prefix ## _ ## _ccuname ## _CCU_CLOCK_COUNT,    \
+	}
+
 /* Exported globals */
 
 extern struct clk_ops kona_peri_clk_ops;
 
-/* Help functions */
-
-#define KONA_CLK_SETUP(_ccu, _type, _name) \
-	kona_clk_setup((_ccu), #_name, bcm_clk_## _type, &_name ## _data)
-
-#define PERI_CLK_SETUP(_ccu, _id, _name) \
-	(_ccu)->clk_data.clks[_id] = KONA_CLK_SETUP((_ccu), peri, _name)
-
 /* Externally visible functions */
 
 extern u64 do_div_round_closest(u64 dividend, unsigned long divisor);
@@ -412,11 +418,9 @@ extern u64 scaled_div_max(struct bcm_clk_div *div);
 extern u64 scaled_div_build(struct bcm_clk_div *div, u32 div_value,
 				u32 billionths);
 
-extern struct clk *kona_clk_setup(struct ccu_data *ccu, const char *name,
-			enum bcm_clk_type type, void *data);
+extern struct clk *kona_clk_setup(struct kona_clk *bcm_clk);
 extern void __init kona_dt_ccu_setup(struct ccu_data *ccu,
-			struct device_node *node,
-			int (*ccu_clks_setup)(struct ccu_data *));
+				struct device_node *node);
 extern bool __init kona_ccu_init(struct ccu_data *ccu);
 
 #endif /* _CLK_KONA_H */
-- 
1.7.9.5

