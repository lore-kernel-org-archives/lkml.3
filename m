Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588AbaEZFL0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 01:11:26 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:56959 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbaEZFLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 01:11:25 -0400
Message-ID: <1401081082.5339.41.camel@marge.simpson.net>
Subject: Re: balance storm
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Libo Chen <libo.chen@huawei.com>
Cc: tglx@linutronix.de, mingo@elte.hu, LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, Li Zefan <lizefan@huawei.com>
Date: Mon, 26 May 2014 07:11:22 +0200
In-Reply-To: <5382AF2E.1040407@huawei.com>
References: <5382AF2E.1040407@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-05-26 at 11:04 +0800, Libo Chen wrote: 
> hi,
>     my box has 16 cpu (E5-2658,8 core, 2 thread per core), i did a test on
> 3.4.24stable, startup 50 same process, every process is sample:
> 
>  	#include <unistd.h>
> 
>  	int main()
>  	{
>           	for (;;)
>           	{
>                   	unsigned int i = 0;
>                  	 while (i< 100){
>                      	 i++;
>                   	}
>                   	usleep(100);
>           	}
> 
>          	 return 0;
>   	}
> 
> the result is process uses 15% cpu time, perf tool shows 70w migrations in 5 second.

See e0a79f52 sched: Fix select_idle_sibling() bouncing cow syndrome

That commit will fix expensive as hell bouncing for most real loads, but
it won't fix your test.  Doing nothing but wake, select_idle_sibling()
will be traversing all cores/siblings mightily, taking L2 misses as it
traverses, bouncing wakees that do _nothing_ when an idle CPU is found.

Your synthetic test is the absolute worst case scenario.  There has to
be work between wakeups for select_idle_sibling() to have any chance
whatsoever of turning in a win.  At 0 work, it becomes 100% overhead.

> I guess task migration takes up a lot of cpu, so i did another test. use taskset tool to bind
> a task to a fixed cpu. Results in line with expectations, cpu usage is down to 5%.
> 
> other test:
> - 3.15upstream has the same problem with 3.4.24.
> - suse sp2 has low cpu usage about 5%.

SLE11-SP2 has a patch which fixes that behavior, but of course at the
expense of other load types.  A trade.  It also throttles nohz, which
can have substantial cost when cross CPU scheduling.

> so I think 15% cpu usage and migration event are too high, how to fixed?

You can't for free, low latency wakeup can be worth one hell of a lot.

You could do a decayed hit/miss or such to shut the thing off when the
price is just too high.  Restricting migrations per unit time per task
also helps cut the cost, but hurts tasks that could have gotten to the
CPU quicker, and started your next bit of work.  Anything you do there
is going to be a rob Peter to pay Paul thing.

-Mike

