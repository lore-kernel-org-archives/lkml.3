Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757499AbaDBCGa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 22:06:30 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:59569 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757432AbaDBCEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 22:04:39 -0400
From: Alex Elder <elder@linaro.org>
To: mturquette@linaro.org, bcm@fixthebug.org, mporter@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 6/7] clk: bcm281xx: add clock policy support
Date: Tue,  1 Apr 2014 21:04:54 -0500
Message-Id: <1396404296-9390-7-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1396404296-9390-1-git-send-email-elder@linaro.org>
References: <1396404296-9390-1-git-send-email-elder@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for CCU policy engine control, and also for setting the
mask bits for bus clocks that require a policy change to get
activated.  This includes adding validity checking framework for
CCUs, to validate the policy fields if defined.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/clk/bcm/clk-kona-setup.c |   92 ++++++++++++++++++++++
 drivers/clk/bcm/clk-kona.c       |  155 ++++++++++++++++++++++++++++++++++++++
 drivers/clk/bcm/clk-kona.h       |   71 +++++++++++++++++
 3 files changed, 318 insertions(+)

diff --git a/drivers/clk/bcm/clk-kona-setup.c b/drivers/clk/bcm/clk-kona-setup.c
index 196922b..5a49deb 100644
--- a/drivers/clk/bcm/clk-kona-setup.c
+++ b/drivers/clk/bcm/clk-kona-setup.c
@@ -25,6 +25,31 @@ LIST_HEAD(ccu_list);	/* The list of set up CCUs */
 
 /* Validity checking */
 
