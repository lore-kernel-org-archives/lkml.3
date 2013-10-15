Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758885Ab3JOLvx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 07:51:53 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:48338 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758116Ab3JOLvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 07:51:51 -0400
Date: Tue, 15 Oct 2013 06:51:36 -0500
From: Felipe Balbi <balbi@ti.com>
To: George Cherian <george.cherian@ti.com>
CC: <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <tony@atomide.com>, <balbi@ti.com>, <kishon@ti.com>, <rob@landley.net>,
        <ijc+devicetree@hellion.org.uk>, <swarren@wwwdotorg.org>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>,
        <rob.herring@calxeda.com>, <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 2/2] phy: omap-usb2: Adapt phy-omap-usb2 for AM437x
Message-ID: <20131015115136.GB11380@radagast>
Reply-To: <balbi@ti.com>
References: <1381820025-31376-1-git-send-email-george.cherian@ti.com>
 <1381820025-31376-3-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SkvwRMAIpAhPCcCJ"
Content-Disposition: inline
In-Reply-To: <1381820025-31376-3-git-send-email-george.cherian@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--SkvwRMAIpAhPCcCJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Oct 15, 2013 at 12:23:45PM +0530, George Cherian wrote:
> This patch adds a compatible for AM437x "ti,am43xx-usb2" to
> reuse the same phy-omap-usb2 driver.

it does more than just adding a new compatible flag.

> diff --git a/drivers/phy/phy-omap-usb2.c b/drivers/phy/phy-omap-usb2.c
> index 3e5f08c..7c0bc6c 100644
> --- a/drivers/phy/phy-omap-usb2.c
> +++ b/drivers/phy/phy-omap-usb2.c
> @@ -144,6 +144,35 @@ static struct phy_ops ops =3D {
>  	.owner		=3D THIS_MODULE,
>  };
> =20
> +#ifdef CONFIG_OF
> +static const struct usb_phy_data omap_usb2_data =3D {
> +	.label =3D "omap_usb2",
> +	.set_host =3D omap_usb_set_host,
> +	.set_peripheral =3D omap_usb_set_peripheral,
> +	.set_vbus =3D omap_usb_set_vbus,
> +	.start_srp =3D omap_usb_start_srp,
> +};
> +
> +static const struct usb_phy_data am437x_usb2_data =3D {
> +	.label =3D "am437x_usb2",
> +	.set_host =3D omap_usb_set_host,
> +	.set_peripheral =3D omap_usb_set_peripheral,
> +};
> +
> +static const struct of_device_id omap_usb2_id_table[] =3D {
> +	{
> +		.compatible =3D "ti,omap-usb2",
> +		.data =3D &omap_usb2_data,
> +	},
> +	{
> +		.compatible =3D "ti,am437x-usb2",
> +		.data =3D &am437x_usb2_data,
> +	},
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, omap_usb2_id_table);
> +#endif
> +
>  static int omap_usb2_probe(struct platform_device *pdev)
>  {
>  	struct omap_usb	*phy;
> @@ -153,9 +182,14 @@ static int omap_usb2_probe(struct platform_device *p=
dev)
>  	struct device_node *node =3D pdev->dev.of_node;
>  	struct device_node *control_node;
>  	struct platform_device *control_pdev;
> +	const struct of_device_id *of_id;
> +	struct usb_phy_data *phy_data;
> +
> +	of_id =3D of_match_device(of_match_ptr(omap_usb2_id_table), &pdev->dev);
> =20
> -	if (!node)
> +	if (!of_id)
>  		return -EINVAL;
> +	phy_data =3D (struct usb_phy_data *)of_id->data;
> =20
>  	phy =3D devm_kzalloc(&pdev->dev, sizeof(*phy), GFP_KERNEL);
>  	if (!phy) {
> @@ -172,7 +206,7 @@ static int omap_usb2_probe(struct platform_device *pd=
ev)
>  	phy->dev		=3D &pdev->dev;
> =20
>  	phy->phy.dev		=3D phy->dev;
> -	phy->phy.label		=3D "omap-usb2";
> +	phy->phy.label		=3D phy_data->label;

label can be set based on compatible flag:

if (of_device_is_compatible(node, "ti,omap-usb2"))
	phy->phy.label		=3D "omap-usb2";
else /* if (of_device_is_compatible(node, "ti,am437x-usb2")) */ /* default =
to newest */
	phy->phy.label		=3D "am437x-usb2";	/* keep name consistency */

>  	phy->phy.set_suspend	=3D omap_usb2_suspend;
>  	phy->phy.otg		=3D otg;
>  	phy->phy.type		=3D USB_PHY_TYPE_USB2;
> @@ -199,10 +233,10 @@ static int omap_usb2_probe(struct platform_device *=
pdev)
>  	phy->is_suspended	=3D 1;
>  	omap_control_usb_phy_power(phy->control_dev, 0);
> =20
> -	otg->set_host		=3D omap_usb_set_host;
> -	otg->set_peripheral	=3D omap_usb_set_peripheral;
> -	otg->set_vbus		=3D omap_usb_set_vbus;
> -	otg->start_srp		=3D omap_usb_start_srp;
> +	otg->set_host		=3D phy_data->set_host;
> +	otg->set_peripheral	=3D phy_data->set_peripheral;
> +	otg->set_vbus		=3D phy_data->set_vbus;
> +	otg->start_srp		=3D phy_data->start_srp;

this doesn't look right. I would rather have feature flags so that you
could:

if (test_bit(&phy_data->flags, OMAP_USB2_HAS_SRP))
	otg->start_srp =3D omap_usb_start_srp;

and so on. Note that you might need to add __maybe_unused annotations to
those functions otherwise you'll get unused warnings.

--=20
balbi

--SkvwRMAIpAhPCcCJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSXSxIAAoJEIaOsuA1yqRESpgQAKFiqCTF5cdYmAk752fKEBzv
xYdR/P79dVYeM1a2oGTJHqf6HK2hdWIOz7KI5n1wCI0KZ11V9a1AawAqJL1I13+L
VCtiEYZhZQSoYAdkVYQPPMrRaCPP9pAiaXdP+Td/nL1tmUkRaZcBvG8v8hi+hwQq
jmjXctuwCAbpLG4NbvdGWbuacyC/tZpRfY9mqgmlHyAhK5wEtvWllifMicQ4r6SF
qBol5PbTdy9HOt7o7Dh9ERNth3Jo5VJJJRTrrMtird01CT+H3uM/H3QIQ8KU1BvU
34U+xqo659ud4wTfATQl94Vvh0An5na/PMQTMf/u5bEeZDjCL2FfN0ErWLmpwXwr
xThwpEgOaF6giWJ2gJpeMquAx9ono2GCD3o/Tf3GAt0HVx+II6ro7aNyTvoGblqn
FlktTelROh/BTFRpoQC9qeT2nhweNjXd+Blm+jIWoI0nzhD3udBHY2mahXYZ+Yag
S+orm9Ma0NgVokfvmiig/hCUkG0q/iCE5vaNw8KXbFIIdhoIWSU7rAEZBBgV0/cb
a6gpnqum1PvW1CcEOmZltLRkiJbwVVGpI4bcNGzmuAujxrcaR+WykVzGa3tmeSbZ
yjosoRWuLH26Zrs9Y7vDRopD7jgJzANmAZCYBL+lPXA/ceY/dfv2MS8jXgoRL6Nf
7AHqzXkWdovXAxxuVM5z
=YVKe
-----END PGP SIGNATURE-----

--SkvwRMAIpAhPCcCJ--
