Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514AbbABUF1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 15:05:27 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:43211 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751871AbbABUFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 15:05:25 -0500
Date: Fri, 2 Jan 2015 14:04:24 -0600
From: Felipe Balbi <balbi@ti.com>
To: Dave Gerlach <d-gerlach@ti.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Ohad Ben-Cohen <ohad@wizery.com>, Suman Anna <s-anna@ti.com>,
        Arnd Bergmann <arnd@arndb.de>, Kevin Hilman <khilman@linaro.org>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 3/3] remoteproc: wkup_m3: Add wkup_m3 remote proc driver
Message-ID: <20150102200424.GD4920@saruman>
Reply-To: <balbi@ti.com>
References: <1420228319-41085-1-git-send-email-d-gerlach@ti.com>
 <1420228319-41085-4-git-send-email-d-gerlach@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hoZxPH4CaxYzWscb"
Content-Disposition: inline
In-Reply-To: <1420228319-41085-4-git-send-email-d-gerlach@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--hoZxPH4CaxYzWscb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 02, 2015 at 01:51:59PM -0600, Dave Gerlach wrote:
> Add a remoteproc driver to load the firmware for and boot the wkup_m3
> present on am33xx. The wkup_m3 is an integrated Cortex M3 that allows
> the SoC to enter the lowest possible power state by taking control from
> the MPU after it has gone into its own low power state and shutting off
> any additional peripherals.
>=20
> The driver expects a resource table to be present in the wkup_m3
> firmware to define the required memory resources needed by the wkup_m3,
> at least the data memory so that the firmware can be copied to the proper
> place for execution.
>=20
> Signed-off-by: Dave Gerlach <d-gerlach@ti.com>
> ---
>  drivers/remoteproc/Kconfig         |  12 +++
>  drivers/remoteproc/Makefile        |   1 +
>  drivers/remoteproc/wkup_m3_rproc.c | 175 +++++++++++++++++++++++++++++++=
++++++
>  3 files changed, 188 insertions(+)
>  create mode 100644 drivers/remoteproc/wkup_m3_rproc.c
>=20
> diff --git a/drivers/remoteproc/Kconfig b/drivers/remoteproc/Kconfig
> index 5e343ba..7fbdb53 100644
> --- a/drivers/remoteproc/Kconfig
> +++ b/drivers/remoteproc/Kconfig
> @@ -41,6 +41,18 @@ config STE_MODEM_RPROC
>  	  This can be either built-in or a loadable module.
>  	  If unsure say N.
> =20
> +config WKUP_M3_RPROC
> +	bool "AM33xx wkup-m3 remoteproc support"

it would be nicer if this could be a loadable module.

