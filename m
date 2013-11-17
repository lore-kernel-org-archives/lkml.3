Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035Ab3KQPd6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 10:33:58 -0500
Received: from 19.mo6.mail-out.ovh.net ([188.165.56.177]:52389 "EHLO
	mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751922Ab3KQPds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 10:33:48 -0500
Message-ID: <5288E1B6.5090704@overkiz.com>
Date: Sun, 17 Nov 2013 16:33:10 +0100
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>, Rob Landley <rob@landley.net>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>
CC: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH RESEND 1/2] clk: add clk accuracy retrieval support
References: <1381684631-10835-1-git-send-email-b.brezillon@overkiz.com> <1381684631-10835-2-git-send-email-b.brezillon@overkiz.com> <20131108005147.19193.42349@quantum> <527CA6D5.9070807@overkiz.com> <20131116005031.19193.32668@quantum>
In-Reply-To: <20131116005031.19193.32668@quantum>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 16261372355138648092
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrieekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrieekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mike,

On 16/11/2013 01:50, Mike Turquette wrote:
> Quoting boris brezillon (2013-11-08 00:54:45)
>> Hello Mike,
>>
>> On 08/11/2013 01:51, Mike Turquette wrote:
>>> Quoting Boris BREZILLON (2013-10-13 10:17:10)
>>>> +/**
>>>> + * clk_get_accuracy - return the accuracy of clk
>>>> + * @clk: the clk whose accuracy is being returned
>>>> + *
>>>> + * Simply returns the cached accuracy of the clk, unless
>>>> + * CLK_GET_ACCURACY_NOCACHE flag is set, which means a recalc_rate will be
>>>> + * issued.
>>>> + * If clk is NULL then returns 0.
>>>> + */
>>>> +unsigned long clk_get_accuracy(struct clk *clk)
>>>> +{
>>>> +       unsigned long accuracy;
>>>> +       clk_prepare_lock();
>>>> +
>>>> +       if (clk && (clk->flags & CLK_GET_ACCURACY_NOCACHE))
>>>> +               __clk_recalc_accuracies(clk);
>>> I think that there is some overlap between recalculating the accuracy
>>> here and simply getting it. You only provide clk_get_accuracy and it
>>> serves both purposes. It would be better if clk_recalc_accuracy walked
>>> the subtree of children and if clk_get_accuracy simply returned a cached
>>> value.
>> I'm not sure I get your point.
>>
>> I used exactly the same model as for clk rate retrieval.
> Not exactly the same model. For rates we support public clk_recalc_rate
> and clk_get_rate functions.

I didn't find any clk_recalc_rate function in the CCF.
Could you point me out where it is defined ?

>
>> Actually there's one flag (CLK_GET_ACCURACY_NOCACHE) which is
>> checked to decide wether the accuracy should be recalculated each
>> time the get_accuracy is called or not.
>>
>> This means most of the time the clk_get_accuracy will return the cached
>> value unless the clk provider explicitely ask for accuracy recalculation
>> (e.g. a clk with dynamic accuracy according to temperature range ?).
>>
>> Are you suggesting to expose 2 functions to clk users (clk_get_accuracy
>> and clk_recalc_accuracy) ?
>> Or is clk_recalc_accuracy an internal/private function used by the CCF ?
> I was suggesting that in my previous email. However I've thought on it a
> bit and I'm not sure there is any value to having a public
> clk_recalc_accuracy right now.
>
> The only reason to do so would be if the accuracy can change in such a
> way that the clock framework is never aware of it.  This would mean that
> somehow the accuracy changed "behind our back".
>
> One hypothetical example is a PLL which Linux knows about, but perhaps
> is controlled by some other co-processor (not Linux). In this case the
> co-processor may reprogram/relock the PLL in a way that affects it's
> accuracy, and a Linux driver that knows this may want to update the CCF
> book-keeping with a call to clk_recalc_accuracy.
>
> That's all hypothetical though and it can be added in later. Looking
> over your change again I think that it is sufficient for now.

This looks reasonable.
I'll propose a new patch to provide a public clk_recalc_rate function 
after this
series is merged.

>
> Can you respin this patch with fixes for the two nitpicks I outlined in
> my previous mail and rebase it onto -rc1 when it drops? That should be
> any day now.

I've rebased this series (with the proposed fixes) onto linux-next.
I guess there won't be a lot of changes between the current tag ( 
next-20131115 
<https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/tag/?id=next-20131115>)
and -rc1, but I'll wait till -rc1 is released ;-).


