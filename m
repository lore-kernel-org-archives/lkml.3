Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526Ab3CPA6K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 20:58:10 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:8451 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755031Ab3CPA6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 20:58:08 -0400
Message-ID: <1363395478.7231.9.camel@lorien2>
Subject: [PATCH 3.0] perf,x86: fix kernel crash with PEBS/BTS after
 suspend/resume
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: eranian@google.com, Greg KH <gregkh@linuxfoundation.org>,
        a.p.zijlstra@chello.nl, paulus@samba.org, mingo@elte.hu,
        acme@ghostprotocols.net, tglx@linutronix.de, hpa@zytor.com,
        pavel@ucw.cz, rafael.j.wysocki@intel.com
Cc: LKML <linux-kernel@vger.kernel.org>, torvalds@linux-foundation.org,
        peterz@infradead.org, Andrew Morton <akpm@linux-foundation.org>,
        jolsa@redhat.com, ak@linux.intel.com, stable <stable@vger.kernel.org>,
        shuahkhan@gmail.com
Date: Fri, 15 Mar 2013 18:57:58 -0600
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
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

Upstream commit id: 1d9d8639c063caf6efc2447f5f26aa637f844ff6

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Shuah Khan <shuah.khan@hp.com>
CC: stable@vger.kernel.org 3.0
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c |    8 ++++++++
 arch/x86/power/cpu.c                      |    2 ++
 include/linux/perf_event.h                |    2 ++
 3 files changed, 12 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index d812fe2..cf82ee5 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -754,6 +754,14 @@ static void intel_ds_init(void)
 	}
 }
 
+void perf_restore_debug_store(void)
+{
+	if (!x86_pmu.bts && !x86_pmu.pebs)
+		return;
+
+	init_debug_store_on_cpu(smp_processor_id());
+}
+
 #else /* CONFIG_CPU_SUP_INTEL */
 
 static void reserve_ds_buffers(void)
diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
index 87bb35e..0ea8bd2 100644
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -10,6 +10,7 @@
 
 #include <linux/suspend.h>
 #include <linux/smp.h>
+#include <linux/perf_event.h>
 
 #include <asm/pgtable.h>
 #include <asm/proto.h>
@@ -224,6 +225,7 @@ static void __restore_processor_state(struct saved_context *ctxt)
 
 	do_fpu_end();
 	mtrr_bp_restore();
+	perf_restore_debug_store();
 }
 
 /* Needed by apm.c */
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index effadd6..038ad4a 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1153,6 +1153,7 @@ extern void perf_swevent_put_recursion_context(int rctx);
 extern void perf_event_enable(struct perf_event *event);
 extern void perf_event_disable(struct perf_event *event);
 extern void perf_event_task_tick(void);
+extern void perf_restore_debug_store(void);
 #else
 static inline void
 perf_event_task_sched_in(struct task_struct *task)			{ }
@@ -1187,6 +1188,7 @@ static inline void perf_swevent_put_recursion_context(int rctx)		{ }
 static inline void perf_event_enable(struct perf_event *event)		{ }
 static inline void perf_event_disable(struct perf_event *event)		{ }
 static inline void perf_event_task_tick(void)				{ }
+static inline void perf_restore_debug_store(void)			{ }
 #endif
 
 #define perf_output_put(handle, x) perf_output_copy((handle), &(x), sizeof(x))
-- 
1.7.9.5



