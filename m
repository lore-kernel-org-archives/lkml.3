Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910AbaB1KqW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 05:46:22 -0500
Received: from top.free-electrons.com ([176.31.233.9]:50544 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750927AbaB1KqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 05:46:20 -0500
Message-ID: <531068F4.3060903@free-electrons.com>
Date: Fri, 28 Feb 2014 11:46:12 +0100
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: Tomasz Figa <tomasz.figa@gmail.com>, linux-kernel@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
Subject: Re: [PATCH v3] clk: respect the clock dependencies in of_clk_init
References: <1393265413-16641-1-git-send-email-gregory.clement@free-electrons.com>
In-Reply-To: <1393265413-16641-1-git-send-email-gregory.clement@free-electrons.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On 24/02/2014 19:10, Gregory CLEMENT wrote:
> Until now the clock providers were initialized in the order found in
> the device tree. This led to have the dependencies between the clocks
> not respected: children clocks could be initialized before their
> parent clocks.
> 
> Instead of forcing each platform to manage its own initialization order,
> this patch adds this work inside the framework itself.
> 
> Using the data of the device tree the of_clk_init function now delayed
> the initialization of a clock provider if its parent provider was not
> ready yet.
> 
> The strict dependency check (all parents of a given clk must be
> initialized) was added by Boris BREZILLON

Are you ok with this version?
Will you take it for 3.15?
Or maybe you expected that it will be part of a pull request?

However as it is modifying the core of the framework I thought that you
would take it and apply yourself.

Thanks,

Gregory

> 
> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
> ---
> Mike,
> 
> This patch depend on the patch "clk: return probe defer when DT clock
> not yet ready": http://article.gmane.org/gmane.linux.kernel/1643466
> 
> If for any reason you don't want to take it, then I will write a new
> version closer to the v2 for the parent_ready() function.
> 
> I have taken into account all the remarks from Tomasz.
> 
> Thanks,
> 
> Changelog:
> v2->v3:
> 
> - added the SoB flag of Boris
> - used of_clk_get(np, i) in the parent_ready() function.
> - simplified the loops to manage the order dependencies in of_clk_init()
> 
> v1 -> v2:
> Merged the  strict dependency check from Boris.
> 
> 
>  drivers/clk/clk.c | 83 ++++++++++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 79 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index 32d84e921b23..3a07f8ac2e11 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -2526,24 +2526,99 @@ const char *of_clk_get_parent_name(struct device_node *np, int index)
>  }
>  EXPORT_SYMBOL_GPL(of_clk_get_parent_name);
>  
> +struct clock_provider {
> +	of_clk_init_cb_t clk_init_cb;
> +	struct device_node *np;
> +	struct list_head node;
> +};
> +
> +static LIST_HEAD(clk_provider_list);
> +
> +/*
> + * This function looks for a parent clock. If there is one, then it
> + * checks that the provider for this parent clock was initialized, in
> + * this case the parent clock will be ready.
> + */
> +static int parent_ready(struct device_node *np)
> +{
> +	int i = 0;
> +
> +	while (true) {
> +		struct clk *clk = of_clk_get(np, i);
> +
> +		/* this parent is ready we can check the next one */
> +		if (!IS_ERR(clk)) {
> +			clk_put(clk);
> +			i++;
> +			continue;
> +		}
> +
> +		/* at least one parent is not ready, we exit now */
> +		if (PTR_ERR(clk) == -EPROBE_DEFER)
> +			return 0;
> +
> +		/*
> +		 * Here we make assumption that the device tree is
> +		 * written correctly. So an error means that there is
> +		 * no more parent. As we didn't exit yet, then the
> +		 * previous parent are ready. If there is no clock
> +		 * parent, no need to wait for them, then we can
> +		 * consider their absence as being ready
> +		 */
> +		return 1;
> +	}
> +}
> +
>  /**
>   * of_clk_init() - Scan and init clock providers from the DT
>   * @matches: array of compatible values and init functions for providers.
>   *
> - * This function scans the device tree for matching clock providers and
> - * calls their initialization functions
> + * This function scans the device tree for matching clock providers
> + * and calls their initialization functions. It also do it by trying
> + * to follow the dependencies.
>   */
>  void __init of_clk_init(const struct of_device_id *matches)
>  {
>  	const struct of_device_id *match;
>  	struct device_node *np;
> +	struct clock_provider *clk_provider, *next;
> +	bool is_init_done;
> +	bool force = false;
>  
>  	if (!matches)
>  		matches = &__clk_of_table;
>  
> +	/* First prepare the list of the clocks providers */
>  	for_each_matching_node_and_match(np, matches, &match) {
> -		of_clk_init_cb_t clk_init_cb = match->data;
> -		clk_init_cb(np);
> +		struct clock_provider *parent =
> +			kzalloc(sizeof(struct clock_provider),	GFP_KERNEL);
> +
> +		parent->clk_init_cb = match->data;
> +		parent->np = np;
> +		list_add(&parent->node, &clk_provider_list);
> +	}
> +
> +	while (!list_empty(&clk_provider_list)) {
> +		is_init_done = false;
> +		list_for_each_entry_safe(clk_provider, next,
> +					&clk_provider_list, node) {
> +			if (force || parent_ready(clk_provider->np)) {
> +				clk_provider->clk_init_cb(clk_provider->np);
> +				list_del(&clk_provider->node);
> +				kfree(clk_provider);
> +				is_init_done = true;
> +			}
> +		}
> +
> +		/*
> +		 * We didn't managed to initialize any of the
> +		 * remaining providers during the last loop, so now we
> +		 * initialize all the remaining ones unconditionally
> +		 * in case the clock parent was not mandatory
> +		 */
> +		if (!is_init_done)
> +			force = true;
> +
>  	}
>  }
>  #endif
> 


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
