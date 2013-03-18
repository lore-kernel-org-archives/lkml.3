Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772Ab3CRV3j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:29:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45886 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932155Ab3CRVH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:07:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Stephane Eranian <eranian@google.com>
Subject: [ 17/48] perf,x86: fix kernel crash with PEBS/BTS after suspend/resume
Date: Mon, 18 Mar 2013 14:08:25 -0700
Message-Id: <20130318210811.466798627@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130318210810.247845918@linuxfoundation.org>
References: <20130318210810.247845918@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/cpu/perf_event_intel_ds.c |    8 ++++++++
 arch/x86/power/cpu.c                      |    2 ++
 include/linux/perf_event.h                |    2 ++
 3 files changed, 12 insertions(+)

--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -723,3 +723,11 @@ void intel_ds_init(void)
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
@@ -227,6 +228,7 @@ static void __restore_processor_state(st
 	do_fpu_end();
 	x86_platform.restore_sched_clock_state();
 	mtrr_bp_restore();
+	perf_restore_debug_store();
 }
 
 /* Needed by apm.c */
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1290,6 +1290,7 @@ extern void perf_swevent_put_recursion_c
 extern void perf_event_enable(struct perf_event *event);
 extern void perf_event_disable(struct perf_event *event);
 extern void perf_event_task_tick(void);
+extern void perf_restore_debug_store(void);
 #else
 static inline void
 perf_event_task_sched_in(struct task_struct *prev,
@@ -1328,6 +1329,7 @@ static inline void perf_swevent_put_recu
 static inline void perf_event_enable(struct perf_event *event)		{ }
 static inline void perf_event_disable(struct perf_event *event)		{ }
 static inline void perf_event_task_tick(void)				{ }
+static inline void perf_restore_debug_store(void)			{ }
 #endif
 
 #define perf_output_put(handle, x) perf_output_copy((handle), &(x), sizeof(x))


