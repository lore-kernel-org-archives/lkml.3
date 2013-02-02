Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757713Ab3BBOUb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 09:20:31 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7481 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757702Ab3BBOT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 09:19:58 -0500
X-Authority-Analysis: v=2.0 cv=NqdTgrhJ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=P70P9Q7y_QkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=XSBahJ-50XkA:10 a=3nbZYyFuAAAA:8 a=VwQbUJbxAAAA:8 a=odetyhV5PsyD5YUBHx8A:9 a=QEXdDO2ut3YA:10 a=EvKJbDF4Ut8A:10 a=jeBq3FmKZ4MA:10 a=WxhvT6mR09wQ8p4LBFsA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130202141956.122392638@goodmis.org>
User-Agent: quilt/0.60-1
Date: Sat, 02 Feb 2013 09:18:50 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Subject: [PATCH 08/11] tracing: Replace static old_tracer check of tracer name
References: <20130202141842.189550803@goodmis.org>
Content-Disposition: inline; filename=0008-tracing-Replace-static-old_tracer-check-of-tracer-na.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>

Currently the trace buffer read functions use a static variable
"old_tracer" for detecting if the current tracer changes. This
was suitable for a single trace file ("trace"), but to add a
snapshot feature that will use the same function for its file,
a check against a static variable is not sufficient.

To use the output functions for two different files, instead of
storing the current tracer in a static variable, as the trace
iterator descriptor contains a pointer to the original current
tracer's name, that pointer can now be used to check if the
current tracer has changed between different reads of the trace
file.

Link: http://lkml.kernel.org/r/20121226025252.3252.9276.stgit@liselsia

Signed-off-by: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |   22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 90a1c71..2c72466 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1948,18 +1948,20 @@ void tracing_iter_reset(struct trace_iterator *iter=
, int cpu)
 static void *s_start(struct seq_file *m, loff_t *pos)
 {
 	struct trace_iterator *iter =3D m->private;
-	static struct tracer *old_tracer;
 	int cpu_file =3D iter->cpu_file;
 	void *p =3D NULL;
 	loff_t l =3D 0;
 	int cpu;
=20
-	/* copy the tracer to avoid using a global lock all around */
+	/*
+	 * copy the tracer to avoid using a global lock all around.
+	 * iter->trace is a copy of current_trace, the pointer to the
+	 * name may be used instead of a strcmp(), as iter->trace->name
+	 * will point to the same string as current_trace->name.
+	 */
 	mutex_lock(&trace_types_lock);
-	if (unlikely(old_tracer !=3D current_trace && current_trace)) {
-		old_tracer =3D current_trace;
+	if (unlikely(current_trace && iter->trace->name !=3D current_trace->name))
 		*iter->trace =3D *current_trace;
-	}
 	mutex_unlock(&trace_types_lock);
=20
 	atomic_inc(&trace_record_cmdline_disabled);
@@ -3494,7 +3496,6 @@ tracing_read_pipe(struct file *filp, char __user *ubu=
f,
 		  size_t cnt, loff_t *ppos)
 {
 	struct trace_iterator *iter =3D filp->private_data;
-	static struct tracer *old_tracer;
 	ssize_t sret;
=20
 	/* return any leftover data */
@@ -3506,10 +3507,8 @@ tracing_read_pipe(struct file *filp, char __user *ub=
uf,
=20
 	/* copy the tracer to avoid using a global lock all around */
 	mutex_lock(&trace_types_lock);
-	if (unlikely(old_tracer !=3D current_trace && current_trace)) {
-		old_tracer =3D current_trace;
+	if (unlikely(current_trace && iter->trace->name !=3D current_trace->name))
 		*iter->trace =3D *current_trace;
-	}
 	mutex_unlock(&trace_types_lock);
=20
 	/*
@@ -3665,7 +3664,6 @@ static ssize_t tracing_splice_read_pipe(struct file *=
filp,
 		.ops		=3D &tracing_pipe_buf_ops,
 		.spd_release	=3D tracing_spd_release_pipe,
 	};
-	static struct tracer *old_tracer;
 	ssize_t ret;
 	size_t rem;
 	unsigned int i;
@@ -3675,10 +3673,8 @@ static ssize_t tracing_splice_read_pipe(struct file =
*filp,
=20
 	/* copy the tracer to avoid using a global lock all around */
 	mutex_lock(&trace_types_lock);
-	if (unlikely(old_tracer !=3D current_trace && current_trace)) {
-		old_tracer =3D current_trace;
+	if (unlikely(current_trace && iter->trace->name !=3D current_trace->name))
 		*iter->trace =3D *current_trace;
-	}
 	mutex_unlock(&trace_types_lock);
=20
 	mutex_lock(&iter->mutex);
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRDSCMAAoJEOdOSU1xswtMryoIAKpZDf7POGETDmhJjXOMmyF1
4/nbkP6VlIcaZN04Jr4dHeoaiQZikNT/ECk5SB98b14RdgkFjSUmPv2kYSFJzTVj
IAOPrH4LhMZcSn0roWr/l57mQb1IBl0qGX4O77+LLrEvHI5wKX/sTImzg92VMII+
4iUvdx55f+HGbHL9l4nZ7w2DGBeBXrEeZeLuJNr4g7xx15ieBVnMcZjsx4nNm8p8
+trkIq5ilpEIUKH4vDnFlFAa6DduUIJrdFzGFk5Ekvg3r9h7v+C45KWqaDQPY9VF
Zh19I1Z8ATx5/+72DFcYOD27oMOY7svylZ+2WBCMrSHHP6bROdUgPxafmOvoHUc=
=MwhJ
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
