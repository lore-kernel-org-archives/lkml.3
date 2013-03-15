Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932221Ab3COTwM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 15:52:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21975 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932108Ab3COTv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 15:51:29 -0400
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=SUC6q-5BkCEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=oNKFovVKJZUA:10 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=R3ehyQnb1MiKcFd4aJMA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=Zh68SRI7RUMA:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=mVmoNQkoYjb3L806PqkA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130315195125.338441189@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 15 Mar 2013 15:39:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Clark Williams <williams@redhat.com>, John Kacur <jkacur@redhat.com>
Subject: [for-next][PATCH 17/20] tracing: Add function-trace option to disable function tracing of
 latency tracers
References: <20130315193935.359219613@goodmis.org>
Content-Disposition: inline; filename=0017-tracing-Add-function-trace-option-to-disable-functio.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Currently, the only way to stop the latency tracers from doing function
tracing is to fully disable the function tracer from the proc file
system:

  echo 0 > /proc/sys/kernel/ftrace_enabled

This is a big hammer approach as it disables function tracing for
all users. This includes kprobes, perf, stack tracer, etc.

Instead, create a function-trace option that the latency tracers can
check to determine if it should enable function tracing or not.
This option can be set or cleared even while the tracer is active
and the tracers will disable or enable function tracing depending
on how the option was set.

Instead of using the proc file, disable latency function tracing with

  echo 0 > /debug/tracing/options/function-trace

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Clark Williams <williams@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c              |    3 +-
 kernel/trace/trace.h              |    1 +
 kernel/trace/trace_irqsoff.c      |   67 ++++++++++++++++++++++++++++++---=
----
 kernel/trace/trace_sched_wakeup.c |   63 ++++++++++++++++++++++++++++------
 4 files changed, 111 insertions(+), 23 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 8aa5321..f90ca16 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -328,7 +328,7 @@ static inline void trace_access_lock_init(void)
 unsigned long trace_flags =3D TRACE_ITER_PRINT_PARENT | TRACE_ITER_PRINTK |
 	TRACE_ITER_ANNOTATE | TRACE_ITER_CONTEXT_INFO | TRACE_ITER_SLEEP_TIME |
 	TRACE_ITER_GRAPH_TIME | TRACE_ITER_RECORD_CMD | TRACE_ITER_OVERWRITE |
-	TRACE_ITER_IRQ_INFO | TRACE_ITER_MARKERS;
+	TRACE_ITER_IRQ_INFO | TRACE_ITER_MARKERS | TRACE_ITER_FUNCTION;
=20
 /**
  * tracing_on - enable tracing buffers
@@ -635,6 +635,7 @@ static const char *trace_options[] =3D {
 	"disable_on_free",
 	"irq-info",
 	"markers",
+	"function-trace",
 	NULL
 };
=20
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 0e430b4..5cc5236 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -867,6 +867,7 @@ enum trace_iterator_flags {
 	TRACE_ITER_STOP_ON_FREE		=3D 0x400000,
 	TRACE_ITER_IRQ_INFO		=3D 0x800000,
 	TRACE_ITER_MARKERS		=3D 0x1000000,
+	TRACE_ITER_FUNCTION		=3D 0x2000000,
 };
=20
 /*
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index 5aa40ab..b19d065 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -33,6 +33,7 @@ enum {
 static int trace_type __read_mostly;
=20
 static int save_flags;
+static bool function_enabled;
=20
 static void stop_irqsoff_tracer(struct trace_array *tr, int graph);
 static int start_irqsoff_tracer(struct trace_array *tr, int graph);
@@ -528,15 +529,60 @@ void trace_preempt_off(unsigned long a0, unsigned lon=
g a1)
 }
 #endif /* CONFIG_PREEMPT_TRACER */
