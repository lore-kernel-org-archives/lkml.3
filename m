Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747AbaDXFu5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 01:50:57 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53019 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560AbaDXFuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 01:50:51 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <5358A60D.6070407@jp.fujitsu.com>
Date: Thu, 24 Apr 2014 14:50:05 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Denys Vlasenko <vda.linux@googlemail.com>, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] nohz: delayed iowait accounting for nohz idle time
 stats
References: <534FA04B.8080906@jp.fujitsu.com> <534FA1D5.7040808@jp.fujitsu.com> <20140422194547.GS13658@twins.programming.kicks-ass.net> <53576E62.50508@jp.fujitsu.com> <20140423094119.GJ11096@twins.programming.kicks-ass.net>
In-Reply-To: <20140423094119.GJ11096@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/04/23 18:41), Peter Zijlstra wrote:
> On Wed, Apr 23, 2014 at 04:40:18PM +0900, Hidetoshi Seto wrote:
>> (2014/04/23 4:45), Peter Zijlstra wrote:
>>> On Thu, Apr 17, 2014 at 06:41:41PM +0900, Hidetoshi Seto wrote:
>>>> [TARGET OF THIS PATCH]:
>>>>
>>>>   Complete rework for iowait accounting implies that some user
>>>>   interfaces might be replaced completely. It will introduce new
>>>>   counter or so, and kill per-cpu iowait counter which is known to
>>>>   being nonsense. It will take long time to be achieved, considering
>>>>   time to make the problem to a public knowledge, and also time for
>>>>   interface transition. Anyway as long as linux try to be reliable OS,
>>>>   such drastic change must be placed on mainline kernel in development
>>>>   sooner or later.
>>>>
>>>>   OTOH, drastic change like above is not acceptable for conservative
>>>>   environment, such as stable kernels, some distributor's kernel and
>>>>   so on, due to respect for compatibility. Still these kernel expects
>>>>   per-cpu iowait counter works as well as it might have been.
>>>>   Therefore for such environment, applying a simple patch to fix
>>>>   behavior of counter will be appreciated rather than replacing an
>>>>   over-used interface or changing an existing usage/semantics.
>>>>
>>>>   This patch targets latter kernels mainly. It does not do too much,
>>>>   but intend to fix the idle stats counters to be monotonic. I believe
>>>>   that mainline kernel should pick up this patch too, because it
>>>>   surely fix a hidden bug and does not intercept upcoming drastic
>>>>   change.
>>>>
>>>>   Again, in summary, this patch does not do drastic change to cope
>>>>   with problem 2. But it just fix behavior of idle/iowait counter of
>>>>   /proc/stats.
>>>>
>>>> [WHAT THIS PATCH PROPOSED]:
>>>>
>>>>   The main reason of the bug is that observers have no idea to
>>>>   determine the delta to be idle or iowait at the first place.
>>>>
>>>>   So I introduced delayed iowait accounting to allow observers to
>>>>   assign delta based on status of observed cpu at idle entry.
>>>>
>>>
>>> So the problem I have with this is that it makes CONFIG_NOHZ=[ny]
>>> kernels behave quite differently.
>>
>> It is not true.
>> There are already differences before applying my patches.
>> The behavior of NOHZ=y kernel diverged from original since it was born.
> 
> But if you argue about not actually fixing iowait properly, then this
> difference is the only actual regression.

A difference is not always a regression.

>> Please note that no one complained about this difference.
> 
> Then why are you working on this? You're the one that said there was a
> regression between unnamed enterprise distro 5 and unnamed enterprise
> distro 6.

e.g.
 regression: a counter loses monotonicity
 improvement: drop power consumption by skipping tick during in idle
 not matter: useless fuzzy crap value turned to be another crap

If you say every difference is regression, then all kernel config
must be nop.

>> I just want to fix a counter not to go backward.
>> It's a simple bug, isn't it?
> 
> Seeing how we managed to send as many patches as we did, I'd say that's
> a fairly big clue as to how its not as simple.

I think the situation is that a simple small bug is glued to big
complicated background. I want to separate them and handle only
a small bug, therefore I wrote patch description a lot for background
and my target.

> Just make the value unconditionally 0 then. That's guaranteed not to go
> backwards and just about as useful as the random fwd walk you make it.
> Plus, its a lot easier.

I'd like to hire constant 0 if it is acceptable for stables.

I suppose it could be considered as improvement for mainline kernel
since it will be the first step for upcoming drastic changes.
But I also suppose it could be classified as regression for stable
kernels because one counter ordinarily used stops its progress.

