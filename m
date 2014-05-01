Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855AbaEAIi1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 04:38:27 -0400
Received: from mout.gmx.net ([212.227.17.21]:54323 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167AbaEAIiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 04:38:24 -0400
Date: Thu, 1 May 2014 10:38:11 +0200
From: Christian Engelmayer <cengelma@gmx.at>
To: devel@driverdev.osuosl.org
Cc: Larry.Finger@lwfinger.net, gregkh@linuxfoundation.org, oat.elena@gmail.com,
        mcgrof@do-not-panic.com, standby24x7@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8188eu: fix potential leak in rtw_set_key()
Message-ID: <20140501103811.41992b00@spike>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/gyFZ5h8qeBzx2lUP009o7NW"; protocol="application/pgp-signature"
X-Provags-ID: V03:K0:LxmjsLaUh7NkzKzTG+3qzJywo+j1wSRrUXL5L0WJzdS+NTLV8Hy
 Q8fTGTGFJy5hRPdPCK4sH+93W4771vVxZs2fNG+v/mJGTQ2lWybtVao7AFH62Fq3hK9Li16
 h7aGPUFAfWqV9+6JqmA18KKLzaYZSg7FutDbHkQ0JUpdWGRRJdkXS1Hvj/SjWi+gtYlwBaQ
 HHxeluPkD39tvp8yrJdUw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/gyFZ5h8qeBzx2lUP009o7NW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Fix a potential leak in the error path of rtw_set_key(). In case the reques=
ted
algorithm is not supported by the driver, the function returns without
enqueuing or freeing the already allocated command and parameter structs. U=
se
a centralized exit path and make sure that all memory is freed correctly.
Detected by Coverity - CID 1077716, 1077717.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
Compile tested and applies against branch staging-next of tree
git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
---
 drivers/staging/rtl8188eu/core/rtw_mlme.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_mlme.c b/drivers/staging/rt=
l8188eu/core/rtw_mlme.c
index 769d4dd..275ae7b 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mlme.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mlme.c
@@ -1729,13 +1729,12 @@ int rtw_set_key(struct adapter *adapter, struct sec=
urity_priv *psecuritypriv, in
 	pcmd =3D (struct	cmd_obj *)rtw_zmalloc(sizeof(struct	cmd_obj));
 	if (pcmd =3D=3D NULL) {
 		res =3D _FAIL;  /* try again */
-		goto exit;
+		goto fail_noobj;
 	}
 	psetkeyparm =3D (struct setkey_parm *)rtw_zmalloc(sizeof(struct setkey_pa=
rm));
 	if (psetkeyparm =3D=3D NULL) {
-		kfree(pcmd);
 		res =3D _FAIL;
-		goto exit;
+		goto fail_noparm;
 	}
=20
 	_rtw_memset(psetkeyparm, 0, sizeof(struct setkey_parm));
@@ -1784,7 +1783,7 @@ int rtw_set_key(struct adapter *adapter, struct secur=
ity_priv *psecuritypriv, in
 			 ("\n rtw_set_key:psecuritypriv->dot11PrivacyAlgrthm=3D%x (must be 1 or=
 2 or 4 or 5)\n",
 			 psecuritypriv->dot11PrivacyAlgrthm));
 		res =3D _FAIL;
-		goto exit;
+		goto fail;
 	}
 	pcmd->cmdcode =3D _SetKey_CMD_;
 	pcmd->parmbuf =3D (u8 *)psetkeyparm;
@@ -1793,7 +1792,13 @@ int rtw_set_key(struct adapter *adapter, struct secu=
rity_priv *psecuritypriv, in
 	pcmd->rspsz =3D 0;
 	_rtw_init_listhead(&pcmd->list);
 	res =3D rtw_enqueue_cmd(pcmdpriv, pcmd);
-exit:
+	return res;
+
+fail:
+	kfree(psetkeyparm);
+fail_noparm:
+	kfree(pcmd);
+fail_noobj:
 	return res;
 }
=20
--=20
1.9.1

--Sig_/gyFZ5h8qeBzx2lUP009o7NW
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTYgfzAAoJEKssnEpaPQKEShgP+wa1BLyA5p7IdCDYsjgldhR7
xwpO6tj8EwQpdxO082KOq+B3LJwqNjpI+/lJD+taA+rnl1/Q6S4Mt/hH/9dTrDJF
0uS9NewjwCa29+J13yA0cm7aryzTOInbvQe6HBp1tFvQTGAEfV53WA5hS60jp/dp
UU056r0ywX/BXgmhe6Ks7zjRRKSVfFN+688sdQVeq5HPhJeaqphK7ElTiDFIkckU
Xx92cjWDKTqwiRmejyKs3eKFh3v26PK0neJ4H7oI9G0LMqoSRUXJ9bbGZRyGDkuC
nqW1876yNKJcpu9yM2HWkyYWUlVIbdHv6MuDGw9NseE1756UnZ9fQ9UAWn+KAbUt
a2Fc3HsFuNOELqCDGZEP2HwX2R+5/GjOulJEHlBRQTnQKJ+Iar63DSGs5vsMmqqb
/0wSGkoljRmuV5LnN2hiLf0jKjxOU8tte+pva52jpIqYMeob0O4v94JiRYh2PeyJ
Fbb5iWDVgEZLzvmtyqnLh5mbSiDZLJye0x+eXEaNxOiBYdDCpoisyIEH71JfQkEU
MBFe8nMGCv+4NC6+NBHd5hsPhLT5/MCtBd882cCur5erigjrRnvoH7zgbg85NDlB
1ugx1zFIuH8Q8BZ7GnyihgEixb9bmpOhBDFJa8bk9VQXjEmxrffY+O5kbtFD5aqK
WGHeRMe1mByvhMiDLHDa
=Dz1F
-----END PGP SIGNATURE-----

--Sig_/gyFZ5h8qeBzx2lUP009o7NW--
