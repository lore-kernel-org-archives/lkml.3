Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757090Ab3GRIW7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 04:22:59 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:53439 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063Ab3GRIW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 04:22:56 -0400
Date: Thu, 18 Jul 2013 11:22:40 +0300
From: Felipe Balbi <balbi@ti.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: Felipe Balbi <balbi@ti.com>, Rong Wang <wr011235813@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <Rong.Wang@csr.com>
Subject: Re: [PATCH] usb: udc: add gadget state kobject uevent
Message-ID: <20130718082240.GD11251@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <20130717132736.GA7614@arwen.pp.htv.fi>
 <Pine.LNX.4.44L0.1307171134530.1555-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VUDLurXRWRKrGuMn"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1307171134530.1555-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--VUDLurXRWRKrGuMn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jul 17, 2013 at 11:37:35AM -0400, Alan Stern wrote:
> On Wed, 17 Jul 2013, Felipe Balbi wrote:
>=20
> > On Wed, Jul 17, 2013 at 09:04:54PM +0800, Rong Wang wrote:
> > > Hi Felipe,
> > >=20
> > > On Wed, Jul 17, 2013 at 3:57 PM, Felipe Balbi <balbi@ti.com> wrote:
> > > > Hi,
> > > >
> > > > On Mon, Jul 15, 2013 at 11:31:17PM -0700, Greg KH wrote:
> > > >> > The question is since we default GADGET, so the g_mass_storage.k=
o is
> > > >> > installed early but connecting to a host PC
> > > >> > is randomly, But the udev has no idea when a host PC connects ou=
r device.
> > > >> >
> > > >> > So we consider it's reasonable to let the udev know the GADGET d=
evice state.
> > > >> > Is there any alternative to our question?
> > > >>
> > > >> I thought we already export events for gadget device states, have =
you
> > > >> looked for them?  I can't dig through the code at the moment, but =
this
> > > >> seems like a pretty common issue...
> > > >>
> > > >> Felipe, any ideas?
> > > >
> > > > we already expose that in sysfs. IIRC udev can act on sysfs changes,
> > > > no ?
> > >=20
> > > I do not know if udev can polling sysfs file content change. I'll stu=
dy this.
> > >=20
> > > But the change is triggered by calling usb_gadget_set_state, and I fi=
nd
> > > composite framework do not call this. Then we should do this common w=
ork
> > > in every udc driver?
> >=20
> > yes. Only the UDC driver knows when the controller is moving among those
> > states.
>=20
> Not quite.  Only the gadget driver knows when the transition between=20
> ADDRESS and CONFIGURED occurs.  This should be added to composite.c.

that's not entirely true :-) See how we handle that in dwc3:

| static int dwc3_ep0_set_config(struct dwc3 *dwc, struct usb_ctrlrequest *=
ctrl)
| {
| 	enum usb_device_state state =3D dwc->gadget.state;
| 	u32 cfg;
| 	int ret;
| 	u32 reg;
|=20
| 	dwc->start_config_issued =3D false;
| 	cfg =3D le16_to_cpu(ctrl->wValue);
|=20
| 	switch (state) {
| 	case USB_STATE_DEFAULT:
| 		return -EINVAL;
| 		break;
|=20
| 	case USB_STATE_ADDRESS:
| 		ret =3D dwc3_ep0_delegate_req(dwc, ctrl);
| 		/* if the cfg matches and the cfg is non zero */
| 		if (cfg && (!ret || (ret =3D=3D USB_GADGET_DELAYED_STATUS))) {
| 			usb_gadget_set_state(&dwc->gadget,
| 					USB_STATE_CONFIGURED);
|=20
| 			/*
| 			 * Enable transition to U1/U2 state when
| 			 * nothing is pending from application.
| 			 */
| 			reg =3D dwc3_readl(dwc->regs, DWC3_DCTL);
| 			reg |=3D (DWC3_DCTL_ACCEPTU1ENA | DWC3_DCTL_ACCEPTU2ENA);
| 			dwc3_writel(dwc->regs, DWC3_DCTL, reg);
|=20
| 			dwc->resize_fifos =3D true;
| 			dev_dbg(dwc->dev, "resize fifos flag SET\n");
| 		}
| 		break;
|=20
| 	case USB_STATE_CONFIGURED:
| 		ret =3D dwc3_ep0_delegate_req(dwc, ctrl);
| 		if (!cfg)
| 			usb_gadget_set_state(&dwc->gadget,
| 					USB_STATE_ADDRESS);
| 		break;
| 	default:
| 		ret =3D -EINVAL;
| 	}
| 	return ret;
| }

Also, until other gadget drivers add notifications to the other cases, I
don't think it's wise to add a transition from NOTATTACHED to
CONFIGURED.

But I have one change I'll send for the gadget notifications, I'm just
trying to get a new OMAP5 board to test because the FTDI chip on mine
died and I have no console :-)

--=20
balbi

--VUDLurXRWRKrGuMn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR56XQAAoJEIaOsuA1yqRE5k0QAKZBv22g673MEd00yfllK0JL
ef6eVuNRZX6WRhwIksFVhFf8yrwhaXfwIGTPfIB2TA+luo0mC2mhtqGvZMrJibZy
wYvWO3q0q54J5WglZw5Bf/94E3P04WScBrwpX1UG/v/9/so/RbZWW/nVbUfKN0qE
BOOk39QOVGl5+0lkWLhyRO0cuipobXsRdMHRzR1rW/VFXAsToiTBhvCjZZojX7Rr
FTne77b7Rb7Ks001qHllWo7zWpSBtA+6mxPkmPPMwnkAXT2ZhsI19StE3PCkxVU6
/xlNAhpjU+nynXBxI/Bel2UU5gpQ+WXhqg8wd/GEZR4Hp/Yds43Oz6Mc8PzKT5h8
hC1IGMtZkAn1E9IYniwoNKJ46QzuVAVuYzIA5XoTaE+pEdju6Xvq0nbiiee6l24d
AXAzUMwqsWGepBzCjTQSySTtt392gFTQANhKvFN8DaJ3C/6V6MM0syjHTENDGJwc
GO41jk1hNLnllIEJ4MrEF2XJE1ZdB+BKh+UFSwKCwahbBgZXUZEjdld2bSsRWyYA
4eBTt9QExN/zhcXmFVJz/BIAC9MWGvyksIm30aPIdFjJviuDBawVnq22xnvx0Qd+
CYsC4bKMDmE31Fx6R7J/At7cSefb75fqgyK8U38f6Cn8VcKH0MwpKqPcl15NTmDn
71wXF8SSCcmezX8kLtRd
=LFIO
-----END PGP SIGNATURE-----

--VUDLurXRWRKrGuMn--
