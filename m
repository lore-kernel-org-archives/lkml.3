Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933875AbaCTPdG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 11:33:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:52624 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932796AbaCTPdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 11:33:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,695,1389772800"; 
   d="asc'?scan'208";a="476464243"
Message-ID: <1395329443.17233.10.camel@intelbox>
Subject: Re: [PATCH v4 1/1] drm/i915: Enabling 128x128 and 256x256 ARGB
 Cursor Support
From: Imre Deak <imre.deak@intel.com>
Reply-To: imre.deak@intel.com
To: sagar.a.kamble@intel.com
Cc: intel-gfx@lists.freedesktop.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        "G, Pallavi" <pallavi.g@intel.com>
Date: Thu, 20 Mar 2014 17:30:43 +0200
In-Reply-To: <1394451383-27133-1-git-send-email-sagar.a.kamble@intel.com>
References: <20140310100321.GA30571@phenom.ffwll.local>
	 <1394451383-27133-1-git-send-email-sagar.a.kamble@intel.com>
Organization: Intel
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-/ACFEWok3TtdNIMe5z5u"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-/ACFEWok3TtdNIMe5z5u
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2014-03-10 at 17:06 +0530, sagar.a.kamble@intel.com wrote:
> From: Sagar Kamble <sagar.a.kamble@intel.com>
>=20
> With this patch we allow larger cursor planes of sizes 128x128
> and 256x256.
>=20
> v2: Added more precise check on size while setting cursor plane.
>=20
> v3: Changes related to restructuring cursor size restrictions
> and DRM_DEBUG usage.
>=20
> v4: Indentation related changes for setting cursor control and
> implementing DRM_CAP_CURSOR_WIDTH and DRM_CAP_CURSOR_HEIGHT
>=20
> Testcase: igt/kms_cursor_crc
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: Jani Nikula <jani.nikula@linux.intel.com>
> Cc: David Airlie <airlied@linux.ie>
> Cc: dri-devel@lists.freedesktop.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: G, Pallavi <pallavi.g@intel.com>
> Signed-off-by: Sagar Kamble <sagar.a.kamble@intel.com>

Looks ok:
Reviewed-by: Imre Deak <imre.deak@intel.com>

