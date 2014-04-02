Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757449AbaDBCEk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 22:04:40 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:49591 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757426AbaDBCEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 22:04:36 -0400
From: Alex Elder <elder@linaro.org>
To: mturquette@linaro.org, bcm@fixthebug.org, mporter@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/7] clk: bcm281xx: initialize CCU structures statically
Date: Tue,  1 Apr 2014 21:04:52 -0500
Message-Id: <1396404296-9390-5-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1396404296-9390-1-git-send-email-elder@linaro.org>
References: <1396404296-9390-1-git-send-email-elder@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We know up front how many CCU's we'll support, so there's no need to
allocate their data structures dynamically.  Define a macro
KONA_CCU_COMMON() to simplify the initialization of many of the
fields in a ccu_data structure.  Pass the address of a statically
defined CCU structure to kona_dt_ccu_setup() rather than having that
function allocate one.

We also know at build time how many clocks a given CCU will provide,
though the number of of them for each CCU is different.  Record the
number of clocks we need in the CCU's clk_onecell_data struct
(which is used when we register the CCU with the common clock code
as a clock provider).  Rename that struct field "clk_data" (because
"data" alone gets a little confusing).

Use the known clock count to move the allocation of each CCU's
clocks array into ccu_clks_setup() rather than having each CCU's
setup callback function do it.

(The real motivation behind all of this is that we'll be doing some
static initialization of some additional CCU-specific data soon.)

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/clk/bcm/clk-bcm281xx.c   |  144 +++++++++++++++-----------------------
 drivers/clk/bcm/clk-kona-setup.c |   47 ++++++-------
 drivers/clk/bcm/clk-kona.c       |    4 +-
 drivers/clk/bcm/clk-kona.h       |   21 ++++--
 4 files changed, 97 insertions(+), 119 deletions(-)

diff --git a/drivers/clk/bcm/clk-bcm281xx.c b/drivers/clk/bcm/clk-bcm281xx.c
index bb947af..d72f2ae 100644
--- a/drivers/clk/bcm/clk-bcm281xx.c
+++ b/drivers/clk/bcm/clk-bcm281xx.c
@@ -15,6 +15,9 @@
 #include "clk-kona.h"
 #include "dt-bindings/clock/bcm281xx.h"
 
