Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614Ab3BPJGy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 04:06:54 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:53067 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752477Ab3BPJGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 04:06:49 -0500
Date: Sat, 16 Feb 2013 11:06:37 +0200
From: Felipe Balbi <balbi@ti.com>
To: Simon Glass <sjg@chromium.org>
CC: LKML <linux-kernel@vger.kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Che-Liang Chiou <clchiou@chromium.org>
Subject: Re: [PATCH v4 3/6] mfd: Add ChromeOS EC I2C driver
Message-ID: <20130216090637.GB19639@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1360988172-15380-1-git-send-email-sjg@chromium.org>
 <1360988172-15380-4-git-send-email-sjg@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="R3G7APHDIzY6R/pk"
Content-Disposition: inline
In-Reply-To: <1360988172-15380-4-git-send-email-sjg@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--R3G7APHDIzY6R/pk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 15, 2013 at 08:16:09PM -0800, Simon Glass wrote:
> This uses an I2C bus to talk to the ChromeOS EC. The protocol
> is defined by the EC and is fairly simple, with a length byte,
> checksum, command byte and version byte (to permit easy creation
> of new commands).
>=20
> Signed-off-by: Simon Glass <sjg@chromium.org>
> Signed-off-by: Che-Liang Chiou <clchiou@chromium.org>

the driver you're adding here is no where near being an MFD device. MFD
children shouldn't be under drivers/mfd/. Please find a proper location
for this driver.

> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 837a16b..e1cd15e 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -29,6 +29,16 @@ config MFD_CROS_EC
>  	  You also ned to enable the driver for the bus you are using. The
>  	  protocol for talking to the EC is defined by the bus driver.
> =20
> +config MFD_CROS_EC_I2C
> +	tristate "ChromeOS Embedded Controller (I2C)"
> +	depends on MFD_CROS_EC && I2C
> +
> +	help
> +	  If you say here, you get support for talking to the ChromeOS EC

if you say what here ?

> diff --git a/drivers/mfd/cros_ec_i2c.c b/drivers/mfd/cros_ec_i2c.c
> new file mode 100644
> index 0000000..fe3f2bf
> --- /dev/null
> +++ b/drivers/mfd/cros_ec_i2c.c
> @@ -0,0 +1,262 @@
> +/*
> + * ChromeOS EC multi-function device (I2C)
> + *
> + * Copyright (C) 2012 Google, Inc
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/i2c.h>
> +#include <linux/interrupt.h>
> +#include <linux/mfd/cros_ec.h>
> +#include <linux/mfd/cros_ec_commands.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +
> +

one blank line only.

> +/* Since I2C can be unreliable, we retry commands */
> +#define COMMAND_MAX_TRIES 3

unreliable in what way ? Are you sure you haven't found a bug on your
embedded controller or your i2c controller driver ?

> +static const char *cros_ec_get_name(struct cros_ec_device *ec_dev)
> +{
> +	struct i2c_client *client =3D ec_dev->priv;
> +
> +	return client->name;
> +}

why ? What do you need get_name() for ? Why don't you just pass a
pointer to client->name directly ?

> +static const char *cros_ec_get_phys_name(struct cros_ec_device *ec_dev)
> +{
> +	struct i2c_client *client =3D ec_dev->priv;
> +
> +	return client->adapter->name;
> +}
> +
> +static struct device *cros_ec_get_parent(struct cros_ec_device *ec_dev)
> +{
> +	struct i2c_client *client =3D ec_dev->priv;
> +
> +	return &client->dev;
> +}

not sure you should allow other layers to fiddle with these. Specially
the parent device ointer.

> +static int cros_ec_probe_i2c(struct i2c_client *client,
> +			     const struct i2c_device_id *dev_id)
> +{
> +	struct device *dev =3D &client->dev;
> +	struct cros_ec_device *ec_dev =3D NULL;
> +	int err;
> +
> +	if (dev->of_node && !of_device_is_available(dev->of_node)) {
> +		dev_warn(dev, "Device disabled by device tree\n");
> +		return -ENODEV;
> +	}
> +
> +	ec_dev =3D cros_ec_alloc("I2C");

please don't use any indirection to allocators

> +	if (!ec_dev) {
> +		err =3D -ENOMEM;
> +		dev_err(dev, "cannot create cros_ec\n");

OOM messages are printed for you, no need to add another one here.

> +	i2c_set_clientdata(client, ec_dev);
> +	ec_dev->dev =3D dev;
> +	ec_dev->priv =3D client;
> +	ec_dev->irq =3D client->irq;
> +	ec_dev->command_xfer =3D cros_ec_command_xfer;
> +	ec_dev->get_name =3D cros_ec_get_name;
> +	ec_dev->get_phys_name =3D cros_ec_get_phys_name;
> +	ec_dev->get_parent =3D cros_ec_get_parent;
> +
> +	err =3D cros_ec_register(ec_dev);
> +	if (err) {
> +		dev_err(dev, "cannot register EC\n");
> +		goto fail_register;
> +	}

What is this doing ?

--=20
balbi

--R3G7APHDIzY6R/pk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRH0wdAAoJEIaOsuA1yqREeUUP/A9CzsJek9XjLBKOgR0AgNt6
CqG74YaI/HdRzZ6d7iV7/v7CO6UhnM+0jLdOSdFgz+BQv0M4QsmnK0u3+K+R40Zu
yreWGCS/6T9xkvv1IV8kMhsjoFK9qR8YF7fxcn/PLZIPB/ep81315AhFTPmF8S75
m7ANvhLylMOHMaz7cpQinvU+BLySkZm3cyi0Agu3aX6+QGe9NlWypkJfarl1cfaJ
y48OlVHKD4PKnJv5bfKFiWuBUhB6uQmAz0pg443aLBaNOy/1UgndlNxFt4KlL0N9
dHAxty8rONqLe73KnZZ98Moim9xtrwv0BNYJKNqr04wDH1Dj2t2v9hH69m0Lcrvg
l1J8dfpHve6ZCqTeqp665DQvMxxFXJ5+WyXZs43Og3jg4q8kd6qv5MkwYBf07GcO
9VZB1AwEr7fENrWktofCGD7uLJTaD0OMlWLtwKQcFeXDimvin02h9pVV1Mn9G8X0
5gmMNcsOFYKxP422rCMcLyf9rGWCR+mSpOCN7mrSxIQ8LP+465FjzTvC4yaWHlY6
lCl9HSn5Y6BuDr8sNULoj+dKMx55sr/brk3wusP7SEDfYqocyGJqmwBlN1psixn0
3sGyleCkHQeHAx78McFbNoYvpVg34HzKMs3KEPDe3dHLwUENOK2kSENetaVV5Ph5
U7pPJO3Er/U8NOS1KtYY
=cKSq
-----END PGP SIGNATURE-----

--R3G7APHDIzY6R/pk--
