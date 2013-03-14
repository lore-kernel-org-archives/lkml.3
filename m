Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168Ab3CNVlO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 17:41:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24358 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654Ab3CNVka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 17:40:30 -0400
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=4aMfGutIp-sA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=3Axxf1bwaxsA:10 a=VwQbUJbxAAAA:8 a=RpGju85Lc3TszkA24hcA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=RoLzSC8QgVLrqxJN2ZUA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130314214029.308491197@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 14 Mar 2013 17:33:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, <stable@vger.kernel.org>
Subject: [PATCH 3/3] tracing: Prevent buffer overwrite disabled for latency tracers
References: <20130314213303.302538352@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-Prevent-buffer-overwrite-disabled-for-latenc.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The latency tracers require the buffers to be in overwrite mode,
otherwise they get screwed up. Force the buffers to stay in overwrite
mode when latency tracers are enabled.

Added a flag_changed() method to the tracer structure to allow
the tracers to see what flags are being changed, and also be able
to prevent the change from happing.

Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c              |   38 +++++++++++++++++++++++++++++++--=
----
 kernel/trace/trace.h              |    6 ++++++
 kernel/trace/trace_irqsoff.c      |   19 ++++++++++++++-----
 kernel/trace/trace_sched_wakeup.c |   18 +++++++++++++-----
 4 files changed, 65 insertions(+), 16 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index eaaccd8..1354f5d 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2881,11 +2881,25 @@ static int set_tracer_option(struct tracer *trace, =
char *cmp, int neg)
 	return -EINVAL;
 }
=20
-static void set_tracer_flags(unsigned int mask, int enabled)
+/* Some tracers require overwrite to stay enabled */
+int trace_keep_overwrite(struct tracer *tracer, u32 mask, int set)
+{
+	if (tracer->enabled && (mask & TRACE_ITER_OVERWRITE) && !set)
+		return -1;
+
+	return 0;
+}
+
+int set_tracer_flag(unsigned int mask, int enabled)
 {
 	/* do nothing if flag is already set */
 	if (!!(trace_flags & mask) =3D=3D !!enabled)
-		return;
+		return 0;
+
+	/* Give the tracer a chance to approve the change */
+	if (current_trace->flag_changed)
+		if (current_trace->flag_changed(current_trace, mask, !!enabled))
+			return -EINVAL;
=20
 	if (enabled)
 		trace_flags |=3D mask;
@@ -2902,13 +2916,15 @@ static void set_tracer_flags(unsigned int mask, int=
 enabled)
=20
 	if (mask =3D=3D TRACE_ITER_PRINTK)
 		trace_printk_start_stop_comm(enabled);
+
+	return 0;
 }
