Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555AbaBUVgB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 16:36:01 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59497 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754768AbaBUVf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 16:35:58 -0500
Date: Fri, 21 Feb 2014 13:34:49 -0800
From: tip-bot for Nicolas Pitre <tipbot@zytor.com>
Message-ID: <tip-nr4mtbkkzf2oomaj85m24o7c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, nicolas.pitre@linaro.org,
        paul.burton@imgtec.com, preeti@linux.vnet.ibm.com, nico@linaro.org,
        tglx@linutronix.de, rjw@rjwysocki.net, daniel.lezcano@linaro.org,
        deepthi@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        nicolas.pitre@linaro.org, paul.burton@imgtec.com,
        preeti@linux.vnet.ibm.com, nico@linaro.org, rjw@rjwysocki.net,
        tglx@linutronix.de, daniel.lezcano@linaro.org,
        deepthi@linux.vnet.ibm.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] cpuidle/powernv:
  remove redundant cpuidle_idle_call()
Git-Commit-ID: 21ece92037fcc324d2e43dbd6b934983bfcd91cf
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  21ece92037fcc324d2e43dbd6b934983bfcd91cf
Gitweb:     http://git.kernel.org/tip/21ece92037fcc324d2e43dbd6b934983bfcd91cf
Author:     Nicolas Pitre <nicolas.pitre@linaro.org>
AuthorDate: Mon, 17 Feb 2014 10:59:29 -0500
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 21 Feb 2014 21:43:21 +0100

cpuidle/powernv: remove redundant cpuidle_idle_call()

The core idle loop now takes care of it. We need to add the runlatch
function calls to the idle routines which was earlier taken care of by
the arch specific idle routine.

Cc: Paul Burton <paul.burton@imgtec.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-pm@vger.kernel.org
Cc: linaro-kernel@lists.linaro.org
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Nicolas Pitre <nico@linaro.org>
Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Reviewed-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-nr4mtbkkzf2oomaj85m24o7c@git.kernel.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/powerpc/platforms/powernv/setup.c | 13 +------------
 drivers/cpuidle/cpuidle-powernv.c      |  5 +++++
 2 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/arch/powerpc/platforms/powernv/setup.c b/arch/powerpc/platforms/powernv/setup.c
index 110f4fb..81a7a0a 100644
--- a/arch/powerpc/platforms/powernv/setup.c
+++ b/arch/powerpc/platforms/powernv/setup.c
@@ -26,7 +26,6 @@
 #include <linux/of_fdt.h>
 #include <linux/interrupt.h>
 #include <linux/bug.h>
-#include <linux/cpuidle.h>
 #include <linux/pci.h>
 
 #include <asm/machdep.h>
@@ -225,16 +224,6 @@ static int __init pnv_probe(void)
 	return 1;
 }
 
-void powernv_idle(void)
-{
-	/* Hook to cpuidle framework if available, else
-	 * call on default platform idle code
-	 */
-	if (cpuidle_idle_call()) {
-		power7_idle();
-	}
-}
-
 define_machine(powernv) {
 	.name			= "PowerNV",
 	.probe			= pnv_probe,
@@ -244,7 +233,7 @@ define_machine(powernv) {
 	.show_cpuinfo		= pnv_show_cpuinfo,
 	.progress		= pnv_progress,
 	.machine_shutdown	= pnv_shutdown,
-	.power_save             = powernv_idle,
+	.power_save             = power7_idle,
 	.calibrate_decr		= generic_calibrate_decr,
 	.dma_set_mask		= pnv_dma_set_mask,
 #ifdef CONFIG_KEXEC
diff --git a/drivers/cpuidle/cpuidle-powernv.c b/drivers/cpuidle/cpuidle-powernv.c
index 78fd174..f48607c 100644
--- a/drivers/cpuidle/cpuidle-powernv.c
+++ b/drivers/cpuidle/cpuidle-powernv.c
@@ -14,6 +14,7 @@
 
 #include <asm/machdep.h>
 #include <asm/firmware.h>
+#include <asm/runlatch.h>
 
 struct cpuidle_driver powernv_idle_driver = {
 	.name             = "powernv_idle",
@@ -30,12 +31,14 @@ static int snooze_loop(struct cpuidle_device *dev,
 	local_irq_enable();
 	set_thread_flag(TIF_POLLING_NRFLAG);
 
+	ppc64_runlatch_off();
 	while (!need_resched()) {
 		HMT_low();
 		HMT_very_low();
 	}
 
 	HMT_medium();
+	ppc64_runlatch_on();
 	clear_thread_flag(TIF_POLLING_NRFLAG);
 	smp_mb();
 	return index;
@@ -45,7 +48,9 @@ static int nap_loop(struct cpuidle_device *dev,
 			struct cpuidle_driver *drv,
 			int index)
 {
+	ppc64_runlatch_off();
 	power7_idle();
+	ppc64_runlatch_on();
 	return index;
 }
 
