Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967444AbaLKW7B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 17:59:01 -0500
Received: from mail.kernel.org ([198.145.19.201]:57799 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967420AbaLKW6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 17:58:55 -0500
Date: Thu, 11 Dec 2014 23:58:48 +0100
From: Sebastian Reichel <sre@kernel.org>
To: NeilBrown <neilb@suse.de>
Cc: Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Rutland <mark.rutland@arm.com>, Jiri Slaby <jslaby@suse.cz>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] TTY: add slave driver to power-on device via a
 regulator.
Message-ID: <20141211225847.GB11666@earth.universe>
References: <20141211214801.4127.93914.stgit@notabene.brown>
 <20141211215944.4127.4186.stgit@notabene.brown>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="gj572EiMnwbLXET9"
Content-Disposition: inline
In-Reply-To: <20141211215944.4127.4186.stgit@notabene.brown>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gj572EiMnwbLXET9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Dec 12, 2014 at 08:59:44AM +1100, NeilBrown wrote:
> The regulator is identified in devicetree as 'vdd-supply'

long description is kind of useless...

> Signed-off-by: NeilBrown <neilb@suse.de>
> ---
>  .../devicetree/bindings/serial/slave-reg.txt       |   18 ++++
>  drivers/tty/Kconfig                                |    2=20
>  drivers/tty/Makefile                               |    1=20
>  drivers/tty/slaves/Kconfig                         |   12 ++
>  drivers/tty/slaves/Makefile                        |    2=20
>  drivers/tty/slaves/tty-reg.c                       |  102 ++++++++++++++=
++++++
>  6 files changed, 137 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/serial/slave-reg.txt
>  create mode 100644 drivers/tty/slaves/Kconfig
>  create mode 100644 drivers/tty/slaves/Makefile
>  create mode 100644 drivers/tty/slaves/tty-reg.c
>=20
> diff --git a/Documentation/devicetree/bindings/serial/slave-reg.txt b/Doc=
umentation/devicetree/bindings/serial/slave-reg.txt
> new file mode 100644
> index 000000000000..7896bce8dfe4
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/serial/slave-reg.txt
> @@ -0,0 +1,18 @@
> +Regulator powered UART-attached device
> +
> +Required properties:
> +- compatible: "tty,regulator"
> +- vdd-supply: regulator to power the device
> +
> +
> +This is listed as a child node of a UART.  When the
> +UART is opened, the device is powered.
> +
> +Example:
> +
> +&uart1 {
> +	bluetooth {
> +		compatible =3D "tty,regulator";
> +		vdd-supply =3D <&vaux4>;
> +	};
> +};

NACK. The compatible value should describe the connected device. You
did not connect a regulator, but a bluetooth chip! DT should look
like this:

&uart1 {
    bluetooth {
        compatible =3D "vendor,bluetooth-chip";
        vdd-supply =3D <&vaux4>;
    };
};

I think it would be ok to use your generic driver to handle the
specific compatible value, though.

Having the proper compatible value means, that there can be a more
specific driver later, that other operating systems can expose the
device as some kind of /dev/bluetooth instead of /dev/ttyXY, that
userspace is able to know there is a bluetooth device connected to
/dev/ttyXY by parsing the DT and results in easier-to-understand
DTS.

