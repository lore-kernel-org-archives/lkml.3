Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907AbaDZJd5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 05:33:57 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:40937 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbaDZJdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 05:33:54 -0400
Message-ID: <535B7D7D.4080807@gmail.com>
Date: Sat, 26 Apr 2014 11:33:49 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
To: =?UTF-8?B?QW50b2luZSBUw6luYXJ0?= 
	<antoine.tenart@free-electrons.com>,
        linus.walleij@linaro.org
CC: alexandre.belloni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/7] pinctrl: berlin: add the BG2 pinctrl driver
References: <1398268276-9696-1-git-send-email-antoine.tenart@free-electrons.com> <1398268276-9696-4-git-send-email-antoine.tenart@free-electrons.com>
In-Reply-To: <1398268276-9696-4-git-send-email-antoine.tenart@free-electrons.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2014 05:51 PM, Antoine Ténart wrote:
> Add the pin-controller driver for the Berlin BG2 SoC, with definition
> of its groups and functions. This uses the core Berlin pinctrl driver.
> 
> Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
> ---
[...]
> diff --git a/drivers/pinctrl/berlin/berlin-bg2.c b/drivers/pinctrl/berlin/berlin-bg2.c
> new file mode 100644
> index 000000000000..4a4efdc2232d
> --- /dev/null
> +++ b/drivers/pinctrl/berlin/berlin-bg2.c
> @@ -0,0 +1,251 @@
> +/*
> + * Marvell Berlin BG2 pinctrl driver.
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
> +#include <linux/of_device.h>
> +#include <linux/platform_device.h>
> +
> +#include "berlin.h"
> +
> +static const struct berlin_desc_group berlin2_soc_pinctrl_groups[] = {
> +	/* G */
> +	BERLIN_PINCTRL_GROUP("G0", 0x00, 0x1, 0x00,
> +		BERLIN_PINCTRL_FUNCTION(0x0, "spi1"),
> +		BERLIN_PINCTRL_FUNCTION(0x1, "gpio")),
> +	BERLIN_PINCTRL_GROUP("G1", 0x00, 0x2, 0x01,
> +		BERLIN_PINCTRL_FUNCTION(0x0, "spi1"),
> +		BERLIN_PINCTRL_FUNCTION(0x1, "gpio"),
> +		BERLIN_PINCTRL_FUNCTION(0x2, "usb1")),
> +	BERLIN_PINCTRL_GROUP("G2", 0x00, 0x2, 0x02,
> +		BERLIN_PINCTRL_FUNCTION(0x0, "gpio"),
> +		BERLIN_PINCTRL_FUNCTION(0x1, "spi1"),
> +		BERLIN_PINCTRL_FUNCTION(0x2, "pwm"),
> +		BERLIN_PINCTRL_FUNCTION(0x3, "i2s0")),
> +	BERLIN_PINCTRL_GROUP("G3", 0x00, 0x2, 0x04,
> +		BERLIN_PINCTRL_FUNCTION(0x0, "soc"),
> +		BERLIN_PINCTRL_FUNCTION(0x1, "spi1"),
> +		BERLIN_PINCTRL_FUNCTION(0x2, "gpio"),
> +		BERLIN_PINCTRL_FUNCTION(0x3, "i2s1")),
> +	BERLIN_PINCTRL_GROUP("G4", 0x00, 0x2, 0x06,
> +		BERLIN_PINCTRL_FUNCTION(0x0, "spi1"),
> +		BERLIN_PINCTRL_FUNCTION(0x1, "gpio"),
> +		BERLIN_PINCTRL_FUNCTION(0x2, "pwm")),
> +	BERLIN_PINCTRL_GROUP("G5", 0x00, 0x3, 0x08,
> +		BERLIN_PINCTRL_FUNCTION(0x0, "gpio"),
> +		BERLIN_PINCTRL_FUNCTION(0x1, "sts1"),
> +		BERLIN_PINCTRL_FUNCTION(0x2, "et"),
> +		/*
> +		 * Mode 0x3 mux i2s2 mclk *and* i2s3 mclk:
> +		 * add two functions so it can be used with other groups
> +		 * within the same subnode in the device tree
> +		 */
> +		BERLIN_PINCTRL_FUNCTION(0x3, "i2s2"),
> +		BERLIN_PINCTRL_FUNCTION(0x3, "i2s3")),
> +	BERLIN_PINCTRL_GROUP("G6", 0x00, 0x2, 0x0b,
> +		BERLIN_PINCTRL_FUNCTION(0x0, "gpio"),
> +		BERLIN_PINCTRL_FUNCTION(0x1, "sts0"),
> +		BERLIN_PINCTRL_FUNCTION(0x2, "et")),
> +	BERLIN_PINCTRL_GROUP("G7", 0x00, 0x3, 0x0d,
> +		BERLIN_PINCTRL_FUNCTION(0x0, "gpio"),
> +		BERLIN_PINCTRL_FUNCTION(0x1, "sts0"),
> +		BERLIN_PINCTRL_FUNCTION(0x2, "et"),
> +		BERLIN_PINCTRL_FUNCTION(0x3, "vdac")),
> +	BERLIN_PINCTRL_GROUP("G8", 0x00, 0x3, 0x10,
> +		BERLIN_PINCTRL_FUNCTION(0x0, "gpio"),
> +		BERLIN_PINCTRL_FUNCTION(0x1, "sd0"),
> +		BERLIN_PINCTRL_FUNCTION(0x2, "et"),
> +		BERLIN_PINCTRL_FUNCTION(0x3, "usb0_dbg"),
> +		BERLIN_PINCTRL_FUNCTION(0x4, "sata_dbg"),
> +		BERLIN_PINCTRL_FUNCTION(0x7, "usb1_dbg")),
> +	BERLIN_PINCTRL_GROUP("G9", 0x00, 0x3, 0x13,
> +		BERLIN_PINCTRL_FUNCTION(0x0, "gpio"),
> +		BERLIN_PINCTRL_FUNCTION(0x1, "sd0"),
> +		BERLIN_PINCTRL_FUNCTION(0x2, "et"),
> +		BERLIN_PINCTRL_FUNCTION(0x3, "usb0_dbg"),
> +		BERLIN_PINCTRL_FUNCTION(0x4, "sata_dbg"),
> +		BERLIN_PINCTRL_FUNCTION(0x7, "usb1_dbg")),
> +	BERLIN_PINCTRL_GROUP("G10", 0x00, 0x2, 0x16,
> +		BERLIN_PINCTRL_FUNCTION(0x0, "soc"),
> +		BERLIN_PINCTRL_FUNCTION(0x1, "tw0"),

s/tw/twsi/ and all below.

> +		BERLIN_PINCTRL_FUNCTION(0x2, "gpio"),
> +		BERLIN_PINCTRL_FUNCTION(0x3, "ptp")),
> +	BERLIN_PINCTRL_GROUP("G11", 0x00, 0x2, 0x18,
> +		BERLIN_PINCTRL_FUNCTION(0x0, "soc"),
> +		BERLIN_PINCTRL_FUNCTION(0x1, "tw1"),
> +		BERLIN_PINCTRL_FUNCTION(0x2, "gpio"),
> +		BERLIN_PINCTRL_FUNCTION(0x3, "eddc")),
> +	BERLIN_PINCTRL_GROUP("G12", 0x00, 0x3, 0x1a,
> +		BERLIN_PINCTRL_FUNCTION(0x0, "sts2"),
> +		BERLIN_PINCTRL_FUNCTION(0x1, "sata"),
> +		BERLIN_PINCTRL_FUNCTION(0x2, "sd1"),
> +		BERLIN_PINCTRL_FUNCTION(0x3, "usb0_dbg"),
> +		BERLIN_PINCTRL_FUNCTION(0x4, "sts1"),
> +		BERLIN_PINCTRL_FUNCTION(0x7, "usb1_dbg")),
> +	BERLIN_PINCTRL_GROUP("G13", 0x04, 0x3, 0x00,
> +		BERLIN_PINCTRL_FUNCTION(0x0, "gpio"),
> +		BERLIN_PINCTRL_FUNCTION(0x1, "sata"),
> +		BERLIN_PINCTRL_FUNCTION(0x2, "sd1"),
> +		BERLIN_PINCTRL_FUNCTION(0x3, "usb0_dbg"),
> +		BERLIN_PINCTRL_FUNCTION(0x4, "sts1"),
> +		BERLIN_PINCTRL_FUNCTION(0x7, "usb1_dbg")),
> +	BERLIN_PINCTRL_GROUP("G14", 0x04, 0x1, 0x03,
> +		BERLIN_PINCTRL_FUNCTION_UNKNOW),
> +	BERLIN_PINCTRL_GROUP("G15", 0x04, 0x2, 0x04,
> +		BERLIN_PINCTRL_FUNCTION(0x0, "gpio"),
> +		BERLIN_PINCTRL_FUNCTION(0x2, "et"),
> +		BERLIN_PINCTRL_FUNCTION(0x3, "osco")),
> +	BERLIN_PINCTRL_GROUP("G16", 0x04, 0x3, 0x06,
> +		BERLIN_PINCTRL_FUNCTION(0x0, "gpio"),
> +		BERLIN_PINCTRL_FUNCTION(0x1, "dvio"),
> +		BERLIN_PINCTRL_FUNCTION(0x2, "fp")),
> +	BERLIN_PINCTRL_GROUP("G17", 0x04, 0x3, 0x09,
> +		BERLIN_PINCTRL_FUNCTION(0x0, "gpio"),
> +		BERLIN_PINCTRL_FUNCTION(0x1, "dvio"),
> +		BERLIN_PINCTRL_FUNCTION(0x2, "fp")),
> +	BERLIN_PINCTRL_GROUP("G18", 0x04, 0x1, 0x0c,
> +		BERLIN_PINCTRL_FUNCTION(0x0, "pll"),
> +		BERLIN_PINCTRL_FUNCTION(0x1, "i2s0")),
> +	BERLIN_PINCTRL_GROUP("G19", 0x04, 0x1, 0x0d,
> +		BERLIN_PINCTRL_FUNCTION(0x0, "i2s0"),
> +		BERLIN_PINCTRL_FUNCTION(0x1, "pwm")),
> +	BERLIN_PINCTRL_GROUP("G20", 0x04, 0x1, 0x0e,
> +		BERLIN_PINCTRL_FUNCTION(0x0, "spdif"),
> +		BERLIN_PINCTRL_FUNCTION(0x1, "arc")),
> +	BERLIN_PINCTRL_GROUP("G21", 0x04, 0x3, 0x0f,
> +		BERLIN_PINCTRL_FUNCTION(0x0, "gpio"),
> +		BERLIN_PINCTRL_FUNCTION(0x1, "dvio"),
> +		BERLIN_PINCTRL_FUNCTION(0x2, "fp"),
> +		BERLIN_PINCTRL_FUNCTION(0x3, "adac_dbg"),
> +		BERLIN_PINCTRL_FUNCTION(0x4, "pdm_a"),	/* gpio17..19,pdm */
> +		BERLIN_PINCTRL_FUNCTION(0x7, "pdm_b")),	/* gpio12..14,pdm */
> +	BERLIN_PINCTRL_GROUP("G22", 0x04, 0x3, 0x12,
> +		BERLIN_PINCTRL_FUNCTION(0x0, "gpio"),
> +		BERLIN_PINCTRL_FUNCTION(0x1, "dv0"),
> +		BERLIN_PINCTRL_FUNCTION(0x2, "fp"),
> +		BERLIN_PINCTRL_FUNCTION(0x3, "tw0"),
> +		BERLIN_PINCTRL_FUNCTION(0x4, "pwm")),
> +	BERLIN_PINCTRL_GROUP("G23", 0x04, 0x3, 0x15,
> +		BERLIN_PINCTRL_FUNCTION(0x0, "vclki"),
> +		BERLIN_PINCTRL_FUNCTION(0x1, "dv0"),
> +		BERLIN_PINCTRL_FUNCTION(0x2, "fp"),
> +		BERLIN_PINCTRL_FUNCTION(0x3, "i2s0"),
> +		BERLIN_PINCTRL_FUNCTION(0x4, "pwm"),
> +		BERLIN_PINCTRL_FUNCTION(0x7, "pdm")),
> +	BERLIN_PINCTRL_GROUP("G24", 0x04, 0x2, 0x18,
> +		BERLIN_PINCTRL_FUNCTION(0x0, "i2s2"),
> +		BERLIN_PINCTRL_FUNCTION(0x1, "i2s1")),
> +	BERLIN_PINCTRL_GROUP("G25", 0x04, 0x2, 0x1a,
> +		BERLIN_PINCTRL_FUNCTION(0x0, "gpio"),
> +		BERLIN_PINCTRL_FUNCTION(0x1, "nand"),
> +		BERLIN_PINCTRL_FUNCTION(0x2, "i2s2")),
> +	BERLIN_PINCTRL_GROUP("G26", 0x04, 0x1, 0x1c,
> +		BERLIN_PINCTRL_FUNCTION(0x0, "nand"),
> +		BERLIN_PINCTRL_FUNCTION(0x1, "emmc")),
> +	BERLIN_PINCTRL_GROUP("G27", 0x04, 0x1, 0x1d,
> +		BERLIN_PINCTRL_FUNCTION(0x0, "gpio"),
> +		BERLIN_PINCTRL_FUNCTION(0x1, "nand")),
> +	BERLIN_PINCTRL_GROUP("G28", 0x04, 0x2, 0x1e,
> +		BERLIN_PINCTRL_FUNCTION(0x0, "dvo"),
> +		BERLIN_PINCTRL_FUNCTION(0x2, "sp")),
> +};
> +
> +static const struct berlin_desc_group berlin2_sysmgr_pinctrl_groups[] = {
> +	/* GSM */
> +	BERLIN_PINCTRL_GROUP("GSM0", 0x40, 0x2, 0x00,
> +		BERLIN_PINCTRL_FUNCTION(0x0, "gpio"),
> +		BERLIN_PINCTRL_FUNCTION(0x1, "spi2"),
> +		BERLIN_PINCTRL_FUNCTION(0x2, "eth1")),
> +	BERLIN_PINCTRL_GROUP("GSM1", 0x40, 0x2, 0x02,
> +		BERLIN_PINCTRL_FUNCTION(0x0, "gpio"),
> +		BERLIN_PINCTRL_FUNCTION(0x1, "spi2"),
> +		BERLIN_PINCTRL_FUNCTION(0x2, "eth1")),
> +	BERLIN_PINCTRL_GROUP("GSM2", 0x40, 0x2, 0x04,
> +		BERLIN_PINCTRL_FUNCTION(0x0, "tw2"),
> +		BERLIN_PINCTRL_FUNCTION(0x1, "spi2")),
> +	BERLIN_PINCTRL_GROUP("GSM3", 0x40, 0x2, 0x06,
> +		BERLIN_PINCTRL_FUNCTION(0x0, "gpio"),
> +		BERLIN_PINCTRL_FUNCTION(0x1, "uart0"),	/* CTS/RDS */

s/RDS/RTS/

Sebastian

> +		BERLIN_PINCTRL_FUNCTION(0x2, "uart2"),	/* RX/TX */
> +		BERLIN_PINCTRL_FUNCTION(0x3, "tw2")),
> +	BERLIN_PINCTRL_GROUP("GSM4", 0x40, 0x2, 0x08,
> +		BERLIN_PINCTRL_FUNCTION(0x0, "uart0"),	/* RX/TX */
> +		BERLIN_PINCTRL_FUNCTION(0x1, "irda0")),
> +	BERLIN_PINCTRL_GROUP("GSM5", 0x40, 0x2, 0x0a,
> +		BERLIN_PINCTRL_FUNCTION(0x0, "gpio"),
> +		BERLIN_PINCTRL_FUNCTION(0x1, "uart1"),	/* RX/TX */
> +		BERLIN_PINCTRL_FUNCTION(0x2, "irda1"),
> +		BERLIN_PINCTRL_FUNCTION(0x3, "tw3")),
> +	BERLIN_PINCTRL_GROUP("GSM6", 0x40, 0x2, 0x0c,
> +		BERLIN_PINCTRL_FUNCTION(0x0, "gpio"),
> +		BERLIN_PINCTRL_FUNCTION(0x1, "spi2"),
> +		BERLIN_PINCTRL_FUNCTION(0x1, "clki")),
> +	BERLIN_PINCTRL_GROUP("GSM7", 0x40, 0x1, 0x0e,
> +		BERLIN_PINCTRL_FUNCTION(0x0, "gpio"),
> +		BERLIN_PINCTRL_FUNCTION(0x1, "hdmi")),
> +	BERLIN_PINCTRL_GROUP("GSM8", 0x40, 0x1, 0x0f,
> +		BERLIN_PINCTRL_FUNCTION(0x0, "gpio"),
> +		BERLIN_PINCTRL_FUNCTION(0x1, "hdmi")),
> +	BERLIN_PINCTRL_GROUP("GSM9", 0x40, 0x1, 0x10,
> +		BERLIN_PINCTRL_FUNCTION(0x0, "gpio"),
> +		BERLIN_PINCTRL_FUNCTION(0x1, "led")),
> +	BERLIN_PINCTRL_GROUP("GSM10", 0x40, 0x1, 0x11,
> +		BERLIN_PINCTRL_FUNCTION(0x0, "gpio"),
> +		BERLIN_PINCTRL_FUNCTION(0x1, "led")),
> +	BERLIN_PINCTRL_GROUP("GSM11", 0x40, 0x1, 0x12,
> +		BERLIN_PINCTRL_FUNCTION(0x0, "gpio"),
> +		BERLIN_PINCTRL_FUNCTION(0x1, "led")),
> +};
> +
> +static const struct berlin_pinctrl_desc berlin2_soc_pinctrl_data = {
> +	.groups = berlin2_soc_pinctrl_groups,
> +	.ngroups = ARRAY_SIZE(berlin2_soc_pinctrl_groups),
> +};
> +
> +static const struct berlin_pinctrl_desc berlin2_sysmgr_pinctrl_data = {
> +	.groups = berlin2_sysmgr_pinctrl_groups,
> +	.ngroups = ARRAY_SIZE(berlin2_sysmgr_pinctrl_groups),
> +};
> +
> +static const struct of_device_id berlin2_pinctrl_match[] = {
> +	{
> +		.compatible = "marvell,berlin2-soc-pinctrl",
> +		.data = &berlin2_soc_pinctrl_data
> +	},
> +	{
> +		.compatible = "marvell,berlin2-sysmgr-pinctrl",
> +		.data = &berlin2_sysmgr_pinctrl_data
> +	},
> +	{}
> +};
> +MODULE_DEVICE_TABLE(of, berlin2_pinctrl_match);
> +
> +static int berlin2_pinctrl_probe(struct platform_device *pdev)
> +{
> +	const struct of_device_id
> +		*device = of_match_device(berlin2_pinctrl_match, &pdev->dev);
> +
> +	return berlin_pinctrl_probe(pdev, device->data);
> +}
> +
> +static struct platform_driver berlin2_pinctrl_driver = {
> +	.probe	= berlin2_pinctrl_probe,
> +	.driver	= {
> +		.name = "berlin-bg2-pinctrl",
> +		.owner = THIS_MODULE,
> +		.of_match_table = berlin2_pinctrl_match,
> +	},
> +};
> +module_platform_driver(berlin2_pinctrl_driver);
> +
> +MODULE_AUTHOR("Antoine Ténart <antoine.tenart@free-electrons.com>");
> +MODULE_DESCRIPTION("Marvell Berlin BG2 pinctrl driver");
> +MODULE_LICENSE("GPL");
> 

