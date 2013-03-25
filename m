Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162Ab3CYBms (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:42:48 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33757 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755112Ab3CYBO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:14:57 -0400
Message-Id: <20130325010524.509840202@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 25 Mar 2013 01:05:26 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Stephane Eranian <eranian@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 002/104] perf,x86: fix kernel crash with PEBS/BTS after suspend/resume
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130325010524.240972766@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:f137:78a:b654:affb
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephane Eranian <eranian@google.com>

commit 1d9d8639c063caf6efc2447f5f26aa637f844ff6 upstream.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c |    8 ++++++++
 arch/x86/power/cpu.c                      |    2 ++
 include/linux/perf_event.h                |    2 ++
 3 files changed, 12 insertions(+)

--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -736,3 +736,11 @@ void intel_ds_init(void)
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
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -11,6 +11,7 @@
 #include <linux/suspend.h>
 #include <linux/export.h>
 #include <linux/smp.h>
+#include <linux/perf_event.h>
 
 #include <asm/pgtable.h>
 #include <asm/proto.h>
@@ -225,6 +226,7 @@ static void __restore_processor_state(st
 
 	do_fpu_end();
 	mtrr_bp_restore();
+	perf_restore_debug_store();
 }
 
 /* Needed by apm.c */
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1146,6 +1146,7 @@ extern void perf_swevent_put_recursion_c
 extern void perf_event_enable(struct perf_event *event);
 extern void perf_event_disable(struct perf_event *event);
 extern void perf_event_task_tick(void);
+extern void perf_restore_debug_store(void);
 #else
 static inline void
 perf_event_task_sched_in(struct task_struct *prev,
@@ -1184,6 +1185,7 @@ static inline void perf_swevent_put_recu
 static inline void perf_event_enable(struct perf_event *event)		{ }
 static inline void perf_event_disable(struct perf_event *event)		{ }
 static inline void perf_event_task_tick(void)				{ }
+static inline void perf_restore_debug_store(void)			{ }
 #endif
 
 #define perf_output_put(handle, x) perf_output_copy((handle), &(x), sizeof(x))


