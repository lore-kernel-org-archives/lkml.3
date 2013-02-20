Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935725Ab3BTEJa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 23:09:30 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5998 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934949Ab3BTEJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 23:09:28 -0500
X-Authority-Analysis: v=2.0 cv=It2cgcDg c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=VrCVEnytJgIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=lxCP6klvZc0A:10 a=jZIw_L4tASvw45iKDEwA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=Sh_2PeqqvTGVH4YCr7cA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130220040927.143537522@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 19 Feb 2013 23:07:31 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3/7] ktest: Allow a test option to use its default option
References: <20130220040728.921685169@goodmis.org>
Content-Disposition: inline; filename=0003-ktest-Allow-a-test-option-to-use-its-default-option.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Options are allowed to use other options, for example:

  LOG_FILE =3D ${OUTPUT_DIR}/${MACHINE}.log

where the option LOG_FILE used the options OUTPUT_DIR and MACHINE.

But if a test option were to use a default option, it will not get
substituted:

  OUTPUT_DIR =3D ${THIS_DIR}/${MACHINE}

  TEST_START
  OUTPUT_DIR =3D ${OUTPUT_DIR}/t1

For the above test, OUTPUT_DIR will stay literally "${OUTPUT_DIR}/t1"
and not be converted to "${THIS_DIR}/${MACHINE}/t1". When the test runs,
it will pass the ${OUTPUT_DIR} to the shell, which would probaly
interpret it as "", and the output directory will end up as "/t1".

Change the code where if a test option has its own option name in
its defined field, and a default option exists, then substitute the
default option in its place.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index cc9925a..3d19ee4 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -1074,7 +1074,7 @@ sub read_config {
 }
=20
 sub __eval_option {
-    my ($option, $i) =3D @_;
+    my ($name, $option, $i) =3D @_;
=20
     # Add space to evaluate the character before $
     $option =3D " $option";
@@ -1106,7 +1106,11 @@ sub __eval_option {
 	my $o =3D "$var\[$i\]";
 	my $parento =3D "$var\[$parent\]";
=20
-	if (defined($opt{$o})) {
+	# If a variable contains itself, use the default var
+	if (($var eq $name) && defined($opt{$var})) {
+	    $o =3D $opt{$var};
+	    $retval =3D "$retval$o";
+	} elsif (defined($opt{$o})) {
 	    $o =3D $opt{$o};
 	    $retval =3D "$retval$o";
 	} elsif ($repeated && defined($opt{$parento})) {
@@ -1130,7 +1134,7 @@ sub __eval_option {
 }
=20
 sub eval_option {
-    my ($option, $i) =3D @_;
+    my ($name, $option, $i) =3D @_;
=20
     my $prev =3D "";
=20
@@ -1146,7 +1150,7 @@ sub eval_option {
 		"Check for recursive variables\n";
 	}
 	$prev =3D $option;
-	$option =3D __eval_option($option, $i);
+	$option =3D __eval_option($name, $option, $i);
     }
=20
     return $option;
@@ -3683,7 +3687,7 @@ EOF
 read_config $ktest_config;
=20
 if (defined($opt{"LOG_FILE"})) {
-    $opt{"LOG_FILE"} =3D eval_option($opt{"LOG_FILE"}, -1);
+    $opt{"LOG_FILE"} =3D eval_option("LOG_FILE", $opt{"LOG_FILE"}, -1);
 }
=20
 # Append any configs entered in manually to the config file.
@@ -3760,7 +3764,7 @@ sub set_test_option {
     my $option =3D __set_test_option($name, $i);
     return $option if (!defined($option));
=20
-    return eval_option($option, $i);
+    return eval_option($name, $option, $i);
 }
=20
 # First we need to do is the builds
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRJEx3AAoJEOdOSU1xswtMrVwIALxOYOYWt8fRhTNwUwI9XctT
umqBb+3aaabxF+20KoLSHxvBUD+Tl33VTREM7PwoPKLG3t4BwnDktCQ8GGjWBebB
bvn4FSer2nRm4fhz8aAbke7s7mmjbuTomY2BID2JGh1VUmOahIQ+U0fzopDNBjQb
jn1tnwVNBiFrefGRC8Lp/XT1Q16bmsDtPHfuHpMtU4JYNeLcTFCfT83UgUhrLAsA
1FoEZ61dxEYDS2imAgg8tDVAA1bZtqasWimPggj3w92rz2mCV7B4mO5fYr19J/ou
zzMUnXO+qWDcObTaNWviykN/p3CxsboFK+BN2VVy/qiZWh8KiihiKvEmGIe85c8=
=mlVa
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
