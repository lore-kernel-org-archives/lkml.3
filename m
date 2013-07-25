Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295Ab3GYIVN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 04:21:13 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:56765 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755098Ab3GYIVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 04:21:07 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Mike Turquette <mturquette@linaro.org>, linux-arm-msm@vger.kernel.org,
        Saravana Kannan <skannan@codeaurora.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 02/14] clk: Add of_init_clk_data() to parse common clock bindings
Date: Thu, 25 Jul 2013 10:21:02 +0200
Message-ID: <1714620.Z8J8zTxIRB@flatron>
User-Agent: KMail/4.10.5 (Linux/3.10.1-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1374713022-6049-3-git-send-email-sboyd@codeaurora.org>
References: <1374713022-6049-1-git-send-email-sboyd@codeaurora.org> <1374713022-6049-3-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

Pretty good idea, but I have some comments inline.

On Wednesday 24 of July 2013 17:43:30 Stephen Boyd wrote:
> Consolidate DT parsing for the common bits of a clock binding in
> one place to simplify clock drivers. This also has the added
> benefit of standardizing how the clock names used by the common
> clock framework are generated from the DT bindings. We always use
> the first clock-output-names string if it exists, otherwise we
> fall back to the node name.
> 
> To be slightly more efficient and make the caller's life easier,
> we introduce a shallow copy flag so that the clock core knows to
> just copy the pointers to the strings and not the string
> contents. Otherwise the callers of this function would have to
> free the strings allocated here which could be cumbersome.
> 
> Cc: Rob Herring <rob.herring@calxeda.com>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  drivers/clk/clk.c            | 59
> +++++++++++++++++++++++++++++++++++++++++++-
> include/linux/clk-provider.h |  7 ++++++
>  2 files changed, 65 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index 1ed9bdd..ea8e951b 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -1809,6 +1809,10 @@ static int _clk_register(struct device *dev,
> struct clk_hw *hw, struct clk *clk) {
>  	int i, ret;
> 
> +	hw->clk = clk;
> +	if (hw->init->flags & CLK_SHALLOW_COPY)
> +		return PTR_RET(__clk_register(dev, hw));
> +
>  	clk->name = kstrdup(hw->init->name, GFP_KERNEL);
>  	if (!clk->name) {
>  		pr_err("%s: could not allocate clk->name\n", __func__);
> @@ -1819,7 +1823,6 @@ static int _clk_register(struct device *dev,
> struct clk_hw *hw, struct clk *clk) clk->hw = hw;
>  	clk->flags = hw->init->flags;
>  	clk->num_parents = hw->init->num_parents;
> -	hw->clk = clk;
> 
>  	/* allocate local copy in case parent_names is __initdata */
>  	clk->parent_names = kzalloc((sizeof(char*) * clk->num_parents),
> @@ -2232,4 +2235,58 @@ void __init of_clk_init(const struct of_device_id
> *matches) clk_init_cb(np);
>  	}
>  }
> +
> +/**
> + * of_init_clk_data() - Initialize a clk_init_data struct from a DT
> node + * @np: node to initialize struct from
> + * @init: struct to initialize
> + *
> + * Populates the clk_init_data struct by parsing the device node for
> + * properties matching the common clock binding. Returns 0 on success
> + * and a negative error code on failure.
> + */
> +int of_init_clk_data(struct device_node *np, struct clk_init_data
> *init) +{
> +	struct of_phandle_args s;
> +	const char **names = NULL, **p;
> +	const char *name;
> +	int i;
> +
> +	if (of_property_read_string(np, "clock-output-names", &name) < 0)
> +		name = np->name;
> +	init->name = kstrdup(name, GFP_KERNEL);
> +	if (!init->name)
> +		return -ENOMEM;
> +
> +	for (i = 0; of_parse_phandle_with_args(np, "clocks", "#clock-
cells",
> +				i, &s) == 0; i++) {
> +		p = krealloc(names, sizeof(*names) * (i + 1), GFP_KERNEL);
> +		if (!p)
> +			goto err;

What about using of_count_phandle_with_args() first to get the parent 
count?

> +		names = p;
> +
> +		if (of_property_read_string(s.np, "clock-output-names",
> +					&name) < 0)
> +			name = s.np->name;

You should be able to use of_clk_get_parent_name() here, instead of 
parsing the properties directly.

Best regards,
Tomasz