+#define BCM281XX_CCU_COMMON(_name, _ucase_name) \
+	KONA_CCU_COMMON(BCM281XX, _name, _ucase_name)
+
 /*
  * These are the bcm281xx CCU device tree "compatible" strings.
  * We're stuck with using "bcm11351" in the string because wild
@@ -27,7 +30,7 @@
 #define BCM281XX_DT_MASTER_CCU_COMPAT	"brcm,bcm11351-master-ccu"
 #define BCM281XX_DT_SLAVE_CCU_COMPAT	"brcm,bcm11351-slave-ccu"
 
-/* Root CCU clocks */
+/* Root CCU */
 
 static struct peri_clk_data frac_1m_data = {
 	.gate		= HW_SW_GATE(0x214, 16, 0, 1),
@@ -36,7 +39,11 @@ static struct peri_clk_data frac_1m_data = {
 	.clocks		= CLOCKS("ref_crystal"),
 };
 
-/* AON CCU clocks */
+static struct ccu_data root_ccu_data = {
+	BCM281XX_CCU_COMMON(root, ROOT),
+};
+
+/* AON CCU */
 
 static struct peri_clk_data hub_timer_data = {
 	.gate		= HW_SW_GATE(0x0414, 16, 0, 1),
@@ -65,7 +72,11 @@ static struct peri_clk_data pmu_bsc_var_data = {
 	.trig		= TRIGGER(0x0a40, 2),
 };
 
-/* Hub CCU clocks */
+static struct ccu_data aon_ccu_data = {
+	BCM281XX_CCU_COMMON(aon, AON),
+};
+
+/* Hub CCU */
 
 static struct peri_clk_data tmon_1m_data = {
 	.gate		= HW_SW_GATE(0x04a4, 18, 2, 3),
@@ -75,7 +86,11 @@ static struct peri_clk_data tmon_1m_data = {
 	.trig		= TRIGGER(0x0e84, 1),
 };
 
-/* Master CCU clocks */
+static struct ccu_data hub_ccu_data = {
+	BCM281XX_CCU_COMMON(hub, HUB),
+};
+
+/* Master CCU */
 
 static struct peri_clk_data sdio1_data = {
 	.gate		= HW_SW_GATE(0x0358, 18, 2, 3),
@@ -158,7 +173,11 @@ static struct peri_clk_data hsic2_12m_data = {
 	.trig		= TRIGGER(0x0afc, 5),
 };
 
-/* Slave CCU clocks */
+static struct ccu_data master_ccu_data = {
+	BCM281XX_CCU_COMMON(master, MASTER),
+};
+
+/* Slave CCU */
 
 static struct peri_clk_data uartb_data = {
 	.gate		= HW_SW_GATE(0x0400, 18, 2, 3),
@@ -266,6 +285,10 @@ static struct peri_clk_data pwm_data = {
 	.trig		= TRIGGER(0x0afc, 15),
 };
 
+static struct ccu_data slave_ccu_data = {
+	BCM281XX_CCU_COMMON(slave, SLAVE),
+};
+
 /*
  * CCU setup routines
  *
@@ -277,107 +300,52 @@ static struct peri_clk_data pwm_data = {
  */
 static int __init bcm281xx_root_ccu_clks_setup(struct ccu_data *ccu)
 {
-	struct clk **clks;
-	size_t count = BCM281XX_ROOT_CCU_CLOCK_COUNT;
-
-	clks = kzalloc(count * sizeof(*clks), GFP_KERNEL);
-	if (!clks) {
-		pr_err("%s: failed to allocate root clocks\n", __func__);
-		return -ENOMEM;
-	}
-	ccu->data.clks = clks;
-	ccu->data.clk_num = count;
-
-	PERI_CLK_SETUP(clks, ccu, BCM281XX_ROOT_CCU_FRAC_1M, frac_1m);
+	PERI_CLK_SETUP(ccu, BCM281XX_ROOT_CCU_FRAC_1M, frac_1m);
 
 	return 0;
 }
 
 static int __init bcm281xx_aon_ccu_clks_setup(struct ccu_data *ccu)
 {
-	struct clk **clks;
-	size_t count = BCM281XX_AON_CCU_CLOCK_COUNT;
-
-	clks = kzalloc(count * sizeof(*clks), GFP_KERNEL);
-	if (!clks) {
-		pr_err("%s: failed to allocate aon clocks\n", __func__);
-		return -ENOMEM;
-	}
-	ccu->data.clks = clks;
-	ccu->data.clk_num = count;
-
-	PERI_CLK_SETUP(clks, ccu, BCM281XX_AON_CCU_HUB_TIMER, hub_timer);
-	PERI_CLK_SETUP(clks, ccu, BCM281XX_AON_CCU_PMU_BSC, pmu_bsc);
-	PERI_CLK_SETUP(clks, ccu, BCM281XX_AON_CCU_PMU_BSC_VAR, pmu_bsc_var);
+	PERI_CLK_SETUP(ccu, BCM281XX_AON_CCU_HUB_TIMER, hub_timer);
+	PERI_CLK_SETUP(ccu, BCM281XX_AON_CCU_PMU_BSC, pmu_bsc);
+	PERI_CLK_SETUP(ccu, BCM281XX_AON_CCU_PMU_BSC_VAR, pmu_bsc_var);
 
 	return 0;
 }
 
 static int __init bcm281xx_hub_ccu_clks_setup(struct ccu_data *ccu)
 {
-	struct clk **clks;
-	size_t count = BCM281XX_HUB_CCU_CLOCK_COUNT;
-
-	clks = kzalloc(count * sizeof(*clks), GFP_KERNEL);
-	if (!clks) {
-		pr_err("%s: failed to allocate hub clocks\n", __func__);
-		return -ENOMEM;
-	}
-	ccu->data.clks = clks;
-	ccu->data.clk_num = count;
-
-	PERI_CLK_SETUP(clks, ccu, BCM281XX_HUB_CCU_TMON_1M, tmon_1m);
+	PERI_CLK_SETUP(ccu, BCM281XX_HUB_CCU_TMON_1M, tmon_1m);
 
 	return 0;
 }
 
 static int __init bcm281xx_master_ccu_clks_setup(struct ccu_data *ccu)
 {
-	struct clk **clks;
-	size_t count = BCM281XX_MASTER_CCU_CLOCK_COUNT;
-
-	clks = kzalloc(count * sizeof(*clks), GFP_KERNEL);
-	if (!clks) {
-		pr_err("%s: failed to allocate master clocks\n", __func__);
-		return -ENOMEM;
-	}
-	ccu->data.clks = clks;
-	ccu->data.clk_num = count;
-
-	PERI_CLK_SETUP(clks, ccu, BCM281XX_MASTER_CCU_SDIO1, sdio1);
-	PERI_CLK_SETUP(clks, ccu, BCM281XX_MASTER_CCU_SDIO2, sdio2);
-	PERI_CLK_SETUP(clks, ccu, BCM281XX_MASTER_CCU_SDIO3, sdio3);
-	PERI_CLK_SETUP(clks, ccu, BCM281XX_MASTER_CCU_SDIO4, sdio4);
-	PERI_CLK_SETUP(clks, ccu, BCM281XX_MASTER_CCU_USB_IC, usb_ic);
-	PERI_CLK_SETUP(clks, ccu, BCM281XX_MASTER_CCU_HSIC2_48M, hsic2_48m);
-	PERI_CLK_SETUP(clks, ccu, BCM281XX_MASTER_CCU_HSIC2_12M, hsic2_12m);
+	PERI_CLK_SETUP(ccu, BCM281XX_MASTER_CCU_SDIO1, sdio1);
+	PERI_CLK_SETUP(ccu, BCM281XX_MASTER_CCU_SDIO2, sdio2);
+	PERI_CLK_SETUP(ccu, BCM281XX_MASTER_CCU_SDIO3, sdio3);
+	PERI_CLK_SETUP(ccu, BCM281XX_MASTER_CCU_SDIO4, sdio4);
+	PERI_CLK_SETUP(ccu, BCM281XX_MASTER_CCU_USB_IC, usb_ic);
+	PERI_CLK_SETUP(ccu, BCM281XX_MASTER_CCU_HSIC2_48M, hsic2_48m);
+	PERI_CLK_SETUP(ccu, BCM281XX_MASTER_CCU_HSIC2_12M, hsic2_12m);
 
 	return 0;
 }
 
 static int __init bcm281xx_slave_ccu_clks_setup(struct ccu_data *ccu)
 {
-	struct clk **clks;
-	size_t count = BCM281XX_SLAVE_CCU_CLOCK_COUNT;
-
-	clks = kzalloc(count * sizeof(*clks), GFP_KERNEL);
-	if (!clks) {
-		pr_err("%s: failed to allocate slave clocks\n", __func__);
-		return -ENOMEM;
-	}
-	ccu->data.clks = clks;
-	ccu->data.clk_num = count;
-
-	PERI_CLK_SETUP(clks, ccu, BCM281XX_SLAVE_CCU_UARTB, uartb);
-	PERI_CLK_SETUP(clks, ccu, BCM281XX_SLAVE_CCU_UARTB2, uartb2);
-	PERI_CLK_SETUP(clks, ccu, BCM281XX_SLAVE_CCU_UARTB3, uartb3);
-	PERI_CLK_SETUP(clks, ccu, BCM281XX_SLAVE_CCU_UARTB4, uartb4);
-	PERI_CLK_SETUP(clks, ccu, BCM281XX_SLAVE_CCU_SSP0, ssp0);
-	PERI_CLK_SETUP(clks, ccu, BCM281XX_SLAVE_CCU_SSP2, ssp2);
-	PERI_CLK_SETUP(clks, ccu, BCM281XX_SLAVE_CCU_BSC1, bsc1);
-	PERI_CLK_SETUP(clks, ccu, BCM281XX_SLAVE_CCU_BSC2, bsc2);
-	PERI_CLK_SETUP(clks, ccu, BCM281XX_SLAVE_CCU_BSC3, bsc3);
-	PERI_CLK_SETUP(clks, ccu, BCM281XX_SLAVE_CCU_PWM, pwm);
+	PERI_CLK_SETUP(ccu, BCM281XX_SLAVE_CCU_UARTB, uartb);
+	PERI_CLK_SETUP(ccu, BCM281XX_SLAVE_CCU_UARTB2, uartb2);
+	PERI_CLK_SETUP(ccu, BCM281XX_SLAVE_CCU_UARTB3, uartb3);
+	PERI_CLK_SETUP(ccu, BCM281XX_SLAVE_CCU_UARTB4, uartb4);
+	PERI_CLK_SETUP(ccu, BCM281XX_SLAVE_CCU_SSP0, ssp0);
+	PERI_CLK_SETUP(ccu, BCM281XX_SLAVE_CCU_SSP2, ssp2);
+	PERI_CLK_SETUP(ccu, BCM281XX_SLAVE_CCU_BSC1, bsc1);
+	PERI_CLK_SETUP(ccu, BCM281XX_SLAVE_CCU_BSC2, bsc2);
+	PERI_CLK_SETUP(ccu, BCM281XX_SLAVE_CCU_BSC3, bsc3);
+	PERI_CLK_SETUP(ccu, BCM281XX_SLAVE_CCU_PWM, pwm);
 
 	return 0;
 }
@@ -386,27 +354,29 @@ static int __init bcm281xx_slave_ccu_clks_setup(struct ccu_data *ccu)
 
 static void __init kona_dt_root_ccu_setup(struct device_node *node)
 {
-	kona_dt_ccu_setup(node, bcm281xx_root_ccu_clks_setup);
+	kona_dt_ccu_setup(&root_ccu_data, node, bcm281xx_root_ccu_clks_setup);
 }
 
 static void __init kona_dt_aon_ccu_setup(struct device_node *node)
 {
-	kona_dt_ccu_setup(node, bcm281xx_aon_ccu_clks_setup);
+	kona_dt_ccu_setup(&aon_ccu_data, node, bcm281xx_aon_ccu_clks_setup);
 }
 
 static void __init kona_dt_hub_ccu_setup(struct device_node *node)
 {
-	kona_dt_ccu_setup(node, bcm281xx_hub_ccu_clks_setup);
+	kona_dt_ccu_setup(&hub_ccu_data, node, bcm281xx_hub_ccu_clks_setup);
 }
 
 static void __init kona_dt_master_ccu_setup(struct device_node *node)
 {
-	kona_dt_ccu_setup(node, bcm281xx_master_ccu_clks_setup);
+	kona_dt_ccu_setup(&master_ccu_data, node,
+			bcm281xx_master_ccu_clks_setup);
 }
 
 static void __init kona_dt_slave_ccu_setup(struct device_node *node)
 {
-	kona_dt_ccu_setup(node, bcm281xx_slave_ccu_clks_setup);
+	kona_dt_ccu_setup(&slave_ccu_data, node,
+			bcm281xx_slave_ccu_clks_setup);
 }
 
 CLK_OF_DECLARE(bcm281xx_root_ccu, BCM281XX_DT_ROOT_CCU_COMPAT,
diff --git a/drivers/clk/bcm/clk-kona-setup.c b/drivers/clk/bcm/clk-kona-setup.c
index eed84f5..4468065 100644
--- a/drivers/clk/bcm/clk-kona-setup.c
+++ b/drivers/clk/bcm/clk-kona-setup.c
@@ -674,50 +674,49 @@ static void ccu_clks_teardown(struct ccu_data *ccu)
 {
 	u32 i;
 
-	for (i = 0; i < ccu->data.clk_num; i++)
-		kona_clk_teardown(ccu->data.clks[i]);
-	kfree(ccu->data.clks);
+	for (i = 0; i < ccu->clk_data.clk_num; i++)
+		kona_clk_teardown(ccu->clk_data.clks[i]);
+	kfree(ccu->clk_data.clks);
 }
 
 static void kona_ccu_teardown(struct ccu_data *ccu)
 {
-	if (!ccu)
-		return;
-
+	kfree(ccu->clk_data.clks);
+	ccu->clk_data.clks = NULL;
 	if (!ccu->base)
-		goto done;
+		return;
 
 	of_clk_del_provider(ccu->node);	/* safe if never added */
 	ccu_clks_teardown(ccu);
 	list_del(&ccu->links);
 	of_node_put(ccu->node);
+	ccu->node = NULL;
 	iounmap(ccu->base);
-done:
-	kfree(ccu->name);
-	kfree(ccu);
+	ccu->base = NULL;
 }
 
 /*
  * Set up a CCU.  Call the provided ccu_clks_setup callback to
  * initialize the array of clocks provided by the CCU.
  */
-void __init kona_dt_ccu_setup(struct device_node *node,
+void __init kona_dt_ccu_setup(struct ccu_data *ccu,
+			struct device_node *node,
 			int (*ccu_clks_setup)(struct ccu_data *))
 {
-	struct ccu_data *ccu;
 	struct resource res = { 0 };
 	resource_size_t range;
 	int ret;
 
-	ccu = kzalloc(sizeof(*ccu), GFP_KERNEL);
-	if (ccu)
-		ccu->name = kstrdup(node->name, GFP_KERNEL);
-	if (!ccu || !ccu->name) {
-		pr_err("%s: unable to allocate CCU struct for %s\n",
-			__func__, node->name);
-		kfree(ccu);
+	if (ccu->clk_data.clk_num) {
+		size_t size;
 
-		return;
+		size = ccu->clk_data.clk_num * sizeof(*ccu->clk_data.clks);
+		ccu->clk_data.clks = kzalloc(size, GFP_KERNEL);
+		if (!ccu->clk_data.clks) {
+			pr_err("%s: unable to allocate %u clocks for %s\n",
+				__func__, ccu->clk_data.clk_num, node->name);
+			return;
+		}
 	}
 
 	ret = of_address_to_resource(node, 0, &res);
@@ -741,18 +740,14 @@ void __init kona_dt_ccu_setup(struct device_node *node,
 			node->name);
 		goto out_err;
 	}
-
-	spin_lock_init(&ccu->lock);
-	INIT_LIST_HEAD(&ccu->links);
 	ccu->node = of_node_get(node);
-
 	list_add_tail(&ccu->links, &ccu_list);
 
-	/* Set up clocks array (in ccu->data) */
+	/* Set up clocks array (in ccu->clk_data) */
 	if (ccu_clks_setup(ccu))
 		goto out_err;
 
-	ret = of_clk_add_provider(node, of_clk_src_onecell_get, &ccu->data);
+	ret = of_clk_add_provider(node, of_clk_src_onecell_get, &ccu->clk_data);
 	if (ret) {
 		pr_err("%s: error adding ccu %s as provider (%d)\n", __func__,
 				node->name, ret);
diff --git a/drivers/clk/bcm/clk-kona.c b/drivers/clk/bcm/clk-kona.c
index 488ed1f..5c0dc5b 100644
--- a/drivers/clk/bcm/clk-kona.c
+++ b/drivers/clk/bcm/clk-kona.c
@@ -1018,13 +1018,13 @@ bool __init kona_ccu_init(struct ccu_data *ccu)
 {
 	unsigned long flags;
 	unsigned int which;
-	struct clk **clks = ccu->data.clks;
+	struct clk **clks = ccu->clk_data.clks;
 	bool success = true;
 
 	flags = ccu_lock(ccu);
 	__ccu_write_enable(ccu);
 
-	for (which = 0; which < ccu->data.clk_num; which++) {
+	for (which = 0; which < ccu->clk_data.clk_num; which++) {
 		struct kona_clk *bcm_clk;
 
 		if (!clks[which])
diff --git a/drivers/clk/bcm/clk-kona.h b/drivers/clk/bcm/clk-kona.h
index 96fd0bc..0748c9b 100644
--- a/drivers/clk/bcm/clk-kona.h
+++ b/drivers/clk/bcm/clk-kona.h
@@ -85,11 +85,20 @@ struct ccu_data {
 	bool write_enabled;	/* write access is currently enabled */
 	struct list_head links;	/* for ccu_list */
 	struct device_node *node;
-	struct clk_onecell_data data;
+	struct clk_onecell_data clk_data;
 	const char *name;
 	u32 range;		/* byte range of address space */
 };
 
+/* Initialization for common fields in a Kona ccu_data structure */
+#define KONA_CCU_COMMON(_prefix, _name, _ucase_name)			    \
+	.name		= #_name "_ccu",				    \
+	.lock		= __SPIN_LOCK_UNLOCKED(_name ## _ccu_data.lock),    \
+	.links		= LIST_HEAD_INIT(_name ## _ccu_data.links),	    \
+	.clk_data	= {						    \
+		.clk_num = _prefix ## _ ## _ucase_name ## _CCU_CLOCK_COUNT, \
+	}
+
 /*
  * Gating control and status is managed by a 32-bit gate register.
  *
@@ -390,8 +399,11 @@ extern struct clk_ops kona_peri_clk_ops;
 
 /* Help functions */
 
-#define PERI_CLK_SETUP(clks, ccu, id, name) \
-	clks[id] = kona_clk_setup(ccu, #name, bcm_clk_peri, &name ## _data)
+#define KONA_CLK_SETUP(_ccu, _type, _name) \
+	kona_clk_setup((_ccu), #_name, bcm_clk_## _type, &_name ## _data)
+
+#define PERI_CLK_SETUP(_ccu, _id, _name) \
+	(_ccu)->clk_data.clks[_id] = KONA_CLK_SETUP((_ccu), peri, _name)
 
 /* Externally visible functions */
 
@@ -402,7 +414,8 @@ extern u64 scaled_div_build(struct bcm_clk_div *div, u32 div_value,
 
 extern struct clk *kona_clk_setup(struct ccu_data *ccu, const char *name,
 			enum bcm_clk_type type, void *data);
-extern void __init kona_dt_ccu_setup(struct device_node *node,
+extern void __init kona_dt_ccu_setup(struct ccu_data *ccu,
+			struct device_node *node,
 			int (*ccu_clks_setup)(struct ccu_data *));
 extern bool __init kona_ccu_init(struct ccu_data *ccu);
 
-- 
1.7.9.5

