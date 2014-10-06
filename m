Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851AbaJFROd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 13:14:33 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:53971 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbaJFROb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 13:14:31 -0400
MIME-Version: 1.0
In-Reply-To: <20141003231515.GM10233@codeaurora.org>
References: <1412255097-15928-1-git-send-email-tomeu.vizoso@collabora.com>
 <1412255097-15928-2-git-send-email-tomeu.vizoso@collabora.com> <20141003231515.GM10233@codeaurora.org>
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Date: Mon, 6 Oct 2014 19:14:10 +0200
X-Google-Sender-Auth: lO6EI3nE1fdD4ZyyUNtmIbqGmvs
Message-ID: <CAAObsKDa=ia3Gbu1WkoUBjXt2GCoysK7rv=3PzLarnfS7K5ZLA@mail.gmail.com>
Subject: Re: [PATCH 1/2] clk: Make clk API return per-user struct clk instances
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>, Paul Walmsley <paul@pwsan.com>,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 October 2014 01:15, Stephen Boyd <sboyd@codeaurora.org> wrote:
> On 10/02, Tomeu Vizoso wrote:
>> Moves clock state to struct clk_core, but takes care to change as little API as
>> possible.
>>
>> struct clk_hw still has a pointer to a struct clk, which is the
>> implementation's per-user clk instance, for backwards compatibility.
>>
>> The struct clk that clk_get_parent() returns isn't owned by the caller, but by
>> the clock implementation, so the former shouldn't call clk_put() on it.
>>
>> Because some boards in mach-omap2 still register clocks statically, their clock
>> registration had to be updated to take into account that the clock information
>> is stored in struct clk_core now.
>>
>> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
>> ---
>
>
> We should s/provider/core/ when we're dealing with clk_core
> structures in the function signature. The providers are hardware
> drivers and the core structures are for the framework, not the
> same. Furthermore, the provider drivers should only be dealing
> with clk_hw structures. The only place that clk_core should be in
> clk-provider.h is in struct clk_hw because there's no way to get
> around it.
>
> This way, provider drivers should only be including
> clk-provider.h because they only care about dealing with struct
> clk_hw. Consumers should only be including linux/clk.h where they
> only know about struct clk as an opaque pointer. Once we get OMAP
> to stop using clk-private.h we can kill off that header entirely
> (I see there are some other bogus users of that header outside of
> OMAP that we should nuke). Then the framework can include
> clk-provider.h and clk.h to map between the hw cookie and the
> consumer cookie.

Agreed.

> This is the end goal. I understand that the provider API is sort
> of a mess with us allowing drivers to use the underscore and
> non-underscore functions and the mixture of struct clk and struct
> ckl_hw throughout.
>
>  struct clk_hw <--> struct clk_core <----> struct clk
>                                        \-> struct clk
>                                        |-> struct clk

Agree this is how it should look like at some point, but for now I
need a reference to struct clk from struct clk_hw, so providers can
keep using the existing API. This reference would be removed once they
move to the new clk_hw-based API.

>  providers
>  ---------
>  struct clk_hw {
>         struct clk_core *
>         ...
>  };
>
>  consumers
>  ---------
>
>  struct clk;
>
>  hidden in core framework
>  ------------------------
>  struct clk {
>         struct clk_core *;
>         ...
>  }
>
>  struct clk_core {
>         struct clk_hw *;
>         ...
>  }
>
>
>>
>> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
>> index 4eeb8de..b216b13 100644
>> --- a/drivers/clk/clk.c
>> +++ b/drivers/clk/clk.c
>> @@ -37,6 +37,13 @@ static HLIST_HEAD(clk_root_list);
>>  static HLIST_HEAD(clk_orphan_list);
>>  static LIST_HEAD(clk_notifier_list);
>>
>> +static void clk_provider_put(struct clk_core *clk);
>
> Does this need to be forward declared?

No, removed.