> ---
>  drivers/gpu/drm/i915/i915_reg.h      |  4 +++
>  drivers/gpu/drm/i915/intel_display.c | 53 ++++++++++++++++++++++++++++++=
++----
>  drivers/gpu/drm/i915/intel_drv.h     |  7 +++++
>  3 files changed, 59 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_=
reg.h
> index 146609a..aee8258 100644
> --- a/drivers/gpu/drm/i915/i915_reg.h
> +++ b/drivers/gpu/drm/i915/i915_reg.h
> @@ -3551,7 +3551,11 @@ enum punit_power_well {
>  /* New style CUR*CNTR flags */
>  #define   CURSOR_MODE		0x27
>  #define   CURSOR_MODE_DISABLE   0x00
> +#define   CURSOR_MODE_128_32B_AX 0x02
> +#define   CURSOR_MODE_256_32B_AX 0x03
>  #define   CURSOR_MODE_64_32B_AX 0x07
> +#define   CURSOR_MODE_128_ARGB_AX ((1 << 5) | CURSOR_MODE_128_32B_AX)
> +#define   CURSOR_MODE_256_ARGB_AX ((1 << 5) | CURSOR_MODE_256_32B_AX)
>  #define   CURSOR_MODE_64_ARGB_AX ((1 << 5) | CURSOR_MODE_64_32B_AX)
>  #define   MCURSOR_PIPE_SELECT	(1 << 28)
>  #define   MCURSOR_PIPE_A	0x00
> diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/=
intel_display.c
> index 0868afb..ec6a073 100644
> --- a/drivers/gpu/drm/i915/intel_display.c
> +++ b/drivers/gpu/drm/i915/intel_display.c
> @@ -7440,10 +7440,26 @@ static void i9xx_update_cursor(struct drm_crtc *c=
rtc, u32 base)
>  	bool visible =3D base !=3D 0;
> =20
>  	if (intel_crtc->cursor_visible !=3D visible) {
> +		int16_t width =3D intel_crtc->cursor_width;
>  		uint32_t cntl =3D I915_READ(CURCNTR(pipe));
>  		if (base) {
>  			cntl &=3D ~(CURSOR_MODE | MCURSOR_PIPE_SELECT);
> -			cntl |=3D CURSOR_MODE_64_ARGB_AX | MCURSOR_GAMMA_ENABLE;
> +			cntl |=3D MCURSOR_GAMMA_ENABLE;
> +
> +			switch (width) {
> +			case 64:
> +				cntl |=3D CURSOR_MODE_64_ARGB_AX;
> +				break;
> +			case 128:
> +				cntl |=3D CURSOR_MODE_128_ARGB_AX;
> +				break;
> +			case 256:
> +				cntl |=3D CURSOR_MODE_256_ARGB_AX;
> +				break;
> +			default:
> +				WARN_ON(1);
> +				return;
> +			}
>  			cntl |=3D pipe << 28; /* Connect to correct pipe */
>  		} else {
>  			cntl &=3D ~(CURSOR_MODE | MCURSOR_GAMMA_ENABLE);
> @@ -7468,10 +7484,25 @@ static void ivb_update_cursor(struct drm_crtc *cr=
tc, u32 base)
>  	bool visible =3D base !=3D 0;
> =20
>  	if (intel_crtc->cursor_visible !=3D visible) {
> +		int16_t width =3D intel_crtc->cursor_width;
>  		uint32_t cntl =3D I915_READ(CURCNTR_IVB(pipe));
>  		if (base) {
>  			cntl &=3D ~CURSOR_MODE;
> -			cntl |=3D CURSOR_MODE_64_ARGB_AX | MCURSOR_GAMMA_ENABLE;
> +			cntl |=3D MCURSOR_GAMMA_ENABLE;
> +			switch (width) {
> +			case 64:
> +				cntl |=3D CURSOR_MODE_64_ARGB_AX;
> +				break;
> +			case 128:
> +				cntl |=3D CURSOR_MODE_128_ARGB_AX;
> +				break;
> +			case 256:
> +				cntl |=3D CURSOR_MODE_256_ARGB_AX;
> +				break;
> +			default:
> +				WARN_ON(1);
> +				return;
> +			}
>  		} else {
>  			cntl &=3D ~(CURSOR_MODE | MCURSOR_GAMMA_ENABLE);
>  			cntl |=3D CURSOR_MODE_DISABLE;
> @@ -7567,9 +7598,11 @@ static int intel_crtc_cursor_set(struct drm_crtc *=
crtc,
>  		goto finish;
>  	}
> =20
> -	/* Currently we only support 64x64 cursors */
> -	if (width !=3D 64 || height !=3D 64) {
> -		DRM_ERROR("we currently only support 64x64 cursors\n");
> +	/* Check for which cursor types we support */
> +	if (!((width =3D=3D 64 && height =3D=3D 64) ||
> +			(width =3D=3D 128 && height =3D=3D 128 && !IS_GEN2(dev)) ||
> +			(width =3D=3D 256 && height =3D=3D 256 && !IS_GEN2(dev)))) {
> +		DRM_DEBUG("Cursor dimension not supported\n");
>  		return -EINVAL;
>  	}
> =20
> @@ -10331,6 +10364,16 @@ static void intel_crtc_init(struct drm_device *d=
ev, int pipe)
> =20
>  	drm_crtc_init(dev, &intel_crtc->base, &intel_crtc_funcs);
> =20
> +	if (IS_GEN2(dev)) {
> +		intel_crtc->max_cursor_width =3D GEN2_CURSOR_WIDTH;
> +		intel_crtc->max_cursor_height =3D GEN2_CURSOR_HEIGHT;
> +	} else {
> +		intel_crtc->max_cursor_width =3D CURSOR_WIDTH;
> +		intel_crtc->max_cursor_height =3D CURSOR_HEIGHT;
> +	}
> +	dev->mode_config.cursor_width =3D intel_crtc->max_cursor_width;
> +	dev->mode_config.cursor_height =3D intel_crtc->max_cursor_height;
> +
>  	drm_mode_crtc_set_gamma_size(&intel_crtc->base, 256);
>  	for (i =3D 0; i < 256; i++) {
>  		intel_crtc->lut_r[i] =3D i;
> diff --git a/drivers/gpu/drm/i915/intel_drv.h b/drivers/gpu/drm/i915/inte=
l_drv.h
> index 9c70905..eca4a0a 100644
> --- a/drivers/gpu/drm/i915/intel_drv.h
> +++ b/drivers/gpu/drm/i915/intel_drv.h
> @@ -78,6 +78,12 @@
>  #define MAX_OUTPUTS 6
>  /* maximum connectors per crtcs in the mode set */
> =20
> +/* Maximum cursor sizes */
> +#define GEN2_CURSOR_WIDTH 64
> +#define GEN2_CURSOR_HEIGHT 64
> +#define CURSOR_WIDTH 256
> +#define CURSOR_HEIGHT 256
> +
>  #define INTEL_I2C_BUS_DVO 1
>  #define INTEL_I2C_BUS_SDVO 2
> =20
> @@ -364,6 +370,7 @@ struct intel_crtc {
>  	uint32_t cursor_addr;
>  	int16_t cursor_x, cursor_y;
>  	int16_t cursor_width, cursor_height;
> +	int16_t max_cursor_width, max_cursor_height;
>  	bool cursor_visible;
> =20
>  	struct intel_crtc_config config;


--=-/ACFEWok3TtdNIMe5z5u
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQEcBAABAgAGBQJTKwmjAAoJEORIIAnNuWDFH/wH/1LGUlujmKeP4D0b/OtDizpL
oYdt0EwG1XjKgKHpbLiCGoh1eR0MriB7jO6BHFPud0UHCYXDhjEbGMBVXtGIAbYV
QiA9q5P3GvUY4D44EHqY8VWU6YM055KZkj4/aVCIp28bpZxVoourKzmuC3NHlaTl
nWib8WQtv1unaQqOvNH8B9mIBSc+lLSjXkXRnJ6kUpkX/pnGCfOQcHSH+qEy3f5q
p8HtzUdWSD/348rvcIqb4wo63BM7N/1eYhgQt4kYCz1AuO4V/R2cuE7q4xyN6Le0
7fWo/cfYJWxyr/QpOuRLYVoA2cRUE7GskDXHr48rzqW/HJJOaLvR3DmcVhhxr90=
=JrDe
-----END PGP SIGNATURE-----

--=-/ACFEWok3TtdNIMe5z5u--

