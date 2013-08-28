Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051Ab3H1JjK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 05:39:10 -0400
Received: from sauhun.de ([89.238.76.85]:38882 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751616Ab3H1JjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 05:39:08 -0400
Date: Wed, 28 Aug 2013 11:38:58 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-i2c@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Zheng <lv.zheng@intel.com>, Aaron Lu <aaron.lu@intel.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 1/2] i2c: prepare runtime PM support for I2C client
 devices
Message-ID: <20130828093858.GF4086@katana>
References: <1377007416-13851-1-git-send-email-mika.westerberg@linux.intel.com>
 <1377007416-13851-2-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xaMk4Io5JJdpkLEb"
Content-Disposition: inline
In-Reply-To: <1377007416-13851-2-git-send-email-mika.westerberg@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xaMk4Io5JJdpkLEb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 20, 2013 at 05:03:35PM +0300, Mika Westerberg wrote:
> From: Aaron Lu <aaron.lu@intel.com>
>=20
> This patch adds runtime PM support for the I2C bus in a similar way that
> has been done for PCI bus already. This means that the I2C bus core
> prepares runtime PM for a client device just before a driver is about to =
be
> bound to it. Devices that are not bound to any driver are not prepared for
> runtime PM.
>=20
> In order to take advantage of this runtime PM support, the client device
> driver needs drop the device runtime PM reference count by calling
> pm_runtime_put() in its ->probe() callback and possibly implement rest of
> the runtime PM callbacks.
>=20
> However, this does not yet make runtime PM happen for the device, it has =
to
> be explicitly allowed from userspace per each I2C client device. The
> reason for this is that things like HID over I2C might not work as smooth=
ly
> when runtime PM is active. So we leave it to the user to balance between
> performance and power efficiency.
>=20
> User can allow runtime PM for the client device by running:
>=20
> 	# echo auto > /sys/bus/i2c/devices/<device>/power/control
>=20
> and it can be forbidden again by:
>=20
> 	# echo on > /sys/bus/i2c/devices/<device>/power/control
>=20
> Status of the device can be monitored by reading files under the device
> power directory.
>=20
> If the driver doesn't support runtime PM (like most of the existing I2C
> client drivers), the device in question is regarded as being runtime PM
> active and powered on.
>=20
> The patch adds also runtime PM support for the adapter device because it =
is
> needed to be able to runtime power manage the I2C controller device. The
> adapter device is handled along with the I2C controller device (it uses
> pm_runtime_no_callbacks()).
>=20
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

CCing ALKML. Would appreciate comments/tags from the runtime-PM users of
the ARM world.

