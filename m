Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934988Ab3CZQQh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 12:16:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53623 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934557Ab3CZPWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:22:05 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stephane Eranian <eranian@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 034/150] perf,x86: fix kernel crash with PEBS/BTS after suspend/resume
Date: Tue, 26 Mar 2013 15:18:53 +0000
Message-Id: <1364311249-14454-35-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c | 8 ++++++++
 arch/x86/power/cpu.c                      | 2 ++
 include/linux/perf_event.h                | 2 ++
 3 files changed, 12 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 35e2192..9a9be1e 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -714,3 +714,11 @@ void intel_ds_init(void)
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
index 218cdb1..fcbaac60 100644
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -11,6 +11,7 @@
 #include <linux/suspend.h>
 #include <linux/export.h>
 #include <linux/smp.h>
+#include <linux/perf_event.h>
 
 #include <asm/pgtable.h>
 #include <asm/proto.h>
@@ -227,6 +228,7 @@ static void __restore_processor_state(struct saved_context *ctxt)
 	do_fpu_end();
 	x86_platform.restore_sched_clock_state();
 	mtrr_bp_restore();
+	perf_restore_debug_store();
 }
 
 /* Needed by apm.c */
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index c3c98a6..1d56bf6 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1295,6 +1295,7 @@ extern void perf_swevent_put_recursion_context(int rctx);
 extern void perf_event_enable(struct perf_event *event);
 extern void perf_event_disable(struct perf_event *event);
 extern void perf_event_task_tick(void);
+extern void perf_restore_debug_store(void);
 #else
 static inline void
 perf_event_task_sched_in(struct task_struct *prev,
@@ -1333,6 +1334,7 @@ static inline void perf_swevent_put_recursion_context(int rctx)		{ }
 static inline void perf_event_enable(struct perf_event *event)		{ }
 static inline void perf_event_disable(struct perf_event *event)		{ }
 static inline void perf_event_task_tick(void)				{ }
+static inline void perf_restore_debug_store(void)			{ }
 #endif
 
 #define perf_output_put(handle, x) perf_output_copy((handle), &(x), sizeof(x))
-- 
1.8.1.2

