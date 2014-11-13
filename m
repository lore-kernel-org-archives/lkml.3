Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932715AbaKMLwe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 06:52:34 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:45177 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932329AbaKMLwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 06:52:31 -0500
Message-ID: <54649B43.1000801@ti.com>
Date: Thu, 13 Nov 2014 13:51:31 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Marek Belisko <marek@goldelico.com>
CC: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <bcousson@baylibre.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <plagnioj@jcrosoft.com>, <grant.likely@linaro.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-fbdev@vger.kernel.org>, <hns@goldelico.com>,
        <gta04-owner@goldelico.com>
Subject: Re: [PATCH v2 1/5] video: omapdss: Add opa362 driver
References: <1415830247-31633-1-git-send-email-marek@goldelico.com> <1415830247-31633-2-git-send-email-marek@goldelico.com>
In-Reply-To: <1415830247-31633-2-git-send-email-marek@goldelico.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="PRMatdQC2VUWXWuJrwRcKb0R0pGETr3fh"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--PRMatdQC2VUWXWuJrwRcKb0R0pGETr3fh
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 13/11/14 00:10, Marek Belisko wrote:
> opa362 is amplifier for video and can be connected to the tvout pads
> of the OMAP3. It has one gpio control for enable/disable of the output
> (high impedance).
>=20
> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
> ---
>  drivers/video/fbdev/omap2/displays-new/Kconfig     |   6 +
>  drivers/video/fbdev/omap2/displays-new/Makefile    |   1 +
>  .../fbdev/omap2/displays-new/amplifier-opa362.c    | 343 +++++++++++++=
++++++++

I think it would be better to rename this to encoder-opa362.c. It's not
encoder as such, but it falls into the same category.

>  include/video/omap-panel-data.h                    |  12 +
>  4 files changed, 362 insertions(+)
>  create mode 100644 drivers/video/fbdev/omap2/displays-new/amplifier-op=
a362.c
>=20
> diff --git a/drivers/video/fbdev/omap2/displays-new/Kconfig b/drivers/v=
ideo/fbdev/omap2/displays-new/Kconfig
> index e6cfc38..211b3ec 100644
> --- a/drivers/video/fbdev/omap2/displays-new/Kconfig
> +++ b/drivers/video/fbdev/omap2/displays-new/Kconfig
> @@ -1,6 +1,12 @@
>  menu "OMAP Display Device Drivers (new device model)"
>          depends on OMAP2_DSS
> =20
> +config DISPLAY_AMPLIFIER_OPA362

Here also use ENCODER instead.

> +        tristate "external analog amplifier with output disable/high-Z=
 (e.g. OPA362)"
> +	help
> +	  Driver to enable an external analog TV amplifier (e.g. OPA362)
> +	  through a GPIO.

The indentation above seems funny.

The text looks a bit odd. So is this a driver for OPA362, or is this a
generic driver for any similar devices? Most of the names and code makes
me think this is a driver for OPA362, but the text above quite clearly
gives the impression that this is a driver for any analog video amp,
with single enable gpio.

