Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795AbaEAUQp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 16:16:45 -0400
Received: from mout.gmx.net ([212.227.15.19]:56148 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835AbaEAUQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 16:16:44 -0400
Date: Thu, 1 May 2014 22:16:31 +0200
From: Christian Engelmayer <cengelma@gmx.at>
To: Mateusz Guzik <mguzik@redhat.com>
Cc: devel@driverdev.osuosl.org, Larry.Finger@lwfinger.net,
        Jes.Sorensen@redhat.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8723au: fix potential leak in
 update_bcn_wps_ie()
Message-ID: <20140501221631.291a9c49@spike>
In-Reply-To: <20140501122216.GC1806@mguzik.redhat.com>
References: <20140501135727.467d6bf2@spike>
	<20140501122216.GC1806@mguzik.redhat.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/ojea9m7MMBgHwMMu1pBP7k4"; protocol="application/pgp-signature"
X-Provags-ID: V03:K0:fe9EFVzsV3T9ARD4av+g68Cx7W5WFXxUQ5wUzvHEsCyBZ6LBOIS
 0ejFonU+hdLZUYwg0HpaIo03hC+HzLortWwhU84Q89zO7pCP0bEi//uhol40ZwuUwONaO+z
 +aorvj8Hoeph5Mq4CfdGHWyzmjDv7g17WK5rL/l9IT081hhxO5VvymGE67ze9Pz1CVJi+FW
 ObIttcV5K9QPi99sflAAQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/ojea9m7MMBgHwMMu1pBP7k4
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 1 May 2014 14:22:17 +0200, Mateusz Guzik <mguzik@redhat.com> wrote:
> On Thu, May 01, 2014 at 01:57:27PM +0200, Christian Engelmayer wrote:
> > Fix a potential leak in the error path of function update_bcn_wps_ie().
> > Make sure that allocated memory for 'pbackup_remainder_ie' is freed
> > upon return. Detected by Coverity - CID 1077718.
> >=20
>=20
>         if (remainder_ielen > 0) {
>                 pbackup_remainder_ie =3D kmalloc(remainder_ielen, GFP_ATO=
MIC);
>                 if (pbackup_remainder_ie)
>                         memcpy(pbackup_remainder_ie, premainder_ie,
>                                remainder_ielen);
>         }
>=20
>         pwps_ie_src =3D pmlmepriv->wps_beacon_ie;
>         if (pwps_ie_src =3D=3D NULL)
>                 return;
>=20
>=20
> Maybe just check pwps_ie_src earlier?
>=20

You are right, I see no reason why this cannot be done early in the functio=
n.


diff --git a/drivers/staging/rtl8723au/core/rtw_ap.c b/drivers/staging/rtl8=
723au/core/rtw_ap.c
index 9b31412..da028c535 100644
--- a/drivers/staging/rtl8723au/core/rtw_ap.c
+++ b/drivers/staging/rtl8723au/core/rtw_ap.c
@@ -1256,6 +1256,10 @@ static void update_bcn_wps_ie(struct rtw_adapter *pa=
dapter)
=20
 	DBG_8723A("%s\n", __func__);
=20
+	pwps_ie_src =3D pmlmepriv->wps_beacon_ie;
+	if (pwps_ie_src =3D=3D NULL)
+		return;
+
 	pwps_ie =3D rtw_get_wps_ie23a(ie+_FIXED_IE_LENGTH_, ielen-_FIXED_IE_LENGT=
H_, NULL, &wps_ielen);
=20
 	if (pwps_ie =3D=3D NULL || wps_ielen =3D=3D 0)
@@ -1274,10 +1278,6 @@ static void update_bcn_wps_ie(struct rtw_adapter *pa=
dapter)
 			       remainder_ielen);
 	}
=20
-	pwps_ie_src =3D pmlmepriv->wps_beacon_ie;
-	if (pwps_ie_src =3D=3D NULL)
-		return;
-
 	wps_ielen =3D (uint)pwps_ie_src[1];/* to get ie data len */
 	if ((wps_offset+wps_ielen+2+remainder_ielen)<=3D MAX_IE_SZ)
 	{


Regards,
Christian

--Sig_/ojea9m7MMBgHwMMu1pBP7k4
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTYqufAAoJEKssnEpaPQKEfU4QAJxwU3C+3oLuw6poR5Ffd5bZ
B0eTLrj5C3dLRST6BoOjMyQQaGhi80Vlr84snzYBT315ZpRUrj6pai8Ex15rWQHE
r3DawTMG3hYMnz5XGntA2Tm3aJxs5lJ6P5gdX0nbie+z6QF9RMCgTWpCvxStwnse
+BMmJQzoPKEA2Y5QtQTL+fSHXX+3ARsqNW81vK7qbIm2kCQD1bEgNNvT0XFIx6xw
1dS0w/umZ39RSUNxXxg4wf7d60Dyfz1rs+Z+fzM3aGmUXD/cxpplSywSta1sMmG7
YjFpYFRtnl54oMVwJ/zpYOpq85acI8lzadOL6eiJionW9PGU2KLiZirr5YWQGDsL
EFRfZs9R3SQ7P3+trqDiJVlXZN0qofQA0+VcNiZPPPwtg7zZvyCIFKLgBdVHa+As
k4jBWuzGxN1q27s6jwqNUe9bgDp8qDG2dj+JPFE5mSx6E3lgGTTMh9ecpWnrQtp0
eeh+Js+gPiChzmd+eFbFmbtUDG6AOAMa3N/M8V1TdBdzKtENoo0ml3i2N1Ny/mpV
LZRC57GwPl3yy2dECAlZEEuX0S16wXwlOuUmt24iCkZCR9Cj8qjaNFRcabF+KHnh
ntQpN+sk67YqNw+db+8w7QwvKS/0w0X4X2dUGWbCYhAZPoaV2gLsWGmOPPmwyMT0
s9lqYo6JBBufVmEZjnov
=RjFQ
-----END PGP SIGNATURE-----

--Sig_/ojea9m7MMBgHwMMu1pBP7k4--
