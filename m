Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbaJQOxK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 10:53:10 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:49342 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752343AbaJQOxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 10:53:08 -0400
Date: Fri, 17 Oct 2014 09:52:52 -0500
From: Felipe Balbi <balbi@ti.com>
To: Huang Rui <ray.huang@amd.com>
CC: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Vincent Wan <vincent.wan@amd.com>, Tony Li <tony.li@amd.com>,
        <linux-usb@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 09/16] usb: dwc3: add P3 in U2 SS inactive quirk
Message-ID: <20141017145252.GE26260@saruman>
Reply-To: <balbi@ti.com>
References: <1413536021-4886-1-git-send-email-ray.huang@amd.com>
 <1413536021-4886-10-git-send-email-ray.huang@amd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xA/XKXTdy9G3iaIz"
Content-Disposition: inline
In-Reply-To: <1413536021-4886-10-git-send-email-ray.huang@amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--xA/XKXTdy9G3iaIz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 17, 2014 at 04:53:34PM +0800, Huang Rui wrote:
> AMD NL needs to enable P3 OK for U2/SSInactive on USB3PIPE register.
>=20
> Signed-off-by: Huang Rui <ray.huang@amd.com>
> ---
>  drivers/usb/dwc3/core.c          | 20 ++++++++++++++++++++
>  drivers/usb/dwc3/core.h          |  1 +
>  drivers/usb/dwc3/dwc3-pci.c      |  3 ++-
>  drivers/usb/dwc3/platform_data.h |  1 +
>  4 files changed, 24 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> index 7322d85..9d0a249 100644
> --- a/drivers/usb/dwc3/core.c
> +++ b/drivers/usb/dwc3/core.c
> @@ -365,6 +365,24 @@ static void dwc3_cache_hwparams(struct dwc3 *dwc)
>  }
> =20
>  /**
> + * dwc3_phy_setup - Configure USB3 PHY Interface of DWC3 Core
> + * @dwc: Pointer to our controller context structure
> + */
> +static void dwc3_phy_setup(struct dwc3 *dwc)
> +{
> +	u32 reg;
> +
> +	reg =3D dwc3_readl(dwc->regs, DWC3_GUSB3PIPECTL(0));
> +
> +	if (dwc->quirks & DWC3_QUIRK_U2SSINP3OK)

	if (dwc->p3_ok_on_ss_inactive_quirk)

> +		reg |=3D DWC3_GUSB3PIPECTL_U2SSINP3OK;
> +
> +	dwc3_writel(dwc->regs, DWC3_GUSB3PIPECTL(0), reg);
> +
> +	mdelay(100);
> +}
> +
> +/**
>   * dwc3_core_init - Low-level initialization of DWC3 Core
>   * @dwc: Pointer to our controller context structure
>   *
> @@ -484,6 +502,8 @@ static int dwc3_core_init(struct dwc3 *dwc)
> =20
>  	dwc3_writel(dwc->regs, DWC3_GCTL, reg);
> =20
> +	dwc3_phy_setup(dwc);
> +
>  	ret =3D dwc3_alloc_scratch_buffers(dwc);
>  	if (ret)
>  		goto err1;
> diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
> index 3d27f10..71cb255 100644
> --- a/drivers/usb/dwc3/core.h
> +++ b/drivers/usb/dwc3/core.h
> @@ -176,6 +176,7 @@
> =20
>  /* Global USB3 PIPE Control Register */
>  #define DWC3_GUSB3PIPECTL_PHYSOFTRST	(1 << 31)
> +#define DWC3_GUSB3PIPECTL_U2SSINP3OK	(1 << 29)
>  #define DWC3_GUSB3PIPECTL_SUSPHY	(1 << 17)
> =20
>  /* Global TX Fifo Size Register */
> diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
> index cdb9b04..1235eb3 100644
> --- a/drivers/usb/dwc3/dwc3-pci.c
> +++ b/drivers/usb/dwc3/dwc3-pci.c
> @@ -150,7 +150,8 @@ static int dwc3_pci_probe(struct pci_dev *pci,
>  			PCI_DEVICE_ID_AMD_NL) {
>  		dwc3_pdata.has_lpm_erratum =3D true;
>  		dwc3_pdata.quirks |=3D DWC3_QUIRK_AMD_NL
> -			| DWC3_QUIRK_U2EXIT_LFPS;
> +			| DWC3_QUIRK_U2EXIT_LFPS
> +			| DWC3_QUIRK_U2SSINP3OK;
>  	}

again to be combined in a single patch as the last patch in the series.

--=20
balbi

--xA/XKXTdy9G3iaIz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUQS1EAAoJEIaOsuA1yqRExVsP+QFhwzIgYM/EzeLzFlLdU04H
fU0OsqzXhRZHplMQwOUEnG2n3KzeRMKZ43dpnYCjGiFjqZRC452xwFGgUcA1x4pW
3eNhETResGIiIZCc4v419XRbC+AyJqWcttKJaapPg7YvDYdM7uT1DKd1/9Spwk5k
5829lk9pf4doZBHMt7QTyrc/yM9EoTKdBWb98nvwOi6E79sIE69clOtt9XRQ8SUW
Q88yQvcdC+j2bV8/CoukZAXVk6MnVwD6YnyzJLB/9UvORkhLa+CpWSLPMjo2J8hy
wYte4OIgqoGAnSmjkot4SdOU2flz0p3mUa/cWW1FTpo5J7p5TgUsGVYooZHXxwpA
1awdnj1sFiJKi1jzkUhfGtv57H2q7a+qD1hzggziuc+p+9rXuzGG/v9Au0KQfw4M
vueGyZfpAbXAwWJFYyQeU8PS7eId7yIvqH7rHcPQ4TPIEutXVyzOBQHfH0LaSe62
Qc2g7RziudQ8rG5E6MWlknCzGYDnwfm2n/L5xpYBFtaGj/DuOm5ammOOMrQYy+U/
AzxIr2IsruwlY2SyEoG0z6eOfF0ZnNr+kCjWlfC0u5QjVkYkxP23hOxB2mGPGw3a
qvBNua/5DVxDhO80cGkbCSugZnpR4xkcKlbYh3jbvPhWnXi3GtGtBjrIYcbG/FY3
oUOlxFC2ET6iHr9rpWQX
=D4Ed
-----END PGP SIGNATURE-----

--xA/XKXTdy9G3iaIz--