+static bool ccu_data_offsets_valid(struct ccu_data *ccu)
+{
+	struct ccu_policy *ccu_policy = &ccu->policy;
+	u32 limit;
+
+	limit = ccu->range - sizeof(u32);
+	limit = round_down(limit, sizeof(u32));
+	if (ccu_policy_exists(ccu_policy)) {
+		if (ccu_policy->enable.offset > limit) {
+			pr_err("%s: bad policy enable offset for %s "
+					"(%u > %u)\n", __func__,
+				ccu->name, ccu_policy->enable.offset, limit);
+			return false;
+		}
+		if (ccu_policy->control.offset > limit) {
+			pr_err("%s: bad policy control offset for %s "
+					"(%u > %u)\n", __func__,
+				ccu->name, ccu_policy->control.offset, limit);
+			return false;
+		}
+	}
+
+	return true;
+}
+
 static bool clk_requires_trigger(struct kona_clk *bcm_clk)
 {
 	struct peri_clk_data *peri = bcm_clk->peri;
@@ -54,6 +79,7 @@ static bool clk_requires_trigger(struct kona_clk *bcm_clk)
 static bool peri_clk_data_offsets_valid(struct kona_clk *bcm_clk)
 {
 	struct peri_clk_data *peri;
+	struct bcm_clk_policy *policy;
 	struct bcm_clk_gate *gate;
 	struct bcm_clk_div *div;
 	struct bcm_clk_sel *sel;
@@ -70,6 +96,15 @@ static bool peri_clk_data_offsets_valid(struct kona_clk *bcm_clk)
 	limit = range - sizeof(u32);
 	limit = round_down(limit, sizeof(u32));
 
+	policy = &peri->policy;
+	if (policy_exists(policy)) {
+		if (policy->offset > limit) {
+			pr_err("%s: bad policy offset for %s (%u > %u)\n",
+				__func__, name, policy->offset, limit);
+			return false;
+		}
+	}
+
 	gate = &peri->gate;
 	if (gate_exists(gate)) {
 		if (gate->offset > limit) {
@@ -167,6 +202,36 @@ static bool bitfield_valid(u32 shift, u32 width, const char *field_name,
 	return true;
 }
 
+static bool
+ccu_policy_valid(struct ccu_policy *ccu_policy, const char *ccu_name)
+{
+	struct bcm_lvm_en *enable = &ccu_policy->enable;
+	struct bcm_policy_ctl *control;
+
+	if (!bit_posn_valid(enable->bit, "policy enable", ccu_name))
+		return false;
+
+	control = &ccu_policy->control;
+	if (!bit_posn_valid(control->go_bit, "policy control GO", ccu_name))
+		return false;
+
+	if (!bit_posn_valid(control->atl_bit, "policy control ATL", ccu_name))
+		return false;
+
+	if (!bit_posn_valid(control->ac_bit, "policy control AC", ccu_name))
+		return false;
+
+	return true;
+}
+
+static bool policy_valid(struct bcm_clk_policy *policy, const char *clock_name)
+{
+	if (!bit_posn_valid(policy->bit, "policy", clock_name))
+		return false;
+
+	return true;
+}
+
 /*
  * All gates, if defined, have a status bit, and for hardware-only
  * gates, that's it.  Gates that can be software controlled also
@@ -311,6 +376,7 @@ static bool
 peri_clk_data_valid(struct kona_clk *bcm_clk)
 {
 	struct peri_clk_data *peri;
+	struct bcm_clk_policy *policy;
 	struct bcm_clk_gate *gate;
 	struct bcm_clk_sel *sel;
 	struct bcm_clk_div *div;
@@ -330,6 +396,11 @@ peri_clk_data_valid(struct kona_clk *bcm_clk)
 
 	peri = bcm_clk->peri;
 	name = bcm_clk->init_data.name;
+
+	policy = &peri->policy;
+	if (policy_exists(policy) && !policy_valid(policy, name))
+		return false;
+
 	gate = &peri->gate;
 	if (gate_exists(gate) && !gate_valid(gate, "gate", name))
 		return false;
@@ -678,6 +749,21 @@ static void kona_ccu_teardown(struct ccu_data *ccu)
 	ccu->base = NULL;
 }
 
+static bool ccu_data_valid(struct ccu_data *ccu)
+{
+	struct ccu_policy *ccu_policy;
+
+	if (!ccu_data_offsets_valid(ccu))
+		return false;
+
+	ccu_policy = &ccu->policy;
+	if (ccu_policy_exists(ccu_policy))
+		if (!ccu_policy_valid(ccu_policy, ccu->name))
+			return false;
+
+	return true;
+}
+
 /*
  * Set up a CCU.  Call the provided ccu_clks_setup callback to
  * initialize the array of clocks provided by the CCU.
@@ -717,6 +803,12 @@ void __init kona_dt_ccu_setup(struct ccu_data *ccu,
 	}
 
 	ccu->range = (u32)range;
+
+	if (!ccu_data_valid(ccu)) {
+		pr_err("%s: ccu data not valid for %s\n", __func__, node->name);
+		goto out_err;
+	}
+
 	ccu->base = ioremap(res.start, ccu->range);
 	if (!ccu->base) {
 		pr_err("%s: unable to map CCU registers for %s\n", __func__,
diff --git a/drivers/clk/bcm/clk-kona.c b/drivers/clk/bcm/clk-kona.c
index 5c0dc5b..bf9661c 100644
--- a/drivers/clk/bcm/clk-kona.c
+++ b/drivers/clk/bcm/clk-kona.c
@@ -16,6 +16,14 @@
 
 #include <linux/delay.h>
 
+/*
+ * "Policies" affect the frequencies of bus clocks provided by a
+ * CCU.  (I believe these polices are named "Deep Sleep", "Economy",
+ * "Normal", and "Turbo".)  A lower policy number has lower power
+ * consumption, and policy 2 is the default.
+ */
+#define CCU_POLICY_COUNT	4
+
 #define CCU_ACCESS_PASSWORD      0xA5A500
 #define CLK_GATE_DELAY_LOOP      2000
 
@@ -213,6 +221,148 @@ __ccu_wait_bit(struct ccu_data *ccu, u32 reg_offset, u32 bit, bool want)
 	return false;
 }
 
+/* Policy operations */
+
+static bool __ccu_policy_engine_start(struct ccu_data *ccu, bool sync)
+{
+	struct bcm_policy_ctl *control = &ccu->policy.control;
+	u32 offset;
+	u32 go_bit;
+	u32 mask;
+	bool ret;
+
+	/* If we don't need to control policy for this CCU, we're done. */
+	if (!policy_ctl_exists(control))
+		return true;
+
+	offset = control->offset;
+	go_bit = control->go_bit;
+
+	/* Ensure we're not busy before we start */
+	ret = __ccu_wait_bit(ccu, offset, go_bit, false);
+	if (!ret) {
+		pr_err("%s: ccu %s policy engine wouldn't go idle\n",
+			__func__, ccu->name);
+		return false;
+	}
+
+	/*
+	 * If it's a synchronous request, we'll wait for the voltage
+	 * and frequency of the active load to stabilize before
+	 * returning.  To do this we select the active load by
+	 * setting the ATL bit.
+	 *
+	 * An asynchronous request instead ramps the voltage in the
+	 * background, and when that process stabilizes, the target
+	 * load is copied to the active load and the CCU frequency
+	 * is switched.  We do this by selecting the target load
+	 * (ATL bit clear) and setting the request auto-copy (AC bit
+	 * set).
+	 *
+	 * Note, we do NOT read-modify-write this register.
+	 */
+	mask = (u32)1 << go_bit;
+	if (sync)
+		mask |= 1 << control->atl_bit;
+	else
+		mask |= 1 << control->ac_bit;
+	__ccu_write(ccu, offset, mask);
+
+	/* Wait for indication that operation is complete. */
+	ret = __ccu_wait_bit(ccu, offset, go_bit, false);
+	if (!ret)
+		pr_err("%s: ccu %s policy engine never started\n",
+			__func__, ccu->name);
+
+	return ret;
+}
+
+static bool __ccu_policy_engine_stop(struct ccu_data *ccu)
+{
+	struct bcm_lvm_en *enable = &ccu->policy.enable;
+	u32 offset;
+	u32 enable_bit;
+	bool ret;
+
+	/* If we don't need to control policy for this CCU, we're done. */
+	if (!policy_lvm_en_exists(enable))
+		return true;
+
+	/* Ensure we're not busy before we start */
+	offset = enable->offset;
+	enable_bit = enable->bit;
+	ret = __ccu_wait_bit(ccu, offset, enable_bit, false);
+	if (!ret) {
+		pr_err("%s: ccu %s policy engine already stopped\n",
+			__func__, ccu->name);
+		return false;
+	}
+
+	/* Now set the bit to stop the engine (NO read-modify-write) */
+	__ccu_write(ccu, offset, (u32)1 << enable_bit);
+
+	/* Wait for indication that it has stopped. */
+	ret = __ccu_wait_bit(ccu, offset, enable_bit, false);
+	if (!ret)
+		pr_err("%s: ccu %s policy engine never stopped\n",
+			__func__, ccu->name);
+
+	return ret;
+}
+
+/*
+ * A CCU has four operating conditions ("policies"), and some clocks
+ * can be disabled or enabled based on which policy is currently in
+ * effect.  Such clocks have a bit in a "policy mask" register for
+ * each policy indicating whether the clock is enabled for that
+ * policy or not.  The bit position for a clock is the same for all
+ * four registers, and the 32-bit registers are at consecutive
+ * addresses.
+ */
+static bool policy_init(struct ccu_data *ccu, struct bcm_clk_policy *policy)
+{
+	u32 offset;
+	u32 mask;
+	int i;
+	bool ret;
+
+	if (!policy_exists(policy))
+		return true;
+
+	/*
+	 * We need to stop the CCU policy engine to allow update
+	 * of our policy bits.
+	 */
+	if (!__ccu_policy_engine_stop(ccu)) {
+		pr_err("%s: unable to stop CCU %s policy engine\n",
+			__func__, ccu->name);
+		return false;
+	}
+
+	/*
+	 * For now, if a clock defines its policy bit we just mark
+	 * it "enabled" for all four policies.
+	 */
+	offset = policy->offset;
+	mask = (u32)1 << policy->bit;
+	for (i = 0; i < CCU_POLICY_COUNT; i++) {
+		u32 reg_val;
+
+		reg_val = __ccu_read(ccu, offset);
+		reg_val |= mask;
+		__ccu_write(ccu, offset, reg_val);
+		offset += sizeof(u32);
+	}
+
+	/* We're done updating; fire up the policy engine again. */
+	ret = __ccu_policy_engine_start(ccu, true);
+	if (!ret)
+		pr_err("%s: unable to restart CCU %s policy engine\n",
+			__func__, ccu->name);
+
+	return ret;
+}
+
 /* Gate operations */
 
 /* Determine whether a clock is gated.  CCU lock must be held.  */
@@ -970,6 +1120,11 @@ static bool __peri_clk_init(struct kona_clk *bcm_clk)
 
 	BUG_ON(bcm_clk->type != bcm_clk_peri);
 
+	if (!policy_init(ccu, &peri->policy)) {
+		pr_err("%s: error initializing policy for %s\n",
+			__func__, name);
+		return false;
+	}
 	if (!gate_init(ccu, &peri->gate)) {
 		pr_err("%s: error initializing gate for %s\n", __func__, name);
 		return false;
diff --git a/drivers/clk/bcm/clk-kona.h b/drivers/clk/bcm/clk-kona.h
index fba2740..c390ca4 100644
--- a/drivers/clk/bcm/clk-kona.h
+++ b/drivers/clk/bcm/clk-kona.h
@@ -43,8 +43,14 @@
 #define FLAG_FLIP(obj, type, flag)	((obj)->flags ^= FLAG(type, flag))
 #define FLAG_TEST(obj, type, flag)	(!!((obj)->flags & FLAG(type, flag)))
 
+/* CCU field state tests */
+
+#define ccu_policy_exists(ccu_policy)	((ccu_policy)->enable.offset != 0)
+
 /* Clock field state tests */
 
+#define policy_exists(policy)		((policy)->offset != 0)
+
 #define gate_exists(gate)		FLAG_TEST(gate, GATE, EXISTS)
 #define gate_is_enabled(gate)		FLAG_TEST(gate, GATE, ENABLED)
 #define gate_is_hw_controllable(gate)	FLAG_TEST(gate, GATE, HW)
@@ -62,6 +68,9 @@
 #define selector_exists(sel)		((sel)->width != 0)
 #define trigger_exists(trig)		FLAG_TEST(trig, TRIG, EXISTS)
 
+#define policy_lvm_en_exists(enable)	((enable)->offset != 0)
+#define policy_ctl_exists(control)	((control)->offset != 0)
+
 /* Clock type, used to tell common block what it's part of */
 enum bcm_clk_type {
 	bcm_clk_none,		/* undefined clock type */
@@ -71,6 +80,27 @@ enum bcm_clk_type {
 };
 
 /*
+ * CCU policy control for clocks.  Clocks can be enabled or disabled
+ * based on the CCU policy in effect.  One bit in each policy mask
+ * register (one per CCU policy) represents whether the clock is
+ * enabled when that policy is effect or not.  The CCU policy engine
+ * must be stopped to update these bits, and must be restarted again
+ * afterward.
+ */
+struct bcm_clk_policy {
+	u32 offset;		/* first policy mask register offset */
+	u32 bit;		/* bit used in all mask registers */
+};
+
+/* Policy initialization macro */
+
+#define POLICY(_offset, _bit)						\
+	{								\
+		.offset = (_offset),					\
+		.bit = (_bit),						\
+	}
+
+/*
  * Gating control and status is managed by a 32-bit gate register.
  *
  * There are several types of gating available:
@@ -340,6 +370,7 @@ struct bcm_clk_trig {
 	}
 
 struct peri_clk_data {
+	struct bcm_clk_policy policy;
 	struct bcm_clk_gate gate;
 	struct bcm_clk_trig pre_trig;
 	struct bcm_clk_div pre_div;
@@ -378,6 +409,45 @@ struct kona_clk {
 #define LAST_KONA_CLK	{ .type = bcm_clk_none }
 
 /*
+ * CCU policy control.  To enable software update of the policy
+ * tables the CCU policy engine must be stopped by setting the
+ * software update enable bit (LVM_EN).  After an update the engine
+ * is restarted using the GO bit and either the GO_ATL or GO_AC bit.
+ */
+struct bcm_lvm_en {
+	u32 offset;		/* LVM_EN register offset */
+	u32 bit;		/* POLICY_CONFIG_EN bit in register */
+};
+
+/* Policy enable initialization macro */
+#define CCU_LVM_EN(_offset, _bit)					\
+	{								\
+		.offset = (_offset),					\
+		.bit = (_bit),						\
+	}
+
+struct bcm_policy_ctl {
+	u32 offset;		/* POLICY_CTL register offset */
+	u32 go_bit;
+	u32 atl_bit;		/* GO, GO_ATL, and GO_AC bits */
+	u32 ac_bit;
+};
+
+/* Policy control initialization macro */
+#define CCU_POLICY_CTL(_offset, _go_bit, _ac_bit, _atl_bit)		\
+	{								\
+		.offset = (_offset),					\
+		.go_bit = (_go_bit),					\
+		.ac_bit = (_ac_bit),					\
+		.atl_bit = (_atl_bit),					\
+	}
+
+struct ccu_policy {
+	struct bcm_lvm_en enable;
+	struct bcm_policy_ctl control;
+};
+
+/*
  * Each CCU defines a mapped area of memory containing registers
  * used to manage clocks implemented by the CCU.  Access to memory
  * within the CCU's space is serialized by a spinlock.  Before any
@@ -390,6 +460,7 @@ struct ccu_data {
 	void __iomem *base;	/* base of mapped address space */
 	spinlock_t lock;	/* serialization lock */
 	bool write_enabled;	/* write access is currently enabled */
+	struct ccu_policy policy;
 	struct list_head links;	/* for ccu_list */
 	struct device_node *node;
 	struct clk_onecell_data clk_data;
-- 
1.7.9.5