>>> Ideally NOHZ=y and NOHZ=n behave the same, my proposed solution the
>>> other day does just that. This one OTOH seems to generate entirely
>>> different results between those kernels.
>>
>> As you know, behaviors of NOHZ=[ny] are both crap because of per-cpu
>> iowait accounting.
>>
>> I guess we should say:
>>   Ideally NOHZ=[ny] behave the same "in the proper way."
> 
> No, the premise of NOHZ is that behaviour should not change, we found a
> change in behaviour, we should make it go away.
> 
> Secondly, with or without NOHZ iowait accounting is complete crap. We
> should also fix that.

Humm..? I could not catch the reason why you say no here.
I think wasting time to unify 2 craps into 1 crap is not necessary
before replacing craps by a proper thing. 

>> What you proposed will do too much to make one nonsense to another
>> nonsense. It will be unhelpful for people...
> 
> I proposed that if you don't want to fix the actual iowait is crap
> problem, you at least fix the NOHZ regression proper.

I'd like to target only a part of differences which is considered as
regression.

I'm being overly cautious since removing or stopping this crap counter
could be new regression.

>>> It also doesn't really simplify the code; there's quite a bit of
>>> complexity introduced to paper over this silly stuff.
>>
>> Don't complicate things. I want to talk about a small simple bug.
>>
>> a) today's NOHZ=n
>>    - provides per-cpu iowait counter
>>      (nonsense but still loved by innocent userland)
>> b) today's NOHZ=y
>>    - provides per-cpu iowait counter
>>    - use it's own idle time accounting different from a)
>>    - have a *bug* that counter might go backward
> 
> Like said, the intent of NOHZ is to not change accounting, its often
> more complicated from a because well, no ticks.
> 
> But it really should give the same number, nonsense or not. We do the
> same for all other numbers -- we spend a ton of effort to fix the
> loadavg a year or two ago.
> 
> loadavg is also another dubious number, fwiw.

I can understand how you feel.

>> b') NOHZ=y + my patch
>>    - provides per-cpu iowait counter
>>    - use it's own idle time accounting same as b)
>>    - *bug* in b) have gone
>>    - instead accept gap in iowait value from b)
>>      - "pending" will not bloat more than one iowait span
>>
>> c) unified something for NOHZ=[ny] (you proposed)
>>    - provides per-cpu iowait counter
>>    - use new accounting different from a) and also b)
>>
>> d) ideal goal (=not designed & realized yet)
>>    - no per-cpu iowait counter any more
>>    - use new proper accounting different from all of above
>>
>> I just want to make b) to b') by a patch as small as possible.
> 
> I really don't see the value of b', the actual value of its result is
> really no better than the constant 0, and the constant implementation is
> _way_ simpler.

 a) monotonic per-cpu counter providing useless value
 b) non-monotonic per-cpu counter providing useless value
 b') monotonic per-cpu counter providing useless value
 c) monotonic per-cpu counter providing useless value
 d) monotonic counter(s) providing proper value
 x) constant 0 counter

My evaluation is:
  for stables:
   (bad)  (b,d,x) <<<<< (a,b',c) (good)
  for mainline:
   (bad)  b <<<<< (a,b',c) <<<<< x <<<<< d  (good) 

>> What you proposed will make both of a) and b) to c).
>> I think it does too much and changing a) is not required here.
>> (from my conservative perspective, patch must be non-intrusive)
>>
>> Our final goal must be making d) to replace all nasty things
>> around there. But still there is no idea to do that.
>> And such big jump will not fit to stable environments.
>>
>> Again, I just want to fix a small bug here...
>>
>> I believe my patch is enough simple to do a minimum fix.
>> Please tell me if you have more simple/better way to fix this
>> long-standing minor bug, not only for mainline in development
>> but also for conservative stables like distributor's kernel.
> 
> I really think only fixing the backward motion is retarded. Its papering
> over so much crap its not funny.
> 
> The fact that it does go backwards is because b does not give the
> identical results from a, _that_ is a bug per the design principle of
> NOHZ.
> 
> Fixing it to just return some random number that doesn't go backwards
> doesn't fix it. It just makes the immediately observed problem go away;
> entirely the wrong mindset.

I feel like that you are going to use cardboards instead of papers...


BTW, I found that Denys posted his updated patch set: 
https://lkml.org/lkml/2014/4/23/579

I think it looks like taking almost same approach as what you
proposed. However I guess:
  - It should not have #ifdef CONFIG_NOHZ_* because it make
    differences between behavior of NOHZ=[ny].
  - last_iowait need to be located in rq rather than in struct
    tick_sched, considering cache hit at io_schedule*().
  - last_iowait need to be referred in tick for NOHZ=n, not to make
    difference from NOHZ=y.

Anyway, though I still wonder what you proposed is acceptable fix
for distro's quality assurance, I hope someone in charge may have
broad mind like you and may resolve the matter favorably.

Is it worth to do if I make v5 based on your proposal and post it
for review comparing with v4?


Thanks,
H.Seto