=20
-static int start_irqsoff_tracer(struct trace_array *tr, int graph)
+static int register_irqsoff_function(int graph, int set)
 {
-	int ret =3D 0;
+	int ret;
=20
-	if (!graph)
-		ret =3D register_ftrace_function(&trace_ops);
-	else
+	/* 'set' is set if TRACE_ITER_FUNCTION is about to be set */
+	if (function_enabled || (!set && !(trace_flags & TRACE_ITER_FUNCTION)))
+		return 0;
+
+	if (graph)
 		ret =3D register_ftrace_graph(&irqsoff_graph_return,
 					    &irqsoff_graph_entry);
+	else
+		ret =3D register_ftrace_function(&trace_ops);
+
+	if (!ret)
+		function_enabled =3D true;
+
+	return ret;
+}
+
+static void unregister_irqsoff_function(int graph)
+{
+	if (!function_enabled)
+		return;
+
+	if (graph)
+		unregister_ftrace_graph();
+	else
+		unregister_ftrace_function(&trace_ops);
+
+	function_enabled =3D false;
+}
+
+static void irqsoff_function_set(int set)
+{
+	if (set)
+		register_irqsoff_function(is_graph(), 1);
+	else
+		unregister_irqsoff_function(is_graph());
+}
+
+static int irqsoff_flag_changed(struct tracer *tracer, u32 mask, int set)
+{
+	if (mask & TRACE_ITER_FUNCTION)
+		irqsoff_function_set(set);
+
+	return trace_keep_overwrite(tracer, mask, set);
+}
+
+static int start_irqsoff_tracer(struct trace_array *tr, int graph)
+{
+	int ret;
+
+	ret =3D register_irqsoff_function(graph, 0);
=20
 	if (!ret && tracing_is_enabled())
 		tracer_enabled =3D 1;
@@ -550,10 +596,7 @@ static void stop_irqsoff_tracer(struct trace_array *tr=
, int graph)
 {
 	tracer_enabled =3D 0;
=20
-	if (!graph)
-		unregister_ftrace_function(&trace_ops);
-	else
-		unregister_ftrace_graph();
+	unregister_irqsoff_function(graph);
 }
=20
 static void __irqsoff_tracer_init(struct trace_array *tr)
@@ -615,7 +658,7 @@ static struct tracer irqsoff_tracer __read_mostly =3D
 	.print_line     =3D irqsoff_print_line,
 	.flags		=3D &tracer_flags,
 	.set_flag	=3D irqsoff_set_flag,
-	.flag_changed	=3D trace_keep_overwrite,
+	.flag_changed	=3D irqsoff_flag_changed,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    =3D trace_selftest_startup_irqsoff,
 #endif
@@ -649,7 +692,7 @@ static struct tracer preemptoff_tracer __read_mostly =3D
 	.print_line     =3D irqsoff_print_line,
 	.flags		=3D &tracer_flags,
 	.set_flag	=3D irqsoff_set_flag,
-	.flag_changed	=3D trace_keep_overwrite,
+	.flag_changed	=3D irqsoff_flag_changed,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    =3D trace_selftest_startup_preemptoff,
 #endif
@@ -685,7 +728,7 @@ static struct tracer preemptirqsoff_tracer __read_mostl=
y =3D
 	.print_line     =3D irqsoff_print_line,
 	.flags		=3D &tracer_flags,
 	.set_flag	=3D irqsoff_set_flag,
-	.flag_changed	=3D trace_keep_overwrite,
+	.flag_changed	=3D irqsoff_flag_changed,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    =3D trace_selftest_startup_preemptirqsoff,
 #endif
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_w=
akeup.c
index c16f8cd..fee77e1 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -37,6 +37,7 @@ static int wakeup_graph_entry(struct ftrace_graph_ent *tr=
ace);
 static void wakeup_graph_return(struct ftrace_graph_ret *trace);
=20
 static int save_flags;
+static bool function_enabled;
=20
 #define TRACE_DISPLAY_GRAPH     1
=20
@@ -134,15 +135,60 @@ static struct ftrace_ops trace_ops __read_mostly =3D
 };
 #endif /* CONFIG_FUNCTION_TRACER */
