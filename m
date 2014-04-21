Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320AbaDUSv4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 14:51:56 -0400
Received: from mout.gmx.net ([212.227.15.18]:54290 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775AbaDUSvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 14:51:38 -0400
Date: Mon, 21 Apr 2014 20:45:59 +0200
From: Christian Engelmayer <cengelma@gmx.at>
To: tim.c.chen@linux.intel.com
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] crypto: Fix potential leak in test_aead_speed() if
 aad_size is too big
Message-ID: <20140421204559.75b8aa71@spike>
In-Reply-To: <20140421204439.7999f1c6@spike>
References: <20140421204439.7999f1c6@spike>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_//NIrK910qeX6IIquH3yMDSB"; protocol="application/pgp-signature"
X-Provags-ID: V03:K0:BDmfBl/IfQWe3qsNAGvGggYHfZlm4V17vGePoNExh+tzF/a6AU1
 AWOtrRdFRBbl+tSEZ/AlwTP64B69PBlNLYtpTOpmY0Kj/X15Yc3KKaGqRlR7rq4/nc3xb9g
 y6fGyVBOT65AEGf3cwgT1jowNQokmn4zf0gDWZnH2ZMzT/rqSLLCsY6q3qbebO/6QDsuUm5
 2YQgyvogvM1oxy5NIfhqA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_//NIrK910qeX6IIquH3yMDSB
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Fix a potential memory leak in the error handling of test_aead_speed(). In =
case
the size check on the associate data length parameter fails, the function g=
oes
through the wrong exit label. Reported by Coverity - CID 1163870.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
 crypto/tcrypt.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 870be7b..1856d7f 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -282,6 +282,11 @@ static void test_aead_speed(const char *algo, int enc,=
 unsigned int sec,
 	unsigned int *b_size;
 	unsigned int iv_len;
=20
+	if (aad_size >=3D PAGE_SIZE) {
+		pr_err("associate data length (%u) too big\n", aad_size);
+		return;
+	}
+
 	if (enc =3D=3D ENCRYPT)
 		e =3D "encryption";
 	else
@@ -323,14 +328,7 @@ static void test_aead_speed(const char *algo, int enc,=
 unsigned int sec,
 		b_size =3D aead_sizes;
 		do {
 			assoc =3D axbuf[0];
-
-			if (aad_size < PAGE_SIZE)
-				memset(assoc, 0xff, aad_size);
-			else {
-				pr_err("associate data length (%u) too big\n",
-					aad_size);
-				goto out_nosg;
-			}
+			memset(assoc, 0xff, aad_size);
 			sg_init_one(&asg[0], assoc, aad_size);
=20
 			if ((*keysize + *b_size) > TVMEMSIZE * PAGE_SIZE) {
--=20
1.9.1

--Sig_//NIrK910qeX6IIquH3yMDSB
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTVWdnAAoJEKssnEpaPQKE0VAQAK/LdWfQLyEusWka6j82P5Sf
VrMpFDAxGxjh5Igp7e2LhySNw7lNXA2UYY33J5cHeT6oc7wn4gJulhWpzJwtKgSC
+XYfzzYVVJUDh3z8sBWeb7J68sFOxPUyUvSCkfQjHtIs6z/AYOJqEfGMYzqyW7w3
T3XKaM12Vky9Of7NZp/o9izZmxuDlJbTDNABfYccdTpNGnRF2+4uJHuhfswY7kpy
kzXrfw8uA+w89yNqx+xzB30PwextbO4LJLDRVTOnqrF9F0S0nKt006XVa41+X6j/
uz9y8bytnkEng9Xpok6IS4LmZCwDV8w7x4m/mDuM+fZuZBIv4jjsPjd/RGVrHZo5
wHHu7q4493NvMSHeswBoqWsA/nksW/ke2uUniSGpqAjPfxspyt5leuxz4Witn8l3
mAjZZpQp/kp7LMKktOjaTxLYw1pzahUdDXOf+ZDRpv7Dqqz61KU/Yzk6+W36eL9S
J6P3BztqUNO4wM27pbR6nhPFflBMndbc4vevsUP4ZRbceGinSdPCo594A1/gH+/Y
wS9D0kYdL1gHkrCJy6zyFMSvEzH3EaxHFEFrkfL+kioUUIe3D8bPmhLjn2O4YjK6
UZliamt2hMydlWIicofN9TtAToYGqKWQ3NulsjMpJeM8RRBgzrVreUy2t8SzBeem
gsqh4kUGcenXxVaBjpQ3
=LxHZ
-----END PGP SIGNATURE-----

--Sig_//NIrK910qeX6IIquH3yMDSB--
