Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230AbaJXP3J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 11:29:09 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:33176 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751630AbaJXP3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 11:29:07 -0400
Date: Fri, 24 Oct 2014 10:28:44 -0500
From: Felipe Balbi <balbi@ti.com>
To: Huang Rui <ray.huang@amd.com>
CC: Felipe Balbi <balbi@ti.com>, Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Vincent Wan <vincent.wan@amd.com>, Tony Li <tony.li@amd.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 16/16] usb: dwc3: enable usb suspend phy
Message-ID: <20141024152844.GE26941@saruman>
Reply-To: <balbi@ti.com>
References: <1413536021-4886-1-git-send-email-ray.huang@amd.com>
 <1413536021-4886-17-git-send-email-ray.huang@amd.com>
 <20141017145942.GL26260@saruman>
 <A2CA0424C0A6F04399FB9E1CD98E0304844E3423@US01WEMBX2.internal.synopsys.com>
 <20141017184819.GX26260@saruman>
 <20141020084153.GD24357@hr-slim.amd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a+b56+3nqLzpiR9O"
Content-Disposition: inline
In-Reply-To: <20141020084153.GD24357@hr-slim.amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--a+b56+3nqLzpiR9O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Oct 20, 2014 at 04:41:54PM +0800, Huang Rui wrote:
> On Fri, Oct 17, 2014 at 01:48:19PM -0500, Felipe Balbi wrote:
> > Hi,
> >=20
> > On Fri, Oct 17, 2014 at 06:41:04PM +0000, Paul Zimmerman wrote:
> > > > From: Felipe Balbi [mailto:balbi@ti.com]
> > > > Sent: Friday, October 17, 2014 8:00 AM
> > > >=20
> > > > On Fri, Oct 17, 2014 at 04:53:41PM +0800, Huang Rui wrote:
> > > > > AMD NL needs to suspend usb3 ss phy, but this doesn't enable on s=
imulation
> > > > > board.
> > > > >
> > > > > Signed-off-by: Huang Rui <ray.huang@amd.com>
> > > > > ---
> > > > >  drivers/usb/dwc3/core.c          | 7 ++++++-
> > > > >  drivers/usb/dwc3/dwc3-pci.c      | 3 ++-
> > > > >  drivers/usb/dwc3/platform_data.h | 1 +
> > > > >  3 files changed, 9 insertions(+), 2 deletions(-)
> > > > >
> > > > > diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> > > > > index 3ccfe41..4a98696 100644
> > > > > --- a/drivers/usb/dwc3/core.c
> > > > > +++ b/drivers/usb/dwc3/core.c
> > > > > @@ -395,6 +395,9 @@ static void dwc3_phy_setup(struct dwc3 *dwc)
> > > > >  	if (dwc->quirks & DWC3_QUIRK_TX_DEEPH)
> > > > >  		reg |=3D DWC3_GUSB3PIPECTL_TX_DEEPH(1);
> > > > >
> > > > > +	if (dwc->quirks & DWC3_QUIRK_SUSPHY)
> > > >=20
> > > > should be:
> > > >=20
> > > > 	if (!dwc->suspend_usb3_phy_quirk)
> > > >=20
> > > > > +		reg |=3D DWC3_GUSB3PIPECTL_SUSPHY;
> > > >=20
> > > > IIRC, databook asks us to set that bit anyway, so the quirk is disa=
bling
> > > > that bit. Am I missing something ? Paul ?
> > >=20
> > > It looks to me that Huang's patch is enabling that bit, not disabling
> > > it.
> >=20
> > right, but that's what's actually quirky right ? IIRC, Databook asks us
> > to set usb2 and usb3 suspend phy bits and we're just not doing it.
> >=20
> > > Currently the driver does not set either DWC3_GUSB3PIPECTL_SUSPHY or
> > > DWC3_GUSB2PHYCFG_SUSPHY (unless it has been added by that big patch
> > > series you just posted). According to the databook, both of those
> > > bits should be set to 1 after the core initialization has completed.
> >=20
> > there you go. So unless that quirk bit flag is set, we're safe of
> > setting SUSPHY bit for everybody.
> >=20
>=20
> So I can update to set these two suspend phy bits defaultly in my next
> patch set, is it OK? :)

We need to split this into two patches:

patch 1 adds missing SUSPHY bit for all cores above revision 1.94a at
the end of probe()

patch 2 adds a quirk which AMD needs so that setting USB3_SUSPHY bit is
conditional on that quirk.

--=20
balbi

--a+b56+3nqLzpiR9O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUSnAsAAoJEIaOsuA1yqREKmsP/21cAHDTI0at3AVzw0jG5Pgs
i6YSR3AjoQPeYOUU1HfSSQWHyKouLa+U8/WU0RqnfTq6toQ5vmDgJOsO7vWS9S+q
DM0dB0CG9uMWq4QsRl3vvBcx3f5SXXQFfzf89xR7paAjcbXN9gZXk57U3qSQuWE0
JhpPGBUIHqv+B/nfXLdrZ5VUNuKBGhPnEtvycck53jzMLl6I3oJkntdCHyDWiApi
wt0OMuOTlXlvaAULwXnzP0EW13NjYP7q/RbVmWZ4VCULTrBnVlDxt4+Xbqb8l5g5
V4zxU+nr8UWxddTtXtNnz3k0j3Sgmjxg1RTQcEv34frC/Y0MlBappojO1gAeA9d7
0agTOH5Et9PrZvSe8+dOoxLfWgd/nzDAWwjcVERllrjOOVWj4ofbGpfufS+R+Zqf
HfT3xzOLUxmw9j7pwpyPdPWWWWYCXsu83uQzTT/DNfXKMynj7jt49tolBv96vtHM
EUREHu7/Mpjg205W19PepqMPN8Gz7HOkNnCxQcvqOLXIXklP3+axrgDszQ+sL5QB
hucVasFoa3YBeJpBt3iCNBrbStwp2XY4eINvMvJC7g0PAyU1QOkHuMY5wRVRKLbp
GF8AybA/+sQR1l2aAgxQDm9IGvaR0Bbcyi43PXHfoG6j6hJmJwv1ooF5TZAqdn6I
DVw46NxmwkbnP6E7E2B7
=S57/
-----END PGP SIGNATURE-----

--a+b56+3nqLzpiR9O--
