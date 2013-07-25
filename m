Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200Ab3GYIM1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 04:12:27 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:37765 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745Ab3GYIMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 04:12:16 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Mike Turquette <mturquette@linaro.org>, linux-arm-msm@vger.kernel.org,
        Saravana Kannan <skannan@codeaurora.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 03/14] clk: Add of_clk_match() for device drivers
Date: Thu, 25 Jul 2013 10:12:12 +0200
Message-ID: <52875092.tEWeSbEJZC@flatron>
User-Agent: KMail/4.10.5 (Linux/3.10.1-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1374713022-6049-4-git-send-email-sboyd@codeaurora.org>
References: <1374713022-6049-1-git-send-email-sboyd@codeaurora.org> <1374713022-6049-4-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Wednesday 24 of July 2013 17:43:31 Stephen Boyd wrote:
> In similar fashion as of_regulator_match() add an of_clk_match()
> function that finds an initializes clock init_data structs from
> devicetree. Drivers should use this API to find clocks that their
> device is providing and then iterate over their match table
> registering the clocks with the init data parsed.

I think all you need here is declaring all your clock drivers using 
CLK_OF_DECLARE() macro. Then they will be automatically probed by 
of_clk_init(). See last lines of drivers/clk/clk-fixed-rate.c for an 
example.

Best regards,
Tomasz

> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  drivers/clk/clk.c            | 64
> ++++++++++++++++++++++++++++++++++++++++++++
> include/linux/clk-provider.h | 16 +++++++++++
>  2 files changed, 80 insertions(+)
> 
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index ea8e951b..1e3e0db 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -2289,4 +2289,68 @@ err:
>  	return -ENOMEM;
>  }
>  EXPORT_SYMBOL_GPL(of_init_clk_data);
> +
> +/**
> + * of_clk_match() - Scan and match clock providers from the DT node of
> a device + * @dev: device initializing clock providers
> + * @matches: match table of clocks
> + * @num_matches: number of entries in @matches
> + *
> + * This function uses a match table specified by the clock driver to
> parse + * clock init data from the device tree. @dev is expected to be
> a device with + * a 'clocks' child node containing a set of child
> nodes, each providing the + * init data for one clock. The data parsed
> from a child node will be matched + * to a clock based on the child
> node's name. Note that the match table is + * modified in place.
> + *
> + * Returns the number of matches found or a negative error code on
> failure. + */
> +int of_clk_match(struct device *dev, struct of_clk_match *matches,
> +		 int num_matches)
> +{
> +	int count = 0;
> +	int err, i;
> +	struct device_node *np, *clocks;
> +	struct clk_init_data *init;
> +
> +	clocks = of_find_node_by_name(dev->of_node, "clocks");
> +	if (!clocks)
> +		return -EINVAL;
> +
> +	for (i = 0; i < num_matches; i++) {
> +		struct of_clk_match *match = &matches[i];
> +		match->init_data = NULL;
> +		match->of_node = NULL;
> +	}
> +
> +	for_each_available_child_of_node(clocks, np) {
> +		for (i = 0; i < num_matches; i++) {
> +			struct of_clk_match *match = &matches[i];
> +			if (match->of_node)
> +				continue;
> +
> +			if (strcmp(match->name, np->name))
> +				continue;
> +
> +			init = devm_kzalloc(dev, sizeof(*init), 
GFP_KERNEL);
> +			if (!init)
> +				return -ENOMEM;
> +
> +			err = of_init_clk_data(np, init);
> +			if (err) {
> +				dev_err(dev,
> +					"failed to parse DT for clock 
%s\n",
> +					np->name);
> +				return err;
> +			}
> +			match->of_node = np;
> +			match->init_data = init;
> +			count++;
> +			break;
> +		}
> +	}
> +
> +	return count;
> +}
> +EXPORT_SYMBOL_GPL(of_clk_match);
>  #endif
> diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
> index 18d6362..484f8ad 100644
> --- a/include/linux/clk-provider.h
> +++ b/include/linux/clk-provider.h
> @@ -461,6 +461,13 @@ struct clk_onecell_data {
>  		__used __section(__clk_of_table)		\
>  		= { .compatible = compat, .data = fn };
> 
> +struct of_clk_match {
> +	const char *name;
> +	void *driver_data;
> +	struct clk_init_data *init_data;
> +	struct device_node *of_node;
> +};
> +
>  #ifdef CONFIG_OF
>  int of_clk_add_provider(struct device_node *np,
>  			struct clk *(*clk_src_get)(struct of_phandle_args 
*args,
> @@ -475,6 +482,9 @@ const char *of_clk_get_parent_name(struct
> device_node *np, int index); void of_clk_init(const struct of_device_id
> *matches);
>  int of_init_clk_data(struct device_node *np, struct clk_init_data
> *init);
> 
> +int of_clk_match(struct device *dev, struct of_clk_match *matches,
> +		 int num_matches);
> +
>  #else /* !CONFIG_OF */
> 
>  static inline int of_clk_add_provider(struct device_node *np,
> @@ -508,6 +518,12 @@ of_init_clk_data(struct device_node *np, struct
> clk_init_data *init) {
>  	return 0;
>  }
> +static inline int
> +of_clk_match(struct device *dev, struct of_clk_match *matches, int
> num_matches) +{
> +
> +	return 0;
> +}
>  #endif /* CONFIG_OF */
>  #endif /* CONFIG_COMMON_CLK */
>  #endif /* CLK_PROVIDER_H */
