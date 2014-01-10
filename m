Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757365AbaAJK5Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 05:57:16 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:58105 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751784AbaAJK5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 05:57:13 -0500
Message-ID: <52CFD1ED.7010302@ti.com>
Date: Fri, 10 Jan 2014 12:56:45 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
CC: <plagnioj@jcrosoft.com>, <pali.rohar@gmail.com>, <pavel@ucw.cz>,
        <linux-omap@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Ivaylo Dimitrov <freemangordon@abv.bg>,
        Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: Re: [PATCH v2] ARM: OMAPFB: panel-sony-acx565akm: fix missing mutex
 unlocks
References: <52C956E9.2030008@gmail.com> <1388927585-5640-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
In-Reply-To: <1388927585-5640-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="hGUr26wdwvi5DJNTqgJ7Gb9md9jKG8pXR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--hGUr26wdwvi5DJNTqgJ7Gb9md9jKG8pXR
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2014-01-05 15:13, Ivaylo Dimitrov wrote:
> From: Ivaylo Dimitrov <freemangordon@abv.bg>
>=20
> Commit c37dd677988ca50bc8bc60ab5ab053720583c168 fixes the unbalanced
> unlock in acx565akm_enable but introduces another problem - if
> acx565akm_panel_power_on exits early, the mutex is not unlocked. Fix
> that by unlocking the mutex on early return. Also add mutex protection =
in
> acx565akm_panel_power_off and remove an unused variable
>=20

I think this is just getting more messy. How about we more or less revert=
 the c37dd677988ca50bc8bc60ab5ab053720583c168 and fix it like this:


diff --git a/drivers/video/omap2/displays-new/panel-sony-acx565akm.c b/dr=
ivers/video/omap2/displays-new/panel-sony-acx565akm.c
index 714ee92dfb9f..8e97d06921ff 100644
--- a/drivers/video/omap2/displays-new/panel-sony-acx565akm.c
+++ b/drivers/video/omap2/displays-new/panel-sony-acx565akm.c
@@ -346,28 +346,22 @@ static int acx565akm_get_actual_brightness(struct p=
anel_drv_data *ddata)
 static int acx565akm_bl_update_status(struct backlight_device *dev)
 {
 	struct panel_drv_data *ddata =3D dev_get_drvdata(&dev->dev);
-	int r;
 	int level;
=20
 	dev_dbg(&ddata->spi->dev, "%s\n", __func__);
=20
-	mutex_lock(&ddata->mutex);
-
 	if (dev->props.fb_blank =3D=3D FB_BLANK_UNBLANK &&
 			dev->props.power =3D=3D FB_BLANK_UNBLANK)
 		level =3D dev->props.brightness;
 	else
 		level =3D 0;
=20
-	r =3D 0;
 	if (ddata->has_bc)
 		acx565akm_set_brightness(ddata, level);
 	else
-		r =3D -ENODEV;
-
-	mutex_unlock(&ddata->mutex);
+		return -ENODEV;
=20
-	return r;
+	return 0;
 }
=20
 static int acx565akm_bl_get_intensity(struct backlight_device *dev)
@@ -390,9 +384,33 @@ static int acx565akm_bl_get_intensity(struct backlig=
ht_device *dev)
 	return 0;
 }
=20
+static int acx565akm_bl_update_status_locked(struct backlight_device *de=
v)
+{
+	struct panel_drv_data *ddata =3D dev_get_drvdata(&dev->dev);
+	int r;
+
+	mutex_lock(&ddata->mutex);
+	r =3D acx565akm_bl_update_status(dev);
+	mutex_unlock(&ddata->mutex);
+
+	return r;
+}
+
+static int acx565akm_bl_get_intensity_locked(struct backlight_device *de=
v)
+{
+	struct panel_drv_data *ddata =3D dev_get_drvdata(&dev->dev);
+	int r;
+
+	mutex_lock(&ddata->mutex);
+	r =3D acx565akm_bl_get_intensity(dev);
+	mutex_unlock(&ddata->mutex);
+
+	return r;
+}
+
 static const struct backlight_ops acx565akm_bl_ops =3D {
-	.get_brightness =3D acx565akm_bl_get_intensity,
-	.update_status  =3D acx565akm_bl_update_status,
+	.get_brightness =3D acx565akm_bl_get_intensity_locked,
+	.update_status  =3D acx565akm_bl_update_status_locked,
 };
