Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132AbaEAWP2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 18:15:28 -0400
Received: from mout.gmx.net ([212.227.15.19]:60570 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751762AbaEAWP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 18:15:27 -0400
Date: Thu, 1 May 2014 23:54:02 +0200
From: Christian Engelmayer <cengelma@gmx.at>
To: devel@driverdev.osuosl.org
Cc: Larry.Finger@lwfinger.net, florian.c.schilhabel@googlemail.com,
        gregkh@linuxfoundation.org, linuxgeek@gmail.com,
        alexandre.f.demers@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8712: fix potential leaks in r8712_set_key()
Message-ID: <20140501235402.48ced880@spike>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/dASAGXrB=tcGt5LM9IAJL2v"; protocol="application/pgp-signature"
X-Provags-ID: V03:K0:DKUMuyRTSuTgbNJWe8I7ATXRY25Xu552YJ39bDk9jRuGl2tf2ZO
 xsnMyG6v7KxRf+dejGUwgvXl7Q//cYEZDyiBIWSsewCMj/n362B95M6vEmtil+JdUSMcp8S
 EkTlQ1jRq53wMrtLbpGsqhrjQHc+OCdz4lS2qUqttfGIZPDTSLSHBiEsM0ml67525jP56bR
 zmb/vm/CP4hCV49TgoVBA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/dASAGXrB=tcGt5LM9IAJL2v
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Fix potential leaks in the error paths of r8712_set_key(). In case the
algorithm specific checks fail, the function returns without enqueuing
or freeing the already allocated command and parameter structs. Use a
centralized exit path and make sure that all memory is freed correctly.
Detected by Coverity - CID 144370, 144371.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
Compile tested and applies against branch staging-next of tree
git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
---
 drivers/staging/rtl8712/rtl871x_mlme.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/rtl8712/rtl871x_mlme.c b/drivers/staging/rtl87=
12/rtl871x_mlme.c
index 3ea99ae..23fd8c1 100644
--- a/drivers/staging/rtl8712/rtl871x_mlme.c
+++ b/drivers/staging/rtl8712/rtl871x_mlme.c
@@ -1243,14 +1243,15 @@ sint r8712_set_key(struct _adapter *adapter,
 	struct cmd_obj *pcmd;
 	struct setkey_parm *psetkeyparm;
 	u8 keylen;
+	sint ret =3D _SUCCESS;
=20
 	pcmd =3D (struct cmd_obj *)_malloc(sizeof(struct cmd_obj));
 	if (pcmd =3D=3D NULL)
 		return _FAIL;
 	psetkeyparm =3D (struct setkey_parm *)_malloc(sizeof(struct setkey_parm));
 	if (psetkeyparm =3D=3D NULL) {
-		kfree((unsigned char *)pcmd);
-		return _FAIL;
+		ret =3D _FAIL;
+		goto err_free_cmd;
 	}
 	memset(psetkeyparm, 0, sizeof(struct setkey_parm));
 	if (psecuritypriv->AuthAlgrthm =3D=3D 2) { /* 802.1X */
@@ -1274,23 +1275,28 @@ sint r8712_set_key(struct _adapter *adapter,
 			psecuritypriv->DefKey[keyid].skey, keylen);
 		break;
 	case _TKIP_:
-		if (keyid < 1 || keyid > 2)
-			return _FAIL;
+		if (keyid < 1 || keyid > 2) {
+			ret =3D _FAIL;
+			goto err_free_parm;
+		}
 		keylen =3D 16;
 		memcpy(psetkeyparm->key,
 			&psecuritypriv->XGrpKey[keyid - 1], keylen);
 		psetkeyparm->grpkey =3D 1;
 		break;
 	case _AES_:
-		if (keyid < 1 || keyid > 2)
-			return _FAIL;
+		if (keyid < 1 || keyid > 2) {
+			ret =3D _FAIL;
+			goto err_free_parm;
+		}
 		keylen =3D 16;
 		memcpy(psetkeyparm->key,
 			&psecuritypriv->XGrpKey[keyid - 1], keylen);
 		psetkeyparm->grpkey =3D 1;
 		break;
 	default:
-		return _FAIL;
+		ret =3D _FAIL;
+		goto err_free_parm;
 	}
 	pcmd->cmdcode =3D _SetKey_CMD_;
 	pcmd->parmbuf =3D (u8 *)psetkeyparm;
@@ -1299,7 +1305,13 @@ sint r8712_set_key(struct _adapter *adapter,
 	pcmd->rspsz =3D 0;
 	_init_listhead(&pcmd->list);
 	r8712_enqueue_cmd(pcmdpriv, pcmd);
-	return _SUCCESS;
+	return ret;
+
+err_free_parm:
+	kfree(psetkeyparm);
+err_free_cmd:
+	kfree(pcmd);
+	return ret;
 }
=20
 /* adjust IEs for r8712_joinbss_cmd in WMM */
--=20
1.9.1

--Sig_/dASAGXrB=tcGt5LM9IAJL2v
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTYsJ6AAoJEKssnEpaPQKEXfoP/26TXkH9tmXi4E8WLNVcO9h8
g5fVMUZnYHThdw0bV3xZJt3SCDQMt7NSidHjTlxZKZigckx6SafK+KCaO3t7mAQI
rNj5QGpnvPyuSA6c/mCLOxB9fV+yJn2LWi8mr+HOKsGLoWb0j5wCeN0tBiXNJe7/
SjVJyu4BH3IVJ0otg4doMnciq334xzOH7VKc/c4HGlOwOgu2ZkbAQZOxGSjN7FRh
3H9lKECLU8NJF5UvkhxNTpwgqR9Y7Phu9vkSf2LYxsmpgoE8dRYFSD8dxRy7UhXr
2hJ5aI/u2mr92GALgutM9gyJgh+l8iqzSSwIzJJajdTGKW8yCOoP8bZmLNr58BL0
ROEi0GQsTLy+xxE9N3kJk36wAk5n3c45kN+CDtX6MP+rOLucdmvbPyUHuo7Mu10r
GwUFUTvH84AC0nYa5dAKppMWX4OuqsvRK7xuWQGZuvs4d+aZnBUVcjGSKL5hey/3
sLIyae9TfjgmWZ8I2zQdzZNYy7/WF3f+n5w8cbiVydedRUUrJE7MdmNxVNiT4pxo
djt7/tuPA7Qw1a05H5+ffrHW/XypQHz/NMabg6Hyh+GdXx2oS8+iVlQIW4a0O1AA
Mm+ug7Ibd5Q9woowFE9RnHUSyI5ojT5pLNcZIAeidGM18cyKkYcGp/+mwxB801eu
SFv8wTqSbrvYUqWeegp1
=7pD7
-----END PGP SIGNATURE-----

--Sig_/dASAGXrB=tcGt5LM9IAJL2v--
