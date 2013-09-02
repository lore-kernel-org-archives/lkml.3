Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600Ab3IBIIW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 04:08:22 -0400
Received: from top.free-electrons.com ([176.31.233.9]:32788 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754302Ab3IBIIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 04:08:18 -0400
Date: Mon, 2 Sep 2013 10:08:12 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: oliver+list@schinagl.nl
Cc: arnd@arndb.de, gregkh@linuxfoundation.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        andy.shevchenko@gmail.com, tomasz.figa@gmail.com,
        Oliver Schinagl <oliver@schinagl.nl>
Subject: Re: [PATCHv6 1/2] ARM: sunxi: Initial support for Allwinner's
 Security ID fuses
Message-ID: <20130902080812.GA2630@lukather>
References: <1378035019-9649-1-git-send-email-oliver+list@schinagl.nl>
 <1378035019-9649-2-git-send-email-oliver+list@schinagl.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OgqxwSJOaUobr8KG"
Content-Disposition: inline
In-Reply-To: <1378035019-9649-2-git-send-email-oliver+list@schinagl.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Oliver,

On Sun, Sep 01, 2013 at 01:30:18PM +0200, oliver+list@schinagl.nl wrote:
> From: Oliver Schinagl <oliver@schinagl.nl>
>=20
> Allwinner has electric fuses (efuse) on their line of chips. This driver
> reads those fuses, seeds the kernel entropy and exports them as a sysfs
> node.
>=20
> These fuses are most likely to be programmed at the factory, encoding
> things like Chip ID, some sort of serial number etc and appear to be
> reasonable unique.
> While in theory, these should be writeable by the user, it will probably
> be inconvinient to do so. Allwinner recommends that a certain input pin,
> labeled 'efuse_vddq', be connected to GND. To write these fuses however,
> a 2.5 V programming voltage needs to be applied to this pin.
>=20
> Even so, they can still be used to generate a board-unique mac from,
> board unique RSA key and seed the kernel RNG.
>=20
> On sun7i additional storage is available, this is initially used for an
> UEFI BOOT key, Secure JTAG key, HDMI-HDCP key and vendor specific keys.
>=20
> Currently supported are the following known chips:
> Allwinner sun4i (A10)
> Allwinner sun5i (A10s, A13)
> Allwinner sun7i (A20)
>=20
> Signed-off-by: Oliver Schinagl <oliver@schinagl.nl>
> ---
>  Documentation/ABI/testing/sysfs-driver-sunxi-sid   |  22 +++
>  .../bindings/misc/allwinner,sunxi-sid.txt          |  17 ++
>  drivers/misc/eeprom/Kconfig                        |  13 ++
>  drivers/misc/eeprom/Makefile                       |   1 +
>  drivers/misc/eeprom/sunxi_sid.c                    | 177 +++++++++++++++=
++++++
>  5 files changed, 230 insertions(+)
>  create mode 100644 Documentation/ABI/testing/sysfs-driver-sunxi-sid
>  create mode 100644 Documentation/devicetree/bindings/misc/allwinner,sunx=
i-sid.txt
>  create mode 100644 drivers/misc/eeprom/sunxi_sid.c
>=20
> diff --git a/Documentation/ABI/testing/sysfs-driver-sunxi-sid b/Documenta=
tion/ABI/testing/sysfs-driver-sunxi-sid
> new file mode 100644
> index 0000000..ffb9536
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-driver-sunxi-sid
> @@ -0,0 +1,22 @@
> +What:		/sys/devices/*/<our-device>/eeprom
> +Date:		August 2013
> +Contact:	Oliver Schinagl <oliver@schinagl.nl>
> +Description:	read-only access to the SID (Security-ID) on current
> +		A-series SoC's from Allwinner. Currently supports A10, A10s, A13
> +		and A20 CPU's. The earlier A1x series of SoCs exports 16 bytes,
> +		whereas the newer A20 SoC exposes 512 bytes split into sections.
> +		Besides the 16 bytes of SID, there's also an SJTAG area,
> +		HDMI-HDCP key and some custom keys. Below a quick overview, for
> +		details see the user manual:
> +		0x000  128 bit root-key (sun[457]i)
> +		0x010  128 bit boot-key (sun7i)
> +		0x020   64 bit security-jtag-key (sun7i)
> +		0x028   16 bit key configuration (sun7i)
> +		0x02b   16 bit custom-vendor-key (sun7i)
> +		0x02c  320 bit low general key (sun7i)
> +		0x040   32 bit read-control access (sun7i)
> +		0x064  224 bit low general key (sun7i)
> +		0x080 2304 bit HDCP-key (sun7i)
> +		0x1a0  768 bit high general key (sun7i)
> +Users:		any user space application which wants to read the SID on
> +		Allwinner's A-series of CPU's.
> diff --git a/Documentation/devicetree/bindings/misc/allwinner,sunxi-sid.t=
xt b/Documentation/devicetree/bindings/misc/allwinner,sunxi-sid.txt
> new file mode 100644
> index 0000000..68ba372
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/misc/allwinner,sunxi-sid.txt
> @@ -0,0 +1,17 @@
> +Allwinner sunxi-sid
> +
> +Required properties:
> +- compatible: "allwinner,sun4i-sid" or "allwinner,sun7i-a20-sid".
> +- reg: Should contain registers location and length
> +
> +Example for sun4i:
> +	sid@01c23800 {
> +		compatible =3D "allwinner,sun4i-sid";
> +		reg =3D <0x01c23800 0x10>
> +	};
> +
> +Example for sun7i:
> +	sid@01c23800 {
> +		compatible =3D "allwinner,sun7i-a20-sid";
> +		reg =3D <0x01c23800 0x200>
> +	};
> diff --git a/drivers/misc/eeprom/Kconfig b/drivers/misc/eeprom/Kconfig
> index 04f2e1f..9536852f 100644
> --- a/drivers/misc/eeprom/Kconfig
> +++ b/drivers/misc/eeprom/Kconfig
> @@ -96,4 +96,17 @@ config EEPROM_DIGSY_MTC_CFG
> =20
>  	  If unsure, say N.
> =20
> +config EEPROM_SUNXI_SID
> +	tristate "Allwinner sunxi security ID support"
> +	depends on ARCH_SUNXI && SYSFS
> +	help
> +	  This is a driver for the 'security ID' available on various Allwinner
> +	  devices.
> +
> +	  Due to the potential risks involved with changing e-fuses,
> +	  this driver is read-only.
> +
> +	  This driver can also be built as a module. If so, the module
> +	  will be called sunxi_sid.
> +
>  endmenu
> diff --git a/drivers/misc/eeprom/Makefile b/drivers/misc/eeprom/Makefile
> index fc1e81d..9507aec 100644
> --- a/drivers/misc/eeprom/Makefile
> +++ b/drivers/misc/eeprom/Makefile
> @@ -4,4 +4,5 @@ obj-$(CONFIG_EEPROM_LEGACY)	+=3D eeprom.o
>  obj-$(CONFIG_EEPROM_MAX6875)	+=3D max6875.o
>  obj-$(CONFIG_EEPROM_93CX6)	+=3D eeprom_93cx6.o
>  obj-$(CONFIG_EEPROM_93XX46)	+=3D eeprom_93xx46.o
> +obj-$(CONFIG_EEPROM_SUNXI_SID)	+=3D sunxi_sid.o
>  obj-$(CONFIG_EEPROM_DIGSY_MTC_CFG) +=3D digsy_mtc_eeprom.o
> diff --git a/drivers/misc/eeprom/sunxi_sid.c b/drivers/misc/eeprom/sunxi_=
sid.c
> new file mode 100644
> index 0000000..39a9a62
> --- /dev/null
> +++ b/drivers/misc/eeprom/sunxi_sid.c
> @@ -0,0 +1,177 @@
> +/*
> + * Copyright (c) 2013 Oliver Schinagl <oliver@schinagl.nl>
> + * http://www.linux-sunxi.org
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * This driver exposes the Allwinner security ID, efuses exported in byt=
e-
> + * sized chunks.
> + */
> +
> +#include <linux/compiler.h>
> +#include <linux/device.h>
> +#include <linux/err.h>
> +#include <linux/export.h>
> +#include <linux/fs.h>
> +#include <linux/init.h>
> +#include <linux/io.h>
> +#include <linux/kernel.h>
> +#include <linux/kobject.h>
> +#include <linux/module.h>
> +#include <linux/of_device.h>
> +#include <linux/platform_device.h>
> +#include <linux/random.h>
> +#include <linux/slab.h>
> +#include <linux/stat.h>
> +#include <linux/sysfs.h>
> +#include <linux/types.h>
> +
> +#define DRV_NAME "sunxi-sid"
> +
> +struct sunxi_sid_data {
> +	void __iomem *reg_base;
> +	unsigned int keysize;
> +};
> +
> +/* We read the entire key, due to a 32 bit read alignment requirement. S=
ince we
> + * want to return the requested byte, this resuls in somewhat slower cod=
e and
> + * uses 4 times more reads as needed but keeps code simpler. Since the S=
ID is
> + * only very rarly probed, this is not really an issue.
> + */
> +static u8 sunxi_sid_read_byte(const struct sunxi_sid_data *sid_data,
> +			      const unsigned int offset)
> +{
> +	u32 sid_key;
> +
> +	if (offset >=3D sid_data->keysize)
> +		return 0;
> +
> +	sid_key =3D ioread32be(sid_data->reg_base + round_down(offset, 4));
> +	sid_key >>=3D (offset % 4) * 8;
> +
> +	return sid_key; /* Only return the last byte */
> +}
> +
> +static ssize_t sid_read(struct file *fd, struct kobject *kobj,
> +			struct bin_attribute *attr, char *buf,
> +			loff_t pos, size_t size)
> +{
> +	struct platform_device *pdev;
> +	struct sunxi_sid_data *sid_data;
> +	int i;
> +
> +	pdev =3D to_platform_device(kobj_to_dev(kobj));
> +	sid_data =3D platform_get_drvdata(pdev);
> +
> +	if (pos < 0 || pos >=3D sid_data->keysize)
> +		return 0;
> +	if (size > sid_data->keysize - pos)
> +		size =3D sid_data->keysize - pos;
> +
> +	for (i =3D 0; i < size; i++)
> +		buf[i] =3D sunxi_sid_read_byte(sid_data, pos + i);
> +
> +	return i;
> +}
> +
> +static struct bin_attribute sid_bin_attr =3D {
> +	.attr =3D { .name =3D "eeprom", .mode =3D S_IRUGO, },
> +	.read =3D sid_read,
> +};
> +
> +static struct bin_attribute *sunxi_sid_bin_attrs[] =3D {
> +	&sid_bin_attr,
> +	NULL,
> +};
> +
> +static const struct attribute_group sunxi_sid_group =3D {
> +	.bin_attrs =3D sunxi_sid_bin_attrs,
> +};
> +
> +/* fixme: Unused struct to be used with proper sysfs bin_attr groups */
> +static const struct attribute_group *sunxi_sid_groups[] =3D {
> +	&sunxi_sid_group,
> +	NULL,
> +};
> +

I don't see it used afterwards. Is it?

> +static int sunxi_sid_remove(struct platform_device *pdev)
> +{
> +	struct sunxi_sid_data *sid_data;
> +
> +	device_remove_bin_file(&pdev->dev, &sid_bin_attr); /* fixme: remove whe=
n using sysfs bin attrs */
> +	sid_data =3D platform_get_drvdata(pdev);
> +	dev_dbg(&pdev->dev, "driver unloaded\n");
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id sunxi_sid_of_match[] =3D {
> +	{ .compatible =3D "allwinner,sun4i-sid", .data =3D (void *)16},
> +	{ .compatible =3D "allwinner,sun7i-a20-sid", .data =3D (void *)512},
> +	{/* sentinel */},
> +};
> +MODULE_DEVICE_TABLE(of, sunxi_sid_of_match);
> +
> +static int __init sunxi_sid_probe(struct platform_device *pdev)

This should be triggering a section mismatch warning when you compile
it.

The reason for this is that you reference your probe function (that has
a rather short life expectancy) from another structure (platform_driver)
that has a longer lifecycle. So, basically, after the init freeing, your
platform driver will still hold a reference to your probe function, that
has been freed, which is not a really good thing.

You can solve this in two ways:
  - remove the __init
  - or, in the platform driver case we're in, and if you're 100% sure
    you won't need EPROBE_DEFER, you can use
    module_platform_driver_probe.

> +{
> +	struct sunxi_sid_data *sid_data;
> +	struct resource *res;
> +	const struct of_device_id *of_dev_id;
> +	u8 *entropy;
> +	unsigned int i;
> +
> +	sid_data =3D devm_kzalloc(&pdev->dev, sizeof(struct sunxi_sid_data),
> +				GFP_KERNEL);
> +	if (!sid_data)
> +		return -ENOMEM;
> +
> +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	sid_data->reg_base =3D devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(sid_data->reg_base))
> +		return PTR_ERR(sid_data->reg_base);
> +
> +	of_dev_id =3D of_match_device(sunxi_sid_of_match, &pdev->dev);
> +	if (!of_dev_id)
> +		return -ENODEV;
> +	sid_data->keysize =3D (int)of_dev_id->data;
> +
> +	platform_set_drvdata(pdev, sid_data);
> +
> +	sid_bin_attr.size =3D sid_data->keysize; /* fixme: this should be prope=
rly set by the sysfs bin attr groups later */
> +	if (device_create_bin_file(&pdev->dev, &sid_bin_attr)) /* fixme: this w=
ill need to be removed when using sysfs bin attr groups */

I'm sorry, this is not really what I had in mind. You still don't
explain why this is causing a problem, what problem, and why you can't
use the sysfs groups right from the start.

What I wanted was a (pretty long, I agree) summing up the whole
discussion we had.

Something like:

/*
 * Be aware that this will generate a race with userspace. By the time
 * it gets called, udev has already been notified of the device
 * addition, and will never be notified that this file has been added.
 *
 * It should be properly fixed by having some way to attach a sysfs
 * attribute group to the device structure before the probe.
 * Unfortunately, this is both not possible for platform devices at the
 * moment and not trivial to do, so this will need a proper fix later
 * on.
 */

And just like the comment quoted above, you can remove the useless fixme
comments you added everywhere.

> +		return -ENODEV;
> +
> +	entropy =3D kzalloc(sizeof(u8) * sid_data->keysize, GFP_KERNEL);
> +	for (i =3D 0; i < sid_data->keysize; i++)
> +		entropy[i] =3D sunxi_sid_read_byte(sid_data, i);
> +	add_device_randomness(entropy, sid_data->keysize);
> +	kfree(entropy);
> +
> +	dev_dbg(&pdev->dev, "loaded\n");
> +
> +	return 0;
> +}
> +
> +static struct platform_driver sunxi_sid_driver =3D {
> +	.probe =3D sunxi_sid_probe,
> +	.remove =3D sunxi_sid_remove,
> +	.driver =3D {
> +		.name =3D DRV_NAME,
> +		.owner =3D THIS_MODULE,
> +		.of_match_table =3D sunxi_sid_of_match,
> +		/* .groups =3D sunxi_sid_groups, fixme: this is the proper way using b=
in attr groups */
> +	},
> +};
> +module_platform_driver(sunxi_sid_driver);
> +
> +MODULE_AUTHOR("Oliver Schinagl <oliver@schinagl.nl>");
> +MODULE_DESCRIPTION("Allwinner sunxi security id driver");
> +MODULE_LICENSE("GPL");
> --=20
> 1.8.1.5
>=20

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--OgqxwSJOaUobr8KG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSJEdsAAoJEBx+YmzsjxAgxPgP/1WqFumLbGrfTtY7USeqpu/T
GXDO3GXjPW2rL6kHubrhhEO3xHKip2JOzxQg0fWT/eOHnjfnoOCdrMlZeruTUkau
5sEWZoYudmLpUeiliOv2sdi4meowcFU6Gq0lS1+jE5CV5A1cXZP6FXlPWpzjxXas
2t3qMqd1t/2kLBeOzMKaZEWELW3I5mcrBP6VDkXKUNfPZoiT6oOtCOgNtM/Tbu20
Vd4WRJ6x07h04vpiF9L9JlP/x1Vm7Rq+FN2jHE2pJNYcCYV2Qx79eon49Hy9Cv+S
UzSeFi0qLHdGgOEvorqlgkSWGT2E4yQPjpGCFsmwIu9uY8KEdHNMhb9vsQyOntos
hDRhekASjRVkse/UTAtsS/1Q71hKWXwdxJMCrezIKrV3EAv6NMgu5PJZwjJJX9V/
4u7MGRXalnQAUEPx6SLJHsoug+Zi5fJq3fT67bk1hjTqQ1tdYZr4jqnaZ4gbnq1q
wN7OcqTiEl45kv5Ln3rzuMJMnSqNpy8dA7TIOFztbtTX5PBQGlVrSNcgvq4yzHt9
m78GrdBqdvGoSOMtj5nmZXRhWrAjO0e6ao0sgqh7kB8xuCduinpehxmU2QZCxo70
LCxAXqldY5Q5IB5J6RjnX7nm+DO8Tm9H5Rma/KaPinvQ3LaJUGrAhvFV26KFXX25
JISLJuaqcb/IpBFSzyVf
=i9So
-----END PGP SIGNATURE-----

--OgqxwSJOaUobr8KG--
