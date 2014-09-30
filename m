Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323AbaI3AMK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 20:12:10 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:54493 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755289AbaI3AMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 20:12:07 -0400
Message-ID: <5429F555.9030108@codeaurora.org>
Date: Mon, 29 Sep 2014 17:12:05 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, ccross@android.com
Subject: Re: [PATCH v2 4/4] clk: Use ww_mutexes for clk_prepare_{lock/unlock}
References: <1409792466-5092-1-git-send-email-sboyd@codeaurora.org> <1409792466-5092-5-git-send-email-sboyd@codeaurora.org> <20140928024131.19023.40641@quantum>
In-Reply-To: <20140928024131.19023.40641@quantum>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/14 19:41, Mike Turquette wrote:
> Quoting Stephen Boyd (2014-09-03 18:01:06)
>> @@ -1069,11 +1305,24 @@ static void __clk_recalc_accuracies(struct clk *clk)
>>   */
>>  long clk_get_accuracy(struct clk *clk)
>>  {
>> +       struct ww_acquire_ctx ctx;
>> +       LIST_HEAD(list);
>>         unsigned long accuracy;
>>  
>> -       clk_prepare_lock();
>> +       if (clk && !(clk->flags & CLK_GET_ACCURACY_NOCACHE)) {
>> +               ww_mutex_lock(&clk->lock, NULL);
>> +       } else {
>> +               ww_acquire_init(&ctx, &prepare_ww_class);
>> +               clk_lock_subtree(clk, &list, &ctx);
>> +               ww_acquire_done(&ctx);
>> +       }
> It looks a little weird to access clk->flags outside of the lock, but
> flags is immutable after registration-time, so I guess it is OK. Let me
> know if I'm wrong.

Right. We can ww_acquire_init() and ww_mutex_lock() with that context
before checking the flags. In the single lock case it's better to just
grab the mutex though, without the context, to avoid the whole deadlock
detection overhead that we don't care about.

>
>> +
>>         rate = __clk_get_rate(clk);
>> -       clk_prepare_unlock();
>> +
>> +       if (clk && !(clk->flags & CLK_GET_RATE_NOCACHE))
>> +               ww_mutex_unlock(&clk->lock);
>> +       else
>> +               clk_unlock(&list, &ctx);
>>  
>>         return rate;
>>  }
>> @@ -1317,9 +1579,11 @@ out:
>>         return ret;
>>  }
>>  
>> -static void clk_calc_subtree(struct clk *clk, unsigned long new_rate,
>> -                            struct clk *new_parent, u8 p_index)
>> +static int clk_calc_subtree(struct clk *clk, unsigned long new_rate,
>> +                            struct clk *new_parent, u8 p_index,
>> +                            struct list_head *list, struct ww_acquire_ctx *ctx)
>>  {
>> +       int ret;
>>         struct clk *child;
>>  
>>         clk->new_rate = new_rate;
>> @@ -1331,27 +1595,43 @@ static void clk_calc_subtree(struct clk *clk, unsigned long new_rate,
>>                 new_parent->new_child = clk;
>>  
>>         hlist_for_each_entry(child, &clk->children, child_node) {
>> +               ret = clk_lock_one(child, list, ctx);
>> +               if (ret == -EDEADLK)
>> +                       return ret;
> Why bother with any locking here at all? Why not call clk_lock_subtree
> from clk_calc_new_rates? I guess you avoid an extra tree walk?

Yes we save on the tree walk.

>
>> +
>>                 child->new_rate = clk_recalc(child, new_rate);
>> -               clk_calc_subtree(child, child->new_rate, NULL, 0);
>> +               ret = clk_calc_subtree(child, child->new_rate, NULL, 0, list,
>> +                                       ctx);
>> +               if (ret)
>> +                       return ret;
>>         }
>> +
>> +       return 0;
>>  }
>>  
>>  /*
>>   * calculate the new rates returning the topmost clock that has to be
>>   * changed.
>>   */
>> -static struct clk *clk_calc_new_rates(struct clk *clk, unsigned long rate)
>> +static struct clk *
>> +clk_calc_new_rates(struct clk *clk, unsigned long rate, struct list_head *list,
>> +                  struct ww_acquire_ctx *ctx)
>>  {
>>         struct clk *top = clk;
>>         struct clk *old_parent, *parent;
>>         unsigned long best_parent_rate = 0;
>>         unsigned long new_rate;
>>         int p_index = 0;
>> +       int ret;
>>  
>>         /* sanity */
>>         if (IS_ERR_OR_NULL(clk))
>>                 return NULL;
>>  
>> +       ret = clk_lock_one(clk, list, ctx);
>> +       if (ret == -EDEADLK)
>> +               return ERR_PTR(ret);
> It seems to me that we should call clk_parent_lock here instead, since
> we access the parent's rate. I know that any concurrent access to the
> parent which would change its rate would fail, since we can't lock the
> subtree (including *this* lock). But it still seems more correct to lock
> the parent to me. Let me know what you think.

Blocking the other user of the parent is bad. In our CPU case we have XO
-> PLLn -> CPUn for each CPU. So if we want to change the frequency of
CPU0 we change the frequency of PLL0. If we were to always lock the
parent, in this case XO, then we wouldn't gain anything because the two
CPUs trying to change rates independently would both be trying to
acquire the XO clock's lock, thus synchronizing the two things we're
trying to parallelize.

>
> It might also help the collision case fail faster since you will fail
> trying to grab the parent lock instead of grabbing the parent lock, then
> failing to lock the subtree.

I don't follow this part. Hopefully it doesn't matter though.

>
> Though in all honestly, I haven't finished thinking it through. The
> wait/wound algorithm opens up a lot of possibilities around very
> aggressive locking strategies to prevent contention. For example if we
> call clk_parent_lock it will lock the subtree starting from the parent,
> thus holding potentially a LOT more child locks, which only need to be
> updated during the recalc rate phase.  We could avoid holding those
> children until the moment that we need to lock them... I'll think about
> it some more.
>
> Oh wait, no we couldn't. We have to take all of our locks up front via
> ww_acquire_done(), which happens below.
>
>> +
>>         /* save parent rate, if it exists */
>>         parent = old_parent = clk->parent;
>>         if (parent)
> The context cuts it off, but the next line down accesses parent->rate.
> Again I think this happens without first having locked parent?

Yes.

>> +       ww_acquire_done(ctx);
> ww_acquire_done() happens here. OK. Neverrmind, just thinking through
> out loud.  This looks good.
>
> Let me know what you think about the questions above. I've also Cc'd
> Colin Cross who has experimented with per-clock locking before as well.
> He may or may not have an interest in this now.
>
>

Thanks for reviewing Mike. I've rebased the patches to clk-next as of
today. I still need to update the locking documentation before I send it
out again, hopefully by today or tomorrow. I'm also auditing clock
drivers to find potential brokenness.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

