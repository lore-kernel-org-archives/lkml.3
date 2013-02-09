Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947646Ab3BIBIq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 20:08:46 -0500
Received: from mail-vc0-f175.google.com ([209.85.220.175]:41729 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947527Ab3BIBIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 20:08:32 -0500
From: Len Brown <lenb@kernel.org>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Daniel Lezcano <daniel.lezcano@linaro.org>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 02/16] Replace the flag by a simple global boolean in the cpuidle.c. That will allow to cleanup the rest of the code right after, because the ops won't make sense.
Date: Fri,  8 Feb 2013 20:08:06 -0500
Message-Id: <5af4a21c6efd270a334202fb1fc4a347ea4624e3.1360371180.git.len.brown@intel.com>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
In-Reply-To: <1360372100-28482-1-git-send-email-lenb@kernel.org>
References: <1360372100-28482-1-git-send-email-lenb@kernel.org>
In-Reply-To: <b1beab48f6148d50fee4a56d741cc3168fe1b995.1360371180.git.len.brown@intel.com>
References: <b1beab48f6148d50fee4a56d741cc3168fe1b995.1360371180.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Lezcano <daniel.lezcano@linaro.org>

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Acked-by: Sekhar Nori <nsekhar@ti.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 arch/arm/mach-davinci/cpuidle.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/arch/arm/mach-davinci/cpuidle.c b/arch/arm/mach-davinci/cpuidle.c
index 9107691..5fbd470 100644
--- a/arch/arm/mach-davinci/cpuidle.c
+++ b/arch/arm/mach-davinci/cpuidle.c
@@ -26,8 +26,8 @@
 #define DAVINCI_CPUIDLE_MAX_STATES	2
 
 struct davinci_ops {
-	void (*enter) (u32 flags);
-	void (*exit) (u32 flags);
+	void (*enter) (void);
+	void (*exit) (void);
 	u32 flags;
 };
 
@@ -40,20 +40,17 @@ static int davinci_enter_idle(struct cpuidle_device *dev,
 	struct davinci_ops *ops = cpuidle_get_statedata(state_usage);
 
 	if (ops && ops->enter)
-		ops->enter(ops->flags);
+		ops->enter();
 
 	index = cpuidle_wrap_enter(dev,	drv, index,
 				arm_cpuidle_simple_enter);
 
 	if (ops && ops->exit)
-		ops->exit(ops->flags);
+		ops->exit();
 
 	return index;
 }
 
-/* fields in davinci_ops.flags */
-#define DAVINCI_CPUIDLE_FLAGS_DDR2_PWDN	BIT(0)
-
 static struct cpuidle_driver davinci_idle_driver = {
 	.name			= "cpuidle-davinci",
 	.owner			= THIS_MODULE,
@@ -72,6 +69,7 @@ static struct cpuidle_driver davinci_idle_driver = {
 
 static DEFINE_PER_CPU(struct cpuidle_device, davinci_cpuidle_device);
 static void __iomem *ddr2_reg_base;
+static bool ddr2_pdown;
 
 static void davinci_save_ddr_power(int enter, bool pdown)
 {
@@ -92,14 +90,14 @@ static void davinci_save_ddr_power(int enter, bool pdown)
 	__raw_writel(val, ddr2_reg_base + DDR2_SDRCR_OFFSET);
 }
 
-static void davinci_c2state_enter(u32 flags)
+static void davinci_c2state_enter(void)
 {
-	davinci_save_ddr_power(1, !!(flags & DAVINCI_CPUIDLE_FLAGS_DDR2_PWDN));
+	davinci_save_ddr_power(1, ddr2_pdown);
 }
 
-static void davinci_c2state_exit(u32 flags)
+static void davinci_c2state_exit(void)
 {
-	davinci_save_ddr_power(0, !!(flags & DAVINCI_CPUIDLE_FLAGS_DDR2_PWDN));
+	davinci_save_ddr_power(0, ddr2_pdown);
 }
 
 static struct davinci_ops davinci_states[DAVINCI_CPUIDLE_MAX_STATES] = {
@@ -124,8 +122,7 @@ static int __init davinci_cpuidle_probe(struct platform_device *pdev)
 
 	ddr2_reg_base = pdata->ddr2_ctlr_base;
 
-	if (pdata->ddr2_pdown)
-		davinci_states[1].flags |= DAVINCI_CPUIDLE_FLAGS_DDR2_PWDN;
+	ddr2_pdown = pdata->ddr2_pdown;
 	cpuidle_set_statedata(&device->states_usage[1], &davinci_states[1]);
 
 	device->state_count = DAVINCI_CPUIDLE_MAX_STATES;
-- 
1.8.1.3.535.ga923c31

