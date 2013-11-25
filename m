Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361Ab3KYVWR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 16:22:17 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:49925 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869Ab3KYVWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 16:22:14 -0500
Date: Mon, 25 Nov 2013 15:21:01 -0600
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <bcousson@baylibre.com>, <balbi@ti.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <rob.herring@calxeda.com>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ijc+devicetree@hellion.org.uk>, <rob@landley.net>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>, <gregkh@linuxfoundation.org>,
        <grant.likely@linaro.org>, <s.nawrocki@samsung.com>,
        <galak@codeaurora.org>
Subject: Re: [PATCH v3 04/10] usb: dwc3: use quirks to know if a particualr
 platform doesn't have PHY
Message-ID: <20131125212101.GR18046@saruman.home>
Reply-To: <balbi@ti.com>
References: <1385373690-12170-1-git-send-email-kishon@ti.com>
 <1385373690-12170-5-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hdoY8pikdvrkIRAT"
Content-Disposition: inline
In-Reply-To: <1385373690-12170-5-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--hdoY8pikdvrkIRAT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 25, 2013 at 03:31:24PM +0530, Kishon Vijay Abraham I wrote:
> There can be systems which does not have an external phy, so get
> phy only if no quirks are added that indicates the PHY is not present.
> Introduced two quirk flags to indicate the *absence* of usb2 phy and
> usb3 phy. Also remove checking if return value is -ENXIO since it's now
> changed to always enable usb_phy layer.
>=20
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  drivers/usb/dwc3/Kconfig         |    1 +
>  drivers/usb/dwc3/core.c          |   93 ++++++++++++++++++++------------=
------
>  drivers/usb/dwc3/core.h          |   15 ++++++
>  drivers/usb/dwc3/platform_data.h |    5 ++
>  4 files changed, 69 insertions(+), 45 deletions(-)
>=20
> diff --git a/drivers/usb/dwc3/Kconfig b/drivers/usb/dwc3/Kconfig
> index 70fc430..8e385b4 100644
> --- a/drivers/usb/dwc3/Kconfig
> +++ b/drivers/usb/dwc3/Kconfig
> @@ -1,6 +1,7 @@
>  config USB_DWC3
>  	tristate "DesignWare USB3 DRD Core Support"
>  	depends on (USB || USB_GADGET) && HAS_DMA
> +	select USB_PHY

no more selects, we've already had too many problems caused by bogus
usage of select.

> diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> index 986674f..f20f4a1 100644
> --- a/drivers/usb/dwc3/core.c
> +++ b/drivers/usb/dwc3/core.c
> @@ -32,6 +32,7 @@
>  #include <linux/delay.h>
>  #include <linux/dma-mapping.h>
>  #include <linux/of.h>
> +#include <linux/of_device.h>
> =20
>  #include <linux/usb/ch9.h>
>  #include <linux/usb/gadget.h>
> @@ -351,13 +352,28 @@ static void dwc3_core_exit(struct dwc3 *dwc)
> =20
>  #define DWC3_ALIGN_MASK		(16 - 1)
> =20
> +#ifdef CONFIG_OF
> +static const struct of_device_id of_dwc3_match[] =3D {
> +	{
> +		.compatible =3D "snps,dwc3"
> +	},
> +	{
> +		.compatible =3D "synopsys,dwc3"
> +	},
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(of, of_dwc3_match);
> +#endif
> +

you can split this patch a little bit just to make it easier to review
because there are a few changes which are really obvious:

a) move of_device_id higher in source code so you can use it from probe.
	while at that, aso use of_match_device() and return early if it
	doesn't match anything.

b) introduce struct dwc3_data.

c) initialize of_id->data field.

d) start using struct dwc3_data

this will make to put all obvious changes (a-c) in separate patches so
review can focus on (d).

--=20
balbi

--hdoY8pikdvrkIRAT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSk789AAoJEIaOsuA1yqREUA4QAKJ5mdE8Hv9U3G/Uwaood3de
RZRxtYtpd1hAJWNcRKRN8JhnZ4FsQnjsTOTT6AiWXlNuprgUtcText9xoK0YX9RD
m/D7peeSwXWvC5OwEkXJfDgi6GhqFya2nyLAyx/WZAM7buHXiW3S1ffOr3RP5MkX
loTIZzzjssHZN9/3lAdqAUKmwLpfu+b9P1sl6zF4i83cFWZWiin81dSryM9Eg2CP
S30q5VsT8n6HCOEv8At5JV3SxgSOZgtc5pv7EE4loBzUhLgb/LdaXTHfzXBRPPux
plJ+DVVzdKIrI4eO9StGfUytIQM/DDfGq76wIvwFSfnsopmJ5+ZFR50uxf4nS5Mn
+vpxkVC00uDgBzMLegGdahqOcYNyRA5fSYMClLi1VRe0bfDg7JipAll+VkzV/iZI
WUcxta96WctOH0SbtwC8vqSDkHGiERt+E3OWLpkBZiUeCrLrooXqspJHyGt0Ws+J
Nrzvy55Oc3/t/khbzJLrEeUJqVv3Dh8UcyEkPM9clRfrZtQJ2D01AgZAMC9ry07x
RTs+Aelj2IzgZKtXINJXey4bCglk71h8okVCPK7vxdJNhEQlB/YOCRWwZuq9/84i
G6Jk9PDDrqQ/KnVzalOoXOG/Es+vycXyd2A9DqB+IZRgocPBKR/cOkru6sQB7ogf
h9/lh5qS/k/TZwcyohE2
=X7UI
-----END PGP SIGNATURE-----

--hdoY8pikdvrkIRAT--
