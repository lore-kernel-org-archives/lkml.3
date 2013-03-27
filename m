Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568Ab3C0JHa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 05:07:30 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:38250 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419Ab3C0JH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 05:07:26 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        Rajagopal Venkat <rajagopal.venkat@linaro.org>,
        David Brown <davidb@codeaurora.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v4] clk: allow reentrant calls into the clk framework
Date: Wed, 27 Mar 2013 10:08:15 +0100
Message-ID: <1824016.8AdaQMMrrR@avalon>
User-Agent: KMail/4.10 (Linux/3.7.10-gentoo; KDE/4.10.0; x86_64; ; )
In-Reply-To: <1364368183-24420-1-git-send-email-mturquette@linaro.org>
References: <1364368183-24420-1-git-send-email-mturquette@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

Thanks for the patch.

Please see below for a couple of comments.

On Wednesday 27 March 2013 00:09:43 Mike Turquette wrote:
> Reentrancy into the clock framework from the clk.h api is necessary for
> clocks that are prepared and unprepared via i2c_transfer (which includes
> many PMICs and discrete audio chips) as well as for several other use
> cases.
> 
> This patch implements reentrancy by adding two global atomic_t's which
> track the context of the current caller.  Context in this case is the
> return value from get_current().  One context variable is for slow
> operations protected by the prepare_mutex and the other is for fast
> operations protected by the enable_lock spinlock.
> 
> The clk.h api implementations are modified to first see if the relevant
> global lock is already held and if so compare the global context (set by
> whoever is holding the lock) against their own context (via a call to
> get_current()).  If the two match then this function is a nested call
> from the one already holding the lock and we procede.  If the context
> does not match then procede to call mutex_lock and busy-wait for the
> existing task to complete.
> 
> This patch does not increase concurrency for unrelated calls into the
> clock framework.  Instead it simply allows reentrancy by the single task
> which is currently holding the global clock framework lock.
> 
> Signed-off-by: Mike Turquette <mturquette@linaro.org>
> Cc: Rajagopal Venkat <rajagopal.venkat@linaro.org>
> Cc: David Brown <davidb@codeaurora.org>
> Cc: Ulf Hansson <ulf.hansson@linaro.org>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/clk/clk.c |  255 +++++++++++++++++++++++++++++++++++---------------
>  1 file changed, 186 insertions(+), 69 deletions(-)
> 
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index 5e8ffff..17432a5 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -19,9 +19,12 @@
>  #include <linux/of.h>
>  #include <linux/device.h>
>  #include <linux/init.h>
> +#include <linux/sched.h>
> 
>  static DEFINE_SPINLOCK(enable_lock);
>  static DEFINE_MUTEX(prepare_lock);
> +static atomic_t prepare_context;
> +static atomic_t enable_context;
> 
>  static HLIST_HEAD(clk_root_list);
>  static HLIST_HEAD(clk_orphan_list);

[snip]

> @@ -566,6 +548,35 @@ struct clk *__clk_lookup(const char *name)
>  	return NULL;
>  }
> 
> +/***  locking & reentrancy ***/
> +
> +static void clk_fwk_lock(void)
> +{
> +	/* hold the framework-wide lock, context == NULL */
> +	mutex_lock(&prepare_lock);
> +
> +	/* set context for any reentrant calls */
> +	atomic_set(&prepare_context, (int) get_current());

Won't that break on 64-bit architectures with sizeof(void *) != sizeof(int) ?

I wonder if it would make sense to abstract these operations in a generic 
recursive mutex. Given that it would delay this patch past v3.10 I won't push 
for that.

> +}
> +
> +static void clk_fwk_unlock(void)
> +{
> +	/* clear the context */
> +	atomic_set(&prepare_context, 0);
> +
> +	/* release the framework-wide lock, context == NULL */
> +	mutex_unlock(&prepare_lock);
> +}
> +
> +static bool clk_is_reentrant(void)
> +{
> +	if (mutex_is_locked(&prepare_lock))
> +		if ((void *) atomic_read(&prepare_context) == get_current())
> +			return true;
> +
> +	return false;
> +}
> +
>  /***        clk api        ***/
> 
>  void __clk_unprepare(struct clk *clk)

[snip]

> @@ -877,6 +945,30 @@ static void __clk_recalc_rates(struct clk *clk,
> unsigned long msg) __clk_recalc_rates(child, msg);
>  }
> 
> +unsigned long __clk_get_rate(struct clk *clk)
> +{
> +	unsigned long ret;
> +
> +	if (!clk) {
> +		ret = 0;
> +		goto out;

You could return 0 directly here.

> +	}
> +
> +	if (clk->flags & CLK_GET_RATE_NOCACHE)
> +		__clk_recalc_rates(clk, 0);
> +
> +	ret = clk->rate;
> +
> +	if (clk->flags & CLK_IS_ROOT)
> +		goto out;

And return ret here.

> +
> +	if (!clk->parent)
> +		ret = 0;
> +
> +out:
> +	return ret;
> +}
> +
>  /**
>   * clk_get_rate - return the rate of clk
>   * @clk: the clk whose rate is being returned
> @@ -889,14 +981,22 @@ unsigned long clk_get_rate(struct clk *clk)
>  {
>  	unsigned long rate;
> 
> -	mutex_lock(&prepare_lock);
> +	/*
> +	 * FIXME - any locking here seems heavy weight
> +	 * can clk->rate be replaced with an atomic_t?
> +	 * same logic can likely be applied to prepare_count & enable_count
> +	 */
> 
> -	if (clk && (clk->flags & CLK_GET_RATE_NOCACHE))
> -		__clk_recalc_rates(clk, 0);
> +	if (clk_is_reentrant()) {
> +		rate = __clk_get_rate(clk);
> +		goto out;

You can return directly here as well.

> +	}
> 
> +	clk_fwk_lock();
>  	rate = __clk_get_rate(clk);
> -	mutex_unlock(&prepare_lock);
> +	clk_fwk_unlock();
> 
> +out:
>  	return rate;
>  }
>  EXPORT_SYMBOL_GPL(clk_get_rate);
> @@ -1073,6 +1173,39 @@ static void clk_change_rate(struct clk *clk)
>  		clk_change_rate(child);
>  }
> 
> +int __clk_set_rate(struct clk *clk, unsigned long rate)
> +{
> +	int ret = 0;
> +	struct clk *top, *fail_clk;
> +
> +	/* bail early if nothing to do */
> +	if (rate == clk->rate)
> +		return 0;
> +
> +	if ((clk->flags & CLK_SET_RATE_GATE) && clk->prepare_count) {
> +		return -EBUSY;
> +	}

Braces are not necessary.

> +	/* calculate new rates and get the topmost changed clock */
> +	top = clk_calc_new_rates(clk, rate);
> +	if (!top)
> +		return -EINVAL;
> +
> +	/* notify that we are about to change rates */
> +	fail_clk = clk_propagate_rate_change(top, PRE_RATE_CHANGE);
> +	if (fail_clk) {
> +		pr_warn("%s: failed to set %s rate\n", __func__,
> +				fail_clk->name);
> +		clk_propagate_rate_change(top, ABORT_RATE_CHANGE);
> +		return -EBUSY;
> +	}
> +
> +	/* change the rates */
> +	clk_change_rate(top);
> +
> +	return ret;
> +}
> +
>  /**
>   * clk_set_rate - specify a new rate for clk
>   * @clk: the clk whose rate is being changed

-- 
Regards,

Laurent Pinchart

