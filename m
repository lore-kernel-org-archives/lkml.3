Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab3IWC3M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 22:29:12 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:50446 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023Ab3IWC3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 22:29:09 -0400
Date: Mon, 23 Sep 2013 12:28:56 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jingoo Han <jg1.han@samsung.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org
Subject: linux-next: manual merge of the omap_dss2 tree with the fbdev tree
Message-Id: <20130923122856.0a3dbf72a44dfef1238d7a1c@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__23_Sep_2013_12_28_56_+1000_aoHLZ.OH/kjfJaJ="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__23_Sep_2013_12_28_56_+1000_aoHLZ.OH/kjfJaJ=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tomi,

Today's linux-next merge of the omap_dss2 tree got a conflict in
drivers/video/atmel_lcdfb.c between commits a17c2e7b704f ("video:
atmel_lcdfb: fix platform data struct") and 5e8be022fb5b ("video:
atmel_lcdfb: add device tree suport") from the fbdev tree and commit
a5d58be0796a ("video: atmel_lcdfb: use dev_get_platdata()") from the
omap_dss2 tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/video/atmel_lcdfb.c
index bf9c5d0,df05550..0000000
--- a/drivers/video/atmel_lcdfb.c
+++ b/drivers/video/atmel_lcdfb.c
@@@ -1157,30 -934,19 +1157,30 @@@ static int __init atmel_lcdfb_probe(str
  	}
 =20
  	sinfo =3D info->par;
 +	sinfo->pdev =3D pdev;
 +	sinfo->info =3D info;
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
 +	INIT_LIST_HEAD(&info->modelist);
 +
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

--Signature=_Mon__23_Sep_2013_12_28_56_+1000_aoHLZ.OH/kjfJaJ=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBCAAGBQJSP6dtAAoJEECxmPOUX5FEAzUP/2UURG6Q8bxflQQKj6Dx+1Qd
UyuEcnnxoYoGtthuWVYlnhM/eysu+0qIAdkjKhv48LEZaAh5NoaceihJvq+62+Th
03i4x8hvtmCafM8CflctR5j4Az2D3BpOCW2rlTm0JXxdPXil6Y9I4WvivPgBJGdL
kE4vsdIXBKO3MX6cjbf5nM3tS9BXxPQj9RXebIAb8WCSjAZruKDd/JpskWdRslVB
3QWPoncBjiRU+yUEbVlJdJaIfmaCECOjfthJc3EWoe3eJ6cOtyXKIaYB02jho5gF
6Ch3D7rZp9TNLEcC6O2MkXVgZGbT5XjnzYtWbL2PRz75WwUSxYHDhAHd9OthF0lw
fEHqv8aPp8EgyfYIUOdgQ5UXvChTsNw92yrE/AUoVQF7XpiwLpgQMThc1gLAzCAA
Xu5ueyxkv93rY+cwuBhDTyqz68lQOjDJiuWs3N3iBjEOptoolS3vL3uVNIBT//Fl
FdKE5yBUxuOcIEe34Kr2CVhktkhEEiA/Z2Wlrbe619dnl3V5X2+qTFoBw4YfJuxy
P7PlbfkPijmuQWOrr0yseFbordDBbItWjHEJeL1Y4bgvUQXN1WOgol4/EiVlPkeZ
IGHawyIHQWefI1t2i/olBgI00Ryh1WUsKCDlkf38nuYYRtThqN1edn8JhOswYvnq
W3j68c2y2lsVKryrrUAq
=Wxz2
-----END PGP SIGNATURE-----

--Signature=_Mon__23_Sep_2013_12_28_56_+1000_aoHLZ.OH/kjfJaJ=--
