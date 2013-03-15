Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180Ab3COTvc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 15:51:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27896 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755319Ab3COTvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 15:51:25 -0400
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=pRrPm5jYulIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=srUwO4zr8J0A:10 a=saPgahRV2OynQ5U1GHMA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=jfAO0grRrDdD787lgLgA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130315195122.885154849@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 15 Mar 2013 15:39:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [for-next][PATCH 05/20] tracing: Add alloc/free_snapshot() to replace duplicate code
References: <20130315193935.359219613@goodmis.org>
Content-Disposition: inline; filename=0005-tracing-Add-alloc-free_snapshot-to-replace-duplicate.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Add alloc_snapshot() and free_snapshot() to allocate and free the
snapshot buffer respectively, and use these to remove duplicate
code.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |   79 +++++++++++++++++++++++++++-------------------=
----
 1 file changed, 42 insertions(+), 37 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 5c53e40..906049c 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -149,14 +149,14 @@ static int __init set_ftrace_dump_on_oops(char *str)
 }
 __setup("ftrace_dump_on_oops", set_ftrace_dump_on_oops);
=20
-static int __init alloc_snapshot(char *str)
+static int __init boot_alloc_snapshot(char *str)
 {
 	allocate_snapshot =3D true;
 	/* We also need the main ring buffer expanded */
 	ring_buffer_expanded =3D true;
 	return 1;
 }
-__setup("alloc_snapshot", alloc_snapshot);
+__setup("alloc_snapshot", boot_alloc_snapshot);
=20
=20
 static char trace_boot_options_buf[MAX_TRACER_SIZE] __initdata;
@@ -470,6 +470,38 @@ EXPORT_SYMBOL_GPL(tracing_snapshot);
=20
 static int resize_buffer_duplicate_size(struct trace_buffer *trace_buf,
 					struct trace_buffer *size_buf, int cpu_id);
+static void set_buffer_entries(struct trace_buffer *buf, unsigned long val=
);
+
+static int alloc_snapshot(struct trace_array *tr)
+{
+	int ret;
+
+	if (!tr->allocated_snapshot) {
+
+		/* allocate spare buffer */
+		ret =3D resize_buffer_duplicate_size(&tr->max_buffer,
+				   &tr->trace_buffer, RING_BUFFER_ALL_CPUS);
+		if (ret < 0)
+			return ret;
+
+		tr->allocated_snapshot =3D true;
+	}
+
+	return 0;
+}
+
+void free_snapshot(struct trace_array *tr)
+{
+	/*
+	 * We don't free the ring buffer. instead, resize it because
+	 * The max_tr ring buffer has some state (e.g. ring->clock) and
+	 * we want preserve it.
+	 */
+	ring_buffer_resize(tr->max_buffer.buffer, 1, RING_BUFFER_ALL_CPUS);
+	set_buffer_entries(&tr->max_buffer, 1);
+	tracing_reset_online_cpus(&tr->max_buffer);
+	tr->allocated_snapshot =3D false;
+}
=20
 /**
  * trace_snapshot_alloc - allocate and take a snapshot of the current buff=
er.
@@ -487,16 +519,9 @@ void tracing_snapshot_alloc(void)
 	struct trace_array *tr =3D &global_trace;
 	int ret;
=20
-	if (!tr->allocated_snapshot) {
-
-		/* allocate spare buffer */
-		ret =3D resize_buffer_duplicate_size(&tr->max_buffer,
-				   &tr->trace_buffer, RING_BUFFER_ALL_CPUS);
-		if (WARN_ON(ret < 0))
-			return;
-
-		tr->allocated_snapshot =3D true;
-	}
+	ret =3D alloc_snapshot(tr);
+	if (WARN_ON(ret < 0))
+		return;
=20
 	tracing_snapshot();
 }
@@ -3581,15 +3606,7 @@ static int tracing_set_tracer(const char *buf)
 		 * so a synchronized_sched() is sufficient.
 		 */
 		synchronize_sched();
-		/*
-		 * We don't free the ring buffer. instead, resize it because
-		 * The max_tr ring buffer has some state (e.g. ring->clock) and
-		 * we want preserve it.
-		 */
-		ring_buffer_resize(tr->max_buffer.buffer, 1, RING_BUFFER_ALL_CPUS);
-		set_buffer_entries(&tr->max_buffer, 1);
-		tracing_reset_online_cpus(&tr->max_buffer);
-		tr->allocated_snapshot =3D false;
+		free_snapshot(tr);
 	}
 #endif
 	destroy_trace_option_files(topts);
@@ -3598,12 +3615,9 @@ static int tracing_set_tracer(const char *buf)
=20
 #ifdef CONFIG_TRACER_MAX_TRACE
 	if (t->use_max_tr && !had_max_tr) {
-		/* we need to make per cpu buffer sizes equivalent */
-		ret =3D resize_buffer_duplicate_size(&tr->max_buffer, &tr->trace_buffer,
-						   RING_BUFFER_ALL_CPUS);
+		ret =3D alloc_snapshot(tr);
 		if (ret < 0)
 			goto out;
-		tr->allocated_snapshot =3D true;
 	}
 #endif
=20
@@ -4475,14 +4489,8 @@ tracing_snapshot_write(struct file *filp, const char=
 __user *ubuf, size_t cnt,
 			ret =3D -EINVAL;
 			break;
 		}
-		if (tr->allocated_snapshot) {
-			/* free spare buffer */
-			ring_buffer_resize(tr->max_buffer.buffer, 1,
-					   RING_BUFFER_ALL_CPUS);
-			set_buffer_entries(&tr->max_buffer, 1);
-			tracing_reset_online_cpus(&tr->max_buffer);
-			tr->allocated_snapshot =3D false;
-		}
+		if (tr->allocated_snapshot)
+			free_snapshot(tr);
 		break;
 	case 1:
 /* Only allow per-cpu swap if the ring buffer supports it */
@@ -4493,12 +4501,9 @@ tracing_snapshot_write(struct file *filp, const char=
 __user *ubuf, size_t cnt,
 		}
 #endif
 		if (!tr->allocated_snapshot) {
-			/* allocate spare buffer */
-			ret =3D resize_buffer_duplicate_size(&tr->max_buffer,
-					&tr->trace_buffer, RING_BUFFER_ALL_CPUS);
+			ret =3D alloc_snapshot(tr);
 			if (ret < 0)
 				break;
-			tr->allocated_snapshot =3D true;
 		}
 		local_irq_disable();
 		/* Now, we're going to swap */
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRQ3u6AAoJEOdOSU1xswtM8PYH/jSkLhXrHA9oZb6h7cYsRiHg
HMs4gDxoqyrUo5YHjgOOXwituxCwsZrwKktXq7L3gRqc44dAli+3PiPwPRRPN5DU
HB0n1ef3rPWZugYDL7Q7fvqujeZUMvS9fror5Nf+jo3glduz6i00Ghyaw7i7dyI2
OC5hakHCBdiljo74dPnhL22TsuiQKk6t5nFiNYFoWFat6Sc1NbC1IOtVLldk0RSZ
WTP4gH4tESLW1WZD2uORf1kQ6lzJAVkCnO5dXvo6nh7L/ftObeL9kOxkEjYbwssy
fHndGvY8/gbMQkStaOKiW4cfak0RaEUiF+Jh/VP9P5346F2nc6KhSWqSX9692Y4=
=sM3E
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
