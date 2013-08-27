Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964Ab3H0PmT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 11:42:19 -0400
Received: from top.free-electrons.com ([176.31.233.9]:37206 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752310Ab3H0PmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 11:42:18 -0400
Date: Tue, 27 Aug 2013 17:42:13 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: oliver+list@schinagl.nl
Cc: arnd@arndb.de, gregkh@linuxfoundation.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        andy.shevchenko@gmail.com, tomasz.figa@gmail.com,
        Oliver Schinagl <oliver@schinagl.nl>
Subject: Re: [PATCH 1/2] Initial support for Allwinner's Security ID fuses
Message-ID: <20130827154213.GL2695@lukather>
References: <1377612785-7868-1-git-send-email-oliver+list@schinagl.nl>
 <1377612785-7868-2-git-send-email-oliver+list@schinagl.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eMP3JyRexyk9c0Bv"
Content-Disposition: inline
In-Reply-To: <1377612785-7868-2-git-send-email-oliver+list@schinagl.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eMP3JyRexyk9c0Bv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 27, 2013 at 04:13:04PM +0200, oliver+list@schinagl.nl wrote:
> From: Oliver Schinagl <oliver@schinagl.nl>
>=20
> Allwinner has electric fuses (efuse) on their line of chips. This driver
> reads those fuses, seeds the kernel entropy and exports them as a sysfs
> node.
>=20
> These fuses are most likly to be programmed at the factory, encoding
                       ^ likely
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

Speaking of which, any reason why you didn't add the A10s support in
your second patch?

> Allwinner sun7i (A20)
>=20
> Signed-off-by: Oliver Schinagl <oliver@schinagl.nl>
> ---
>  Documentation/ABI/stable/sysfs-driver-sunxi-sid    |  22 +++
>  .../bindings/misc/allwinner,sunxi-sid.txt          |  16 ++
>  drivers/misc/eeprom/Kconfig                        |  19 +++
>  drivers/misc/eeprom/Makefile                       |   1 +
>  drivers/misc/eeprom/sunxi_sid.c                    | 177 +++++++++++++++=
++++++
>  5 files changed, 235 insertions(+)
>  create mode 100644 Documentation/ABI/stable/sysfs-driver-sunxi-sid
>  create mode 100644 Documentation/devicetree/bindings/misc/allwinner,sunx=
i-sid.txt
>  create mode 100644 drivers/misc/eeprom/sunxi_sid.c
>=20
> diff --git a/Documentation/ABI/stable/sysfs-driver-sunxi-sid b/Documentat=
ion/ABI/stable/sysfs-driver-sunxi-sid
> new file mode 100644
> index 0000000..b04ec05
> --- /dev/null
> +++ b/Documentation/ABI/stable/sysfs-driver-sunxi-sid

I'm not sure this should go to the stable directory directly. Greg?
Isn't it suppose to go through testing/ before making it to stable/ ?

> @@ -0,0 +1,22 @@
> +What:		/sys/devices/soc.0/1c23800.eeprom/eeprom
                                     ^ and ^
are dynamic and depends on the number of instances of your driver, (in
this case) the base address of the device, the name of the root node in
the device tree, etc. so I wouldn't hardcode that in the documentation.

Sotheming like /sys/devices/*/<our-device>/eeprom maybe?=20

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
> index 0000000..2103a44
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/misc/allwinner,sunxi-sid.txt
> @@ -0,0 +1,16 @@
> +Allwinner sunxi-sid
> +
> +Required properties:
> +- compatible: "allwinner,sun4i-sid" or "allwinner,sun7i-sid".
> +- reg: Should contain registers location and length
> +
> +Example for sun4i:
> +	sid@01c23800 {
> +		compatible =3D "allwinner,sun4i-sid";
> +		reg =3D <0x01c23800 0x10>
> +	};
> +Example for sun7i
> +	sid@01c23800 {
> +		compatible =3D "allwinner,sun7i-sid";
> +		reg =3D <0x01c23800 0x200>
> +	};
> diff --git a/drivers/misc/eeprom/Kconfig b/drivers/misc/eeprom/Kconfig
> index 04f2e1f..bc6a14c 100644
> --- a/drivers/misc/eeprom/Kconfig
> +++ b/drivers/misc/eeprom/Kconfig
> @@ -96,4 +96,23 @@ config EEPROM_DIGSY_MTC_CFG
> =20
>  	  If unsure, say N.
> =20
> +config EEPROM_SUNXI_SID
> +	tristate "Allwinner sunxi security ID support"
> +	depends on ARCH_SUNXI && SYSFS
> +	help
> +	  This is a driver for the 'security ID' available on various Allwinner
> +	  devices.
> +	  Currently supported are:
> +		sun4i (A10)
> +		sun5i (A10s, A13)
> +		sun7i (A20)

I'm not sure I like the currently supported driver list to be in
Kconfig. That means that you'll have to duplicate in with the driver and
the Documentation, I'm not sure it's worth it.

> +	  Due to the potential risks involved with changing e-fuses,
> +	  this driver is read-only
> +
> +	  For more information visit http://linux-sunxi.org/SID

And I'm not very eager about putting URL there either. If the domain
name ever has to changed, or the wiki page changes, or whatever, you're
screwed.

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
> index 0000000..6fac205
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
> +static const struct attribute_group *sunxi_sid_groups[] =3D {
> +	&sunxi_sid_group,
> +	NULL,
> +};
> +
> +static int sunxi_sid_remove(struct platform_device *pdev)
> +{
> +	struct sunxi_sid_data *sid_data;
> +
> +	device_remove_bin_file(&pdev->dev, &sid_bin_attr); /* fixme */
> +	sid_data =3D platform_get_drvdata(pdev);
> +	devm_kfree(&pdev->dev, sid_data);
> +	dev_dbg(&pdev->dev, "driver unloaded\n");
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id sunxi_sid_of_match[] =3D {
> +	{ .compatible =3D "allwinner,sun4i-sid", .data =3D (void *)16},
> +	{ .compatible =3D "allwinner,sun7i-sid", .data =3D (void *)512},
> +	{/* sentinel */},
> +};
> +MODULE_DEVICE_TABLE(of, sunxi_sid_of_match);
> +
> +static int __init sunxi_sid_probe(struct platform_device *pdev)
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
> +	sid_bin_attr.size =3D sid_data->keysize; /* ugly */

Ugly? Why?

> +	if (device_create_bin_file(&pdev->dev, &sid_bin_attr)) /* fixme */

And what is there to fix here?

For these two comments, either explain what you find so ugly/broken so
that someone reading your code can get what is wrong, or just remove
them, because keeping them like that is just confusing.

Maxime

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
> +		/* .groups =3D sunxi_sid_groups, proper way */
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

--eMP3JyRexyk9c0Bv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSHMjVAAoJEBx+YmzsjxAgRWgQAImJEMTKRrvhUGM8ja0sZqrF
NTtOQsfnXotrsvZZcz3DqTahnXQUGeNuQa3KYnF6tATSwk6euefRH9UsCPRp1HDL
zjEmPI8DCk3QoewQXJkILABAa54s0j9RvGHt4y+hMJffl/6n3qPvNd7Mn5+8aasp
JiumnL8TnzzR/6nMeSQQccnrAQCZxQN+psvoQH1Ek3HnuGbXSMsynZoEd5XRb4cW
931q0xBny+2z1siPqjXkc3gk8fTlRxdeYwBH97knhJg8hcBFb1ieC/5gMx8aAp33
ANpqCBzA8rf2YYmOUYLHp+dnZWBx9Como3iODXOWTtbcJ05LPE5dtSyraH/2ZPYE
tmrl3ut10S4B1QE3FpsNhz3+sps64TKyQI3Wopn6+bRXgjHNYMcV/wlXVO9jvbzF
N8GbCP28NMrJtm9KfuBQqy1hLTuWFILpRDnBkWXbQ0ZNjmv17Juz+z5FZkshgh7S
R44mRGaqHm+vMVi5YF8t/mOVFXso4VB9wHrGms1H/O4rlQTDv4foJ5kW3c0Q20rq
5QaNAXy0rwP+ZqE0zWEb0q6xHBHWUc/ae2OyCTCMhIqkGWJF/PKtVAjeDbd44T0I
DS4Wf5N1/NB9ckMD22l90S42hIWXrOxdrbbtY/rTbadathkwrSLjBN4FYhpyg0J/
pvAX87ehfOzWyPUcdP7G
=8yDp
-----END PGP SIGNATURE-----

--eMP3JyRexyk9c0Bv--
