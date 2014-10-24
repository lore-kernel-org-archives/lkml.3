Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757130AbaJXRgQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 13:36:16 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:54715 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755894AbaJXRgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 13:36:14 -0400
Date: Fri, 24 Oct 2014 12:35:49 -0500
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
Subject: Re: [PATCH v2 07/16] usb: dwc3: add lpm erratum support
Message-ID: <20141024173549.GP26941@saruman>
Reply-To: <balbi@ti.com>
References: <1413536021-4886-1-git-send-email-ray.huang@amd.com>
 <1413536021-4886-8-git-send-email-ray.huang@amd.com>
 <20141017144859.GC26260@saruman>
 <20141024170128.GA5149@hr-slim.amd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="p6hDAtPN9q+ZnUca"
Content-Disposition: inline
In-Reply-To: <20141024170128.GA5149@hr-slim.amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--p6hDAtPN9q+ZnUca
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sat, Oct 25, 2014 at 01:01:28AM +0800, Huang Rui wrote:
> On Fri, Oct 17, 2014 at 09:48:59AM -0500, Felipe Balbi wrote:
> > On Fri, Oct 17, 2014 at 04:53:32PM +0800, Huang Rui wrote:
> > > When parameter DWC_USB3_LPM_ERRATA_ENABLE is enabled in Andvanced Con=
figuration
> > > of coreConsultant, it supports of xHCI BESL Errata Dated 10/19/2011 i=
s enabled
> > > in host mode. In device mode it adds the capability to send NYET resp=
onse based
> > > on the BESL value received in the LPM token.
> > >=20
> > > This patch add an entry that soc platform is able to define the lpm c=
apacity
> > > with their own device tree or bus glue layer.
> > >=20
> > > Suggested-by: Felipe Balbi <balbi@ti.com>
> > > Signed-off-by: Huang Rui <ray.huang@amd.com>
> > > ---
> > >  drivers/usb/dwc3/core.c          |  2 ++
> > >  drivers/usb/dwc3/core.h          | 24 +++++++++++++++---------
> > >  drivers/usb/dwc3/dwc3-pci.c      |  1 +
> > >  drivers/usb/dwc3/gadget.c        |  7 +++++++
> > >  drivers/usb/dwc3/platform_data.h |  1 +
> > >  5 files changed, 26 insertions(+), 9 deletions(-)
> > >=20
> > > diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> > > index 819e501..25db533 100644
> > > --- a/drivers/usb/dwc3/core.c
> > > +++ b/drivers/usb/dwc3/core.c
> > > @@ -708,11 +708,13 @@ static int dwc3_probe(struct platform_device *p=
dev)
> > > =20
> > >  	if (node) {
> > >  		dwc->maximum_speed =3D of_usb_get_maximum_speed(node);
> > > +		dwc->has_lpm_erratum =3D of_property_read_bool(node, "snps,has-lpm=
-erratum");
> > > =20
> > >  		dwc->needs_fifo_resize =3D of_property_read_bool(node, "tx-fifo-re=
size");
> > >  		dwc->dr_mode =3D of_usb_get_dr_mode(node);
> > >  	} else if (pdata) {
> > >  		dwc->maximum_speed =3D pdata->maximum_speed;
> > > +		dwc->has_lpm_erratum =3D pdata->has_lpm_erratum;
> > > =20
> > >  		dwc->needs_fifo_resize =3D pdata->tx_fifo_resize;
> > >  		dwc->dr_mode =3D pdata->dr_mode;
> > > diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
> > > index cfe0d57..d58479e 100644
> > > --- a/drivers/usb/dwc3/core.h
> > > +++ b/drivers/usb/dwc3/core.h
> > > @@ -246,16 +246,19 @@
> > >  #define DWC3_DCTL_TRGTULST_SS_INACT	(DWC3_DCTL_TRGTULST(6))
> > > =20
> > >  /* These apply for core versions 1.94a and later */
> > > -#define DWC3_DCTL_KEEP_CONNECT	(1 << 19)
> > > -#define DWC3_DCTL_L1_HIBER_EN	(1 << 18)
> > > -#define DWC3_DCTL_CRS		(1 << 17)
> > > -#define DWC3_DCTL_CSS		(1 << 16)
> > > +#define DWC3_DCTL_LPM_ERRATA_MASK	DWC3_DCTL_LPM_ERRATA(0xf)
> > > +#define DWC3_DCTL_LPM_ERRATA(n)		((n) << 20)
> > > -#define DWC3_DCTL_INITU2ENA	(1 << 12)
> > > -#define DWC3_DCTL_ACCEPTU2ENA	(1 << 11)
> > > -#define DWC3_DCTL_INITU1ENA	(1 << 10)
> > > -#define DWC3_DCTL_ACCEPTU1ENA	(1 << 9)
> > > -#define DWC3_DCTL_TSTCTRL_MASK	(0xf << 1)
> > > +#define DWC3_DCTL_KEEP_CONNECT		(1 << 19)
> > > +#define DWC3_DCTL_L1_HIBER_EN		(1 << 18)
> > > +#define DWC3_DCTL_CRS			(1 << 17)
> > > +#define DWC3_DCTL_CSS			(1 << 16)
> > > +
> > > +#define DWC3_DCTL_INITU2ENA		(1 << 12)
> > > +#define DWC3_DCTL_ACCEPTU2ENA		(1 << 11)
> > > +#define DWC3_DCTL_INITU1ENA		(1 << 10)
> > > +#define DWC3_DCTL_ACCEPTU1ENA		(1 << 9)
> > > +#define DWC3_DCTL_TSTCTRL_MASK		(0xf << 1)
> > > =20
> > >  #define DWC3_DCTL_ULSTCHNGREQ_MASK	(0x0f << 5)
> > >  #define DWC3_DCTL_ULSTCHNGREQ(n) (((n) << 5) & DWC3_DCTL_ULSTCHNGREQ=
_MASK)
> > > @@ -665,6 +668,8 @@ struct dwc3_scratchpad_array {
> > >   * @ep0_bounced: true when we used bounce buffer
> > >   * @ep0_expect_in: true when we expect a DATA IN transfer
> > >   * @has_hibernation: true when dwc3 was configured with Hibernation
> > > + * @has_lpm_erratum: true when core was configured with LPM Erratum.=
 Note that
> > > + *			there's now way for software to detect this in runtime.
> > >   * @is_selfpowered: true when we are selfpowered
> > >   * @is_fpga: true when we are using the FPGA board
> > >   * @needs_fifo_resize: not all users might want fifo resizing, flag =
it
> > > @@ -771,6 +776,7 @@ struct dwc3 {
> > >  	unsigned		ep0_bounced:1;
> > >  	unsigned		ep0_expect_in:1;
> > >  	unsigned		has_hibernation:1;
> > > +	unsigned		has_lpm_erratum:1;
> > >  	unsigned		is_selfpowered:1;
> > >  	unsigned		is_fpga:1;
> > >  	unsigned		needs_fifo_resize:1;
> > > diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
> > > index a89db6c..bbe946c 100644
> > > --- a/drivers/usb/dwc3/dwc3-pci.c
> > > +++ b/drivers/usb/dwc3/dwc3-pci.c
> > > @@ -148,6 +148,7 @@ static int dwc3_pci_probe(struct pci_dev *pci,
> > > =20
> > >  	if (pci->vendor =3D=3D PCI_VENDOR_ID_AMD && pci->device =3D=3D
> > >  			PCI_DEVICE_ID_AMD_NL) {
> > > +		dwc3_pdata.has_lpm_erratum =3D true;
> > >  		dwc3_pdata.quirks |=3D DWC3_QUIRK_AMD_NL;
> > >  	}
> > > =20
> >=20
> > let's combine all AMD patches as the last patch in the series so we add
> > AMD support with all quirks in one place.
> >=20
> > > diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> > > index 1f2a719..33bfc70 100644
> > > --- a/drivers/usb/dwc3/gadget.c
> > > +++ b/drivers/usb/dwc3/gadget.c
> > > @@ -1581,6 +1581,13 @@ static int dwc3_gadget_start(struct usb_gadget=
 *g,
> > >  	}
> > >  	dwc3_writel(dwc->regs, DWC3_DCFG, reg);
> > > =20
> > > +	if (dwc->has_lpm_erratum) {
> > > +		reg =3D dwc3_readl(dwc->regs, DWC3_DCTL);
> > > +		/* REVISIT should this be configurable ? */
> > > +		reg |=3D DWC3_DCTL_LPM_ERRATA(0xf);
> >=20
> > as Paul mentioned, this should definitely be configurable. So we need to
> > discuss how to make that configurable too.
> >=20
>=20
> Can I define a 4-bits variable (lpm_nyet_thres) to let platform vendor ab=
le to configure
> the besl value at DT or glue layer?
>=20
> struct dwc3_platform_data {
>         ...
>         unsigned has_lpm_erratum:1;
>         unsigned lpm_nyet_thres:4;

this threshold can be a u8, no problem :-) (also, please spell out
threshold completely :-)

> Then put the value at probe like:
>=20
> dwc->has_lpm_erratum =3D of_property_read_u8(node, "snps,lpm-nyet-thres");

yup, that's fine :-)

> I don't find a 4-bit "Find from a property" interface, so can I use
> of_property_read_u8 instead for ARM platforms?
>=20
> Then do:
> if (dwc->has_lpm_erratum)
>         reg |=3D DWC3_DCTL_LPM_ERRATA(dwc->lpm_nyet_thres);

perfect :-) But then default to highest possible threshold, perhaps ?

lpm_nyet_threshold =3D 0xff;

if (pdata->lpm_nyet_threshold)
	lpm_nyet_threshold =3D pdata->lpm_nyet_threshold;

and likewise for DT.

--=20
balbi

--p6hDAtPN9q+ZnUca
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUSo31AAoJEIaOsuA1yqREpc4P/RCntnTQa48wY+WvvgCIN1rk
yB8hl23iv3pInNHLMW1CEPG9W3qpGt6gGEzp94c203ZaBXe1Osj2tHz0OlVcaxBs
Iw0bMCEp8MtOCFY5o0Dp+2v56Esh88YqMwsGDz4O3vKac+uXYwaomZnI1Eywfjul
O7KpJ0rLBFuod9Locw/vxDJZGEEFuqJAybfwZtoveGgKITE/tKCOLPF7wTQmph0w
u4f379EZwKpZZcmKgfqbmMI77XGBuKPoS4mfavpLjcH/KfRjhMYYmglETmumkpTw
St91hUMXcRmRl81hTAjOBQ8AXG9aqDbiazbyJWv65xYU6F/wJKnlixuPzcX80KLb
ZeQRm753dLUOY2sdTbimQ3aw9lWrV9S1XlaAIO4zp+vBZ6ohYvRC7OeJGT7KcIDJ
yy2Dp1J9anfJ6LDzN7Jym+rSWQXNwpyar5LNawqoq4yB7iaAU0Wtp2uC8zj8TFdz
kR47gfSAeWrJuLBTT2k2bGHlqIGaLt4qAJKtVmECk3djqMUNJ/LPQGv0d+IQ8Wk7
A71mLLvrMM+lGi6jVJ461ll1NouMsZmbAeyKlVLaw8TggsWe/IfoWgGeL5qC9vPH
qnbZk2G3EL7VATp/Vh0RWPSwUBkoGrTOBCAYzM2VQDUOVWrZsuMPNQ4AxCZo8H/L
MHBeH0rweNI76l4jQ/56
=hm1Z
-----END PGP SIGNATURE-----

--p6hDAtPN9q+ZnUca--
