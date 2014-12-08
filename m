Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115AbaLHNej (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 08:34:39 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:48621 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbaLHNeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 08:34:37 -0500
Date: Mon, 8 Dec 2014 14:34:33 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Hai Li <hali@codeaurora.org>
Cc: dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robdclark@gmail.com
Subject: Re: [PATCH 2/2] drm/msm: Add the eDP connector in msm drm driver
Message-ID: <20141208133431.GB13942@ulmo.nvidia.com>
References: <1417815001-9883-1-git-send-email-hali@codeaurora.org>
 <1417815001-9883-2-git-send-email-hali@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="St7VIuEGZ6dlpu13"
Content-Disposition: inline
In-Reply-To: <1417815001-9883-2-git-send-email-hali@codeaurora.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--St7VIuEGZ6dlpu13
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 05, 2014 at 04:30:01PM -0500, Hai Li wrote:
> Modified the hard-coded hdmi connector/encoder implementations in msm drm
> driver to support both edp and hdmi.

s/hdmi/HDMI/, s/msm/MSM/, s/drm/DRM/, s/edp/eDP/

[...]
> diff --git a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_encoder.c b/drivers/gpu/dr=
m/msm/mdp/mdp5/mdp5_encoder.c
[...]
> @@ -177,7 +180,28 @@ static void mdp5_encoder_mode_set(struct drm_encoder=
 *encoder,
>  	/* probably need to get DATA_EN polarity from panel.. */
> =20
>  	dtv_hsync_skew =3D 0;  /* get this from panel? */
> -	format =3D 0x213f;     /* get this from panel? */
> +
> +	/* Get color format from panel, default is 8bpc */
> +	list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
> +		if (connector->encoder =3D=3D encoder) {
> +			switch (connector->display_info.bpc) {
> +			case 4:
> +				format |=3D 0;
> +				break;
> +			case 5:
> +				format |=3D 0x15;
> +				break;
> +			case 6:
> +				format |=3D 0x2A;
> +				break;
> +			case 8:
> +			default:
> +				format |=3D 0x3F;
> +				break;
> +			}
> +			break;

I suppose that it might be obvious from the above switch statement, but
having symbolic names for the values of format might still be good for
readability.

> +		}
> +	}
> =20
>  	hsync_start_x =3D (mode->htotal - mode->hsync_start);
>  	hsync_end_x =3D mode->htotal - (mode->hsync_start - mode->hdisplay) - 1;
> @@ -187,6 +211,16 @@ static void mdp5_encoder_mode_set(struct drm_encoder=
 *encoder,
>  	display_v_start =3D (mode->vtotal - mode->vsync_start) * mode->htotal +=
 dtv_hsync_skew;
>  	display_v_end =3D vsync_period - ((mode->vsync_start - mode->vdisplay) =
* mode->htotal) + dtv_hsync_skew - 1;
> =20
> +	/*
> +	 * For edp only:
> +	 * DISPLAY_V_START =3D (VBP * HCYCLE) + HBP
> +	 * DISPLAY_V_END =3D (VBP + VACTIVE) * HCYCLE - 1 - HFP
> +	 */
> +	if (mdp5_encoder->intf_id =3D=3D INTF_eDP) {
> +		display_v_start +=3D (mode->htotal - mode->hsync_start);
> +		display_v_end -=3D (mode->hsync_start - mode->hdisplay);

No need for the parentheses.

> diff --git a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c b/drivers/gpu/drm/ms=
m/mdp/mdp5/mdp5_kms.c
[...]
>  	struct drm_device *dev =3D mdp5_kms->dev;
>  	struct msm_drm_private *priv =3D dev->dev_private;
> -	struct drm_encoder *encoder;
> +	struct drm_encoder *edp_encoder =3D NULL, *hdmi_encoder =3D NULL;

Can't you simply reuse encoder? It's scope is limited to the
conditionals, so no need to have two separate variables.

Thierry

--St7VIuEGZ6dlpu13
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUhajnAAoJEN0jrNd/PrOhcoQQAIIR4OKU8UGivjt1YXid1n2X
amUWTOAY96yiHt28uRMejwhqdCPvJV2Cd4huXeB2SEQF5EKrETK49MCaIRk2BgxA
px5kHWuuKEzu3AY5u9QNrBeyn4swtvENpQToHRxOuYDRRw4BjcZEV+aSkSUCSaRS
/oVOB5us0sb/Wrw+hNAT3aoUsiviGiMH0xkuwoIM4SD6hMUMszK9IjeDdmHbf9n9
44NfOAJI80XXql4Q/Fz84p728othYkh7kDTYvFnPLbDEGCV8nkbzhyxK9ZAC8eRv
b4orbywwtKPSCZ5YHUsTGDYZpaVaMr83ezGRpEvXfCKwqpSus+rACeS5GZv0woMd
9U3ciRCsxlweWgKCfBU/cJFRKWB1CR2KQ9zDQrepoPgUAPuNCsZ+CQjI0Eg4awxu
BgbyzWMQr8RvR4krgMt2CEUQwvQvdEThiQYXJ3pTfFLbKy7vNgQbMW7hU60bJacZ
SvXkD7rFeV/2FdxJkfiT1ikcc+GDBi/2PV3K4WNheVw1c/MeHNLBGDfExMj3o1Tv
EqVE474BLvI8U3D6eEWBhdfLUOAy+IRoByrr6ptQarrHEYYfO8vbLt5Y5CruGI6N
HlmvIl1Vg5ae9DRrqo5i4NHEy7Z9DWRv56LZbPq0pq/JCwt+/nznbFo1uFVPIGIQ
OujQBvFqVOqeO4aQhnID
=yJQN
-----END PGP SIGNATURE-----

--St7VIuEGZ6dlpu13--
