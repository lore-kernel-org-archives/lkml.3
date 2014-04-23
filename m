Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426AbaDWHlS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 03:41:18 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53883 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756081AbaDWHlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 03:41:14 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <53576E62.50508@jp.fujitsu.com>
Date: Wed, 23 Apr 2014 16:40:18 +0900
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
References: <534FA04B.8080906@jp.fujitsu.com> <534FA1D5.7040808@jp.fujitsu.com> <20140422194547.GS13658@twins.programming.kicks-ass.net>
In-Reply-To: <20140422194547.GS13658@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/04/23 4:45), Peter Zijlstra wrote:
> On Thu, Apr 17, 2014 at 06:41:41PM +0900, Hidetoshi Seto wrote:
>> [TARGET OF THIS PATCH]:
>>
>>   Complete rework for iowait accounting implies that some user
>>   interfaces might be replaced completely. It will introduce new
>>   counter or so, and kill per-cpu iowait counter which is known to
>>   being nonsense. It will take long time to be achieved, considering
>>   time to make the problem to a public knowledge, and also time for
>>   interface transition. Anyway as long as linux try to be reliable OS,
>>   such drastic change must be placed on mainline kernel in development
>>   sooner or later.
>>
>>   OTOH, drastic change like above is not acceptable for conservative
>>   environment, such as stable kernels, some distributor's kernel and
>>   so on, due to respect for compatibility. Still these kernel expects
>>   per-cpu iowait counter works as well as it might have been.
>>   Therefore for such environment, applying a simple patch to fix
>>   behavior of counter will be appreciated rather than replacing an
>>   over-used interface or changing an existing usage/semantics.
>>
>>   This patch targets latter kernels mainly. It does not do too much,
>>   but intend to fix the idle stats counters to be monotonic. I believe
>>   that mainline kernel should pick up this patch too, because it
>>   surely fix a hidden bug and does not intercept upcoming drastic
>>   change.
>>
>>   Again, in summary, this patch does not do drastic change to cope
>>   with problem 2. But it just fix behavior of idle/iowait counter of
>>   /proc/stats.
>>
>> [WHAT THIS PATCH PROPOSED]:
>>
>>   The main reason of the bug is that observers have no idea to
>>   determine the delta to be idle or iowait at the first place.
>>
>>   So I introduced delayed iowait accounting to allow observers to
>>   assign delta based on status of observed cpu at idle entry.
>>
> 
> So the problem I have with this is that it makes CONFIG_NOHZ=[ny]
> kernels behave quite differently.

It is not true.
There are already differences before applying my patches.
The behavior of NOHZ=y kernel diverged from original since it was born.

Please note that no one complained about this difference.

I just want to fix a counter not to go backward.
It's a simple bug, isn't it?

> Ideally NOHZ=y and NOHZ=n behave the same, my proposed solution the
> other day does just that. This one OTOH seems to generate entirely
> different results between those kernels.

As you know, behaviors of NOHZ=[ny] are both crap because of per-cpu
iowait accounting.

I guess we should say:
  Ideally NOHZ=[ny] behave the same "in the proper way."

What you proposed will do too much to make one nonsense to another
nonsense. It will be unhelpful for people...

> It also doesn't really simplify the code; there's quite a bit of
> complexity introduced to paper over this silly stuff.

Don't complicate things. I want to talk about a small simple bug.

a) today's NOHZ=n
   - provides per-cpu iowait counter
     (nonsense but still loved by innocent userland)

b) today's NOHZ=y
   - provides per-cpu iowait counter
   - use it's own idle time accounting different from a)
   - have a *bug* that counter might go backward

b') NOHZ=y + my patch
   - provides per-cpu iowait counter
   - use it's own idle time accounting same as b)
   - *bug* in b) have gone
   - instead accept gap in iowait value from b)
     - "pending" will not bloat more than one iowait span

c) unified something for NOHZ=[ny] (you proposed)
   - provides per-cpu iowait counter
   - use new accounting different from a) and also b)

d) ideal goal (=not designed & realized yet)
   - no per-cpu iowait counter any more
   - use new proper accounting different from all of above

I just want to make b) to b') by a patch as small as possible.

What you proposed will make both of a) and b) to c).
I think it does too much and changing a) is not required here.
(from my conservative perspective, patch must be non-intrusive)

Our final goal must be making d) to replace all nasty things
around there. But still there is no idea to do that.
And such big jump will not fit to stable environments.

Again, I just want to fix a small bug here...

I believe my patch is enough simple to do a minimum fix.
Please tell me if you have more simple/better way to fix this
long-standing minor bug, not only for mainline in development
but also for conservative stables like distributor's kernel.


Thanks,
H.Seto

