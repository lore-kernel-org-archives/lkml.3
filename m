Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbaLUKUf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 05:20:35 -0500
Received: from mail.kernel.org ([198.145.19.201]:47289 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111AbaLUKU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 05:20:29 -0500
Date: Sun, 21 Dec 2014 11:20:19 +0100
From: Sebastian Reichel <sre@kernel.org>
To: NeilBrown <neilb@suse.de>
Cc: Mark Rutland <mark.rutland@arm.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>, Jiri Slaby <jslaby@suse.cz>,
        GTA04 owners <gta04-owner@goldelico.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] TTY: add support for "tty slave" devices.
Message-ID: <20141221102017.GA18161@earth.universe>
References: <20141219235827.13943.45713.stgit@notabene.brown>
 <20141220000920.13943.22511.stgit@notabene.brown>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="T4sUOijqQbZv57TR"
Content-Disposition: inline
In-Reply-To: <20141220000920.13943.22511.stgit@notabene.brown>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Neil,

On Sat, Dec 20, 2014 at 11:09:20AM +1100, NeilBrown wrote:
> A "tty slave" is a device connected via UART.
> It may need a driver to, for example, power the device on
> when the tty is opened, and power it off when the tty
> is released.

How about (reads a bit easier to me, but I'm not a
native speaker):

Such a device may need its own driver, e.g. for powering
it up on tty open and powering it down on tty release.

> A "tty slave" is a platform device which is declared as a
> child of the uart in device-tree:

maybe make this into its own device class instead of making
it a platform device?

> &uart1 {
> 	bluetooth {
> 		compatible =3D "wi2wi,w2cbw003";
> 		vdd-supply =3D <&vaux4>;
> 	};
> };
>=20
> The driver can attach to the tty by calling
>    tty_set_slave(dev->parent, dev, &slave_ops);

this could be handled by the tty core if a custom tty slave device
class is used (similar to spi_device for spi slaves or i2c_client
for i2c slaves).

> where slave_ops' is a set of interface that
> the tty layer must call when appropriate.
> Currently only 'open' and 'release' are defined.
> They are called at first open and last close.
> They cannot fail.
>=20
> Signed-off-by: NeilBrown <neilb@suse.de>
> ---
>  .../devicetree/bindings/serial/of-serial.txt       |    4 +
>  drivers/tty/tty_io.c                               |   73 ++++++++++++++=
+++++-
>  include/linux/tty.h                                |   16 ++++
>  3 files changed, 90 insertions(+), 3 deletions(-)
>=20
> diff --git a/Documentation/devicetree/bindings/serial/of-serial.txt b/Doc=
umentation/devicetree/bindings/serial/of-serial.txt
> index 8c4fd0332028..fc5d00c3c474 100644
> --- a/Documentation/devicetree/bindings/serial/of-serial.txt
> +++ b/Documentation/devicetree/bindings/serial/of-serial.txt
> @@ -39,6 +39,10 @@ Optional properties:
>    driver is allowed to detect support for the capability even without th=
is
>    property.
> =20
> +Optional child node:
> +- a platform device listed as a child node will be probed and can
> +  register with the tty for open/close events to manage power.
> +

Drop the Linux specific bits and add the requirement of a compatible
value here. Suggestion:

Optional child node:
  A slave device connected to the serial port. It must contain at
  least a compatible property with a name string following generic
  names recommended practice.

