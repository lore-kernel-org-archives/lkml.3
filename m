Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136Ab3KOPMR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 10:12:17 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:48280 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190Ab3KOPMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 10:12:10 -0500
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>, <paul@pwsan.com>
CC: <rnayak@ti.com>, <khilman@linaro.org>, <t-kristo@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Nishanth Menon <nm@ti.com>
Subject: [PATCH] ARM: OMAP4+: pm_debug: provide more visibility into suspend failure
Date: Fri, 15 Nov 2013 09:11:42 -0600
Message-ID: <1384528302-31730-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Traditionally on OMAP4+ systems, with complete data properly populated,
we should be able to track down which device prevented the power domain
from transitioning to low power state. This is rather trivial is the
powerdomain to clockdomain to list of clock status registers were easily
accessible. However, it is not. we have linkage from clk->clkdm, and
hwmod to clkdm, however going from clkdm to clk status involves a search
for matches :(.

Previously, we just get:
Powerdomain (XYZ) didn't enter target state 1

Now, we get:
Powerdomain (XYZ) didn't enter target state 1
	XYZ: s/w flags(HWSUP_SWSUP HWSUP_ENABLED(int) ) h/w control(enable_auto )
		module-X: functional

This simplifies our debug when hwmod is properly populated with every
device in the SoC and when status bits are properly identified. However,
the alternative to doing this is to replicate actual h/w data in some
other form which duplicates existing infrastructure for the same.

Signed-off-by: Nishanth Menon <nm@ti.com>
---

Traditionally, we have add solutions in production kernel that
duplicated data such as:
3.0: https://android.googlesource.com/kernel/omap.git/+/android-omap-tuna-3.0-jb-mr2/arch/arm/mach-omap2/prcm-debug.c
3.4: http://git.omapzoom.org/?p=kernel/omap.git;a=blob;f=arch/arm/mach-omap2/prcm-54xx-debug_data.c;h=26d9b1e74368ec387db86fde6208e37ffeb95d5c;hb=p-linux-omap-3.4

Which for obvious reasons dont make sense in an upstream kernel - the
rationale for duplicated data was the in-development state of pm code
which needed cross verification as well.

The code is a bit dirty, but then, this is just an RFC to see if folks
are interested in this feature. If folks think this actually adds
value, then we can split this up properly and control the prints with
some debugfs control flag (instead of spamming every single time).
we could discuss even on how to make this prettier, do checkpatch,
split into a proper series etc.. just *if* folks think it is worth the
work..

Sample logs (using TI vendor kernel):
DRA7-evm: http://pastebin.mozilla.org/3606008
OMAP5-uEVM: http://pastebin.mozilla.org/3606015

Obviously, could be extended for more TI platforms as well since it
uses the mach-omap2 frameworks - but we could instead decide not to
develop this further till we cleanup hwmod instead of adding new usage
of the same and make that transition harder.. over to folks for comments..

Applies on kernel tag v3.12

 arch/arm/mach-omap2/clockdomain.c |   23 ++++++++++
 arch/arm/mach-omap2/clockdomain.h |    5 +++
 arch/arm/mach-omap2/cminst44xx.c  |   40 +++++++++++++++++
 arch/arm/mach-omap2/pm-debug.c    |   85 +++++++++++++++++++++++++++++++++++++
 arch/arm/mach-omap2/pm.h          |    6 +++
 arch/arm/mach-omap2/pm44xx.c      |    1 +
 arch/arm/mach-omap2/powerdomain.c |    3 +-
 7 files changed, 162 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/clockdomain.c b/arch/arm/mach-omap2/clockdomain.c
index 2da3b5e..6de3860 100644
--- a/arch/arm/mach-omap2/clockdomain.c
+++ b/arch/arm/mach-omap2/clockdomain.c
@@ -1295,3 +1295,26 @@ int clkdm_hwmod_disable(struct clockdomain *clkdm, struct omap_hwmod *oh)
 	return 0;
 }
 