> +
>  config DISPLAY_ENCODER_TFP410
>          tristate "TFP410 DPI to DVI Encoder"
>  	help
> diff --git a/drivers/video/fbdev/omap2/displays-new/Makefile b/drivers/=
video/fbdev/omap2/displays-new/Makefile
> index 0323a8a..b311542 100644
> --- a/drivers/video/fbdev/omap2/displays-new/Makefile
> +++ b/drivers/video/fbdev/omap2/displays-new/Makefile
> @@ -1,3 +1,4 @@
> +obj-$(CONFIG_DISPLAY_AMPLIFIER_OPA362) +=3D amplifier-opa362.o
>  obj-$(CONFIG_DISPLAY_ENCODER_TFP410) +=3D encoder-tfp410.o
>  obj-$(CONFIG_DISPLAY_ENCODER_TPD12S015) +=3D encoder-tpd12s015.o
>  obj-$(CONFIG_DISPLAY_CONNECTOR_DVI) +=3D connector-dvi.o
> diff --git a/drivers/video/fbdev/omap2/displays-new/amplifier-opa362.c =
b/drivers/video/fbdev/omap2/displays-new/amplifier-opa362.c
> new file mode 100644
> index 0000000..8065a28
> --- /dev/null
> +++ b/drivers/video/fbdev/omap2/displays-new/amplifier-opa362.c
> @@ -0,0 +1,343 @@
> +/*
> + * OPA362 analog video amplifier with output/power control
> + *
> + * Copyright (C) 2014 Golden Delicious Computers
> + * Author: H. Nikolaus Schaller <hns@goldelico.com>
> + *
> + * based on encoder-tfp410
> + *
> + * Copyright (C) 2013 Texas Instruments
> + * Author: Tomi Valkeinen <tomi.valkeinen@ti.com>
> + *
> + * This program is free software; you can redistribute it and/or modif=
y it
> + * under the terms of the GNU General Public License version 2 as publ=
ished by
> + * the Free Software Foundation.
> + */
> +
> +#include <linux/gpio.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include <linux/of_gpio.h>
> +
> +#include <video/omapdss.h>
> +#include <video/omap-panel-data.h>
> +
> +struct panel_drv_data {
> +	struct omap_dss_device dssdev;
> +	struct omap_dss_device *in;
> +
> +	int enable_gpio;
> +
> +	struct omap_video_timings timings;
> +};
> +
> +#define to_panel_data(x) container_of(x, struct panel_drv_data, dssdev=
)
> +
> +static int opa362_connect(struct omap_dss_device *dssdev,
> +		struct omap_dss_device *dst)
> +{
> +	struct panel_drv_data *ddata =3D to_panel_data(dssdev);
> +	struct omap_dss_device *in =3D ddata->in;
> +	int r;
> +
> +	dev_dbg(dssdev->dev, "connect\n");
> +
> +	if (omapdss_device_is_connected(dssdev))
> +		return -EBUSY;
> +
> +	r =3D in->ops.atv->connect(in, dssdev);
> +	if (r)
> +		return r;
> +
> +	dst->src =3D dssdev;
> +	dssdev->dst =3D dst;
> +
> +	return 0;
> +}
> +
> +static void opa362_disconnect(struct omap_dss_device *dssdev,
> +		struct omap_dss_device *dst)
> +{
> +	struct panel_drv_data *ddata =3D to_panel_data(dssdev);
> +	struct omap_dss_device *in =3D ddata->in;
> +
> +	dev_dbg(dssdev->dev, "disconnect\n");
> +
> +	WARN_ON(!omapdss_device_is_connected(dssdev));
> +	if (!omapdss_device_is_connected(dssdev))
> +		return;
> +
> +	WARN_ON(dst !=3D dssdev->dst);
> +	if (dst !=3D dssdev->dst)
> +		return;
> +
> +	dst->src =3D NULL;
> +	dssdev->dst =3D NULL;
> +
> +	in->ops.atv->disconnect(in, &ddata->dssdev);
> +}
> +
> +static int opa362_enable(struct omap_dss_device *dssdev)
> +{
> +	struct panel_drv_data *ddata =3D to_panel_data(dssdev);
> +	struct omap_dss_device *in =3D ddata->in;
> +	int r;
> +
> +	dev_dbg(dssdev->dev, "enable\n");
> +
> +	if (!omapdss_device_is_connected(dssdev))
> +		return -ENODEV;
> +
> +	if (omapdss_device_is_enabled(dssdev))
> +		return 0;
> +
> +	in->ops.atv->set_timings(in, &ddata->timings);
> +	/* fixme: should we receive the invert from our consumer, i.e. the co=
nnector? */
> +	in->ops.atv->invert_vid_out_polarity(in, true);

Well this does seem to be broken. I don't know what the answer to the
question above is, but the code doesn't work properly.

In the opa362_invert_vid_out_polarity function below, you get the invert
boolean from the connector. This you pass to the OMAP venc. However,
above you always override that value in venc with true.

So, either the invert_vid_out_polarity value has to be always true or
false, because _OPA362_ requires it to be true or false, OR you need use
the value from the connector.

Seeing the comment in opa362_invert_vid_out_polarity, my guess is the
latter, and the call above should be removed.

> +
> +	r =3D in->ops.atv->enable(in);
> +	if (r)
> +		return r;
> +
> +	if (gpio_is_valid(ddata->enable_gpio))
> +		gpio_set_value_cansleep(ddata->enable_gpio, 1);
> +
> +	dssdev->state =3D OMAP_DSS_DISPLAY_ACTIVE;
> +
> +	return 0;
> +}
> +
> +static void opa362_disable(struct omap_dss_device *dssdev)
> +{
> +	struct panel_drv_data *ddata =3D to_panel_data(dssdev);
> +	struct omap_dss_device *in =3D ddata->in;
> +
> +	dev_dbg(dssdev->dev, "disable\n");
> +
> +	if (!omapdss_device_is_enabled(dssdev))
> +		return;
> +
> +	if (gpio_is_valid(ddata->enable_gpio))
> +		gpio_set_value_cansleep(ddata->enable_gpio, 0);
> +
> +	in->ops.atv->disable(in);
> +
> +	dssdev->state =3D OMAP_DSS_DISPLAY_DISABLED;
> +}
> +
> +static void opa362_set_timings(struct omap_dss_device *dssdev,
> +		struct omap_video_timings *timings)
> +{
> +	struct panel_drv_data *ddata =3D to_panel_data(dssdev);
> +	struct omap_dss_device *in =3D ddata->in;
> +
> +	dev_dbg(dssdev->dev, "set_timings\n");
> +
> +	ddata->timings =3D *timings;
> +	dssdev->panel.timings =3D *timings;
> +
> +	in->ops.atv->set_timings(in, timings);
> +}
> +
> +static void opa362_get_timings(struct omap_dss_device *dssdev,
> +		struct omap_video_timings *timings)
> +{
> +	struct panel_drv_data *ddata =3D to_panel_data(dssdev);
> +
> +	dev_dbg(dssdev->dev, "get_timings\n");
> +
> +	*timings =3D ddata->timings;
> +}
> +
> +static int opa362_check_timings(struct omap_dss_device *dssdev,
> +		struct omap_video_timings *timings)
> +{
> +	struct panel_drv_data *ddata =3D to_panel_data(dssdev);
> +	struct omap_dss_device *in =3D ddata->in;
> +
> +	dev_dbg(dssdev->dev, "check_timings\n");
> +
> +	return in->ops.atv->check_timings(in, timings);
> +}
> +
> +static void opa362_set_type(struct omap_dss_device *dssdev,
> +		enum omap_dss_venc_type type)
> +{
> +	/* we can only drive a COMPOSITE output */
> +	WARN_ON(type !=3D OMAP_DSS_VENC_TYPE_COMPOSITE);
> +
> +}
> +
> +static void opa362_invert_vid_out_polarity(struct omap_dss_device *dss=
dev,
> +		bool invert_polarity)
> +{
> +	struct panel_drv_data *ddata =3D to_panel_data(dssdev);
> +	struct omap_dss_device *in =3D ddata->in;
> +
> +	/* OPA362 inverts the polarity */
> +	in->ops.atv->invert_vid_out_polarity(in, !invert_polarity);
> +}
> +
> +static const struct omapdss_atv_ops opa362_atv_ops =3D {
> +	.connect	=3D opa362_connect,
> +	.disconnect	=3D opa362_disconnect,
> +
> +	.enable		=3D opa362_enable,
> +	.disable	=3D opa362_disable,
> +
> +	.check_timings	=3D opa362_check_timings,
> +	.set_timings	=3D opa362_set_timings,
> +	.get_timings	=3D opa362_get_timings,
> +
> +	.set_type	=3D opa362_set_type,
> +	.invert_vid_out_polarity	=3D opa362_invert_vid_out_polarity,
> +};
> +
> +static int opa362_probe_pdata(struct platform_device *pdev)
> +{
> +	struct panel_drv_data *ddata =3D platform_get_drvdata(pdev);
> +	struct amplifier_opa362_platform_data *pdata;
> +	struct omap_dss_device *dssdev, *in;
> +
> +	pdata =3D dev_get_platdata(&pdev->dev);
> +
> +	ddata->enable_gpio =3D pdata->enable_gpio;
> +
> +	in =3D omap_dss_find_output(pdata->source);
> +	if (in =3D=3D NULL) {
> +		dev_err(&pdev->dev, "Failed to find video source\n");
> +		return -ENODEV;
> +	}
> +
> +	ddata->in =3D in;
> +
> +	dssdev =3D &ddata->dssdev;
> +	dssdev->name =3D pdata->name;
> +
> +	return 0;
> +}

