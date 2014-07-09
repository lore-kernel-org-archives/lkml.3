Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351AbaGIUCD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 16:02:03 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:49093 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846AbaGIUCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 16:02:00 -0400
Message-ID: <53BD9FA3.1040204@gmail.com>
Date: Wed, 09 Jul 2014 22:01:39 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Mike Turquette <mturquette@linaro.org>, rabin@rab.in,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
CC: Rabin Vincent <rabin.vincent@stericsson.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: Re: [RFC v2 4/5] clk: per-user clock accounting for debug
References: <1404398323-18934-1-git-send-email-tomeu.vizoso@collabora.com> <1404398323-18934-5-git-send-email-tomeu.vizoso@collabora.com>
In-Reply-To: <1404398323-18934-5-git-send-email-tomeu.vizoso@collabora.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomeu, Rabin,

Please see my comments inline.

On 03.07.2014 16:38, Tomeu Vizoso wrote:
> From: Rabin Vincent <rabin.vincent@stericsson.com>
> 
> When a clock has multiple users, the WARNING on imbalance of
> enable/disable may not show the guilty party since although they may
> have commited the error earlier, the warning is emitted later when some
> other user, presumably innocent, disables the clock.

[snip]

> diff --git a/drivers/clk/clk-devres.c b/drivers/clk/clk-devres.c
> index 5f2aba9..d6a5e59 100644
> --- a/drivers/clk/clk-devres.c
> +++ b/drivers/clk/clk-devres.c
> @@ -37,7 +37,8 @@ EXPORT_SYMBOL(devm_clk_provider_get);
>  
>  struct clk *devm_clk_get(struct device *dev, const char *id)
>  {
> -	return clk_core_to_clk(devm_clk_provider_get(dev, id));
> +	const char *dev_id = dev ? dev_name(dev) : NULL;
> +	return clk_core_to_clk(devm_clk_provider_get(dev, id), dev_id, id);

Hmm, correct me if I'm missing something but you're just calling
devm_clk_provider() which guarantees calling of clk_provider_put() on
device removal, but what about the consumer struct being created here?

Shouldn't you rather call normal clk_provider_get() here, then create a
consumer struct for it and then wrap it up using devres, providing
appropriate release function?

>  }
>  EXPORT_SYMBOL(devm_clk_get);
>  
> diff --git a/drivers/clk/clk-highbank.c b/drivers/clk/clk-highbank.c
> index cc1bae1..4e38856 100644
> --- a/drivers/clk/clk-highbank.c
> +++ b/drivers/clk/clk-highbank.c
> @@ -331,7 +331,7 @@ CLK_OF_DECLARE(hb_a9periph, "calxeda,hb-a9periph-clock", hb_a9periph_init);
>  static void __init hb_a9bus_init(struct device_node *node)
>  {
>  	struct clk_core *clk = hb_clk_init(node, &a9bclk_ops);
> -	clk_prepare_enable(clk_core_to_clk(clk));
> +	clk_prepare_enable(clk_core_to_clk(clk, node->full_name, NULL));
>  }
>  CLK_OF_DECLARE(hb_a9bus, "calxeda,hb-a9bus-clock", hb_a9bus_init);
>  
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index 644a824..b887c69 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -568,6 +568,28 @@ static int clk_disable_unused(void)
>  }
>  late_initcall_sync(clk_disable_unused);
>  
> +struct clk *clk_core_to_clk(struct clk_core *clk_core, const char *dev,
> +			    const char *con)

Name of this function suggests that this is just a simple conversion,
while it creates new object. I would suggest calling this
clk_create_consumer() or something along these lines.