> diff --git a/drivers/tty/Kconfig b/drivers/tty/Kconfig
> index b24aa010f68c..ea3383c71701 100644
> --- a/drivers/tty/Kconfig
> +++ b/drivers/tty/Kconfig
> @@ -419,4 +419,6 @@ config DA_CONSOLE
>  	help
>  	  This enables a console on a Dash channel.
> =20
> +source drivers/tty/slaves/Kconfig
> +
>  endif # TTY
> diff --git a/drivers/tty/Makefile b/drivers/tty/Makefile
> index 58ad1c05b7f8..45957d671e33 100644
> --- a/drivers/tty/Makefile
> +++ b/drivers/tty/Makefile
> @@ -13,6 +13,7 @@ obj-$(CONFIG_R3964)		+=3D n_r3964.o
>  obj-y				+=3D vt/
>  obj-$(CONFIG_HVC_DRIVER)	+=3D hvc/
>  obj-y				+=3D serial/
> +obj-$(CONFIG_TTY_SLAVE)		+=3D slaves/
> =20
>  # tty drivers
>  obj-$(CONFIG_AMIGA_BUILTIN_SERIAL) +=3D amiserial.o
> diff --git a/drivers/tty/slaves/Kconfig b/drivers/tty/slaves/Kconfig
> new file mode 100644
> index 000000000000..2dd1acf80f8c
> --- /dev/null
> +++ b/drivers/tty/slaves/Kconfig
> @@ -0,0 +1,12 @@
> +menuconfig TTY_SLAVE
> +	bool "TTY slave devices"
> +	help
> +	 Devices which attach via a uart, but need extra
> +	 driver support for power management etc.
> +
> +if TTY_SLAVE
> +
> +config TTY_SLAVE_REGULATOR
> +	tristate "TTY slave device powered by regulator"
> +
> +endif
> diff --git a/drivers/tty/slaves/Makefile b/drivers/tty/slaves/Makefile
> new file mode 100644
> index 000000000000..e636bf49f1cc
> --- /dev/null
> +++ b/drivers/tty/slaves/Makefile
> @@ -0,0 +1,2 @@
> +
> +obj-$(CONFIG_TTY_SLAVE_REGULATOR) +=3D tty-reg.o
> diff --git a/drivers/tty/slaves/tty-reg.c b/drivers/tty/slaves/tty-reg.c
> new file mode 100644
> index 000000000000..613f8b10967c
> --- /dev/null
> +++ b/drivers/tty/slaves/tty-reg.c
> @@ -0,0 +1,102 @@
> +/*
> + * tty-reg:
> + *   Support for any device which needs a regulator turned on
> + *   when a tty is opened.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/err.h>
> +#include <linux/regulator/consumer.h>
> +#include <linux/platform_device.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/tty.h>
> +
> +struct tty_reg_data {
> +	struct regulator *reg;
> +	bool	reg_enabled;
> +};
> +
> +static int tty_reg_runtime_resume(struct device *slave)
> +{
> +	struct tty_reg_data *data =3D dev_get_drvdata(slave);
> +	if (!data->reg_enabled &&
> +	    regulator_enable(data->reg) =3D=3D 0) {
> +		dev_dbg(slave, "power on\n");
> +		data->reg_enabled =3D true;
> +	}
> +	return 0;
> +}
> +
> +static int tty_reg_runtime_suspend(struct device *slave)
> +{
> +	struct tty_reg_data *data =3D dev_get_drvdata(slave);
> +
> +	if (data->reg_enabled &&
> +	    regulator_disable(data->reg) =3D=3D 0) {
> +		dev_dbg(slave, "power off\n");
> +		data->reg_enabled =3D false;
> +	}
> +	return 0;
> +}
> +
> +static int tty_reg_probe(struct platform_device *pdev)
> +{
> +	struct tty_reg_data *data;
> +	struct regulator *reg;
> +	int err;
> +
> +	err =3D -ENODEV;
> +	if (pdev->dev.parent =3D=3D NULL)
> +		goto out;
> +	reg =3D devm_regulator_get(&pdev->dev, "vdd");
> +	err =3D PTR_ERR(reg);
> +	if (IS_ERR(reg))
> +		goto out;
> +
> +	data =3D devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
> +	err =3D -ENOMEM;
> +	if (!data)
> +		goto out;
> +	data->reg =3D reg;
> +	data->reg_enabled =3D false;
> +	pm_runtime_enable(&pdev->dev);
> +	platform_set_drvdata(pdev, data);
> +	err =3D 0;
> +out:
> +	return err;
> +}
> +
> +static struct of_device_id tty_reg_dt_ids[] =3D {
> +	{ .compatible =3D "tty,regulator", },
> +	{}
> +};
> +
> +static const struct dev_pm_ops tty_reg_pm_ops =3D {
> +	SET_RUNTIME_PM_OPS(tty_reg_runtime_suspend,
> +			   tty_reg_runtime_resume, NULL)
> +};
> +
> +static struct platform_driver tty_reg_driver =3D {
> +	.driver.name	=3D "tty-regulator",
> +	.driver.owner	=3D THIS_MODULE,
> +	.driver.of_match_table =3D tty_reg_dt_ids,
> +	.driver.pm	=3D &tty_reg_pm_ops,
> +	.probe		=3D tty_reg_probe,
> +};
> +
> +static int __init tty_reg_init(void)
> +{
> +	return platform_driver_register(&tty_reg_driver);
> +}
> +module_init(tty_reg_init);
> +
> +static void __exit tty_reg_exit(void)
> +{
> +	platform_driver_unregister(&tty_reg_driver);
> +}
> +module_exit(tty_reg_exit);
> +
> +MODULE_AUTHOR("NeilBrown <neilb@suse.de>");
> +MODULE_DESCRIPTION("Serial port device which requires a regulator when o=
pen.");
> +MODULE_LICENSE("GPL v2");
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--gj572EiMnwbLXET9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUiiGlAAoJENju1/PIO/qaVo4QAIoZqUwJu8sB84q8HYJfHh+5
KmzD8lJatlWIlPFmfRvRY6y3j0aP3vrqXqgXDRn6JqswS3N6MV0Fy0d6z7UyEh1y
xG5aN9/1d2LUmqDj4eWl/l6a3oKeiioV+WKjZYPPWHuzeF+6B5gZqH/2KJgjCcXk
ZAf3ONB2gH0I8EwCLL+XbtmMyIXcIbdT3TVF5LnLcJNv5rf0I06bGStDiNCQfRoj
aeCoPayLJEX9M6IE+s7hMG3aFHrPdbjZd15NNyG/vKaVDPHymhlOXeEje6kdWSJu
Nu5AX03T0ROzTd0A02VWjuUg9RMSZVNBGGx7sWo1DSZ7jQOZmSn6c7flhTo0kam0
br4H2iWCZS6kHO7DyzcKNEB5mGhjnbMDledKIp2GNPK8Wr6KZ9NMM8pqkhvSyIDR
cOGtoZ7NSPrt1HZ3OQtftatOB4//aWDqohFICq9PQSBBFRk3lvWqRucvZzi6QXUi
olAOvspSBt/Anh80YAyvxNLVxT/TvAxG0Uu3Mx7TvZQrJgrqB92XiBUeGArsMZpd
6+8i4fMctFwZhef5Cu4JZuCGN/pXPqz8TDVoSj4+SsizPi0xPKRl34vffs60SStc
rceD/MmiJxhTofpTbAJM4ZYJ3/p5l4bCR4rKSquiSqzbnfmXWKzPxIXZalb3RPJ+
MIKQZdzN25Ldx4IpS0sY
=qdgn
-----END PGP SIGNATURE-----

--gj572EiMnwbLXET9--