Thanks for your review.

Best Regards,

Boris

> Thanks!
> Mike
>
>>>> +
>>>> +       accuracy = __clk_get_accuracy(clk);
>>>> +       clk_prepare_unlock();
>>>> +
>>>> +       return accuracy;
>>>> +}
>>>> +EXPORT_SYMBOL_GPL(clk_get_accuracy);
>>>> +
>>>> +/**
>>>>     * __clk_recalc_rates
>>>>     * @clk: first clk in the subtree
>>>>     * @msg: notification type (see include/linux/clk.h)
>>>> @@ -1545,6 +1610,7 @@ void __clk_reparent(struct clk *clk, struct clk *new_parent)
>>>>    {
>>>>           clk_reparent(clk, new_parent);
>>>>           clk_debug_reparent(clk, new_parent);
>>>> +       __clk_recalc_accuracies(clk);
>>> Similar to the above statement. Why do this here? We do this for rates
>>> since calls to clk_get_rate will return the cached rate (unless the
>>> NOCACHE flag is set). But since a call to clk_get_accuracy will always
>>> recalculate it then there is no benefit to doing that here.
>> This is the same for clk_get_accuracies (it returns the cached
>> accuracy unless CLK_GET_ACCURACY_NOCACHE is defined).
>>
>> And changing parent of a clk will indirectly change the clk
>> accuracy (clk accuracies are cumulative).
>>
>>>>           __clk_recalc_rates(clk, POST_RATE_CHANGE);
>>>>    }
>>>>    
>>>> @@ -1615,6 +1681,9 @@ int clk_set_parent(struct clk *clk, struct clk *parent)
>>>>           /* do the re-parent */
>>>>           ret = __clk_set_parent(clk, parent, p_index);
>>>>    
>>>> +       /* propagate accuracy recalculation */
>>>> +       __clk_recalc_accuracies(clk);
>>> Ditto.
>> Ditto. :)
>>
>>
>> Please tell me if I misunderstood your requests.
>>
>> Best Regards,
>>
>> Boris
>>
>>> Regards,
>>> Mike
>>>
>>>> +
>>>>           /* propagate rate recalculation accordingly */
>>>>           if (ret)
>>>>                   __clk_recalc_rates(clk, ABORT_RATE_CHANGE);
>>>> @@ -1724,6 +1793,21 @@ int __clk_init(struct device *dev, struct clk *clk)
>>>>                   hlist_add_head(&clk->child_node, &clk_orphan_list);
>>>>    
>>>>           /*
>>>> +        * Set clk's accuracy.  The preferred method is to use
>>>> +        * .recalc_accuracy. For simple clocks and lazy developers the default
>>>> +        * fallback is to use the parent's accuracy.  If a clock doesn't have a
>>>> +        * parent (or is orphaned) then accuracy is set to zero (perfect
>>>> +        * clock).
>>>> +        */
>>>> +       if (clk->ops->recalc_accuracy)
>>>> +               clk->accuracy = clk->ops->recalc_accuracy(clk->hw,
>>>> +                                       __clk_get_accuracy(clk->parent));
>>>> +       else if (clk->parent)
>>>> +               clk->accuracy = clk->parent->accuracy;
>>>> +       else
>>>> +               clk->accuracy = 0;
>>>> +
>>>> +       /*
>>>>            * Set clk's rate.  The preferred method is to use .recalc_rate.  For
>>>>            * simple clocks and lazy developers the default fallback is to use the
>>>>            * parent's rate.  If a clock doesn't have a parent (or is orphaned)
>>>> diff --git a/include/linux/clk-private.h b/include/linux/clk-private.h
>>>> index 8138c94..accb517 100644
>>>> --- a/include/linux/clk-private.h
>>>> +++ b/include/linux/clk-private.h
>>>> @@ -41,6 +41,7 @@ struct clk {
>>>>           unsigned long           flags;
>>>>           unsigned int            enable_count;
>>>>           unsigned int            prepare_count;
>>>> +       unsigned long           accuracy;
>>>>           struct hlist_head       children;
>>>>           struct hlist_node       child_node;
>>>>           unsigned int            notifier_count;
>>>> diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
>>>> index 73bdb69..942811d 100644
>>>> --- a/include/linux/clk-provider.h
>>>> +++ b/include/linux/clk-provider.h
>>>> @@ -29,6 +29,7 @@
>>>>    #define CLK_IS_BASIC           BIT(5) /* Basic clk, can't do a to_clk_foo() */
>>>>    #define CLK_GET_RATE_NOCACHE   BIT(6) /* do not use the cached clk rate */
>>>>    #define CLK_SET_RATE_NO_REPARENT BIT(7) /* don't re-parent on rate change */
>>>> +#define CLK_GET_ACCURACY_NOCACHE BIT(8) /* do not use the cached clk accuracy */
>>>>    
>>>>    struct clk_hw;
>>>>    
>>>> @@ -108,6 +109,13 @@ struct clk_hw;
>>>>     *             which is likely helpful for most .set_rate implementation.
>>>>     *             Returns 0 on success, -EERROR otherwise.
>>>>     *
>>>> + * @recalc_accuracy: Recalculate the accuracy of this clock. The clock accuracy
>>>> + *             is expressed in ppb (parts per billion). The parent accuracy is
>>>> + *             an input parameter.
>>>> + *             Returns the calculated accuracy.  Optional - if this op is not
>>>> + *             set then clock accuracy will be initialized to parent accuracy
>>>> + *             or 0 (perfect clock) if clock has no parent.
>>>> + *
>>>>     * The clk_enable/clk_disable and clk_prepare/clk_unprepare pairs allow
>>>>     * implementations to split any work between atomic (enable) and sleepable
>>>>     * (prepare) contexts.  If enabling a clock requires code that might sleep,
>>>> @@ -139,6 +147,8 @@ struct clk_ops {
>>>>           u8              (*get_parent)(struct clk_hw *hw);
>>>>           int             (*set_rate)(struct clk_hw *hw, unsigned long,
>>>>                                       unsigned long);
>>>> +       unsigned long   (*recalc_accuracy)(struct clk_hw *hw,
>>>> +                                          unsigned long parent_accuracy);
>>>>           void            (*init)(struct clk_hw *hw);
>>>>    };
>>>>    
>>>> @@ -194,6 +204,7 @@ struct clk_hw {
>>>>    struct clk_fixed_rate {
>>>>           struct          clk_hw hw;
>>>>           unsigned long   fixed_rate;
>>>> +       unsigned long   fixed_accuracy;
>>>>           u8              flags;
>>>>    };
>>>>    
>>>> diff --git a/include/linux/clk.h b/include/linux/clk.h
>>>> index 9a6d045..2fe3b54 100644
>>>> --- a/include/linux/clk.h
>>>> +++ b/include/linux/clk.h
>>>> @@ -85,6 +85,23 @@ int clk_notifier_unregister(struct clk *clk, struct notifier_block *nb);
>>>>    #endif
>>>>    
>>>>    /**
>>>> + * clk_get_accuracy - obtain the clock accuracy in ppb (parts per billion)
>>>> + *                   for a clock source.
>>>> + * @clk: clock source
>>>> + *
>>>> + * This gets the clock source accuracy expressed in ppb.
>>>> + * A perfect clock returns 0.
>>>> + */
>>>> +#ifdef CONFIG_HAVE_CLK_GET_ACCURACY
>>>> +unsigned long clk_get_accuracy(struct clk *clk);
>>>> +#else
>>>> +static inline unsigned long clk_get_accuracy(struct clk *clk)
>>>> +{
>>>> +       return 0;
>>>> +}
>>>> +#endif
>>>> +
>>>> +/**
>>>>     * clk_prepare - prepare a clock source
>>>>     * @clk: clock source
>>>>     *
>>>> -- 
>>>> 1.7.9.5
>>>>
>>>>
>>>> _______________________________________________
>>>> linux-arm-kernel mailing list
>>>> linux-arm-kernel@lists.infradead.org
>>>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