> +{
> +	struct clk *clk;
> +
> +	clk = kzalloc(sizeof(*clk), GFP_KERNEL);
> +	if (!clk)
> +		return ERR_PTR(-ENOMEM);

[snip]

> +static void clk_free_clk(struct clk *clk)
> +{
> +	kfree(clk);
> +}

Any need for this one-liner? Seems to be used just once below.

> +
>  void clk_put(struct clk *clk)
>  {
> -	__clk_put(clk_to_clk_core(clk));
> +	clk_core_t *core = clk_to_clk_core(clk);
> +
> +	clk_free_clk(clk);
> +	__clk_put(core);
>  }
>  EXPORT_SYMBOL(clk_put);
>  
> diff --git a/drivers/clk/qcom/mmcc-msm8960.c b/drivers/clk/qcom/mmcc-msm8960.c
> index 28a5d30..47f21ea 100644
> --- a/drivers/clk/qcom/mmcc-msm8960.c
> +++ b/drivers/clk/qcom/mmcc-msm8960.c
> @@ -470,7 +470,8 @@ static int pix_rdi_set_parent(struct clk_hw *hw, u8 index)
>  	 * needs to be on at what time.
>  	 */
>  	for (i = 0; i < num_parents; i++) {
> -		ret = clk_prepare_enable(clk_core_to_clk(clk_get_parent_by_index(clk, i)));
> +		struct clk_core *parent = clk_get_parent_by_index(clk, i);
> +		ret = clk_prepare_enable(clk_core_to_clk(parent, NULL, __clk_get_name(parent)));

Shouldn't this use clk_provider_*() instead? IMHO clk_core_to_clk() and
clk_to_clk_core() shouldn't be available to clock drivers, just the core
clock code. Consumers should operate on struct clks alone, clock drivers
should operate only on struct clk_cores and only the core code should be
responsible for necessary conversions.

>  		if (ret)
>  			goto err;
>  	}
> @@ -498,8 +499,10 @@ static int pix_rdi_set_parent(struct clk_hw *hw, u8 index)
>  	udelay(1);
>  
>  err:
> -	for (i--; i >= 0; i--)
> -		clk_disable_unprepare(clk_core_to_clk(clk_get_parent_by_index(clk, i)));
> +	for (i--; i >= 0; i--) {
> +		struct clk_core *parent = clk_get_parent_by_index(clk, i);
> +		clk_disable_unprepare(clk_core_to_clk(parent, NULL, __clk_get_name(parent)));

Hmm. Memory leak? Every time this operation is called you create a
consumer struct for each parent two times.

> +	}
>  
>  	return ret;
>  }
> diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi.c
> index 5de44c1..550a691 100644
> --- a/drivers/clk/sunxi/clk-sunxi.c
> +++ b/drivers/clk/sunxi/clk-sunxi.c
> @@ -1196,7 +1196,7 @@ static void __init sunxi_init_clocks(const char *clocks[], int nclocks)
>  		struct clk_core *clk = clk_provider_get(NULL, clocks[i]);
>  
>  		if (!IS_ERR(clk))
> -			clk_prepare_enable(clk_core_to_clk(clk));
> +			clk_prepare_enable(clk_core_to_clk(clk, NULL, clocks[i]));

Probably should use clk_provider_*()?

>  	}
>  }
>  
> diff --git a/drivers/clk/tegra/clk.c b/drivers/clk/tegra/clk.c
> index 385d101..2a03d47 100644
> --- a/drivers/clk/tegra/clk.c
> +++ b/drivers/clk/tegra/clk.c
> @@ -228,7 +228,7 @@ void __init tegra_init_from_table(struct tegra_clk_init_table *tbl,
>  			}
>  
>  		if (tbl->state)
> -			if (clk_prepare_enable(clk_core_to_clk(clk))) {
> +			if (clk_prepare_enable(clk_core_to_clk(clk, NULL, __clk_get_name(clk)))) {

Ditto. And all similar cases below which I skipped due to lack of any
added value to this review.

>  				pr_err("%s: Failed to enable %s\n", __func__,
>  				       __clk_get_name(clk));
>  				WARN_ON(1);

[snip]

> diff --git a/include/linux/clk-private.h b/include/linux/clk-private.h
> index 2c1ece9..9657fc8 100644
> --- a/include/linux/clk-private.h
> +++ b/include/linux/clk-private.h
> @@ -57,6 +57,10 @@ struct clk_core {
>  
>  struct clk {
>  	struct clk_core	*core;
> +	unsigned int	enable_count;
> +	const char	*dev_id;
> +	const char	*con_id;
> +	void		*last_disable;

Probably the same as for enables should be done for prepares.

>  };
>  
>  /*
> diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
> index 87de32c..abfc31a 100644
> --- a/include/linux/clk-provider.h
> +++ b/include/linux/clk-provider.h
> @@ -533,7 +533,8 @@ struct clk_core *clk_provider_get_sys(const char *dev_id, const char *con_id);
>  struct clk_core *clk_provider_get(struct device *dev, const char *con_id);
>  struct clk_core *devm_clk_provider_get(struct device *dev, const char *id);
>  
> -#define clk_core_to_clk(core)	((struct clk *)(core))

Btw. this should have been a static inline.

Best regards,
Tomasz
