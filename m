Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194Ab3EKANH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 20:13:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5415 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559Ab3EKANF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 20:13:05 -0400
X-Authority-Analysis: v=2.0 cv=UO1f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=4LmqTyUpg3UA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=wyb2nw6LB-gA:10 a=3nbZYyFuAAAA:8 a=l4VgQDXtWpHuF2t-nJ8A:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=EvKJbDF4Ut8A:10 a=IcH7bX80YRe1QZoG:21 a=OyTYf90ul4OPWD4w:21 a=JmxuiH6XBV8ncz57Q6EA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130511001303.599840597@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 10 May 2013 20:12:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH 03/18] tracing: Return error if register_ftrace_function_probe() fails for
 event_enable_func()
References: <20130511001206.477862307@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-Return-error-if-register_ftrace_function_pro.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

register_ftrace_function_probe() returns the number of functions
it registered, which can be zero, it can also return a negative number
if something went wrong. But event_enable_func() only checks for
the case that it didn't register anything, it needs to also check
for the case that something went wrong and return that error code
as well.

Added some comments about the code as well, to make it more
understandable.

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 44ac836..87e826f 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -2061,11 +2061,18 @@ event_enable_func(struct ftrace_hash *hash,
 	if (ret < 0)
 		goto out_put;
 	ret =3D register_ftrace_function_probe(glob, ops, data);
+	/*
+	 * The above returns on success the # of functions enabled,
+	 * but if it didn't find any functions it returns zero.
+	 * Consider no functions a failure too.
+	 */
 	if (!ret) {
 		ret =3D -ENOENT;
 		goto out_disable;
-	} else
-		ret =3D 0;
+	} else if (ret < 0)
+		goto out_disable;
+	/* Just return zero, not the number of enabled functions */
+	ret =3D 0;
  out:
 	mutex_unlock(&event_mutex);
 	return ret;
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRjY0PAAoJEOdOSU1xswtMi8sIALZIHdSnMmPANmmR3VfGqP4e
hjX8xCCQ6a+3rHtB0OrBMdOa9umMZe/Q9tOhtzStbGdT90NKPFa335km0TjkoOmd
qcm2sOvo+/wtfRp5CWYcjZvdTOCPiuqUk0pJmzph7YC3Z+sCyclcwpCTsq9pIE9d
vEPGcczxSQIRRHcF4sVVUJkcIEVg0ajNTDApDIWXQeA5yY+DK+lVSrYSx/DeXkxF
5TqCc92ScOqcd4ogen0ZTOEKeZZJ98WA134XoKbtBKxE4QdBEVhCHWUL40keuVUq
PVJunTh7gwWoDKAMOPaX6V32YOtbCprMuUn4v/pKFWyi8FZj52WEoOlXXUNfvB8=
=gxlu
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
