Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758600AbaGDNzd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 09:55:33 -0400
Received: from mail-qg0-f54.google.com ([209.85.192.54]:34383 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbaGDNzb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 09:55:31 -0400
MIME-Version: 1.0
In-Reply-To: <1404133317-25953-4-git-send-email-lee.jones@linaro.org>
References: <1404133317-25953-1-git-send-email-lee.jones@linaro.org>
	<1404133317-25953-4-git-send-email-lee.jones@linaro.org>
Date: Fri, 4 Jul 2014 15:55:31 +0200
Message-ID: <CAG374jB6YjMDjaEk=+etrw46mUkXgBHBUhPTPUCyo-P_Wzn32g@mail.gmail.com>
Subject: Re: [PATCH 3/5] phy: miphy365x: Provide support for the MiPHY356x
 Generic PHY
From: Gabriel Fernandez <gabriel.fernandez@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kishon <kishon@ti.com>, "kernel@stlinux.com" <kernel@stlinux.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 June 2014 15:01, Lee Jones <lee.jones@linaro.org> wrote:
> The MiPHY365x is a Generic PHY which can serve various SATA or PCIe
> devices. It has 2 ports which it can use for either; both SATA, both
> PCIe or one of each in any configuration.
>
> Acked-by: Kishon Vijay Abraham I <kishon@ti.com>
> Acked-by: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Alexandre Torgue <alexandre.torgue@st.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/phy/Kconfig         |  10 +
>  drivers/phy/Makefile        |   1 +
>  drivers/phy/phy-miphy365x.c | 630 ++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 641 insertions(+)
>  create mode 100644 drivers/phy/phy-miphy365x.c
>

[...]

> diff --git a/drivers/phy/phy-miphy365x.c b/drivers/phy/phy-miphy365x.c
> new file mode 100644
> index 0000000..1109f42
> --- /dev/null
> +++ b/drivers/phy/phy-miphy365x.c
> @@ -0,0 +1,630 @@
> +/*
> + * Copyright (C) 2014 STMicroelectronics
> + *
> + * STMicroelectronics PHY driver MiPHY365 (for SoC STiH416).
> + *
> + * Author: Alexandre Torgue <alexandre.torgue@st.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2, as
> + * published by the Free Software Foundation.
> + *
> + */
> +
> +#include <linux/platform_device.h>
> +#include <linux/io.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_platform.h>
> +#include <linux/clk.h>
> +#include <linux/phy/phy.h>
> +#include <linux/delay.h>
> +#include <linux/mfd/syscon.h>
> +#include <linux/regmap.h>
> +
> +#include <dt-bindings/phy/phy-miphy365x.h>
> +
> +#define HFC_TIMEOUT            50
> +
> +#define SYSCFG_2521            0x824
> +#define SYSCFG_2522            0x828
> +#define SYSCFG_PCIE_SATA_MASK  BIT(1)
> +#define SYSCFG_PCIE_SATA_POS   1
> +
> +/* MiPHY365x register definitiona */

definition in Brazilian is 'definição', not 'definitiona' ...
:)

[...]

> +struct miphy365x {
> +       struct phy *phy;
> +       void __iomem *base;
> +       void __iomem *sata;
> +       void __iomem *pcie;
> +       u8 type;
> +       u8 port;
> +};
> +
> +struct miphy365x_dev {
> +       struct device *dev;
> +       struct mutex miphy_mutex;
> +       struct miphy365x phys[ARRAY_SIZE(ports)];
> +       bool pcie_tx_pol_inv;
> +       bool sata_tx_pol_inv;
> +       u32 sata_gen;
> +       struct regmap *regmap;
> +};
> +
> +/*

[...]

> +static int miphy365x_of_probe(struct device_node *np,
> +                             struct miphy365x_dev *phy_dev)
> +{
> +       phy_dev->regmap = syscon_regmap_lookup_by_phandle(np, "st,syscfg");
> +       if (IS_ERR(phy_dev->regmap)) {
> +               dev_err(phy_dev->dev, "No syscfg phandle specified\n");
> +               return PTR_ERR(phy_dev->regmap);
> +       }
> +
> +       of_property_read_u32(np, "st,sata-gen", &phy_dev->sata_gen);
> +       if (!phy_dev->sata_gen)
> +               phy_dev->sata_gen = SATA_GEN1;
> +
> +       phy_dev->pcie_tx_pol_inv =
> +               of_property_read_bool(np, "st,pcie-tx-pol-inv");
> +
> +       phy_dev->sata_tx_pol_inv =
> +               of_property_read_bool(np, "st,sata-tx-pol-inv");
> +

"st,sata-gen", "st,pcie-tx-pol-inv", "st,sata-tx-pol-inv" should be
defined in the sub-node ?

if yes then declare pcie_tx_pol_inv, sata_tx_pol_inv and sata_gen
in struct miphy365x instead struct miphy365x_dev.

[...]

Best Regards

Gabriel
