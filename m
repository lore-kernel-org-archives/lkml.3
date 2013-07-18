Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758169Ab3GRJvK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 05:51:10 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:64271 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757421Ab3GRJvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 05:51:08 -0400
Date: Thu, 18 Jul 2013 10:50:35 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Jonas Jensen <jonas.jensen@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "arm@kernel.org" <arm@kernel.org>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] clk: add MOXA ART SoCs clock driver
Message-ID: <20130718095035.GA29153@e106331-lin.cambridge.arm.com>
References: <1372943292-6960-1-git-send-email-jonas.jensen@gmail.com>
 <1374067396-30155-1-git-send-email-jonas.jensen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374067396-30155-1-git-send-email-jonas.jensen@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 17, 2013 at 02:23:16PM +0100, Jonas Jensen wrote:
> This patch adds MOXA ART SoCs clock driver support.
> 
> Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
> ---
> 
> Notes:
>     Changes since v2:
>     
>     1. add devicetree bindings document
>     
>     Applies to next-20130716
> 
>  .../bindings/clock/moxa,moxart-core-clock.txt      | 19 +++++
>  drivers/clk/Makefile                               |  1 +
>  drivers/clk/clk-moxart.c                           | 82 ++++++++++++++++++++++
>  3 files changed, 102 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/clock/moxa,moxart-core-clock.txt
>  create mode 100644 drivers/clk/clk-moxart.c
> 
> diff --git a/Documentation/devicetree/bindings/clock/moxa,moxart-core-clock.txt b/Documentation/devicetree/bindings/clock/moxa,moxart-core-clock.txt
> new file mode 100644
> index 0000000..cf69361
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/clock/moxa,moxart-core-clock.txt
> @@ -0,0 +1,19 @@
> +Device Tree Clock bindings for arch-moxart
> +
> +This binding uses the common clock binding[1].
> +
> +[1] Documentation/devicetree/bindings/clock/clock-bindings.txt
> +
> +MOXA ART SoCs allow to determine core clock frequencies by reading
> +a register.
> +
> +Required properties:
> +- compatible : Should be "moxa,moxart-core-clock"
> +- reg : Should contain registers location and length
> +
> +For example:
> +
> +	clk: core-clock@98100000 {
> +		compatible = "moxa,moxart-core-clock";
> +		reg = <0x98100000 0x34>;
> +	};
> diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
> index 4038c2b..933622f 100644
> --- a/drivers/clk/Makefile
> +++ b/drivers/clk/Makefile
> @@ -11,6 +11,7 @@ obj-$(CONFIG_COMMON_CLK)	+= clk-composite.o
>  
>  # SoCs specific
>  obj-$(CONFIG_ARCH_BCM2835)	+= clk-bcm2835.o
> +obj-$(CONFIG_ARCH_MOXART)	+= clk-moxart.o
>  obj-$(CONFIG_ARCH_NOMADIK)	+= clk-nomadik.o
>  obj-$(CONFIG_ARCH_HIGHBANK)	+= clk-highbank.o
>  obj-$(CONFIG_ARCH_NSPIRE)	+= clk-nspire.o
> diff --git a/drivers/clk/clk-moxart.c b/drivers/clk/clk-moxart.c
> new file mode 100644
> index 0000000..79c27f4
> --- /dev/null
> +++ b/drivers/clk/clk-moxart.c
> @@ -0,0 +1,82 @@
> +/*
> + * MOXA ART SoCs clock driver.
> + *
> + * Copyright (C) 2013 Jonas Jensen
> + *
> + * Jonas Jensen <jonas.jensen@gmail.com>
> + *
> + * This file is licensed under the terms of the GNU General Public
> + * License version 2.  This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */
> +
> +#include <linux/platform_device.h>
> +#include <linux/clk.h>
> +#include <linux/clk-provider.h>
> +#include <linux/slab.h>
> +#include <linux/delay.h>
> +#include <linux/module.h>
> +#include <linux/io.h>
> +#include <linux/of_address.h>
> +#include <linux/clkdev.h>
> +
> +static const struct of_device_id moxart_apb_clock_match[] = {
> +	{ .compatible = "moxa,moxart-apb-clock" },
> +	{ }
> +};
> +
> +void __init moxart_of_clk_init(struct device_node *node)
> +{
> +	static void __iomem *base;
> +	struct device_node *clk_node;
> +	struct clk *clk;
> +	unsigned long rate;
> +	unsigned int mul, val, div;
> +
> +	base = of_iomap(node, 0);
> +	if (IS_ERR(base))
> +		panic("%s: of_iomap failed\n", node->full_name);
> +
> +	clk_node = of_find_matching_node(NULL, moxart_apb_clock_match);
> +	if (!clk_node)
> +		panic("%s: can't find clock DT node\n", node->full_name);
> +
> +	mul = (readl(base + 0x30) >> 3) & 0x1ff;
> +	val = (readl(base + 0x0c) >> 4) & 0x7;
> +
> +	switch (val) {
> +	case 1:
> +		div = 3;
> +		break;
> +	case 2:
> +		div = 4;
> +		break;
> +	case 3:
> +		div = 6;
> +		break;
> +	case 4:
> +		div = 8;
> +		break;
> +	default:
> +		div = 2;
> +		break;
> +	}
> +
> +	/*
> +	 * the rate calculation below is only tested and proven
> +	 * to be true for UC-7112-LX
> +	 *
> +	 * UC-7112-LX: mul=80 val=0
> +	 *
> +	 * to support other moxart SoC hardware, this may need
> +	 * a change, though it's possible it works there too
> +	 */
> +	rate = (mul * 1200000 / div);
> +
> +	clk = clk_register_fixed_rate(NULL, "clkapb", NULL, CLK_IS_ROOT, rate);
> +	clk_register_clkdev(clk, NULL, "clkapb");
> +	of_clk_add_provider(clk_node, of_clk_src_simple_get, clk);

This confuses me. moxart_of_clk_init gets called because there was a
"moxa,moxart-core-clock", node in the dt, but the driver only seems to
use the information to figure out the configuration of another clock
("moxa,moxart-apb-clock"), and never registers a clock specifically for
the core-clock.

I couldn't find "moxa,moxart-apb-clock" described in mainline. COuld you
describe the relationship between core-clock and apb-clock?

Thanks,
Mark.

> +
> +	iounmap(base);
> +}
> +CLK_OF_DECLARE(moxart_core_clock, "moxa,moxart-core-clock", moxart_of_clk_init);
> -- 
> 1.8.2.1
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