>  Example:
> =20
>  	uart@80230000 {
> diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
> index 0508a1d8e4cd..6c67a3fd257e 100644
> --- a/drivers/tty/tty_io.c
> +++ b/drivers/tty/tty_io.c
> @@ -95,6 +95,7 @@
>  #include <linux/seq_file.h>
>  #include <linux/serial.h>
>  #include <linux/ratelimit.h>
> +#include <linux/of_platform.h>
> =20
>  #include <linux/uaccess.h>
> =20
> @@ -110,6 +111,13 @@
>  #define TTY_PARANOIA_CHECK 1
>  #define CHECK_TTY_COUNT 1
> =20
> +struct tty_device {
> +	struct device dev;
> +
> +	struct tty_slave_operations *slave_ops;
> +	struct device *slave;
> +};
> +
>  struct ktermios tty_std_termios =3D {	/* for the benefit of tty drivers =
 */
>  	.c_iflag =3D ICRNL | IXON,
>  	.c_oflag =3D OPOST | ONLCR,
> @@ -1825,6 +1833,17 @@ int tty_release(struct inode *inode, struct file *=
filp)
>  				__func__, tty->count, tty_name(tty, buf));
>  		tty->count =3D 0;
>  	}
> +	if (tty->dev && tty->count =3D=3D 0) {
> +		struct tty_device *ttyd =3D container_of(tty->dev,
> +						       struct tty_device,
> +						       dev);
> +		if (ttyd->slave) {
> +			mutex_lock(&ttyd->dev.mutex);
> +			if (ttyd->slave)
> +				ttyd->slave_ops->release(ttyd->slave, tty);
> +			mutex_unlock(&ttyd->dev.mutex);
> +		}
> +	}
> =20
>  	/*
>  	 * We've decremented tty->count, so we need to remove this file
> @@ -2105,6 +2124,18 @@ retry_open:
>  		goto retry_open;
>  	}
>  	clear_bit(TTY_HUPPED, &tty->flags);
> +	if (tty->dev && tty->count =3D=3D 1) {
> +		struct tty_device *ttyd =3D container_of(tty->dev,
> +						       struct tty_device,
> +						       dev);
> +		if (ttyd->slave) {
> +			mutex_lock(&ttyd->dev.mutex);
> +			if (ttyd->slave &&
> +			    ttyd->slave_ops->open)
> +				ttyd->slave_ops->open(ttyd->slave, tty);
> +			mutex_unlock(&ttyd->dev.mutex);
> +		}
> +	}
>  	tty_unlock(tty);
> =20
> =20
> @@ -3168,6 +3199,7 @@ struct device *tty_register_device_attr(struct tty_=
driver *driver,
>  {
>  	char name[64];
>  	dev_t devt =3D MKDEV(driver->major, driver->minor_start) + index;
> +	struct tty_device *tty_dev;
>  	struct device *dev =3D NULL;
>  	int retval =3D -ENODEV;
>  	bool cdev =3D false;
> @@ -3190,12 +3222,12 @@ struct device *tty_register_device_attr(struct tt=
y_driver *driver,
>  		cdev =3D true;
>  	}
> =20
> -	dev =3D kzalloc(sizeof(*dev), GFP_KERNEL);
> -	if (!dev) {
> +	tty_dev =3D kzalloc(sizeof(*tty_dev), GFP_KERNEL);
> +	if (!tty_dev) {
>  		retval =3D -ENOMEM;
>  		goto error;
>  	}
> -
> +	dev =3D &tty_dev->dev;
>  	dev->devt =3D devt;
>  	dev->class =3D tty_class;
>  	dev->parent =3D device;
> @@ -3207,6 +3239,12 @@ struct device *tty_register_device_attr(struct tty=
_driver *driver,
>  	retval =3D device_register(dev);
>  	if (retval)
>  		goto error;
> +	if (device && device->of_node)
> +		/* Children are platform devices and can register
> +		 * for various call-backs on tty operations.
> +		 */
> +		of_platform_populate(device->of_node, NULL, NULL, dev);
> +
> =20
>  	return dev;
> =20
> @@ -3238,6 +3276,35 @@ void tty_unregister_device(struct tty_driver *driv=
er, unsigned index)
>  }
>  EXPORT_SYMBOL(tty_unregister_device);
> =20
> +int tty_set_slave(struct device *tty, struct device *slave,
> +		  struct tty_slave_operations *ops)
> +{
> +	struct tty_device *ttyd =3D container_of(tty, struct tty_device, dev);
> +	int err;
> +	if (tty->class !=3D tty_class)
> +		return -ENODEV;
> +	if (ttyd->slave)
> +		err =3D -EBUSY;
> +	else {
> +		ttyd->slave =3D slave;
> +		ttyd->slave_ops =3D ops;
> +		err =3D 0;
> +	}
> +	return err;
> +}
> +EXPORT_SYMBOL_GPL(tty_set_slave);
> +
> +void tty_clear_slave(struct device *tty, struct device *slave)
> +{
> +	struct tty_device *ttyd =3D container_of(tty, struct tty_device, dev);
> +
> +	WARN_ON(ttyd->slave !=3D slave);
> +	ttyd->slave =3D NULL;
> +	ttyd->slave_ops =3D NULL;
> +}
> +EXPORT_SYMBOL_GPL(tty_clear_slave);
> +
> +
>  /**
>   * __tty_alloc_driver -- allocate tty driver
>   * @lines: count of lines this driver can handle at most
> diff --git a/include/linux/tty.h b/include/linux/tty.h
> index 5171ef8f7b85..fab8af995bd3 100644
> --- a/include/linux/tty.h
> +++ b/include/linux/tty.h
> @@ -299,6 +299,22 @@ struct tty_file_private {
>  	struct list_head list;
>  };
> =20
> +/* A "tty slave" device is permanently attached to a tty, typically
> + * via a UART.
> + * The driver can register for notifications for power management
> + * etc.  Any operation can be NULL.
> + * Operations are called under dev->mutex for the tty device.
> + */
> +struct tty_slave_operations {
> +	/* 'open' is called when the device is first opened */
> +	void (*open)(struct device *slave, struct tty_struct *tty);
> +	/* 'release' is called on last close */
> +	void (*release)(struct device *slave, struct tty_struct *tty);
> +};

