Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062AbaLJCBF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 21:01:05 -0500
Received: from ozlabs.org ([103.22.144.67]:59419 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753156AbaLJCBC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 21:01:02 -0500
Date: Wed, 10 Dec 2014 13:00:56 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>, Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefan =?UTF-8?B?QnLDvG5z?= <stefan.bruens@rwth-aachen.de>
Subject: linux-next: manual merge of the drm-misc tree with the  tree
Message-ID: <20141210130056.1b434786@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/plMfBZyRDKB_VPmXsk2n/hl"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/plMfBZyRDKB_VPmXsk2n/hl
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the drm-misc tree got a conflict in
drivers/gpu/drm/drm_edid.c between commit 40d9b043a89e ("drm/connector:
store tile information from displayid (v3)") from the drm tree and
commit d6885d659037 ("drm/edid: move drm_edid_is_zero to top, make edid
argument const") and c465bbc87ce3 ("drm/edid: new
drm_edid_block_checksum helper function V3") from the drm-misc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/drm_edid.c
index 72fd8820e186,21cc45cf3367..000000000000
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@@ -1015,8 -1014,24 +1015,27 @@@ module_param_named(edid_fixup, edid_fix
  MODULE_PARM_DESC(edid_fixup,
  		 "Minimum number of valid EDID header bytes (0-8, default 6)");
 =20
 +static void drm_get_displayid(struct drm_connector *connector,
 +			      struct edid *edid);
++
+ static int drm_edid_block_checksum(const u8 *raw_edid)
+ {
+ 	int i;
+ 	u8 csum =3D 0;
+ 	for (i =3D 0; i < EDID_LENGTH; i++)
+ 		csum +=3D raw_edid[i];
+=20
+ 	return csum;
+ }
+=20
+ static bool drm_edid_is_zero(const u8 *in_edid, int length)
+ {
+ 	if (memchr_inv(in_edid, 0, length))
+ 		return false;
+=20
+ 	return true;
+ }
+=20
  /**
   * drm_edid_block_valid - Sanity check the EDID block (base or extension)
   * @raw_edid: pointer to raw EDID block
@@@ -1179,34 -1196,8 +1200,26 @@@ drm_do_probe_ddc_edid(void *data, u8 *b
  	return ret =3D=3D xfers ? 0 : -1;
  }
 =20
- static bool drm_edid_is_zero(u8 *in_edid, int length)
- {
- 	if (memchr_inv(in_edid, 0, length))
- 		return false;
-=20
- 	return true;
- }
-=20
 -static u8 *
 -drm_do_get_edid(struct drm_connector *connector, struct i2c_adapter *adap=
ter)
 +/**
 + * drm_do_get_edid - get EDID data using a custom EDID block read function
 + * @connector: connector we're probing
 + * @get_edid_block: EDID block read function
 + * @data: private data passed to the block read function
 + *
 + * When the I2C adapter connected to the DDC bus is hidden behind a devic=
e that
 + * exposes a different interface to read EDID blocks this function can be=
 used
 + * to get EDID data using a custom block read function.
 + *
 + * As in the general case the DDC bus is accessible by the kernel at the =
I2C
 + * level, drivers must make all reasonable efforts to expose it as an I2C
 + * adapter and use drm_get_edid() instead of abusing this function.
 + *
 + * Return: Pointer to valid EDID or NULL if we couldn't find any.
 + */
 +struct edid *drm_do_get_edid(struct drm_connector *connector,
 +	int (*get_edid_block)(void *data, u8 *buf, unsigned int block,
 +			      size_t len),
 +	void *data)
  {
  	int i, j =3D 0, valid_extensions =3D 0;
  	u8 *block, *new;

--Sig_/plMfBZyRDKB_VPmXsk2n/hl
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUh6lcAAoJEMDTa8Ir7ZwVaRcP/izJf3UnxU1QAzYZTEpva8w5
40YtEC+wyNs1hZ46Y/VC0Lbu/jF7B5pQ+5ub5IkcwIkmjR+KbSTTGUgHHZUALUpK
nlvzu0O9uyKUMQGNRhLzBSlM2KxwmT8W05/StA9CsYfffEfeFosIV0j8uy2oQMf9
85bASO0QgHwP2ZtUL7TQUx9NJLxbG6rq+1mSsfPudn/sOI7FAdjtAdLDkvjAsfcp
dT0j6s+X4spKCxmmU5pG9qPcm47MOUBGAUTdysdrsOdkAplMuai81SLO2kmQ3m94
f0bkq2dxT/T7AFPy3Rbcg5wJ8StjWvwi1dD+6SDZq7F2u5dKwOdFU1HRgX4scfQ0
de4D5b+dWYpvcKymnprRO/5WWDqGOVTmF9gZkrfNX0RYk7APO0hs895VG6YaGB0t
0sT6ZqY5VZZDBqEfkMa9W4tIuh7AjnSO4EC07o2GwnhU4yjD+71ItibhBEcOKvp5
8G0382g7jGqJlmA2kej/d/HQVVUTAfK0NnhqJO7WNm8YTdiy2wPoXP/OgJi8uY4Q
q0gcJ31iWBhGuwS1TuR8GhINgqH3eOMD6zL6CmRKOSUhocF6XicZCqly0JB/gK29
fJZcceEOe2q7Kq+c5Wip+EQRMgMAH+ee8d+VHpgT3OQrrprAfcX/XJxl8JEV2Iw1
scZKM18CL2l2+6/Ta3IU
=kKQQ
-----END PGP SIGNATURE-----

--Sig_/plMfBZyRDKB_VPmXsk2n/hl--
