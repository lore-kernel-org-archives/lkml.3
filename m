Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699Ab3EaBQT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 21:16:19 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:41165 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825Ab3EaBQL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 21:16:11 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Daniel Tang <dt.tangr@gmail.com>, linux-arm-kernel@lists.infradead.org,
        "linux@arm.linux.org.uk ARM Linux" <linux@arm.linux.org.uk>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1369480087-24786-4-git-send-email-dt.tangr@gmail.com>
Cc: Daniel Tang <dt.tangr@gmail.com>, Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "fabian@ritter-vogt.de Vogt" <fabian@ritter-vogt.de>,
        Lionel Debroux <lionel_debroux@yahoo.fr>, linux-kernel@vger.kernel.org
References: <1369480087-24786-1-git-send-email-dt.tangr@gmail.com>
 <1369480087-24786-4-git-send-email-dt.tangr@gmail.com>
Message-ID: <20130531011606.21525.92648@quantum>
User-Agent: alot/0.3.4
Subject: Re: [RFC PATCHv4 3/6] clk: TI-Nspire clock drivers
Date: Thu, 30 May 2013 18:16:06 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Daniel Tang (2013-05-25 04:08:04)
> diff --git a/drivers/clk/clk-nspire.c b/drivers/clk/clk-nspire.c
> new file mode 100644
> index 0000000..2546f7d
> --- /dev/null
> +++ b/drivers/clk/clk-nspire.c
> @@ -0,0 +1,155 @@
> +/*
> + *  linux/drivers/clk/clk-nspire.c

Hi Daniel,

It's best not to put any file path here, since it could change in the
future.  Please remove it.

> + *
> + *  Copyright (C) 2013 Daniel Tang <tangrs@tangrs.id.au>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2, as
> + * published by the Free Software Foundation.
> + *
> + */
> +
> +#include <linux/clk-provider.h>
> +#include <linux/err.h>
> +#include <linux/io.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +
> +#define MHZ (1000 * 1000)
> +
> +#define BASE_CPU_SHIFT         1
> +#define BASE_CPU_MASK          0x7F
> +
> +#define CPU_AHB_SHIFT          12
> +#define CPU_AHB_MASK           0x07
> +
> +#define FIXED_BASE_SHIFT       8
> +#define FIXED_BASE_MASK                0x01
> +
> +#define CLASSIC_BASE_SHIFT     16
> +#define CLASSIC_BASE_MASK      0x1F
> +
> +#define CX_BASE_SHIFT          15
> +#define CX_BASE_MASK           0x3F
> +
> +#define CX_UNKNOWN_SHIFT       21
> +#define CX_UNKNOWN_MASK                0x03
> +
> +struct nspire_clk_info {
> +       u32 base_clock;
> +       u16 base_cpu_ratio;
> +       u16 base_ahb_ratio;
> +};
> +
> +
> +#define EXTRACT(var, prop) (((var)>>prop##_SHIFT) & prop##_MASK)
> +static void nspire_clkinfo_cx(u32 val, struct nspire_clk_info *clk)
> +{
> +       if (EXTRACT(val, FIXED_BASE))
> +               clk->base_clock = 48 * MHZ;
> +       else
> +               clk->base_clock = 6 * EXTRACT(val, CX_BASE) * MHZ;
> +
> +       clk->base_cpu_ratio = EXTRACT(val, BASE_CPU) * EXTRACT(val, CX_UNKNOWN);
> +       clk->base_ahb_ratio = clk->base_cpu_ratio * (EXTRACT(val, CPU_AHB) + 1);
> +}
> +
> +static void nspire_clkinfo_classic(u32 val, struct nspire_clk_info *clk)
> +{
> +       if (EXTRACT(val, FIXED_BASE))
> +               clk->base_clock = 27 * MHZ;
> +       else
> +               clk->base_clock = (300 - 6 * EXTRACT(val, CLASSIC_BASE)) * MHZ;
> +
> +       clk->base_cpu_ratio = EXTRACT(val, BASE_CPU) * 2;
> +       clk->base_ahb_ratio = clk->base_cpu_ratio * (EXTRACT(val, CPU_AHB) + 1);
> +}
> +#undef EXTRACT

Any particular reason for the undef?

Rest looks good to me.  If you can respin this patch I'll take it into
clk-next.

Thanks,
Mike