> ---
>  drivers/i2c/i2c-core.c | 48 ++++++++++++++++++++++++++++++++++++++++++++=
+++-
>  1 file changed, 47 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
> index 3d44292..8fad5ac 100644
> --- a/drivers/i2c/i2c-core.c
> +++ b/drivers/i2c/i2c-core.c
> @@ -254,11 +254,34 @@ static int i2c_device_probe(struct device *dev)
>  					client->flags & I2C_CLIENT_WAKE);
>  	dev_dbg(dev, "probe\n");
> =20
> +	/* Make sure the adapter is active */
> +	pm_runtime_get_sync(&client->adapter->dev);
> +
> +	/*
> +	 * Enable runtime PM for the client device. If the client wants to
> +	 * participate on runtime PM it should call pm_runtime_put() in its
> +	 * probe() callback.
> +	 *
> +	 * User still needs to allow the PM runtime before it can actually
> +	 * happen.
> +	 */
> +	pm_runtime_forbid(&client->dev);
> +	pm_runtime_get_noresume(&client->dev);
> +	pm_runtime_set_active(&client->dev);
> +	pm_runtime_enable(&client->dev);
> +
>  	status =3D driver->probe(client, i2c_match_id(driver->id_table, client)=
);
>  	if (status) {
>  		client->driver =3D NULL;
>  		i2c_set_clientdata(client, NULL);
> +
> +		pm_runtime_disable(&client->dev);
> +		pm_runtime_set_suspended(&client->dev);
> +		pm_runtime_put_noidle(&client->dev);
>  	}
> +
> +	pm_runtime_put(&client->adapter->dev);
> +
>  	return status;
>  }
> =20
> @@ -271,6 +294,8 @@ static int i2c_device_remove(struct device *dev)
>  	if (!client || !dev->driver)
>  		return 0;
> =20
> +	pm_runtime_get_sync(&client->adapter->dev);
> +
>  	driver =3D to_i2c_driver(dev->driver);
>  	if (driver->remove) {
>  		dev_dbg(dev, "remove\n");
> @@ -283,6 +308,13 @@ static int i2c_device_remove(struct device *dev)
>  		client->driver =3D NULL;
>  		i2c_set_clientdata(client, NULL);
>  	}
> +
> +	/* Undo the runtime PM done in i2c_probe() */
> +	pm_runtime_disable(&client->dev);
> +	pm_runtime_set_suspended(&client->dev);
> +	pm_runtime_put_noidle(&client->dev);
> +
> +	pm_runtime_put(&client->adapter->dev);
>  	return status;
>  }
> =20
> @@ -294,8 +326,11 @@ static void i2c_device_shutdown(struct device *dev)
>  	if (!client || !dev->driver)
>  		return;
>  	driver =3D to_i2c_driver(dev->driver);
> -	if (driver->shutdown)
> +	if (driver->shutdown) {
> +		pm_runtime_get_sync(&client->adapter->dev);
>  		driver->shutdown(client);
> +		pm_runtime_put(&client->adapter->dev);
> +	}
>  }
> =20
>  #ifdef CONFIG_PM_SLEEP
> @@ -1263,6 +1298,15 @@ exit_recovery:
>  	bus_for_each_drv(&i2c_bus_type, NULL, adap, __process_new_adapter);
>  	mutex_unlock(&core_lock);
> =20
> +	/*
> +	 * Make sure the adapter runtime PM follows the parent device (the
> +	 * host controller) so that we can suspend it once there aren't any
> +	 * active clients anymore.
> +	 */
> +	pm_runtime_set_active(&adap->dev);
> +	pm_runtime_no_callbacks(&adap->dev);
> +	pm_runtime_enable(&adap->dev);
> +
>  	return 0;
> =20
>  out_list:
> @@ -1427,6 +1471,8 @@ void i2c_del_adapter(struct i2c_adapter *adap)
>  		return;
>  	}
> =20
> +	pm_runtime_disable(&adap->dev);
> +
>  	/* Tell drivers about this removal */
>  	mutex_lock(&core_lock);
>  	bus_for_each_drv(&i2c_bus_type, NULL, adap,
> --=20
> 1.8.4.rc2
>=20

--xaMk4Io5JJdpkLEb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSHcUxAAoJEBQN5MwUoCm2wuoP/0Wy4O1hMBxaGONYusjkdjph
ccAcDh/kGcwQD9/9Wp6bhV9MwQi0W+No4lEFQzk+hzTARafdJ/C4ZZEOsNNuQyOO
0WxqW9GgianfpSSqlc/T0XFu24stgSrSyMW5r5vqP3IUaja6vu91rLVl3uxWwtIA
+frpp4Ip/v9yiKIy1PEgGN3wL6YX95A/L44U3O0KfssgyHtXpUyq+lrnhu+bT6qx
Z/9gJ12Z6jFZ+vA/4H53plMbe817Jn5XjDPioGLqHHMktWQ18rXVLF9eCLebNz9e
aywH4T6A1NiNXXVr6wNe5IXk7o9igHfUm1lM6/OBKJYgigReSp56e82uK3VpoGkS
iHnnrYJECYWKr+b2WKRrbKSAyixYF1IzUiDuhVl9vbnWXd8CgYNFFYOCzDDB1C8N
SkyEW5lE638Jcz5OKU2Z3aXh4dlgeAUmlRtBi3L+T8ICgqC2c7s+OdRgwYksJEAx
FsxE/3yqvxstqig1R2Z9ZEFL9TPKFao8H2eYIFhrwXjFUTkc8w+PC3VtYlpGrLdQ
+jPzvH9YyiSQ6+luEmnZMPAME/sGH4TEKwEFzFpRameMqtRIYTfgUI/q4bMBBmw2
Oirwc1jBZXYrJwCGAPcx6Kt7lWV8FumwAb+wl0dB2o3J7gfC6eEPCrTwFeT9jVm1
v36QU1/snCqS7+wDB53f
=sQ6r
-----END PGP SIGNATURE-----

--xaMk4Io5JJdpkLEb--