+int clkdm_control_status(struct clockdomain *clkdm, bool *disable_auto, bool *force_sleep, bool *force_wakeup, bool *enable_auto)
+{
+	/* The clkdm attribute does not exist yet prior OMAP4 */
+	if (cpu_is_omap24xx() || cpu_is_omap34xx())
+		return 0;
+
+	if (!clkdm || !arch_clkdm || !arch_clkdm->clkdm_control_status || !disable_auto || !force_sleep || !force_wakeup || !enable_auto)
+		return -EINVAL;
+
+	return arch_clkdm->clkdm_control_status(clkdm, disable_auto, force_sleep, force_wakeup, enable_auto);
+}
+
+int clkdm_current_status(struct clockdomain *clkdm, struct omap_hwmod *oh, bool *functional, bool *in_transition, bool *if_idle, bool *disabled)
+{
+	/* The clkdm attribute does not exist yet prior OMAP4 */
+	if (cpu_is_omap24xx() || cpu_is_omap34xx())
+		return 0;
+
+	if (!clkdm || !oh || !arch_clkdm || !arch_clkdm->clkdm_current_status || !functional || !in_transition || !if_idle || !disabled)
+		return -EINVAL;
+
+	return arch_clkdm->clkdm_current_status(clkdm, oh, functional, in_transition, if_idle, disabled);
+}
diff --git a/arch/arm/mach-omap2/clockdomain.h b/arch/arm/mach-omap2/clockdomain.h
index 4b03394..1048baa 100644
--- a/arch/arm/mach-omap2/clockdomain.h
+++ b/arch/arm/mach-omap2/clockdomain.h
@@ -172,8 +172,13 @@ struct clkdm_ops {
 	void	(*clkdm_deny_idle)(struct clockdomain *clkdm);
 	int	(*clkdm_clk_enable)(struct clockdomain *clkdm);
 	int	(*clkdm_clk_disable)(struct clockdomain *clkdm);
+	int	(*clkdm_control_status)(struct clockdomain *clkdm, bool *disable_auto, bool *force_sleep, bool *force_wakeup, bool *enable_auto);
+	int	(*clkdm_current_status)(struct clockdomain *clkdm, struct omap_hwmod *oh, bool *functional, bool *intransition, bool *if_idle, bool *disabled);
 };
 
+int clkdm_control_status(struct clockdomain *clkdm, bool *disable_auto, bool *force_sleep, bool *force_wakeup, bool *enable_auto);
+int clkdm_current_status(struct clockdomain *clkdm, struct omap_hwmod *oh, bool *functional, bool *intransition, bool *if_idle, bool *disabled);
+
 int clkdm_register_platform_funcs(struct clkdm_ops *co);
 int clkdm_register_autodeps(struct clkdm_autodep *ia);
 int clkdm_register_clkdms(struct clockdomain **c);
diff --git a/arch/arm/mach-omap2/cminst44xx.c b/arch/arm/mach-omap2/cminst44xx.c
index f0290f5..07f61e1 100644
--- a/arch/arm/mach-omap2/cminst44xx.c
+++ b/arch/arm/mach-omap2/cminst44xx.c
@@ -467,6 +467,44 @@ static int omap4_clkdm_clk_disable(struct clockdomain *clkdm)
 	return 0;
 }
 