=20
 static int trace_set_options(char *option)
 {
 	char *cmp;
 	int neg =3D 0;
-	int ret =3D 0;
+	int ret =3D -ENODEV;
 	int i;
=20
 	cmp =3D strstrip(option);
@@ -2922,7 +2938,7 @@ static int trace_set_options(char *option)
=20
 	for (i =3D 0; trace_options[i]; i++) {
 		if (strcmp(cmp, trace_options[i]) =3D=3D 0) {
-			set_tracer_flags(1 << i, !neg);
+			ret =3D set_tracer_flag(1 << i, !neg);
 			break;
 		}
 	}
@@ -2941,6 +2957,7 @@ tracing_trace_options_write(struct file *filp, const =
char __user *ubuf,
 			size_t cnt, loff_t *ppos)
 {
 	char buf[64];
+	int ret;
=20
 	if (cnt >=3D sizeof(buf))
 		return -EINVAL;
@@ -2950,7 +2967,9 @@ tracing_trace_options_write(struct file *filp, const =
char __user *ubuf,
=20
 	buf[cnt] =3D 0;
=20
-	trace_set_options(buf);
+	ret =3D trace_set_options(buf);
+	if (ret < 0)
+		return ret;
=20
 	*ppos +=3D cnt;
=20
@@ -3254,6 +3273,9 @@ static int tracing_set_tracer(const char *buf)
 		goto out;
=20
 	trace_branch_disable();
+
+	current_trace->enabled =3D false;
+
 	if (current_trace->reset)
 		current_trace->reset(tr);
=20
@@ -3298,6 +3320,7 @@ static int tracing_set_tracer(const char *buf)
 	}
=20
 	current_trace =3D t;
+	current_trace->enabled =3D true;
 	trace_branch_enable(tr);
  out:
 	mutex_unlock(&trace_types_lock);
@@ -4786,9 +4809,12 @@ trace_options_core_write(struct file *filp, const ch=
ar __user *ubuf, size_t cnt,
 		return -EINVAL;
=20
 	mutex_lock(&trace_types_lock);
-	set_tracer_flags(1 << index, val);
+	ret =3D set_tracer_flag(1 << index, val);
 	mutex_unlock(&trace_types_lock);
=20
+	if (ret < 0)
+		return ret;
+
 	*ppos +=3D cnt;
=20
 	return cnt;
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 57d7e53..2081971 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -283,11 +283,15 @@ struct tracer {
 	enum print_line_t	(*print_line)(struct trace_iterator *iter);
 	/* If you handled the flag setting, return 0 */
 	int			(*set_flag)(u32 old_flags, u32 bit, int set);
+	/* Return 0 if OK with change, else return non-zero */
+	int			(*flag_changed)(struct tracer *tracer,
+						u32 mask, int set);
 	struct tracer		*next;
 	struct tracer_flags	*flags;
 	bool			print_max;
 	bool			use_max_tr;
 	bool			allocated_snapshot;
+	bool			enabled;
 };
=20
=20
@@ -943,6 +947,8 @@ extern const char *__stop___trace_bprintk_fmt[];
=20
 void trace_printk_init_buffers(void);
 void trace_printk_start_comm(void);
+int trace_keep_overwrite(struct tracer *tracer, u32 mask, int set);
+int set_tracer_flag(unsigned int mask, int enabled);
=20
 #undef FTRACE_ENTRY
 #define FTRACE_ENTRY(call, struct_name, id, tstruct, print, filter)	\
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index 713a2ca..443b25b 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -32,7 +32,7 @@ enum {
=20
 static int trace_type __read_mostly;
=20
-static int save_lat_flag;
+static int save_flags;
=20
 static void stop_irqsoff_tracer(struct trace_array *tr, int graph);
 static int start_irqsoff_tracer(struct trace_array *tr, int graph);
@@ -558,8 +558,11 @@ static void stop_irqsoff_tracer(struct trace_array *tr=
, int graph)
=20
 static void __irqsoff_tracer_init(struct trace_array *tr)
 {
-	save_lat_flag =3D trace_flags & TRACE_ITER_LATENCY_FMT;
-	trace_flags |=3D TRACE_ITER_LATENCY_FMT;
+	save_flags =3D trace_flags;
+
+	/* non overwrite screws up the latency tracers */
+	set_tracer_flag(TRACE_ITER_OVERWRITE, 1);
+	set_tracer_flag(TRACE_ITER_LATENCY_FMT, 1);
=20
 	tracing_max_latency =3D 0;
 	irqsoff_trace =3D tr;
@@ -573,10 +576,13 @@ static void __irqsoff_tracer_init(struct trace_array =
*tr)
=20
 static void irqsoff_tracer_reset(struct trace_array *tr)
 {
+	int lat_flag =3D save_flags & TRACE_ITER_LATENCY_FMT;
+	int overwrite_flag =3D save_flags & TRACE_ITER_OVERWRITE;
+
 	stop_irqsoff_tracer(tr, is_graph());
=20
-	if (!save_lat_flag)
-		trace_flags &=3D ~TRACE_ITER_LATENCY_FMT;
+	set_tracer_flag(TRACE_ITER_LATENCY_FMT, lat_flag);
+	set_tracer_flag(TRACE_ITER_OVERWRITE, overwrite_flag);
 }
=20
 static void irqsoff_tracer_start(struct trace_array *tr)
@@ -609,6 +615,7 @@ static struct tracer irqsoff_tracer __read_mostly =3D
 	.print_line     =3D irqsoff_print_line,
 	.flags		=3D &tracer_flags,
 	.set_flag	=3D irqsoff_set_flag,
+	.flag_changed	=3D trace_keep_overwrite,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    =3D trace_selftest_startup_irqsoff,
 #endif
@@ -642,6 +649,7 @@ static struct tracer preemptoff_tracer __read_mostly =3D
 	.print_line     =3D irqsoff_print_line,
 	.flags		=3D &tracer_flags,
 	.set_flag	=3D irqsoff_set_flag,
+	.flag_changed	=3D trace_keep_overwrite,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    =3D trace_selftest_startup_preemptoff,
 #endif
@@ -677,6 +685,7 @@ static struct tracer preemptirqsoff_tracer __read_mostl=
y =3D
 	.print_line     =3D irqsoff_print_line,
 	.flags		=3D &tracer_flags,
 	.set_flag	=3D irqsoff_set_flag,
+	.flag_changed	=3D trace_keep_overwrite,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    =3D trace_selftest_startup_preemptirqsoff,
 #endif
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_w=
akeup.c
index 75aa97f..fde652c 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -36,7 +36,7 @@ static void __wakeup_reset(struct trace_array *tr);
 static int wakeup_graph_entry(struct ftrace_graph_ent *trace);
 static void wakeup_graph_return(struct ftrace_graph_ret *trace);
=20
-static int save_lat_flag;
+static int save_flags;
=20
 #define TRACE_DISPLAY_GRAPH     1
=20
@@ -540,8 +540,11 @@ static void stop_wakeup_tracer(struct trace_array *tr)
=20
 static int __wakeup_tracer_init(struct trace_array *tr)
 {
-	save_lat_flag =3D trace_flags & TRACE_ITER_LATENCY_FMT;
-	trace_flags |=3D TRACE_ITER_LATENCY_FMT;
+	save_flags =3D trace_flags;
+
+	/* non overwrite screws up the latency tracers */
+	set_tracer_flag(TRACE_ITER_OVERWRITE, 1);
+	set_tracer_flag(TRACE_ITER_LATENCY_FMT, 1);
=20
 	tracing_max_latency =3D 0;
 	wakeup_trace =3D tr;
@@ -563,12 +566,15 @@ static int wakeup_rt_tracer_init(struct trace_array *=
tr)
=20
 static void wakeup_tracer_reset(struct trace_array *tr)
 {
+	int lat_flag =3D save_flags & TRACE_ITER_LATENCY_FMT;
+	int overwrite_flag =3D save_flags & TRACE_ITER_OVERWRITE;
+
 	stop_wakeup_tracer(tr);
 	/* make sure we put back any tasks we are tracing */
 	wakeup_reset(tr);
=20
-	if (!save_lat_flag)
-		trace_flags &=3D ~TRACE_ITER_LATENCY_FMT;
+	set_tracer_flag(TRACE_ITER_LATENCY_FMT, lat_flag);
+	set_tracer_flag(TRACE_ITER_OVERWRITE, overwrite_flag);
 }
=20
 static void wakeup_tracer_start(struct trace_array *tr)
@@ -594,6 +600,7 @@ static struct tracer wakeup_tracer __read_mostly =3D
 	.print_line	=3D wakeup_print_line,
 	.flags		=3D &tracer_flags,
 	.set_flag	=3D wakeup_set_flag,
+	.flag_changed	=3D trace_keep_overwrite,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    =3D trace_selftest_startup_wakeup,
 #endif
@@ -615,6 +622,7 @@ static struct tracer wakeup_rt_tracer __read_mostly =3D
 	.print_line	=3D wakeup_print_line,
 	.flags		=3D &tracer_flags,
 	.set_flag	=3D wakeup_set_flag,
+	.flag_changed	=3D trace_keep_overwrite,
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

iQEcBAABAgAGBQJRQkPNAAoJEOdOSU1xswtMoqgIAJLarrXj8CnBudPpJFShf/0C
hloVGoLb3lQRUD0AJS1DzvgvxPosgdQtu4K3gNlvyyQUsvvX2iux8qPkEfE9vtEZ
SxGtQBQ63hV8KtE9Iwc8RuzEOepXSPXoY9cJ+mNA6Q/4UnH5MHjwL2S3GKHRvsvz
mH6MbOLlwrTiGSbW/L0LtmiCXkYiqWk0fHm4WPcg4l/voMkrjZxVlnh7YDDuKRW1
AfYRNv1bmJUgOinmNB1AS4frxBUrZfPlqIi7UUIUps+PIRkfIXSadWK8/nzYmhHq
y0Fkyk1P09LEHylLZjLDie2syY1Uo9T4Tf2TAlHTqdHkO9E8lmnFk3P1r/cD8po=
=N1jv
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
