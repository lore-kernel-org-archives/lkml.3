Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800Ab3LLAxv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 19:53:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40915 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615Ab3LLAxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 19:53:46 -0500
Message-ID: <52A908DB.60902@zytor.com>
Date: Wed, 11 Dec 2013 16:52:43 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <bitbucket@online.de>,
        Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Eder <jeder@redhat.com>, x86@kernel.org
Subject: Re: 50 Watt idle power regression bisected to Linux-3.10
References: <alpine.DEB.2.02.1312111206200.28330@ionos.tec.linutronix.de> <20131211113839.GF21683@pd.tnic> <20131211115239.GA21999@twins.programming.kicks-ass.net> <1386764955.12005.60.camel@marge.simpson.net> <20131211124352.GB21999@twins.programming.kicks-ass.net> <20131211134048.GH21683@pd.tnic> <20131211145655.GB4510@gmail.com> <20131211164318.GA2480@laptop.programming.kicks-ass.net> <20131211175036.GC12431@gmail.com> <52A8F073.9040500@zytor.com> <20131211231425.GD8863@pd.tnic>
In-Reply-To: <20131211231425.GD8863@pd.tnic>
X-Enigmail-Version: 1.6
Content-Type: multipart/mixed;
 boundary="------------010709060908020902070706"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010709060908020902070706
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/11/2013 03:14 PM, Borislav Petkov wrote:
> On Wed, Dec 11, 2013 at 03:08:35PM -0800, H. Peter Anvin wrote:
>> So I would like to propose that we switch to using a percpu variable
>> which is a single cache line of nothing at all. It would only ever
>> be touched by MONITOR and for explicit wakeup. Hopefully that will
>> resolve this problem without the need for the CLFLUSH.
> 
> Yep, makes a lot of sense to me to have an exclusive (overloaded meaning
> here :-)) cacheline only for that. And, if it works, we'll save us the
> penalty from the CLFLUSH too, cool.
> 

Here is a POC patch... anyone willing to test it out?

Two obvious things to watch out for:

1. I couldn't actually spot any obvious cases of a deliberate monitor
   trigger.

2. Should we do cpu_relax() for all users, not just powerclamp?

	-hpa


--------------010709060908020902070706
Content-Type: text/x-patch;
 name="0001-x86-mwait-Use-a-dedicated-percpu-area-for-mwait-door.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-x86-mwait-Use-a-dedicated-percpu-area-for-mwait-door.pa";
 filename*1="tch"

>From 20a54d54ea06f050650ab8923b7d9ee1d21b5317 Mon Sep 17 00:00:00 2001
From: "H. Peter Anvin" <hpa@linux.intel.com>
Date: Wed, 11 Dec 2013 16:31:04 -0800
Subject: [PATCH] x86, mwait: Use a dedicated percpu area for mwait doorbell

We have used the cache line that includes thread_info.flags as the
mwait doorbell.  However, this is liable to be dirty in the cache,
which may trigger hardware errata, plus it might cause false wakeups.
Instead, use a dedicated wakeup doorbell area.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/cpufeature.h  |  1 -
 arch/x86/include/asm/mwait.h       | 46 ++++++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/processor.h   | 23 -------------------
 arch/x86/kernel/acpi/cstate.c      |  6 +----
 arch/x86/kernel/cpu/common.c       | 17 ++++++++++++++
 arch/x86/kernel/cpu/intel.c        |  3 ---
 arch/x86/kernel/setup_percpu.c     |  3 +++
 arch/x86/kernel/smpboot.c          | 19 +---------------
 drivers/acpi/acpi_pad.c            |  3 +--
 drivers/idle/intel_idle.c          |  4 +---
 drivers/thermal/intel_powerclamp.c |  2 +-
 11 files changed, 71 insertions(+), 56 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index e099f95..cdc77f3 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -96,7 +96,6 @@
 #define X86_FEATURE_XTOPOLOGY	(3*32+22) /* cpu topology enum extensions */
 #define X86_FEATURE_TSC_RELIABLE (3*32+23) /* TSC is known to be reliable */
 #define X86_FEATURE_NONSTOP_TSC	(3*32+24) /* TSC does not stop in C states */
-#define X86_FEATURE_CLFLUSH_MONITOR (3*32+25) /* "" clflush reqd with monitor */
 #define X86_FEATURE_EXTD_APICID	(3*32+26) /* has extended APICID (8 bits) */
 #define X86_FEATURE_AMD_DCM     (3*32+27) /* multi-node processor */
 #define X86_FEATURE_APERFMPERF	(3*32+28) /* APERFMPERF */
