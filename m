Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbaF0SXQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 14:23:16 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:63324 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbaF0SXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 14:23:14 -0400
MIME-Version: 1.0
X-Originating-IP: [95.23.59.197]
In-Reply-To: <1403848871-26519-3-git-send-email-peter.ujfalusi@ti.com>
References: <1403848871-26519-1-git-send-email-peter.ujfalusi@ti.com>
	<1403848871-26519-3-git-send-email-peter.ujfalusi@ti.com>
Date: Fri, 27 Jun 2014 20:23:12 +0200
Message-ID: <CABxcv=metB4=eoT=fAh7S-b_mhAvHcJtn2wrV8v8koSyKMxNNw@mail.gmail.com>
Subject: Re: [RESEND 2/2] clk: Add driver for Palmas clk32kg and clk32kgaudio clocks
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        ldewangan@nvidia.com, linux-doc@vger.kernel.org,
        Nishanth Menon <nm@ti.com>, Rob Herring <robh+dt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Peter,

On Fri, Jun 27, 2014 at 8:01 AM, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:
> Palmas class of devices can provide 32K clock(s) to be used by other devices
> on the board. Depending on the actual device the provided clocks can be:
> CLK32K_KG and CLK32K_KGAUDIO
> or only one:
> CLK32K_KG (TPS659039 for example)
>
> Use separate compatible flags for the two 32K clock.
> A system which needs or have only one of the 32k clock from
> Palmas will need to add node(s) for each clock as separate section
> in the dts file.
> The two compatible property is:
> "ti,palmas-clk32kg" for clk32kg clock
> "ti,palmas-clk32kgaudio" for clk32kgaudio clock
>
> Apart from the register control of the clocks - which is done via
> the clock API there is a posibility to enable the external sleep
> control. In this way the clock can be enabled/disabled on demand by the
> user of the clock.
>
> See the documentation for more details.
>
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> Reviewed-by: Nishanth Menon <nm@ti.com>
> ---
>  drivers/clk/Kconfig      |   7 ++
>  drivers/clk/Makefile     |   1 +
>  drivers/clk/clk-palmas.c | 307 +++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 315 insertions(+)
>  create mode 100644 drivers/clk/clk-palmas.c
>
> diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
> index 9f9c5ae5359b..cfd3af7b2cbd 100644
> --- a/drivers/clk/Kconfig
> +++ b/drivers/clk/Kconfig
> @@ -102,6 +102,13 @@ config COMMON_CLK_KEYSTONE
>            Supports clock drivers for Keystone based SOCs. These SOCs have local
>           a power sleep control module that gate the clock to the IPs and PLLs.
>
> +config COMMON_CLK_PALMAS
> +       tristate "Clock driver for TI Palmas devices"
> +       depends on MFD_PALMAS
> +       ---help---
> +         This driver supports TI Palmas devices 32KHz output KG and KG_AUDIO
> +         using common clock framework.
> +
>  source "drivers/clk/qcom/Kconfig"
>
>  endmenu
> diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
> index 567f10259029..312742c10661 100644
> --- a/drivers/clk/Makefile
> +++ b/drivers/clk/Makefile
> @@ -22,6 +22,7 @@ obj-$(CONFIG_COMMON_CLK_MAX77686)     += clk-max77686.o
>  obj-$(CONFIG_ARCH_MOXART)              += clk-moxart.o
>  obj-$(CONFIG_ARCH_NOMADIK)             += clk-nomadik.o
>  obj-$(CONFIG_ARCH_NSPIRE)              += clk-nspire.o
> +obj-$(CONFIG_COMMON_CLK_PALMAS)                += clk-palmas.o
>  obj-$(CONFIG_CLK_PPC_CORENET)          += clk-ppc-corenet.o
>  obj-$(CONFIG_COMMON_CLK_S2MPS11)       += clk-s2mps11.o
>  obj-$(CONFIG_COMMON_CLK_SI5351)                += clk-si5351.o
> diff --git a/drivers/clk/clk-palmas.c b/drivers/clk/clk-palmas.c
> new file mode 100644
> index 000000000000..781630e1372b
> --- /dev/null
> +++ b/drivers/clk/clk-palmas.c
> @@ -0,0 +1,307 @@
> +/*
> + * Clock driver for Palmas device.
> + *
> + * Copyright (c) 2013, NVIDIA Corporation.
> + * Copyright (c) 2013-2014 Texas Instruments, Inc.
> + *
> + * Author:     Laxman Dewangan <ldewangan@nvidia.com>
> + *             Peter Ujfalusi <peter.ujfalusi@ti.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation version 2.
> + *
> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any kind,
> + * whether express or implied; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
> + * General Public License for more details.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/clkdev.h>
> +#include <linux/clk-provider.h>
> +#include <linux/mfd/palmas.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_device.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +
> +#define PALMAS_CLOCK_DT_EXT_CONTROL_ENABLE1    1
> +#define PALMAS_CLOCK_DT_EXT_CONTROL_ENABLE2    2
> +#define PALMAS_CLOCK_DT_EXT_CONTROL_NSLEEP     3
> +
> +struct palmas_clk32k_desc {
> +       const char *clk_name;
> +       unsigned int control_reg;
> +       unsigned int enable_mask;
> +       unsigned int sleep_mask;
> +       unsigned int sleep_reqstr_id;
> +       int delay;
> +};
> +
> +struct palmas_clock_info {
> +       struct device *dev;
> +       struct clk *clk;
> +       struct clk_hw hw;
> +       struct palmas *palmas;
> +       struct palmas_clk32k_desc *clk_desc;
> +       int ext_control_pin;
> +};
> +
> +static inline struct palmas_clock_info *to_palmas_clks_info(struct clk_hw *hw)
> +{
> +       return container_of(hw, struct palmas_clock_info, hw);
> +}
> +
> +static unsigned long palmas_clks_recalc_rate(struct clk_hw *hw,
> +                                            unsigned long parent_rate)
> +{
> +       return 32768;
> +}

I see that other clock drivers using a constant rate return 0 if the
clock has not been enabled. So maybe is more correct to have something
like the following?

if (__clk_is_enabled(hw->clk))
        return 32768;
else
        return 0;

Best regards,
Javier
