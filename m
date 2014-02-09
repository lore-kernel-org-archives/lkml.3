Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175AbaBIWpX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 17:45:23 -0500
Received: from mx01.mykolab.com ([95.128.36.1]:60874 "EHLO mx03.mykolab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707AbaBIWpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 17:45:21 -0500
X-Greylist: delayed 425 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Feb 2014 17:45:20 EST
X-Spam-Flag: NO
X-Spam-Score: 1.995
Message-ID: <52F8034B.8080303@mykolab.com>
Date: Sun, 09 Feb 2014 17:38:03 -0500
From: Emily Maier <emilymaier@mykolab.com>
To: Rob Landley <rob@landley.net>, Michal Marek <mmarek@suse.cz>
CC: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: [PATCH RFC] kernel build: enable use of password-protected signing
 keys
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="LhQGxMXRiw2afUAEchD917mJ640trmRUF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--LhQGxMXRiw2afUAEchD917mJ640trmRUF
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Currently, the module signing script assumes that the private key is=20
not password-protected. This patch makes it slightly more secure by=20
allowing it to be passed in on the command line as "make=20
modules_install MOD_PASSWORD=3Dabc". It's vulnerable to snooping during=20
the build of course, but so is an unprotected signing key.

I'm not sure how to securely give the password to the perl signing=20
script. OpenSSL will prompt you for it in stdin if one isn't provided,=20
but that's obviously not reasonable if you're building many modules.

Signed-off-by: Emily Maier <emilymaier@mykolab.com>
---
 Documentation/dontdiff |    1 +
 Makefile               |    7 ++++++-
 scripts/sign-file      |   18 +++++++++++++-----
 3 files changed, 20 insertions(+), 6 deletions(-)

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
diff -uprN -X linux-3.13.2-devel/Documentation/dontdiff linux-3.13.2/Make=
file linux-3.13.2-devel/Makefile
--- linux-3.13.2/Makefile	2014-02-06 14:42:22.000000000 -0500
+++ linux-3.13.2-devel/Makefile	2014-02-09 16:34:19.727020032 -0500
@@ -742,11 +742,16 @@ INITRD_COMPRESS-$(CONFIG_RD_LZ4)   :=3D lz
 # choose a sane default compression above.
 # export INITRD_COMPRESS :=3D $(INITRD_COMPRESS-y)
 +ifdef MOD_PASSWORD
+mod_sign_cmd =3D perl $(srctree)/scripts/sign-file -p $(MOD_PASSWORD)
+else
+mod_sign_cmd =3D perl $(srctree)/scripts/sign-file
+endif
 ifdef CONFIG_MODULE_SIG_ALL
 MODSECKEY =3D ./signing_key.priv
 MODPUBKEY =3D ./signing_key.x509
 export MODPUBKEY
-mod_sign_cmd =3D perl $(srctree)/scripts/sign-file $(CONFIG_MODULE_SIG_H=
ASH) $(MODSECKEY) $(MODPUBKEY)
+mod_sign_cmd +=3D $(CONFIG_MODULE_SIG_HASH) $(MODSECKEY) $(MODPUBKEY)
 else
 mod_sign_cmd =3D true
 endif
diff -uprN -X linux-3.13.2-devel/Documentation/dontdiff linux-3.13.2/scri=
pts/sign-file linux-3.13.2-devel/scripts/sign-file
--- linux-3.13.2/scripts/sign-file	2014-02-06 14:42:22.000000000 -0500
+++ linux-3.13.2-devel/scripts/sign-file	2014-02-09 15:16:22.198684877 -0=
500
@@ -5,7 +5,8 @@
  my $USAGE =3D
 "Usage: scripts/sign-file [-v] <hash algo> <key> <x509> <module> [<dest>=
]\n" .
-"       scripts/sign-file [-v] -s <raw sig> <hash algo> <x509> <module> =
[<dest>]\n";
+"       scripts/sign-file [-v] -s <raw sig> <hash algo> <x509> <module> =
[<dest>]\n" .
+"	scripts/sign-file [-v] -p <password> <hash algo> <x509> <module> [<des=
t>]";
  use strict;
 use FileHandle;
@@ -13,9 +14,10 @@ use IPC::Open2;
 use Getopt::Std;
  my %opts;
-getopts('vs:', \%opts) or die $USAGE;
+getopts('vs:p:', \%opts) or die $USAGE;
 my $verbose =3D $opts{'v'};
 my $signature_file =3D $opts{'s'};
+my $password =3D $opts{'p'};
  die $USAGE if ($#ARGV > 4);
 die $USAGE if (!$signature_file && $#ARGV < 3 || $signature_file && $#AR=
GV < 2);
@@ -365,9 +367,15 @@ if ($signature_file) {
 	# comprises the signature with no metadata attached.
 	#
 	my $pid;
-	$pid =3D open2(*read_from, *write_to,
-		     "openssl rsautl -sign -inkey $private_key -keyform PEM") ||
-	    die "openssl rsautl";
+	if ($password) {
+		$pid =3D open2(*read_from, *write_to,
+		             "openssl rsautl -sign -inkey $private_key -keyform PEM \\=

+		              -passin pass:$password") || die "openssl rsautl";
+	} else {
+		$pid =3D open2(*read_from, *write_to,
+			     "openssl rsautl -sign -inkey $private_key -keyform PEM") ||
+		    die "openssl rsautl";
+	}
 	binmode write_to;
 	print write_to $prologue . $digest || die "pipe to openssl rsautl";
 	close(write_to) || die "pipe to openssl rsautl";


--LhQGxMXRiw2afUAEchD917mJ640trmRUF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJS+ANLAAoJEOcmnllJ9/EeVAYQAJr2wHzu8E80ECgD7QDADBsn
Eavt+eCL1D3JMNxpOd3Qh3wft7Y8nmNfb2XYpQRm0W5dB4njEGqKT0w6EThsESWd
KYLs5djZhfuszEzWIQF0U0qPLneSm5GN0CEW4XBUEmoYNucOumj3rVy2oi5UUQ9c
JV6gr3xgy12Qz097+AUesiDSs/wSqtABaOOrON0ri3uRrE79q9kNloEKm+YuwpJ5
DA4AnqRyvXxwTqQ+FlJ9/EnYqCmtvHfmdaRc9UsNXUTGtArdvrKA0zSXxNdGGS3V
9sbSKSu2ML8C1WYCkEaKom92S2SU4gnBB6WWEv18dKxsNh9k5aQWlBJ6ZyrFKmyh
UlA1g5Pj9dVnfD7blsfgfBxON6ecuMqFu1ciea71qZT6DGcA9iEU+59Rt7b6DehJ
L1U964XvDlUCldrl6MUNa5TzPDcL7oljKdZXWiQK17DaR9hReOyqIp4uioLG2UKg
A6u0z+07vsbcQ7iK8z6uZ6NSYF2G6zZ6QqeVSSHC70Y4r73Irc+ZVnWLwn3KuHVs
pxl5B6JJjNAnJZMSsPB7vb/duX60KTKw+FsnWQ4GleJR4aXqC1i4ll/qoqNDbrw8
1LawhfI0d070wUZ1Enls4BylwO2f9+WLJV44dxAIFamBtJzyLdNpeJkNbeDC+HvM
vt5Gv3TOHv6ezKwqNUCQ
=Mz0E
-----END PGP SIGNATURE-----

--LhQGxMXRiw2afUAEchD917mJ640trmRUF--