=20
 /*--------------------Auto Brightness control via Sysfs-----------------=
----*/
@@ -526,8 +544,6 @@ static int acx565akm_panel_power_on(struct omap_dss_d=
evice *dssdev)
 	struct omap_dss_device *in =3D ddata->in;
 	int r;
=20
-	mutex_lock(&ddata->mutex);
-
 	dev_dbg(&ddata->spi->dev, "%s\n", __func__);
=20
 	in->ops.sdi->set_timings(in, &ddata->videomode);
@@ -568,8 +584,6 @@ static int acx565akm_panel_power_on(struct omap_dss_d=
evice *dssdev)
 	set_display_state(ddata, 1);
 	set_cabc_mode(ddata, ddata->cabc_mode);
=20
-	mutex_unlock(&ddata->mutex);
-
 	return acx565akm_bl_update_status(ddata->bl_dev);
 }
=20
@@ -605,6 +619,7 @@ static void acx565akm_panel_power_off(struct omap_dss=
_device *dssdev)
=20
 static int acx565akm_enable(struct omap_dss_device *dssdev)
 {
+	struct panel_drv_data *ddata =3D to_panel_data(dssdev);
 	int r;
=20
 	dev_dbg(dssdev->dev, "%s\n", __func__);
@@ -615,7 +630,9 @@ static int acx565akm_enable(struct omap_dss_device *d=
ssdev)
 	if (omapdss_device_is_enabled(dssdev))
 		return 0;
=20
+	mutex_lock(&ddata->mutex);
 	r =3D acx565akm_panel_power_on(dssdev);
+	mutex_unlock(&ddata->mutex);
 	if (r)
 		return r;
=20



--hGUr26wdwvi5DJNTqgJ7Gb9md9jKG8pXR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSz9HxAAoJEPo9qoy8lh71yaIQAIurETL+FVc1/l8dFy/XtSpQ
FSrnY4J+GqF3CYYddCHzwXwO8yJCJop3rsW1+kGfR7+t9DEZhM8i00VbfDhW7ifj
zKmeKbfEUhcxfjlXj4UICKmJrBDR/IRXG6T44dGAI7LVtPzVwfH33nqxaMj/FhKE
uhiO4zBtZ/llm4d3dt+CFDBtyM+4Z+7dLrvf/lO6S95z6oPZW9jTUhS3zgmwKAFm
WcSjkEsXCu+4t9DeLxUQEMAPh+RPb0vPzgSP4E9jo8BXljbgZzXplC52CXusx9ht
bdkCnQf2lubki6TZu56KP4i1dVeWAcwfHkw7aP5z1CsCxl3Wgli94FyMBNpMtnB7
yUhAst7zZzLRYyqMkkwiO6s485N30sEtdH+5WkY9HJ2o9uOuRpNfQa604hp9FWaW
tPBC1LERYdPBtMVnXyvZD2a+CjIiIiP5oHeemPypflSQX4mUO11SF6lARs38OHik
NU4sn+kY9cIchvbV4sw64VMLzALfzhzXVh8ppJve7ZTwIR0f/8oDpv2vzpMqz2PL
UC5S94voTsq8XQi3Sb0spu1X42pVnwW/g9saEzWLbTyWpZe3/QADgb5w0AQ8PpVZ
BDjpIfj+1SVJP+ThkPfemeAXgBVp7Tnb0yBPMWgS5MvkkbHr9oQZFZQIRNP6opLI
bRD6WQRxrLNep9XfEU1G
=8KUK
-----END PGP SIGNATURE-----

--hGUr26wdwvi5DJNTqgJ7Gb9md9jKG8pXR--
