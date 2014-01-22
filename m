Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459AbaAVHNO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 02:13:14 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:46000 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455AbaAVHNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 02:13:10 -0500
Subject: [RESEND PATCH V5 7/8] cpuidle/powernv: Add "Fast-Sleep" CPU idle
 state
To: peterz@infradead.org, fweisbec@gmail.com, paul.gortmaker@windriver.com,
        paulus@samba.org, mingo@kernel.org, mikey@neuling.org,
        shangw@linux.vnet.ibm.com, rafael.j.wysocki@intel.com,
        galak@kernel.crashing.org, =daniel.lezcano@linaro.org,
        benh@kernel.crashing.org, paulmck@linux.vnet.ibm.com,
        --to=agraf@suse.de, arnd@arndb.de, linux-pm@vger.kernel.org,
        rostedt@goodmis.org, michael@ellerman.id.au, john.stultz@linaro.org,
        anton@samba.org, tglx@linutronix.de, chenhui.zhao@freescale.com,
        deepthi@linux.vnet.ibm.com, r58472@freescale.com, geoff@infradead.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, svaidy@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Date: Wed, 22 Jan 2014 12:39:32 +0530
Message-ID: <20140122070932.30650.88481.stgit@preeti.in.ibm.com>
In-Reply-To: <20140122065918.30650.22437.stgit@preeti.in.ibm.com>
References: <20140122065918.30650.22437.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14012207-9332-0000-0000-000002D86CCF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fast sleep is one of the deep idle states on Power8 in which local timers of
CPUs stop. On PowerPC we do not have an external clock device which can
handle wakeup of such CPUs. Now that we have the support in the tick broadcast
framework for archs that do not sport such a device and the low level support
for fast sleep, enable it in the cpuidle framework on PowerNV.

Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---

 arch/powerpc/Kconfig              |    2 ++
 arch/powerpc/kernel/time.c        |    2 +-
 drivers/cpuidle/cpuidle-powernv.c |   42 +++++++++++++++++++++++++++++++++++++
 3 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index fa39517..ec91584 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -129,6 +129,8 @@ config PPC
 	select GENERIC_CMOS_UPDATE
 	select GENERIC_TIME_VSYSCALL_OLD
 	select GENERIC_CLOCKEVENTS
+	select GENERIC_CLOCKEVENTS_BROADCAST
+	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
 	select GENERIC_STRNCPY_FROM_USER
 	select GENERIC_STRNLEN_USER
 	select HAVE_MOD_ARCH_SPECIFIC
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index df2989b..95fa5ce 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -106,7 +106,7 @@ struct clock_event_device decrementer_clockevent = {
 	.irq            = 0,
 	.set_next_event = decrementer_set_next_event,
 	.set_mode       = decrementer_set_mode,
-	.features       = CLOCK_EVT_FEAT_ONESHOT,
+	.features       = CLOCK_EVT_FEAT_ONESHOT | CLOCK_EVT_FEAT_C3STOP,
 };
 EXPORT_SYMBOL(decrementer_clockevent);
 
diff --git a/drivers/cpuidle/cpuidle-powernv.c b/drivers/cpuidle/cpuidle-powernv.c
index 78fd174..90f0c2b 100644
--- a/drivers/cpuidle/cpuidle-powernv.c
+++ b/drivers/cpuidle/cpuidle-powernv.c
@@ -11,6 +11,7 @@
 #include <linux/cpuidle.h>
 #include <linux/cpu.h>
 #include <linux/notifier.h>
+#include <linux/clockchips.h>
 
 #include <asm/machdep.h>
 #include <asm/firmware.h>
@@ -49,6 +50,40 @@ static int nap_loop(struct cpuidle_device *dev,
 	return index;
 }
 
+static int fastsleep_loop(struct cpuidle_device *dev,
+				struct cpuidle_driver *drv,
+				int index)
+{
+	int cpu = dev->cpu;
+	unsigned long old_lpcr = mfspr(SPRN_LPCR);
+	unsigned long new_lpcr;
+
+	if (unlikely(system_state < SYSTEM_RUNNING))
+		return index;
+
+	new_lpcr = old_lpcr;
+	new_lpcr &= ~(LPCR_MER | LPCR_PECE); /* lpcr[mer] must be 0 */
+
+	/* exit powersave upon external interrupt, but not decrementer
+	 * interrupt, Emulate sleep.
+	 */
+	new_lpcr |= LPCR_PECE0;
+
+	if (clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &cpu)) {
+		new_lpcr |= LPCR_PECE1;
+		mtspr(SPRN_LPCR, new_lpcr);
+		power7_nap();
+	} else {
+		mtspr(SPRN_LPCR, new_lpcr);
+		power7_sleep();
+	}
+	clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &cpu);
+
+	mtspr(SPRN_LPCR, old_lpcr);
+
+	return index;
+}
+
 /*
  * States for dedicated partition case.
  */
@@ -67,6 +102,13 @@ static struct cpuidle_state powernv_states[] = {
 		.exit_latency = 10,
 		.target_residency = 100,
 		.enter = &nap_loop },
+	 { /* Fastsleep */
+		.name = "fastsleep",
+		.desc = "fastsleep",
+		.flags = CPUIDLE_FLAG_TIME_VALID,
+		.exit_latency = 10,
+		.target_residency = 100,
+		.enter = &fastsleep_loop },
 };
 
 static int powernv_cpuidle_add_cpu_notifier(struct notifier_block *n,

