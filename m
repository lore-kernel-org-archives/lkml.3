Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001Ab3COGYl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 02:24:41 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:39307 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544Ab3COGYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 02:24:39 -0400
Message-ID: <5142BE99.4070001@linux.vnet.ibm.com>
Date: Fri, 15 Mar 2013 14:24:25 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Alex Shi <alex.shi@intel.com>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH] sched: wakeup buddy
References: <5136EB06.2050905@linux.vnet.ibm.com> <1362677252.10972.26.camel@laptop> <5139520C.1060109@linux.vnet.ibm.com> <1362998219.14933.9.camel@laptop> <513E9FC6.4060507@linux.vnet.ibm.com> <1363082932.14933.19.camel@laptop> <513FED85.8030603@linux.vnet.ibm.com> <1363258711.26965.16.camel@laptop>
In-Reply-To: <1363258711.26965.16.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031506-5564-0000-0000-0000070E2DE3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2013 06:58 PM, Peter Zijlstra wrote:
> On Wed, 2013-03-13 at 11:07 +0800, Michael Wang wrote:
> 
>> However, we already figure out the logical that wakeup related task
>> could benefit from closely running, this could promise us somewhat
>> reliable benefit.
> 
> I'm not convinced that the 2 task wakeup scenario is the only sane
> scenario. Imagine a ring of 3 tasks that wakes each other, if the
> machine is loaded enough, those 3 tasks might fit a single cpu just
> fine -- esp. if one of those is always idle.
> 
> But your strict 1:1 wakeup relation thing will completely fail to
> detect this.

Hmm...yeah, I see your point here, some optimize timing will always
be missed whatever how we twiddle the knob besides 0.

You are right, that's a problem, although currently there are no
workload to prove it, but we have the theory...

> 
>> IMHO, that sounds a little easier for users than to make the decision on
>> tell me how long to pull tasks together, they may be confused...
> 
> Users shouldn't ever need/want/etc.. rely on this. They should just run
> their programs and be (reasonably) happy.
> 
>> In summary, I think we have two point here need to be considered:
>>
>> 1. what about the missed optimize timing, that may benefit
>>    some workload (although we haven't found such workload yet).
> 
> Missed optimize; as in not calling wake_affine() due to the throttle?
> If we're calling it at such a high frequency it is very likely the next
> call isn't very far away.
> 
>> 2. how many benefit could wake_affine() stuff bring to us,
>>    if limit rate benefit us, why don't we remove it?
> 
> It could bring the same benefit but at lower overhead, what's the point
> of computing the same value over and over again? Also, the rate limit
> thing naturally works for the soft/hard-irq case.

Just try to confirm my understanding, so we are going to do something
like:

	if (now - wakee->last > time_limit) && wakeup_affine()
		wakee->last = now
		select_idle_sibling(curr_cpu)
	else
		select_idle_sibling(prev_cpu)

And time_limit is some static value respect to the rate of load balance,
is that correct?

Currently I haven't found regression by reduce the rate, but if we found
such benchmark, we may still need a way (knob or CONFIG) to disable this
limitation.

> 
> Now, there's another detail I thought up, one could only limit the
> wake_affine() calls once it starts returning false.

Hmm..if wake_affine() keep succeed, then there will be no difference?

I do believe pgbench match the case, since wake_affine() stuff make it
suffered...and the more it suffered, means the more often wake_affine()
succeed and pull none related tasks together.

I really can't see how could it do help... did I miss something?

Regards,
Michael Wang

> 

