Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548AbaAQPR5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 10:17:57 -0500
Received: from service87.mimecast.com ([91.220.42.44]:32849 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471AbaAQPRy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 10:17:54 -0500
Message-ID: <52D949A6.9060607@arm.com>
Date: Fri, 17 Jan 2014 15:17:58 +0000
From: Sudeep Holla <Sudeep.Holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Jonas Jensen <jonas.jensen@gmail.com>,
        "mturquette@linaro.org" <mturquette@linaro.org>
CC: Sudeep.Holla@arm.com,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>, Mark Rutland <Mark.Rutland@arm.com>,
        "tomasz.figa@gmail.com" <tomasz.figa@gmail.com>,
        "adam.jaremko@gmail.com" <adam.jaremko@gmail.com>,
        "sylvester.nawrocki@gmail.com" <sylvester.nawrocki@gmail.com>
Subject: Re: [PATCH v9] clk: add MOXA ART SoCs clock driver
References: <1386602163-28479-1-git-send-email-jonas.jensen@gmail.com> <1389971035-17781-1-git-send-email-jonas.jensen@gmail.com>
In-Reply-To: <1389971035-17781-1-git-send-email-jonas.jensen@gmail.com>
X-OriginalArrivalTime: 17 Jan 2014 15:17:49.0429 (UTC) FILETIME=[487EC250:01CF1397]
X-MC-Unique: 114011715175103601
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/01/14 15:03, Jonas Jensen wrote:
> This patch adds MOXA ART SoCs clock driver support.
> 
> Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
> ---
> 
> Notes:
>     Changes since v8:
>     
>     1. rebase drivers/clk/Makefile to next-20140117
>     
>     DT bindings document:
>     
>     2. use two separate sections describing PLL/APB
>     3. update example
>     
>     Applies to next-20140117
> 
>  .../bindings/clock/moxa,moxart-clock.txt           |  48 +++++++++
>  drivers/clk/Makefile                               |   1 +
>  drivers/clk/clk-moxart.c                           | 112 +++++++++++++++++++++
>  3 files changed, 161 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/clock/moxa,moxart-clock.txt
>  create mode 100644 drivers/clk/clk-moxart.c
> 
> diff --git a/Documentation/devicetree/bindings/clock/moxa,moxart-clock.txt b/Documentation/devicetree/bindings/clock/moxa,moxart-clock.txt
> new file mode 100644
> index 0000000..242e3fc
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/clock/moxa,moxart-clock.txt
> @@ -0,0 +1,48 @@
> +Device Tree Clock bindings for arch-moxart
> +
> +This binding uses the common clock binding[1].
> +
> +[1] Documentation/devicetree/bindings/clock/clock-bindings.txt
> +
> +MOXA ART SoCs allow to determine PLL output and APB frequencies
> +by reading registers holding multiplier and divisor information.
> +
> +
> +PLL:
> +
> +Required properties:
> +- compatible : Must be "moxa,moxart-pll-clock"
> +- #clock-cells : Should be 0
> +- reg : Should contain registers location and length
> +- clocks : Should contain phandle to parent clock
> +
> +Optional properties:
> +- clock-output-names : Should contain clock name
> +
> +
> +APB:
> +
> +Required properties:
> +- compatible : Must be "moxa,moxart-apb-clock"
> +- #clock-cells : Should be 0
> +- reg : Should contain registers location and length
> +- clocks : Should contain phandle to parent clock
> +
> +Optional properties:
> +- clock-output-names : Should contain clock name
> +
> +
> +For example:
> +
> +	clk_pll: clk_pll@98100000 {
> +		compatible = "moxa,moxart-pll-clock";
> +		#clock-cells = <0>;
> +		reg = <0x98100000 0x34>;
> +	};
> +
> +	clk_apb: clk_apb@98100000 {
> +		compatible = "moxa,moxart-apb-clock";
> +		#clock-cells = <0>;
> +		reg = <0x98100000 0x34>;
> +		clocks = <&clk_pll>;
> +	};
> diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
> index 0c16e9c..ed5d58d 100644
> --- a/drivers/clk/Makefile
> +++ b/drivers/clk/Makefile
> @@ -12,6 +12,7 @@ obj-$(CONFIG_COMMON_CLK)	+= clk-composite.o
>  # SoCs specific
>  obj-$(CONFIG_ARCH_BCM2835)	+= clk-bcm2835.o
>  obj-$(CONFIG_ARCH_EFM32)	+= clk-efm32gg.o
> +obj-$(CONFIG_ARCH_MOXART)	+= clk-moxart.o
>  obj-$(CONFIG_ARCH_NOMADIK)	+= clk-nomadik.o
>  obj-$(CONFIG_ARCH_HIGHBANK)	+= clk-highbank.o
>  obj-$(CONFIG_ARCH_HI3xxx)	+= hisilicon/
> diff --git a/drivers/clk/clk-moxart.c b/drivers/clk/clk-moxart.c
> new file mode 100644
> index 0000000..f0436a3
> --- /dev/null
> +++ b/drivers/clk/clk-moxart.c
> @@ -0,0 +1,112 @@
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
> +#include <linux/clk-provider.h>
> +#include <linux/io.h>
> +#include <linux/of_address.h>
> +#include <linux/clkdev.h>
> +
> +void __init moxart_of_pll_clk_init(struct device_node *node)
> +{
> +	static void __iomem *base;
> +	struct clk *clk, *ref_clk;
> +	unsigned long rate;
> +	unsigned int mul;
> +	const char *name = node->name;
> +
> +	of_property_read_string(node, "clock-output-names", &name);
> +
> +	base = of_iomap(node, 0);
> +	if (!base) {
> +		pr_err("%s: of_iomap failed\n", node->full_name);
> +		return;
> +	}
> +
> +	mul = readl(base + 0x30) >> 3 & 0x3f;
> +	iounmap(base);
> +
> +	ref_clk = of_clk_get(node, 0);
> +	if (IS_ERR(ref_clk)) {
> +		pr_err("%s: of_clk_get failed\n", node->full_name);
> +		return;
> +	}
> +
> +	rate = mul * clk_get_rate(ref_clk);
> +
> +	clk = clk_register_fixed_rate(NULL, name, NULL, CLK_IS_ROOT, rate);
> +	if (IS_ERR(clk)) {
> +		pr_err("%s: clk_register_fixed_rate failed\n", node->full_name);
> +		return;
> +	}
> +
> +	clk_register_clkdev(clk, NULL, name);
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
> +	unsigned int div, val;
> +	const char *name = node->name;
> +
> +	of_property_read_string(node, "clock-output-names", &name);
> +
> +	base = of_iomap(node, 0);
> +	if (!base) {
> +		pr_err("%s: of_iomap failed\n", node->full_name);
> +		return;
> +	}
> +
> +	val = readl(base + 0xc) >> 4 & 0x7;
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

How about something like this to avoid unnecessary switch:
	int div_idx[] = { 2, 3, 4, 6, 8};
	if (val > 4)
		val = 0;
	div = div_idx[val];

Regards,
Sudeep

