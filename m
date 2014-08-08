Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778AbaHHOTI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 10:19:08 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:48708 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080AbaHHOTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 10:19:02 -0400
MIME-Version: 1.0
In-Reply-To: <1407505411-2207-3-git-send-email-srv_yingjoe.chen@mediatek.com>
References: <1407505411-2207-1-git-send-email-srv_yingjoe.chen@mediatek.com>
	<1407505411-2207-3-git-send-email-srv_yingjoe.chen@mediatek.com>
Date: Fri, 8 Aug 2014 16:19:01 +0200
Message-ID: <CABuKBeL-dcs+pDW3jUeRWNijyYwx4VUdUB=CjGXoGmQUCifQ5Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] arm: mediatek: Add support for GIC interrupt
 polarity extension.
From: Matthias Brugger <matthias.bgg@gmail.com>
To: "Joe.C" <srv_yingjoe.chen@mediatek.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Jonas Jensen <jonas.jensen@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        open list <linux-kernel@vger.kernel.org>,
        srv_heupstream <srv_heupstream@mediatek.com>,
        Hsien-Chun Yen <hc.yen@mediatek.com>,
        =?UTF-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= 
	<eddie.huang@mediatek.com>,
        Nathan Chung <nathan.chung@mediatek.com>,
        Yuhau Chen <yh.chen@mediatek.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-08-08 15:43 GMT+02:00 Joe.C <srv_yingjoe.chen@mediatek.com>:
> From: "Joe.C" <yingjoe.chen@mediatek.com>
>
> Mediatek SoCs have an interrupt polarity extension which allows
> to swap the polarity for given interrupts.

Please use ./script/checkpatch.pl, all 4 patches have errors.
Apart please use the get_maintainer.pl on all patches of a set and
send the whole set to all email addresses returned by the script.
Otherwise it will be really difficult to understand the context of the
patch set.

Cheers,
Matthias

>
> Signed-off-by: Joe.C <yingjoe.chen@mediatek.com>
> ---
>  arch/arm/mach-mediatek/Makefile   |  2 +-
>  arch/arm/mach-mediatek/common.h   | 19 ++++++++++++
>  arch/arm/mach-mediatek/intpol.c   | 61 +++++++++++++++++++++++++++++++++++++++
>  arch/arm/mach-mediatek/mediatek.c | 10 +++++++
>  4 files changed, 91 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm/mach-mediatek/common.h
>  create mode 100644 arch/arm/mach-mediatek/intpol.c
>
> diff --git a/arch/arm/mach-mediatek/Makefile b/arch/arm/mach-mediatek/Makefile
> index 43e619f..82c39d8 100644
> --- a/arch/arm/mach-mediatek/Makefile
> +++ b/arch/arm/mach-mediatek/Makefile
> @@ -1 +1 @@
> -obj-$(CONFIG_ARCH_MEDIATEK) += mediatek.o
> +obj-$(CONFIG_ARCH_MEDIATEK) += mediatek.o intpol.o
> diff --git a/arch/arm/mach-mediatek/common.h b/arch/arm/mach-mediatek/common.h
> new file mode 100644
> index 0000000..8f2bbeb
> --- /dev/null
> +++ b/arch/arm/mach-mediatek/common.h
> @@ -0,0 +1,19 @@
> +/*
> + * Copyright (c) 2014 Mediatek Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +#ifndef __MEDIATEK_COMMON_H__
> +#define __MEDIATEK_COMMON_H__
> +
> +extern char init_intpol(void);
> +
> +#endif /* __MEDIATEK_COMMON_H__ */
> diff --git a/arch/arm/mach-mediatek/intpol.c b/arch/arm/mach-mediatek/intpol.c
> new file mode 100644
> index 0000000..65ccc7c
> --- /dev/null
> +++ b/arch/arm/mach-mediatek/intpol.c
> @@ -0,0 +1,61 @@
> +/*
> + * This file contains common code that is intended to be used across
> + * boards so that it's not replicated.
> + *
> + * Copyright (C) 2014 Mediatek Inc.
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +#include <linux/of_address.h>
> +#include <linux/io.h>
> +#include <linux/irq.h>
> +#include <linux/irqchip/arm-gic.h>
> +
> +#define GIC_HW_IRQ_BASE  32
> +#define INT_POL_INDEX(a)   ((a) - GIC_HW_IRQ_BASE)
> +
> +static void __iomem *int_pol_base;
> +
> +static int mtk_int_pol_set_type(struct irq_data *d, unsigned int type)
> +{
> +       unsigned int irq = d->hwirq;
> +       u32 offset, reg_index, value;
> +
> +       offset = INT_POL_INDEX(irq) & 0x1F;
> +       reg_index = INT_POL_INDEX(irq) >> 5;
> +
> +       /* This arch extension was called with irq_controller_lock held,
> +          so the read-modify-write will be atomic */
> +       value = readl(int_pol_base + reg_index * 4);
> +       if (type == IRQ_TYPE_LEVEL_LOW || type == IRQ_TYPE_EDGE_FALLING)
> +               value |= (1 << offset);
> +       else
> +               value &= ~(1 << offset);
> +       writel(value, int_pol_base + reg_index * 4);
> +
> +       return 0;
> +}
> +
> +void init_intpol(void)
> +{
> +       struct device_node *node;
> +
> +       node = of_find_compatible_node(NULL, NULL, "mediatek,mt6577-intpol");
> +       if (!node)
> +               return;
> +
> +       int_pol_base = of_io_request_and_map(node, 0, "intpol");
> +       if (IS_ERR(int_pol_base)) {
> +               pr_warn("Can't get resource\n");
> +               return;
> +       }
> +
> +       gic_arch_extn.irq_set_type = mtk_int_pol_set_type;
> +}
> diff --git a/arch/arm/mach-mediatek/mediatek.c b/arch/arm/mach-mediatek/mediatek.c
> index 48051a2..aa10c70 100644
> --- a/arch/arm/mach-mediatek/mediatek.c
> +++ b/arch/arm/mach-mediatek/mediatek.c
> @@ -16,6 +16,15 @@
>   */
>  #include <linux/init.h>
>  #include <asm/mach/arch.h>
> +#include <linux/irqchip.h>
> +
> +#include "common.h"
> +
> +static void __init mediatek_init_irq(void)
> +{
> +       init_intpol();
> +       irqchip_init();
> +}
>
>  static const char * const mediatek_board_dt_compat[] = {
>         "mediatek,mt6589",
> @@ -26,4 +35,5 @@ static const char * const mediatek_board_dt_compat[] = {
>
>  DT_MACHINE_START(MEDIATEK_DT, "Mediatek Cortex-A7 (Device Tree)")
>         .dt_compat      = mediatek_board_dt_compat,
> +       .init_irq       = mediatek_init_irq,
>  MACHINE_END
> --
> 1.8.1.1.dirty
>



-- 
motzblog.wordpress.com
