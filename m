Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644Ab3KTR6n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 12:58:43 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:39224 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753463Ab3KTR6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 12:58:40 -0500
Date: Wed, 20 Nov 2013 11:58:14 -0600
From: Felipe Balbi <balbi@ti.com>
To: <ldewangan@nvidia.com>, <broonie@linaro.org>, <lgirdwood@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Subject: commit c368e5fc2a190923b786f2de3e79430ea3566a25 regresses MMC
Message-ID: <20131120175814.GC27423@saruman.home>
Reply-To: <balbi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oTHb8nViIGeoXxdp"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--oTHb8nViIGeoXxdp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

commit c368e5fc2a190923b786f2de3e79430ea3566a25 (regulator: fixed: get
rid of {get|list}_voltage()) regresses any MMC host controller which
uses fixed regulator for functionality.

Note that mmc core uses regulator_list_voltage() to setup OCR mask and
that has a check for missing ->list_voltage() method.

Reverting that commit makes beablebone black and white work with today's
Linus' HEAD.

That commit should either be reverted or regulator_list_voltages()
should be fixed up accordingly.

Proposed patch below:

8<------------------------ cut here -----------------------------------

=46rom 807bb4e91eea46390f184b737f7f8dc634e62a01 Mon Sep 17 00:00:00 2001
=46rom: Felipe Balbi <balbi@ti.com>
Date: Wed, 20 Nov 2013 11:52:33 -0600
Subject: [PATCH] regulator: core: fix regulator_list_voltage()

commit c368e5f (regulator: fixed: get rid of
{get|list}_voltage()) caused a regression
for any MMC host which uses a fixed regulator.

MMC core uses regulator_list_voltage() to
setup card's OCR mask. Unfortunately, said
commit missed the fact that regulator_list_voltage()
would bail out early if ->list_voltage()
implementation is missing.

This was not a problem before, since fixed
regulator implemented that callback.

The best solution is to patch regulator_list_voltage()
itself, since MMC core shouldn't have to know
which regulator type it's using.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/regulator/core.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 6382f0a..0da48ae 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2181,15 +2181,21 @@ EXPORT_SYMBOL_GPL(regulator_count_voltages);
 int regulator_list_voltage(struct regulator *regulator, unsigned selector)
 {
 	struct regulator_dev	*rdev =3D regulator->rdev;
-	struct regulator_ops	*ops =3D rdev->desc->ops;
+	const struct regulator_desc *desc =3D rdev->desc;
+	struct regulator_ops	*ops =3D desc->ops;
 	int			ret;
=20
-	if (!ops->list_voltage || selector >=3D rdev->desc->n_voltages)
+	if ((!ops->list_voltage && !desc->fixed_uV) ||
+			selector >=3D rdev->desc->n_voltages)
 		return -EINVAL;
=20
-	mutex_lock(&rdev->mutex);
-	ret =3D ops->list_voltage(rdev, selector);
-	mutex_unlock(&rdev->mutex);
+	if (ops->list_voltage) {
+		mutex_lock(&rdev->mutex);
+		ret =3D ops->list_voltage(rdev, selector);
+		mutex_unlock(&rdev->mutex);
+	} else /* if (desc->fixed_uV) */ {
+		ret =3D desc->fixed_uV;
+	}
=20
 	if (ret > 0) {
 		if (ret < rdev->constraints->min_uV)
--=20
1.8.4.GIT


--=20
balbi

--oTHb8nViIGeoXxdp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSjPg1AAoJEIaOsuA1yqREq9MP/jfIsBIYGqaFZdguzeMnoO3h
gfpe41b7R/JAh61BezJT6vL7DsV8MvceNAZKs7r6cs+rvlF3iZx07LLTmvGi+YLj
jStKfE4cyV05q9NhyhHrxQg58LtDK11XIujWClIdF8pN4W0WFkFrM0coSWU5I/aH
s/MYjXufZ2j/4Ymvzu4WQ4F87PKkES6PcbOHht90BqRCsYXGyLva6d7bqrGovb1B
gVKg9IsaMzDLwavs9ORP8g4I9gChs81TL0jP1MBbAybfrujcqxhI9kvU6pKQc3KP
07Jys92BENcjrZab13O+Yw+iEadXbXW4xKaGzMuJQ1ThcltjEaOvR+1NYWN90hld
1xmbXY2xHcaz+yO3FdKUV6jis+iPyLTOFzdKAzZRP8NvtqL9r+LdHSq8QDFu6Zmd
wc51+8OfyrbFYTKgc1w7aGg2EnaFzdqnnWR8fgJYCGOPCYg3ds3SeFPNLe/uzo0i
DDZLn9sTrw2XfDnQgbj9jjuREtp7jD8zUTzkfrYQqGksDwFr8voRHw4KsGPDsMaj
NOnQJeehH4M15ZUUN05nsSlWnvDTt4ulVHZeNDLD4sPmX+DG9t1YU2fbuYyzBns5
8r/iIPUTjqhPiftHEABLwFwaRh8znjWeOYOuCv4WVSumr66wm4U+QU6LftBWMbsr
HbSECV9HcXQvLY2MSO0h
=xb2U
-----END PGP SIGNATURE-----

--oTHb8nViIGeoXxdp--