diff --git a/arch/x86/include/asm/mwait.h b/arch/x86/include/asm/mwait.h
index 2f366d0..4c82863 100644
--- a/arch/x86/include/asm/mwait.h
+++ b/arch/x86/include/asm/mwait.h
@@ -13,4 +13,50 @@
 
 #define MWAIT_ECX_INTERRUPT_BREAK	0x1
 
+#ifndef __ASSEMBLY__
+
+#include <linux/compiler.h>
+#include <linux/kernel.h>
+#include <linux/percpu.h>
+
+static inline void __monitor(const void *eax, unsigned long ecx,
+			     unsigned long edx)
+{
+	/* "monitor %eax, %ecx, %edx;" */
+	asm volatile(".byte 0x0f, 0x01, 0xc8;"
+		     :: "a" (eax), "c" (ecx), "d"(edx));
+}
+
+static inline void __mwait(unsigned long eax, unsigned long ecx)
+{
+	/* "mwait %eax, %ecx;" */
+	asm volatile(".byte 0x0f, 0x01, 0xc9;"
+		     :: "a" (eax), "c" (ecx));
+}
+
+static inline void __sti_mwait(unsigned long eax, unsigned long ecx)
+{
+	trace_hardirqs_on();
+	/* "mwait %eax, %ecx;" */
+	asm volatile("sti; .byte 0x0f, 0x01, 0xc9;"
+		     :: "a" (eax), "c" (ecx));
+}
+
+extern char __percpu *mwait_doorbell;
+
+void __init setup_mwait_doorbell(void);
+
+static inline void x86_monitor_doorbell(unsigned long ecx, unsigned long edx)
+{
+	__monitor(__this_cpu_ptr(mwait_doorbell), ecx, edx);
+	mb();
+}
+
+static inline void x86_mwait_doorbell_bing_bong(int cpu)
+{
+	ACCESS_ONCE(*per_cpu_ptr(mwait_doorbell, cpu)) = 0;
+}
+
+#endif /* !__ASSEMBLY__ */
+
 #endif /* _ASM_X86_MWAIT_H */
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index b7845a1..a51a79e 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -723,29 +723,6 @@ static inline void sync_core(void)
 #endif
 }
 
-static inline void __monitor(const void *eax, unsigned long ecx,
-			     unsigned long edx)
-{
-	/* "monitor %eax, %ecx, %edx;" */
-	asm volatile(".byte 0x0f, 0x01, 0xc8;"
-		     :: "a" (eax), "c" (ecx), "d"(edx));
-}
-
-static inline void __mwait(unsigned long eax, unsigned long ecx)
-{
-	/* "mwait %eax, %ecx;" */
-	asm volatile(".byte 0x0f, 0x01, 0xc9;"
-		     :: "a" (eax), "c" (ecx));
-}
-
-static inline void __sti_mwait(unsigned long eax, unsigned long ecx)
-{
-	trace_hardirqs_on();
-	/* "mwait %eax, %ecx;" */
-	asm volatile("sti; .byte 0x0f, 0x01, 0xc9;"
-		     :: "a" (eax), "c" (ecx));
-}
-
 extern void select_idle_routine(const struct cpuinfo_x86 *c);
 extern void init_amd_e400_c1e_mask(void);
 
diff --git a/arch/x86/kernel/acpi/cstate.c b/arch/x86/kernel/acpi/cstate.c
index d2b7f27..aec26c5 100644
--- a/arch/x86/kernel/acpi/cstate.c
+++ b/arch/x86/kernel/acpi/cstate.c
@@ -163,11 +163,7 @@ EXPORT_SYMBOL_GPL(acpi_processor_ffh_cstate_probe);
 void mwait_idle_with_hints(unsigned long ax, unsigned long cx)
 {
 	if (!need_resched()) {
-		if (this_cpu_has(X86_FEATURE_CLFLUSH_MONITOR))
-			clflush((void *)&current_thread_info()->flags);
-
-		__monitor((void *)&current_thread_info()->flags, 0, 0);
-		smp_mb();
+		x86_monitor_doorbell(0, 0);
 		if (!need_resched())
 			__mwait(ax, cx);
 	}
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 6abc172..b6b19ab 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -24,6 +24,7 @@
 #include <linux/cpumask.h>
 #include <asm/pgtable.h>
 #include <linux/atomic.h>
+#include <asm/mwait.h>
 #include <asm/proto.h>
 #include <asm/setup.h>
 #include <asm/apic.h>
@@ -63,6 +64,22 @@ void __init setup_cpu_local_masks(void)
 	alloc_bootmem_cpumask_var(&cpu_sibling_setup_mask);
 }
 
