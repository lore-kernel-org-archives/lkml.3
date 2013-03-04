Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091Ab3CDDfy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:35:54 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60679 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752080Ab3CDDfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:35:50 -0500
Message-ID: <1362368134.3768.289.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 019/150] serial_core: Fix type definition for
 PORT_BRCM_TRUMANAGE.
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Stephen Hurd <shurd@broadcom.com>, Michael Chan <mchan@broadcom.com>,
        linux-serial@vger.kernel.org
Date: Mon, 04 Mar 2013 03:35:34 +0000
In-Reply-To: <20130304024116.GA9309@kroah.com>
References: <20130226235523.930663721@linuxfoundation.org>
	 <20130226235526.246172467@linuxfoundation.org>
	 <1362009959.3768.85.camel@deadeye.wl.decadent.org.uk>
	 <20130228003906.GA3754@kroah.com>
	 <1362279084.3768.200.camel@deadeye.wl.decadent.org.uk>
	 <1362281921.3768.204.camel@deadeye.wl.decadent.org.uk>
	 <20130304024116.GA9309@kroah.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-GfdpUqa9eTkdg68hADmG"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-GfdpUqa9eTkdg68hADmG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-03-04 at 10:41 +0800, Greg Kroah-Hartman wrote:
> On Sun, Mar 03, 2013 at 03:38:41AM +0000, Ben Hutchings wrote:
> > I've queued up the following for 3.2.y.  Let me know if you see any
> > issue with this or want to ack it.
> >=20
> > Ben.
> >=20
> > ---
> > From: Ben Hutchings <ben@decadent.org.uk>
> > Subject: 8250: use correct value for PORT_BRCM_TRUMANAGE
> > Date: Sun, 03 Mar 2013 03:24:34 +0000
> >=20
> > When backporting commit ebebd49a8eab ('8250/16?50: Add support for
> > Broadcom TruManage redirected serial port') I took the next
> > available port type number for PORT_BRCM_TRUMANAGE (22).
> >=20
> > However, the 8250 port type numbers are exposed to userland through
> > the TIOC{G,S}SERIAL ioctls and so must remain stable.  Redefine
> > PORT_BRCM_TRUMANAGE as 25, matching mainline as of commit
> > 85f024401bf807.
> >=20
> > This leaves port types 22-24 within the valid range for 8250 but not
> > implemented there.  Change serial8250_verify_port() to specifically
> > reject these and change serial8250_type() to return "unknown" for them
> > (though I'm not sure why it would ever see them).
> >=20
> > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> > ---
> > --- a/drivers/tty/serial/8250.c
> > +++ b/drivers/tty/serial/8250.c
> > @@ -2695,7 +2695,7 @@ serial8250_verify_port(struct uart_port
> >  	if (ser->irq >=3D nr_irqs || ser->irq < 0 ||
> >  	    ser->baud_base < 9600 || ser->type < PORT_UNKNOWN ||
> >  	    ser->type >=3D ARRAY_SIZE(uart_config) || ser->type =3D=3D PORT_C=
IRRUS ||
> > -	    ser->type =3D=3D PORT_STARTECH)
> > +	    ser->type =3D=3D PORT_STARTECH || uart_config[ser->type].name =3D=
=3D NULL)
> >  		return -EINVAL;
> >  	return 0;
> >  }
> > @@ -2705,7 +2705,7 @@ serial8250_type(struct uart_port *port)
> >  {
> >  	int type =3D port->type;
> > =20
> > -	if (type >=3D ARRAY_SIZE(uart_config))
> > +	if (type >=3D ARRAY_SIZE(uart_config) || uart_config[type].name =3D=
=3D NULL)
>=20
> I don't think these two changes are really needed, as you point out
> above, no one should really see, or care, about this.  But if you do,
> these changes should go upstream first, right?

The change in serial8250_verify_port() is needed in 3.2 but not mainline
because types 22-24 won't be supported in 3.2.  I could alternately
define the PORT_* macros for these types and explicitly reject each of
those here.

The change in serial8250_type() is done for the same reason.  It already
has a check for out-of-range type which suggests there's some case where
the type might not have been validated by serial8250_verify_port().
Again, not needed upstream as all elements in uart_config have a
non-null name.

Ben.

> >  		type =3D 0;
> >  	return uart_config[type].name;
> >  }
> > --- a/include/linux/serial_core.h
> > +++ b/include/linux/serial_core.h
> > @@ -47,8 +47,8 @@
> >  #define PORT_U6_16550A	19	/* ST-Ericsson U6xxx internal UART */
> >  #define PORT_TEGRA	20	/* NVIDIA Tegra internal UART */
> >  #define PORT_XR17D15X	21	/* Exar XR17D15x UART */
> > -#define PORT_BRCM_TRUMANAGE	22
> > -#define PORT_MAX_8250	22	/* max port ID */
> > +#define PORT_BRCM_TRUMANAGE	25
> > +#define PORT_MAX_8250	25	/* max port ID */
>=20
> This one is good to have though, I have no objection to this hunk going
> into 3.2, for it, feel free to add:
> 	Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>=20
>=20

--=20
Ben Hutchings
Always try to do things in chronological order;
it's less confusing that way.

--=-GfdpUqa9eTkdg68hADmG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUTQWhue/yOyVhhEJAQqwvA//f3WrF06+fhCKck805gou7AOyWStYv2Pu
DP7D/Rm7HO0p6tW762YoYHuVhrGl75PPXwl8m2zzSRvqo/M+3OLMCoAejCEPgq5W
TTXyXBECH7Xy/zJoyg+JdpNfBhYRTkS0KtKNtcKRjY/4JhvZbnyoSZIQJzxY+ykf
kxTDezS9bnV1OYAOtA1TZTkc/iA0c0ooe1AyuuikAQvivPfJGzxiniJ+ajP8p3c3
wWPwN5bGa32TFHu/EthFonXyhdUltZittr+0c4Lu9kQI1bWp5agfyxSGB2uALNTO
s//kwaYSyEgERdB3tHkc5SoubCqOUbG0JevsIED/SKT7t3DoT5cIAQfqdTWFdJjy
NxiwiAmU1ktxJ7fVnwM9CqSwihqoFrak2myBH4HQv5IEwU3XuO3NIs1u5PaaC470
PpoT1JLDeL4bLvTZmktSByALNrAkiSSmrRuwq8juudOMFCWF7CC4Ng/qGLLqUZB3
ilrX4HuCo7DFdj6RDLxdK0kRB6+eXQnNYuk4WHCCbPwOgWqgs8yeTSBbMav+UMs7
Z3Zb4B96giu3lJ5KBWYconpjn2gGnSLJmhIjjG7T2TzSD3BnhVWIojP/xmmZsZDl
5DJv9tTw/gNF0jCOp2pQH1EIX4JpPCYAUZ3d2OmPadxJL1u30lYeRMSa5j3HIJ02
EU0EfghX8sY=
=sZMl
-----END PGP SIGNATURE-----

--=-GfdpUqa9eTkdg68hADmG--
