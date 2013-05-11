Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083Ab3EKANs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 20:13:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11649 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756079Ab3EKANH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 20:13:07 -0400
X-Authority-Analysis: v=2.0 cv=UY7TuduN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=UevlCch2svkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=XXGI1-51kC4A:10 a=wuX1wG3kHLwclxvCqzQA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=Et7-MWnu-A5xAS9x0WsA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130511001305.316664906@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 10 May 2013 20:12:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH 11/18] ftrace: Fix locking in register_ftrace_function_probe()
References: <20130511001206.477862307@goodmis.org>
Content-Disposition: inline; filename=0011-ftrace-Fix-locking-in-register_ftrace_function_probe.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The iteration of the ftrace function list and the call to
ftrace_match_record() need to be protected by the ftrace_lock.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index cacf085..f104c45 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3017,14 +3017,16 @@ register_ftrace_function_probe(char *glob, struct f=
trace_probe_ops *ops,
 	hash =3D alloc_and_copy_ftrace_hash(FTRACE_HASH_DEFAULT_BITS, *orig_hash);
 	if (!hash) {
 		count =3D -ENOMEM;
-		goto out_unlock;
+		goto out;
 	}
=20
 	if (unlikely(ftrace_disabled)) {
 		count =3D -ENODEV;
-		goto out_unlock;
+		goto out;
 	}
=20
+	mutex_lock(&ftrace_lock);
+
 	do_for_each_ftrace_rec(pg, rec) {
=20
 		if (!ftrace_match_record(rec, NULL, search, len, type))
@@ -3070,15 +3072,15 @@ register_ftrace_function_probe(char *glob, struct f=
trace_probe_ops *ops,
=20
 	} while_for_each_ftrace_rec();
=20
-	mutex_lock(&ftrace_lock);
 	ret =3D ftrace_hash_move(&trace_probe_ops, 1, orig_hash, hash);
 	if (ret < 0)
 		count =3D ret;
=20
 	__enable_ftrace_function_probe();
-	mutex_unlock(&ftrace_lock);
=20
  out_unlock:
+	mutex_unlock(&ftrace_lock);
+ out:
 	mutex_unlock(&trace_probe_ops.regex_lock);
 	free_ftrace_hash(hash);
=20
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRjY0RAAoJEOdOSU1xswtMnNsIAMXTk4LGSr85jgfug98b+ucN
lRl0p1HlLXELE5x+w46Zqc6O4rHibq9MJzXfWo9v/btOwYEDRYlgJD9fVnqfGaU9
tyu8UdA9qIubZU8k1ymzmX8wIUPFuonrxzw2B26PL0e569gti5YNJdKTRqwNSqN4
1xh4ghCA0kjoGJzO9rNjmfkAbC3Xp+JpTM5AeL7DyYjEy9MmAKEUmx9SwiM468up
JmXjYH5iX+DHSYfpLPOn3T2y9wywBuHcgbzjp13JIjN13wTb2s5mLeG4GBkGrtee
KOWJxNLNR4PXao/0s6UCXg6JdxCPaS0KuQ5cO+Ju8FA8NYpXX+VlqcbMDrLSwh0=
=kCNl
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
