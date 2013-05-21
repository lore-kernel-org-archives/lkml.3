Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab3EUFK5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 01:10:57 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:36786 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab3EUFK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 01:10:56 -0400
X-IronPort-AV: E=Sophos;i="4.87,712,1363158000"; 
   d="scan'208";a="49062276"
Message-ID: <519B01DF.1080700@codeaurora.org>
Date: Mon, 20 May 2013 22:10:55 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: James Hogan <james.hogan@imgtec.com>
CC: Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/5] clk: add support for clock reparent on set_rate
References: <1369056507-32521-1-git-send-email-james.hogan@imgtec.com> <1369056507-32521-4-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1369056507-32521-4-git-send-email-james.hogan@imgtec.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2013 06:28 AM, James Hogan wrote:
> Add core support to allow clock implementations to select the best
> parent clock when rounding a rate, e.g. the one which can provide the
> closest clock rate to that requested. This is by way of adding a new
> clock op, determine_rate(), which is like round_rate() but has an extra
> parameter to allow the clock implementation to optionally select a
> different parent clock. The core then takes care of reparenting the
> clock when setting the rate.
>
> The parent change takes place with the help of some new private data
> members. struct clk::new_parent specifies a clock's new parent (NULL
> indicates no change), and struct clk::new_child specifies a clock's new
> child (whose new_parent member points back to it). The purpose of these
> are to allow correct walking of the future tree for notifications prior
> to actually reparenting any clocks, specifically to skip child clocks
> who are being reparented to another clock (they will be notified via the
> new parent), and to include any new child clock. These pointers are set
> by clk_calc_subtree(), and the new_child pointer gets cleared when a
> child is actually reparented to avoid duplicate POST_RATE_CHANGE
> notifications.
>
> Each place where round_rate() is called, determine_rate() is checked
> first and called in preference. This restructures a few of the call
> sites to simplify the logic into if/else blocks.
>
> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> Cc: Mike Turquette <mturquette@linaro.org>
> Cc: linux-arm-kernel@lists.infradead.org
> ---
> Changes in v4:
>
> * (not included Stephen Boyd's Reviewed-by due to changes)
> * replace __clk_set_parent_no_recalc with __clk_set_parent.
> * never pass NULL to determine_rate's best_parent_clk parameter, and
>    slight refactor of __clk_round_rate to use local copy of clk->parent.
> * a few new comments around use of clk::new_child.
>
> Changes in v3:
>
> * rebased on v3.10-rc1.
> * store new_parent_index in struct clk too (calculated from
>    clk_fetch_parent_index, and passed through __clk_set_parent_no_recalc
>    to __clk_set_parent).
> * allow determine_rate to satisfy recalc_rate check in __clk_init.
>
>   Documentation/clk.txt        |   4 ++
>   drivers/clk/clk.c            | 142 +++++++++++++++++++++++++++++--------------
>   include/linux/clk-private.h  |   3 +
>   include/linux/clk-provider.h |   7 +++
>   4 files changed, 110 insertions(+), 46 deletions(-)
>
> diff --git a/Documentation/clk.txt b/Documentation/clk.txt
> index b9911c2..3110ba4 100644
> --- a/Documentation/clk.txt
> +++ b/Documentation/clk.txt
> @@ -70,6 +70,10 @@ the operations defined in clk.h:
>   						unsigned long parent_rate);
>   		long		(*round_rate)(struct clk_hw *hw, unsigned long,
>   						unsigned long *);
> +		long		(*determine_rate)(struct clk_hw *hw,
> +						unsigned long rate,
> +						unsigned long *best_parent_rate,
> +						struct clk **best_parent_clk);
>   		int		(*set_parent)(struct clk_hw *hw, u8 index);
>   		u8		(*get_parent)(struct clk_hw *hw);
>   		int		(*set_rate)(struct clk_hw *hw, unsigned long);
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index a4cd6bc..3ce4810 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -888,21 +888,24 @@ EXPORT_SYMBOL_GPL(clk_enable);
>   unsigned long __clk_round_rate(struct clk *clk, unsigned long rate)
>   {
>   	unsigned long parent_rate = 0;
> +	struct clk *parent;
>
>   	if (!clk)
>   		return 0;
>
> -	if (!clk->ops->round_rate) {
> -		if (clk->flags & CLK_SET_RATE_PARENT)
> -			return __clk_round_rate(clk->parent, rate);
> -		else
> -			return clk->rate;
> -	}
> -
> -	if (clk->parent)
> -		parent_rate = clk->parent->rate;
> -
> -	return clk->ops->round_rate(clk->hw, rate, &parent_rate);
> +	parent = clk->parent;
> +	if (parent)
> +		parent_rate = parent->rate;
> +
> +	if (clk->ops->determine_rate)
> +		return clk->ops->determine_rate(clk->hw, rate, &parent_rate,
> +						&parent);
> +	else if (clk->ops->round_rate)
> +		return clk->ops->round_rate(clk->hw, rate, &parent_rate);
> +	else if (clk->flags & CLK_SET_RATE_PARENT)
> +		return __clk_round_rate(clk->parent, rate);
> +	else
> +		return clk->rate;
>   }
>
>   /**
> @@ -1055,6 +1058,10 @@ static u8 clk_fetch_parent_index(struct clk *clk, struct clk *parent)
>
>   static void clk_reparent(struct clk *clk, struct clk *new_parent)
>   {
> +	/* avoid duplicate POST_RATE_CHANGE notifications */
> +	if (new_parent->new_child == clk)
> +		new_parent->new_child = NULL;
> +
>   	hlist_del(&clk->child_node);
>
>   	if (new_parent)
> @@ -1173,18 +1180,25 @@ out:
>   	return ret;
>   }
>
> -static void clk_calc_subtree(struct clk *clk, unsigned long new_rate)
> +static void clk_calc_subtree(struct clk *clk, unsigned long new_rate,
> +			     struct clk *new_parent, u8 p_index)
>   {
>   	struct clk *child;
>
>   	clk->new_rate = new_rate;
> +	clk->new_parent = new_parent;
> +	clk->new_parent_index = p_index;
> +	/* include clk in new parent's PRE_RATE_CHANGE notifications */
> +	clk->new_child = NULL;
> +	if (new_parent && new_parent != clk->parent)
> +		new_parent->new_child = clk;
>
>   	hlist_for_each_entry(child, &clk->children, child_node) {
>   		if (child->ops->recalc_rate)
>   			child->new_rate = child->ops->recalc_rate(child->hw, new_rate);
>   		else
>   			child->new_rate = new_rate;
> -		clk_calc_subtree(child, child->new_rate);
> +		clk_calc_subtree(child, child->new_rate, NULL, 0);
>   	}
>   }
>
> @@ -1195,50 +1209,63 @@ static void clk_calc_subtree(struct clk *clk, unsigned long new_rate)
>   static struct clk *clk_calc_new_rates(struct clk *clk, unsigned long rate)
>   {
>   	struct clk *top = clk;
> +	struct clk *old_parent, *parent;
>   	unsigned long best_parent_rate = 0;
>   	unsigned long new_rate;
> +	u8 p_index = 0;
>
>   	/* sanity */
>   	if (IS_ERR_OR_NULL(clk))
>   		return NULL;
>
>   	/* save parent rate, if it exists */
> -	if (clk->parent)
> -		best_parent_rate = clk->parent->rate;
> -
> -	/* never propagate up to the parent */
> -	if (!(clk->flags & CLK_SET_RATE_PARENT)) {
> -		if (!clk->ops->round_rate) {
> -			clk->new_rate = clk->rate;
> -			return NULL;
> -		}
> -		new_rate = clk->ops->round_rate(clk->hw, rate, &best_parent_rate);
> +	parent = old_parent = clk->parent;
> +	if (parent)
> +		best_parent_rate = parent->rate;
> +
> +	/* find the closest rate and parent clk/rate */
> +	if (clk->ops->determine_rate) {
> +		new_rate = clk->ops->determine_rate(clk->hw, rate,
> +						    &best_parent_rate,
> +						    &parent);
> +	} else if (clk->ops->round_rate) {
> +		new_rate = clk->ops->round_rate(clk->hw, rate,
> +						&best_parent_rate);
> +	} else if (!parent || !(clk->flags & CLK_SET_RATE_PARENT)) {
> +		/* pass-through clock without adjustable parent */
> +		clk->new_rate = clk->rate;
> +		return NULL;
> +	} else {
> +		/* pass-through clock with adjustable parent */
> +		top = clk_calc_new_rates(parent, rate);
> +		new_rate = parent->new_rate;
>   		goto out;
>   	}
>
> -	/* need clk->parent from here on out */
> -	if (!clk->parent) {
> -		pr_debug("%s: %s has NULL parent\n", __func__, clk->name);
> +	/* some clocks must be gated to change parent */
> +	if (parent != old_parent &&
> +	    (clk->flags & CLK_SET_PARENT_GATE) && clk->prepare_count) {
> +		pr_debug("%s: %s not gated but wants to reparent\n",
> +			 __func__, clk->name);
>   		return NULL;
>   	}
>
> -	if (!clk->ops->round_rate) {
> -		top = clk_calc_new_rates(clk->parent, rate);
> -		new_rate = clk->parent->new_rate;
> -
> -		goto out;
> +	/* try finding the new parent index */
> +	if (parent) {
> +		p_index = clk_fetch_parent_index(clk, parent);
> +		if (p_index == clk->num_parents) {
> +			pr_debug("%s: clk %s can not be parent of clk %s\n",
> +				 __func__, parent->name, clk->name);
> +			return NULL;
> +		}
>   	}
>
> -	new_rate = clk->ops->round_rate(clk->hw, rate, &best_parent_rate);
> -
> -	if (best_parent_rate != clk->parent->rate) {
> -		top = clk_calc_new_rates(clk->parent, best_parent_rate);
> -
> -		goto out;
> -	}
> +	if ((clk->flags & CLK_SET_RATE_PARENT) && parent &&
> +	    best_parent_rate != parent->rate)
> +		top = clk_calc_new_rates(parent, best_parent_rate);
>
>   out:
> -	clk_calc_subtree(clk, new_rate);
> +	clk_calc_subtree(clk, new_rate, parent, p_index);
>
>   	return top;
>   }
> @@ -1250,7 +1277,7 @@ out:
>    */
>   static struct clk *clk_propagate_rate_change(struct clk *clk, unsigned long event)
>   {
> -	struct clk *child, *fail_clk = NULL;
> +	struct clk *child, *tmp_clk, *fail_clk = NULL;
>   	int ret = NOTIFY_DONE;
>
>   	if (clk->rate == clk->new_rate)
> @@ -1263,9 +1290,19 @@ static struct clk *clk_propagate_rate_change(struct clk *clk, unsigned long even
>   	}
>
>   	hlist_for_each_entry(child, &clk->children, child_node) {
> -		clk = clk_propagate_rate_change(child, event);
> -		if (clk)
> -			fail_clk = clk;
> +		/* Skip children who will be reparented to another clock */
> +		if (child->new_parent && child->new_parent != clk)
> +			continue;
> +		tmp_clk = clk_propagate_rate_change(child, event);
> +		if (tmp_clk)
> +			fail_clk = tmp_clk;
> +	}
> +
> +	/* handle the new child who might not be in clk->children yet */
> +	if (clk->new_child) {
> +		tmp_clk = clk_propagate_rate_change(clk->new_child, event);
> +		if (tmp_clk)
> +			fail_clk = tmp_clk;
>   	}
>
>   	return fail_clk;
> @@ -1283,6 +1320,10 @@ static void clk_change_rate(struct clk *clk)
>
>   	old_rate = clk->rate;
>
> +	/* set parent */
> +	if (clk->new_parent && clk->new_parent != clk->parent)
> +		__clk_set_parent(clk, clk->new_parent, clk->new_parent_index);
> +
>   	if (clk->parent)
>   		best_parent_rate = clk->parent->rate;
>
> @@ -1297,8 +1338,16 @@ static void clk_change_rate(struct clk *clk)
>   	if (clk->notifier_count && old_rate != clk->rate)
>   		__clk_notify(clk, POST_RATE_CHANGE, old_rate, clk->rate);
>
> -	hlist_for_each_entry(child, &clk->children, child_node)
> +	hlist_for_each_entry(child, &clk->children, child_node) {
> +		/* Skip children who will be reparented to another clock */
> +		if (child->new_parent && child->new_parent != clk)
> +			continue;
>   		clk_change_rate(child);
> +	}
> +
> +	/* handle the new child who might not be in clk->children yet */
> +	if (clk->new_child)
> +		clk_change_rate(clk->new_child);
>   }
>
>   /**
> @@ -1545,8 +1594,9 @@ int __clk_init(struct device *dev, struct clk *clk)
>
>   	/* check that clk_ops are sane.  See Documentation/clk.txt */
>   	if (clk->ops->set_rate &&
> -			!(clk->ops->round_rate && clk->ops->recalc_rate)) {
> -		pr_warning("%s: %s must implement .round_rate & .recalc_rate\n",
> +	    !((clk->ops->round_rate || clk->ops->determine_rate) &&
> +	      clk->ops->recalc_rate)) {
> +		pr_warning("%s: %s must implement .round_rate or .determine_rate in addition to .recalc_rate\n",
>   				__func__, clk->name);
>   		ret = -EINVAL;
>   		goto out;
> diff --git a/include/linux/clk-private.h b/include/linux/clk-private.h
> index dd7adff..8138c94 100644
> --- a/include/linux/clk-private.h
> +++ b/include/linux/clk-private.h
> @@ -33,8 +33,11 @@ struct clk {
>   	const char		**parent_names;
>   	struct clk		**parents;
>   	u8			num_parents;
> +	u8			new_parent_index;

Why do you need this? Given the new_parent, can't the specific clock 
implementation just look it up when set_rate() is called? Wouldn't that 
be the only time you would actually need the index?

If it's just for optimization of some error cases, I think we should 
drop this to keep the code simpler. One less state to keep track of when 
reading, writing or reviewing the clock framework.

I would like to do a more thorough review of this patch, but it's been a 
while since I have looked at clk.c. So, I might not be able to do it 
soon enough. But I can't ask to hold off this patch just because I don't 
have time. So, I'll see what I can do.

-Saravana




-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
