Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751511AbaILRrx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 13:47:53 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:56742 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884AbaILRrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 13:47:51 -0400
Date: Fri, 12 Sep 2014 12:47:04 -0500
From: Felipe Balbi <balbi@ti.com>
To: Andy Gross <agross@codeaurora.org>
CC: Felipe Balbi <balbi@ti.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Jack Pham <jackp@codeaurora.org>, Kumar Gala <galak@codeaurora.org>,
        <linux-arm-msm@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>
Subject: Re: [PATCH v8 2/3] usb: dwc3: Add Qualcomm DWC3 glue layer driver
Message-ID: <20140912174704.GG8567@saruman.home>
Reply-To: <balbi@ti.com>
References: <1410542986-24419-1-git-send-email-agross@codeaurora.org>
 <1410542986-24419-3-git-send-email-agross@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Rn7IEEq3VEzCw+ji"
Content-Disposition: inline
In-Reply-To: <1410542986-24419-3-git-send-email-agross@codeaurora.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Rn7IEEq3VEzCw+ji
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Sep 12, 2014 at 12:29:45PM -0500, Andy Gross wrote:
> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
>=20
> DWC3 glue layer is hardware layer around Synopsys DesignWare
> USB3 core. Its purpose is to supply Synopsys IP with required
> clocks, voltages and interface it with the rest of the SoC.
>=20
> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> Signed-off-by: Andy Gross <agross@codeaurora.org>
> ---
>  drivers/usb/dwc3/Kconfig     |    9 +++
>  drivers/usb/dwc3/Makefile    |    1 +
>  drivers/usb/dwc3/dwc3-qcom.c |  133 ++++++++++++++++++++++++++++++++++++=
++++++
>  3 files changed, 143 insertions(+)
>  create mode 100644 drivers/usb/dwc3/dwc3-qcom.c
>=20
> diff --git a/drivers/usb/dwc3/Kconfig b/drivers/usb/dwc3/Kconfig
> index 785510a..e9f258e 100644
> --- a/drivers/usb/dwc3/Kconfig
> +++ b/drivers/usb/dwc3/Kconfig
> @@ -80,6 +80,15 @@ config USB_DWC3_KEYSTONE
>  	  Support of USB2/3 functionality in TI Keystone2 platforms.
>  	  Say 'Y' or 'M' here if you have one such device
> =20
> +config USB_DWC3_QCOM
> +	tristate "Qualcomm Platforms"
> +	depends on ARCH_QCOM || COMPILE_TEST
> +	default USB_DWC3
> +	select PHY_QCOM_DWC3

I would rather steer away from selecting the PHY as it prevents having
PHYs as modules. Also, this will add a Kconfig warning for selecting a
symbol that doesn't exist (yet).

If it's all the same with you, I can clean this up when applying.

> diff --git a/drivers/usb/dwc3/dwc3-qcom.c b/drivers/usb/dwc3/dwc3-qcom.c
> new file mode 100644
> index 0000000..2067c04
> --- /dev/null
> +++ b/drivers/usb/dwc3/dwc3-qcom.c
> @@ -0,0 +1,133 @@
> +/* Copyright (c) 2013-2014, The Linux Foundation. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/err.h>
> +#include <linux/io.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_platform.h>
> +#include <linux/platform_device.h>
> +#include <linux/regulator/consumer.h>
> +#include <linux/usb/phy.h>

doesn't look like you need regulator/consumer.h and usb/phy.h. I can
clean it up when applying.

> +struct dwc3_qcom {
> +	struct device		*dev;
> +
> +	struct clk		*core_clk;
> +	struct clk		*iface_clk;
> +	struct clk		*sleep_clk;
> +};
> +
> +static int dwc3_qcom_probe(struct platform_device *pdev)
> +{
> +	struct device_node *node =3D pdev->dev.of_node;
> +	struct dwc3_qcom *qdwc;
> +	int ret =3D 0;
> +
> +	qdwc =3D devm_kzalloc(&pdev->dev, sizeof(*qdwc), GFP_KERNEL);
> +	if (!qdwc)
> +		return -ENOMEM;
> +
> +	platform_set_drvdata(pdev, qdwc);
> +
> +	qdwc->dev =3D &pdev->dev;
> +
> +	qdwc->core_clk =3D devm_clk_get(qdwc->dev, "core");
> +	if (IS_ERR(qdwc->core_clk)) {
> +		dev_dbg(qdwc->dev, "failed to get core clock\n");

this one would be a dev_err() since core can't work without its clock. I
can fix when applying.

--=20
balbi

--Rn7IEEq3VEzCw+ji
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUEzGYAAoJEIaOsuA1yqRE420QAKstJj0gzbXAGM+tChypADxD
tJ4VvoKSK8YN/oGPoXC0uobfqG+cTM3Amq3bWCbj3f/V7w1HLTRecjMAG+Ixwwtv
/rsJrOucdEYBXFt82LCBX1qxwAaSFF3baxzMnZ/yBMF/OP9yMn2eUR6khjy5c4q8
4TdeQ/jCbx4bDH+vHHDai6YtjRbyg3u+PuDTNvVJp9sZpsbgu117i32Hv6xwR9d9
F0mrWiuXYyzhY1WMUtUQ9ZtE9q+jiFbZWDPkZ+OcOlIHRu4T/yJfqDojgNcoGSrY
IzgcHt+UAE0MAE/Ow5ndiUWwzGgX5ZGxmotNKIeDrlD7IPlFPO2ZvAs2/dsbtErm
zLocmG95FOzFZoZME7QpGS2w1/yNnY6GbchnIvnoSKykqLjB0Te72yA75DKgqMPv
8OiYcXX3a5r8rhE+c8dykAVMiyZsZOa7BCZjU0NRHMxJRljlnWZ6t82qGXWBCuyW
Uwqb92kNTMOcS1TOqGlT6U1gJrKfv2VZVDTeGwBb0enzc94tbET3jwzwRRXpZOLO
3wMuj8nUDwemSvGDns6UA7idR5amzGv+jz2sMFThfcmqstUED5FD7u1i8XtQl/Li
ggFmZMzUNHYKr9808sgss5BeszHBoMkJiYA930CAJz+Lqfm1owwIHsiQdVwl99hI
gleuQml1VtpL40NKA020
=rq44
-----END PGP SIGNATURE-----

--Rn7IEEq3VEzCw+ji--
