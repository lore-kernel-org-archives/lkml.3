Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872Ab3IYSSp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 14:18:45 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:46703 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754798Ab3IYSSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 14:18:42 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: linux@arm.linux.org.uk, mturquette@linaro.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        linux-arm-kernel@lists.infradead.org, jiada_wang@mentor.com,
        kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
        t.figa@samsung.com, g.liakhovetski@gmx.de,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH v6 0/5] clk: clock deregistration support
Date: Wed, 25 Sep 2013 11:47:36 +0200
Message-ID: <3160771.O1gFkR91vK@avalon>
User-Agent: KMail/4.10.5 (Linux/3.8.13-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <52420664.2040604@gmail.com>
References: <1377874402-2944-1-git-send-email-s.nawrocki@samsung.com> <52420664.2040604@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sylwester,

On Tuesday 24 September 2013 23:38:44 Sylwester Nawrocki wrote:
> On 08/30/2013 04:53 PM, Sylwester Nawrocki wrote:
> > This patch series implements clock deregistration in the common clock
> > framework. Comparing to v5 it only includes further corrections of NULL
> > clock handling.
> 
> [...]
> 
> >    clk: Provide not locked variant of of_clk_get_from_provider()
> >    clkdev: Fix race condition in clock lookup from device tree
> >    clk: Add common __clk_get(), __clk_put() implementations
> >    clk: Assign module owner of a clock being registered
> >    clk: Implement clk_unregister
> 
> Hi Mike, Russell,
> 
> Would you have any further comments/suggestions on this series ?
> 
> I have inspected all callers of clk_register() and all should be fine
> with regards to dereferencing dev->driver. The first argument to this
> function is either NULL or clk_register() is being called in drivers'
> probe() callback, which ensures dev->driver won't change due to holding
> dev->mutex.
> 
> The only issue I found might be at the omap3isp driver, which provides
> clock to its sub-drivers and takes reference on the sub-driver modules.
> When sub-driver calls clk_get() all modules would get locked in memory,
> due to circular reference. One solution to that could be to pass NULL
> struct device pointer, as in the below patch.

Doesn't that introduce race conditions ? If the sub-drivers require the clock, 
they want to be sure that the clock won't disappear beyond their backs. I 
agree that the circular dependency needs to be solved somehow, but we probably 
need a more generic solution. The problem will become more widespread in the 
future with DT-based device instantiation in both V4L2 and KMS.

> ---------8<------------------
>  From ca5963041aad67e31324cb5d4d5e2cfce1706d4f Mon Sep 17 00:00:00 2001
> From: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Date: Thu, 19 Sep 2013 23:52:04 +0200
> Subject: [PATCH] omap3isp: Pass NULL device pointer to clk_register()
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> ---
>   drivers/media/platform/omap3isp/isp.c |   15 ++++++++++-----
>   drivers/media/platform/omap3isp/isp.h |    1 +
>   2 files changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/platform/omap3isp/isp.c
> b/drivers/media/platform/omap3isp/isp.c
> index df3a0ec..d7f3c98 100644
> --- a/drivers/media/platform/omap3isp/isp.c
> +++ b/drivers/media/platform/omap3isp/isp.c
> @@ -290,9 +290,11 @@ static int isp_xclk_init(struct isp_device *isp)
>   	struct clk_init_data init;
>   	unsigned int i;
> 
> +	for (i = 0; i < ARRAY_SIZE(isp->xclks); ++i)
> +		isp->xclks[i] = ERR_PTR(-EINVAL);
> +
>   	for (i = 0; i < ARRAY_SIZE(isp->xclks); ++i) {
>   		struct isp_xclk *xclk = &isp->xclks[i];
> -		struct clk *clk;
> 
>   		xclk->isp = isp;
>   		xclk->id = i == 0 ? ISP_XCLK_A : ISP_XCLK_B;
> @@ -306,9 +308,9 @@ static int isp_xclk_init(struct isp_device *isp)
> 
>   		xclk->hw.init = &init;
> 
> -		clk = devm_clk_register(isp->dev, &xclk->hw);
> -		if (IS_ERR(clk))
> -			return PTR_ERR(clk);
> +		xclk->clk = clk_register(NULL, &xclk->hw);
> +		if (IS_ERR(xclk->clk))
> +			return PTR_ERR(xclk->clk);
> 
>   		if (pdata->xclks[i].con_id == NULL &&
>   		    pdata->xclks[i].dev_id == NULL)
> @@ -320,7 +322,7 @@ static int isp_xclk_init(struct isp_device *isp)
> 
>   		xclk->lookup->con_id = pdata->xclks[i].con_id;
>   		xclk->lookup->dev_id = pdata->xclks[i].dev_id;
> -		xclk->lookup->clk = clk;
> +		xclk->lookup->clk = xclk->clk;
> 
>   		clkdev_add(xclk->lookup);
>   	}
> @@ -335,6 +337,9 @@ static void isp_xclk_cleanup(struct isp_device *isp)
>   	for (i = 0; i < ARRAY_SIZE(isp->xclks); ++i) {
>   		struct isp_xclk *xclk = &isp->xclks[i];
> 
> +		if (!IS_ERR(xclk->clk))
> +			clk_unregister(xclk->clk);
> +
>   		if (xclk->lookup)
>   			clkdev_drop(xclk->lookup);
>   	}
> diff --git a/drivers/media/platform/omap3isp/isp.h
> b/drivers/media/platform/omap3isp/isp.h
> index cd3eff4..1498f2b 100644
> --- a/drivers/media/platform/omap3isp/isp.h
> +++ b/drivers/media/platform/omap3isp/isp.h
> @@ -135,6 +135,7 @@ struct isp_xclk {
>   	struct isp_device *isp;
>   	struct clk_hw hw;
>   	struct clk_lookup *lookup;
> +	struct clk *clk;
>   	enum isp_xclk_id id;
> 
>   	spinlock_t lock;	/* Protects enabled and divider */
> ---------8<------------------
> 
> Alternatively an additional argument could be added to the clk_register*()
> functions. Something like:
> 
> ---------8<------------------
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index 27f8c42..ef934ac 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -1837,7 +1837,8 @@ struct clk *__clk_register(struct device *dev,
> struct clk_hw *hw)
> 
>   }
>   EXPORT_SYMBOL_GPL(__clk_register);
> 
> -static int _clk_register(struct device *dev, struct clk_hw *hw, struct
> clk *clk)
> +static int _clk_register(struct device *dev, struct clk_hw *hw, struct
> clk *clk,
> +                         struct module *owner)
>   {
>         int i, ret;
> 
> @@ -1877,6 +1878,8 @@ static int _clk_register(struct device *dev,
> struct clk_hw *hw, struct clk *clk)
>                 }
>         }
> 
> +       clk->owner = owner;
> +
>         ret = __clk_init(dev, clk);
>         if (!ret)
>                 return 0;
> @@ -1892,7 +1895,7 @@ fail_name:
>   }
>   
>   /**
> - * clk_register - allocate a new clock, register it and return an
> opaque cookie
> + * ___clk_register - allocate a new clock, register it and return an
> opaque cookie
>    * @dev: device that is registering this clock
>    * @hw: link to hardware-specific clock data
>    *
> @@ -1902,7 +1905,8 @@ fail_name:
>    * rest of the clock API.  In the event of an error clk_register will
>    * return an error code; drivers must test for an error code after calling
>    * clk_register.
>    */
> 
> -struct clk *clk_register(struct device *dev, struct clk_hw *hw)
> +struct clk *___clk_register(struct device *dev, struct clk_hw *hw,
> +                                               struct module *owner)
>   {
>         int ret;
>         struct clk *clk;
> @@ -1914,7 +1918,7 @@ struct clk *clk_register(struct device *dev,
> struct clk_hw *hw)
>                 goto fail_out;
>         }
> -       ret = _clk_register(dev, hw, clk);
> +       ret = _clk_register(dev, hw, clk, owner);
>         if (!ret)
>                 return clk;
> 
> @@ -1922,7 +1926,7 @@ struct clk *clk_register(struct device *dev,
> struct clk_hw *hw)
>   fail_out:
>         return ERR_PTR(ret);
>   }
> -EXPORT_SYMBOL_GPL(clk_register);
> +EXPORT_SYMBOL_GPL(___clk_register);
> 
>   /*
>    * Free memory allocated for a clock.
> @@ -2040,7 +2044,8 @@ static void devm_clk_release(struct device *dev,
> void *res)
>    * automatically clk_unregister()ed on driver detach. See
>    * clk_register() for more information.
>    */
> -struct clk *devm_clk_register(struct device *dev, struct clk_hw *hw)
> +struct clk *__devm_clk_register(struct device *dev, struct clk_hw *hw,
> +                                               struct module *owner)
>   {
>         struct clk *clk;
>         int ret;
> @@ -2049,7 +2054,7 @@ struct clk *devm_clk_register(struct device *dev,
> struct clk_hw *hw)
>         if (!clk)
>                 return ERR_PTR(-ENOMEM);
> 
> -       ret = _clk_register(dev, hw, clk);
> +       ret = _clk_register(dev, hw, clk, owner);
>         if (!ret) {
>                 devres_add(dev, clk);
>         } else {
> @@ -2059,7 +2064,7 @@ struct clk *devm_clk_register(struct device *dev,
> struct clk_hw *hw)
>         return clk;
>   }
> -EXPORT_SYMBOL_GPL(devm_clk_register);
> +EXPORT_SYMBOL_GPL(__devm_clk_register);
> 
>   static int devm_clk_match(struct device *dev, void *res, void *data)
>   {
> diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
> index 13623f3..c656ebf 100644
> --- a/include/linux/clk-provider.h
> +++ b/include/linux/clk-provider.h
> @@ -31,6 +31,7 @@
>   #define CLK_SET_RATE_NO_REPARENT BIT(7) /* don't re-parent on rate
> change */
> 
>  struct clk_hw;
> +struct module;
> 
>   /**
>    * struct clk_ops -  Callback operations for hardware clocks; these are to
> @@ -436,8 +437,21 @@ struct clk *clk_register_composite(struct device
> *dev, const char *name,
>    * rest of the clock API.  In the event of an error clk_register will
>    * return an error code; drivers must test for an error code after calling
>    * clk_register.
>    */
> -struct clk *clk_register(struct device *dev, struct clk_hw *hw);
> -struct clk *devm_clk_register(struct device *dev, struct clk_hw *hw);
> +struct clk *___clk_register(struct device *dev, struct clk_hw *hw,
> +               struct module *owner);
> +
> +static inline struct clk *clk_register(struct device *dev, struct
> clk_hw *hw)
> +{
> +       return ___clk_register(dev, hw, THIS_MODULE);
> +}
> +
> +struct clk *__devm_clk_register(struct device *dev, struct clk_hw *hw,
> +                               struct module *owner);
> +static inline struct clk *devm_clk_register(struct device *dev,
> +                                           struct clk_hw *hw)
> +{
> +       return __devm_clk_register(dev, hw, THIS_MODULE);
> +}
> 
>   void clk_unregister(struct clk *clk);
>   void devm_clk_unregister(struct device *dev, struct clk *clk);
> ---------8<------------------
> 
> Similarly it would need to be done for the remaining clk_register*()
> functions, which have much longer arguments list.
> 
> It's a bit messy, since there is already __clk_register() function with
> double underscore prefix. Perhaps that could be renamed to something else so
> all the functions taking struct module * parameter are prefixed with double
> underscore.
> 
> I would squash patches 3/5 and 4/5 in the next iteration, if it is decided
> to keep using dev->driver->owner.
-- 
Regards,

Laurent Pinchart

