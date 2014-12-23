Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608AbaLWFQu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 00:16:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35872 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753805AbaLWFQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 00:16:48 -0500
Date: Tue, 23 Dec 2014 16:16:35 +1100
From: NeilBrown <neilb@suse.de>
To: Sebastian Reichel <sre@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>, Jiri Slaby <jslaby@suse.cz>,
        GTA04 owners <gta04-owner@goldelico.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] TTY: add support for "tty slave" devices.
Message-ID: <20141223161635.1ba78491@notabene.brown>
In-Reply-To: <20141221102017.GA18161@earth.universe>
References: <20141219235827.13943.45713.stgit@notabene.brown>
	<20141220000920.13943.22511.stgit@notabene.brown>
	<20141221102017.GA18161@earth.universe>
X-Mailer: Claws Mail 3.10.1-162-g4d0ed6 (GTK+ 2.24.25; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/k8kStFxBN+00SVipbunjDtS"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/k8kStFxBN+00SVipbunjDtS
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 21 Dec 2014 11:20:19 +0100 Sebastian Reichel <sre@kernel.org> wrote:

> Hi Neil,
>=20
> On Sat, Dec 20, 2014 at 11:09:20AM +1100, NeilBrown wrote:
> > A "tty slave" is a device connected via UART.
> > It may need a driver to, for example, power the device on
> > when the tty is opened, and power it off when the tty
> > is released.
>=20
> How about (reads a bit easier to me, but I'm not a
> native speaker):
>=20
> Such a device may need its own driver, e.g. for powering
> it up on tty open and powering it down on tty release.

Yes, that does read better - thanks.

>=20
> > A "tty slave" is a platform device which is declared as a
> > child of the uart in device-tree:
>=20
> maybe make this into its own device class instead of making
> it a platform device?

Did you mean "class" or "bus"?? or "type".  I'm going to have to figure out
exactly what role each of those has.

In any case, the real question is "why?".  Where is the gain?

>=20
> > &uart1 {
> > 	bluetooth {
> > 		compatible =3D "wi2wi,w2cbw003";
> > 		vdd-supply =3D <&vaux4>;
> > 	};
> > };
> >=20
> > The driver can attach to the tty by calling
> >    tty_set_slave(dev->parent, dev, &slave_ops);
>=20
> this could be handled by the tty core if a custom tty slave device
> class is used (similar to spi_device for spi slaves or i2c_client
> for i2c slaves).

spi_device seems to be a 'bus' device - spi_bus_type.

i2_client is also a 'bus' device - i2c_bus_type.  But there is also an
i2c_client_type.

Having a specific bus type (rather than the more generic 'platform') allows
these drivers to use the functionality of the bus to access the device.
e.g. the probe function of an i2c device gets a 'struct i2c_client' handle =
to
send commands  to the device.

But that is not the functionality that my 'tty slave' needs.  The driver
doesn't want to access the bus (the parent) - rather we need to arrange for
the parent (the uart/tty) to access the slave driver.

i.e. even if we had a 'serial bus', we would still need to register some
call-backs with the parent.  I don't see that the 'bus' model provides any
particular simplified way to do this.

If there were a 'tty_client' bus type, I would expect it to behave a lot li=
ke
the current "line disciplines".  They use the tty as a bus to provide a
higher-level channel to a specific uart attached device such as an hci
interface to a bluetooth module.

I has occasionally been suggested that the functionality I want should be
implemented as a line discipline.  As I understand it, the line discipline
cannot be imposed until you open the device, which make it too late for me.=
..


Note that I'm not convinced that I have the model correct - I just don't see
how the change you suggest would be an improvement.

>=20
> > where slave_ops' is a set of interface that
> > the tty layer must call when appropriate.
> > Currently only 'open' and 'release' are defined.
> > They are called at first open and last close.
> > They cannot fail.
> >=20
> > Signed-off-by: NeilBrown <neilb@suse.de>
> > ---
> >  .../devicetree/bindings/serial/of-serial.txt       |    4 +
> >  drivers/tty/tty_io.c                               |   73 ++++++++++++=
+++++++-
> >  include/linux/tty.h                                |   16 ++++
> >  3 files changed, 90 insertions(+), 3 deletions(-)
> >=20
> > diff --git a/Documentation/devicetree/bindings/serial/of-serial.txt b/D=
ocumentation/devicetree/bindings/serial/of-serial.txt
> > index 8c4fd0332028..fc5d00c3c474 100644
> > --- a/Documentation/devicetree/bindings/serial/of-serial.txt
> > +++ b/Documentation/devicetree/bindings/serial/of-serial.txt
> > @@ -39,6 +39,10 @@ Optional properties:
> >    driver is allowed to detect support for the capability even without =
this
> >    property.
> > =20
> > +Optional child node:
> > +- a platform device listed as a child node will be probed and can
> > +  register with the tty for open/close events to manage power.
> > +
>=20
> Drop the Linux specific bits and add the requirement of a compatible
> value here. Suggestion:
>=20
> Optional child node:
>   A slave device connected to the serial port. It must contain at
>   least a compatible property with a name string following generic
>   names recommended practice.

That looks good, thanks.

>=20
> >  Example:
> > =20
> >  	uart@80230000 {
> > diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
> > index 0508a1d8e4cd..6c67a3fd257e 100644
....
> > diff --git a/include/linux/tty.h b/include/linux/tty.h
> > index 5171ef8f7b85..fab8af995bd3 100644
> > --- a/include/linux/tty.h
> > +++ b/include/linux/tty.h
> > @@ -299,6 +299,22 @@ struct tty_file_private {
> >  	struct list_head list;
> >  };
> > =20
> > +/* A "tty slave" device is permanently attached to a tty, typically
> > + * via a UART.
> > + * The driver can register for notifications for power management
> > + * etc.  Any operation can be NULL.
> > + * Operations are called under dev->mutex for the tty device.
> > + */
> > +struct tty_slave_operations {
> > +	/* 'open' is called when the device is first opened */
> > +	void (*open)(struct device *slave, struct tty_struct *tty);
> > +	/* 'release' is called on last close */
> > +	void (*release)(struct device *slave, struct tty_struct *tty);
> > +};
>=20
> Something like the following would be really useful for remote
> devices, that can/must be woken up from idle states via an GPIO
> (e.g.  the bluetooth chip from the Nokia N900):
>=20
> /* 'write' is called when data should be sent to the remote device */
> void (*write)(struct device *slave, struct tty_struct *tty);
>=20
> The same kind of GPIO exists for waking up the host's UART chip from
> idle, but that can simply be implemented by incrementing the runtime
> usage of the tty_slave's parent device :)

I agree that could be useful.
I've also toyed with the idea of a 'recv' callback which tells the driver
whenever data is received.  That would confirm that the device is 'on'.
I couldn't convince myself that it was *really* useful and left it out for
simplicity.

Either could certainly be added, but I don't want to add some interface that
doesn't have an immediate user - the risk of choose imperfect semantics is
too high.

>=20
> > +int tty_set_slave(struct device *tty, struct device *slave,
> > +		  struct tty_slave_operations *ops);
> > +void tty_clear_slave(struct device *tty, struct device *slave);
> > +
> >  /* tty magic number */
> >  #define TTY_MAGIC		0x5401
>=20
> -- Sebastian

Thanks a lot for the review.

NeilBrown

--Sig_/k8kStFxBN+00SVipbunjDtS
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVJj6sznsnt1WYoG5AQKK6Q//bgt5icmrOAcBTUAnGB39th/vxNbYUZG0
jAWMHLam9wKgZYaFldody0qtWnIY6uQzQdbGEM9XYnQyIzx3iH4qTUBCO6NIVWWl
mfP2RiOggdAye6NPaepUIoPTE1jLnCaGuO83GQ5PcJvfNIIfhhlHXh1GxC+veBsB
e8zOhoKimVf7Z7BQkXt0Qj9YI9vjtBS1JEgYyU4IhnjdKW3TnovKS3azoK/Thq78
szT/HCh5XcnX9/A7L0VsoSj3GxGIIDtdgwPrT9ycKBHv801/jxxsRZumyeC9WBYF
PG7NV5xquy7HJS3p1D2YQZlkWbOXsDdWPAsONm0O5iFsTDs6OQmoCUJ7ICAi/SoI
uWV0C62RAgY5qRz4CTFknVIIa7/xtsbHLFs1uH9dyoIegLgK8veL5cCFZ2Ql8TZC
DJJ2AxTGMokAoFNkf2DMJA8rpqr2XROQMOgNpsreFvfySrPr+8+hx3avnZ2ksDBT
I+39v4+hHu4tNGynC6Ai1D07Ks0HOZenjzJaHjFnJKYcpCt6tsWVw0OZIPLaQnGS
84k6zATHbG97aD0WrKeyu5rLjsUOdt3fd10W0VqKWwavGkLYT65mAVnFEc7yx/tx
3yIc934jWcgjH+h1hM8ybyfBikz9/Ye2raqCfjB/SBlEuTRX4IsNEIo/xqAnOLZ7
zcWeNOZa0NY=
=K+jz
-----END PGP SIGNATURE-----

--Sig_/k8kStFxBN+00SVipbunjDtS--
