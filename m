Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072Ab3CON0O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:26:14 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:43648 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754448Ab3CON0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:26:12 -0400
Date: Fri, 15 Mar 2013 14:26:07 +0100
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, peterz@infradead.org, mingo@elte.hu,
        tglx@linutronix.de, akpm@linux-foundation.org, acme@redhat.com,
        jolsa@redhat.com, ak@linux.intel.com
Subject: [PATCH] perf,x86: fix kernel crash with PEBS/BTS after suspend/resume
Message-ID: <20130315132607.GA4565@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch fixes a kernel crash when using precise sampling (PEBS)
after a suspend/resume. Turns out the CPU notifier code is not invoked
on CPU0 (BP). Therefore, the DS_AREA (used by PEBS) is not restored properly
by the kernel and keeps it power-on/resume value of 0 causing any PEBS
measurement to crash when running on CPU0.

The workaround is to add a hook in the actual resume code to restore
the DS Area MSR value. It is invoked for all CPUS. So for all but CPU0,
the DS_AREA will be restored twice but this is harmless.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 826054a..0e9bdd3 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -729,3 +729,11 @@ void intel_ds_init(void)
 		}
 	}
 }
+
+void perf_restore_debug_store(void)
+{
+	if (!x86_pmu.bts && !x86_pmu.pebs)
+		return;
+
+	init_debug_store_on_cpu(smp_processor_id());
+}
diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
index 120cee1..3c68768 100644
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -11,6 +11,7 @@
 #include <linux/suspend.h>
 #include <linux/export.h>
 #include <linux/smp.h>
+#include <linux/perf_event.h>
 
 #include <asm/pgtable.h>
 #include <asm/proto.h>
@@ -228,6 +229,7 @@ static void __restore_processor_state(struct saved_context *ctxt)
 	do_fpu_end();
 	x86_platform.restore_sched_clock_state();
 	mtrr_bp_restore();
+	perf_restore_debug_store();
 }
 
 /* Needed by apm.c */
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 8737e1c..746be3b 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -742,6 +742,7 @@ extern void perf_event_enable(struct perf_event *event);
 extern void perf_event_disable(struct perf_event *event);
 extern int __perf_event_disable(void *info);
 extern void perf_event_task_tick(void);
+extern void perf_restore_debug_store(void);
 #else
 static inline void
 perf_event_task_sched_in(struct task_struct *prev,
@@ -781,6 +782,7 @@ static inline void perf_event_enable(struct perf_event *event)		{ }
 static inline void perf_event_disable(struct perf_event *event)		{ }
 static inline int __perf_event_disable(void *info)			{ return -1; }
 static inline void perf_event_task_tick(void)				{ }
+static inline void perf_restore_debug_store(void)			{ }
 #endif
 
 #define perf_output_put(handle, x) perf_output_copy((handle), &(x), sizeof(x))
