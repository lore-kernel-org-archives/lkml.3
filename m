Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010AbaBMXAx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 18:00:53 -0500
Received: from mx01.mykolab.com ([95.128.36.1]:50058 "EHLO mx03.mykolab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751199AbaBMXAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 18:00:52 -0500
X-Spam-Flag: NO
X-Spam-Score: 1.995
Message-ID: <52FD4E8F.2030905@mykolab.com>
Date: Thu, 13 Feb 2014 18:00:31 -0500
From: Emily Maier <emilymaier@mykolab.com>
To: Rob Landley <rob@landley.net>, Michal Marek <mmarek@suse.cz>
CC: linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] kbuild: enable use of password-protected signing keys
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="3SqrHviVU0d67Jq9txMCnN4RV9JsNbk2w"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3SqrHviVU0d67Jq9txMCnN4RV9JsNbk2w
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Currently, the module signing script assumes that the private key is=20
not password-protected. This patch makes it somewhat more secure by=20
checking of a password file ("signing_key.pass") exists and passing it=20
to OpenSSL if so.

Version 2 changes: removed command line password passing from the=20
Makefile, the password file is now autodetected by the Perl signing=20
script.

Signed-off-by: Emily Maier <emilymaier@mykolab.com>
---
 Documentation/dontdiff                          |    1 +
 Documentation/module-signing.txt                |    3 +++
 scripts/sign-file                               |   13 ++++++++++---
 5 files changed, 15 insertions(+), 4 deletions(-)

diff -uprN -X linux-3.13.2-devel/Documentation/dontdiff linux-3.13.2/Docu=
mentation/dontdiff linux-3.13.2-devel/Documentation/dontdiff
--- linux-3.13.2/Documentation/dontdiff	2014-02-06 14:42:22.000000000 -05=
00
+++ linux-3.13.2-devel/Documentation/dontdiff	2014-02-09 15:30:41.7194480=
65 -0500
@@ -214,6 +214,7 @@ setup
 setup.bin
 setup.elf
 sImage
+signing_key.*
 sm_tbl*
 split-include
 syscalltab.h
diff -uprN -X linux-3.13.2-devel/Documentation/dontdiff linux-3.13.2/Docu=
mentation/module-signing.txt linux-3.13.2-devel/Documentation/module-sign=
ing.txt
--- linux-3.13.2/Documentation/module-signing.txt	2014-02-06 14:42:22.000=
000000 -0500
+++ linux-3.13.2-devel/Documentation/module-signing.txt	2014-02-13 17:29:=
54.412512011 -0500
@@ -137,6 +137,9 @@ generate the public/private key files:
 	   -config x509.genkey -outform DER -out signing_key.x509 \
 	   -keyout signing_key.priv
=20
+If you want to use a signing key with a password, write it to a file cal=
led
+"signing_key.pass". For security, make sure it is owned by root with 600=

+permissions.
=20
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
 PUBLIC KEYS IN THE KERNEL
diff -uprN -X linux-3.13.2-devel/Documentation/dontdiff linux-3.13.2/scri=
pts/sign-file linux-3.13.2-devel/scripts/sign-file
--- linux-3.13.2/scripts/sign-file	2014-02-06 14:42:22.000000000 -0500
+++ linux-3.13.2-devel/scripts/sign-file	2014-02-13 17:40:26.003859486 -0=
500
@@ -365,9 +365,16 @@ if ($signature_file) {
 	# comprises the signature with no metadata attached.
 	#
 	my $pid;
-	$pid =3D open2(*read_from, *write_to,
-		     "openssl rsautl -sign -inkey $private_key -keyform PEM") ||
-	    die "openssl rsautl";
+	my $passfile =3D "signing_key.pass";
+	if (-e $passfile) {
+		$pid =3D open2(*read_from, *write_to,
+		             "openssl rsautl -sign -inkey $private_key -keyform PEM \\=

+		              -passin file:$passfile") || die "openssl rsautl";
+	} else {
+		$pid =3D open2(*read_from, *write_to,
+			     "openssl rsautl -sign -inkey $private_key -keyform PEM") ||
+		    die "openssl rsautl";
+	}
 	binmode write_to;
 	print write_to $prologue . $digest || die "pipe to openssl rsautl";
 	close(write_to) || die "pipe to openssl rsautl";


--3SqrHviVU0d67Jq9txMCnN4RV9JsNbk2w
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIbBAEBAgAGBQJS/U6XAAoJEOcmnllJ9/EeHhMP9RT58gCvzkE/vyvbyTR0mCm1
iTRocXPYbeJ4ZuHdUEody4B681jrcp2+T7HQpaXWlWs0y+d4fGSIZ/NLmTthcldl
7aA7rZMUspWb89fB56vY+YEXe0fS6sMdTBjHMnjelQYB+xU3ZBMYqJ2bfAoicQBW
ItHZqpveC75K1TibXpUEjINhkCTHUUxgQKg64abY2bCbEPJJ5I86x5xXn9Tgk9wi
Bdon2ITHK4uuBhwRdFDr3xrxqUkxbvN0M6e0M18Y8kyefr6orlHToZ5ETwMXszsY
VWM0cAN8p3RWf/r6Ikjo5eAOOWDetM3/d3Cu0KMFsEJAV34JhaUoPmJpEMb7gFdR
HIWGz4JSJ/JFCZPyXhndkH8+MB+YMDbqWVRGaP/Vf8CyPYgG5yWnsBRQBIYbhzun
HLbtmr41wNOYRXzxgqtl3fvBbMEj0u/zVvxEYoYi6MYC1/a3Kop9oeO7vTYO2+VA
wR62/kqnAbPAa5+pnpCckAtM30shsfWv7lUrEW+peb7XjU8BhQCSdRdwbJm4JRqS
0O4lGSkLlUqKpfvUc6EKnEj16Ve17o5nZJ3UkNAzvxUFYKRMHyBVWkrYPR/Hk651
K5NDmtm96djrT04yjATgr57P5N2rxcHVgtY3H3c2OmNDiT8D3F1FSEwA5jJQDfKf
SsPqbiEp96M1l+WcEgw=
=Ock3
-----END PGP SIGNATURE-----

--3SqrHviVU0d67Jq9txMCnN4RV9JsNbk2w--