We are going to support only DT boot at some point. Thus I think the
whole platform data code should be left out.

> +
> +static int opa362_probe_of(struct platform_device *pdev)
> +{
> +	struct panel_drv_data *ddata =3D platform_get_drvdata(pdev);
> +	struct device_node *node =3D pdev->dev.of_node;
> +	struct omap_dss_device *in;
> +	int gpio;
> +
> +	gpio =3D of_get_gpio(node, 0);
> +
> +	if (gpio_is_valid(gpio) || gpio =3D=3D -ENOENT) {
> +		ddata->enable_gpio =3D gpio;
> +	} else {
> +		dev_err(&pdev->dev, "failed to parse enable gpio\n");
> +		return gpio;
> +	}

You should use the new GPIO API to get full support from the DT data.
For an example, see panel-dpi.c's enable_gpio.

 Tomi



--PRMatdQC2VUWXWuJrwRcKb0R0pGETr3fh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUZJtDAAoJEPo9qoy8lh71HXMQALFntRIGyvQHIgtOhC6rrk+f
wit5rFD/T+90MYPuGf0sfryc0GXRoJwP8ynmvPU/kTdPNxELOhzPsscznyctgLHg
oZeFnuSN4mF9yJ3Yazr7yuDsZSNWiY9DrfTkO+eQ6cI83EnBTZZ4bcfoBCcDUpCo
Ik3eC5AOg1O7urRS6bUD7KikJ2jckBS0pbXv+lg2m/C5SU4Ofux788+n/BnOtt3G
uFjscF0KxBnPBKvzV60G/8i2RtIw88qXKDwTH+KcDrhAwd15PQF2cT5H+1MhdQ4Z
/OfYx/RAFUnO8nPAvbWaGFHSFFl0LaRXXcq+h54CPHvddx6547eN5s6v0g0/SJR/
v5SbXIKujELQ5BXHcJ3/IHc73Qrj7scMRI/AdgjsyQRoaEVxkfi1+9H6TYiQW+p4
jYyWsUb54j60n6nuwUlahrKyHEz5ZHCUtv+WdWXbWRttZU/ft8F7gFYxjxMITgFE
VwUHIL2OcAGYCwi7Y9dJI+Ph1jRegwxwHh9qte3ETsgqPQEobqwQRmSAHtNggNxO
dvpP6bWpvXheMXTgd13ocvQyFvyrS5l1RNdGSGdXXO3cFF58TkIaUZNpELB78R8K
/1/qNGeFlW1dov7n9Z6m4BoZYrh+GMuZ+blzq2wgAfLCNK6aRwMocjV/XGpzvS0s
hWoWyRDHxlmPZ0NlqoE5
=ud+i
-----END PGP SIGNATURE-----

--PRMatdQC2VUWXWuJrwRcKb0R0pGETr3fh--
