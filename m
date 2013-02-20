Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935830Ab3BTELY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 23:11:24 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5998 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934952Ab3BTEJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 23:09:29 -0500
X-Authority-Analysis: v=2.0 cv=It2cgcDg c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=3585qKBZacsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=lrvjw4vzsvMA:10 a=wjwkSS7DOEIEClS_Et8A:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=5BBMoYA6pYBqD9PFwrsA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130220040927.810076131@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 19 Feb 2013 23:07:34 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6/7] ktest: Ignore warnings during reboot
References: <20130220040728.921685169@goodmis.org>
Content-Disposition: inline; filename=0006-ktest-Ignore-warnings-during-reboot.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The reboot just wants to get to the next kernel. But if a warning (Call
Trace) appears, the monitor will report an error, and the reboot will
think something went wrong and power cycle the box, even though we
successfully made it to the next kernel.

Ignore warnings during the reboot until we get to the next kernel. It
will still timeout if we never get to the next kernel and then a power
cycle will happen. That's what we want it to do.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 839989d..f3bb5da 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -1212,6 +1212,12 @@ sub reboot {
     }
=20
     if (defined($time)) {
+
+	# We only want to get to the new kernel, don't fail
+	# if we stumble over a call trace.
+	my $save_ignore_errors =3D $ignore_errors;
+	$ignore_errors =3D 1;
+
 	# Look for the good kernel to boot
 	if (wait_for_monitor($time, "Linux version")) {
 	    # reboot got stuck?
@@ -1219,6 +1225,8 @@ sub reboot {
 	    run_command "$power_cycle";
 	}
=20
+	$ignore_errors =3D $save_ignore_errors;
+
 	# Still need to wait for the reboot to finish
 	wait_for_monitor($time, $reboot_success_line);
=20
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRJEx3AAoJEOdOSU1xswtMWSsH/0xvio2VIUOIT8YBvq4jwy/v
Hk2jYctBIoxStxdjQiKHR1yNc3w0JTVOzjNGh4wMcIPlondGMId1JVntZCaNKx1O
QcssLFWoMdTpAmOnB3tHmzs6CRCbWg3W7Mjm1ZzuECjoK3sMIZfOz7hHRk+ouqfY
KLiRzE5FZMv0bYmFXmgIkYRoxTRfD1N2nBFCHnUr3N1lhARHWK4y5EocnjKyKI+z
ovknICTosZErJfGDWgJGNY/cl/QdiE11FdN3SoDLG8IROD1bjh0t3R2KAV7SKb4E
RhkNsiKibMF0zaf4Ulfe6pzQCQnK12Ha+Sdg/IGyK1IKlPIBog3HDqxf3QxfSlg=
=2755
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
