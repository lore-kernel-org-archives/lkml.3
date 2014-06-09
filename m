Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934605AbaFIXBH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 19:01:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57002 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933705AbaFIWpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 18:45:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Roger Quadros <rogerq@ti.com>, Kevin Hilman <khilman@linaro.org>,
        Tony Lindgren <tony@atomide.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCH 3.10 16/40] ARM: OMAP4: Fix the boot regression with CPU_IDLE enabled
Date: Mon,  9 Jun 2014 15:48:47 -0700
Message-Id: <20140609224839.726187262@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140609224839.127615063@linuxfoundation.org>
References: <20140609224839.127615063@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Santosh Shilimkar <santosh.shilimkar@ti.com>

commit 4b353a706a86598ba47307c47301c3c428b79e09 upstream.

On OMAP4 panda board, there have been several bug reports about boot
hang and lock-ups with CPU_IDLE enabled. The root cause of the issue
is missing interrupts while in idle state. Commit cb7094e8 {cpuidle / omap4 :
use CPUIDLE_FLAG_TIMER_STOP flag} moved the broadcast notifiers to common
code for right reasons but on OMAP4 which suffers from a nasty ROM code
bug with GIC, commit ff999b8a {ARM: OMAP4460: Workaround for ROM bug ..},
we loose interrupts which leads to issues like lock-up, hangs etc.

Patch reverts commit cb7094 {cpuidle / omap4 : use CPUIDLE_FLAG_TIMER_STOP
flag} and 54769d6 {cpuidle: OMAP4: remove timer broadcast initialization} to
avoid the issue. With this change, OMAP4 panda boards, the mentioned
issues are getting fixed. We no longer loose interrupts which was the cause
of the regression.

Fixes: cb7094e8 (cpuidle / omap4 : use CPUIDLE_FLAG_TIMER_STOP flag)
Fixes: ff999b8a (cpuidle: OMAP4: remove timer broadcast initialization)
Cc: Roger Quadros <rogerq@ti.com>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Reported-tested-by: Roger Quadros <rogerq@ti.com>
Reported-tested-by: Kevin Hilman <khilman@linaro.org>
Tested-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-omap2/cpuidle44xx.c |   25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

--- a/arch/arm/mach-omap2/cpuidle44xx.c
+++ b/arch/arm/mach-omap2/cpuidle44xx.c
@@ -14,6 +14,7 @@
 #include <linux/cpuidle.h>
 #include <linux/cpu_pm.h>
 #include <linux/export.h>
+#include <linux/clockchips.h>
 
 #include <asm/cpuidle.h>
 #include <asm/proc-fns.h>
@@ -80,6 +81,7 @@ static int omap_enter_idle_coupled(struc
 			int index)
 {
 	struct idle_statedata *cx = state_ptr + index;
+	int cpu_id = smp_processor_id();
 
 	/*
 	 * CPU0 has to wait and stay ON until CPU1 is OFF state.
@@ -104,6 +106,8 @@ static int omap_enter_idle_coupled(struc
 		}
 	}
 
+	clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &cpu_id);
+
 	/*
 	 * Call idle CPU PM enter notifier chain so that
 	 * VFP and per CPU interrupt context is saved.
@@ -147,6 +151,8 @@ static int omap_enter_idle_coupled(struc
 		(cx->mpu_logic_state == PWRDM_POWER_OFF))
 		cpu_cluster_pm_exit();
 
+	clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &cpu_id);
+
 fail:
 	cpuidle_coupled_parallel_barrier(dev, &abort_barrier);
 	cpu_done[dev->cpu] = false;
@@ -154,6 +160,16 @@ fail:
 	return index;
 }
 
+/*
+ * For each cpu, setup the broadcast timer because local timers
+ * stops for the states above C1.
+ */
+static void omap_setup_broadcast_timer(void *arg)
+{
+	int cpu = smp_processor_id();
+	clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ON, &cpu);
+}
+
 static struct cpuidle_driver omap4_idle_driver = {
 	.name				= "omap4_idle",
 	.owner				= THIS_MODULE,
@@ -171,8 +187,7 @@ static struct cpuidle_driver omap4_idle_
 			/* C2 - CPU0 OFF + CPU1 OFF + MPU CSWR */
 			.exit_latency = 328 + 440,
 			.target_residency = 960,
-			.flags = CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_COUPLED |
-			         CPUIDLE_FLAG_TIMER_STOP,
+			.flags = CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_COUPLED,
 			.enter = omap_enter_idle_coupled,
 			.name = "C2",
 			.desc = "CPUx OFF, MPUSS CSWR",
@@ -181,8 +196,7 @@ static struct cpuidle_driver omap4_idle_
 			/* C3 - CPU0 OFF + CPU1 OFF + MPU OSWR */
 			.exit_latency = 460 + 518,
 			.target_residency = 1100,
-			.flags = CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_COUPLED |
-			         CPUIDLE_FLAG_TIMER_STOP,
+			.flags = CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_COUPLED,
 			.enter = omap_enter_idle_coupled,
 			.name = "C3",
 			.desc = "CPUx OFF, MPUSS OSWR",
@@ -213,5 +227,8 @@ int __init omap4_idle_init(void)
 	if (!cpu_clkdm[0] || !cpu_clkdm[1])
 		return -ENODEV;
 
+	/* Configure the broadcast timer on each cpu */
+	on_each_cpu(omap_setup_broadcast_timer, NULL, 1);
+
 	return cpuidle_register(&omap4_idle_driver, cpu_online_mask);
 }


