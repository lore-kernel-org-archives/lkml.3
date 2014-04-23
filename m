Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757069AbaDWRKM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 13:10:12 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:35827 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114AbaDWRKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 13:10:09 -0400
Message-ID: <5357F3EC.8070203@gmail.com>
Date: Wed, 23 Apr 2014 19:10:04 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] clk: berlin: add support for clocks
References: <1398261667-12621-1-git-send-email-alexandre.belloni@free-electrons.com> <1398261667-12621-2-git-send-email-alexandre.belloni@free-electrons.com> <5357F24B.8070405@gmail.com>
In-Reply-To: <5357F24B.8070405@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2014 07:03 PM, Sebastian Hesselbarth wrote:
> On 04/23/2014 04:01 PM, Alexandre Belloni wrote:
>> Add support for clocks having their own register set.
>>
>> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
>> ---
>>  drivers/clk/berlin/Makefile |   2 +-
>>  drivers/clk/berlin/clk.c    | 132 ++++++++++++++++++++++++++++++++++++++++++++
>>  2 files changed, 133 insertions(+), 1 deletion(-)
>>  create mode 100644 drivers/clk/berlin/clk.c
>>
>> diff --git a/drivers/clk/berlin/Makefile b/drivers/clk/berlin/Makefile
>> index 94859513de90..9bfa58eaf25a 100644
>> --- a/drivers/clk/berlin/Makefile
>> +++ b/drivers/clk/berlin/Makefile
>> @@ -1,4 +1,4 @@
>> -obj-y += pll.o
>> +obj-y += pll.o clk.o
>>  obj-$(CONFIG_MACH_BERLIN_BG2)   += pll-berlin2.o
>>  obj-$(CONFIG_MACH_BERLIN_BG2CD) += pll-berlin2.o
>>  obj-$(CONFIG_MACH_BERLIN_BG2Q)  += pll-berlin2q.o
>> diff --git a/drivers/clk/berlin/clk.c b/drivers/clk/berlin/clk.c
>> new file mode 100644
>> index 000000000000..a0e688e5bead
>> --- /dev/null
>> +++ b/drivers/clk/berlin/clk.c
>> @@ -0,0 +1,132 @@
>> +/*
>> + * Copyright (c) 2014 Marvell Technology Group Ltd.
>> + *
>> + * This program is free software; you can redistribute it and/or modify it
>> + * under the terms and conditions of the GNU General Public License,
>> + * version 2, as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope it will be useful, but WITHOUT
>> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
>> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
>> + * more details.
>> + *
>> + * You should have received a copy of the GNU General Public License along with
>> + * this program.  If not, see <http://www.gnu.org/licenses/>.
>> + */
>> +#include <linux/bitops.h>
>> +#include <linux/clk-provider.h>
>> +#include <linux/of.h>
>> +#include <linux/of_address.h>
>> +#include <linux/slab.h>
>> +
>> +#include "common.h"
>> +
>> +#define CLKEN		(1 << 0)
> 
> Alexandre,
> 
> please use BIT(n) instead of (1 << n).
> 
>> +#define CLKPLLSEL_MASK	7
>> +#define CLKPLLSEL_SHIFT	1
>> +#define CLKPLLSWITCH	(1 << 4)
>> +#define CLKSWITCH	(1 << 5)
>> +#define CLKD3SWITCH	(1 << 6)
>> +#define CLKSEL_MASK	7
>> +#define CLKSEL_SHIFT	7
> 
> In general, I would change the above defines to CLK_SEL_MASK, i.e.
> add a _ after CLK. While at it (as it can be seen from the code
> below), also rename CLK_D3SWITCH to CLK_DIV3_SWITCH.
> 
>> +
>> +struct berlin_clk {
>> +	struct clk_hw hw;
>> +	void __iomem *base;
>> +};
>> +
>> +#define to_berlin_clk(hw)	container_of(hw, struct berlin_clk, hw)
>> +
>> +static u8 clk_div[] = {1, 2, 4, 6, 8, 12, 1, 1};
>> +
>> +static unsigned long berlin_clk_recalc_rate(struct clk_hw *hw,
>> +					unsigned long parent_rate)
>> +{
>> +	u32 val, divider;
>> +	struct berlin_clk *clk = to_berlin_clk(hw);
>> +
>> +	val = readl_relaxed(clk->base);
>> +	if (val & CLKD3SWITCH)
>> +		divider = 3;
>> +	else {
>> +		if (val & CLKSWITCH) {
>> +			val >>= CLKSEL_SHIFT;
>> +			val &= CLKSEL_MASK;
>> +			divider = clk_div[val];
>> +		} else
>> +			divider = 1;
>> +	}
>> +
> 
> There are stylistic issues:
> 
> if-else with one part being enclosed in {} requires both parts
> to be enclosed in those curly brackets, i.e.
> 
> if (foo)
> 	bar;
> else {
> 	foobar;
> 	barfoo;
> }
> 
> has to become
> 
> if (foo) {
> 	bar;
> } else {
> 	foobar;
> 	barfoo;
> }
> 
> How about writing the above

Grr, I wasn't done with my review but who the f*ck puts
"Send now" on ^D ?

So, how about writing the above

val = readl_relaxed(clk->base);

divider = 1;
if (val & CLKD3SWITCH) {
	divider = 3;
} else if (val & CLKSWITCH) {
	val >>= CLKSEL_SHIFT;
	val &= CLKSEL_MASK;
	divider = clk_div[val];
}

>> +	return parent_rate / divider;
>> +}
>> +
>> +static u8 berlin_clk_get_parent(struct clk_hw *hw)
>> +{
>> +	u32 val;
>> +	struct berlin_clk *clk = to_berlin_clk(hw);
>> +
>> +	val = readl_relaxed(clk->base);
>> +	if (val & CLKPLLSWITCH) {
>> +		val >>= CLKPLLSEL_SHIFT;
>> +		val &= CLKPLLSEL_MASK;
>> +		return val;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static const struct clk_ops berlin_clk_ops = {
>> +	.recalc_rate	= berlin_clk_recalc_rate,
>> +	.get_parent	= berlin_clk_get_parent,
>> +};
>> +
>> +static void __init berlin_clk_setup(struct device_node *np)
>> +{
>> +	struct clk_init_data init;
>> +	struct berlin_clk *bclk;
>> +	struct clk *clk;
>> +	const char **parent_names;
>> +	int nparents, i, ret;
>> +
>> +	bclk = kzalloc(sizeof(*bclk), GFP_KERNEL);
>> +	if (WARN_ON(!bclk))
>> +		return;
>> +
>> +	bclk->base = of_iomap(np, 0);
>> +	if (WARN_ON(!bclk->base))
>> +		goto exit;
>> +
>> +	nparents = of_clk_get_parent_count(np);
>> +	if (WARN_ON(!nparents))
>> +		goto exit;
>> +
>> +	parent_names = kzalloc((sizeof(char *) * nparents), GFP_KERNEL);

No need to put () around the calculation above. Also, if you put
nparents in front it may be more readable.

Sebastian

>> +	if (WARN_ON(!parent_names))
>> +		goto exit;
>> +
>> +	init.name = np->name;
>> +	init.ops = &berlin_clk_ops;
>> +	for (i = 0; i < nparents; i++) {
>> +		parent_names[i] = of_clk_get_parent_name(np, i);
>> +		if (!parent_names[i])
>> +			break;
>> +	}
>> +	init.parent_names = parent_names;
>> +	init.num_parents = i;
>> +
>> +	bclk->hw.init = &init;
>> +
>> +	clk = clk_register(NULL, &bclk->hw);
>> +	kfree(parent_names);
>> +	if (WARN_ON(IS_ERR(clk)))
>> +		goto exit;
>> +
>> +	ret = of_clk_add_provider(np, of_clk_src_simple_get, clk);
>> +	WARN_ON(ret);
>> +
>> +	return;
>> +exit:
>> +	kfree(bclk);
>> +}
>> +
>> +CLK_OF_DECLARE(berlin_clk, "marvell,berlin-clk", berlin_clk_setup);
>>
> 

