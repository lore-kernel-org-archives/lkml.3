Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780AbaEAKcj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 06:32:39 -0400
Received: from mout.gmx.net ([212.227.15.19]:54971 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752037AbaEAKci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 06:32:38 -0400
Date: Thu, 1 May 2014 12:30:57 +0200
From: Christian Engelmayer <cengelma@gmx.at>
To: devel@driverdev.osuosl.org
Cc: dan.carpenter@oracle.com, mcgrof@do-not-panic.com,
        gregkh@linuxfoundation.org, oat.elena@gmail.com,
        Larry.Finger@lwfinger.net, linux-kernel@vger.kernel.org
Subject: [PATCH v2] staging: rtl8188eu: fix potential leak in rtw_set_key()
Message-ID: <20140501123057.5f00e30d@spike>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/MQoNQntfOAaEPIPc7QSKQIj"; protocol="application/pgp-signature"
X-Provags-ID: V03:K0:BZJ7tT6pZeqo7aeWDflsdJkPtc1OYgUsTcm1+CbWExJMRfrbowX
 A3wu8t4HxMMIKytLY85mXe561Rk3xRiN386CGRJcY92Fm5Rvqi+7lKXZVZqEyqwCVDR90/y
 uU9WPICbCE7N0CYU19DjgadDOlS8Na9VOfaY31g0HFybCtYYrs1LqVfu4WX/T16DM+SIBAI
 AHgKs4CDd6AD69nSFfovA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/MQoNQntfOAaEPIPc7QSKQIj
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
v2: Added changes requested by Dan Carpenter:

   * Just return directly where no cleanup is needed.
   * Prefer naming labels by the labeled action rather than the goto locati=
on.

Compile tested and applies against branch staging-next of tree
git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
---
 drivers/staging/rtl8188eu/core/rtw_mlme.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_mlme.c b/drivers/staging/rt=
l8188eu/core/rtw_mlme.c
index 769d4dd..155282e 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mlme.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mlme.c
@@ -1727,15 +1727,13 @@ int rtw_set_key(struct adapter *adapter, struct sec=
urity_priv *psecuritypriv, in
 	int	res =3D _SUCCESS;
=20
 	pcmd =3D (struct	cmd_obj *)rtw_zmalloc(sizeof(struct	cmd_obj));
-	if (pcmd =3D=3D NULL) {
-		res =3D _FAIL;  /* try again */
-		goto exit;
-	}
+	if (pcmd =3D=3D NULL)
+		return _FAIL;  /* try again */
+
 	psetkeyparm =3D (struct setkey_parm *)rtw_zmalloc(sizeof(struct setkey_pa=
rm));
 	if (psetkeyparm =3D=3D NULL) {
-		kfree(pcmd);
 		res =3D _FAIL;
-		goto exit;
+		goto err_free_cmd;
 	}
=20
 	_rtw_memset(psetkeyparm, 0, sizeof(struct setkey_parm));
@@ -1784,7 +1782,7 @@ int rtw_set_key(struct adapter *adapter, struct secur=
ity_priv *psecuritypriv, in
 			 ("\n rtw_set_key:psecuritypriv->dot11PrivacyAlgrthm=3D%x (must be 1 or=
 2 or 4 or 5)\n",
 			 psecuritypriv->dot11PrivacyAlgrthm));
 		res =3D _FAIL;
-		goto exit;
+		goto err_free_parm;
 	}
 	pcmd->cmdcode =3D _SetKey_CMD_;
 	pcmd->parmbuf =3D (u8 *)psetkeyparm;
@@ -1793,7 +1791,12 @@ int rtw_set_key(struct adapter *adapter, struct secu=
rity_priv *psecuritypriv, in
 	pcmd->rspsz =3D 0;
 	_rtw_init_listhead(&pcmd->list);
 	res =3D rtw_enqueue_cmd(pcmdpriv, pcmd);
-exit:
+	return res;
+
+err_free_parm:
+	kfree(psetkeyparm);
+err_free_cmd:
+	kfree(pcmd);
 	return res;
 }
=20
--=20
1.9.1

--Sig_/MQoNQntfOAaEPIPc7QSKQIj
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTYiJhAAoJEKssnEpaPQKEa6sP/RTCBVW8bLf4nUW4Oa/Al8OG
zK1k4EWSgqehlBIjmb7vrt74+Syqa2Nl9YA2CWuydIaEA8l5hw2MknghEU+XqjXM
zONARIogAxBiGI6382NyiEQldpq/R7bzSvs6qkyvBL3uYrMJfL6GG4GSG9qQglDU
zo3CghutfmNamUBbqCdNY1q8terSiAenLA/qnEUfe3olBRwkj0bpugXLckWn+rj0
yyg1Sw9xX4kYdaLb5bMDteor7lWfLZAH96knrHLnYeWfdP1heA/tT0+t79Y9yCM6
0Q4kreSLqcSLsCuxkdN35iwXvZbYiuwU4/S1fzU+Zvbz7unjitJsykgSJ3p4IJYW
au/Z+IIg5xop66FbO+Ct4DBrmD4Qn600njr+JdOgWwo9MiemvR2B2hO1aDUWH7Fe
QBki9179Yy6cpOl4sPya6sH2/gw5ZMRUym1tv0ia/0gC6z/Tki/UJSvfH4a6u7g+
8SuLpNR7tzGA0pZ/+7WpdlVmtITskbFNM98u1o4YIcBENx0cBv3+2PUnl5PdTwFd
gkDyMIACGJKdMAPvcrHCp7HQ0KRhxZDTWk+Eo4GHSLGx1QG7TgOObuwizydQhcRw
eUqwbe2Ctq2MtrXcpp47rJFijrVUGxUfRocuYW2CAZ8/c9pvonUOrjagQOnJnmOE
Kr/+KobVXcLKBga2zPsE
=/io+
-----END PGP SIGNATURE-----

--Sig_/MQoNQntfOAaEPIPc7QSKQIj--
