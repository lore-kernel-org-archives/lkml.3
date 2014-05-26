Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017AbaEZMRM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 08:17:12 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:12465 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443AbaEZMRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 08:17:11 -0400
Message-ID: <538330B7.5070503@huawei.com>
Date: Mon, 26 May 2014 20:16:55 +0800
From: Libo Chen <libo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Mike Galbraith <umgwanakikbuti@gmail.com>
CC: <tglx@linutronix.de>, <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, "Li Zefan" <lizefan@huawei.com>,
        <peterz@infradead.org>
Subject: Re: balance storm
References: <5382AF2E.1040407@huawei.com> <1401081082.5339.41.camel@marge.simpson.net>
In-Reply-To: <1401081082.5339.41.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.22.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/5/26 13:11, Mike Galbraith wrote:
> On Mon, 2014-05-26 at 11:04 +0800, Libo Chen wrote: 
>> hi,
>>     my box has 16 cpu (E5-2658,8 core, 2 thread per core), i did a test on
>> 3.4.24stable, startup 50 same process, every process is sample:
>>
>>  	#include <unistd.h>
>>
>>  	int main()
>>  	{
>>           	for (;;)
>>           	{
>>                   	unsigned int i = 0;
>>                  	 while (i< 100){
>>                      	 i++;
>>                   	}
>>                   	usleep(100);
>>           	}
>>
>>          	 return 0;
>>   	}
>>
>> the result is process uses 15% cpu time, perf tool shows 70w migrations in 5 second.
> 
> See e0a79f52 sched: Fix select_idle_sibling() bouncing cow syndrome
> 
> That commit will fix expensive as hell bouncing for most real loads, but
> it won't fix your test.  Doing nothing but wake, select_idle_sibling()
> will be traversing all cores/siblings mightily, taking L2 misses as it
> traverses, bouncing wakees that do _nothing_ when an idle CPU is found.
> 
> Your synthetic test is the absolute worst case scenario.  There has to
> be work between wakeups for select_idle_sibling() to have any chance
> whatsoever of turning in a win.  At 0 work, it becomes 100% overhead.

not synthetic, it is a real problem in our product. under no load, waste
much cpu time.

> 
>> I guess task migration takes up a lot of cpu, so i did another test. use taskset tool to bind
>> a task to a fixed cpu. Results in line with expectations, cpu usage is down to 5%.
>>
>> other test:
>> - 3.15upstream has the same problem with 3.4.24.
>> - suse sp2 has low cpu usage about 5%.
> 
> SLE11-SP2 has a patch which fixes that behavior, but of course at the
> expense of other load types.  A trade.  It also throttles nohz, which
> can have substantial cost when cross CPU scheduling.

which patch ?

> 
>> so I think 15% cpu usage and migration event are too high, how to fixed?
> 
> You can't for free, low latency wakeup can be worth one hell of a lot.
> 
> You could do a decayed hit/miss or such to shut the thing off when the
> price is just too high.  Restricting migrations per unit time per task
> also helps cut the cost, but hurts tasks that could have gotten to the
> CPU quicker, and started your next bit of work.  Anything you do there
> is going to be a rob Peter to pay Paul thing.
> 

I had tried to change sched_migration_cost and sched_nr_migrate in /proc,
but no use.  any other  suggestion?

I still think this is a problem to schedular.  it is better to directly solve
this issue instead of a workaroud


thanks,
Libo

> -Mike
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


