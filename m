Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965018Ab3DHVFX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 17:05:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31580 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964927Ab3DHVFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 17:05:20 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=qON8pLPu1-gA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=t3S1shvx5yMA:10 a=zavyHLYIyEpDPWPh8yUA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=b04bx0hJNeJjjbaqg0QA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130408210518.124331560@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 08 Apr 2013 16:49:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/3] tracing: Fix race with update_max_tr_single and changing tracers
References: <20130408204937.649895945@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Fix-race-with-update_max_tr_single-and-chang.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The commit 34600f0e9 "tracing: Fix race with max_tr and changing tracers"
fixed the updating of the main buffers with the race of changing
tracers, but left out the fix to the updating of just a per cpu buffer.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 4f1dade..7ba7fc7 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -744,8 +744,11 @@ update_max_tr_single(struct trace_array *tr, struct ta=
sk_struct *tsk, int cpu)
 		return;
=20
 	WARN_ON_ONCE(!irqs_disabled());
-	if (WARN_ON_ONCE(!current_trace->allocated_snapshot))
+	if (!current_trace->allocated_snapshot) {
+		/* Only the nop tracer should hit this when disabling */
+		WARN_ON_ONCE(current_trace !=3D &nop_trace);
 		return;
+	}
=20
 	arch_spin_lock(&ftrace_max_lock);
=20
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRYzEOAAoJEOdOSU1xswtMeNIH/iVy6haAj2JbJ36ji0/RXO8+
nk2HGTcSGae2Xa2HksBPGYDpzdMvG1kVVR8E8QHfpaLNB/sHFHqEeT3/ObydXZpI
Et6tFN+62v069a5iBcwzeFAzyJqjwFvhVCOlw56itwRZQyYwT4eljo0lUPsdCr39
Xd4gJ/RK4Ip1M16TDAW2CGNPWj6OvlwPYG6+Xnb0bc0kj8yAm6YMpoA96YhqIvoI
sDtCIPaBg9JYZZ3Bdclr6z5XZG5L5NU5jqvUTqzs+gR1Im5oNoWEU1U+A2E2GTKT
4axrWL/fQ2kaC+UG/6xICnyExS19X0NJqcD/rNlMZX56sGh3a5lDgfPxlbnsSUM=
=GBcO
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
