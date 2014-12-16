Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751379AbaLPEw0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 23:52:26 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:30897 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbaLPEwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 23:52:25 -0500
Message-ID: <548FBA62.5090603@oracle.com>
Date: Mon, 15 Dec 2014 23:51:46 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Andrey Ryabinin <a.ryabinin@samsung.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: sched: odd values for effective load calculations
References: <547E42F7.5070105@gmail.com> <20141213083012.GH32572@gmail.com> <20141215121227.GZ29390@twins.programming.kicks-ass.net>
In-Reply-To: <20141215121227.GZ29390@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2014 07:12 AM, Peter Zijlstra wrote:
> 
> Sorry for the long delay, I was out for a few weeks due to having become
> a dad for the second time.

Congrats! May you be able to sleep at night sooner rather than later.

> On Sat, Dec 13, 2014 at 09:30:12AM +0100, Ingo Molnar wrote:
>> * Sasha Levin <levinsasha928@gmail.com> wrote:
>>
>>> Hi all,
>>>
>>> I was fuzzing with trinity inside a KVM tools guest, running the latest -next
>>> kernel along with the undefined behaviour sanitizer patch, and hit the following:
>>>
>>> [  787.894288] ================================================================================
>>> [  787.897074] UBSan: Undefined behaviour in kernel/sched/fair.c:4541:17
>>> [  787.898981] signed integer overflow:
>>> [  787.900066] 361516561629678 * 101500 cannot be represented in type 'long long int'
> 
> So that's:
> 
> 	this_eff_load *= this_load +
> 		effective_load(tg, this_cpu, weight, weight);
> 
> Going by the numbers the 101500 must be 'this_eff_load', 100 * ~1024
> makes that. Which makes the rhs 'large'. Do you have
> CONFIG_FAIR_GROUP_SCHED enabled? If so, what kind of cgroup hierarchy
> are you using?

CONFIG_FAIR_GROUP_SCHED is enabled. There's no cgroup set-up initially,
but I figure that trinity is able to do crazy things here.

> In any case, bit sad this doesn't have a register dump included :/
> 
> Is this easy to reproduce or something that happened once?

It's fairy reproducible, I've seen it happen quite a few times. What other
information might be useful?

>>> The values for effective load seem a bit off (and are overflowing!).
>>
>> It definitely looks like a bug in SMP load balancing!
> 
> Yeah, although theoretically (and somewhat practical) this can be
> triggered in more places if you manage to run up the 'weight' with
> enough tasks.
> 
> That said, it should at worst result in 'funny' balancing behaviour, not
> anything else.

I'm not sure if you've caught up on the RCU stall issue we've been trying
to track down (https://lkml.org/lkml/2014/11/14/656), but could this "funny"
balancing behaviour be "funny" enough to cause a stall?


Thanks,
Sasha

