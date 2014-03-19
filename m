Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965636AbaCSPsc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 11:48:32 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:55695 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965160AbaCSPsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 11:48:30 -0400
Date: Wed, 19 Mar 2014 10:46:10 -0500
From: Felipe Balbi <balbi@ti.com>
To: "suresh.gupta@freescale.com" <suresh.gupta@freescale.com>
CC: "balbi@ti.com" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stefani Seibold <stefani@seibold.net>
Subject: Re: [PATCH] USB: Gadget: fsl driver pullup fix
Message-ID: <20140319154610.GA30557@saruman.home>
Reply-To: <balbi@ti.com>
References: <1394716255-26963-1-git-send-email-suresh.gupta@freescale.com>
 <20140313152517.GG4599@saruman.home>
 <797f2a4344754765a968250ef26f2b53@BN1PR03MB251.namprd03.prod.outlook.com>
 <20140315013529.GB31520@saruman.home>
 <35bc432e846140e3b5d89ef677c8287f@BN1PR03MB251.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n8g4imXOkfNTN/H1"
Content-Disposition: inline
In-Reply-To: <35bc432e846140e3b5d89ef677c8287f@BN1PR03MB251.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 19, 2014 at 02:23:59PM +0000, suresh.gupta@freescale.com wrote:
>=20
>=20
> > -----Original Message-----
> > From: Felipe Balbi [mailto:balbi@ti.com]
> > Sent: Saturday, March 15, 2014 7:05 AM
> > To: Gupta Suresh-B42813
> > Cc: balbi@ti.com; gregkh@linuxfoundation.org; linux-usb@vger.kernel.org;
> > linux-kernel@vger.kernel.org; Stefani Seibold
> > Subject: Re: [PATCH] USB: Gadget: fsl driver pullup fix
> >=20
> > Hi,
> >=20
> > (first of all, please fix your email client, we need the quotation mark=
s.
> > See Documentation/email-clients.txt)
> >=20
> > On Fri, Mar 14, 2014 at 08:53:24PM +0000, suresh.gupta@freescale.com
> > wrote:
> > > > On Thu, Mar 13, 2014 at 06:40:55PM +0530, Suresh Gupta wrote:
> > > > > Attached is a small fix for the fsl usb gadget driver. This fix
> > > > > the driver in a way that the usb device will be only "pulled up"
> > > > > on requests like other usb gadget drivers do.
> > > > > This is necessary, because the device information is not always
> > > > > available until an application is up and running which provides
> > > > > this datas.
> > > > >
> > > > > Signed-off-by: Stefani Seibold <stefani@seibold.net>
> > > > > Signed-off-by: Suresh Gupta <suresh.gupta@freescale.com>
> > > > > ---
> > > > >  drivers/usb/gadget/fsl_udc_core.c | 38
> > > > > +++++++++++++++++++++-----------------
> > > > >  1 file changed, 21 insertions(+), 17 deletions(-)
> > > > >
> > > > > diff --git a/drivers/usb/gadget/fsl_udc_core.c
> > > > > b/drivers/usb/gadget/fsl_udc_core.c
> > > > > index 35cb972..9a93727 100644
> > > > > --- a/drivers/usb/gadget/fsl_udc_core.c
> > > > > +++ b/drivers/usb/gadget/fsl_udc_core.c
> > > > > @@ -153,6 +153,21 @@ static inline void fsl_set_accessors(struct
> > > > > fsl_usb2_platform_data *pdata) {}
> > > > >
> > /********************************************************************
> > > > >   *	Internal Used Function
> > > > >
> > > > > ******************************************************************
> > > > > **/
> > > > > +static int can_pullup(struct fsl_udc *udc) {
> > > > > +	return udc->driver && udc->softconnect && udc->vbus_active; }
> > > > > +
> > > > > +static void set_pullup(struct fsl_udc *udc) {
> > > > > +	if (can_pullup(udc))
> > > > > +		fsl_writel((fsl_readl(&dr_regs->usbcmd) |
> > USB_CMD_RUN_STOP),
> > > > > +				&dr_regs->usbcmd);
> > > > > +	else
> > > > > +		fsl_writel((fsl_readl(&dr_regs->usbcmd) &
> > ~USB_CMD_RUN_STOP),
> > > > > +				&dr_regs->usbcmd);
> > > > > +}
> > > >
> > > > why is this a "fix", you just re-factored some code into
> > set_pullup().
> > > >
> > > [SuresH] I set udc->vbus_active and udc->softconnect to default value
> > > of 1 in struct_udc_setup. This was actual fix in this patch.  The
> >=20
> > right, you see now why is it a problem to mix cleanups with fixes ? You
> > *never*, ever combine unrelated changes in a single patch. It makes it a
> > lot more difficult to see what you're actually changing. So, to start
> > with, this patch should (if it was correct) be split into two smaller
> > patches: one re-factoring the duplicated code into set_pullup() and
> > another which fixes vbus_active and softconnect flags.
>=20
> Agreed, I will resend the patches. =20
>=20
> >=20
> > But hang on, before you do that...
> >=20
> > > can_pullup function return false when these values was not set and
> > > intern the code return without enabling the pullup and gadget
> > > controller stops.
> >=20
> > So here's you mistake: the idea of can_pullup() (and thus, vbus_active
> > and softconnect flags) is to tell the driver "we're connet to a host,
> > it's safe to connect your pullups".
> >=20
> > When you set both those flags to true, you're telling the driver that
> > you, indeed, are connected to a host. This might not be true if you fir=
st
> > boot up your platform, load all drivers and only after connect the cabl=
e.
> > In essence, you're lying to your driver and, as my mommy used to say,
> > "nobody likes a liar, my boy".
> >=20
> > Curret situation isn't very good either since the driver is assuming th=
at
> > cable is only plugged after driver is loaded, so it won't cope very well
> > with situation where cable is first plugged, then you apply power to yo=
ur
> > board.
> >=20
> > What you *really* need to do here is ask the HW for initial states of
> > those flags. During your probe() routine - as the name says - you probe
> > your HW to check its state (or to initialize its state), then you ask
> > "Hey IP, is VBUS above session valid threshold ?" Then you use the HW's
> > reply to initialize both flags, the way you want.
>=20
> After your explanation and some code browsing, I think the exact place to
> set vbus_active is fsl_vbus_session which called on detecting vbus.
> Also fsl_pullup should return without doing anything if vbus_active is no=
t set.
> Please suggest.
>=20
> I do not get the usage of softconnect. Do I set softconnect also in
> fsl_vbus_session.  Please suggest.

