Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920AbaCOBhf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 21:37:35 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:56259 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752107AbaCOBhe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 21:37:34 -0400
Date: Fri, 14 Mar 2014 20:35:29 -0500
From: Felipe Balbi <balbi@ti.com>
To: "suresh.gupta@freescale.com" <suresh.gupta@freescale.com>
CC: "balbi@ti.com" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stefani Seibold <stefani@seibold.net>
Subject: Re: [PATCH] USB: Gadget: fsl driver pullup fix
Message-ID: <20140315013529.GB31520@saruman.home>
Reply-To: <balbi@ti.com>
References: <1394716255-26963-1-git-send-email-suresh.gupta@freescale.com>
 <20140313152517.GG4599@saruman.home>
 <797f2a4344754765a968250ef26f2b53@BN1PR03MB251.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="K8nIJk4ghYZn606h"
Content-Disposition: inline
In-Reply-To: <797f2a4344754765a968250ef26f2b53@BN1PR03MB251.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--K8nIJk4ghYZn606h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

(first of all, please fix your email client, we need the quotation
marks. See Documentation/email-clients.txt)

On Fri, Mar 14, 2014 at 08:53:24PM +0000, suresh.gupta@freescale.com wrote:
> > On Thu, Mar 13, 2014 at 06:40:55PM +0530, Suresh Gupta wrote:
> > > Attached is a small fix for the fsl usb gadget driver. This fix the=
=20
> > > driver in a way that the usb device will be only "pulled up" on=20
> > > requests like other usb gadget drivers do.
> > > This is necessary, because the device information is not always=20
> > > available until an application is up and running which provides this=
=20
> > > datas.
> > >=20
> > > Signed-off-by: Stefani Seibold <stefani@seibold.net>
> > > Signed-off-by: Suresh Gupta <suresh.gupta@freescale.com>
> > > ---
> > >  drivers/usb/gadget/fsl_udc_core.c | 38=20
> > > +++++++++++++++++++++-----------------
> > >  1 file changed, 21 insertions(+), 17 deletions(-)
> > >=20
> > > diff --git a/drivers/usb/gadget/fsl_udc_core.c=20
> > > b/drivers/usb/gadget/fsl_udc_core.c
> > > index 35cb972..9a93727 100644
> > > --- a/drivers/usb/gadget/fsl_udc_core.c
> > > +++ b/drivers/usb/gadget/fsl_udc_core.c
> > > @@ -153,6 +153,21 @@ static inline void fsl_set_accessors(struct=20
> > > fsl_usb2_platform_data *pdata) {}
> > >  /********************************************************************
> > >   *	Internal Used Function
> > >  ********************************************************************/
> > > +static int can_pullup(struct fsl_udc *udc) {
> > > +	return udc->driver && udc->softconnect && udc->vbus_active; }
> > > +
> > > +static void set_pullup(struct fsl_udc *udc) {
> > > +	if (can_pullup(udc))
> > > +		fsl_writel((fsl_readl(&dr_regs->usbcmd) | USB_CMD_RUN_STOP),
> > > +				&dr_regs->usbcmd);
> > > +	else
> > > +		fsl_writel((fsl_readl(&dr_regs->usbcmd) & ~USB_CMD_RUN_STOP),
> > > +				&dr_regs->usbcmd);
> > > +}
> >=20
> > why is this a "fix", you just re-factored some code into set_pullup().
> >
> [SuresH] I set udc->vbus_active and udc->softconnect to default value
> of 1 in struct_udc_setup. This was actual fix in this patch.  The

right, you see now why is it a problem to mix cleanups with fixes ? You
*never*, ever combine unrelated changes in a single patch. It makes it a
lot more difficult to see what you're actually changing. So, to start
with, this patch should (if it was correct) be split into two smaller
patches: one re-factoring the duplicated code into set_pullup() and
another which fixes vbus_active and softconnect flags.

But hang on, before you do that...

> can_pullup function return false when these values was not set and
> intern the code return without enabling the pullup and gadget
> controller stops.=20

So here's you mistake: the idea of can_pullup() (and thus, vbus_active
and softconnect flags) is to tell the driver "we're connet to a host,
it's safe to connect your pullups".

When you set both those flags to true, you're telling the driver that
you, indeed, are connected to a host. This might not be true if you
first boot up your platform, load all drivers and only after connect the
cable. In essence, you're lying to your driver and, as my mommy used to
say, "nobody likes a liar, my boy".

Curret situation isn't very good either since the driver is assuming
that cable is only plugged after driver is loaded, so it won't cope very
well with situation where cable is first plugged, then you apply power
to your board.

What you *really* need to do here is ask the HW for initial states of
those flags. During your probe() routine - as the name says - you
probe your HW to check its state (or to initialize its state), then you
ask "Hey IP, is VBUS above session valid threshold ?" Then you use the
HW's reply to initialize both flags, the way you want.

cheers

--=20
balbi

--K8nIJk4ghYZn606h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTI65hAAoJEIaOsuA1yqREp+EQAIjdcfisalhURfq61eE9mt1G
lyIUak9jIbUM2F6ao5MIQDas3P6fj+K80OIKEG7AULXdrLT5ycdJqadNdiESIPKl
pHndDY4we68FelyxBBjQUF1R141DTuWZUpBFhJqimWaxCZ3aC+dcutVIHaCIdRc/
kIY0vh3IR1h/mfJNMYdP7oTRP7z22A7P08WW+g3L1VMacBNL57j92ZmHHxwoxyWf
LAWBZ4pB0mOb1mMPejgdqPn8LihrQTvKkXu66T6LB2Lo72xk5wk9DxFYLbOAhxPg
x0LHjDX5YbnfdeoHU17evVcswekp57YdFuQ+UBhU8xWAg7FYNNy6BfzVeZhlIAbX
26p+5PnSzWw0NhFFYMusUaK6hG4CgxrNf+A3nsMjKzW6PZEGZNdziY9O9D2qoFz8
uz9L+TlQ4j4qhi60VkAsx5bW0yCRbgLOgpd2S0eyftKVg06FuY5b04vI0WSqMz5C
8eiMc8UwXXko+avxIq6yCpVI0B2PcaTTCOugP8htX/4J+5YQC/WwTW6e1kqH//O8
pI6xHeAcP+U0FU9gc4eeDN9MYGyGPcLEbhmvFj1Yt51ExOqj5kjwUcrhkJ6zpBcc
LDFZdpV48oRtQgHeUsKHneXkD9Y5yl2B83MB4tfoDiTxTvi4/TMEiijlPriVHlnv
00pf6ANOfzlc00oN0LIX
=ldQY
-----END PGP SIGNATURE-----

--K8nIJk4ghYZn606h--
