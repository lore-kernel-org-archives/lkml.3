Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606AbaJ1OxP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 10:53:15 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:57029 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550AbaJ1OxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 10:53:13 -0400
MIME-Version: 1.0
In-Reply-To: <1413479495-14206-2-git-send-email-soren.brinkmann@xilinx.com>
References: <1413479495-14206-1-git-send-email-soren.brinkmann@xilinx.com>
	<1413479495-14206-2-git-send-email-soren.brinkmann@xilinx.com>
Date: Tue, 28 Oct 2014 15:53:12 +0100
Message-ID: <CACRpkdaPiXiDegibiaqGdFxApowNEmbG0L4RDJVv-t+xhGBmjA@mail.gmail.com>
Subject: Re: [PATCH RFC v2 1/8] pinctrl: Add driver for Zynq
From: Linus Walleij <linus.walleij@linaro.org>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
Cc: Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 7:11 PM, Soren Brinkmann
<soren.brinkmann@xilinx.com> wrote:

> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
> changes since RFC:
>  - use syscon/regmap to access registers in SLCR space
>  - add pinctrl to zc702 DT
>  - rebase to 3.18: rename enable -> set_mux
>  - add kernel-doc
>  - support pinconf
>    - supported attributes
>      - pin-bias: pull up, tristate, disable
>      - slew-rate: 0 == slow, 1 == fast; generic pinconf does not display
>        argument

Great progress!!

(...)
> +++ b/arch/arm/mach-zynq/Kconfig
> @@ -9,6 +9,7 @@ config ARCH_ZYNQ
>         select HAVE_ARM_TWD if SMP
>         select ICST
>         select MFD_SYSCON
> +       select PINCTRL

Don't you also want to select PINCTRL_ZYNQ or is it
really optional?

>         select SOC_BUS
>         help
>           Support for Xilinx Zynq ARM Cortex A9 Platform

Please split these machine changes into a separate patch. It is hitting
a totally different subsystem.

(...)
> +++ b/drivers/pinctrl/pinctrl-zynq.c
(...)
> +static const struct pinctrl_ops zynq_pctrl_ops = {
> +       .get_groups_count = zynq_pctrl_get_groups_count,
> +       .get_group_name = zynq_pctrl_get_group_name,
> +       .get_group_pins = zynq_pctrl_get_group_pins,
> +       .dt_node_to_map = pinconf_generic_dt_node_to_map_group,
> +       .dt_free_map = pinctrl_utils_dt_free_map
> +};

Nice use of generic functions!

> +static int zynq_pinconf_cfg_get(struct pinctrl_dev *pctldev,
> +                               unsigned pin,
> +                               unsigned long *config)
> +{
> +       u32 reg;
> +       int ret;
> +       unsigned int arg = 0;
> +       unsigned int param = pinconf_to_config_param(*config);
> +       struct zynq_pinctrl *pctrl = pinctrl_dev_get_drvdata(pctldev);
> +
> +       if (pin > 53)
> +               return -ENOTSUPP;

53 looks a bit magical? #define or comment here to explain what's
going on?

Apart from these small things this looks like merge material.

Yours,
Linus Walleij
