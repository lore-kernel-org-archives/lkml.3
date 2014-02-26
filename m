Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450AbaBZPQ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 10:16:26 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:49693 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926AbaBZPQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 10:16:24 -0500
Message-ID: <530E0531.7000303@linaro.org>
Date: Wed, 26 Feb 2014 23:16:01 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@redhat.com, morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        daniel.lezcano@linaro.org, fweisbec@gmail.com, linux@arm.linux.org.uk,
        tony.luck@intel.com, fenghua.yu@intel.com, james.hogan@imgtec.com,
        jason.low2@hp.com, viresh.kumar@linaro.org, hanjun.guo@linaro.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, pjt@google.com,
        fengguang.wu@intel.com, linaro-kernel@lists.linaro.org,
        wangyun@linux.vnet.ibm.com, mgorman@suse.de
Subject: Re: [PATCH 04/11] sched: unify imbalance bias for target group
References: <1393293054-11378-1-git-send-email-alex.shi@linaro.org> <1393293054-11378-5-git-send-email-alex.shi@linaro.org> <20140225141407.GT9987@twins.programming.kicks-ass.net>
In-Reply-To: <20140225141407.GT9987@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> So this patch is weird..
> 
> So the original bias in the source/target load is purely based on actual
> load figures. It only pulls-down/pulls-up resp. the long term avg with a
> shorter term average; iow. it allows the source to decrease faster and
> the target to increase faster, giving a natural inertia (ie. a
> resistance to movement).
> 
> Therefore this gives rise to a conservative imbalance.
> 
> Then at the end we use the imbalance_pct thing as a normal hysteresis
> control to avoid the rapid state switching associated with a single
> control point system.

Peter, Thanks response and detailed explanations! :)

Yes, fixed bias can not replace the current bias.
If we said sth inertia, we usually mean the previous value or long term
value here. but source/target_load doesn't prefer a long term or shorter
term load, Just get the min or max of them. so I can't see other meaning
except source/target bias. And the long term load is a decayed load with
history load value, not a real actual load.

And in current logical, assume the load of cpu is constant in a period,
then the source/target_load will lose its 'resistance' function for
balance. Considering the moving cost, rq locking and potential cpu cache
missing, Is some bias needed here?

Another problem is, we bias load twice for busy_idx scenario. once in
source/target_load another is imbalance_pct in find_busiest_group. I
can't figure out the reason. :(

So would rather select a random long/shorter term load, than maybe it's
better to use a fixed bias, like in current NUMA balancing, and in
newidle/wake balance.

> 
> 
> You completely wreck that, you also don't give a coherent model back.
> 
> 
> The movement of imbalance_pct into target_load() doesn't make sense to
> me either; it's an (expensive) no-op afaict. Seeing how:
> 
>   100 * source_load() < imb_pct * target_load()
> 
> is very much equal to:
> 
>   source_load() < (imb_pct * target_load()) / 100;
> 
> Except you get to do that div all over the place.

It is my fault. Will change it back.
> 
> It also completely muddles the fact that its a normal hysteresis
> control. Not a load bias. A fixed bias can never replace the inertial
> control we had; it doesn't make sense as a replacement.

I know fixed bias maybe not the best, but sorry for can not figure out
better one. Would you like to give some suggestion?
> 
> Not to mention you seem to ignore all concerns wrt the use of longer
> term averages for the bigger domains.

For bigger domain, I given up the aggression bias idea(less bias on
large group) in V2 version due to Morten's concern. And I have asked for
more comments, but no more detailed concerns I can see now. :(
> 
> Now I'm all for removing code; and so far the numbers aren't bad; but I
> don't like the complete muddle you make of things at all.
> 

Sorry, do you mean the load_idx removing is fine, if without this fixed
bias? Or other suggestion here?

-- 
Thanks
    Alex
