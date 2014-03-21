Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043AbaCUVWn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 17:22:43 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:63818 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbaCUVWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 17:22:40 -0400
Message-ID: <532CAD99.4060307@gmail.com>
Date: Fri, 21 Mar 2014 22:22:33 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>
CC: Jimmy Xu <zmxu@marvell.com>, Jisheng Zhang <jszhang@marvell.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        =?ISO-8859-1?Q?Antoine_T=E9nart?= 
	<antoine.tenart@free-electrons.com>
Subject: Re: [PATCH v2 1/5] clk: berlin: add support for berlin plls
References: <1395432521-11055-1-git-send-email-alexandre.belloni@free-electrons.com> <1395432521-11055-2-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1395432521-11055-2-git-send-email-alexandre.belloni@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2014 09:08 PM, Alexandre Belloni wrote:
> This drivers allows to provide DT clocks for the cpu and system PLLs found on
> Marvell Berlin SoCs.

Alexandre,

as mentioned on IRC, I now had a closer look on it. Some minor
remarks below. Sorry, I didn't mention them earlier.

> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
[...]
> --- /dev/null
> +++ b/drivers/clk/berlin/pll-berlin2.c
> @@ -0,0 +1,42 @@
> +/*
> + * Copyright (c) 2014 Marvell Technology Group Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along with
> + * this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +#include <linux/clk-provider.h>
> +#include <linux/io.h>
> +#include <linux/kernel.h>
> +#include <linux/of.h>
> +
> +#include "common.h"
> +
> +static const u8 vcodiv_berlin2[] = {10, 15, 20, 25, 30, 40, 50, 60, 80,
> +				    1, 1, 1, 1, 1, 1, 1};

As there are already zeroes in vcodiv_berlin2q below, we should rather
make the above

static const u8 vcodiv_berlin2[16] = {10, 15, 20, 25, 30, 40, 50, 60, 80};

And check for vcodiv == 0 in berlin_pll_recalc_rate below.

> +static struct berlin_pllmap berlin_pll_map = {
> +	.vcodiv = vcodiv_berlin2,
> +	.fbdiv_mask = 0x1FF,
> +	.fbdiv_shift = 6,
> +	.rfdiv_mask = 0x1F,
> +	.rfdiv_shift = 1,
> +	.divsel_mask = 0xF,
> +	.divsel_shift = 7,
> +	.mult = 10,
> +};
> +
> +static void __init berlin2_pll_setup(struct device_node *np)
> +{
> +	berlin_pll_setup(np, &berlin_pll_map);
> +}
> +CLK_OF_DECLARE(berlin2q_pll, "marvell,berlin2-pll", berlin2_pll_setup);

s/berlin2q_pll/berlin2_pll

> +

Remove empty line above.

> diff --git a/drivers/clk/berlin/pll-berlin2q.c b/drivers/clk/berlin/pll-berlin2q.c
> new file mode 100644
> index 000000000000..0a2e9968cc09
> --- /dev/null
> +++ b/drivers/clk/berlin/pll-berlin2q.c
> @@ -0,0 +1,42 @@
> +/*
> + * Copyright (c) 2014 Marvell Technology Group Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along with
> + * this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +#include <linux/clk-provider.h>
> +#include <linux/io.h>
> +#include <linux/kernel.h>
> +#include <linux/of.h>
> +
> +#include "common.h"
> +
> +static const u8 vcodiv_berlin2q[] = {1, 0, 2, 0, 3, 4, 0, 6, 8,
> +				     1, 1, 1, 1, 1, 1, 1};

Same comment as for vcodiv_berlin2.

> +static struct berlin_pllmap berlin2q_pll_map = {
> +	.vcodiv = vcodiv_berlin2q,
> +	.fbdiv_mask = 0x1FF,
> +	.fbdiv_shift = 7,
> +	.rfdiv_mask = 0x1F,
> +	.rfdiv_shift = 2,
> +	.divsel_mask = 0xF,
> +	.divsel_shift = 9,
> +	.mult = 1,
> +};
> +
> +static void __init berlin2q_pll_setup(struct device_node *np)
> +{
> +	berlin_pll_setup(np, &berlin2q_pll_map);
> +}
> +CLK_OF_DECLARE(berlin2q_pll, "marvell,berlin2q-pll", berlin2q_pll_setup);
> +

Remove empty line above.

> diff --git a/drivers/clk/berlin/pll.c b/drivers/clk/berlin/pll.c
> new file mode 100644
> index 000000000000..264c48d6e797
> --- /dev/null
> +++ b/drivers/clk/berlin/pll.c
> @@ -0,0 +1,107 @@
> +/*
> + * Copyright (c) 2014 Marvell Technology Group Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along with
> + * this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +#include <linux/clk-provider.h>
> +#include <linux/io.h>
> +#include <linux/kernel.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +#include <linux/slab.h>
> +
> +#include "common.h"
> +
> +struct berlin_pll {
> +	struct clk_hw		hw;
> +	void __iomem		*base;
> +	struct berlin_pllmap	*map;
> +};
> +
> +#define to_berlin_pll(hw)	container_of(hw, struct berlin_pll, hw)
> +
> +#define PLL_CTRL0	0x00
> +#define PLL_CTRL1	0x04
> +
> +static inline u32 berlin_pll_read(struct berlin_pll *pll, unsigned long offset)
> +{
> +	return readl_relaxed(pll->base + offset);
> +}
> +
> +/*
> + * The output frequency formula for the pll is:
> + * clkout = fbdiv / refdiv * parent / vcodiv

That comment is enough, remove the one below.

> + * Note that for BG2, BG2CD and BG2Q, the parent clock is provided by the SM
> + * oscillator and is always 25MHz.
> + */
> +static unsigned long berlin_pll_recalc_rate(struct clk_hw *hw,
> +					unsigned long parent_rate)
> +{
> +	struct berlin_pll *pll = to_berlin_pll(hw);
> +	struct berlin_pllmap *map = pll->map;
> +	u32 val, fbdiv, rfdiv, vcodivsel;
> +
> +	val = berlin_pll_read(pll, PLL_CTRL0);
> +	fbdiv = (val >> map->fbdiv_shift) & map->fbdiv_mask;
> +	rfdiv = (val >> map->rfdiv_shift) & map->rfdiv_mask;
> +	if (rfdiv == 0)
> +		rfdiv = 1;

if (rfdiv) {
	pr_warn("%s has zero rfdiv\n", __clk_get_name(hw->clk));
	rfdiv = 1;
}

> +
> +	val = berlin_pll_read(pll, PLL_CTRL1);
> +	vcodivsel = (val >> map->divsel_shift) & map->divsel_mask;

As map->vcodiv can contain zeros, we should rather do

vcodiv = map->vcodiv[vcodivsel];
if (vcodiv) {
	pr_warn("%s has zero vcodiv\n", __clk_get_name(hw->clk));
	vcodiv = 1;
}

> +	parent_rate *= fbdiv * map->mult;
> +	parent_rate /= rfdiv;
> +	return parent_rate / map->vcodiv[vcodivsel];

With parent_rate = 25M and max(fbdiv) == 511 we can possibly
exceed 32b range. So, we should rather switch to u64 here:

#include <asm/div64.h>

u64 rate = parent_rate;

...

rate *= fbdiv * map->mult;
do_div(rate, vcodiv * rfdiv);
return (unsigned long)rate;

Besides the comments, this really looks good to me. We may have
to rebase some of it onto v3.15-rc1 as soon as it drops, but I
can take care of it.

Sebastian

> +}
> +
> +static const struct clk_ops berlin_pll_ops = {
> +	.recalc_rate	= berlin_pll_recalc_rate,
> +};
> +
> +void __init berlin_pll_setup(struct device_node *np,
> +			struct berlin_pllmap *map)
> +{
> +	struct clk_init_data init;
> +	struct berlin_pll *pll;
> +	const char *parent_name;
> +	struct clk *clk;
> +	int ret;
> +
> +	pll = kzalloc(sizeof(*pll), GFP_KERNEL);
> +	if (WARN_ON(!pll))
> +		return;
> +
> +	pll->base = of_iomap(np, 0);
> +	if (WARN_ON(!pll->base))
> +		return;
> +
> +	pll->map = map;
> +
> +	init.name = np->name;
> +	init.ops = &berlin_pll_ops;
> +	parent_name = of_clk_get_parent_name(np, 0);
> +	init.parent_names = &parent_name;
> +	init.num_parents = 1;
> +
> +	pll->hw.init = &init;
> +
> +	clk = clk_register(NULL, &pll->hw);
> +	if (WARN_ON(IS_ERR(clk)))
> +		return;
> +
> +	ret = of_clk_add_provider(np, of_clk_src_simple_get, clk);
> +	if (WARN_ON(ret))
> +		return;
> +}
> +
>

