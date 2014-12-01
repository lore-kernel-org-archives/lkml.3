Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090AbaLAPnG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 10:43:06 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:52727 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877AbaLAPnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 10:43:04 -0500
Date: Mon, 1 Dec 2014 16:42:58 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>
Subject: Re: [PATCH v4 1/3] drm: add bus_formats and num_bus_formats fields
 to drm_display_info
Message-ID: <20141201154257.GD11943@ulmo.nvidia.com>
References: <1417422061-10384-1-git-send-email-boris.brezillon@free-electrons.com>
 <1417422061-10384-6-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eqp4TxRxnD4KrmFZ"
Content-Disposition: inline
In-Reply-To: <1417422061-10384-6-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eqp4TxRxnD4KrmFZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 01, 2014 at 09:20:59AM +0100, Boris Brezillon wrote:
> Add bus_formats and num_bus_formats fields and
> drm_display_info_set_bus_formats helper function to specify the bus
> formats supported by a given display.
>=20
> This information can be used by display controller drivers to configure
> the output interface appropriately (i.e. RGB565, RGB666 or RGB888 on raw
> RGB or LVDS busses).
>=20
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> ---
>  drivers/gpu/drm/drm_crtc.c | 32 ++++++++++++++++++++++++++++++++
>  include/drm/drm_crtc.h     |  7 +++++++
>  2 files changed, 39 insertions(+)
>=20
> diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
> index e79c8d3..d3b7ed0 100644
> --- a/drivers/gpu/drm/drm_crtc.c
> +++ b/drivers/gpu/drm/drm_crtc.c
> @@ -763,6 +763,38 @@ static void drm_mode_remove(struct drm_connector *co=
nnector,
>  	drm_mode_destroy(connector->dev, mode);
>  }
> =20
> +/*

This needs a /** marker to make it a valid kerneldoc comment.

> + * drm_display_info_set_bus_formats - set the supported bus formats
> + * @info: display info to store bus formats in
> + * @fmts: array containing the supported bus formats
> + * @nfmts: the number of entries in the fmts array
> + *
> + * Store the suppported bus formats in display info structure.
> + * See MEDIA_BUS_FMT_* definitions in include/uapi/linux/media-bus-forma=
t.h for
> + * a full list of available formats.
> + */
> +int drm_display_info_set_bus_formats(struct drm_display_info *info, cons=
t u32 *fmts,

This one still exceeds 80-characters per line, but perhaps I'm reviewing
the wrong patch? Also I think fmts should be formats here.

> +				     unsigned int num_fmts)

And this should be num_formats, for consistency. Also make sure to keep
this consistent with the kerneldoc.

> +{
> +	u32 *formats =3D NULL;

If you name the parameter formats, maybe bus_formats would be a good
alternative for this local variable. Or fmts here. I think it's most
important that the public API gets the more idiomatic name.

> +
> +	if (!fmts && num_fmts)
> +		return -EINVAL;
> +
> +	if (fmts && num_fmts) {
> +		formats =3D kmemdup(fmts, sizeof(*fmts) * num_fmts, GFP_KERNEL);
> +		if (!formats)
> +			return -ENOMEM;
> +	}
> +
> +	kfree(info->bus_formats);
> +	info->bus_formats =3D formats;
> +	info->num_bus_formats =3D num_fmts;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(drm_display_info_set_bus_formats);

I think you'll want to call kfree() on the bus_formats array from
drm_connector_cleanup() as well to make sure you don't leak this on
driver unload.

Thierry

--eqp4TxRxnD4KrmFZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUfIyBAAoJEN0jrNd/PrOh34wQAIV6cdisHNK0PJx2+Io1LbwJ
vc0Yjmkcr3FJeMRGJZd57lA3kz4OWXozDIxZ/wXn4lMBVzNtVb5ooNrv3Xbhbfc/
AByj2b2LOmUlQ1ds42EPKLF0ZmNTJxpU3NUlYvQyoKNmZ9VEHjIUqxxNXV7OvoI8
3U20w3g+/DyWOHmQaL6SqMWfps1qM4UW7tx5QR4nTOeawTxSwTJxntwNv5iTgRnu
+kDkAxkpnrbwn7mmxoz6ZG60Cu7jdu6r1cjehnN79EzZYSigib0uYG4dXEcm8jvF
pbF49wUvirFIgbqA2ANYtZOKBr4+AezX1jsY/gjxxB+VIGVmdUC1fxBJxNMR6pmn
3Zg8I735NIxy5eZuBEjsSvjo46wkS5gQJTerPAA2Uk9ekc9PssoRulCDqDf6paDu
fIwnPpqZLRFaMSRmrLvPT7DDyxWevHNUqyRVL5SCLi+VPi52hfND5lguMWyN8TZD
mIGqY81aOGkhTY9Vi16vQTibcpcZklEs47SDsHjQ/IjfJJ9Bjh0fQn1Dw4J1nwtM
1yKlxO70ICyB0CKHjv4kDKsu3vcjbnEWP4oidhtdxMKbeO+OyWFBdAtexrmdubxn
HDWyV+X/ety7yCGfkA3PbHkVqstJhvDUVR2RO71xQDTsP/MB2NDB4txTmS3yvExQ
Cha36vddZUieeUxtKhq0
=NDYt
-----END PGP SIGNATURE-----

--eqp4TxRxnD4KrmFZ--
