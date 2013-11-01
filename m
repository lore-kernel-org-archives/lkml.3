Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837Ab3KASN4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 14:13:56 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:49179 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002Ab3KASNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 14:13:55 -0400
Message-ID: <5273EF5E.7050402@gmail.com>
Date: Fri, 01 Nov 2013 19:13:50 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: Jonas Jensen <jonas.jensen@gmail.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, mturquette@linaro.org, mark.rutland@arm.com,
        tomasz.figa@gmail.com, adam.jaremko@gmail.com
Subject: Re: [PATCH v7] clk: add MOXA ART SoCs clock driver
References: <1375091062-3773-1-git-send-email-jonas.jensen@gmail.com> <1381330482-13846-1-git-send-email-jonas.jensen@gmail.com>
In-Reply-To: <1381330482-13846-1-git-send-email-jonas.jensen@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonas,

On 10/09/2013 04:54 PM, Jonas Jensen wrote:
> This patch adds MOXA ART SoCs clock driver support.
>
> Signed-off-by: Jonas Jensen<jonas.jensen@gmail.com>
> ---
>
> Notes:
>      Since last version, Adam Jaremko has been helping providing info on
>      the clock registers and the SoC in general. He's been looking at
>      bootloader sources in particular, which seem to do the same things
>      with slight variations.
>
>      Two separate clocks are now registered: clk_pll and clk_apb
>
>      clk_apb provides the same 48MHz frequency as before but the value is
>      calculated from clk_pll (192MHz) which in turn is calculated from a
>      fixed rate reference (12MHz).
>
>      Device drivers (watchdog, clocksource, MMC) should generally be
>      interested in reading apb_clk, not clk_pll.
>
>      clk_pll is obtained by multiplying the content of 0x98100030 (16)
>      with the reference.
>
>      The reference represent the PCB oscillator crystal, on UC-7112-LX
>      this has part number "12.000 KCC 20GT".
>
>      apb_clk is obtained by getting the rate of clk_pll and dividing it.
>
>      I don't think the parent clock can change rate, not without modifying
>      the hardware.
>
>      Changes since v6:
>
>      1. all rates calculated from a fixed rate reference clock
>      2. register two separate clocks, clk_pll and clk_apb
>
>      Applies to next-20130927
>
>   .../bindings/clock/moxa,moxart-clock.txt           |  43 ++++++++
>   drivers/clk/Makefile                               |   1 +
>   drivers/clk/clk-moxart.c                           | 109 +++++++++++++++++++++
>   3 files changed, 153 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/clock/moxa,moxart-clock.txt
>   create mode 100644 drivers/clk/clk-moxart.c
>
> diff --git a/Documentation/devicetree/bindings/clock/moxa,moxart-clock.txt b/Documentation/devicetree/bindings/clock/moxa,moxart-clock.txt
> new file mode 100644
> index 0000000..61fd327
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/clock/moxa,moxart-clock.txt
> @@ -0,0 +1,43 @@
> +Device Tree Clock bindings for arch-moxart
> +
> +This binding uses the common clock binding[1].
> +
> +[1] Documentation/devicetree/bindings/clock/clock-bindings.txt
> +
> +MOXA ART SoCs allow to determine PLL output and APB frequencies
> +by reading registers holding multiplier and divisor information.
> +
> +Required properties:
> +- compatible : Must be "moxa,moxart-pll-clock" or "moxa,moxart-apb-clock"
> +- #clock-cells : Should be 0
> +- reg : Should contain registers location and length
> +- clocks : Should contain phandle to parent clock
> +
> +Optional properties for "moxa,moxart-pll-clock":
> +- multiplier-reg : Should contain register offset
> +- multiplier-mask : Should contain register mask
> +- multiplier-shift : Should contain number of places the register is shifted to the right

Are those properties actually used ? Couldn't you derive those values
from compatible string ? Also it should normally be said explicitly
which register name we refer to, as specified in the datasheet.
However IIRC describing hardware to register bits level in the device
tree is discouraged.

> +- clock-output-names : Should contain clock name
> +
> +Optional properties for "moxa,moxart-apb-clock":
> +- divisor-reg : Should contain register offset
> +- divisor-mask : Should contain register mask
> +- divisor-shift : Should contain number of places the register is shifted to the right

Ditto.

