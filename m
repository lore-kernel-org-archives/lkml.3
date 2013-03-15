Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932331Ab3COTzs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 15:55:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27896 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755229Ab3COTvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 15:51:24 -0400
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=GeSmTBBqxbkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=3f7oDsHacvgA:10 a=_6EPSxkMAmLMEE3QWz4A:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=9B1YwVNYmaY4rr8OdLEA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130315195122.156202450@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 15 Mar 2013 15:39:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [for-next][PATCH 01/20] tracing: Consolidate updating of count for traceon/off
References: <20130315193935.359219613@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Consolidate-updating-of-count-for-traceon-of.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Remove some duplicate code and replace it with a helper function.
This makes the code a it cleaner.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_functions.c |   33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index e467c0c..38cfb29 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -214,38 +214,37 @@ static struct tracer function_trace __read_mostly =3D
 };
=20
 #ifdef CONFIG_DYNAMIC_FTRACE
-static void
-ftrace_traceon(unsigned long ip, unsigned long parent_ip, void **data)
+static int update_count(void **data)
 {
-	long *count =3D (long *)data;
-
-	if (tracing_is_on())
-		return;
+	unsigned long *count =3D (long *)data;
=20
 	if (!*count)
-		return;
+		return 0;
=20
 	if (*count !=3D -1)
 		(*count)--;
=20
-	tracing_on();
+	return 1;
 }
=20
 static void
-ftrace_traceoff(unsigned long ip, unsigned long parent_ip, void **data)
+ftrace_traceon(unsigned long ip, unsigned long parent_ip, void **data)
 {
-	long *count =3D (long *)data;
-
-	if (!tracing_is_on())
+	if (tracing_is_on())
 		return;
=20
-	if (!*count)
-		return;
+	if (update_count(data))
+		tracing_on();
+}
=20
-	if (*count !=3D -1)
-		(*count)--;
+static void
+ftrace_traceoff(unsigned long ip, unsigned long parent_ip, void **data)
+{
+	if (!tracing_is_on())
+		return;
=20
-	tracing_off();
+	if (update_count(data))
+		tracing_off();
 }
=20
 static int
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRQ3u6AAoJEOdOSU1xswtM6fQIAK8gLvAR7s0eYF7zKdwpV+XG
gMQaqokzrHMervx+LJfGC2VZre0o+xR+juovP4Ksqu+G1MyJVsXe0r2VfvC6ga+f
3TjYWrvOhF8YBAFQN7NQsfpi5c6cNVbjQFCa7cWWhKEPZIQR6/+6ZcJBngqrz/5C
PdoCFOI05jaaa7XXtCrvfM2AWQbv6Ry3slydqWzl8OCm3mzD8ca1EOm4ZvPOAit1
hfKPjXwK/DGbfi5wLmhLI7xEK3S6SegvvNbmpOG8cOWXcTTAWzhdTnpqg4KNRQpA
QNCVFOG6ozt6LZcPPg0t4CfRPVGpySLc9zPGTzpTlIjfonAd/CsTCuXSv3MrpOA=
=BR79
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
