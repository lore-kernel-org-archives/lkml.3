Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190AbaDLIfO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 04:35:14 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:58045 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbaDLIfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 04:35:07 -0400
Message-ID: <1397291702.6038.43.camel@marge.simpson.net>
Subject: Re: [RFC][PATCH 0/8] sched,idle: need resched polling rework
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@kernel.org, tglx@linutronix.de, luto@amacapital.net,
        nicolas.pitre@linaro.org, daniel.lezcano@linaro.org,
        linux-kernel@vger.kernel.org
Date: Sat, 12 Apr 2014 10:35:02 +0200
In-Reply-To: <20140411134243.160989490@infradead.org>
References: <20140411134243.160989490@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-04-11 at 15:42 +0200, Peter Zijlstra wrote: 
> A while ago both Mike and Andy complained that we still get pointless wakeup
> IPIs, we had a few patches back and forth but eventually more or less agreed
> and then nothing... :-)
> 
> So here's a number of patches that implement something near what we left off
> with.
> 
> Its only been compile/boot tested on x86_64, I've no actually looked at the IPI
> numbers yet.

'course this didn't do much for my Q6600 box, or core2 lappy when booted
max_cstate=1, but series didn't seem to break anything, both boxen still
work fine with the below on top.


Subject: [PATCH REGRESSION FIX] x86 idle: restore mwait_idle()
From: Len Brown <lenb@kernel.org>
Date: Wed, 15 Jan 2014 00:37:34 -0500

From: Len Brown <len.brown@intel.com>

In Linux-3.9 we removed the mwait_idle() loop:
'x86 idle: remove mwait_idle() and "idle=mwait" cmdline param'
(69fb3676df3329a7142803bb3502fa59dc0db2e3)

The reasoning was that modern machines should be sufficiently
happy during the boot process using the default_idle() HALT loop,
until cpuidle loads and either acpi_idle or intel_idle
invoke the newer MWAIT-with-hints idle loop.

But two machines reported problems:
1. Certain Core2-era machines support MWAIT-C1 and HALT only.
   MWAIT-C1 is preferred for optimal power and performance.
   But if they support just C1, cpuidle never loads and
   so they use the boot-time default idle loop forever.

2. Some laptops will boot-hang if HALT is used,
   but will boot successfully if MWAIT is used.
   This appears to be a hidden assumption in BIOS SMI,
   that is presumably valid on the proprietary OS
   where the BIOS was validated.

   https://bugzilla.kernel.org/show_bug.cgi?id=60770

So here we effectively revert the patch above, restoring
the mwait_idle() loop.  However, we don't bother restoring
the idle=mwait cmdline parameter, since it appears to add
no value.

Maintainer notes:
For 3.9, simply revert 69fb3676df
for 3.10, patch -F3 applies, fuzz needed due to __cpuinit use in context
For 3.11, 3.12, 3.13, this patch applies cleanly

Mike: add clflush barriers and resched IPI avoidance.

Cc: Mike Galbraith <bitbucket@online.de>
Cc: Ian Malone <ibmalone@gmail.com>
Cc: Josh Boyer <jwboyer@redhat.com>
Cc: <stable@vger.kernel.org> # 3.9, 3.10, 3.11, 3.12, 3.13
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Mike Galbraith <bitbucket@online.de>
---
 arch/x86/include/asm/mwait.h |    8 ++++++
 arch/x86/kernel/process.c    |   50 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+)

--- a/arch/x86/include/asm/mwait.h
+++ b/arch/x86/include/asm/mwait.h
@@ -30,6 +30,14 @@ static inline void __mwait(unsigned long
 		     :: "a" (eax), "c" (ecx));
 }
 
+static inline void __sti_mwait(unsigned long eax, unsigned long ecx)
+{
+	trace_hardirqs_on();
+	/* "mwait %eax, %ecx;" */
+	asm volatile("sti; .byte 0x0f, 0x01, 0xc9;"
+		     :: "a" (eax), "c" (ecx));
+}
+
 /*
  * This uses new MONITOR/MWAIT instructions on P4 processors with PNI,
  * which can obviate IPI to trigger checking of need_resched.
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -28,6 +28,7 @@
 #include <asm/fpu-internal.h>
 #include <asm/debugreg.h>
 #include <asm/nmi.h>
+#include <asm/mwait.h>
 
 /*
  * per-CPU TSS segments. Threads are completely 'soft' on Linux,
@@ -395,6 +396,52 @@ static void amd_e400_idle(void)
 		default_idle();
 }
 
+/*
+ * Intel Core2 and older machines prefer MWAIT over HALT for C1.
+ * We can't rely on cpuidle installing MWAIT, because it will not load
+ * on systems that support only C1 -- so the boot default must be MWAIT.
+ *
+ * Some AMD machines are the opposite, they depend on using HALT.
+ *
+ * So for default C1, which is used during boot until cpuidle loads,
+ * use MWAIT-C1 on Intel HW that has it, else use HALT.
+ */
+static int prefer_mwait_c1_over_halt(const struct cpuinfo_x86 *c)
+{
+	if (c->x86_vendor != X86_VENDOR_INTEL)
+		return 0;
+
+	if (!cpu_has(c, X86_FEATURE_MWAIT))
+		return 0;
+
+	return 1;
+}
+
+/*
+ * MONITOR/MWAIT with no hints, used for default default C1 state.
+ * This invokes MWAIT with interrutps enabled and no flags,
+ * which is backwards compatible with the original MWAIT implementation.
+ */
+
+static void mwait_idle(void)
+{
+	if (!current_set_polling_and_test()) {
+		if (this_cpu_has(X86_FEATURE_CLFLUSH_MONITOR)) {
+			mb();
+			clflush((void *)&current_thread_info()->flags);
+			mb();
+		}
+
+		__monitor((void *)&current_thread_info()->flags, 0, 0);
+		if (!need_resched())
+			__sti_mwait(0, 0);
+		else
+			local_irq_enable();
+	} else
+		local_irq_enable();
+	current_clr_polling();
+}
+
 void select_idle_routine(const struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_SMP
@@ -408,6 +455,9 @@ void select_idle_routine(const struct cp
 		/* E400: APIC timer interrupt does not wake up CPU from C1e */
 		pr_info("using AMD E400 aware idle routine\n");
 		x86_idle = amd_e400_idle;
+	} else if (prefer_mwait_c1_over_halt(c)) {
+		pr_info("using mwait in idle threads\n");
+		x86_idle = mwait_idle;
 	} else
 		x86_idle = default_idle;
 }



