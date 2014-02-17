Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798AbaBQQAX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 11:00:23 -0500
Received: from relais.videotron.ca ([24.201.245.36]:50032 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbaBQQAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 11:00:17 -0500
Content-transfer-encoding: 7BIT
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Paul Burton <paul.burton@imgtec.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Subject: [PATCH 1/2] cpuidle/powernv: remove redundant cpuidle_idle_call()
Date: Mon, 17 Feb 2014 10:59:29 -0500
Message-id: <1392652770-19397-2-git-send-email-nicolas.pitre@linaro.org>
X-Mailer: git-send-email 1.8.4.108.g55ea5f6
In-reply-to: <1392652770-19397-1-git-send-email-nicolas.pitre@linaro.org>
References: <1392652770-19397-1-git-send-email-nicolas.pitre@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The core idle loop now takes care of it. We need to add the runlatch
function calls to the idle routines which was earlier taken care of by
the arch specific idle routine.

Signed-off-by: Nicolas Pitre <nico@linaro.org>
Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Reviewed-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/powerpc/platforms/powernv/setup.c | 13 +------------
 drivers/cpuidle/cpuidle-powernv.c      |  5 +++++
 2 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/arch/powerpc/platforms/powernv/setup.c b/arch/powerpc/platforms/powernv/setup.c
index 110f4fbd31..81a7a0a79b 100644
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
index 78fd174c57..f48607cd25 100644
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
 
-- 
1.8.4.108.g55ea5f6

