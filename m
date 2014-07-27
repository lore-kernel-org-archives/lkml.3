Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751447AbaG0ER6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 00:17:58 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:40646 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbaG0ERz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 00:17:55 -0400
Content-Type: multipart/signed; boundary="Apple-Mail=_5B345BDC-4070-4C84-87F0-29E89E8F63D0"; protocol="application/pgp-signature"; micalg=pgp-sha1
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH] crypto: crypto_user.c:  Cleaning up missing null-terminate in conjunction with strncpy
From: Mark D Rustad <mrustad@gmail.com>
In-Reply-To: <1406384125-2093-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Sat, 26 Jul 2014 21:17:50 -0700
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-Id: <35BFF3B8-DE0F-4201-8C7B-80AE49409209@gmail.com>
References: <1406384125-2093-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Apple-Mail=_5B345BDC-4070-4C84-87F0-29E89E8F63D0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

Rickard,

On Jul 26, 2014, at 7:15 AM, Rickard Strandqvist =
<rickard_strandqvist@spectrumdigital.se> wrote:

> Replacing strncpy with strlcpy to avoid strings that lacks null =
terminate.
>=20
> Signed-off-by: Rickard Strandqvist =
<rickard_strandqvist@spectrumdigital.se>
> ---
> crypto/crypto_user.c |   12 ++++++------
> 1 file changed, 6 insertions(+), 6 deletions(-)
>=20
> diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
> index e2a34fe..09b465e 100644
> --- a/crypto/crypto_user.c
> +++ b/crypto/crypto_user.c
> @@ -77,7 +77,7 @@ static int crypto_report_cipher(struct sk_buff *skb, =
struct crypto_alg *alg)
> {
> 	struct crypto_report_cipher rcipher;
>=20
> -	strncpy(rcipher.type, "cipher", sizeof(rcipher.type));
> +	strlcpy(rcipher.type, "cipher", sizeof(rcipher.type));
>=20
> 	rcipher.blocksize =3D alg->cra_blocksize;
> 	rcipher.min_keysize =3D alg->cra_cipher.cia_min_keysize;

This patch is an example of what I mentioned in my previous message. I =
figured I should go back and take a look at more of the patches. It =
looks to me like all of the changes in this patch create information =
leaks, because strlcpy only copies to the terminator, leaving the rest =
of the destination area in an otherwise uninitialized stack area alone. =
That structure is then copied whole into an skb and sent as a netlink =
message.

That will leak kernel information into userspace.

All of these patches need to be considered in regard to information =
leakage.

> @@ -96,7 +96,7 @@ static int crypto_report_comp(struct sk_buff *skb, =
struct crypto_alg *alg)
> {
> 	struct crypto_report_comp rcomp;
>=20
> -	strncpy(rcomp.type, "compression", sizeof(rcomp.type));
> +	strlcpy(rcomp.type, "compression", sizeof(rcomp.type));
> 	if (nla_put(skb, CRYPTOCFGA_REPORT_COMPRESS,
> 		    sizeof(struct crypto_report_comp), &rcomp))
> 		goto nla_put_failure;
> @@ -109,10 +109,10 @@ nla_put_failure:
> static int crypto_report_one(struct crypto_alg *alg,
> 			     struct crypto_user_alg *ualg, struct =
sk_buff *skb)
> {
> -	strncpy(ualg->cru_name, alg->cra_name, sizeof(ualg->cru_name));
> -	strncpy(ualg->cru_driver_name, alg->cra_driver_name,
> +	strlcpy(ualg->cru_name, alg->cra_name, sizeof(ualg->cru_name));
> +	strlcpy(ualg->cru_driver_name, alg->cra_driver_name,
> 		sizeof(ualg->cru_driver_name));
> -	strncpy(ualg->cru_module_name, module_name(alg->cra_module),
> +	strlcpy(ualg->cru_module_name, module_name(alg->cra_module),
> 		sizeof(ualg->cru_module_name));
>=20
> 	ualg->cru_type =3D 0;
> @@ -125,7 +125,7 @@ static int crypto_report_one(struct crypto_alg =
*alg,
> 	if (alg->cra_flags & CRYPTO_ALG_LARVAL) {
> 		struct crypto_report_larval rl;
>=20
> -		strncpy(rl.type, "larval", sizeof(rl.type));
> +		strlcpy(rl.type, "larval", sizeof(rl.type));
> 		if (nla_put(skb, CRYPTOCFGA_REPORT_LARVAL,
> 			    sizeof(struct crypto_report_larval), &rl))
> 			goto nla_put_failure;

--=20
Mark Rustad, MRustad@gmail.com


--Apple-Mail=_5B345BDC-4070-4C84-87F0-29E89E8F63D0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJT1H1vAAoJEDwO/+eO4+5uYZQQAKdLyYKUL1zLeW6BNlXUOtjT
DlNXd1vDltd1Yx4SKDelu9NNOdVMzdDzlNv26LilqursGhKE5Fe3YKAGCyNMaa4W
rbuQhNnKiuuLLXn63Nhh/tYCR073rV7X1M7HlKGjZ5W32t3TFIGXv4wary3OVakW
8rc0Tq+vpm7k2A3ig/uGd5Kp2ANWLw4LMIMh7TOdtoG3QuqRDXsFNImGa/LhZQx1
QP2C/cTTFOWpvAWYGAk4PIKhSMKhZ1HDTPhwbZpuuUTpIYw2OsqvpitO76E87mCh
97r3RfsrqiJavvTAsIVf/Y+RPrh3hkDIFGd1PxO0S7jDLa4F1Fd++9l2+2i7UCSS
tljfapb3uLqvG+aJFWj8MGZuzKzi8vfkUEcGt9dvhNB2zw765yX2lMfxRdIfKyas
E1O3oU8Rk/8mVfw2eDUY+g7mRu/ENZjiJDD6uOgqB5KULvCqI2BRA5lqDw88KLu0
+f12R550zXBJeYmC0x++IVJ0NO/roFhfE5vVTVCwN4/bHmClV9Y9I96NUV4B31ai
QYz7Du1Z7lUrvHuerLYAen0niB22yJfAdww5MLSVQk7qCvWx4V67WC/rqUmzfTvk
KUJs6lHW/yCl9SkA6SypEmeKWYuzKxFluPP5qLKiEvdSkOvOrW/vEV5TfG43iQbX
5fpy8TZbkxhMews+DGyt
=QUjg
-----END PGP SIGNATURE-----

--Apple-Mail=_5B345BDC-4070-4C84-87F0-29E89E8F63D0--
