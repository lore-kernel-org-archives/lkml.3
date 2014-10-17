Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197AbaJQOpv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 10:45:51 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:57200 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846AbaJQOpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 10:45:50 -0400
Date: Fri, 17 Oct 2014 09:45:32 -0500
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
Subject: Re: [PATCH v2 06/16] usb: dwc3: add disscramble quirk
Message-ID: <20141017144532.GB26260@saruman>
Reply-To: <balbi@ti.com>
References: <1413536021-4886-1-git-send-email-ray.huang@amd.com>
 <1413536021-4886-7-git-send-email-ray.huang@amd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LyciRD1jyfeSSjG0"
Content-Disposition: inline
In-Reply-To: <1413536021-4886-7-git-send-email-ray.huang@amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--LyciRD1jyfeSSjG0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Oct 17, 2014 at 04:53:31PM +0800, Huang Rui wrote:
> AMD NL fpga needs to enable disscramble quirk. And this quirk doesn't nee=
d on
> the true soc.
>=20
> Signed-off-by: Huang Rui <ray.huang@amd.com>
> ---
>  drivers/usb/dwc3/core.c          | 8 +++++++-
>  drivers/usb/dwc3/dwc3-pci.c      | 5 +++++
>  drivers/usb/dwc3/platform_data.h | 4 ++++
>  3 files changed, 16 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> index 50c0eae..819e501 100644
> --- a/drivers/usb/dwc3/core.c
> +++ b/drivers/usb/dwc3/core.c
> @@ -422,7 +422,6 @@ static int dwc3_core_init(struct dwc3 *dwc)
> =20
>  	reg =3D dwc3_readl(dwc->regs, DWC3_GCTL);
>  	reg &=3D ~DWC3_GCTL_SCALEDOWN_MASK;
> -	reg &=3D ~DWC3_GCTL_DISSCRAMBLE;
> =20
>  	switch (DWC3_GHWPARAMS1_EN_PWROPT(dwc->hwparams.hwparams1)) {
>  	case DWC3_GHWPARAMS1_EN_PWROPT_CLK:
> @@ -461,6 +460,13 @@ static int dwc3_core_init(struct dwc3 *dwc)
>  		dwc->is_fpga =3D true;
>  	}
> =20
> +	if ((dwc->quirks & DWC3_QUIRK_AMD_NL) && dwc->is_fpga)
> +		dwc->quirks |=3D DWC3_QUIRK_DISSCRAMBLE;
> +
> +	if (dwc->quirks & DWC3_QUIRK_DISSCRAMBLE)

this should only be set if is_fpga, and this quirk should be a 1-bit
flag, so here's what you should do:

	WARN_ONCE(dwc->disable_scramble_quirk && !dwc->is_fpga,
		"disable_scramble cannot be used on non-FPGA builds\n");

	if (dwc->disable_scramble && dwc->is_fpga)
		reg |=3D DWC3_GCTL_DISSCRAMBLE;
	else
		reg &=3D ~DWC3_GCTL_DISSCRAMBLE;

> +		reg |=3D DWC3_GCTL_DISSCRAMBLE;
> +	else
> +		reg &=3D ~DWC3_GCTL_DISSCRAMBLE;

add a blank line here, to aid readability.

>  	/*
>  	 * WORKAROUND: DWC3 revisions <1.90a have a bug
>  	 * where the device can fail to connect at SuperSpeed
> diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
> index 18569a4..a89db6c 100644
> --- a/drivers/usb/dwc3/dwc3-pci.c
> +++ b/drivers/usb/dwc3/dwc3-pci.c
> @@ -146,6 +146,11 @@ static int dwc3_pci_probe(struct pci_dev *pci,
>  	res[1].name	=3D "dwc_usb3";
>  	res[1].flags	=3D IORESOURCE_IRQ;
> =20
> +	if (pci->vendor =3D=3D PCI_VENDOR_ID_AMD && pci->device =3D=3D
> +			PCI_DEVICE_ID_AMD_NL) {
> +		dwc3_pdata.quirks |=3D DWC3_QUIRK_AMD_NL;
> +	}

should be part of another patch and the quirk is
"disable_scramble_quirk", not AMD.

--=20
balbi

--LyciRD1jyfeSSjG0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUQSuMAAoJEIaOsuA1yqREM84P/16X8tKJCCHzOQd2yYvvi2FG
JkDbxb4I5mX9AmxAYpjr3mG/WTaLNZteRsh2lrck/oXzD4+l7BM6zXE0z8vxS1rx
7xxP84H6eBX6J1NVKZJi3CTJ4mUo2jW4RucPN/fETH24odEmxIuuutagQd8ET2/v
gYofKcWfXJTL/Id7ZHRJ+1Ah/QlfDM1W8xcOP0wldt7MA3tXX7r9HTi0m8ortLSU
LK277cS5btbgh3GiZrPinDi94l7TBmy3u58FzUoV01Tc0x0bPNC4G5iwy5hZLteW
pEXtSUUtd19Ise8nuiC0G7kCArAokaMb5EXMIFPotP5fGdCn98AKTfhRMaUMqOdx
pD5mKcbhKHnccFuUpXt7+etdt9y+BaEWb1aASlhe/DFvmwbrr518vLqoDeA1QrWc
7/sbnSZoeO6eikC9K9DaQrGfMHRRHhXr3drkSc0yzdaN68/PO5Z+R26KiScvszrP
iCkaBdFQoUmgIFXCB/h5XavQ9vQOMVK0hmeQs7CUQ4iReofEZ00dqc3BARu/i2DX
u5itcnHJ5DtjHBPh1nt/LekLT2AcJuWjxjHM0cHXoldPJc2tivS++Tpt8+crz8Tm
0tChQVzR2g8oJuHVAucJtCETs5buEWfG6ZvjkmJW/kPdKtvQTPHtiY9eXz9JD2zo
UpKYdfsgSV46GVsCPyQs
=hFRu
-----END PGP SIGNATURE-----

--LyciRD1jyfeSSjG0--
