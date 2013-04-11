Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760888Ab3DKI0z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 04:26:55 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:52759 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755203Ab3DKI0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 04:26:52 -0400
Message-ID: <516673BF.4080404@linux.vnet.ibm.com>
Date: Thu, 11 Apr 2013 16:26:39 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Peter Zijlstra <peterz@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Alex Shi <alex.shi@intel.com>, Namhyung Kim <namhyung@kernel.org>,
        Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH] sched: wake-affine throttle
References: <5164DCE7.8080906@linux.vnet.ibm.com> <1365583873.30071.31.camel@laptop> <51652F43.7000300@linux.vnet.ibm.com> <516651C8.307@linux.vnet.ibm.com> <1365665447.19620.102.camel@marge.simpson.net>
In-Reply-To: <1365665447.19620.102.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041108-3864-0000-0000-000007AB13A1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Mike

On 04/11/2013 03:30 PM, Mike Galbraith wrote:
[snip]
>>
>> Please let me know if I failed to express my thought clearly.
>>
>> I know it's hard to figure out why throttle could bring so many benefit,
>> since the wake-affine stuff is a black box with too many unmeasurable
>> factors, but that's actually the reason why we finally figure out this
>> throttle idea, not the approach like wakeup-buddy, although both of them
>> help to stop the regression.
> 
> For that load, as soon as clients+server exceeds socket size, pull is
> doomed to always be a guaranteed loser.  There simply is no way to win,
> some tasks must drag their data cross node no matter what you do,
> because there is one and only one source of data, so you can not
> possibly do anything but harm by pulling or in any other way disturbing
> task placement, because you will force tasks to re-heat their footprint
> every time you migrate someone with zero benefit to offset cost.  That
> is why the closer you get to completely killing all migration, the
> better your throughput gets with this load.. you're killing the cost of
> migration in a situation there simply is no gain to be had.
> 
> That's why that wakeup-buddy thingy is a ~good idea.  It will allow 1:1
> buddies that can and do benefit from motion to pair up and jabber in a
> shared cache (though that motion needs slowing down too), _and_ detect
> the case where wakeup migration is utterly pointless.  Just killing
> wakeup migration OTOH should (I'd say very emphatic will) hurt pgbench
> just as much, because spreading a smallish set which could share a cache
> across several nodes hurts things like pgbench via misses just as much
> as any other load.. it's just that once this load (or ilk) doesn't fit
> in a node, you're absolutely screwed as far as misses go, you will eat
> that because there simply is no other option.

Wow, it's really hard to write down the logical behind, but you made it ;-)

The 1:N is a good reason to explain why the chance that wakee's hot data
cached on curr_cpu is lower, and since it's just 'lower' not 'extinct',
after the throttle interval large enough, it will be balanced, this
could be proved, since during my test, when the interval become too big,
the improvement start to drop.

> 
> Any migration is pointless for this thing once it exceeds socket size,
> and fairness plays a dominant role, is absolutely not throughputs best
> friend when any component of a load requires more CPU than the other
> components, which very definitely is the case with pgbench.  Fairness
> hurts this thing a lot.  That's why pgbench took a whopping huge hit
> when I fixed up select_idle_sibling() to not completely rape fast/light
> communicating tasks, it forced pgbench to face the consequences of a
> fair scheduler, by cutting off the escape routes that searching for
> _any_ even ever so briefly idle spot to place tasks such that wakeup
> preemption just didn't happen, and when we failed to pull, we instead
> did the very same thing on wakees original socket, thus providing
> pgbench the fairness escape mechanism that it needs.
> 
> When you wake to idle cores, you do not have a nanosecond resolution
> ultra fair scheduler, with the fairness price to be paid.. tasks run as
> long as they want to run, or at least full ticks, which of course makes
> the hard working load components a lot more productive.  Hogs can be
> hogs.  For pgbench run in 1:N mode, the hardest working load component
> is the mother of all work, the (singular) server.  Any time 'mom' is not
> continuously working her little digital a$$ off to keep all those kids
> fed, you have a performance problem on your hands, the entire load
> stalls, lives and dies with one and only 'mom'.

Hmm...that's an interesting point, the workload contain different
'priority' works, and depend on each other, if mother starving, all the
kids could do nothing but wait for her, may be that's the reason why the
benefit is so significant, since in such case, mother's little quicker
respond will make all the kids happy :)

Regards,
Michael Wang

> 
> -Mike
> 