> +	depends on SOC_AM33XX
> +	select REMOTEPROC
> +	help
> +	  Say y here to support AM33xx wkup-m3.
> +
> +	  Required for Suspend-to-ram and CPUIdle on AM33xx. Allows for
> +	  loading of firmware of CM3 PM coprocessor that is present
> +	  on AM33xx family of SoCs
> +	  If unsure say N.
> +
>  config DA8XX_REMOTEPROC
>  	tristate "DA8xx/OMAP-L13x remoteproc support"
>  	depends on ARCH_DAVINCI_DA8XX
> diff --git a/drivers/remoteproc/Makefile b/drivers/remoteproc/Makefile
> index ac2ff75..81b04d1 100644
> --- a/drivers/remoteproc/Makefile
> +++ b/drivers/remoteproc/Makefile
> @@ -9,4 +9,5 @@ remoteproc-y				+=3D remoteproc_virtio.o
>  remoteproc-y				+=3D remoteproc_elf_loader.o
>  obj-$(CONFIG_OMAP_REMOTEPROC)		+=3D omap_remoteproc.o
>  obj-$(CONFIG_STE_MODEM_RPROC)	 	+=3D ste_modem_rproc.o
> +obj-$(CONFIG_WKUP_M3_RPROC)		+=3D wkup_m3_rproc.o
>  obj-$(CONFIG_DA8XX_REMOTEPROC)		+=3D da8xx_remoteproc.o
> diff --git a/drivers/remoteproc/wkup_m3_rproc.c b/drivers/remoteproc/wkup=
_m3_rproc.c
> new file mode 100644
> index 0000000..8686ca2
> --- /dev/null
> +++ b/drivers/remoteproc/wkup_m3_rproc.c
> @@ -0,0 +1,175 @@
> +/*
> + * AMx3 Wkup M3 Remote Processor driver
> + *
> + * Copyright (C) 2014 Texas Instruments, Inc.
> + *
> + * Dave Gerlach <d-gerlach@ti.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/err.h>
> +#include <linux/kernel.h>
> +#include <linux/interrupt.h>
> +#include <linux/module.h>
> +#include <linux/of_device.h>
> +#include <linux/platform_device.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/remoteproc.h>
> +
> +#include <linux/platform_data/wkup_m3.h>
> +
> +#include "remoteproc_internal.h"
> +
> +struct wkup_m3_rproc {
> +	struct rproc *rproc;
> +	struct platform_device *pdev;
> +};
> +
> +static int wkup_m3_rproc_start(struct rproc *rproc)
> +{
> +	struct wkup_m3_rproc *m3_rproc =3D rproc->priv;
> +	struct platform_device *pdev =3D m3_rproc->pdev;
> +	struct device *dev =3D &pdev->dev;
> +	struct wkup_m3_platform_data *pdata =3D dev->platform_data;
> +	int ret;
> +
> +	ret =3D pdata->deassert_reset(pdev, pdata->reset_name);

looks like here you should assert, wait, deassert. What if soemthing
else used wkup_m3 before this loads ?

> +	if (ret) {
> +		dev_err(dev, "Unable to reset wkup_m3!\n");
> +		return -ENODEV;
> +	}
> +
> +	return 0;
> +}
> +
> +static int wkup_m3_rproc_stop(struct rproc *rproc)
> +{
> +	struct wkup_m3_rproc *m3_rproc =3D rproc->priv;
> +	struct platform_device *pdev =3D m3_rproc->pdev;
> +	struct device *dev =3D &pdev->dev;
> +	struct wkup_m3_platform_data *pdata =3D dev->platform_data;
> +	int ret;
> +
> +	ret =3D pdata->assert_reset(pdev, pdata->reset_name);
> +	if (ret) {
> +		dev_err(dev, "Unable to assert reset of wkup_m3!\n");
> +		return -ENODEV;
> +	}
> +	return 0;
> +}
> +
> +static struct rproc_ops wkup_m3_rproc_ops =3D {
> +	.start		=3D wkup_m3_rproc_start,
> +	.stop		=3D wkup_m3_rproc_stop,
> +};
> +
> +static const struct of_device_id wkup_m3_rproc_of_match[] =3D {
> +	{
> +		.compatible =3D "ti,am3353-wkup-m3",
> +		.data =3D (void *)"am335x-pm-firmware.elf",

do you know of anybody else who might want to different firmware image
name ? Otherwise why pass it as driver_data ?

> +	},
> +	{},
> +};
> +
> +static int wkup_m3_rproc_probe(struct platform_device *pdev)
> +{
> +	struct device *dev =3D &pdev->dev;
> +	const char *fw_name;
> +	struct wkup_m3_platform_data *pdata =3D dev->platform_data;
> +	struct wkup_m3_rproc *m3_rproc;
> +	const struct of_device_id *match;
> +	struct rproc *rproc;
> +	int ret;
> +
> +	if (!(pdata && pdata->deassert_reset && pdata->assert_reset &&
> +	      pdata->reset_name)) {
> +		dev_err(dev, "Platform data missing!\n");
> +		return -ENODEV;
> +	}

if pdata is missing, couldn't you assume the thing has been reset and
try to load anyway ?

> +	match =3D of_match_device(wkup_m3_rproc_of_match, &pdev->dev);
> +	if (!match)
> +		return -ENODEV;
> +	fw_name =3D (char *)match->data;
> +
> +	pm_runtime_enable(&pdev->dev);
> +
> +	ret =3D pm_runtime_get_sync(&pdev->dev);
> +	if (IS_ERR_VALUE(ret)) {
> +		dev_err(&pdev->dev, "pm_runtime_get_sync() failed\n");
> +		return ret;

this is wrong for two reasons:

a) you need to pm_runtime_disable();
b) even if pm_runtime_get*() fails, you _must_ call
	pm_runtime_put_sync();

> +	}
> +
> +	rproc =3D rproc_alloc(dev, "wkup_m3", &wkup_m3_rproc_ops,
> +			    fw_name, sizeof(*m3_rproc));
> +	if (!rproc)
> +		return -ENOMEM;
> +
> +	m3_rproc =3D rproc->priv;
> +	m3_rproc->rproc =3D rproc;
> +	m3_rproc->pdev =3D pdev;
> +
> +	dev_set_drvdata(dev, rproc);
> +
> +	/* Register as a remoteproc device */
> +	ret =3D rproc_add(rproc);
> +	if (ret) {
> +		dev_err(dev, "rproc_add failed\n");
> +		goto err;
> +	}
> +
> +	return 0;
> +
> +err:
> +	rproc_put(rproc);
> +	pm_runtime_put_sync(&pdev->dev);

