Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935788Ab3BTEJc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 23:09:32 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11270 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934951Ab3BTEJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 23:09:28 -0500
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=S8Df2DjCdSsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=asl1r4hDyFwA:10 a=ubFgiO5nTAOVMy0qMVEA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=7a3aQjawoir7MAdM-6kA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130220040926.725614699@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 19 Feb 2013 23:07:29 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 1/7] ktest: Do not require CONSOLE for build or install bisects
References: <20130220040728.921685169@goodmis.org>
Content-Disposition: inline; filename=0001-ktest-Do-not-require-CONSOLE-for-build-or-install-bi.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

If the user is doing a build or install bisect, there's no reason to
have them define CONSOLE, as the console does not need to be read. The
console only needs to be read for boot tests.

CONSOLE is not required for normal build or install tests, let's not
require it for bisect tests with BISECT_TYPE of build or install.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl |   27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 35fc584..d6690df 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -619,6 +619,18 @@ sub set_value {
 	# Note if a test is something other than build, then we
 	# will need other manditory options.
 	if ($prvalue ne "install") {
+	    # for bisect, we need to check BISECT_TYPE
+	    if ($prvalue ne "bisect") {
+		$buildonly =3D 0;
+	    }
+	} else {
+	    # install still limits some manditory options.
+	    $buildonly =3D 2;
+	}
+    }
+
+    if ($buildonly && $lvalue =3D~ /^BISECT_TYPE(\[.*\])?$/ && $prvalue ne=
 "build") {
+	if ($prvalue ne "install") {
 	    $buildonly =3D 0;
 	} else {
 	    # install still limits some manditory options.
@@ -1279,6 +1291,7 @@ sub start_monitor {
 }
=20
 sub end_monitor {
+    return if (!defined $console);
     if (--$monitor_cnt) {
 	return;
     }
@@ -1585,7 +1598,7 @@ sub wait_for_input
=20
     $rin =3D '';
     vec($rin, fileno($fp), 1) =3D 1;
-    $ready =3D select($rin, undef, undef, $time);
+    ($ready, $time) =3D select($rin, undef, undef, $time);
=20
     $line =3D "";
=20
@@ -1891,15 +1904,19 @@ sub get_version {
=20
 sub start_monitor_and_boot {
     # Make sure the stable kernel has finished booting
-    start_monitor;
-    wait_for_monitor 5;
-    end_monitor;
+
+    # Install bisects, don't need console
+    if (defined $console) {
+	start_monitor;
+	wait_for_monitor 5;
+	end_monitor;
+    }
=20
     get_grub_index;
     get_version;
     install;
=20
-    start_monitor;
+    start_monitor if (defined $console);
     return monitor;
 }
=20
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRJEx2AAoJEOdOSU1xswtM34kIAMgQZ7kyDt1fsZ5bmlWLt9OM
Uc1Flo7rWU1oJ22T2nFPWkxQnmZ207UFbncrRrHZfC0swPGUgxz7SoR6xyz4R2A7
HApAyZqgwdqrgkJGq1s7yUnhhWeGl2eUIyZ7lv18Zq84XdFEwEcqKXYN7FcnJRKj
DjLDw9gl0k3oMk5xhzk6/DYnkOkplKW6oMvABPZTxl/Nhq+4JsFmRUaMB2NiUQPo
ZsLMF13kqK9v29zGBaN8LH9B9qDN0tKv9vJCKnknBmoYyE+wiR1pa2wKxRYVvj8C
bjYIsiaaCYucuIDIE+MiN+2t7ko9BvHkW6cWDiSAD8kKiM+Jn1prfk/hTMDXtxQ=
=Pgoh
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
