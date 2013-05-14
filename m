Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757638Ab3ENSNY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 14:13:24 -0400
Received: from mail-da0-f53.google.com ([209.85.210.53]:36870 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755469Ab3ENSNW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 14:13:22 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: James Hogan <james.hogan@imgtec.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1366388904-13903-3-git-send-email-james.hogan@imgtec.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>, James Hogan <james.hogan@imgtec.com>
References: <1366388904-13903-1-git-send-email-james.hogan@imgtec.com>
 <1366388904-13903-3-git-send-email-james.hogan@imgtec.com>
Message-ID: <20130514181318.10068.79002@quantum>
User-Agent: alot/0.3.4
Subject: Re: [PATCH v2 2/3] clk: add support for clock reparent on set_rate
Date: Tue, 14 May 2013 11:13:18 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting James Hogan (2013-04-19 09:28:23)
> Add core support to allow clock implementations to select the best
> parent clock when rounding a rate, e.g. the one which can provide the
> closest clock rate to that requested. This is by way of adding a new
> clock op, determine_rate(), which is like round_rate() but has an extra
> parameter to allow the clock implementation to optionally select a
> different parent clock. The core then takes care of reparenting the
> clock when setting the rate.
> 

Hi James,

Can you rebase this onto -rc1?  It does not apply cleanly.

Thanks,
Mike

> The parent change takes place with the help of two new private data
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
> Each place where round_rate() is called, determine_rate is checked first
> and called in preference, passing NULL to the new parent argument if not
> needed (e.g. in __clk_round_rate). This restructures a few of the call
> sites to simplify the logic into if/else blocks.
> 
> A new __clk_set_parent_no_recalc() is created similar to
> clk_set_parent() but without calling __clk_recalc_rates(). This is for
> clk_change_rate() to use, where rate recalculation and notifications are
> already handled.
> 
> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> ---
>  Documentation/clk.txt        |   4 ++
>  drivers/clk/clk.c            | 146 ++++++++++++++++++++++++++++++-------------
>  include/linux/clk-private.h  |   2 +
>  include/linux/clk-provider.h |   7 +++
>  4 files changed, 116 insertions(+), 43 deletions(-)
> 
> diff --git a/Documentation/clk.txt b/Documentation/clk.txt
> index 1943fae..502c033 100644
> --- a/Documentation/clk.txt
> +++ b/Documentation/clk.txt
> @@ -70,6 +70,10 @@ the operations defined in clk.h:
>                                                 unsigned long parent_rate);
>                 long            (*round_rate)(struct clk_hw *hw, unsigned long,
>                                                 unsigned long *);
> +               long            (*determine_rate)(struct clk_hw *hw,
> +                                               unsigned long rate,
> +                                               unsigned long *best_parent_rate,
> +                                               struct clk **best_parent_clk);
>                 int             (*set_parent)(struct clk_hw *hw, u8 index);
>                 u8              (*get_parent)(struct clk_hw *hw);
>                 int             (*set_rate)(struct clk_hw *hw, unsigned long);
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index 79d5deb..cc0e618 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -27,6 +27,8 @@ static HLIST_HEAD(clk_root_list);
>  static HLIST_HEAD(clk_orphan_list);
>  static LIST_HEAD(clk_notifier_list);
>  
> +static int __clk_set_parent_no_recalc(struct clk *clk, struct clk *parent);
> +
>  /***        debugfs support        ***/
>  
>  #ifdef CONFIG_COMMON_CLK_DEBUG
> @@ -727,17 +729,20 @@ unsigned long __clk_round_rate(struct clk *clk, unsigned long rate)
>         if (!clk)
>                 return 0;
>  
> -       if (!clk->ops->round_rate) {
> -               if (clk->flags & CLK_SET_RATE_PARENT)
> -                       return __clk_round_rate(clk->parent, rate);
> -               else
> -                       return clk->rate;
> -       }
>  
>         if (clk->parent)
>                 parent_rate = clk->parent->rate;
>  
> -       return clk->ops->round_rate(clk->hw, rate, &parent_rate);
> +       if (clk->ops->determine_rate)
> +               return clk->ops->determine_rate(clk->hw, rate, &parent_rate,
> +                                               NULL);
> +       else if (clk->ops->round_rate)
> +               return clk->ops->round_rate(clk->hw, rate, &parent_rate);
> +       else if (clk->flags & CLK_SET_RATE_PARENT)
> +               return __clk_round_rate(clk->parent, rate);
> +       else
> +               return clk->rate;
> +
>  }
>  
>  /**
> @@ -906,18 +911,23 @@ out:
>         return ret;
>  }
>  
> -static void clk_calc_subtree(struct clk *clk, unsigned long new_rate)
> +static void clk_calc_subtree(struct clk *clk, unsigned long new_rate,
> +                            struct clk *new_parent)
>  {
>         struct clk *child;
>  
>         clk->new_rate = new_rate;
> +       clk->new_parent = new_parent;
> +       clk->new_child = NULL;
> +       if (new_parent && new_parent != clk->parent)
> +               new_parent->new_child = clk;
>  
>         hlist_for_each_entry(child, &clk->children, child_node) {
>                 if (child->ops->recalc_rate)
>                         child->new_rate = child->ops->recalc_rate(child->hw, new_rate);
>                 else
>                         child->new_rate = new_rate;
> -               clk_calc_subtree(child, child->new_rate);
> +               clk_calc_subtree(child, child->new_rate, NULL);
>         }
>  }
>  
> @@ -928,6 +938,7 @@ static void clk_calc_subtree(struct clk *clk, unsigned long new_rate)
>  static struct clk *clk_calc_new_rates(struct clk *clk, unsigned long rate)
>  {
>         struct clk *top = clk;
> +       struct clk *old_parent, *parent;
>         unsigned long best_parent_rate = 0;
>         unsigned long new_rate;
>  
> @@ -936,42 +947,43 @@ static struct clk *clk_calc_new_rates(struct clk *clk, unsigned long rate)
>                 return NULL;
>  
>         /* save parent rate, if it exists */
> -       if (clk->parent)
> -               best_parent_rate = clk->parent->rate;
> -
> -       /* never propagate up to the parent */
> -       if (!(clk->flags & CLK_SET_RATE_PARENT)) {
> -               if (!clk->ops->round_rate) {
> -                       clk->new_rate = clk->rate;
> -                       return NULL;
> -               }
> -               new_rate = clk->ops->round_rate(clk->hw, rate, &best_parent_rate);
> +       parent = old_parent = clk->parent;
> +       if (parent)
> +               best_parent_rate = parent->rate;
> +
> +       /* find the closest rate and parent clk/rate */
> +       if (clk->ops->determine_rate) {
> +               new_rate = clk->ops->determine_rate(clk->hw, rate,
> +                                                   &best_parent_rate,
> +                                                   &parent);
> +       } else if (clk->ops->round_rate) {
> +               new_rate = clk->ops->round_rate(clk->hw, rate,
> +                                               &best_parent_rate);
> +       } else if (!parent || !(clk->flags & CLK_SET_RATE_PARENT)) {
> +               /* pass-through clock without adjustable parent */
> +               clk->new_rate = clk->rate;
> +               return NULL;
> +       } else {
> +               /* pass-through clock with adjustable parent */
> +               top = clk_calc_new_rates(parent, rate);
> +               new_rate = parent->new_rate;
>                 goto out;
>         }
>  
> -       /* need clk->parent from here on out */
> -       if (!clk->parent) {
> -               pr_debug("%s: %s has NULL parent\n", __func__, clk->name);
> +       /* some clocks must be gated to change parent */
> +       if (parent != old_parent &&
> +           (clk->flags & CLK_SET_PARENT_GATE) && clk->prepare_count) {
> +               pr_debug("%s: %s not gated but wants to reparent\n",
> +                        __func__, clk->name);
>                 return NULL;
>         }
>  
> -       if (!clk->ops->round_rate) {
> -               top = clk_calc_new_rates(clk->parent, rate);
> -               new_rate = clk->parent->new_rate;
> -
> -               goto out;
> -       }
> -
> -       new_rate = clk->ops->round_rate(clk->hw, rate, &best_parent_rate);
> -
> -       if (best_parent_rate != clk->parent->rate) {
> -               top = clk_calc_new_rates(clk->parent, best_parent_rate);
> -
> -               goto out;
> -       }
> +       if ((clk->flags & CLK_SET_RATE_PARENT) && parent &&
> +           best_parent_rate != parent->rate)
> +               top = clk_calc_new_rates(parent, best_parent_rate);
>  
>  out:
> -       clk_calc_subtree(clk, new_rate);
> +       clk_calc_subtree(clk, new_rate, parent);
>  
>         return top;
>  }
> @@ -983,7 +995,7 @@ out:
>   */
>  static struct clk *clk_propagate_rate_change(struct clk *clk, unsigned long event)
>  {
> -       struct clk *child, *fail_clk = NULL;
> +       struct clk *child, *tmp_clk, *fail_clk = NULL;
>         int ret = NOTIFY_DONE;
>  
>         if (clk->rate == clk->new_rate)
> @@ -996,9 +1008,19 @@ static struct clk *clk_propagate_rate_change(struct clk *clk, unsigned long even
>         }
>  
>         hlist_for_each_entry(child, &clk->children, child_node) {
> -               clk = clk_propagate_rate_change(child, event);
> -               if (clk)
> -                       fail_clk = clk;
> +               /* Skip children who will be reparented to another clock */
> +               if (child->new_parent && child->new_parent != clk)
> +                       continue;
> +               tmp_clk = clk_propagate_rate_change(child, event);
> +               if (tmp_clk)
> +                       fail_clk = tmp_clk;
> +       }
> +
> +       /* handle the new child who might not be in clk->children yet */
> +       if (clk->new_child) {
> +               tmp_clk = clk_propagate_rate_change(clk->new_child, event);
> +               if (tmp_clk)
> +                       fail_clk = tmp_clk;
>         }
>  
>         return fail_clk;
> @@ -1016,6 +1038,10 @@ static void clk_change_rate(struct clk *clk)
>  
>         old_rate = clk->rate;
>  
> +       /* set parent */
> +       if (clk->new_parent && clk->new_parent != clk->parent)
> +               __clk_set_parent_no_recalc(clk, clk->new_parent);
> +
>         if (clk->parent)
>                 best_parent_rate = clk->parent->rate;
>  
> @@ -1030,8 +1056,15 @@ static void clk_change_rate(struct clk *clk)
>         if (clk->notifier_count && old_rate != clk->rate)
>                 __clk_notify(clk, POST_RATE_CHANGE, old_rate, clk->rate);
>  
> -       hlist_for_each_entry(child, &clk->children, child_node)
> +       hlist_for_each_entry(child, &clk->children, child_node) {
> +               /* Skip children who will be reparented to another clock */
> +               if (child->new_parent && child->new_parent != clk)
> +                       continue;
>                 clk_change_rate(child);
> +       }
> +
> +       if (clk->new_child)
> +               clk_change_rate(clk->new_child);
>  }
>  
>  /**
> @@ -1169,7 +1202,7 @@ out:
>         return ret;
>  }
>  
> -void __clk_reparent(struct clk *clk, struct clk *new_parent)
> +void __clk_reparent_no_recalc(struct clk *clk, struct clk *new_parent)
>  {
>  #ifdef CONFIG_COMMON_CLK_DEBUG
>         struct dentry *d;
> @@ -1179,6 +1212,9 @@ void __clk_reparent(struct clk *clk, struct clk *new_parent)
>         if (!clk || !new_parent)
>                 return;
>  
> +       if (new_parent->new_child == clk)
> +               new_parent->new_child = NULL;
> +
>         hlist_del(&clk->child_node);
>  
>         if (new_parent)
> @@ -1206,6 +1242,11 @@ out:
>  #endif
>  
>         clk->parent = new_parent;
> +}
> +
> +void __clk_reparent(struct clk *clk, struct clk *new_parent)
> +{
> +       __clk_reparent_no_recalc(clk, new_parent);
>  
>         __clk_recalc_rates(clk, POST_RATE_CHANGE);
>  }
> @@ -1270,6 +1311,25 @@ out:
>         return ret;
>  }
>  
> +static int __clk_set_parent_no_recalc(struct clk *clk, struct clk *parent)
> +{
> +       int ret = 0;
> +
> +       if (clk->parent == parent)
> +               goto out;
> +
> +       /* only re-parent if the clock is not in use */
> +       ret = __clk_set_parent(clk, parent);
> +       if (ret)
> +               goto out;
> +
> +       /* reparent, but don't propagate rate recalculation downstream */
> +       __clk_reparent_no_recalc(clk, parent);
> +
> +out:
> +       return ret;
> +}
> +
>  /**
>   * clk_set_parent - switch the parent of a mux clk
>   * @clk: the mux clk whose input we are switching
> diff --git a/include/linux/clk-private.h b/include/linux/clk-private.h
> index 9c7f580..0826a60 100644
> --- a/include/linux/clk-private.h
> +++ b/include/linux/clk-private.h
> @@ -35,6 +35,8 @@ struct clk {
>         u8                      num_parents;
>         unsigned long           rate;
>         unsigned long           new_rate;
> +       struct clk              *new_parent;
> +       struct clk              *new_child;
>         unsigned long           flags;
>         unsigned int            enable_count;
>         unsigned int            prepare_count;
> diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
> index 4e0b634..5fe1d38 100644
> --- a/include/linux/clk-provider.h
> +++ b/include/linux/clk-provider.h
> @@ -71,6 +71,10 @@ struct clk_hw;
>   * @round_rate:        Given a target rate as input, returns the closest rate actually
>   *             supported by the clock.
>   *
> + * @determine_rate: Given a target rate as input, returns the closest rate
> + *             actually supported by the clock, and optionally the parent clock
> + *             that should be used to provide the clock rate.
> + *
>   * @get_parent:        Queries the hardware to determine the parent of a clock.  The
>   *             return value is a u8 which specifies the index corresponding to
>   *             the parent clock.  This index can be applied to either the
> @@ -116,6 +120,9 @@ struct clk_ops {
>                                         unsigned long parent_rate);
>         long            (*round_rate)(struct clk_hw *hw, unsigned long,
>                                         unsigned long *);
> +       long            (*determine_rate)(struct clk_hw *hw, unsigned long rate,
> +                                       unsigned long *best_parent_rate,
> +                                       struct clk **best_parent_clk);
>         int             (*set_parent)(struct clk_hw *hw, u8 index);
>         u8              (*get_parent)(struct clk_hw *hw);
>         int             (*set_rate)(struct clk_hw *hw, unsigned long,
> -- 
> 1.8.1.2
