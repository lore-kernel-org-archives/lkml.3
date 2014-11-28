Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751174AbaK1TO6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 14:14:58 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:62594 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbaK1TO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 14:14:57 -0500
Message-ID: <5478C9AA.2010600@aurabindo.in>
Date: Sat, 29 Nov 2014 00:44:50 +0530
From: Jay Aurabind <mail@aurabindo.in>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Daniel Vetter <daniel.vetter@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drm/i915 Trouble with minimum brightness
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="rLUDWnHnMt3VodhugFehGRhl9sThpXsuB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--rLUDWnHnMt3VodhugFehGRhl9sThpXsuB
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hello all,

I notice that some activity has been going on with the minimum value of d=
isplay brightness recently (e1c412e7575).

But the minimum value thats currently chosen is not at all acceptable for=
 my eyes. My display is working perfectly without that restriction on min=
imum intensity.
I tend to stare at the screen a lot and the current minimum settings is s=
training my eyes.

Even if you say that it may not be good for the devices, I still insist, =
because I want my *display* to fail first, not my eyes.
So please try providing a way for the needy users to override this minimu=
m settings. I hope adding a module parameter would be easy fix.

Something like this: ? (I dont call myself a kernel programmer yet, just =
scratching the surface)


Provide provision for users to disable restriction on minimum brightness
value introduced in:

    commit e1c412e75754ab7b7002f3e18a2652d999c40d4b
    Author: Jani Nikula <jani.nikula@intel.com>
    Date:   Wed Nov 5 14:46:31 2014 +0200

        drm/i915: safeguard against too high minimum brightness

There are systems which work reliably without restriction on minimum
value of display brightness. Also the arbitrary value may be too high
for many users as well.

Signed-off-by: Aurabindo J <mail@aurabindo.in>
---
 drivers/gpu/drm/i915/i915_drv.h    |  1 +
 drivers/gpu/drm/i915/i915_params.c |  6 ++++++
 drivers/gpu/drm/i915/intel_panel.c | 14 ++++++++++----
 3 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_=
drv.h
index 16a6f6d..55d2ead 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -2213,6 +2213,7 @@ struct i915_params {
 	int disable_power_well;
 	int enable_ips;
 	int invert_brightness;
+	int restrict_min_brightness;
 	int enable_cmd_parser;
 	/* leave bools at the end to not create holes */
 	bool enable_hangcheck;
diff --git a/drivers/gpu/drm/i915/i915_params.c b/drivers/gpu/drm/i915/i9=
15_params.c
index c91cb20..0601c2a 100644
--- a/drivers/gpu/drm/i915/i915_params.c
+++ b/drivers/gpu/drm/i915/i915_params.c
@@ -46,6 +46,7 @@ struct i915_params i915 __read_mostly =3D {
 	.prefault_disable =3D 0,
 	.reset =3D true,
 	.invert_brightness =3D 0,
+	.restrict_min_brightness =3D 1,
 	.disable_display =3D 0,
 	.enable_cmd_parser =3D 1,
 	.disable_vtd_wa =3D 0,
@@ -155,6 +156,11 @@ MODULE_PARM_DESC(invert_brightness,
 	"to dri-devel@lists.freedesktop.org, if your machine needs it. "
 	"It will then be included in an upcoming module version.");

+module_param_named(restrict_min_brightness, i915.restrict_min_brightness=
, int, 0600);
+MODULE_PARM_DESC(restrict_min_brightness,
+	"Restrict minimum brightness "
+	"(-1 disable restriction, 0 value from VBT, 1 arbitrary value )");
+
 module_param_named(disable_display, i915.disable_display, bool, 0600);
 MODULE_PARM_DESC(disable_display, "Disable display (default: false)");

diff --git a/drivers/gpu/drm/i915/intel_panel.c b/drivers/gpu/drm/i915/in=
tel_panel.c
index 41b3be2..def9f4e 100644
--- a/drivers/gpu/drm/i915/intel_panel.c
+++ b/drivers/gpu/drm/i915/intel_panel.c
@@ -1109,10 +1109,16 @@ static u32 get_backlight_min_vbt(struct intel_con=
nector *connector)
 	 * against this by letting the minimum be at most (arbitrarily chosen)
 	 * 25% of the max.
 	 */
-	min =3D clamp_t(int, dev_priv->vbt.backlight.min_brightness, 0, 64);
-	if (min !=3D dev_priv->vbt.backlight.min_brightness) {
-		DRM_DEBUG_KMS("clamping VBT min backlight %d/255 to %d/255\n",
-			      dev_priv->vbt.backlight.min_brightness, min);
+	if (i915.restrict_min_brightness < 0)
+		min =3D 0;
+	else if (i915.restrict_min_brightness =3D=3D 0)
+		min =3D dev_priv->vbt.backlight.min_brightness;
+	else {
+		min =3D clamp_t(int, dev_priv->vbt.backlight.min_brightness, 0, 64);
+		if (min !=3D dev_priv->vbt.backlight.min_brightness) {
+			DRM_DEBUG_KMS("clamping VBT min backlight %d/255 to %d/255\n",
+					dev_priv->vbt.backlight.min_brightness, min);
+	    }
 	}

 	/* vbt value is a coefficient in range [0..255] */
--=20
2.1.3






--rLUDWnHnMt3VodhugFehGRhl9sThpXsuB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iF4EAREIAAYFAlR4yaoACgkQq5pl9aLRKAW87QD/RXneizYGBfSZ5kr1NwyhYVlV
UrBxS+Y+SbLJ20p3cJEA/Rw7tD69/giK3yYTsuygbQ7k9GSiaAZOOvLuluZqEbw6
=8Pkt
-----END PGP SIGNATURE-----

--rLUDWnHnMt3VodhugFehGRhl9sThpXsuB--
