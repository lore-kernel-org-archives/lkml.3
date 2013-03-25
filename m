Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551Ab3CYKVW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 06:21:22 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:56420 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755728Ab3CYKVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 06:21:21 -0400
Message-ID: <51502513.6010607@linux.vnet.ibm.com>
Date: Mon, 25 Mar 2013 18:21:07 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@kernel.org>, Alex Shi <alex.shi@intel.com>,
        Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Subject: Re: [RFC PATCH] sched: wake-affine throttle
References: <514FDF76.2060806@linux.vnet.ibm.com> <1364203359.4559.66.camel@marge.simpson.net>
In-Reply-To: <1364203359.4559.66.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032510-0260-0000-0000-000002B780CA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Mike

Thanks for your reply :)

On 03/25/2013 05:22 PM, Mike Galbraith wrote:
> On Mon, 2013-03-25 at 13:24 +0800, Michael Wang wrote: 
>> Recently testing show that wake-affine stuff cause regression on pgbench, the
>> hiding rat was finally catched out.
>>
>> wake-affine stuff is always trying to pull wakee close to waker, by theory,
>> this will benefit us if waker's cpu cached hot data for wakee, or the extreme
>> ping-pong case.
>>
>> However, the whole stuff is somewhat blindly, there is no examining on the
>> relationship between waker and wakee, and since the stuff itself
>> is time-consuming, some workload suffered, pgbench is just the one who
>> has been found.
>>
>> Thus, throttle the wake-affine stuff for such workload is necessary.
>>
>> This patch introduced a new knob 'sysctl_sched_wake_affine_interval' with the
>> default value 1ms, which means wake-affine stuff only effect once per 1ms, which
>> usually the minimum balance interval (the idea is that the rapid of wake-affine
>> should lower than the rapid of load-balance at least).
>>
>> By turning the new knob, those workload who suffered will have the chance to
>> stop the regression.
> 
> I wouldn't do it quite this way.  Per task, yes (I suggested that too,
> better agree;), but for one, using jiffies in the scheduler when we have
> a spiffy clock sitting there ready to use seems wrong,

Well, I get the approach from load-balance code, this is one existed way
to play interval stuff, just try to keep consistent...

 and secondly,
> when you've got a bursty load, not pulling can hurt like hell.  Alex
> encountered that while working on his patch set.
> 
>> Test:
>> 	Test with 12 cpu X86 server and tip 3.9.0-rc2.
>>
>> 	Default 1ms interval bring limited performance improvement(<5%) for
>> 	pgbench, significant improvement start to show when turning the
>> 	knob to 100ms.
> 
> So it seems you'd be better served by an on/off switch for this load.
> 100ms in the future for many tasks is akin to a human todo list entry
> scheduled for Solar radius >= Earth orbital radius day ;-)

Do you mean 1ms interval is still too big? and you prefer to have a 0
option?

> 
>> 			    original	100ms	
>>
>> 	| db_size | clients |  tps  |	|  tps  |
>> 	+---------+---------+-------+   +-------+
>> 	| 21 MB   |       1 | 10572 |   | 10675 |
>> 	| 21 MB   |       2 | 21275 |   | 21228 |
>> 	| 21 MB   |       4 | 41866 |   | 41946 |
>> 	| 21 MB   |       8 | 53931 |   | 55176 |
>> 	| 21 MB   |      12 | 50956 |   | 54457 |	+6.87%
>> 	| 21 MB   |      16 | 49911 |   | 55468 |	+11.11%
>> 	| 21 MB   |      24 | 46046 |   | 56446 |	+22.59%
>> 	| 21 MB   |      32 | 43405 |   | 55177 |	+27.12%
>> 	| 7483 MB |       1 |  7734 |   |  7721 |
>> 	| 7483 MB |       2 | 19375 |   | 19277 |
>> 	| 7483 MB |       4 | 37408 |   | 37685 |
>> 	| 7483 MB |       8 | 49033 |   | 49152 |
>> 	| 7483 MB |      12 | 45525 |   | 49241 |	+8.16%
>> 	| 7483 MB |      16 | 45731 |   | 51425 |	+12.45%
>> 	| 7483 MB |      24 | 41533 |   | 52349 |	+26.04%
>> 	| 7483 MB |      32 | 36370 |   | 51022 |	+40.28%
>> 	| 15 GB   |       1 |  7576 |   |  7422 |
>> 	| 15 GB   |       2 | 19157 |   | 19176 |
>> 	| 15 GB   |       4 | 37285 |   | 36982 |
>> 	| 15 GB   |       8 | 48718 |   | 48413 |
>> 	| 15 GB   |      12 | 45167 |   | 48497 |	+7.37%
>> 	| 15 GB   |      16 | 45270 |   | 51276 |	+13.27%
>> 	| 15 GB   |      24 | 40984 |   | 51628 |	+25.97%
>> 	| 15 GB   |      32 | 35918 |   | 51060 |	+42.16%
> 
> The benefit you get with not pulling is two fold at least, first and
> foremost it keeps the forked off clients the hell away from the mother
> of all work so it can keep the kids fed.  Second, you keep the load
> spread out, which is the only way the full box sized load can possibly
> perform in the first place.  The full box benefit seems clear from the
> numbers.. hard working server can compete best for its share when it's
> competing against the same set of clients, that's likely why you have to
> set the knob to 100ms to get the big win.

Actually the 10ms will also get around 27% improvement at most, I use
100ms since it looks more significant...

I haven't tried the interval between 1 and 10, but I suppose the benefit
could be some kind of parabola, it's not a suddenly change, but smoothly.

> 
> With small burst loads of short running tasks, even things like pgbench
> will benefit from pulling to local llc more frequently than 100ms, iff
> burst does not exceed socket size.  That pulling is not completely evil,
> it automagically consolidates your mostly idle NUMA box to it's most
> efficient task placement for both power saving and throughput, so IMHO,
> you can't just let tasks sit cross node over ~extended idle periods
> without doing harm.

I see, and actually that's the reason for this proposal, it's just try
to reserve all the possible benefit of wake-affine, and provide a way to
control the rapid.

I think your point here is still that we need a 0 option, it that correct?

> 
> OTOH, if the box is mostly busy, or if there's only one llc, per task
> pick a smallish number is dirt simple, and should be a general case
> improvement over the overly 1:1 buddy centric current behavior.
> 
> Have you tried the patch set by Alex Shi?   In my fiddling with them,
> they put a very big dent in the evil side of select_idle_sibling() and
> affine wakeups in general, and should help pgbench and ilk heaping
> truckloads.

I haven't tried yet, whatever, a way to throttle the wake-affine is
necessary, since we have the proof that it will damage some workload.

OTOH, by theory, we have the chance to pull none-related tasks together,
and we can't promise this will help the system all the time, don't we?

Regards,
Michael Wang

> 
> -Mike
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

