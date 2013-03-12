Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843Ab3CLDYq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 23:24:46 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:50364 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754246Ab3CLDYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 23:24:45 -0400
Message-ID: <513E9FC6.4060507@linux.vnet.ibm.com>
Date: Tue, 12 Mar 2013 11:23:50 +0800
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
References: <5136EB06.2050905@linux.vnet.ibm.com> <1362677252.10972.26.camel@laptop> <5139520C.1060109@linux.vnet.ibm.com> <1362998219.14933.9.camel@laptop>
In-Reply-To: <1362998219.14933.9.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031203-9574-0000-0000-000006F6066D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2013 06:36 PM, Peter Zijlstra wrote:
> On Fri, 2013-03-08 at 10:50 +0800, Michael Wang wrote:
> 
>>> OK, so there's two issues I have with all this are:
>>>
>>>  - it completely wrecks task placement for things like interrupts (sadly I don't
>>>      have a good idea about a benchmark where this matters).
>>
>> I don't get this point...could you please give more details?
> 
> Take for instance a network workload, the hardirq notifies us there's
> data buffered, then softirq does a ton of network layer demuxing and
> eventually wakes one (or more) tasks to process data. You want these
> tasks to move to the waking cpu, it has lots of this data in cache.
> 
> Now, neither hard- nor softirq runs in task context (except for -rt) so
> it completely fails on what you propose.

I got it, exactly, the new feature with current ref limit will miss this
optimize timing, if the data not related to current...

However, we are still gambling here, and some workload suffered.

Actually this feature's purpose is to provide a way for user who want to
balance the risk and benefit on self demand, it providing flexible, not
restriction...

So what about make the default sysctl_sched_wakeup_buddy_ref to be 0 and
make every thing just like the old world.

And for those who want to make the decision more carefully, they could
turn the knob to make it bigger, and gain the benefit.

> 
> We could simply add something like in_softirq() || in_irq() etc.. to
> re-enable wake_affine() for those cases unconditionally, but not sure
> that's the right thing either.
> 
>>>  - yet another random number.. :/
>>
>> Correct...well, but that also means flexibility, I suppose different
>> system and workload will need some tuning on this knob to gain more
>> benefit, by default, they will gain some benefit, small or big.
> 
> Nah, it just means another knob nobody knows how to twiddle.

Right, and we already have many such kind of knob...since some formular
is impossible to be written down.

Mysterious knob, I twiddle it and wait for something to drop from sky,
candy, cake or rock, whatever, there are adventures there ;-)

And I believe if once the cake drop from sky, there will be more
adventurers, and it won't be a mysterious knob any more.

> 
>>> Also, I'm starting to dislike the buddy name; its somewhat over-used.
>>
>> I have to agree :), any suggestions?
> 
> Nah.. I suppose it depends a bit on the shape the final solution takes,

What about default sysctl_sched_wakeup_buddy_ref = 0 and keep the old
logical?

Regards,
Michael Wang


> but I'll think about it.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