+/* allocate percpu area for mwait doorbell */
+char __percpu *mwait_doorbell;
+
+void __init setup_mwait_doorbell(void)
+{
+	if (boot_cpu_has(X86_FEATURE_MWAIT)) {
+		mwait_doorbell = __alloc_percpu(boot_cpu_data.clflush_size,
+						boot_cpu_data.clflush_size);
+
+		if (!mwait_doorbell) {
+			/* This should never happen... */
+			panic("Unable to allocate mwait doorbell!\n");
+		}
+	}
+}
+
 static void default_init(struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index dc1ec0d..47b4e7b 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -387,9 +387,6 @@ static void init_intel(struct cpuinfo_x86 *c)
 			set_cpu_cap(c, X86_FEATURE_PEBS);
 	}
 
-	if (c->x86 == 6 && c->x86_model == 29 && cpu_has_clflush)
-		set_cpu_cap(c, X86_FEATURE_CLFLUSH_MONITOR);
-
 #ifdef CONFIG_X86_64
 	if (c->x86 == 15)
 		c->x86_cache_alignment = c->x86_clflush_size * 2;
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 5cdff03..917e1af 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -284,4 +284,7 @@ void __init setup_per_cpu_areas(void)
 
 	/* Setup cpu initialized, callin, callout masks */
 	setup_cpu_local_masks();
+
+	/* Setup MWAIT doorbell */
+	setup_mwait_doorbell();
 }
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 85dc05a..558e097 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1368,7 +1368,6 @@ static inline void mwait_play_dead(void)
 	unsigned int eax, ebx, ecx, edx;
 	unsigned int highest_cstate = 0;
 	unsigned int highest_subcstate = 0;
-	void *mwait_ptr;
 	int i;
 
 	if (!this_cpu_has(X86_FEATURE_MWAIT))
@@ -1400,26 +1399,10 @@ static inline void mwait_play_dead(void)
 			(highest_subcstate - 1);
 	}
 
-	/*
-	 * This should be a memory location in a cache line which is
-	 * unlikely to be touched by other processors.  The actual
-	 * content is immaterial as it is not actually modified in any way.
-	 */
-	mwait_ptr = &current_thread_info()->flags;
-
 	wbinvd();
 
 	while (1) {
-		/*
-		 * The CLFLUSH is a workaround for erratum AAI65 for
-		 * the Xeon 7400 series.  It's not clear it is actually
-		 * needed, but it should be harmless in either case.
-		 * The WBINVD is insufficient due to the spurious-wakeup
-		 * case where we return around the loop.
-		 */
-		clflush(mwait_ptr);
-		__monitor(mwait_ptr, 0, 0);
-		mb();
+		x86_monitor_doorbell(0, 0);
 		__mwait(eax, 0);
 		/*
 		 * If NMI wants to wake up CPU0, start CPU0.
diff --git a/drivers/acpi/acpi_pad.c b/drivers/acpi/acpi_pad.c
index fc6008f..38aaa8b 100644
--- a/drivers/acpi/acpi_pad.c
+++ b/drivers/acpi/acpi_pad.c
@@ -193,8 +193,7 @@ static int power_saving_thread(void *data)
 					CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &cpu);
 			stop_critical_timings();
 
-			__monitor((void *)&current_thread_info()->flags, 0, 0);
-			smp_mb();
+			x86_monitor_doorbell(0, 0);
 			if (!need_resched())
 				__mwait(power_saving_mwait_eax, 1);
 
diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 92d1206..6fef6d9 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -376,9 +376,7 @@ static int intel_idle(struct cpuidle_device *dev,
 		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &cpu);
 
 	if (!current_set_polling_and_test()) {
-
-		__monitor((void *)&current_thread_info()->flags, 0, 0);
-		smp_mb();
+		x86_monitor_doorbell(0, 0);
 		if (!need_resched())
 			__mwait(eax, ecx);
 	}
diff --git a/drivers/thermal/intel_powerclamp.c b/drivers/thermal/intel_powerclamp.c
index 8f181b3..15cf013 100644
--- a/drivers/thermal/intel_powerclamp.c
+++ b/drivers/thermal/intel_powerclamp.c
@@ -438,7 +438,7 @@ static int clamp_thread(void *arg)
 			 */
 			local_touch_nmi();
 			stop_critical_timings();
-			__monitor((void *)&current_thread_info()->flags, 0, 0);
+			x86_monitor_doorbell(0, 0);
 			cpu_relax(); /* allow HT sibling to run */
 			__mwait(eax, ecx);
 			start_critical_timings();
-- 
1.8.3.1


--------------010709060908020902070706--
