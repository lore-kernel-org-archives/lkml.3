Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903Ab3BDDBm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 22:01:42 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:37584 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753757Ab3BDDBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 22:01:40 -0500
Message-ID: <510F2483.6070301@linux.vnet.ibm.com>
Date: Mon, 04 Feb 2013 11:01:23 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        tglx@linutronix.de
Subject: Re: [RFC 2/2] sched/fair: prefer a CPU in the "lowest" idle state
References: <1359580757-4121-1-git-send-email-bigeasy@linutronix.de> <1359580757-4121-3-git-send-email-bigeasy@linutronix.de> <5109D313.1020409@linux.vnet.ibm.com> <510D51CD.6020506@linutronix.de>
In-Reply-To: <510D51CD.6020506@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13020402-8256-0000-0000-0000061693BE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2013 01:50 AM, Sebastian Andrzej Siewior wrote:
> On 01/31/2013 03:12 AM, Michael Wang wrote:
>> I'm not sure, but just concern about this case:
>>
>> 	group 0		cpu 0			cpu 1
>> 			least idle		4 task
>>
>> 	group 1		cpu 2			cpu 3
>> 			1 task			1 task
>>
>> The previous logical will pick group 1 and now it will take group 0, and
>> that cause more imbalance, doesn't it?
> 
> That depends on load of CPU 0 + 1 vs CPU 2 + 3. If the four tasks on
> CPU1 are idle then the previous code should return group 0.
> If the four tasks are running at 100% each then two of them should be
> migrated to CPU0 and this point the idle state does not matter :)

Hmm...may be I should make it more clear like this:

Prev find_idlest_group():

	cpu 0 is the least idle
	cpu 1 has 4 tasks on it's running queue
	cpu 2 has 1 task(current task) on it's running queue
	cpu 3 has 1 task on it's running queue

	and suppose no changes happen during the search, and this
	sd only contain 2 groups:

	group 0 has cpu 0 and 1
	group 1 has cpu 2 and 3

So in the old world, group 0 has load 4096 (if all the task are nice 0,
and let's put down the revise), group 1 has load 2048, so
find_idlest_group() will return group 1 since it's the idlest.

But now, since we directly using the idle group, that will be group 0,
and after applied, group 0 will has 5120 load while group 1 only has
2048, and that's cause more imbalance (than 4096 : 3072).

That's just flash in my mind when I saw the patch, may be not a good
case or missed some thing, but since find_idlest_group() is trying to
balance the load, if we want to override the rule, we need proof by
logical or benchmarks.

> 
>> May be check that state in find_idlest_cpu() will be better?
> 
> You say to move this from find_idlest_group() to find_idlest_cpu()?

Yes, since we already make sure the balance by find_idlest_group(), we
only need to add some check like below in find_idlest_cpu():

if (load < min_load || (load == min_load && i == this_cpu)) {
	if (power state of 'idlest' < power state of 'i')
		continue;

	min_load = load;
	idlest = i;
}

That will get very limited benefit (only the case when there are
multiple different power state idle cpu in the group), but is very easy
to be proved by logical, doesn't it?

And Namhyung mentioned some interesting implementation which may need no
changes to the code in select, please take a look :)

Regards,
Michael Wang

> 
>> Regards,
>> Michael Wang
> 
> Sebastian
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