looks like softconnect should be set when pullups are connected.

--=20
balbi

--n8g4imXOkfNTN/H1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTKbvCAAoJEIaOsuA1yqREw+kQAIVfIwS5fh21SIRrazg7awnA
voM7W3dRuWUGFkq2MTKmGP6mj30O5JvcrQCH83X4GaDrZOdmlqoUw7yELrHIMOAJ
DkKlDS89Kz9tQdeFqA/4BkgfKM3LocDgl+vokcanMwb8Z9dlEMNQC4O0jxfWVXk+
/FOOD+rkVDqLYfJFcgKTA2AFhyLcxIxK+FLvos5ou5bSSCydBuBMj9S+xteV2sLt
bKjdrWwlpV9Y+wnXhR/wJR8dXnq9GkguPrwGqoFxRkMNCfw3YpyznfgKqCh972No
12CakapdfGB4Mhyyi4hn0E5wQIMmX0PVzWThREkScKtsAx2FvKPX1TSAO+qaG19S
IT8Jrm+XUHmga9EIhQ8Sq3oX5hfnA5qhpQQUwCK/54hC1dzeJjZ/wXuNlNJ0oFWR
lcSvRv8l26Z1zr3uw37eXiSIgqNi1wezha+isaMHvSoJvr42nzfbR6yxsh67GNEY
4oJQM01IddkD6rBauYbBLKndcyeLeJCxF1Ok6UuNqKGAMNMysCJFXrEXWpjEQ+dS
8GL+/jbKca71l29JNjcbrvH4uWuP5vxTlpUPwTLpJu0KS4SI74gBSGNs24fL0g83
vS+bGrditF4nhQH8A8huK2Vi7pue4T+pR5jMH3Z/Y80VI2oPPu4cCYboE5GdSMkj
ifnIabecZ5KnSe/4KpZs
=IAuy
-----END PGP SIGNATURE-----

--n8g4imXOkfNTN/H1--
