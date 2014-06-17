Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933203AbaFQSRJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 14:17:09 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:64895 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932762AbaFQSRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 14:17:05 -0400
Message-ID: <53A0861E.90400@gmail.com>
Date: Tue, 17 Jun 2014 20:17:02 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
To: =?UTF-8?B?QW50b2luZSBUw6luYXJ0?= 
	<antoine.tenart@free-electrons.com>,
        tj@kernel.org, kishon@ti.com
CC: alexandre.belloni@free-electrons.com, thomas.petazzoni@free-electrons.com,
        zmxu@marvell.com, jszhang@marvell.com,
        linux-arm-kernel@lists.infradead.org, linux-ide@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 1/7] phy: add a driver for the Berlin SATA PHY
References: <1402914392-6028-1-git-send-email-antoine.tenart@free-electrons.com> <1402914392-6028-2-git-send-email-antoine.tenart@free-electrons.com>
In-Reply-To: <1402914392-6028-2-git-send-email-antoine.tenart@free-electrons.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2014 12:26 PM, Antoine Ténart wrote:
> The Berlin SoC has a two SATA ports. Add a PHY driver to handle them.
> 
> The mode selection can let us think this PHY can be configured to fit
> other purposes. But there are reasons to think the SATA mode will be
> the only one usable: the PHY registers are only accessible indirectly
> through two registers in the SATA range, the PHY seems to be integrated
> and no information tells us the contrary. For these reasons, make the
> driver a SATA PHY driver.
> 
> Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
> ---
[...]
> diff --git a/drivers/phy/phy-berlin-sata.c b/drivers/phy/phy-berlin-sata.c
> new file mode 100644
> index 000000000000..907897a02672
> --- /dev/null
> +++ b/drivers/phy/phy-berlin-sata.c
> @@ -0,0 +1,232 @@
> +/*
> + * Marvell Berlin SATA PHY driver
> + *
> + * Copyright (C) 2014 Marvell Technology Group Ltd.
> + *
> + * Antoine Ténart <antoine.tenart@free-electrons.com>
> + *
> + * This file is licensed under the terms of the GNU General Public
> + * License version 2. This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/phy/phy.h>
> +#include <linux/io.h>
> +#include <linux/platform_device.h>
> +
> +#define HOST_VSA_ADDR		0x0
> +#define HOST_VSA_DATA		0x4
> +#define PORT_VSR_ADDR		0x78
> +#define PORT_VSR_DATA		0x7c
> +#define PORT_SCR_CTL		0x2c
> +
> +#define CONTROL_REGISTER	0x0
> +#define MBUS_SIZE_CONTROL	0x4
> +
> +#define POWER_DOWN_PHY0			BIT(6)
> +#define POWER_DOWN_PHY1			BIT(14)
> +#define MBUS_WRITE_REQUEST_SIZE_128	(BIT(2) << 16)
> +#define MBUS_READ_REQUEST_SIZE_128	(BIT(2) << 19)
> +
> +#define PHY_BASE		0x200

Antoine,

I gave your Berlin AHCI patches a try on BG2. I finally got it working
but BG2 has a different PHY_BASE and need some register fixups.

Please update this patch and the DT bindings to reflect the difference
of BG2Q with respect to BG2 as below.

[...]
> +
> +static const struct of_device_id phy_berlin_sata_of_match[] = {
> +	{ .compatible = "marvell,berlin-sata-phy" },

s/marvell,berlin-sata-phy/marvell,berlin2-sata-phy/

and add

marvell,berlin2q-sata-phy

That way it can be applied now without proper support for BG2
and I can send patches later.

Sebastian

> +	{ },
> +};
> +
> +static struct platform_driver phy_berlin_sata_driver = {
> +	.probe	= phy_berlin_sata_probe,
> +	.driver	= {
> +		.name		= "phy-berlin-sata",
> +		.owner		= THIS_MODULE,
> +		.of_match_table	= phy_berlin_sata_of_match,
> +	},
> +};
> +module_platform_driver(phy_berlin_sata_driver);
> +
> +MODULE_DESCRIPTION("Marvell Berlin SATA PHY driver");
> +MODULE_AUTHOR("Antoine Ténart <antoine.tenart@free-electrons.com>");
> +MODULE_LICENSE("GPL v2");
> 

