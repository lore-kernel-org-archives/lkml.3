Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756983AbaJXP05 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 11:26:57 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:36220 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756957AbaJXP0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 11:26:53 -0400
Date: Fri, 24 Oct 2014 10:26:28 -0500
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
Message-ID: <20141024152628.GC26941@saruman>
Reply-To: <balbi@ti.com>
References: <1413536021-4886-1-git-send-email-ray.huang@amd.com>
 <1413536021-4886-7-git-send-email-ray.huang@amd.com>
 <20141017144532.GB26260@saruman>
 <20141020063827.GB24357@hr-slim.amd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LwW0XdcUbUexiWVK"
Content-Disposition: inline
In-Reply-To: <20141020063827.GB24357@hr-slim.amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--LwW0XdcUbUexiWVK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 20, 2014 at 02:38:28PM +0800, Huang Rui wrote:
> On Fri, Oct 17, 2014 at 09:45:32AM -0500, Felipe Balbi wrote:
> > Hi,
> >=20
> > On Fri, Oct 17, 2014 at 04:53:31PM +0800, Huang Rui wrote:
> > > AMD NL fpga needs to enable disscramble quirk. And this quirk doesn't=
 need on
> > > the true soc.
> > >=20
> > > Signed-off-by: Huang Rui <ray.huang@amd.com>
> > > ---
> > >  drivers/usb/dwc3/core.c          | 8 +++++++-
> > >  drivers/usb/dwc3/dwc3-pci.c      | 5 +++++
> > >  drivers/usb/dwc3/platform_data.h | 4 ++++
> > >  3 files changed, 16 insertions(+), 1 deletion(-)
> > >=20
> > > diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> > > index 50c0eae..819e501 100644
> > > --- a/drivers/usb/dwc3/core.c
> > > +++ b/drivers/usb/dwc3/core.c
> > > @@ -422,7 +422,6 @@ static int dwc3_core_init(struct dwc3 *dwc)
> > > =20
> > >  	reg =3D dwc3_readl(dwc->regs, DWC3_GCTL);
> > >  	reg &=3D ~DWC3_GCTL_SCALEDOWN_MASK;
> > > -	reg &=3D ~DWC3_GCTL_DISSCRAMBLE;
> > > =20
> > >  	switch (DWC3_GHWPARAMS1_EN_PWROPT(dwc->hwparams.hwparams1)) {
> > >  	case DWC3_GHWPARAMS1_EN_PWROPT_CLK:
> > > @@ -461,6 +460,13 @@ static int dwc3_core_init(struct dwc3 *dwc)
> > >  		dwc->is_fpga =3D true;
> > >  	}
> > > =20
> > > +	if ((dwc->quirks & DWC3_QUIRK_AMD_NL) && dwc->is_fpga)
> > > +		dwc->quirks |=3D DWC3_QUIRK_DISSCRAMBLE;
> > > +
> > > +	if (dwc->quirks & DWC3_QUIRK_DISSCRAMBLE)
> >=20
> > this should only be set if is_fpga, and this quirk should be a 1-bit
> > flag, so here's what you should do:
> >=20
> > 	WARN_ONCE(dwc->disable_scramble_quirk && !dwc->is_fpga,
> > 		"disable_scramble cannot be used on non-FPGA builds\n");
> >=20
> > 	if (dwc->disable_scramble && dwc->is_fpga)
> > 		reg |=3D DWC3_GCTL_DISSCRAMBLE;
> > 	else
> > 		reg &=3D ~DWC3_GCTL_DISSCRAMBLE;
> >=20
>=20
> OK, will update it in V3.
>=20
> > > +		reg |=3D DWC3_GCTL_DISSCRAMBLE;
> > > +	else
> > > +		reg &=3D ~DWC3_GCTL_DISSCRAMBLE;
> >=20
> > add a blank line here, to aid readability.
> >=20
>=20
> OK, will add it.
>=20
> > >  	/*
> > >  	 * WORKAROUND: DWC3 revisions <1.90a have a bug
> > >  	 * where the device can fail to connect at SuperSpeed
> > > diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
> > > index 18569a4..a89db6c 100644
> > > --- a/drivers/usb/dwc3/dwc3-pci.c
> > > +++ b/drivers/usb/dwc3/dwc3-pci.c
> > > @@ -146,6 +146,11 @@ static int dwc3_pci_probe(struct pci_dev *pci,
> > >  	res[1].name	=3D "dwc_usb3";
> > >  	res[1].flags	=3D IORESOURCE_IRQ;
> > > =20
> > > +	if (pci->vendor =3D=3D PCI_VENDOR_ID_AMD && pci->device =3D=3D
> > > +			PCI_DEVICE_ID_AMD_NL) {
> > > +		dwc3_pdata.quirks |=3D DWC3_QUIRK_AMD_NL;
> > > +	}
> >=20
> > should be part of another patch and the quirk is
> > "disable_scramble_quirk", not AMD.
> >=20
>=20
> Got it, you would like to keep this patch just for fpga disscramble
> quirk and do not add any 3rd platform info, right?

right. So far only FPGA-based systems need this :-)

--=20
balbi

--LwW0XdcUbUexiWVK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUSm+kAAoJEIaOsuA1yqREmWUP/REwJX7PJlz+4QpftDPTbwTh
AqtdshSZ2kmxfAPQd3GWVsU2K4lrNT3OUCZdZgB9lB8q9psJzCR7SaGGHKy8szVf
ZUQrw2gWzCN5KN/6TLiSnLvPAMkIlnivudEEZ3hvjISuk5x/zRyZGJuuMChfZ/1y
TXIwyKQJcrndzLZo5Zsqh6dvUxLYaImmf8Gfez6ccianL3yXIyYbAg05uBzjTJkl
iYO3yOsh6t+JkOHdrDJiETh7kdSMVX3uoKsZS2usyKs2Xn+5AwHYijI3whC1Xmcl
+/MuAEF8NL357D1LAEHuhpadmU7mro28zeHt3Hf0qrTNhPhOdWJ8L08KPsExjvzC
DVo5awl29twuI/65tJhVJ5QDP+uEbu4q1xszpgDVl+hwDmaWcn9N7Y/86X503uyt
5e8mSSpJkcA1hg35zVZgNx8akHDPKtXuSN4RENK+fh60t1SDQDl3hK/TCHLSVm6T
adm1nkMp9VI80nv48FwL00pr4E/KSZcue5SRQyMLoTUm9/gnM8R3pVi+P+7F5oI4
11NjlrTboIMOH9viP7u0EUOJGMORUYMG4aiZdhrcb3BaoDRBULGTJW8FgV0lOlpI
bkKb4Oy28QFk11D2L+QPePJhd6m2e54t2newZjwp4pl08M7ghoZsygI2dYVTtMC1
WMfUVCm3BDeZzX/w87fK
=ZIM6
-----END PGP SIGNATURE-----

--LwW0XdcUbUexiWVK--
