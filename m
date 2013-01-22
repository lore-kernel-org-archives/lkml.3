Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925Ab3AVSDn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 13:03:43 -0500
Received: from eso.teric.us ([69.164.192.171]:51318 "EHLO eso.teric.us"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753963Ab3AVSDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 13:03:41 -0500
Date: Tue, 22 Jan 2013 12:08:22 -0600
From: Josh Cartwright <joshc@eso.teric.us>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] clk: Add axi-clkgen driver
Message-ID: <20130122180822.GA2371@kryptos>
References: <1357755120-32735-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357755120-32735-1-git-send-email-lars@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2013 at 07:12:00PM +0100, Lars-Peter Clausen wrote:
> This driver adds support for the AXI clkgen pcore to the common clock framework.
> The AXI clkgen pcore is a AXI front-end to the MMCM_ADV frequency synthesizer
> commonly found in Xilinx FPGAs.
> 
> The AXI clkgen pcore is used in Analog Devices' reference designs targeting
> Xilinx FPGAs.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---
>  .../devicetree/bindings/clock/axi-clkgen.txt       |  22 ++
>  drivers/clk/Kconfig                                |   8 +
>  drivers/clk/Makefile                               |   1 +
>  drivers/clk/clk-axi-clkgen.c                       | 326 +++++++++++++++++++++
>  4 files changed, 357 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/clock/axi-clkgen.txt
>  create mode 100644 drivers/clk/clk-axi-clkgen.c
> 
[..]
> diff --git a/drivers/clk/clk-axi-clkgen.c b/drivers/clk/clk-axi-clkgen.c
> new file mode 100644
> index 0000000..e9db225
> --- /dev/null
> +++ b/drivers/clk/clk-axi-clkgen.c
> @@ -0,0 +1,326 @@
> +/*
> + * AXI clkgen driver
> + *
> + * Copyright 2012-2013 Analog Device Inc.
> + *  Author: Lars-Peter Clausen <lars@metafoo.de>
> + *
> + * Licensed under the GPL-2.
> + *
> + */
> +
> +#include <linux/platform_device.h>
> +#include <linux/clk-provider.h>
> +#include <linux/clk.h>
> +#include <linux/slab.h>
> +#include <linux/io.h>
> +#include <linux/of.h>
> +#include <linux/module.h>
> +#include <linux/err.h>
> +
> +#define AXI_CLKGEN_REG_UPDATE_ENABLE	0x04
> +#define AXI_CLKGEN_REG_CLK_OUT1		0x08
> +#define AXI_CLKGEN_REG_CLK_OUT2		0x0c
> +#define AXI_CLKGEN_REG_CLK_DIV		0x10
> +#define AXI_CLKGEN_REG_CLK_FB1		0x14
> +#define AXI_CLKGEN_REG_CLK_FB2		0x18
> +#define AXI_CLKGEN_REG_LOCK1		0x1c
> +#define AXI_CLKGEN_REG_LOCK2		0x20
> +#define AXI_CLKGEN_REG_LOCK3		0x24
> +#define AXI_CLKGEN_REG_FILTER1		0x28
> +#define AXI_CLKGEN_REG_FILTER2		0x2c
> +
> +struct axi_clkgen {
> +	void __iomem *base;
> +	struct clk_hw clk_hw;
> +};
> +
> +static uint32_t axi_clkgen_lookup_filter(unsigned int m)
> +{
> +	switch (m) {
> +	case 0:
> +		return 0x01001990;
> +	case 1:
> +		return 0x01001190;
> +	case 2:
> +		return 0x01009890;
> +	case 3:
> +		return 0x01001890;
> +	case 4:
> +		return 0x01008890;
> +	case 5 ... 8:
> +		return 0x01009090;
> +	case 9 ... 11:
> +		return 0x0100890;

Just checking to ensure this ^ entry is correct, since it looks
different then the others (it may very well be).

   Josh
