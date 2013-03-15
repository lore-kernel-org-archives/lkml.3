Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932275Ab3COTxL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 15:53:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27573 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755434Ab3COTv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 15:51:27 -0400
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=LZeOiBshvH8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=q7izd8dhLW4A:10 a=BbLmiaFJiMmzLd_09KYA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=pL8ehe5o7oPLC27hingA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130315195124.516791964@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 15 Mar 2013 15:39:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [for-next][PATCH 13/20] tracing: Add function probe to trigger stack traces
References: <20130315193935.359219613@goodmis.org>
Content-Disposition: inline; filename=0013-tracing-Add-function-probe-to-trigger-stack-traces.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Add a function probe that will cause a stack trace to be traced in
the ring buffer when the given function(s) are called.

format is:

 <function>:stacktrace[:<count>]

 echo 'schedule:stacktrace' > /debug/tracing/set_ftrace_filter
 cat /debug/tracing/trace_pipe
     kworker/2:0-4329  [002] ...2  2933.558007: <stack trace>
 =3D> kthread
 =3D> ret_from_fork
          <idle>-0     [000] .N.2  2933.558019: <stack trace>
 =3D> rest_init
 =3D> start_kernel
 =3D> x86_64_start_reservations
 =3D> x86_64_start_kernel
     kworker/2:0-4329  [002] ...2  2933.558109: <stack trace>
 =3D> kthread
 =3D> ret_from_fork
[...]

This can be set to only trace a specific amount of times:

 echo 'schedule:stacktrace:3' > /debug/tracing/set_ftrace_filter
 cat /debug/tracing/trace_pipe
           <...>-58    [003] ...2   841.801694: <stack trace>
 =3D> kthread
 =3D> ret_from_fork
          <idle>-0     [001] .N.2   841.801697: <stack trace>
 =3D> start_secondary
           <...>-2059  [001] ...2   841.801736: <stack trace>
 =3D> wait_for_common
 =3D> wait_for_completion
 =3D> flush_work
 =3D> tty_flush_to_ldisc
 =3D> input_available_p
 =3D> n_tty_poll
 =3D> tty_poll
 =3D> do_select
 =3D> core_sys_select
 =3D> sys_select
 =3D> system_call_fastpath

To remove these:

 echo '!schedule:stacktrace' > /debug/tracing/set_ftrace_filter
 echo '!schedule:stacktrace:0' > /debug/tracing/set_ftrace_filter

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_functions.c |  150 ++++++++++++++++++++++++++++++------=
----
 1 file changed, 115 insertions(+), 35 deletions(-)

diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index 043b242..c4d6d71 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -265,56 +265,103 @@ ftrace_traceoff(unsigned long ip, unsigned long pare=
nt_ip, void **data)
 	tracing_off();
 }
=20
+/*
+ * Skip 4:
+ *   ftrace_stacktrace()
+ *   function_trace_probe_call()
+ *   ftrace_ops_list_func()
+ *   ftrace_call()
+ */
+#define STACK_SKIP 4
+
+static void
+ftrace_stacktrace(unsigned long ip, unsigned long parent_ip, void **data)
+{
+	trace_dump_stack(STACK_SKIP);
+}
+
+static void
+ftrace_stacktrace_count(unsigned long ip, unsigned long parent_ip, void **=
data)
+{
+	if (!tracing_is_on())
+		return;
+
+	if (update_count(data))
+		trace_dump_stack(STACK_SKIP);
+}
+
 static int
-ftrace_trace_onoff_print(struct seq_file *m, unsigned long ip,
-			 struct ftrace_probe_ops *ops, void *data);
+ftrace_probe_print(const char *name, struct seq_file *m,
+		   unsigned long ip, void *data)
+{
+	long count =3D (long)data;
+
+	seq_printf(m, "%ps:%s", (void *)ip, name);
+
+	if (count =3D=3D -1)
+		seq_printf(m, ":unlimited\n");
+	else
+		seq_printf(m, ":count=3D%ld\n", count);
+
+	return 0;
+}
+
+static int
+ftrace_traceon_print(struct seq_file *m, unsigned long ip,
+			 struct ftrace_probe_ops *ops, void *data)
+{
+	return ftrace_probe_print("traceon", m, ip, data);
+}
+
+static int
+ftrace_traceoff_print(struct seq_file *m, unsigned long ip,
+			 struct ftrace_probe_ops *ops, void *data)
+{
+	return ftrace_probe_print("traceoff", m, ip, data);
+}
+
+static int
+ftrace_stacktrace_print(struct seq_file *m, unsigned long ip,
+			struct ftrace_probe_ops *ops, void *data)
+{
+	return ftrace_probe_print("stacktrace", m, ip, data);
+}
=20
 static struct ftrace_probe_ops traceon_count_probe_ops =3D {
 	.func			=3D ftrace_traceon_count,
-	.print			=3D ftrace_trace_onoff_print,
+	.print			=3D ftrace_traceon_print,
 };
=20
 static struct ftrace_probe_ops traceoff_count_probe_ops =3D {
 	.func			=3D ftrace_traceoff_count,
-	.print			=3D ftrace_trace_onoff_print,
+	.print			=3D ftrace_traceoff_print,
+};
+
+static struct ftrace_probe_ops stacktrace_count_probe_ops =3D {
+	.func			=3D ftrace_stacktrace_count,
+	.print			=3D ftrace_stacktrace_print,
 };
=20
 static struct ftrace_probe_ops traceon_probe_ops =3D {
 	.func			=3D ftrace_traceon,
-	.print			=3D ftrace_trace_onoff_print,
+	.print			=3D ftrace_traceon_print,
 };
