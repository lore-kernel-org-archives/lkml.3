Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178Ab3KYTxY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 14:53:24 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:34651 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757487Ab3KYTxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 14:53:20 -0500
Date: Mon, 25 Nov 2013 13:52:50 -0600
From: Felipe Balbi <balbi@ti.com>
To: Olof Johansson <olof@lixom.net>
CC: <linux-kernel@vger.kernel.org>, <keescook@chromium.org>,
        <bleung@chromium.org>
Subject: Re: [PATCH] platform/chrome: Add pstore platform_device
Message-ID: <20131125195250.GD18046@saruman.home>
Reply-To: <balbi@ti.com>
References: <1385408226-22369-1-git-send-email-olof@lixom.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8TMLq6GPUuN4DysL"
Content-Disposition: inline
In-Reply-To: <1385408226-22369-1-git-send-email-olof@lixom.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--8TMLq6GPUuN4DysL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Nov 25, 2013 at 11:37:06AM -0800, Olof Johansson wrote:
> Add the ramoops pstore device so that we get logs of panics across reboot=
s.
>=20
> Signed-off-by: Olof Johansson <olof@lixom.net>
> ---
>=20
>  drivers/platform/chrome/Kconfig           |  14 +++++
>  drivers/platform/chrome/Makefile          |   1 +
>  drivers/platform/chrome/chromeos_pstore.c | 101 ++++++++++++++++++++++++=
++++++
>  3 files changed, 116 insertions(+)
>  create mode 100644 drivers/platform/chrome/chromeos_pstore.c
>=20
> diff --git a/drivers/platform/chrome/Kconfig b/drivers/platform/chrome/Kc=
onfig
> index b13303e75a34..06c53c8132ad 100644
> --- a/drivers/platform/chrome/Kconfig
> +++ b/drivers/platform/chrome/Kconfig
> @@ -25,4 +25,18 @@ config CHROMEOS_LAPTOP
>  	  If you have a supported Chromebook, choose Y or M here.
>  	  The module will be called chromeos_laptop.
> =20
> +config CHROMEOS_PSTORE
> +	tristate "Chrome OS pstore support"
> +	---help---
> +	  This module instantiates the persistent storage on x86 ChromeOS
> +	  devices. It can be used to store away console logs and crash
> +	  information across reboots.
> +
> +	  The range of memory used is 0xf00000-0x1000000, tradionally the
> +	  memory used to back VGA controller memory.
> +
> +	  If you have a supported Chromebook, choose Y or M here.
> +	  The module will be called chromeos_pstore.
> +
> +
>  endif # CHROMEOS_PLATFORMS
> diff --git a/drivers/platform/chrome/Makefile b/drivers/platform/chrome/M=
akefile
> index 015e9195e226..2b860ca7450f 100644
> --- a/drivers/platform/chrome/Makefile
> +++ b/drivers/platform/chrome/Makefile
> @@ -1,2 +1,3 @@
> =20
>  obj-$(CONFIG_CHROMEOS_LAPTOP)	+=3D chromeos_laptop.o
> +obj-$(CONFIG_CHROMEOS_PSTORE)	+=3D chromeos_pstore.o
> diff --git a/drivers/platform/chrome/chromeos_pstore.c b/drivers/platform=
/chrome/chromeos_pstore.c
> new file mode 100644
> index 000000000000..e0e0e65cf442
> --- /dev/null
> +++ b/drivers/platform/chrome/chromeos_pstore.c
> @@ -0,0 +1,101 @@
> +/*
> + *  chromeos_pstore.c - Driver to instantiate Chromebook ramoops device
> + *
> + *  Copyright (C) 2013 Google, Inc.
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation, version 2 of the License.
> + */
> +
> +#include <linux/dmi.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/pstore_ram.h>
> +
> +static struct dmi_system_id chromeos_pstore_dmi_table[] __initdata =3D {
> +	{
> +		/*
> +		 * Today all Chromebooks/boxes ship with GOOGLE as vendor and
> +		 * coreboot as bios vendor. No other systems with this
> +		 * combination are known to date.
> +		 */
> +		.matches =3D {
> +			DMI_MATCH(DMI_SYS_VENDOR, "GOOGLE"),
> +			DMI_MATCH(DMI_BIOS_VENDOR, "coreboot"),
> +		},
> +	},
> +	{
> +		/*
> +		 * The first Samsung Chromebox and Chromebook Series 5 550 use
> +		 * coreboot but with Samsung as the system vendor.
> +		 */
> +		.matches =3D {
> +			DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG"),
> +			DMI_MATCH(DMI_BIOS_VENDOR, "coreboot"),
> +		},
> +	},
> +	{
> +		/* x86-alex, the first Samsung Chromebook. */
> +		.matches =3D {
> +			DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "Alex"),
> +		},
> +	},
> +	{
> +		/* x86-mario, the Cr-48 pilot device from Google. */
> +		.matches =3D {
> +			DMI_MATCH(DMI_SYS_VENDOR, "IEC"),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "Mario"),
> +		},
> +	},
> +	{
> +		/* x86-zgb, the first Acer Chromebook. */
> +		.matches =3D {
> +			DMI_MATCH(DMI_SYS_VENDOR, "ACER"),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "ZGB"),
> +		},
> +	},
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(dmi, chromeos_pstore_dmi_table);