Something like the following would be really useful for remote
devices, that can/must be woken up from idle states via an GPIO
(e.g.  the bluetooth chip from the Nokia N900):

/* 'write' is called when data should be sent to the remote device */
void (*write)(struct device *slave, struct tty_struct *tty);

The same kind of GPIO exists for waking up the host's UART chip from
idle, but that can simply be implemented by incrementing the runtime
usage of the tty_slave's parent device :)

> +int tty_set_slave(struct device *tty, struct device *slave,
> +		  struct tty_slave_operations *ops);
> +void tty_clear_slave(struct device *tty, struct device *slave);
> +
>  /* tty magic number */
>  #define TTY_MAGIC		0x5401

-- Sebastian

--T4sUOijqQbZv57TR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUlp7eAAoJENju1/PIO/qaHpwP/Ar4umPu5EZACQxUhIoDWkw7
eSJPycLetOVfZ00hqOWf3mpjflT41SmD+Q3uI1M6adQjPF3XIpS9lle3ayVPsk+S
+BVVA/H3B8OYK5ppPCQ6TrEqSGiZI5BgCfoIZYZLFoAS9TJvs9lsENMjUK65IARx
RTIfNn2lr/d1pnYTIU+lvPVQap/QEryGgW1pJn13wJGWzRlcluuAOAECcm2RrIqg
wBhL47qRkThaDPsIuhFgpz130Pzw9r4k9fmzRQDPYKxigLvl//DGPFCA29kPw4W5
ITx/nRKG2g6CzY8i8jpy2yG9DGaTKi1AJsDg5Zf7bvTmF/tyxk3lglzw0GrYpfnE
1FsDW4TZTMDnOmA1fON+jA6Ms18a3eA2RLDP+/IfcqJspKLndxFwfnScxqKBPCYm
qu+3gOsSt7Y43J37zNq++H6XOw3ULVFInVRc2+aYHdLSzhUpAsTT5m8RrpJhWb2r
qR3iwLKWHUwwyh3LwyIz3ZSvODTaVtubog+BomatNRUOAe7zigGpl1KvQS5gjeND
3EXuqfQlnC1Yka3zCR4VEBVonYLdwDW/Dox9h1RL1gSQdP7DJdKjeqqr0VwPnxwn
SOdWJ5gySX5lDGyMIf8a+OMK3MDDPMg3tuyY3Q8PBZbtGZ3IpiiurpOHuHgk6Mqg
l0tcpGbvwVSAoNoHuMY0
=WQd6
-----END PGP SIGNATURE-----

--T4sUOijqQbZv57TR--
