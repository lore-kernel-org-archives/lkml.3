Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496Ab3EKANw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 20:13:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5415 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813Ab3EKANH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 20:13:07 -0400
X-Authority-Analysis: v=2.0 cv=UO1f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=r1zBh6h6_jQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=68T_GTYXkPwA:10 a=3nbZYyFuAAAA:8 a=YCsdFM7F17MQULGSw6MA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=EvKJbDF4Ut8A:10 a=7L9Pp_lz4QmeWKLhztIA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130511001304.993491559@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 10 May 2013 20:12:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH 10/18] tracing: Add helper function trace_create_new_event() to remove
 duplicate code
References: <20130511001206.477862307@goodmis.org>
Content-Disposition: inline; filename=0010-tracing-Add-helper-function-trace_create_new_event-t.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Both __trace_add_new_event() and __trace_early_add_new_event() do
basically the same thing, except that __trace_add_new_event() does
a little more.

Instead of having duplicate code between the two functions, add
a helper function trace_create_new_event() that both can use.
This will help against having bugs fixed in one function but not
the other.

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c |   32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 8be1224..7a0cf68 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1529,6 +1529,24 @@ __register_event(struct ftrace_event_call *call, str=
uct module *mod)
 	return 0;
 }
=20
+static struct ftrace_event_file *
+trace_create_new_event(struct ftrace_event_call *call,
+		       struct trace_array *tr)
+{
+	struct ftrace_event_file *file;
+
+	file =3D kmem_cache_alloc(file_cachep, GFP_TRACE);
+	if (!file)
+		return NULL;
+
+	file->event_call =3D call;
+	file->tr =3D tr;
+	atomic_set(&file->sm_ref, 0);
+	list_add(&file->list, &tr->events);
+
+	return file;
+}
+
 /* Add an event to a trace directory */
 static int
 __trace_add_new_event(struct ftrace_event_call *call,
@@ -1540,15 +1558,10 @@ __trace_add_new_event(struct ftrace_event_call *cal=
l,
 {
 	struct ftrace_event_file *file;
=20
-	file =3D kmem_cache_alloc(file_cachep, GFP_TRACE);
+	file =3D trace_create_new_event(call, tr);
 	if (!file)
 		return -ENOMEM;
=20
-	file->event_call =3D call;
-	file->tr =3D tr;
-	atomic_set(&file->sm_ref, 0);
-	list_add(&file->list, &tr->events);
-
 	return event_create_dir(tr->event_dir, file, id, enable, filter, format);
 }
=20
@@ -1563,15 +1576,10 @@ __trace_early_add_new_event(struct ftrace_event_cal=
l *call,
 {
 	struct ftrace_event_file *file;
=20
-	file =3D kmem_cache_alloc(file_cachep, GFP_TRACE);
+	file =3D trace_create_new_event(call, tr);
 	if (!file)
 		return -ENOMEM;
=20
-	file->event_call =3D call;
-	file->tr =3D tr;
-	atomic_set(&file->sm_ref, 0);
-	list_add(&file->list, &tr->events);
-
 	return 0;
 }
=20
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRjY0RAAoJEOdOSU1xswtMxx8IAItqZlE69Ec+o0Pqe38BpH2w
bMGv2I7Kgy2P6ZQb0VzkRXHmd8Selm6DMfQ3fZBIam1IITgV0fUz36LEoiDJ8Nfd
CwpSTJRjfyzPgj7c7yzf23dA007XTyRsWzIh9a14aNNdts6AVkwE72xc3ju4fWVn
YPSkgcCHTP6PkBM5Mv6CZaoN8yOvq8sjIbJg8xzrsL4f9b9WraYKDHkx9n8qGEwj
Nv1eqqjHhrC1AFjnMpDsQLO/4+6Dm8GmHS71lUk6uGLiEjyFsupPXg8IOvywm1Jv
CJgBeEDwKzq9A2xozFCDQQrHNLuXJFH0KD/iDW6/V80FnuNWLn4oPi01fbMD//0=
=HOZS
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
