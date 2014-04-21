Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222AbaDUSvn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 14:51:43 -0400
Received: from mout.gmx.net ([212.227.17.20]:59041 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752779AbaDUSvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 14:51:33 -0400
Date: Mon, 21 Apr 2014 20:46:40 +0200
From: Christian Engelmayer <cengelma@gmx.at>
To: tim.c.chen@linux.intel.com
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] crypto: Fix potential leak in test_aead_speed() if
 crypto_alloc_aead() fails
Message-ID: <20140421204640.76380365@spike>
In-Reply-To: <20140421204439.7999f1c6@spike>
References: <20140421204439.7999f1c6@spike>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_//O1rreyrO7_4r_Z671jpHem"; protocol="application/pgp-signature"
X-Provags-ID: V03:K0:r2/69ySuJf6TwUCsmeTFcrXNehCWbdLO/IRiT23WIpygEwqVUj2
 fqyluGkj5nJ8viSqsDQSJ8hkSzvHN0u+A9LzGgQsKGZKE82ZimelZ/ubauJhAY8CVH/WJNY
 TEmj7YuO7DUtq0tZ+1d3OIyzl2ON7HMSRRHtPBuHmIvRxDoPvI3gvLVbFrqEhqbumVyzNv2
 hlfKTXsMtsfQK6HVM6PHg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_//O1rreyrO7_4r_Z671jpHem
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Fix a potential memory leak in the error handling of test_aead_speed(). In =
case
crypto_alloc_aead() fails, the function returns without going through the
centralized cleanup path. Reported by Coverity - CID 1163870.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
 crypto/tcrypt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 1856d7f..1849155 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -313,7 +313,7 @@ static void test_aead_speed(const char *algo, int enc, =
unsigned int sec,
 	if (IS_ERR(tfm)) {
 		pr_err("alg: aead: Failed to load transform for %s: %ld\n", algo,
 		       PTR_ERR(tfm));
-		return;
+		goto out_notfm;
 	}
=20
 	req =3D aead_request_alloc(tfm, GFP_KERNEL);
@@ -391,6 +391,7 @@ static void test_aead_speed(const char *algo, int enc, =
unsigned int sec,
=20
 out:
 	crypto_free_aead(tfm);
+out_notfm:
 	kfree(sg);
 out_nosg:
 	testmgr_free_buf(xoutbuf);
--=20
1.9.1

--Sig_//O1rreyrO7_4r_Z671jpHem
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTVWeQAAoJEKssnEpaPQKE5dIP/10SxMtgvSwS12sqq+0TnxBE
BdtYTkn9E4UR2tozjPZTUkSX3iTHpn5WMhUxb3ZYwC4LyW8kZhJsyx2HgXQplvMg
zJWughLMQJ7oZV3bo6mrHc5ZeNrLDNMU6AIzRGXqgohn2gXJDedV8moQj2frG/FA
sjxwKi5oz1JREfBD16O07ej9qhBVvUp/nLc6/mH95dj/9enfC3zFPTnyKtJZnppk
+l2rSVUQ/nJYIgysMzEwR0C4sTx750d7mOHGO3xbmqNhWrz9dh5On+dn+bOXU8FT
Vb2tsHyvmMjoYXpD4nX32W1g2Yn4A3vTRT9Gk1s65BoW+nL4uk5KFdtZZ5A+bQRe
eJ3v+5zcsZG1uSRKsBk8290iwRSXgssflhQbIiHpINhVaOUgYEigj3qylsLeVqAT
hYg3ZuSnQDagIX1bZ7dPcc6I9yPq9mzkPLu7QWS4xfvxn6lVesHWMZs+zpMJp7ak
kJJakpNvDK58Pg44pA9quFM9HSxnd6qeGfZKXIDBZIkiqUqftVolJF0OhPvA2FQ6
XUcQuwfYoHJuX9Q/98GjR8jPosrMIu3CsmwT7t0p88rHeALmtqqEoKhC1AaZk6bP
Hh6zyTuVBeFk+9YEjU9iACOCy2JNC9oZ2d7XsIPFZaDxMjeTd2IQHAwcu6McJRyl
nLNVgqYVS4lGN1ozV2En
=w51F
-----END PGP SIGNATURE-----

--Sig_//O1rreyrO7_4r_Z671jpHem--
