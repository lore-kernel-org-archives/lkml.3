Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084AbaLSKQl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 05:16:41 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:7351 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbaLSKQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 05:16:39 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 19 Dec 2014 02:14:55 -0800
Date: Fri, 19 Dec 2014 11:15:44 +0100
From: Thierry Reding <treding@nvidia.com>
To: Fengguang Wu <fengguang.wu@intel.com>
CC: Daniel Vetter <daniel.vetter@ffwll.ch>, LKP <lkp@01.org>,
        <dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [drm/fb-helper] BUG: unable to handle kernel paging request at
 95d24c70
Message-ID: <20141219101543.GA16504@ulmo.nvidia.com>
References: <20141218170349.GC9298@wfg-t540p.sh.intel.com>
 <20141219020445.GA10008@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
In-Reply-To: <20141219020445.GA10008@wfg-t540p.sh.intel.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [10.2.71.5]
X-ClientProxiedBy: UKMAIL102.nvidia.com (10.26.138.15) To
 UKMAIL101.nvidia.com (10.26.138.13)
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3uo+9/B/ebqu+fSQ"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--3uo+9/B/ebqu+fSQ
Content-Type: multipart/mixed; boundary="BOKacYhQ+x31HxR3"
Content-Disposition: inline


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 18, 2014 at 06:04:45PM -0800, Fengguang Wu wrote:
>=20
> Hi Thierry,
>=20
> FYI, here is another bisect result.

Thanks. Looking at the cirrus driver more closely it already employs the
big hammer upon failure and ends up calling drm_fb_helper_fini() via the
cirrus_driver_unload() call in cirrus_driver_load()'s cleanup path.

> commit 7bf2844ed14de049a4ccec26eb3d8b4c3d5c1971
> Author:     Thierry Reding <treding@nvidia.com>
> AuthorDate: Wed Dec 17 16:39:59 2014 +0100
> Commit:     Daniel Vetter <daniel.vetter@ffwll.ch>
> CommitDate: Wed Dec 17 22:05:08 2014 +0100
>=20
>     drm/fb-helper: Propagate errors from initial config failure
>    =20
>     Make drm_fb_helper_initial_config() return an int rather than a bool =
so
>     that the error can be properly propagated. While at it, update drivers
>     to propagate errors further rather than just ignore them.
>    =20
>     Cc: David Airlie <airlied@linux.ie>
>     Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
>     Cc: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
>     Cc: Rob Clark <robdclark@gmail.com>
>     Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
>     Cc: Alex Deucher <alexander.deucher@amd.com>
>     Cc: Christian K=C3=B6nig <christian.koenig@amd.com>
>     Cc: Ben Skeggs <bskeggs@redhat.com>
>     Signed-off-by: Thierry Reding <treding@nvidia.com>
>     Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
>     Reviewed-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
>     Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>

Using the attached patch on top of this I can no longer reproduce either
this or the earlier result. I'll send a revised patch with this squashed
in.

Thanks,
Thierry

--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=patch
Content-Transfer-Encoding: quoted-printable

diff --git a/drivers/gpu/drm/cirrus/cirrus_fbdev.c b/drivers/gpu/drm/cirrus=
/cirrus_fbdev.c
index 0682210b068b..f7e8c6530beb 100644
--- a/drivers/gpu/drm/cirrus/cirrus_fbdev.c
+++ b/drivers/gpu/drm/cirrus/cirrus_fbdev.c
@@ -318,26 +318,20 @@ int cirrus_fbdev_init(struct cirrus_device *cdev)
 	ret =3D drm_fb_helper_init(cdev->dev, &gfbdev->helper,
 				 cdev->num_crtc, CIRRUSFB_CONN_LIMIT);
 	if (ret)
-		goto free;
+		return ret;
=20
 	ret =3D drm_fb_helper_single_add_all_connectors(&gfbdev->helper);
 	if (ret)
-		goto fini;
+		return ret;
=20
 	/* disable all the possible outputs/crtcs before entering KMS mode */
 	drm_helper_disable_unused_functions(cdev->dev);
=20
 	ret =3D drm_fb_helper_initial_config(&gfbdev->helper, bpp_sel);
 	if (ret)
-		goto fini;
+		return ret;;
=20
 	return 0;
-
-free:
-	kfree(gfbdev);
-fini:
-	drm_fb_helper_fini(&gfbdev->helper);
-	return ret;
 }
=20
 void cirrus_fbdev_fini(struct cirrus_device *cdev)

--BOKacYhQ+x31HxR3--

--3uo+9/B/ebqu+fSQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUk/rPAAoJEN0jrNd/PrOhbmkQAJZYWOnLEwsuKHNMyZzYMbEo
O0cgLYPk6J/Vne4ANf1uD2m9BaOzHlNEW4FCrgwsbXNDNwBUnMhsR7R7bWbcB0oc
qRmlbIVPlWT48RX7vJc9zEIYc3an1t/0oKrbZKXbNUznCwx2bngNDOcP9w+D+EQN
xTyZ1Uc/ql6kb1avSB5b+Y7q/Hn3tMuHVWFgwD6w9CNZ0jZ/PdY0oQdBFjdEXOoe
jNyEWDqpk/2GQK+qCM3U/Qrg/KeEyi1HeDBAhAp1mlusOIr0+ssqNsyQiTmup9d/
LsYMUOY7MmknOj3gq5s+0W2Y4nc6QBDYd4PbSGAaqRqhWiCEzN2pVh1nNUkt6cVp
LzRFL0WuiNbVH02QUta1F2Y63v+O+yifBpI1ZRKjFv9mzIr3/M1X1O1Co/SW+URR
mi2jKDvWNS74akNKIbNpZ5fgm4GwmEatDzl1dwdgujb5ZLrGC3SN9o+G5FN3/TKg
9DM/bOcRWbLIt2GkdJmer8BNXOmmwvYRiaNs7XESjBziNLfppIvWje7Unm3dwaL8
A8dwzmKz+Rp8aTkx2rp3/uRJen84k77RM9q14kGe93cJE6nts9lLIibxGfPU9y4l
8G+cnUhGVEIehX0Pn7f2Aaom4LYfZGUHN/18J8j6MHowMXvL8/UnUNES9Lx02rTd
taZGcrDY7GAp15cGQzSz
=n0uW
-----END PGP SIGNATURE-----

--3uo+9/B/ebqu+fSQ--
