Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379Ab3GYI0g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 04:26:36 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:60203 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755297Ab3GYI0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 04:26:21 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Mike Turquette <mturquette@linaro.org>, linux-arm-msm@vger.kernel.org,
        James Hogan <james.hogan@imgtec.com>,
        Saravana Kannan <skannan@codeaurora.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 04/14] clk: Add set_rate_and_parent() op
Date: Thu, 25 Jul 2013 10:26:18 +0200
Message-ID: <4582949.WCP5JfKYES@flatron>
User-Agent: KMail/4.10.5 (Linux/3.10.1-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1374713022-6049-5-git-send-email-sboyd@codeaurora.org>
References: <1374713022-6049-1-git-send-email-sboyd@codeaurora.org> <1374713022-6049-5-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 of July 2013 17:43:32 Stephen Boyd wrote:
> Some of Qualcomm's clocks can change their parent and rate at the
> same time with a single register write. Add support for this
> hardware to the common clock framework by adding a new
> set_rate_and_parent() op. When the clock framework determines
> that both the parent and the rate are going to change during
> clk_set_rate() it will call the .set_rate_and_parent() op if
> available and fall back to calling .set_parent() followed by
> .set_rate() otherwise.

This is strange. Does you hardware support switching parent and rate 
separately or you always need to set both and so all the fuss here?

If the latter is the case, then maybe you can simply keep parent index and 
rate cached inside driver data of your clock driver and use them on any 
.set_rate() or .set_parent() calls?

I'm not really sure if we want such oddities to be handled inside of 
common clock framework. Mike, what do you think?

Best regards,
Tomasz

> Cc: James Hogan <james.hogan@imgtec.com>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  Documentation/clk.txt        |  3 ++
>  drivers/clk/clk.c            | 78
> +++++++++++++++++++++++++++++++++-----------
> include/linux/clk-provider.h | 15 +++++++++
>  3 files changed, 77 insertions(+), 19 deletions(-)
> 
> diff --git a/Documentation/clk.txt b/Documentation/clk.txt
> index 3aeb5c4..79700ea 100644
> --- a/Documentation/clk.txt
> +++ b/Documentation/clk.txt
> @@ -77,6 +77,9 @@ the operations defined in clk.h:
>  		int		(*set_parent)(struct clk_hw *hw, u8 
index);
>  		u8		(*get_parent)(struct clk_hw *hw);
>  		int		(*set_rate)(struct clk_hw *hw, unsigned 
long);
> +		int		(*set_rate_and_parent)(struct clk_hw *hw,
> +					    unsigned long rate,
> +					    unsigned long parent_rate, u8 
index);
>  		void		(*init)(struct clk_hw *hw);
>  	};
> 
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index 1e3e0db..73de07c 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -1121,10 +1121,9 @@ static void clk_reparent(struct clk *clk, struct
> clk *new_parent) clk->parent = new_parent;
>  }
> 
> -static int __clk_set_parent(struct clk *clk, struct clk *parent, u8
> p_index) +static struct clk *__clk_set_parent_before(struct clk *clk,
> struct clk *parent) {
>  	unsigned long flags;
> -	int ret = 0;
>  	struct clk *old_parent = clk->parent;
> 
>  	/*
> @@ -1155,6 +1154,34 @@ static int __clk_set_parent(struct clk *clk,
> struct clk *parent, u8 p_index) clk_reparent(clk, parent);
>  	clk_enable_unlock(flags);
> 
> +	return old_parent;
> +}
> +
> +static void __clk_set_parent_after(struct clk *clk, struct clk *parent,
> +		struct clk *old_parent)
> +{
> +	/*
> +	 * Finish the migration of prepare state and undo the changes done
> +	 * for preventing a race with clk_enable().
> +	 */
> +	if (clk->prepare_count) {
> +		clk_disable(clk);
> +		clk_disable(old_parent);
> +		__clk_unprepare(old_parent);
> +	}
> +
> +	/* update debugfs with new clk tree topology */
> +	clk_debug_reparent(clk, parent);
> +}
> +
> +static int __clk_set_parent(struct clk *clk, struct clk *parent, u8
> p_index) +{
> +	unsigned long flags;
> +	int ret = 0;
> +	struct clk *old_parent;
> +
> +	old_parent = __clk_set_parent_before(clk, parent);
> +
>  	/* change clock input source */
>  	if (parent && clk->ops->set_parent)
>  		ret = clk->ops->set_parent(clk->hw, p_index);
> @@ -1172,18 +1199,8 @@ static int __clk_set_parent(struct clk *clk,
> struct clk *parent, u8 p_index) return ret;
>  	}
> 
> -	/*
> -	 * Finish the migration of prepare state and undo the changes done
> -	 * for preventing a race with clk_enable().
> -	 */
> -	if (clk->prepare_count) {
> -		clk_disable(clk);
> -		clk_disable(old_parent);
> -		__clk_unprepare(old_parent);
> -	}
> +	__clk_set_parent_after(clk, parent, old_parent);
> 
> -	/* update debugfs with new clk tree topology */
> -	clk_debug_reparent(clk, parent);
>  	return 0;
>  }
> 
> @@ -1368,17 +1385,32 @@ static void clk_change_rate(struct clk *clk)
>  	struct clk *child;
>  	unsigned long old_rate;
>  	unsigned long best_parent_rate = 0;
> +	bool skip_set_rate = false;
> +	struct clk *old_parent;
> 
>  	old_rate = clk->rate;
> 
> -	/* set parent */
> -	if (clk->new_parent && clk->new_parent != clk->parent)
> -		__clk_set_parent(clk, clk->new_parent, clk-
>new_parent_index);
> -
> -	if (clk->parent)
> +	if (clk->new_parent)
> +		best_parent_rate = clk->new_parent->rate;
> +	else if (clk->parent)
>  		best_parent_rate = clk->parent->rate;
> 
> -	if (clk->ops->set_rate)
> +	if (clk->new_parent && clk->new_parent != clk->parent) {
> +		old_parent = __clk_set_parent_before(clk, clk-
>new_parent);
> +
> +		if (clk->ops->set_rate_and_parent) {
> +			skip_set_rate = true;
> +			clk->ops->set_rate_and_parent(clk->hw, clk-
>new_rate,
> +					best_parent_rate,
> +					clk->new_parent_index);
> +		} else if (clk->ops->set_parent) {
> +			clk->ops->set_parent(clk->hw, clk-
>new_parent_index);
> +		}
> +
> +		__clk_set_parent_after(clk, clk->new_parent, old_parent);
> +	}
> +
> +	if (!skip_set_rate && clk->ops->set_rate)
>  		clk->ops->set_rate(clk->hw, clk->new_rate, 
best_parent_rate);
> 
>  	if (clk->ops->recalc_rate)
> @@ -1664,6 +1696,14 @@ int __clk_init(struct device *dev, struct clk
> *clk) goto out;
>  	}
> 
> +	if (clk->ops->set_rate_and_parent &&
> +			!(clk->ops->set_parent && clk->ops->set_rate)) {
> +		pr_warning("%s: %s must implement .set_parent & 
.set_rate\n",
> +				__func__, clk->name);
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
>  	/* throw a WARN if any entries in parent_names are NULL */
>  	for (i = 0; i < clk->num_parents; i++)
>  		WARN(!clk->parent_names[i],
> diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
> index 484f8ad..1f7eabb 100644
> --- a/include/linux/clk-provider.h
> +++ b/include/linux/clk-provider.h
> @@ -108,6 +108,18 @@ struct clk_hw;
>   *		which is likely helpful for most .set_rate implementation.
>   *		Returns 0 on success, -EERROR otherwise.
>   *
> + * @set_rate_and_parent: Change the rate and the parent of this clock.
> The + *		requested rate is specified by the second 
argument, which +
> *		should typically be the return of .round_rate call.  The
> + *		third argument gives the parent rate which is likely 
helpful
> + *		for most .set_rate_and_parent implementation. The fourth
> + *		argument gives the parent index. It is optional (and
> + *		unnecessary) for clocks with 0 or 1 parents as well as
> + *		for clocks that can tolerate switching the rate and the 
parent
> + *		separately via calls to .set_parent and .set_rate.
> + *		Returns 0 on success, -EERROR otherwise.
> + *
> + *
>   * The clk_enable/clk_disable and clk_prepare/clk_unprepare pairs allow
> * implementations to split any work between atomic (enable) and
> sleepable * (prepare) contexts.  If enabling a clock requires code that
> might sleep, @@ -139,6 +151,9 @@ struct clk_ops {
>  	u8		(*get_parent)(struct clk_hw *hw);
>  	int		(*set_rate)(struct clk_hw *hw, unsigned long,
>  				    unsigned long);
> +	int		(*set_rate_and_parent)(struct clk_hw *hw,
> +				    unsigned long rate,
> +				    unsigned long parent_rate, u8 index);
>  	void		(*init)(struct clk_hw *hw);
>  };