missing pm_runtime_disable();

> +	return ret;
> +}
> +
> +static int wkup_m3_rproc_remove(struct platform_device *pdev)
> +{
> +	struct rproc *rproc =3D platform_get_drvdata(pdev);
> +
> +	rproc_del(rproc);
> +	rproc_put(rproc);
> +	pm_runtime_put_sync(&pdev->dev);

missing pm_runtime_disable();

> +
> +	return 0;
> +}
> +
> +static int wkup_m3_rpm_suspend(struct device *dev)
> +{
> +	return -EBUSY;
> +}

looks like this is just coping with omap_device bogosity, no ?

> +
> +static int wkup_m3_rpm_resume(struct device *dev)
> +{
> +	return 0;
> +}
> +
> +static const struct dev_pm_ops wkup_m3_rproc_pm_ops =3D {
> +	SET_RUNTIME_PM_OPS(wkup_m3_rpm_suspend, wkup_m3_rpm_resume, NULL)
> +};
> +
> +static struct platform_driver wkup_m3_rproc_driver =3D {
> +	.probe =3D wkup_m3_rproc_probe,
> +	.remove =3D wkup_m3_rproc_remove,
> +	.driver =3D {
> +		.name =3D "wkup_m3",
> +		.of_match_table =3D wkup_m3_rproc_of_match,
> +		.pm =3D &wkup_m3_rproc_pm_ops,
> +	},
> +};
> +
> +module_platform_driver(wkup_m3_rproc_driver);
> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_DESCRIPTION("wkup m3 remote processor control driver");

do you want to add MODULE_AUTHOR() ?

--=20
balbi

--hoZxPH4CaxYzWscb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUpvnIAAoJEIaOsuA1yqRE2B8P/RqJ+TJWNbkD5kotC4yfV/0e
r/0T9aHRQ3vhCXuyeB1uL7xqE2WTJm2FPadyeNfIAZvpf+pm8uxHPhiH3tSBVI01
9MbB6zuXrF2mh+kcjGw5Yg16w+Y+BykMgDC3nHmNPBH6UXCRs2G1efg1LlfaL7tC
8AWfQFmoNwzrLICR6MHUvN4PZqJM4BdO0js7kK/aR+3TJ9p0E20nzrgBTScTZKvv
GMXwBv+eKlgfC6yOlAXBG75+7douC4GGHQtLeAYKln5jqqn/BjIJ+H+CS4SZ7pex
CXKYMye3QjbUhAPbTi3Ch6lfuLjrF+PRFQS9KHqlveYBX/ynjSk6czx0Pws/zrR6
XwafYrMBsAMpHTfjrPgcCoBDEP7i/3nKOHFkhimxS39YeRhs992VzdvxecI7CGra
CiwhjJ/2SHtkSRF30dwBRym3KPGq4oTn1lhPpAbQ5SUdRI60WKTNp3vTQ7Ma69KK
0FWuZX96PL9iI9LOg+H20EsrlAnCUa+hp2D8Fe5O7Zh0G+M6sMMApFwJIRZEypuP
SAkpplYSqE7tqIkqleRp3ENbuVjkm0H40oFcq7VOI4wHlz1BOSB4pDNSSigCRbex
hcswavqp8qBd1PpSE3KT9ETkZB1A3qKjrxIpkVRP9V2gwJY6zFu1syZcwZ587uXY
LL2aue6QVRv15GpSCY4t
=q23V
-----END PGP SIGNATURE-----

--hoZxPH4CaxYzWscb--
