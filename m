Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911AbaIAN2d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 09:28:33 -0400
Received: from mga14.intel.com ([192.55.52.115]:19175 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998AbaIAN2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 09:28:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,442,1406617200"; 
   d="asc'?scan'208";a="474423072"
Message-ID: <1409578107.12004.20.camel@intelbox>
Subject: Re: [Intel-gfx] [drm/i915/3.17] panic in i915_digport_work_func
From: Imre Deak <imre.deak@intel.com>
Reply-To: imre.deak@intel.com
To: Dave Airlie <airlied@gmail.com>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@redhat.com>,
        "Nikula, Jani" <jani.nikula@intel.com>
Date: Mon, 01 Sep 2014 16:28:27 +0300
In-Reply-To: <CAPM=9txZ5mS3u-7FrjCMF6T3sATfAU2Y+fpyXi-REPWXExBajA@mail.gmail.com>
References: <1409382202.5141.36.camel@marge.simpson.net>
	 <1409486735.4991.19.camel@marge.simpson.net>
	 <CAPM=9txZ5mS3u-7FrjCMF6T3sATfAU2Y+fpyXi-REPWXExBajA@mail.gmail.com>
Organization: Intel
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-uqpYONArwHgBHZAVZTlD"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-uqpYONArwHgBHZAVZTlD
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2014-09-01 at 17:02 +1000, Dave Airlie wrote:
> From: Dave Airlie <airlied@redhat.com>
> Date: Mon, 1 Sep 2014 16:58:12 +1000
> Subject: [PATCH] drm/i915: handle G45/GM45 pulse detection connected
> state.
>=20
> In the HPD pulse handler we check for long pulses if the port is
> actually
> connected, however we do that for IBX, but we use the pulse handling
> code on
> GM45 systems as well, so we need to use a diffent check.
>=20
> This patch refactors the digital port connected check out of the g4x
> detection
> path and reuses it in the hpd pulse path.
>=20
> Should fix:
> Message-ID: <1409382202.5141.36.camel@marge.simpson.net>
>=20
> Reported-by: Mike Galbraith <umgwanakikbuti@gmail.com>
> Signed-off-by: Dave Airlie <airlied@redhat.com>

Daniel reviewed this already, but Jani asked me to take a look, so:
Acked-by: Imre Deak <imre.deak@intel.com>

One thing for the future is to move ibx_digital_port_connected() to
intel_dp.c too and make its return value match that of
g4x_digital_port_connected().

--Imre

> ---
>  drivers/gpu/drm/i915/intel_dp.c | 55
> +++++++++++++++++++++++++++--------------
>  1 file changed, 37 insertions(+), 18 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/i915/intel_dp.c
> b/drivers/gpu/drm/i915/intel_dp.c
> index 67cfed6..81d7681 100644
> --- a/drivers/gpu/drm/i915/intel_dp.c
> +++ b/drivers/gpu/drm/i915/intel_dp.c
> @@ -3661,24 +3661,12 @@ ironlake_dp_detect(struct intel_dp *intel_dp)
>         return intel_dp_detect_dpcd(intel_dp);
>  }
> =20
> -static enum drm_connector_status
> -g4x_dp_detect(struct intel_dp *intel_dp)
> +static int g4x_digital_port_connected(struct drm_device *dev,
> +                                      struct intel_digital_port
> *intel_dig_port)
>  {
> -       struct drm_device *dev =3D intel_dp_to_dev(intel_dp);
>         struct drm_i915_private *dev_priv =3D dev->dev_private;
> -       struct intel_digital_port *intel_dig_port =3D
> dp_to_dig_port(intel_dp);
>         uint32_t bit;
> =20
> -       /* Can't disconnect eDP, but you can close the lid... */
> -       if (is_edp(intel_dp)) {
> -               enum drm_connector_status status;
> -
> -               status =3D intel_panel_detect(dev);
> -               if (status =3D=3D connector_status_unknown)
> -                       status =3D connector_status_connected;
> -               return status;
> -       }
> -
>         if (IS_VALLEYVIEW(dev)) {
>                 switch (intel_dig_port->port) {
>                 case PORT_B:
> @@ -3691,7 +3679,7 @@ g4x_dp_detect(struct intel_dp *intel_dp)
>                         bit =3D PORTD_HOTPLUG_LIVE_STATUS_VLV;
>                         break;
>                 default:
> -                       return connector_status_unknown;
> +                       return -EINVAL;
>                 }
>         } else {
>                 switch (intel_dig_port->port) {
> @@ -3705,11 +3693,36 @@ g4x_dp_detect(struct intel_dp *intel_dp)
>                         bit =3D PORTD_HOTPLUG_LIVE_STATUS_G4X;
>                         break;
>                 default:
> -                       return connector_status_unknown;
> +                       return -EINVAL;
>                 }
>         }
> =20
>         if ((I915_READ(PORT_HOTPLUG_STAT) & bit) =3D=3D 0)
> +               return 0;
> +       return 1;
> +}
> +
> +static enum drm_connector_status
> +g4x_dp_detect(struct intel_dp *intel_dp)
> +{
> +       struct drm_device *dev =3D intel_dp_to_dev(intel_dp);
> +       struct intel_digital_port *intel_dig_port =3D
> dp_to_dig_port(intel_dp);
> +       int ret;
> +
> +       /* Can't disconnect eDP, but you can close the lid... */
> +       if (is_edp(intel_dp)) {
> +               enum drm_connector_status status;
> +
> +               status =3D intel_panel_detect(dev);
> +               if (status =3D=3D connector_status_unknown)
> +                       status =3D connector_status_connected;
> +               return status;
> +       }
> +
> +       ret =3D g4x_digital_port_connected(dev, intel_dig_port);
> +       if (ret =3D=3D -EINVAL)
> +               return connector_status_unknown;
> +       else if (ret =3D=3D 0)
>                 return connector_status_disconnected;
> =20
>         return intel_dp_detect_dpcd(intel_dp);
> @@ -4066,8 +4079,14 @@ intel_dp_hpd_pulse(struct intel_digital_port
> *intel_dig_port, bool long_hpd)
>         intel_display_power_get(dev_priv, power_domain);
> =20
>         if (long_hpd) {
> -               if (!ibx_digital_port_connected(dev_priv,
> intel_dig_port))
> -                       goto mst_fail;
> +
> +               if (HAS_PCH_SPLIT(dev)) {
> +                       if (!ibx_digital_port_connected(dev_priv,
> intel_dig_port))
> +                               goto mst_fail;
> +               } else {
> +                       if (g4x_digital_port_connected(dev,
> intel_dig_port) !=3D 1)
> +                               goto mst_fail;
> +               }
> =20
>                 if (!intel_dp_get_dpcd(intel_dp)) {
>                         goto mst_fail;


--=-uqpYONArwHgBHZAVZTlD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQEcBAABAgAGBQJUBHR7AAoJEORIIAnNuWDFPQkIALKQASdhYXO3xLuz2ivuHE7K
HKTFce6vmFjimYL/EyvJP7Km5rw3sBSEJKXl9/3rxUPkupqGbGFnQImja4pQAP+J
Ab4GKWVay99RID+u7QMUpS0O/29efizO78pcurap6G4poKiXYtiY3w81ne6C2MUr
2Kf1fZBc7WEmRZQf68MU8fYyT3no+XjOGsbHBk+u6slus9KQbtneEhj7ljMifqcv
p0wfD6CwKQ9lRYeStkWiZssoHIUu6fAk2kHpm/PymO2wAA6SWn35S8IggjsgIArs
Y7PppZJfULnM1ldw3KEIJXZNzEvOTNVCViL9UvNaXIehZjLZVmE55GeafhKpxYQ=
=sWE7
-----END PGP SIGNATURE-----

--=-uqpYONArwHgBHZAVZTlD--

