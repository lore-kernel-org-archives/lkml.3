Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947630Ab3BIBIo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 20:08:44 -0500
Received: from mail-vc0-f181.google.com ([209.85.220.181]:48979 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947580Ab3BIBIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 20:08:37 -0500
From: Len Brown <lenb@kernel.org>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Daniel Lezcano <daniel.lezcano@linaro.org>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 04/16] davinci: cpuidle - remove the ops
Date: Fri,  8 Feb 2013 20:08:08 -0500
Message-Id: <36ce8d4f5fecc20c2dfb08f24fe01c5eb81f6245.1360371180.git.len.brown@intel.com>
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

With one function handling the idle state and a single variable,
the usage of the davinci_ops is overkill.

This patch removes these ops and simplify the code.

Furthermore, the 'driver_data' field is no longer used, we have
1 of the 3 remaining user of this field removed.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Acked-by: Sekhar Nori <nsekhar@ti.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 arch/arm/mach-davinci/cpuidle.c | 33 ++-------------------------------
 1 file changed, 2 insertions(+), 31 deletions(-)

diff --git a/arch/arm/mach-davinci/cpuidle.c b/arch/arm/mach-davinci/cpuidle.c
index 697febe..5e430bf 100644
--- a/arch/arm/mach-davinci/cpuidle.c
+++ b/arch/arm/mach-davinci/cpuidle.c
@@ -25,12 +25,6 @@
 
 #define DAVINCI_CPUIDLE_MAX_STATES	2
 
-struct davinci_ops {
-	void (*enter) (void);
-	void (*exit) (void);
-	u32 flags;
-};
-
 static DEFINE_PER_CPU(struct cpuidle_device, davinci_cpuidle_device);
 static void __iomem *ddr2_reg_base;
 static bool ddr2_pdown;
@@ -54,39 +48,17 @@ static void davinci_save_ddr_power(int enter, bool pdown)
 	__raw_writel(val, ddr2_reg_base + DDR2_SDRCR_OFFSET);
 }
 
-static void davinci_c2state_enter(void)
-{
-	davinci_save_ddr_power(1, ddr2_pdown);
-}
-
-static void davinci_c2state_exit(void)
-{
-	davinci_save_ddr_power(0, ddr2_pdown);
-}
-
-static struct davinci_ops davinci_states[DAVINCI_CPUIDLE_MAX_STATES] = {
-	[1] = {
-		.enter	= davinci_c2state_enter,
-		.exit	= davinci_c2state_exit,
-	},
-};
-
 /* Actual code that puts the SoC in different idle states */
 static int davinci_enter_idle(struct cpuidle_device *dev,
 				struct cpuidle_driver *drv,
 						int index)
 {
-	struct cpuidle_state_usage *state_usage = &dev->states_usage[index];
-	struct davinci_ops *ops = cpuidle_get_statedata(state_usage);
-
-	if (ops && ops->enter)
-		ops->enter();
+	davinci_save_ddr_power(1, ddr2_pdown);
 
 	index = cpuidle_wrap_enter(dev,	drv, index,
 				arm_cpuidle_simple_enter);
 
-	if (ops && ops->exit)
-		ops->exit();
+	davinci_save_ddr_power(0, ddr2_pdown);
 
 	return index;
 }
@@ -123,7 +95,6 @@ static int __init davinci_cpuidle_probe(struct platform_device *pdev)
 	ddr2_reg_base = pdata->ddr2_ctlr_base;
 
 	ddr2_pdown = pdata->ddr2_pdown;
-	cpuidle_set_statedata(&device->states_usage[1], &davinci_states[1]);
 
 	device->state_count = DAVINCI_CPUIDLE_MAX_STATES;
 
-- 
1.8.1.3.535.ga923c31

