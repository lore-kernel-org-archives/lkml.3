Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759544Ab3D2TwL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 15:52:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33571 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759119Ab3D2TwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 15:52:05 -0400
X-Authority-Analysis: v=2.0 cv=GtrACzJC c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=iIjuBAqTbCMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=10e-2EioWqEA:10 a=VwQbUJbxAAAA:8 a=MaTfSPlqobeUgB7gn_QA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=9sHArSNYffL3UlbgPaYA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130429195201.690687280@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 29 Apr 2013 15:51:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        <stable@vger.kernel.org>, "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: [PATCH 2/2] localmodconfig: Process source kconfig files as they are found
References: <20130429195100.202681236@goodmis.org>
Content-Disposition: inline; filename=0002-localmodconfig-Process-source-kconfig-files-as-they-.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <rostedt@goodmis.org>

A bug was reported that caused localmodconfig to not keep all the
dependencies of ATH9K. This was caused by the kconfig file:

In drivers/net/wireless/ath/Kconfig:

---
if ATH_CARDS

config ATH_DEBUG
        bool "Atheros wireless debugging"
        ---help---
          Say Y, if you want to debug atheros wireless drivers.
          Right now only ath9k makes use of this.

source "drivers/net/wireless/ath/ath5k/Kconfig"
source "drivers/net/wireless/ath/ath9k/Kconfig"
source "drivers/net/wireless/ath/carl9170/Kconfig"
source "drivers/net/wireless/ath/ath6kl/Kconfig"
source "drivers/net/wireless/ath/ar5523/Kconfig"
source "drivers/net/wireless/ath/wil6210/Kconfig"

endif
---

The current way kconfig works, it processes new source files after the
first file is completed. It creates an array of new source config files
and when the one file is finished, it continues with the next file.

Unfortunately, this means that it loses the fact that the source file is
within an "if" statement, and this means that each of these source file's
configs will not have the proper dependencies set.

As ATH9K requires ATH_CARDS set, the localmodconfig did not see that
dependency, and did not enable ATH_CARDS. When the oldconfig was run, it
forced ATH9K to be disabled.

Link: http://lkml.kernel.org/r/alpine.DEB.2.02.1304291022320.9234@oneiric

Cc: stable@vger.kernel.org # 3.8+
Reported-by: Robert P. J. Day <rpjday@crashcourse.ca>
Tested-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/kconfig/streamline_config.pl |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/scripts/kconfig/streamline_config.pl b/scripts/kconfig/streaml=
ine_config.pl
index 343a568..4606cdf 100644
--- a/scripts/kconfig/streamline_config.pl
+++ b/scripts/kconfig/streamline_config.pl
@@ -156,7 +156,6 @@ sub read_kconfig {
=20
     my $state =3D "NONE";
     my $config;
-    my @kconfigs;
=20
     my $cont =3D 0;
     my $line;
@@ -190,7 +189,13 @@ sub read_kconfig {
=20
 	# collect any Kconfig sources
 	if (/^source\s*"(.*)"/) {
-	    $kconfigs[$#kconfigs+1] =3D $1;
+	    my $kconfig =3D $1;
+	    # prevent reading twice.
+	    if (!defined($read_kconfigs{$kconfig})) {
+		$read_kconfigs{$kconfig} =3D 1;
+		read_kconfig($kconfig);
+	    }
+	    next;
 	}
=20
 	# configs found
@@ -250,14 +255,6 @@ sub read_kconfig {
 	}
     }
     close($kinfile);
-
-    # read in any configs that were found.
-    foreach my $kconfig (@kconfigs) {
-	if (!defined($read_kconfigs{$kconfig})) {
-	    $read_kconfigs{$kconfig} =3D 1;
-	    read_kconfig($kconfig);
-	}
-    }
 }
=20
 if ($kconfig) {
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRfs9hAAoJEOdOSU1xswtMHXQH/jV61d/9IzGCNdzZVFD/AZr8
a0ejKxzpGJVe5G3EAyHyzElqEDPCPlHeq+nbr14kO17HrGX2+NFTfW9psTXLQM26
L9D2IzXR+brFrMo8RqOX1E81Px4sNTn54C8Q9K1sdqI7q0KHD+oCprwn0ACGQqMc
GdC+5eCEq4e0LWsz548o3BnPpabkax+Slkeq0HyBYgzDKqdy8MZ7d88NLbXATzgS
d7ux3cRO90ctIvFSwhZb7jG5ZLF/XNxKyD+Jxateb7eo7px5Yd1iWJ8wiN4csk3n
9Z27IMT0hg7ATGNvwzjPsUNO1zlTSItbsJEqyOLT+QcUtdDXGbxAS+L4ZHyPh2s=
=x/Fj
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
