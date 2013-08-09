Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967646Ab3HINYL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 09:24:11 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:40075 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966645Ab3HINYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 09:24:08 -0400
Date: Fri, 9 Aug 2013 16:23:49 +0300
From: Felipe Balbi <balbi@ti.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: <balbi@ti.com>, <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ian.campbell@citrix.com>, <rob@landley.net>,
        <gregkh@linuxfoundation.org>, <grant.likely@linaro.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [RFC 2/2] usb: dwc3: Add Qualcomm DWC3 glue layer driver
Message-ID: <20130809132349.GC12041@radagast>
Reply-To: <balbi@ti.com>
References: <1375789991-30041-1-git-send-email-iivanov@mm-sol.com>
 <1375789991-30041-3-git-send-email-iivanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sHrvAb52M6C8blB9"
Content-Disposition: inline
In-Reply-To: <1375789991-30041-3-git-send-email-iivanov@mm-sol.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--sHrvAb52M6C8blB9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Aug 06, 2013 at 02:53:11PM +0300, Ivan T. Ivanov wrote:
> diff --git a/drivers/usb/dwc3/dwc3-msm.c b/drivers/usb/dwc3/dwc3-msm.c
> new file mode 100644
> index 0000000..e509abc
> --- /dev/null
> +++ b/drivers/usb/dwc3/dwc3-msm.c
> @@ -0,0 +1,175 @@
> +#undef CONFIG_REGULATOR

why ??????

> +static int dwc3_msm_probe(struct platform_device *pdev)
> +{
> +	struct device_node *node =3D pdev->dev.of_node;
> +	struct dwc3_msm *mdwc;
> +	struct resource *res;
> +	void __iomem *tcsr;
> +	int ret =3D 0;
> +
> +	dev_info(&pdev->dev, "MSM DWC3\n");

please don't. This is hardly necessary.

> +	mdwc =3D devm_kzalloc(&pdev->dev, sizeof(*mdwc), GFP_KERNEL);
> +	if (!mdwc) {
> +		dev_err(&pdev->dev, "not enough memory\n");

this message isn't needed either

> +	/*
> +	 * DWC3 Core requires its CORE CLK (aka master / bus clk) to
> +	 * run at 125Mhz in SSUSB mode and >60MHZ for HSUSB mode.
> +	 */
> +	clk_set_rate(mdwc->core_clk, 125000000);

if this is dwc3's core clock, why don't we teach dwc3.ko about this
requirement ? Just make sure to have it optional, since x86 and OMAP
wouldn't need direct fiddling with the clocks.

> +	clk_prepare_enable(mdwc->core_clk);
> +	clk_prepare_enable(mdwc->iface_clk);
> +	clk_prepare_enable(mdwc->sleep_clk);
> +	clk_prepare_enable(mdwc->utmi_clk);

do you really need to enable your clocks here ? Why don't you enable
them on runtime_resume and disable on runtime_suspend ?

> +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	tcsr =3D devm_ioremap_resource(&pdev->dev, res);
> +	if (!tcsr) {
> +		dev_dbg(&pdev->dev, "tcsr ioremap failed\n");

no need to ioremap, also you're likely leaking clocks and regulators
enabled here.

Make sure to have something like:

	if (!tcsr)
		goto err_disable_clocks;

	/* TODO This has to be revised */\

	[...]

> +	} else {
> +		/* TODO: This has to be revised */
> +
> +		/* Enable USB3 on the primary USB port. */
> +		writel_relaxed(0x1, tcsr);
> +		/*
> +		 * Ensure that TCSR write is completed before
> +		 * USB registers initialization.
> +		 */
> +		mb();

why don't you use writel() instead. It will add the memory barrier for
you.

--=20
balbi

--sHrvAb52M6C8blB9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSBO1lAAoJEIaOsuA1yqRElAwP/iaRFtjQxSosL4XQPDRdyvRS
YQ82mdk+7vG8rX9jqAJXmEWIFrEaxamuqZ6kMMh+xzEludsXHsSSJnUhntNybCnY
9MFKNac7MoT7m7FA5bTXecye/1VE46Z0YimvMiUT/leWXRIn+zgzBWc3B3bJ7v0s
HoUwLbK0wKsUxmGp5WyI1bCt731ge0l8nEtEBi3egkODs/K9xBo/JkoS4KOr0SkJ
0lvcvu+3O4zy5fqGlKfVSf7XAZuQjTMqn/qBmBvMOklEzlfxuXA322garVNXSVt0
KCs0LwDulSWvQsdDNgeetlC+nB92K2jgyGq/iPVupzeVCWuxkPpUMYl5oqOjceR4
qCYapyS1GhO0zbPlIcqHNPO1N9Q3UM5mVy+KC9QcHE0b1mZwX6NApSysuAt4KRzf
n288O7vKZpKmsDVp0iX0RGrb91Z+UAGXRh9jjuJExP6WYXVJiuufpzP0MpzO3iti
/YNpolUrMykHRRFDzx4MJSMicM6LDUy0XMgDCiKfRW0OSzGLZ+J83i7JvkY+7HLj
zOD0a0aygzYWAIQGRzbdljItff25ehLg43ww+o/UTiIDzMeW6Ef9D24iEe3wVUtD
eFTfycFRVXMDH87Fm7sEL6af4IU8m8mMkgYqfuqjLnq/C2rbA7JviyjGZeSu6q9R
jXHo1Wiq0u2LhTeBC1ph
=8LTb
-----END PGP SIGNATURE-----

--sHrvAb52M6C8blB9--