> +- clock-output-names : Should contain clock name
> +
> +
> +For example:
> +
> +	clk_pll: clk_pll0@98100000 {
> +		compatible = "moxa,moxart-pll-clock";
> +		#clock-cells =<0>;
> +		reg =<0x98100000 0x34>;
> +		clocks =<&ref12>;
> +	};
> +
> +	clk_apb: clk_apb@98100000 {
> +		compatible = "moxa,moxart-apb-clock";
> +		#clock-cells =<0>;
> +		reg =<0x98100000 0x34>;
> +		clocks =<&pll0>;
> +	};
> diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
> index 7b11106..4c8d857 100644
> --- a/drivers/clk/Makefile
> +++ b/drivers/clk/Makefile
> @@ -11,6 +11,7 @@ obj-$(CONFIG_COMMON_CLK)	+= clk-composite.o
>
>   # SoCs specific
>   obj-$(CONFIG_ARCH_BCM2835)	+= clk-bcm2835.o
> +obj-$(CONFIG_ARCH_MOXART)	+= clk-moxart.o
>   obj-$(CONFIG_ARCH_NOMADIK)	+= clk-nomadik.o
>   obj-$(CONFIG_ARCH_HIGHBANK)	+= clk-highbank.o
>   obj-$(CONFIG_ARCH_NSPIRE)	+= clk-nspire.o
> diff --git a/drivers/clk/clk-moxart.c b/drivers/clk/clk-moxart.c
> new file mode 100644
> index 0000000..18b337a
> --- /dev/null
> +++ b/drivers/clk/clk-moxart.c
> @@ -0,0 +1,109 @@
> +/*
> + * MOXA ART SoCs clock driver.
> + *
> + * Copyright (C) 2013 Jonas Jensen
> + *
> + * Jonas Jensen<jonas.jensen@gmail.com>
> + *
> + * This file is licensed under the terms of the GNU General Public
> + * License version 2.  This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */
> +
> +#include<linux/clk-provider.h>
> +#include<linux/io.h>
> +#include<linux/of_address.h>
> +#include<linux/clkdev.h>
> +
> +void __init moxart_of_pll_clk_init(struct device_node *node)
> +{
> +	static void __iomem *base;
> +	struct clk *clk, *ref_clk;
> +	unsigned long rate;
> +	unsigned int mul, reg_offset = 0x30, reg_mask = 0x3f, reg_shift = 3;
> +	const char *name = node->name;
> +
> +	of_property_read_u32(node, "multiplier-reg",&reg_offset);
> +	of_property_read_u32(node, "multiplier-mask",&reg_mask);
> +	of_property_read_u32(node, "multiplier-shift",&reg_shift);
> +	of_property_read_string(node, "clock-output-names",&name);
> +
> +	base = of_iomap(node, 0);
> +	if (!base) {
> +		pr_err("%s: of_iomap failed\n", node->full_name);
> +		return;
> +	}
> +
> +	mul = (readl(base + reg_offset)>>  reg_shift)&  reg_mask;
> +	iounmap(base);
> +
> +	ref_clk = of_clk_get(node, 0);
> +	if (IS_ERR(ref_clk)) {
> +		pr_err("%s: of_clk_get failed\n", node->full_name);
> +		return;
> +	}
> +
> +	rate = (mul * clk_get_rate(ref_clk));

Parentheses seem redundant.

> +	clk = clk_register_fixed_rate(NULL, name, NULL, CLK_IS_ROOT, rate);
> +	clk_register_clkdev(clk, NULL, name);

You may want to check return value of this function, before actually
adding the clock provider.

> +	of_clk_add_provider(node, of_clk_src_simple_get, clk);
> +}
> +CLK_OF_DECLARE(moxart_pll_clock, "moxa,moxart-pll-clock",
> +	       moxart_of_pll_clk_init);
> +
> +void __init moxart_of_apb_clk_init(struct device_node *node)
> +{
> +	static void __iomem *base;
> +	struct clk *clk, *pll_clk;
> +	unsigned long rate;
> +	unsigned int div, val, reg_offset = 0xc, reg_mask = 0x7, reg_shift = 4;
> +	const char *name = node->name;
> +
> +	of_property_read_u32(node, "divisor-reg",&reg_offset);
> +	of_property_read_u32(node, "divisor-mask",&reg_mask);
> +	of_property_read_u32(node, "divisor-shift",&reg_shift);
> +	of_property_read_string(node, "clock-output-names",&name);
> +
> +	base = of_iomap(node, 0);
> +	if (!base) {
> +		pr_err("%s: of_iomap failed\n", node->full_name);
> +		return;
> +	}
> +
> +	val = (readl(base + reg_offset)>>  reg_shift)&  reg_mask;
> +	iounmap(base);
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
> +	pll_clk = of_clk_get(node, 0);
> +	if (IS_ERR(pll_clk)) {
> +		pr_err("%s: of_clk_get failed\n", node->full_name);
> +		return;
> +	}
> +
> +	rate = clk_get_rate(pll_clk) / (div * 2);
> +
> +	clk = clk_register_fixed_rate(NULL, name, NULL, CLK_IS_ROOT, rate);
> +	clk_register_clkdev(clk, NULL, name);

Ditto.

> +	of_clk_add_provider(node, of_clk_src_simple_get, clk);
> +}

Regards,
Sylwester
