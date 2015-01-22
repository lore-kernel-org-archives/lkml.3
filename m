Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988AbbAVCX3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 21:23:29 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:48675 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677AbbAVCXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 21:23:21 -0500
Date: Wed, 21 Jan 2015 18:23:19 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: linux-kernel@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: Re: [PATCH v11 4/4] clk: Add module for unit tests
Message-ID: <20150122022319.GJ27202@codeaurora.org>
References: <1421847039-29544-1-git-send-email-tomeu.vizoso@collabora.com>
 <1421847039-29544-5-git-send-email-tomeu.vizoso@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421847039-29544-5-git-send-email-tomeu.vizoso@collabora.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21, Tomeu Vizoso wrote:
> diff --git a/drivers/clk/Kconfig.debug b/drivers/clk/Kconfig.debug
> new file mode 100644
> index 0000000..840b790
> --- /dev/null
> +++ b/drivers/clk/Kconfig.debug
> @@ -0,0 +1,6 @@
> +config COMMON_CLK_TEST
> +	tristate "Unit tests for the Common Clock Framework"

depends on DEBUG_KERNEL?

> +	default n

Drop this line. n is the default.

> +	---help---
> +	  This driver runs several tests on the Common Clock Framework.

s/driver/module/ ?


> diff --git a/drivers/clk/clk-test.c b/drivers/clk/clk-test.c
> new file mode 100644
> index 0000000..4eb7eb4
> --- /dev/null
> +++ b/drivers/clk/clk-test.c
> @@ -0,0 +1,325 @@
> +/*
> + * Copyright (C) 2015 Google, Inc
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * Unit tests for the Common Clock Framework
> + */
> +
> +#include <linux/clk-provider.h>
> +#include <linux/clkdev.h>
> +#include <linux/delay.h>
> +#include <linux/init.h>
> +#include <linux/printk.h>
> +#include <linux/slab.h>

#include <linux/clk.h> ?

