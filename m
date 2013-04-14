Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022Ab3DNPVF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 11:21:05 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:44032 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894Ab3DNPVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 11:21:03 -0400
Date: Sun, 14 Apr 2013 17:20:56 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20130414152056.GA4324@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   HEAD: c481420248c6730246d2a1b1773d5d7007ae0835 perf: Fix error return code

Misc fixlets.

 Thanks,

	Ingo

------------------>
Chen Gang (3):
      perf: Fix strncpy() use, always make sure it's NUL terminated
      perf: Fix strncpy() use, use strlcpy() instead of strncpy()
      ftrace: Fix strncpy() use, use strlcpy() instead of strncpy()

Stephane Eranian (2):
      perf/x86: Fix uninitialized pt_regs in intel_pmu_drain_bts_buffer()
      perf: Fix ring_buffer perf_output_space() boundary calculation

Wei Yongjun (1):
      perf: Fix error return code


 arch/x86/kernel/cpu/perf_event_intel_ds.c |  3 ++-
 kernel/events/core.c                      |  4 +++-
 kernel/events/internal.h                  |  2 +-
 kernel/events/ring_buffer.c               | 22 ++++++++++++++++++----
 kernel/trace/ftrace.c                     |  4 ++--
 kernel/trace/trace.c                      |  4 ++--
 6 files changed, 28 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 826054a..f71c9f0 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -314,10 +314,11 @@ int intel_pmu_drain_bts_buffer(void)
 	if (top <= at)
 		return 0;
 
+	memset(&regs, 0, sizeof(regs));
+
 	ds->bts_index = ds->bts_buffer_base;
 
 	perf_sample_data_init(&data, 0, event->hw.last_period);
-	regs.ip     = 0;
 
 	/*
 	 * Prepare a generic sample, i.e. fill in the invariant fields.
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 59412d0..7e0962e 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4737,7 +4737,8 @@ static void perf_event_mmap_event(struct perf_mmap_event *mmap_event)
 	} else {
 		if (arch_vma_name(mmap_event->vma)) {
 			name = strncpy(tmp, arch_vma_name(mmap_event->vma),
-				       sizeof(tmp));
+				       sizeof(tmp) - 1);
+			tmp[sizeof(tmp) - 1] = '\0';
 			goto got_name;
 		}
 
@@ -5986,6 +5987,7 @@ skip_type:
 	if (pmu->pmu_cpu_context)
 		goto got_cpu_context;
 
+	ret = -ENOMEM;
 	pmu->pmu_cpu_context = alloc_percpu(struct perf_cpu_context);
 	if (!pmu->pmu_cpu_context)
 		goto free_dev;
diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index d56a64c..eb675c4 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -16,7 +16,7 @@ struct ring_buffer {
 	int				page_order;	/* allocation order  */
 #endif
 	int				nr_pages;	/* nr of data pages  */
-	int				writable;	/* are we writable   */
+	int				overwrite;	/* can overwrite itself */
 
 	atomic_t			poll;		/* POLL_ for wakeups */
 
diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index 23cb34f..97fddb0 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -18,12 +18,24 @@
 static bool perf_output_space(struct ring_buffer *rb, unsigned long tail,
 			      unsigned long offset, unsigned long head)
 {
-	unsigned long mask;
+	unsigned long sz = perf_data_size(rb);
+	unsigned long mask = sz - 1;
 
-	if (!rb->writable)
+	/*
+	 * check if user-writable
+	 * overwrite : over-write its own tail
+	 * !overwrite: buffer possibly drops events.
+	 */
+	if (rb->overwrite)
 		return true;
 
-	mask = perf_data_size(rb) - 1;
+	/*
+	 * verify that payload is not bigger than buffer
+	 * otherwise masking logic may fail to detect
+	 * the "not enough space" condition
+	 */
+	if ((head - offset) > sz)
+		return false;
 
 	offset = (offset - tail) & mask;
 	head   = (head   - tail) & mask;
@@ -212,7 +224,9 @@ ring_buffer_init(struct ring_buffer *rb, long watermark, int flags)
 		rb->watermark = max_size / 2;
 
 	if (flags & RING_BUFFER_WRITABLE)
-		rb->writable = 1;
+		rb->overwrite = 0;
+	else
+		rb->overwrite = 1;
 
 	atomic_set(&rb->refcount, 1);
 
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 6893d5a..db14374 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3441,14 +3441,14 @@ static char ftrace_filter_buf[FTRACE_FILTER_SIZE] __initdata;
 
 static int __init set_ftrace_notrace(char *str)
 {
-	strncpy(ftrace_notrace_buf, str, FTRACE_FILTER_SIZE);
+	strlcpy(ftrace_notrace_buf, str, FTRACE_FILTER_SIZE);
 	return 1;
 }
 __setup("ftrace_notrace=", set_ftrace_notrace);
 
 static int __init set_ftrace_filter(char *str)
 {
-	strncpy(ftrace_filter_buf, str, FTRACE_FILTER_SIZE);
+	strlcpy(ftrace_filter_buf, str, FTRACE_FILTER_SIZE);
 	return 1;
 }
 __setup("ftrace_filter=", set_ftrace_filter);
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 4f1dade..3f5046a 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -132,7 +132,7 @@ static char *default_bootup_tracer;
 
 static int __init set_cmdline_ftrace(char *str)
 {
-	strncpy(bootup_tracer_buf, str, MAX_TRACER_SIZE);
+	strlcpy(bootup_tracer_buf, str, MAX_TRACER_SIZE);
 	default_bootup_tracer = bootup_tracer_buf;
 	/* We are using ftrace early, expand it */
 	ring_buffer_expanded = 1;
@@ -162,7 +162,7 @@ static char *trace_boot_options __initdata;
 
 static int __init set_trace_boot_options(char *str)
 {
-	strncpy(trace_boot_options_buf, str, MAX_TRACER_SIZE);
+	strlcpy(trace_boot_options_buf, str, MAX_TRACER_SIZE);
 	trace_boot_options = trace_boot_options_buf;
 	return 0;
 }

