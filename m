Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212Ab3LQCO5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 21:14:57 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:46011 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab3LQCO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 21:14:56 -0500
Date: Mon, 16 Dec 2013 20:14:16 -0600
From: Felipe Balbi <balbi@ti.com>
To: Apelete Seketeli <apelete@seketeli.net>
CC: Felipe Balbi <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH 3/3] usb: musb: fix setting JZ4740 gadget periphal mode
 on reset
Message-ID: <20131217021416.GA21787@saruman.home>
Reply-To: <balbi@ti.com>
References: <1386992918-1531-1-git-send-email-apelete@seketeli.net>
 <1386992918-1531-4-git-send-email-apelete@seketeli.net>
 <20131216212056.GE12896@saruman.home>
 <20131217013100.GX4581@hermes>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
Content-Disposition: inline
In-Reply-To: <20131217013100.GX4581@hermes>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Dec 17, 2013 at 02:31:00AM +0100, Apelete Seketeli wrote:
> On 16-Dec-13, Felipe Balbi wrote:
> > On Sat, Dec 14, 2013 at 04:48:38AM +0100, Apelete Seketeli wrote:
> > > JZ4740 USB Device Controller is not OTG compatible and does not have =
DEVCTL
> > > register in silicon.
> > >=20
> > > During ethernet-over-usb transactions, on reset, musb driver tries to
> > > read from DEVCTL and consequently sets device as host (A-Device)
> > > instead of peripheral (B-Device), which makes it a composite device to
> > > the USB gadget driver.
> > > This induces a kernel panic during power down where the USB gadget
> > > driver does a null pointer dereference when trying to access the
> > > composite device configuration.
> > >=20
> > > On reset, do not rely on DEVCTL value for setting gadget peripheral
> > > mode: hardcode it instead to B-Device.
> > >=20
> > > Signed-off-by: Apelete Seketeli <apelete@seketeli.net>
> > > ---
> > >  drivers/usb/musb/musb_gadget.c |    9 +++++++++
> > >  1 file changed, 9 insertions(+)
> > >=20
> > > diff --git a/drivers/usb/musb/musb_gadget.c b/drivers/usb/musb/musb_g=
adget.c
> > > index 32fb057..b4bea7a 100644
> > > --- a/drivers/usb/musb/musb_gadget.c
> > > +++ b/drivers/usb/musb/musb_gadget.c
> > > @@ -2119,6 +2119,14 @@ __acquires(musb->lock)
> > >  	/* Normal reset, as B-Device;
> > >  	 * or else after HNP, as A-Device
> > >  	 */
> > > +#if defined(CONFIG_USB_MUSB_JZ4740) || defined(CONFIG_USB_MUSB_JZ474=
0_MODULE)
> >=20
> > NAK, no ifdefs in this driver. Pass a quirk flag through platform_data
> > or something similar.
>=20
> I get that, makes sense to me, but problem is the driver has to read a
> valid value from DEVCTL hardware register when musb_g_reset() is
> called, and I do not see how this can be achieved through
> platform_data.

why not ?

	/*
	 * JZ4740 UDC Controller is not OTG compatible as does not
	 * have a DEVCTL register in silicon. Due to that, we must
	 * NOT rely on that register for setting peripheral mode.
	 */
	if (unlikely(musb->quirk_broken_devctl)) {
		musb->xceiv->state =3D OTG_STATE_B_PERIPHERAL;
		musb->g_is_a_peripheral =3D 0;
	else if (devctl & MUSB_DEVCTL_BDEVICE) {
		musb->xceiv->state =3D OTG_STATE_B_PERIPHERAL;
		musb->g_is_a_peripheral =3D 0;
	} else {
		musb->xceiv->state =3D OTG_STATE_A_PERIPHERAL;
		musb->g_is_a_peripheral =3D 1;
	}

> Is it ok to use ifdefs in musb_regs.h to add specific hardware
> register indexes for JZ4740 instead ?

you guys changed the register file ? Why ? Is my pain not enough
already ? :-p

> I am actually thinking about fooling the musb driver into reading a
> valid value from another register instead of DEVCTL.

which register would that be ? If the register file is different, we
need to find a way to support it, but you gotta fix a few other things
first before I look into that, I don't want to see any more hacks and
ifdeffery hell around this driver. It's already painful enough to
support all HW variants it already supports.

cheers

--=20
balbi

--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSr7N4AAoJEIaOsuA1yqRElcMQAKonHq9qcg2Nq9r7EzkL+Gwn
yz02yp24bd/EVDG2VE5nfRIXD4GxygAmg6zVEciAaOqHSBl/AVLmzjaTT//+8zFd
TITA7Khi7MzIKKISZ09osJVpeEWY9nGb9fEBEOl0c9QWPE2gZ7FnGmKBTN3v8dI6
VGlrzBlHet47/7ssATMv/vAAOmcl6gcFRTsyt+3OZkovgM+j3tDzgZ3rHriB5auj
1iiPjc6+6VgfIPucb7XYyCMAxT/QZMDGHisrMIC/FipN+mLGc1/C/vXEbXfMGZEd
5zpJqYuUACcvSD8P04u4xbSfKUffPRZ0zQMdN2YvyZ5gMKpO96tlw1r6N46jiS02
odyuHQrRobqe2sZE4bRqLmjibyNPdDR6tpNIl9wWi5uWVaYVjlAgOP4G8Jdfvna7
uqmvL+50KMN97ZpH3LDaiCWjeB+h+s8/Ky2ZLrHAaxx1xco03N6AoLE1kvJsMJDR
OgDghhoF+rN9aCRRb4DA8MuIs/D1y1EcbEOQNmlKhqe0A2n5raMH5Ht/uMLKzStI
Av8Yji3r7+ELPpbGTl3CUlsT6M4nuNjQ9oadkRKVpyAxa9eQvHcJ7PUMMm78vGMm
1c7CNDa8iclTvEIsbwmd55f5wxdGGEgwRuIBEfXymdVlR+K1sRbzzgo66Bd+OsTX
RM454wLlICp4GIaT2IKd
=vseH
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--