=20
-static int start_func_tracer(int graph)
+static int register_wakeup_function(int graph, int set)
 {
 	int ret;
=20
-	if (!graph)
-		ret =3D register_ftrace_function(&trace_ops);
-	else
+	/* 'set' is set if TRACE_ITER_FUNCTION is about to be set */
+	if (function_enabled || (!set && !(trace_flags & TRACE_ITER_FUNCTION)))
+		return 0;
+
+	if (graph)
 		ret =3D register_ftrace_graph(&wakeup_graph_return,
 					    &wakeup_graph_entry);
+	else
+		ret =3D register_ftrace_function(&trace_ops);
+
+	if (!ret)
+		function_enabled =3D true;
+
+	return ret;
+}
+
+static void unregister_wakeup_function(int graph)
+{
+	if (!function_enabled)
+		return;
+
+	if (graph)
+		unregister_ftrace_graph();
+	else
+		unregister_ftrace_function(&trace_ops);
+
+	function_enabled =3D false;
+}
+
+static void wakeup_function_set(int set)
+{
+	if (set)
+		register_wakeup_function(is_graph(), 1);
+	else
+		unregister_wakeup_function(is_graph());
+}
+
+static int wakeup_flag_changed(struct tracer *tracer, u32 mask, int set)
+{
+	if (mask & TRACE_ITER_FUNCTION)
+		wakeup_function_set(set);
+
+	return trace_keep_overwrite(tracer, mask, set);
+}
+
+static int start_func_tracer(int graph)
+{
+	int ret;
+
+	ret =3D register_wakeup_function(graph, 0);
=20
 	if (!ret && tracing_is_enabled())
 		tracer_enabled =3D 1;
@@ -156,10 +202,7 @@ static void stop_func_tracer(int graph)
 {
 	tracer_enabled =3D 0;
=20
-	if (!graph)
-		unregister_ftrace_function(&trace_ops);
-	else
-		unregister_ftrace_graph();
+	unregister_wakeup_function(graph);
 }
=20
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
@@ -600,7 +643,7 @@ static struct tracer wakeup_tracer __read_mostly =3D
 	.print_line	=3D wakeup_print_line,
 	.flags		=3D &tracer_flags,
 	.set_flag	=3D wakeup_set_flag,
-	.flag_changed	=3D trace_keep_overwrite,
+	.flag_changed	=3D wakeup_flag_changed,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    =3D trace_selftest_startup_wakeup,
 #endif
@@ -622,7 +665,7 @@ static struct tracer wakeup_rt_tracer __read_mostly =3D
 	.print_line	=3D wakeup_print_line,
 	.flags		=3D &tracer_flags,
 	.set_flag	=3D wakeup_set_flag,
-	.flag_changed	=3D trace_keep_overwrite,
+	.flag_changed	=3D wakeup_flag_changed,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    =3D trace_selftest_startup_wakeup,
 #endif
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRQ3u9AAoJEOdOSU1xswtM4bEIAJspjG2Q70dX8/pfopHb4YLd
1Wf3JuuvxXNWaO4vPzI4FuYB2cAlsiNXCvvqKJioVwgHw1cE4XYnaA8BB7swTWbA
4o0csowK8E8QfaBgDnqMwrLec7VGuk8UNHeuGIuKH2oKBkWKVkzY2TQ1xkV3FgrE
WtouPUvR6PYKVMeKtbvsAcY4ku6UMPOaA1b64Ku9QTuRWMyzFm2+aJku6rvO3IMf
zGcyQgDr2kOpAEkNEcEkRHshH2rzfKu399m7+cA0PAs/fpmTSmwFIKhJHSuWRlCc
/r4ap49nVMUMI+szopcTm7PH6VeEM5B14JoZ73DlypuJ6Py5E9ZZ2+Uan2xlMEI=
=zEfV
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