> +
> +/* Assumed to be sorted */
> +static const unsigned long allowed_rates[] = { 0, 100, 200, 300, 400, 500 };
> +
> +struct test_clk {
> +	struct clk_hw hw;
> +	unsigned long rate;
> +};
> +
> +static inline struct test_clk *to_test_clk(struct clk_hw *hw)
> +{
> +	return container_of(hw, struct test_clk, hw);
> +}
> +
> +static long test_clk_determine_rate(struct clk_hw *hw,
> +				    unsigned long rate,
> +				    unsigned long min_rate,
> +				    unsigned long max_rate,
> +				    unsigned long *best_parent_rate,
> +				    struct clk_hw **best_parent)
> +{
> +	struct clk *parent;
> +	unsigned long target_rate = 0;
> +	unsigned int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(allowed_rates); i++) {
> +
> +		if (allowed_rates[i] > max_rate) {
> +			if (i > 0)
> +				target_rate = allowed_rates[i - 1];
> +			else
> +				target_rate = 0;
> +			break;
> +		}
> +
> +		if (allowed_rates[i] < min_rate)
> +			continue;
> +
> +		if (allowed_rates[i] >= rate) {
> +			target_rate = allowed_rates[i];
> +			break;
> +		}
> +	}
> +
> +	parent = clk_get_parent(hw->clk);
> +	if (parent) {
> +		*best_parent = __clk_get_hw(parent);
> +		*best_parent_rate = __clk_determine_rate(__clk_get_hw(parent),
> +							 target_rate / 2,
> +							 min_rate,
> +							 max_rate);

So child's a multiplier? That's new.

> +	}
> +
> +	return target_rate;
> +}
> +
> +static unsigned long test_clk_recalc_rate(struct clk_hw *hw,
> +					  unsigned long parent_rate)
> +{
> +	struct test_clk *test_clk = to_test_clk(hw);
> +
> +	return test_clk->rate;

It would be good to actually use parent_rate here to match
whatever is done in determine_rate().

> +}
> +
> +static int test_clk_set_rate(struct clk_hw *hw, unsigned long rate,
> +			     unsigned long parent_rate)
> +{
> +	struct test_clk *test_clk = to_test_clk(hw);
> +
> +	test_clk->rate = rate;
> +
> +	return 0;
> +}
> +
> +static const struct clk_ops test_clk_ops = {
> +	.determine_rate = test_clk_determine_rate,
> +	.recalc_rate = test_clk_recalc_rate,
> +	.set_rate = test_clk_set_rate,
> +};
> +
> +static struct clk *init_test_clk(const char *name, const char *parent_name)
> +{
> +	struct test_clk *test_clk;
> +	struct clk *clk;
> +	struct clk_init_data init;
> +	int err;
> +
> +	test_clk = kzalloc(sizeof(*test_clk), GFP_KERNEL);
> +	if (!test_clk)
> +		return ERR_PTR(-ENOMEM);
> +
> +	test_clk->rate = 0;

It would probably be good to assign some initial rate besides 0.

> +
> +	init.name = name;
> +	init.ops = &test_clk_ops;
> +
> +	if (parent_name) {
> +		init.parent_names = &parent_name;
> +		init.num_parents = 1;
> +		init.flags = CLK_SET_RATE_PARENT;
> +	} else {
> +		init.parent_names = NULL;
> +		init.num_parents = 0;
> +		init.flags = CLK_IS_ROOT;
> +	}
> +
> +	test_clk->hw.init = &init;
> +
> +	clk = clk_register(NULL, &test_clk->hw);
> +	if (IS_ERR(clk)) {
> +		printk("%s: error registering clk: %ld\n", __func__,
> +		       PTR_ERR(clk));

Use pr_error() throughout? And use a pr_fmt with __func__ to make
things simpler.

> +		return clk;
> +	}
> +
> +	err = clk_register_clkdev(clk, name, NULL);
> +	if (err)
> +		printk("%s: error registering alias: %d\n", __func__, err);
> +
> +	return clk;
> +}
> +
> +static void test_ceiling(struct clk *clk)
> +{
> +	unsigned long rate;
> +	int ret;
> +
> +	ret = clk_set_max_rate(clk, 399);
> +	if (ret)
> +		printk("%s: error setting ceiling: %d\n", __func__, ret);
> +
> +	rate = clk_round_rate(clk, 400);
> +	if (rate != 300)
> +		printk("%s: unexpected rounded rate: %lu != 300\n", __func__, rate);
> +
> +	ret = clk_set_rate(clk, 400);
> +	if (ret)
> +		printk("%s: error setting rate: %d\n", __func__, ret);
> +
> +	rate = clk_get_rate(clk);
> +	if (rate != 300)

Perhaps these tests for constraints should just be checking to
make sure we don't go outside the range we want. Something more
like:

	if (rate > 399)

> +		printk("%s: unexpected rate: %lu != 300\n", __func__, rate);
> +
> +	ret = clk_set_max_rate(clk, ULONG_MAX);
> +	if (ret)
> +		printk("%s: error setting ceiling: %d\n", __func__, ret);
> +}
> +
> +static void test_floor(struct clk *clk)
> +{
> +	unsigned long rate;
> +	int ret;
> +
> +	ret = clk_set_min_rate(clk, 199);
> +	if (ret)
> +		printk("%s: error setting floor: %d\n", __func__, ret);
> +
> +	rate = clk_round_rate(clk, 90);
> +	if (rate != 200)
> +		printk("%s: unexpected rounded rate: %lu != 200\n", __func__, rate);
> +
> +	ret = clk_set_rate(clk, 90);
> +	if (ret)
> +		printk("%s: error setting rate: %d\n", __func__, ret);
> +
> +	rate = clk_get_rate(clk);
> +	if (rate != 200)

And 

	if (rate < 200)

This reminds me, it would be good to indicate in the
documentation if min/max is inclusive or exclusive.

> +		printk("%s: unexpected rate: %lu != 200\n", __func__, rate);
> +
> +	ret = clk_set_min_rate(clk, 0);
> +	if (ret)
> +		printk("%s: error setting floor: %d\n", __func__, ret);
> +}
> +
> +static void test_unsatisfiable(struct clk *clk)
> +{
> +	struct clk *clk2 = clk_get_sys(NULL, "clk");
> +	unsigned long rate;
> +	int ret;
> +
> +	if (IS_ERR(clk2))
> +		printk("%s: error getting clk: %ld\n", __func__,
> +		       PTR_ERR(clk2));
> +
> +	ret = clk_set_min_rate(clk, 99);
> +	if (ret)
> +		printk("%s: error setting floor: %d\n", __func__, ret);
> +
> +	ret = clk_set_max_rate(clk, 199);
> +	if (ret)
> +		printk("%s: error setting ceiling: %d\n", __func__, ret);
> +
> +	ret = clk_set_min_rate(clk2, 399);
> +	if (ret)
> +		printk("%s: error setting floor: %d\n", __func__, ret);

Shouldn't this one fail and print an error?

> +
> +	ret = clk_set_max_rate(clk2, 499);
> +	if (ret)
> +		printk("%s: error setting ceiling: %d\n", __func__, ret);

This one should be ok though.

> +
> +	ret = clk_set_rate(clk, 90);
> +	if (ret)
> +		printk("%s: error setting rate: %d\n", __func__, ret);
> +
> +	/*
> +	 * It's expected that the rate is the highest rate that is still
> +	 * below the smallest ceiling
> +	 */
> +	rate = clk_get_rate(clk);
> +	if (rate != 100)
> +		printk("%s: unexpected rate: %lu != 100\n", __func__, rate);
> +
> +	clk_put(clk2);
> +
> +	ret = clk_set_min_rate(clk, 0);
> +	if (ret)
> +		printk("%s: error setting floor: %d\n", __func__, ret);
> +
> +	ret = clk_set_max_rate(clk, ULONG_MAX);
> +	if (ret)
> +		printk("%s: error setting ceiling: %d\n", __func__, ret);
> +}
> +
> +static void test_constrained_parent(struct clk *clk, struct clk *parent)
> +{
> +	unsigned long rate;
> +	int ret;
> +
> +	ret = clk_set_max_rate(parent, 199);
> +	if (ret)
> +		printk("%s: error setting ceiling: %d\n", __func__, ret);
> +
> +	ret = clk_set_rate(clk, 200);
> +	if (ret)
> +		printk("%s: error setting rate: %d\n", __func__, ret);
> +
> +	rate = clk_get_rate(clk);
> +	if (rate != 200)
> +		printk("%s: unexpected rate: %lu != 200\n", __func__, rate);
> +
> +	rate = clk_get_rate(parent);
> +	if (rate != 100)
> +		printk("%s: unexpected parent rate: %lu != 100\n", __func__, rate);
> +
> +	ret = clk_set_max_rate(parent, ULONG_MAX);
> +	if (ret)
> +		printk("%s: error setting ceiling: %d\n", __func__, ret);
> +}
> +
> +static void test_constraint_with_parent(struct clk *clk, struct clk *parent)
> +{
> +	unsigned long rate;
> +	int ret;
> +
> +	ret = clk_set_min_rate(clk, 201);
> +	if (ret)
> +		printk("%s: error setting ceiling: %d\n", __func__, ret);
> +
> +	ret = clk_set_rate(clk, 300);
> +	if (ret)
> +		printk("%s: error setting rate: %d\n", __func__, ret);
> +
> +	rate = clk_get_rate(clk);
> +	if (rate != 300)
> +		printk("%s: unexpected rate: %lu != 300\n", __func__, rate);
> +
> +	rate = clk_get_rate(parent);
> +	if (rate != 300)
> +		printk("%s: unexpected parent rate: %lu != 300\n", __func__, rate);
> +
> +	ret = clk_set_max_rate(parent, ULONG_MAX);
> +	if (ret)
> +		printk("%s: error setting ceiling: %d\n", __func__, ret);
> +}
> +
> +static int __init clk_test_init(void)
> +{
> +	struct clk *parent, *clk;
> +
> +	printk("---------- Common Clock Framework test results ----------\n");
> +
> +	parent = init_test_clk("parent", NULL);
> +	if (IS_ERR(parent)) {
> +		printk("%s: error registering parent: %ld\n", __func__,
> +		       PTR_ERR(parent));
> +		return PTR_ERR(parent);
> +	}
> +
> +	clk = init_test_clk("clk", "parent");
> +	if (IS_ERR(clk)) {
> +		printk("%s: error registering clk: %ld\n", __func__,
> +		       PTR_ERR(clk));
> +		return PTR_ERR(clk);
> +	}
> +
> +	test_ceiling(clk);
> +	test_floor(clk);
> +	test_unsatisfiable(clk);
> +	test_constrained_parent(clk, parent);
> +	test_constraint_with_parent(clk, parent);
> +

It would be good to unregister the clocks here so that we don't
leave them hanging around unused.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