=20
 static struct ftrace_probe_ops traceoff_probe_ops =3D {
 	.func			=3D ftrace_traceoff,
-	.print			=3D ftrace_trace_onoff_print,
+	.print			=3D ftrace_traceoff_print,
 };
=20
-static int
-ftrace_trace_onoff_print(struct seq_file *m, unsigned long ip,
-			 struct ftrace_probe_ops *ops, void *data)
-{
-	long count =3D (long)data;
-
-	seq_printf(m, "%ps:", (void *)ip);
-
-	if (ops =3D=3D &traceon_probe_ops || ops =3D=3D &traceon_count_probe_ops)
-		seq_printf(m, "traceon");
-	else
-		seq_printf(m, "traceoff");
-
-	if (count =3D=3D -1)
-		seq_printf(m, ":unlimited\n");
-	else
-		seq_printf(m, ":count=3D%ld\n", count);
-
-	return 0;
-}
+static struct ftrace_probe_ops stacktrace_probe_ops =3D {
+	.func			=3D ftrace_stacktrace,
+	.print			=3D ftrace_stacktrace_print,
+};
=20
 static int
-ftrace_trace_onoff_callback(struct ftrace_hash *hash,
-			    char *glob, char *cmd, char *param, int enable)
+ftrace_trace_probe_callback(struct ftrace_probe_ops *ops,
+			    struct ftrace_hash *hash, char *glob,
+			    char *cmd, char *param, int enable)
 {
-	struct ftrace_probe_ops *ops;
 	void *count =3D (void *)-1;
 	char *number;
 	int ret;
@@ -323,12 +370,6 @@ ftrace_trace_onoff_callback(struct ftrace_hash *hash,
 	if (!enable)
 		return -EINVAL;
=20
-	/* we register both traceon and traceoff to this callback */
-	if (strcmp(cmd, "traceon") =3D=3D 0)
-		ops =3D param ? &traceon_count_probe_ops : &traceon_probe_ops;
-	else
-		ops =3D param ? &traceoff_count_probe_ops : &traceoff_probe_ops;
-
 	if (glob[0] =3D=3D '!') {
 		unregister_ftrace_function_probe_func(glob+1, ops);
 		return 0;
@@ -356,6 +397,34 @@ ftrace_trace_onoff_callback(struct ftrace_hash *hash,
 	return ret < 0 ? ret : 0;
 }
=20
+static int
+ftrace_trace_onoff_callback(struct ftrace_hash *hash,
+			    char *glob, char *cmd, char *param, int enable)
+{
+	struct ftrace_probe_ops *ops;
+
+	/* we register both traceon and traceoff to this callback */
+	if (strcmp(cmd, "traceon") =3D=3D 0)
+		ops =3D param ? &traceon_count_probe_ops : &traceon_probe_ops;
+	else
+		ops =3D param ? &traceoff_count_probe_ops : &traceoff_probe_ops;
+
+	return ftrace_trace_probe_callback(ops, hash, glob, cmd,
+					   param, enable);
+}
+
+static int
+ftrace_stacktrace_callback(struct ftrace_hash *hash,
+			   char *glob, char *cmd, char *param, int enable)
+{
+	struct ftrace_probe_ops *ops;
+
+	ops =3D param ? &stacktrace_count_probe_ops : &stacktrace_probe_ops;
+
+	return ftrace_trace_probe_callback(ops, hash, glob, cmd,
+					   param, enable);
+}
+
 static struct ftrace_func_command ftrace_traceon_cmd =3D {
 	.name			=3D "traceon",
 	.func			=3D ftrace_trace_onoff_callback,
@@ -366,6 +435,11 @@ static struct ftrace_func_command ftrace_traceoff_cmd =
=3D {
 	.func			=3D ftrace_trace_onoff_callback,
 };
=20
+static struct ftrace_func_command ftrace_stacktrace_cmd =3D {
+	.name			=3D "stacktrace",
+	.func			=3D ftrace_stacktrace_callback,
+};
+
 static int __init init_func_cmd_traceon(void)
 {
 	int ret;
@@ -377,6 +451,12 @@ static int __init init_func_cmd_traceon(void)
 	ret =3D register_ftrace_command(&ftrace_traceon_cmd);
 	if (ret)
 		unregister_ftrace_command(&ftrace_traceoff_cmd);
+
+	ret =3D register_ftrace_command(&ftrace_stacktrace_cmd);
+	if (ret) {
+		unregister_ftrace_command(&ftrace_traceoff_cmd);
+		unregister_ftrace_command(&ftrace_traceon_cmd);
+	}
 	return ret;
 }
 #else
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRQ3u8AAoJEOdOSU1xswtM2NAH/3bkfAZNDNxsFsGxHm/AWAdp
rO1s1MFJEuOUD66Di71PySgQfsuk7kMtM4v4SZotz1ueEkpv4n32oJra7828ZF6T
dpYmky6twa3bERkpxuUVZCXwEOcpQAfm93/aGHSHP1ztmAyULsnkhJiH4zdJDtNJ
K4tC+bJRZnO9la05rt6QdCGxFDkjPRhpcmlbD18FYJjFslGpxd44uNV2Kbijn3X0
7dglNsl+cgT8YtPdIHOIBbKGMoNuOR8LwfB9MNGvYF0LVB9nuY/at/uQBqhm1TP+
LLvI344+eo916osJhk6FMHdzcOOq/Ue+A1317Tm/4MMd4YB2k+Gulo0zwLfCNro=
=i89E
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