>> +static long clk_provider_get_accuracy(struct clk_core *clk);
>> +static bool clk_provider_is_prepared(struct clk_core *clk);
>> +static bool clk_provider_is_enabled(struct clk_core *clk);
>> +static long clk_provider_round_rate(struct clk_core *clk, unsigned long rate);
>> @@ -356,7 +363,7 @@ out:
>>   *
>>   * Caller must hold prepare_lock.
>>   */
>> -static void clk_debug_unregister(struct clk *clk)
>> +static void clk_debug_unregister(struct clk_core *clk)
>>  {
>>       debugfs_remove_recursive(clk->dentry);
>>  }
>> @@ -366,8 +373,8 @@ struct dentry *clk_debugfs_add_file(struct clk *clk, char *name, umode_t mode,
>
> We should pass struct clk_hw here instead of struct clk. Let's do
> it soon before we get any users.

Sounds good to me.

>>  {
>>       struct dentry *d = NULL;
>>
>> -     if (clk->dentry)
>> -             d = debugfs_create_file(name, mode, clk->dentry, data, fops);
>> +     if (clk->core->dentry)
>> +             d = debugfs_create_file(name, mode, clk->core->dentry, data, fops);
>>
>>       return d;
>>  }
>> @@ -545,53 +553,67 @@ late_initcall_sync(clk_disable_unused);
>>
>>  const char *__clk_get_name(struct clk *clk)
>>  {
>> -     return !clk ? NULL : clk->name;
>> +     return !clk ? NULL : clk->core->name;
>>  }
>>  EXPORT_SYMBOL_GPL(__clk_get_name);
>>
>>  struct clk_hw *__clk_get_hw(struct clk *clk)
>>  {
>> -     return !clk ? NULL : clk->hw;
>> +     return !clk ? NULL : clk->core->hw;
>>  }
>>  EXPORT_SYMBOL_GPL(__clk_get_hw);
>>
>>  u8 __clk_get_num_parents(struct clk *clk)
>>  {
>> -     return !clk ? 0 : clk->num_parents;
>> +     return !clk ? 0 : clk->core->num_parents;
>>  }
>>  EXPORT_SYMBOL_GPL(__clk_get_num_parents);
>>
>>  struct clk *__clk_get_parent(struct clk *clk)
>>  {
>> -     return !clk ? NULL : clk->parent;
>> +     /* TODO: Create a per-user clk and change callers to call clk_put */
>
> More like replace all callers with a function that returns their
> parent's hw pointer.

Sounds good, but I thought about it and have chosen to just remove the comment.

>         struct clk_hw *clk_provider_get_parent(struct clk_hw *hw)
>
>
>> +     return !clk ? NULL : clk->core->parent->hw->clk;
>>  }
>>  EXPORT_SYMBOL_GPL(__clk_get_parent);
>>
>> -struct clk *clk_get_parent_by_index(struct clk *clk, u8 index)
>> +static struct clk_core *clk_provider_get_parent_by_index(struct clk_core *clk,
>> +                                                      u8 index)
>>  {
>>       if (!clk || index >= clk->num_parents)
>>               return NULL;
>>       else if (!clk->parents)
>> -             return __clk_lookup(clk->parent_names[index]);
>> +             return clk_provider_lookup(clk->parent_names[index]);
>>       else if (!clk->parents[index])
>>               return clk->parents[index] =
>> -                     __clk_lookup(clk->parent_names[index]);
>> +                     clk_provider_lookup(clk->parent_names[index]);
>>       else
>>               return clk->parents[index];
>>  }
>> +
>> +struct clk *clk_get_parent_by_index(struct clk *clk, u8 index)
>> +{
>> +     struct clk_core *parent;
>> +
>> +     parent = clk_provider_get_parent_by_index(clk->core, index);
>> +     if (IS_ERR(parent))
>> +             return (void *)parent;
>
> What is this for? Does it actually happen that we have error
> pointers here?

No, have simplified it.

>> +
>> +     /* TODO: Create a per-user clk and change callers to call clk_put */
>> +     return parent->hw->clk;
>> +}
>>  EXPORT_SYMBOL_GPL(clk_get_parent_by_index);
>>
>>  unsigned int __clk_get_enable_count(struct clk *clk)
>>  {
>> -     return !clk ? 0 : clk->enable_count;
>> +     return !clk ? 0 : clk->core->enable_count;
>>  }
>>
>>  unsigned int __clk_get_prepare_count(struct clk *clk)
>>  {
>> -     return !clk ? 0 : clk->prepare_count;
>> +     return !clk ? 0 : clk->core->prepare_count;
>>  }
>
> This function isn't even used. Maybe we should remove it.

Have just gone ahead with your suggestion.

>>
>> -unsigned long __clk_get_rate(struct clk *clk)
>> +static unsigned long clk_provider_get_rate_nolock(struct clk_core *clk)
>>  {
>>       unsigned long ret;
>>
>> @@ -1612,11 +1722,11 @@ EXPORT_SYMBOL_GPL(clk_get_parent);
>>   *
>>   * For single-parent clocks without .get_parent, first check to see if the
>>   * .parents array exists, and if so use it to avoid an expensive tree
>> - * traversal.  If .parents does not exist then walk the tree with __clk_lookup.
>> + * traversal.  If .parents does not exist then walk the tree with clk_provider_lookup.
>
> Maybe just remove the function name entirely so we don't have to
> keep updating something that's obvious from the code.

Sounds good.

>>   */
>> -static struct clk *__clk_init_parent(struct clk *clk)
>> +static struct clk_core *__clk_init_parent(struct clk_core *clk)
>>  {
>> -     struct clk *ret = NULL;
>> +     struct clk_core *ret = NULL;
>>       u8 index;
>>
>>       /* handle the trivial cases */
>> @@ -1626,7 +1736,7 @@ static struct clk *__clk_init_parent(struct clk *clk)
>>
>>       if (clk->num_parents == 1) {
>>               if (IS_ERR_OR_NULL(clk->parent))
>> -                     ret = clk->parent = __clk_lookup(clk->parent_names[0]);
>> +                     ret = clk->parent = clk_provider_lookup(clk->parent_names[0]);
>>               ret = clk->parent;
>>               goto out;
>>       }
>> @@ -1640,7 +1750,7 @@ static struct clk *__clk_init_parent(struct clk *clk)
>>
>>       /*
>>        * Do our best to cache parent clocks in clk->parents.  This prevents
>> -      * unnecessary and expensive calls to __clk_lookup.  We don't set
>> +      * unnecessary and expensive calls to clk_provider_lookup.  We don't set
>
> Ditto.
>
>>        * clk->parent here; that is done by the calling function
>>        */
>>
>> @@ -2306,7 +2438,7 @@ int clk_notifier_unregister(struct clk *clk, struct notifier_block *nb)
>>       if (cn->clk == clk) {
>>               ret = srcu_notifier_chain_unregister(&cn->notifier_head, nb);
>>
>> -             clk->notifier_count--;
>> +             clk->core->notifier_count--;
>>
>>               /* XXX the notifier code should handle this better */
>>               if (!cn->notifier_head.head) {
>> @@ -2325,6 +2457,31 @@ int clk_notifier_unregister(struct clk *clk, struct notifier_block *nb)
>>  }
>>  EXPORT_SYMBOL_GPL(clk_notifier_unregister);
>>
>> +struct clk *__clk_create_clk(struct clk_core *clk_core, const char *dev_id,
>
> This should take clk_hw instead of clk_core.

Nod.

>> +                          const char *con_id)
>> +{
>> +     struct clk *clk;
>> +
>> +     /* This is to allow this function to be chained to others */
>> +     if (!clk_core || IS_ERR(clk_core))
>> +             return (struct clk *) clk_core;
>> +
>> +     clk = kzalloc(sizeof(*clk), GFP_KERNEL);
>> +     if (!clk)
>> +             return ERR_PTR(-ENOMEM);
>> +
>> +     clk->core = clk_core;
>> +     clk->dev_id = dev_id;
>> +     clk->con_id = con_id;
>> +
>> +     return clk;
>> +}
>> +
>> +
>>  #ifdef CONFIG_OF
>>  /**
>>   * struct of_clk_provider - Clock provider registration structure
>> diff --git a/drivers/clk/clk.h b/drivers/clk/clk.h
>> index c798138..4a17902 100644
>> --- a/drivers/clk/clk.h
>> +++ b/drivers/clk/clk.h
>> @@ -9,9 +9,16 @@
>>   * published by the Free Software Foundation.
>>   */
>>
>> +#include <linux/clk-private.h>
>
> Ah, please no. Why do we need this?

Not needed any more.

>> +
>>  #if defined(CONFIG_OF) && defined(CONFIG_COMMON_CLK)
>
> These ifdefs look useless.
>
>>  struct clk *of_clk_get_by_clkspec(struct of_phandle_args *clkspec);
>>  struct clk *__of_clk_get_from_provider(struct of_phandle_args *clkspec);
>>  void of_clk_lock(void);
>>  void of_clk_unlock(void);
>>  #endif
>> +
>> +#if defined(CONFIG_COMMON_CLK)
>
> So we shouldn't need this one either.

Fine.

>> +struct clk *__clk_create_clk(struct clk_core *clk_core, const char *dev_id,
>> +                          const char *con_id);
>> +#endif
>> diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
>> index da4bda8..fe3712f 100644
>> --- a/drivers/clk/clkdev.c
>> +++ b/drivers/clk/clkdev.c
>> @@ -168,14 +172,27 @@ static struct clk_lookup *clk_find(const char *dev_id, const char *con_id)
>>  struct clk *clk_get_sys(const char *dev_id, const char *con_id)
>>  {
>>       struct clk_lookup *cl;
>> +     struct clk *clk = NULL;
>>
>>       mutex_lock(&clocks_mutex);
>>       cl = clk_find(dev_id, con_id);
>> -     if (cl && !__clk_get(cl->clk))
>> -             cl = NULL;
>> +     if (cl) {
>> +#if defined(CONFIG_COMMON_CLK)
>> +             clk = __clk_create_clk(cl->clk->core, dev_id, con_id);
>> +             if (clk && !__clk_get(clk)) {
>> +                     kfree(clk);
>
> This looks weird. It makes me suspect we've failed to reference
> count something properly. Can we avoid this?

Can you extend on this? But I see how the behaviour doesn't match the
previous one because cl should be NULLed when __clk_get fails. I have
fixed this.

>> +                     clk = NULL;
>> +             }
>> +#else
>> +             if (!__clk_get(cl->clk))
>> +                     cl = NULL;
>> +             else
>> +                     clk = cl->clk;
>> +#endif
>> +     }
>>       mutex_unlock(&clocks_mutex);
>>
>> -     return cl ? cl->clk : ERR_PTR(-ENOENT);
>> +     return cl ? clk : ERR_PTR(-ENOENT);
>>  }
>>  EXPORT_SYMBOL(clk_get_sys);
>>
>> diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
>> index 411dd7e..8fd6320 100644
>> --- a/include/linux/clk-provider.h
>> +++ b/include/linux/clk-provider.h
>> @@ -514,7 +519,7 @@ struct clk *clk_get_parent_by_index(struct clk *clk, u8 index);
>>  unsigned int __clk_get_enable_count(struct clk *clk);
>>  unsigned int __clk_get_prepare_count(struct clk *clk);
>>  unsigned long __clk_get_rate(struct clk *clk);
>> -unsigned long __clk_get_accuracy(struct clk *clk);
>> +unsigned long __clk_get_accuracy(struct clk_core *clk);
>
> Oops. Maybe we can just delete this one given that nobody uses it.

Good.

>>  unsigned long __clk_get_flags(struct clk *clk);
>>  bool __clk_is_prepared(struct clk *clk);
>>  bool __clk_is_enabled(struct clk *clk);
>> @@ -523,6 +528,22 @@ long __clk_mux_determine_rate(struct clk_hw *hw, unsigned long rate,
>>                             unsigned long *best_parent_rate,
>>                             struct clk **best_parent_p);
>>
>> +unsigned long clk_provider_get_rate(struct clk_core *clk);
>> +struct clk_core *clk_provider_get_parent(struct clk_core *clk);
>> +
>> +/**
>> + * __clk_core_to_clk - return per-user clk
>> + * @clk: struct clk_core for which we want a per-user clk
>> + *
>> + * Returns a per-user clock that is owned by its provider. The caller shall not
>> + * call clk_get() on it.
>> + *
>> + * This function should be only needed by implementors of
>> + * clk_ops.determine_rate() and should be dropped once all have moved to a
>> + * variant that returns **clk_core instead.
>
> Can we do that before this patch? And also move them to use **clk_hw instead?

Will look at it.

Thanks for the great feedback!

Tomeu

>> + */
>> +struct clk *__clk_core_to_clk(struct clk_core *clk);
>> +
>
> --
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
> hosted by The Linux Foundation
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