if you have this ...

> +/*
> + * On x86 chromebooks/boxes, the firmware will keep the legacy VGA memory
> + * range untouched across reboots, so we use that to store our pstore
> + * contents for panic logs, etc.
> + */
> +static struct ramoops_platform_data chromeos_ramoops_data =3D {
> +	.mem_size	=3D 0x100000,
> +	.mem_address	=3D 0xf00000,
> +	.record_size	=3D 0x20000,
> +	.console_size	=3D 0x20000,
> +	.ftrace_size	=3D 0x20000,
> +	.dump_oops	=3D 1,
> +};
> +
> +static struct platform_device chromeos_ramoops =3D {
> +	.name =3D "ramoops",
> +	.dev =3D {
> +		.platform_data =3D &chromeos_ramoops_data,
> +	},
> +};
> +
> +static int __init chromeos_pstore_init(void)
> +{
> +	if (dmi_check_system(chromeos_pstore_dmi_table))

is this check really necessary ? I would assume that your probe would
only be called if the device matches the dmi MODULE_DEVICE_TABLE().

Except that you don't have a probe function which is quite odd. Also,
there's nothing using chromeos_ramoops_data, how does this work ?

cheers

--=20
balbi

--8TMLq6GPUuN4DysL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSk6qSAAoJEIaOsuA1yqRERuAP/RSjLnqxNmoXcX2ixfwFS1Es
uLMd/ICCnYiIYSd9I1a2wgeWnD9VDMoOGTlcPSBtkNbgANgpKnzofmMMehXP4utI
k8l++naJrTT4p/7m3gB88Cb7SVSd3VL1QWWuMHYvrkmhsUsxWZIFBJdVqmiBL3Rd
xSq11vVBctrcyZcAM2/wXMSox26+t6crU5TSDKGY49Vy9ZS9Uz/o/cVWJCDEPxAo
w0zfpqarWTMchSYveDRPoThxBBG3wQ6PnLx7sN4WXjPaaCgjSLmgHL9atf3CpWUK
DM92ydnYEjzOePu/docJK8N9CitMicTdN+N/U1u4/N/Aip2HKE7hAoyrhNjLLSjY
a2Duh0atpVYb+z2eqvwhxNqNDp7eyKSwjGM2ysNroRv42R2TaCSnezjo/AX5oArN
ZlJ/H/ddshNL2xfAGqeTLEtZ5BIbKu0p7gcHtExdq8Qq5JSUlBzBg6MRzxrMxLuA
R7C3R8RU57Bdl14DtM7QrojscxEr1/t2YYhqUeFf3gSlgDXFBnXaA/lb1+eY5KBV
Z9iQZy7z4yrGWXFe9RBQc6Yjb7ca5DZtgaku3GDGjjXYJIlVADXAhO8jyYe82FHA
hE2Cdj/y0mkbxEThO1RLWpZEP5U3C9VU3KrMd1/uiZrphTzgj/Frl7s8SgEYDKLz
V4/DWGQVUHgSwyZhpGpn
=x7da
-----END PGP SIGNATURE-----

--8TMLq6GPUuN4DysL--
