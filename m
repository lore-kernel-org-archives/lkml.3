Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679Ab3I0Ftu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 01:49:50 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40595 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab3I0Fts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 01:49:48 -0400
Date: Fri, 27 Sep 2013 15:49:36 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org
Subject: linux-next: manual merge of the omap_dss2 tree with the fbdev tree
Message-Id: <20130927154936.a4f2998544091a3424f0de83@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.21; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__27_Sep_2013_15_49_36_+1000_SdOO7a1KP7uPAmy9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__27_Sep_2013_15_49_36_+1000_SdOO7a1KP7uPAmy9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tomi,

Today's linux-next merge of the omap_dss2 tree got a conflict in
drivers/video/atmel_lcdfb.c between commit 5e8be022fb5b ("video:
atmel_lcdfb: add device tree suport") from the fbdev tree and commit
a36bf1925539 ("video: atmel_lcdfb: Remove redundant dev_set_drvdata")
from the omap_dss2 tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/video/atmel_lcdfb.c
index bf9c5d0,3f7d6dc..0000000
--- a/drivers/video/atmel_lcdfb.c
+++ b/drivers/video/atmel_lcdfb.c
@@@ -1157,30 -934,19 +1157,30 @@@ static int __init atmel_lcdfb_probe(str
  	}
 =20
  	sinfo =3D info->par;
 +	sinfo->pdev =3D pdev;
 +	sinfo->info =3D info;
 +
 +	INIT_LIST_HEAD(&info->modelist);
 =20
 -	if (dev_get_platdata(dev)) {
 -		pdata_sinfo =3D dev_get_platdata(dev);
 -		sinfo->default_bpp =3D pdata_sinfo->default_bpp;
 -		sinfo->default_dmacon =3D pdata_sinfo->default_dmacon;
 -		sinfo->default_lcdcon2 =3D pdata_sinfo->default_lcdcon2;
 -		sinfo->default_monspecs =3D pdata_sinfo->default_monspecs;
 -		sinfo->atmel_lcdfb_power_control =3D pdata_sinfo->atmel_lcdfb_power_con=
trol;
 -		sinfo->guard_time =3D pdata_sinfo->guard_time;
 -		sinfo->smem_len =3D pdata_sinfo->smem_len;
 -		sinfo->lcdcon_is_backlight =3D pdata_sinfo->lcdcon_is_backlight;
 -		sinfo->lcdcon_pol_negative =3D pdata_sinfo->lcdcon_pol_negative;
 -		sinfo->lcd_wiring_mode =3D pdata_sinfo->lcd_wiring_mode;
 +	if (pdev->dev.of_node) {
 +		ret =3D atmel_lcdfb_of_init(sinfo);
 +		if (ret)
 +			goto free_info;
- 	} else if (dev->platform_data) {
++	} else if (dev_get_platdata(dev)) {
 +		struct fb_monspecs *monspecs;
 +		int i;
 +
- 		pdata =3D dev->platform_data;
++		pdata =3D dev_get_platdata(dev);
 +		monspecs =3D pdata->default_monspecs;
 +		sinfo->pdata =3D *pdata;
 +
 +		for (i =3D 0; i < monspecs->modedb_len; i++)
 +			fb_add_videomode(&monspecs->modedb[i], &info->modelist);
 +
 +		sinfo->config =3D atmel_lcdfb_get_config(pdev);
 +
 +		info->var.bits_per_pixel =3D pdata->default_bpp ? pdata->default_bpp : =
16;
 +		memcpy(&info->monspecs, pdata->default_monspecs, sizeof(info->monspecs)=
);
  	} else {
  		dev_err(dev, "cannot get default configuration\n");
  		goto free_info;
@@@ -1305,11 -1089,16 +1305,11 @@@
  	ret =3D register_framebuffer(info);
  	if (ret < 0) {
  		dev_err(dev, "failed to register framebuffer device: %d\n", ret);
- 		goto reset_drvdata;
+ 		goto free_cmap;
  	}
 =20
 -	/* add selected videomode to modelist */
 -	fb_var_to_videomode(&fbmode, &info->var);
 -	fb_add_videomode(&fbmode, &info->modelist);
 -
  	/* Power up the LCDC screen */
 -	if (sinfo->atmel_lcdfb_power_control)
 -		sinfo->atmel_lcdfb_power_control(1);
 +	atmel_lcdfb_power_control(sinfo, 1);
 =20
  	dev_info(dev, "fb%d: Atmel LCDC at 0x%08lx (mapped at %p), irq %d\n",
  		       info->node, info->fix.mmio_start, sinfo->mmio, sinfo->irq_base);

--Signature=_Fri__27_Sep_2013_15_49_36_+1000_SdOO7a1KP7uPAmy9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBCAAGBQJSRRx0AAoJEMDTa8Ir7ZwVoU8P+wczOG8vEyoeRlAc14Im1enw
zjYy31EsT6L1LwEVbm/UoWFMEU9OiLx5McJryYKrnAuIMawwlOQ9AIRnGPIDb2fH
MN70mB8T65R1Jwv57GRRKmtCteO+COGp+17VcxUa36dJupjLT+Ny8EK5/0S/pscS
OMmn8xddKYgP+IrgTPdnqHdhwORB84hkhJIxqUzyiC6EFEeBF1ghkak+29Gfb/3S
3NMEQevs1blxPgakXARyvpyrF8/AESRVUm20ly2zG+MDVsX1CUY85ZYrC1Yb86Pe
g+TgWjCmmOIDQGnrmv5NCCFdhP3NzFP3uMNlrjW8nMGYKrVKR4tKAU4pwaFhChZA
yQZ+QM4gO/vHEn2Lj5tJAb1QTo/Hm1nNJ9oxMqN1G898jSvz71+JAvD1NYzNv7yv
MjDHL1HmBkKJeHyzCaCGWtOgbVLAJ0xhGEO2u5Hrc2xELZOnjyzlXxV2EH4ttJ8d
fGOojM3jM+LDN5DJa3C/o71P5NDRezgQK2/3tlE1IaZcv7FHhOS25NnL6VqVtw4S
CNgnLSvi/4XnkY/4ACdm8iP9bb7V96Jl3en5lh8aJIW4Wr6wa+OXPOAsuU47i990
mI7ksffNU+lnEsjNP7YOt9ERsonMvjKoZSxfWax4LR350vBD8aianseWgbLidVPy
5HFeJ9eH3JnXapnXqD0t
=zK9v
-----END PGP SIGNATURE-----

--Signature=_Fri__27_Sep_2013_15_49_36_+1000_SdOO7a1KP7uPAmy9--