+static int omap4_clkdm_control_status(struct clockdomain *clkdm, bool *disable_auto, bool *force_sleep, bool *force_wakeup, bool *enable_auto)
+{
+	u32 v;
+
+	if (!clkdm->prcm_partition)
+		return -EINVAL;
+	v = omap4_cminst_read_inst_reg(clkdm->prcm_partition, clkdm->cm_inst, clkdm->clkdm_offs + OMAP4_CM_CLKSTCTRL);
+	v &= OMAP4430_CLKTRCTRL_MASK;
+	v >>= OMAP4430_CLKTRCTRL_SHIFT;
+
+	*enable_auto = (v  == OMAP34XX_CLKSTCTRL_ENABLE_AUTO) ? true : false;
+	*force_wakeup = (v  == OMAP34XX_CLKSTCTRL_FORCE_WAKEUP) ? true : false;
+	*force_sleep = (v  == OMAP34XX_CLKSTCTRL_FORCE_SLEEP) ? true : false;
+	*disable_auto = (v  == OMAP34XX_CLKSTCTRL_DISABLE_AUTO) ? true : false;
+
+	return 0;
+}
+
+static int omap4_clkdm_current_status(struct clockdomain *clkdm, struct omap_hwmod *oh, bool *functional, bool *intransition, bool *if_idle, bool *disabled)
+{
+	u32 idlest = 0;
+	u16 clkctrl_offs = oh->prcm.omap4.clkctrl_offs;
+
+	if (!clkdm->prcm_partition || !clkctrl_offs)
+		return -EINVAL;
+
+	idlest = _clkctrl_idlest(clkdm->prcm_partition, clkdm->cm_inst, clkdm->clkdm_offs, clkctrl_offs);
+	if (idlest  == CLKCTRL_IDLEST_FUNCTIONAL)
+		*functional = true;
+	else if (idlest  == CLKCTRL_IDLEST_INTRANSITION)
+		*intransition = true;
+	else if (idlest  == CLKCTRL_IDLEST_INTERFACE_IDLE)
+		*if_idle = true;
+	else if (idlest  == CLKCTRL_IDLEST_DISABLED)
+		*disabled = true;
+	return 0;
+}
+
 struct clkdm_ops omap4_clkdm_operations = {
 	.clkdm_add_wkdep	= omap4_clkdm_add_wkup_sleep_dep,
 	.clkdm_del_wkdep	= omap4_clkdm_del_wkup_sleep_dep,
@@ -482,4 +520,6 @@ struct clkdm_ops omap4_clkdm_operations = {
 	.clkdm_deny_idle	= omap4_clkdm_deny_idle,
 	.clkdm_clk_enable	= omap4_clkdm_clk_enable,
 	.clkdm_clk_disable	= omap4_clkdm_clk_disable,
+	.clkdm_control_status	= omap4_clkdm_control_status,
+	.clkdm_current_status	= omap4_clkdm_current_status,
 };
diff --git a/arch/arm/mach-omap2/pm-debug.c b/arch/arm/mach-omap2/pm-debug.c
index 0b33986..0ae6437 100644
--- a/arch/arm/mach-omap2/pm-debug.c
+++ b/arch/arm/mach-omap2/pm-debug.c
@@ -39,6 +39,91 @@
 
 u32 enable_off_mode;
 
+static int _check_hwmod(struct omap_hwmod *oh, void *data)
+{
+	struct clockdomain *clkdm = data;
+	bool functional = false;
+	bool in_transition = false;
+	bool if_idle = false;
+	bool disabled = false;
+	char *state = "unknown";
+	bool print = true;
+
+	/* Skip if we dont have clkdm match */
+	if (clkdm != oh->clkdm)
+		return 0;
+
+	if (!clkdm_current_status(clkdm, oh, &functional, &in_transition, &if_idle, &disabled)) {
+		if (disabled) {
+			print = false;
+			state = "disabled";
+		} else {
+			if (functional)
+				state = "functional";
+			else if (in_transition)
+				state = "stuck in transition";
+			else if (if_idle)
+				state = "i/f clk idled - if iclk = fclk for this module, consider as disabled";
+		}
+	}
+
+	if (print)
+		pr_err("\t\t%s: %s\n", oh->name, state);
+
+	return 0;
+}
+
+static int _check_clkdm_state(struct powerdomain *pwrdm, struct clockdomain *clkdm)
+{
+	char sflags[255] = {0};
+	char hflags[255] = {0};
+	bool disable_auto = false;
+	bool force_sleep = false;
+	bool force_wakeup = false;
+	bool enable_auto = false;
+
+
+	if (clkdm->flags & CLKDM_CAN_HWSUP_SWSUP)
+		strncat(sflags, "HWSUP_SWSUP ", sizeof(sflags));
+
+	else if (clkdm->flags & CLKDM_CAN_HWSUP)
+		strncat(sflags, "HWSUP ", sizeof(sflags));
+	else if (clkdm->flags & CLKDM_CAN_SWSUP)
+		strncat(sflags, "SWSUP ", sizeof(sflags));
+	if (clkdm->flags & CLKDM_NO_AUTODEPS)
+		strncat(sflags, "NO_AUTODEPS ", sizeof(sflags));
+	if (clkdm->flags & CLKDM_ACTIVE_WITH_MPU)
+		strncat(sflags, "ACTIVE_WITH_MPU ", sizeof(sflags));
+	if (clkdm->flags & CLKDM_MISSING_IDLE_REPORTING)
+		strncat(sflags, "MISSING_IDLE_REPORTING ", sizeof(sflags));
+	if (clkdm->_flags & _CLKDM_FLAG_HWSUP_ENABLED)
+		strncat(sflags, "HWSUP_ENABLED(int) ", sizeof(sflags));
+
+	if (!clkdm_control_status(clkdm, &disable_auto, &force_sleep, &force_wakeup, &enable_auto) ){
+		if (disable_auto)
+			strncat(hflags, "disable_auto ", sizeof(hflags));
+		if (enable_auto)
+			strncat(hflags, "enable_auto ", sizeof(hflags));
+		if (force_sleep)
+			strncat(hflags, "force_sleep ", sizeof(hflags));
+		if (force_wakeup)
+			strncat(hflags, "force_wakeup ", sizeof(hflags));
+	}
+
+	pr_info("\t %s: s/w flags(%s) h/w control(%s)\n",
+		clkdm->name, sflags, hflags);
+	/* Need to check per hwmod for match */
+	omap_hwmod_for_each(_check_hwmod, clkdm);
+
+
+	return 0;
+}
+
+void pm_debug_check_pwrdm(struct powerdomain *pwrdm)
+{
+	pwrdm_for_each_clkdm(pwrdm,_check_clkdm_state);
+}
+
 #ifdef CONFIG_DEBUG_FS
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
diff --git a/arch/arm/mach-omap2/pm.h b/arch/arm/mach-omap2/pm.h
index 7bdd22a..6349bb1 100644
--- a/arch/arm/mach-omap2/pm.h
+++ b/arch/arm/mach-omap2/pm.h
@@ -147,4 +147,10 @@ static inline void omap_pm_get_oscillator(u32 *tstart, u32 *tshut) { *tstart = *
 static inline void omap_pm_setup_sr_i2c_pcb_length(u32 mm) { }
 #endif
 
+#ifdef CONFIG_PM_DEBUG
+void pm_debug_check_pwrdm(struct powerdomain *pwrdm);
+#else
+static inline void pm_debug_check_pwrdm(struct powerdomain *pwrdm) { };
+#endif
+
 #endif
diff --git a/arch/arm/mach-omap2/pm44xx.c b/arch/arm/mach-omap2/pm44xx.c
index 82f06989..f3ee79d 100644
--- a/arch/arm/mach-omap2/pm44xx.c
+++ b/arch/arm/mach-omap2/pm44xx.c
@@ -72,6 +72,7 @@ static int omap4_pm_suspend(void)
 		if (state > pwrst->next_state) {
 			pr_info("Powerdomain (%s) didn't enter target state %d\n",
 				pwrst->pwrdm->name, pwrst->next_state);
+			pm_debug_check_pwrdm(pwrst->pwrdm);
 			ret = -1;
 		}
 		omap_set_pwrdm_state(pwrst->pwrdm, pwrst->saved_state);
diff --git a/arch/arm/mach-omap2/powerdomain.c b/arch/arm/mach-omap2/powerdomain.c
index e233dfc..73b0be3 100644
--- a/arch/arm/mach-omap2/powerdomain.c
+++ b/arch/arm/mach-omap2/powerdomain.c
@@ -544,7 +544,8 @@ int pwrdm_for_each_clkdm(struct powerdomain *pwrdm,
 		return -EINVAL;
 
 	for (i = 0; i < PWRDM_MAX_CLKDMS && !ret; i++)
-		ret = (*fn)(pwrdm, pwrdm->pwrdm_clkdms[i]);
+		if (pwrdm->pwrdm_clkdms[i])
+			ret = (*fn)(pwrdm, pwrdm->pwrdm_clkdms[i]);
 
 	return ret;
 }
-- 
1.7.9.5

