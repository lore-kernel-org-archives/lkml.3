Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab3COTv1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 15:51:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18130 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302Ab3COTvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 15:51:25 -0400
X-Authority-Analysis: v=2.0 cv=BZhaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=l3YSjOqmpswA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=TUdi6mUyijAA:10 a=ifY9Kg6_1U6U20D1ojwA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=38vPdKtYg7c_gRUIETIA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130315195122.506438048@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 15 Mar 2013 15:39:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [for-next][PATCH 03/20] ftrace: Separate unlimited probes from count limited probes
References: <20130315193935.359219613@goodmis.org>
Content-Disposition: inline; filename=0003-ftrace-Separate-unlimited-probes-from-count-limited-.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The function tracing probes that trigger traceon or traceoff can be
set to unlimited, or given a count of # of times to execute.

By separating these two types of probes, we can then use the dynamic
ftrace function filtering directly, and remove the brute force
"check if this function called is my probe" routines in ftrace.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_functions.c |   38 +++++++++++++++++++++++++++++++++---=
--
 1 file changed, 33 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index a88a3e0..043b242 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -228,7 +228,7 @@ static int update_count(void **data)
 }
=20
 static void
-ftrace_traceon(unsigned long ip, unsigned long parent_ip, void **data)
+ftrace_traceon_count(unsigned long ip, unsigned long parent_ip, void **dat=
a)
 {
 	if (tracing_is_on())
 		return;
@@ -238,7 +238,7 @@ ftrace_traceon(unsigned long ip, unsigned long parent_i=
p, void **data)
 }
=20
 static void
-ftrace_traceoff(unsigned long ip, unsigned long parent_ip, void **data)
+ftrace_traceoff_count(unsigned long ip, unsigned long parent_ip, void **da=
ta)
 {
 	if (!tracing_is_on())
 		return;
@@ -247,10 +247,38 @@ ftrace_traceoff(unsigned long ip, unsigned long paren=
t_ip, void **data)
 		tracing_off();
 }
=20
+static void
+ftrace_traceon(unsigned long ip, unsigned long parent_ip, void **data)
+{
+	if (tracing_is_on())
+		return;
+
+	tracing_on();
+}
+
+static void
+ftrace_traceoff(unsigned long ip, unsigned long parent_ip, void **data)
+{
+	if (!tracing_is_on())
+		return;
+
+	tracing_off();
+}
+
 static int
 ftrace_trace_onoff_print(struct seq_file *m, unsigned long ip,
 			 struct ftrace_probe_ops *ops, void *data);
=20
+static struct ftrace_probe_ops traceon_count_probe_ops =3D {
+	.func			=3D ftrace_traceon_count,
+	.print			=3D ftrace_trace_onoff_print,
+};
+
+static struct ftrace_probe_ops traceoff_count_probe_ops =3D {
+	.func			=3D ftrace_traceoff_count,
+	.print			=3D ftrace_trace_onoff_print,
+};
+
 static struct ftrace_probe_ops traceon_probe_ops =3D {
 	.func			=3D ftrace_traceon,
 	.print			=3D ftrace_trace_onoff_print,
@@ -269,7 +297,7 @@ ftrace_trace_onoff_print(struct seq_file *m, unsigned l=
ong ip,
=20
 	seq_printf(m, "%ps:", (void *)ip);
=20
-	if (ops =3D=3D &traceon_probe_ops)
+	if (ops =3D=3D &traceon_probe_ops || ops =3D=3D &traceon_count_probe_ops)
 		seq_printf(m, "traceon");
 	else
 		seq_printf(m, "traceoff");
@@ -297,9 +325,9 @@ ftrace_trace_onoff_callback(struct ftrace_hash *hash,
=20
 	/* we register both traceon and traceoff to this callback */
 	if (strcmp(cmd, "traceon") =3D=3D 0)
-		ops =3D &traceon_probe_ops;
+		ops =3D param ? &traceon_count_probe_ops : &traceon_probe_ops;
 	else
-		ops =3D &traceoff_probe_ops;
+		ops =3D param ? &traceoff_count_probe_ops : &traceoff_probe_ops;
=20
 	if (glob[0] =3D=3D '!') {
 		unregister_ftrace_function_probe_func(glob+1, ops);
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRQ3u6AAoJEOdOSU1xswtMtTQH/2mfq2xQEkuy/Ar/cRpP5n1d
TcD0umWFLAGLlYkZUIkGOpdPSZB+KQu1r8l2r3h3JBgZx/YntktOA1R0fMdDBWPM
us6YH57hHnQBMuPi5WldNrROBJJpv3mi/NUeDBo+7WOpJ12gdDo3SMDTPgNa95RW
ppcW81wRahVPGbilI/EaWjKGGuUlUbqJ6ejcd/t65qaibkYg0syLwRUY4yS36XIj
oYMXsbVQbTfr2kQESDxqSyci7GBSv/Yv08xomPUnnXS+AIa4ctA01UzS8hGwetOd
4NpAt7HsMx9vxg1YK8RYQXEjppVZD0o7alAthpE4s9I92pBQPbnMa2gQ4e8/2sk=
=am7t
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
