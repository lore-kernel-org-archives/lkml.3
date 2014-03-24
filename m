Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795AbaCXSOV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 14:14:21 -0400
Received: from mail-yh0-f74.google.com ([209.85.213.74]:60962 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771AbaCXSOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 14:14:16 -0400
From: Bharath Ravi <rbharath@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>,
        David Sharp <dhsharp@google.com>, Bharath Ravi <rbharath@google.com>,
        Laurent Chavey <chavey@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] tracing: Allow instances to independently set trace_overwrite.
Date: Mon, 24 Mar 2014 11:13:46 -0700
Message-Id: <1395684826-22931-4-git-send-email-rbharath@google.com>
X-Mailer: git-send-email 1.9.1.423.g4596e3a
In-Reply-To: <1395684826-22931-1-git-send-email-rbharath@google.com>
References: <1395684826-22931-1-git-send-email-rbharath@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes "trace_overwrite" an instance specific flag, so that
instances may independently control whether their buffers are in
overwrite mode or not.

To do this, the global_flags_start offset is set to 1, and the
trace_overwrite flag is moved to position 0 in the trace_options array.

Signed-off-by: Bharath Ravi <rbharath@google.com>
---
 kernel/trace/trace.c              |  6 ++++--
 kernel/trace/trace.h              | 44 +++++++++++++++++++--------------------
 kernel/trace/trace_irqsoff.c      |  2 +-
 kernel/trace/trace_sched_wakeup.c |  2 +-
 4 files changed, 28 insertions(+), 26 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 61f2301..e61875b 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -774,6 +774,9 @@ unsigned long nsecs_to_usecs(unsigned long nsecs)
 
 /* These must match the bit postions in trace_iterator_flags */
 static const char *trace_options[] = {
+	/* Instance specific flags */
+	"overwrite",
+	/* Global flags */
 	"print-parent",
 	"sym-offset",
 	"sym-addr",
@@ -795,7 +798,6 @@ static const char *trace_options[] = {
 	"sleep-time",
 	"graph-time",
 	"record-cmd",
-	"overwrite",
 	"disable_on_free",
 	"irq-info",
 	"markers",
@@ -808,7 +810,7 @@ static const char *trace_options[] = {
  * equal to this are global flags, while indices smaller than this are
  * per-instance flags.
  */
-static const int global_flags_start;
+static const int global_flags_start = 1;
 
 static struct {
 	u64 (*func)(void);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 38b511a..6359d4d 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -867,28 +867,28 @@ extern int trace_get_user(struct trace_parser *parser, const char __user *ubuf,
  *       trace.c.
  */
 enum trace_iterator_flags {
-	TRACE_ITER_PRINT_PARENT		= 0x01,
-	TRACE_ITER_SYM_OFFSET		= 0x02,
-	TRACE_ITER_SYM_ADDR		= 0x04,
-	TRACE_ITER_VERBOSE		= 0x08,
-	TRACE_ITER_RAW			= 0x10,
-	TRACE_ITER_HEX			= 0x20,
-	TRACE_ITER_BIN			= 0x40,
-	TRACE_ITER_BLOCK		= 0x80,
-	TRACE_ITER_STACKTRACE		= 0x100,
-	TRACE_ITER_PRINTK		= 0x200,
-	TRACE_ITER_PREEMPTONLY		= 0x400,
-	TRACE_ITER_BRANCH		= 0x800,
-	TRACE_ITER_ANNOTATE		= 0x1000,
-	TRACE_ITER_USERSTACKTRACE       = 0x2000,
-	TRACE_ITER_SYM_USEROBJ          = 0x4000,
-	TRACE_ITER_PRINTK_MSGONLY	= 0x8000,
-	TRACE_ITER_CONTEXT_INFO		= 0x10000, /* Print pid/cpu/time */
-	TRACE_ITER_LATENCY_FMT		= 0x20000,
-	TRACE_ITER_SLEEP_TIME		= 0x40000,
-	TRACE_ITER_GRAPH_TIME		= 0x80000,
-	TRACE_ITER_RECORD_CMD		= 0x100000,
-	TRACE_ITER_OVERWRITE		= 0x200000,
+	TRACE_ITER_OVERWRITE		= 0x01,
+	TRACE_ITER_PRINT_PARENT		= 0x02,
+	TRACE_ITER_SYM_OFFSET		= 0x04,
+	TRACE_ITER_SYM_ADDR		= 0x08,
+	TRACE_ITER_VERBOSE		= 0x10,
+	TRACE_ITER_RAW			= 0x20,
+	TRACE_ITER_HEX			= 0x40,
+	TRACE_ITER_BIN			= 0x80,
+	TRACE_ITER_BLOCK		= 0x100,
+	TRACE_ITER_STACKTRACE		= 0x200,
+	TRACE_ITER_PRINTK		= 0x400,
+	TRACE_ITER_PREEMPTONLY		= 0x800,
+	TRACE_ITER_BRANCH		= 0x1000,
+	TRACE_ITER_ANNOTATE		= 0x2000,
+	TRACE_ITER_USERSTACKTRACE       = 0x4000,
+	TRACE_ITER_SYM_USEROBJ          = 0x8000,
+	TRACE_ITER_PRINTK_MSGONLY	= 0x10000,
+	TRACE_ITER_CONTEXT_INFO		= 0x20000, /* Print pid/cpu/time */
+	TRACE_ITER_LATENCY_FMT		= 0x40000,
+	TRACE_ITER_SLEEP_TIME		= 0x80000,
+	TRACE_ITER_GRAPH_TIME		= 0x100000,
+	TRACE_ITER_RECORD_CMD		= 0x200000,
 	TRACE_ITER_STOP_ON_FREE		= 0x400000,
 	TRACE_ITER_IRQ_INFO		= 0x800000,
 	TRACE_ITER_MARKERS		= 0x1000000,
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index 4943166..b0dcba5 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -601,7 +601,7 @@ static void stop_irqsoff_tracer(struct trace_array *tr, int graph)
 
 static void __irqsoff_tracer_init(struct trace_array *tr)
 {
-	save_flags = global_trace_flags();
+	save_flags = tr->trace_flags;
 
 	/* non overwrite screws up the latency tracers */
 	set_tracer_flag(tr, TRACE_ITER_OVERWRITE, 1);
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index d643705..afdbbf0 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -606,7 +606,7 @@ static void stop_wakeup_tracer(struct trace_array *tr)
 
 static int __wakeup_tracer_init(struct trace_array *tr)
 {
-	save_flags = global_trace_flags();
+	save_flags = tr->trace_flags;
 
 	/* non overwrite screws up the latency tracers */
 	set_tracer_flag(tr, TRACE_ITER_OVERWRITE, 1);
-- 
1.9.1.423.g4596e3a

