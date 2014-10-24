Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757054AbaJXP11 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 11:27:27 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:49978 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757012AbaJXP1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 11:27:23 -0400
Date: Fri, 24 Oct 2014 10:27:00 -0500
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
Subject: Re: [PATCH v2 08/16] usb: dwc3: add u2exit lfps quirk
Message-ID: <20141024152700.GD26941@saruman>
Reply-To: <balbi@ti.com>
References: <1413536021-4886-1-git-send-email-ray.huang@amd.com>
 <1413536021-4886-9-git-send-email-ray.huang@amd.com>
 <20141017145000.GD26260@saruman>
 <20141020064331.GC24357@hr-slim.amd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rz+pwK2yUstbofK6"
Content-Disposition: inline
In-Reply-To: <20141020064331.GC24357@hr-slim.amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--rz+pwK2yUstbofK6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 20, 2014 at 02:43:31PM +0800, Huang Rui wrote:
> On Fri, Oct 17, 2014 at 09:50:00AM -0500, Felipe Balbi wrote:
> > Hi,
> >=20
> > On Fri, Oct 17, 2014 at 04:53:33PM +0800, Huang Rui wrote:
> > > AMD NL needs to enable u2exit lfps quirk.
> > >=20
> > > Signed-off-by: Huang Rui <ray.huang@amd.com>
> > > ---
> > >  drivers/usb/dwc3/core.c          | 4 ++++
> > >  drivers/usb/dwc3/core.h          | 1 +
> > >  drivers/usb/dwc3/dwc3-pci.c      | 3 ++-
> > >  drivers/usb/dwc3/platform_data.h | 1 +
> > >  4 files changed, 8 insertions(+), 1 deletion(-)
> > >=20
> > > diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> > > index 25db533..7322d85 100644
> > > --- a/drivers/usb/dwc3/core.c
> > > +++ b/drivers/usb/dwc3/core.c
> > > @@ -467,6 +467,10 @@ static int dwc3_core_init(struct dwc3 *dwc)
> > >  		reg |=3D DWC3_GCTL_DISSCRAMBLE;
> > >  	else
> > >  		reg &=3D ~DWC3_GCTL_DISSCRAMBLE;
> > > +
> > > +	if (dwc->quirks & DWC3_QUIRK_U2EXIT_LFPS)
> >=20
> > this should be:
> >=20
> > 	if (dwc->u2_exit_lfps_quirk)
> >=20
>=20
> OK, will update it in V3.
>=20
> > > +		reg |=3D DWC3_GCTL_U2EXIT_LFPS;
> > > +
> > >  	/*
> > >  	 * WORKAROUND: DWC3 revisions <1.90a have a bug
> > >  	 * where the device can fail to connect at SuperSpeed
> > > diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
> > > index d58479e..3d27f10 100644
> > > --- a/drivers/usb/dwc3/core.h
> > > +++ b/drivers/usb/dwc3/core.h
> > > @@ -166,6 +166,7 @@
> > >  #define DWC3_GCTL_SCALEDOWN(n)		((n) << 4)
> > >  #define DWC3_GCTL_SCALEDOWN_MASK	DWC3_GCTL_SCALEDOWN(3)
> > >  #define DWC3_GCTL_DISSCRAMBLE		(1 << 3)
> > > +#define DWC3_GCTL_U2EXIT_LFPS		(1 << 2)
> > >  #define DWC3_GCTL_GBLHIBERNATIONEN	(1 << 1)
> > >  #define DWC3_GCTL_DSBLCLKGTNG		(1 << 0)
> > > =20
> > > diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
> > > index bbe946c..cdb9b04 100644
> > > --- a/drivers/usb/dwc3/dwc3-pci.c
> > > +++ b/drivers/usb/dwc3/dwc3-pci.c
> > > @@ -149,7 +149,8 @@ static int dwc3_pci_probe(struct pci_dev *pci,
> > >  	if (pci->vendor =3D=3D PCI_VENDOR_ID_AMD && pci->device =3D=3D
> > >  			PCI_DEVICE_ID_AMD_NL) {
> > >  		dwc3_pdata.has_lpm_erratum =3D true;
> > > -		dwc3_pdata.quirks |=3D DWC3_QUIRK_AMD_NL;
> > > +		dwc3_pdata.quirks |=3D DWC3_QUIRK_AMD_NL
> > > +			| DWC3_QUIRK_U2EXIT_LFPS;
> > >  	}
> >=20
> > should be combined and the last patch in the series.
> >=20
>=20
> You want to make all the AMD quirks enablement info and device id at
> last patch, right?

Correct, that way we avoid bisection points were AMD is "supported" but
not working.

--=20
balbi

--rz+pwK2yUstbofK6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUSm/EAAoJEIaOsuA1yqREvHEP/3fXRur64fJMGBi4R+YbDoYG
p2YsproY6D0BNLwPnKPRK6ud7qIQtogofrCJynvjIU9zKbosLxTUPsCR8PX8uTyF
za8UKMdwlSxtz5cGaPmicTelhJKJT9WxD0OjiyeMvbIqTqrjvqN5F5fNU95C2N10
XB6VYhImv/hC6H74wawuBPPD7LIF1KSdhR3GmnjVxWo1N5j778EsfaIBcQrzCm8O
O5dvZDjLBJR5ED0xhB//7Vu2h08HC4gnFRxPVqNrh3BeoSpGoXZH/tZqgpEqypWM
qPVG+jM3cHXXJcYsCERldO9nUb4kJweeWdg7D8lc8INFpfvoXEFLyEidWxnoRm9y
xBM7ybnXJfixqyfi3OzYI8Ai8lIkIJ5aN/nPWZbr3aVJmxttD42esuTRKLbWE18n
YXmYS3Pxk/mgNvmu4JH3DxT2/h/MYoGA8nzZMqRUPRmIpQVvHSQBJt4VA/IrVkZ6
RKySlkiof1f4ufk5m0H6YG4l4uJNEndGq1/oaXYKvBgagFux4/wmUcsopqJcYjny
CfScYUcpHtYykZnR7aq5b4F8Gk6o1cYIvAN/GCMv6icTE5tw9XWU2cNWmBfPCt/l
IHOhtR4xIvgslFTFHi+XNvUaxfrm04/ybx8uvH4TvZFQqwaRrNhAShReS/ULHVfV
bk1AE7m/hF6WQDZtTcfM
=1Fuo
-----END PGP SIGNATURE-----

--rz+pwK2yUstbofK6--
