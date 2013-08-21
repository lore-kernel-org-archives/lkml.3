Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263Ab3HUQqa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 12:46:30 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:35146 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726Ab3HUQq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 12:46:28 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        John Stultz <john.stultz@linaro.org>,
        Steven Rostedt <rostedt@goodmis.org>, Don Zickus <dzickus@redhat.com>
Subject: [RFC PATCH 2/6] x86: nsecs to cycles conversion
Date: Wed, 21 Aug 2013 18:42:17 +0200
Message-Id: <1377103341-15235-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1377103341-15235-1-git-send-email-fweisbec@gmail.com>
References: <1377103341-15235-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hw_nmi_get_sample_period() is simply a conversion from a period
to cycles. Lets generalize the API naming so that it can be used for
wider purpose than just watchdog perf event settings. Also it makes the
function name less opaque about what it really does.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Don Zickus <dzickus@redhat.com>
---
 arch/Kconfig                  |    3 +++
 arch/x86/Kconfig              |    1 +
 arch/x86/include/asm/cycles.h |   11 +++++++++++
 arch/x86/kernel/apic/hw_nmi.c |    7 -------
 kernel/watchdog.c             |    3 ++-
 lib/Kconfig.debug             |    1 +
 6 files changed, 18 insertions(+), 8 deletions(-)
 create mode 100644 arch/x86/include/asm/cycles.h

diff --git a/arch/Kconfig b/arch/Kconfig
index 52ad235..cc4d14a 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -398,6 +398,9 @@ config HAVE_SCHED_CLOCK_NMI
 	help
 	  Architecture's sched_clock() implementation is safely callable from  NMIs.
 
+config HAVE_NSECS_TO_CYCLES
+	bool
+
 #
 # ABI hall of shame
 #
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index b32ebf9..7fbda5c 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -124,6 +124,7 @@ config X86
 	select COMPAT_OLD_SIGACTION if IA32_EMULATION
 	select RTC_LIB
 	select HAVE_DEBUG_STACKOVERFLOW
+	select HAVE_NSECS_TO_CYCLES
 
 config INSTRUCTION_DECODER
 	def_bool y
diff --git a/arch/x86/include/asm/cycles.h b/arch/x86/include/asm/cycles.h
new file mode 100644
index 0000000..7dedeb3
--- /dev/null
+++ b/arch/x86/include/asm/cycles.h
@@ -0,0 +1,11 @@
+#ifndef _ASM_X86_CYCLES_H
+#define _ASM_X86_CYCLES_H
+
+#include <linux/time.h>
+#include <asm/tsc.h>
+
+static inline u64 nsecs_to_cycles(u64 nsecs)
+{
+	return (u64)((cpu_khz) * nsecs) / NSEC_PER_MSEC;
+}
+#endif /* #ifndef _ASM_X86_CYCLES_H */
diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
index a698d71..4015906 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -19,13 +19,6 @@
 #include <linux/module.h>
 #include <linux/delay.h>
 
-#ifdef CONFIG_HARDLOCKUP_DETECTOR
-u64 hw_nmi_get_sample_period(int watchdog_thresh)
-{
-	return (u64)(cpu_khz) * 1000 * watchdog_thresh;
-}
-#endif
-
 #ifdef arch_trigger_all_cpu_backtrace
 /* For reliability, we're prepared to waste bits here. */
 static DECLARE_BITMAP(backtrace_mask, NR_CPUS) __read_mostly;
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 1241d8c..e04887c 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -26,6 +26,7 @@
 #include <linux/sched/rt.h>
 
 #include <asm/irq_regs.h>
+#include <asm/cycles.h>
 #include <linux/kvm_para.h>
 #include <linux/perf_event.h>
 
@@ -417,7 +418,7 @@ static int watchdog_nmi_enable(unsigned int cpu)
 		goto out_enable;
 
 	wd_attr = &wd_hw_attr;
-	wd_attr->sample_period = hw_nmi_get_sample_period(watchdog_thresh);
+	wd_attr->sample_period = nsecs_to_cycles(watchdog_thresh * NSEC_PER_SEC);
 
 	/* Try to register using hardware perf events */
 	event = perf_event_create_kernel_counter(wd_attr, cpu, NULL, watchdog_overflow_callback, NULL);
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 1501aa5..568179d 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -634,6 +634,7 @@ config HARDLOCKUP_DETECTOR
 	def_bool y
 	depends on LOCKUP_DETECTOR && !HAVE_NMI_WATCHDOG
 	depends on PERF_EVENTS && HAVE_PERF_EVENTS_NMI
+	depends on HAVE_NSECS_TO_CYCLES
 
 config BOOTPARAM_HARDLOCKUP_PANIC
 	bool "Panic (Reboot) On Hard Lockups"
-- 
1.7.5.4

