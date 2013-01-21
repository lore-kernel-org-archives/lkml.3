Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782Ab3AUHeO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 02:34:14 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:60020 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab3AUHeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 02:34:13 -0500
Message-ID: <50FCEF6C.6010801@linux.vnet.ibm.com>
Date: Mon, 21 Jan 2013 15:34:04 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Mike Galbraith <bitbucket@online.de>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, peterz@infradead.org,
        mingo@kernel.org, a.p.zijlstra@chello.nl
Subject: Re: [RFC PATCH 0/2] sched: simplify the select_task_rq_fair()
References: <1356588535-23251-1-git-send-email-wangyun@linux.vnet.ibm.com> <50ED384C.1030301@linux.vnet.ibm.com> <1357977704.6796.47.camel@marge.simpson.net> <1357985943.6796.55.camel@marge.simpson.net> <1358155290.5631.19.camel@marge.simpson.net> <50F79256.1010900@linux.vnet.ibm.com> <1358654997.5743.17.camel@marge.simpson.net> <50FCACE3.5000706@linux.vnet.ibm.com> <1358743128.4994.33.camel@marge.simpson.net> <50FCCCF5.30504@linux.vnet.ibm.com> <1358750523.4994.55.camel@marge.simpson.net>
In-Reply-To: <1358750523.4994.55.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012107-2674-0000-0000-0000078A34CB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2013 02:42 PM, Mike Galbraith wrote:
> On Mon, 2013-01-21 at 13:07 +0800, Michael Wang wrote:
> 
>> That seems like the default one, could you please show me the numbers in
>> your datapoint file?
> 
> Yup, I do not touch the workfile.  Datapoints is what you see in the
> tabulated result...
> 
> 1
> 1
> 1
> 5
> 5
> 5
> 10
> 10
> 10
> ...
> 
> so it does three consecutive runs at each load level.  I quiesce the
> box, set governor to performance, echo 250 32000 32 4096
>> /proc/sys/kernel/sem, then ./multitask -nl -f, and point it
> at ./datapoints.

I have changed the "/proc/sys/kernel/sem" to:

2000    2048000 256     1024

and run few rounds, seems like I can't reproduce this issue on my 12 cpu
X86 server:

	prev		post
Tasks    jobs/min  	jobs/min
    1      508.39    	506.69
    5     2792.63   	2792.63
   10     5454.55   	5449.64
   20    10262.49  	10271.19
   40    18089.55  	18184.55
   80    28995.22  	28960.57
  160    41365.19  	41613.73
  320    53099.67  	52767.35
  640    61308.88  	61483.83
 1280    66707.95  	66484.96
 2560    69736.58  	69350.02

Almost nothing changed...I would like to find another machine and do the
test again later.

> 
>> I'm not familiar with this benchmark, but I'd like to have a try on my
>> server, to make sure whether it is a generic issue.
> 
> One thing I didn't like about your changes is that you don't ask
> wake_affine() if it's ok to pull cross node or not, which I though might
> induce imbalance, but twiddling that didn't fix up the collapse, pretty
> much leaving only the balance path.

wake_affine() will be asked before trying to use the idle sibling
selected from current cpu's domain, doesn't it? It's just been delayed
since it's cost is too high.

But you notified me that I missed the case when prev == current, not
sure whether it's the killer, but will correct it.

> 
>>>> And I'm confusing about how those new parameter value was figured out
>>>> and how could them help solve the possible issue?
>>>
>>> Oh, that's easy.  I set sched_min_granularity_ns such that last_buddy
>>> kicks in when a third task arrives on a runqueue, and set
>>> sched_wakeup_granularity_ns near minimum that still allows wakeup
>>> preemption to occur.  Combined effect is reduced over-scheduling.
>>
>> That sounds very hard, to catch the timing, whatever, it could be an
>> important clue for analysis.
> 
> (Play with the knobs with a bunch of different loads, I think you'll
> find that those settings work well)
> 
>>>> Do you have any idea about which part in this patch set may cause the issue?
>>>
>>> Nope, I'm as puzzled by that as you are.  When the box had 40 cores,
>>> both virgin and patched showed over-scheduling effects, but not like
>>> this.  With 20 cores, symptoms changed in a most puzzling way, and I
>>> don't see how you'd be directly responsible.
>>
>> Hmm...
>>
>>>
>>>> One change by designed is that, for old logical, if it's a wake up and
>>>> we found affine sd, the select func will never go into the balance path,
>>>> but the new logical will, in some cases, do you think this could be a
>>>> problem?
>>>
>>> Since it's the high load end, where looking for an idle core is most
>>> likely to be a waste of time, it makes sense that entering the balance
>>> path would hurt _some_, it isn't free.. except for twiddling preemption
>>> knobs making the collapse just go away.  We're still going to enter that
>>> path if all cores are busy, no matter how I twiddle those knobs.
>>
>> May be we could try change this back to the old way later, after the aim
>> 7 test on my server.
> 
> Yeah, something funny is going on.  I'd like select_idle_sibling() to
> just go away, that task be integrated into one and only one short and
> sweet balance path.  I don't see why fine_idlest* needs to continue
> traversal after seeing a zero.  
It should be just fine to say gee, we're
> done.  

Yes, that's true :)

Hohum, so much for pure test and report, twiddle twiddle tweak,
> bend spindle mutilate ;-) 

Scheduler is impossible to be analysis some time, the only way to prove
is the painful endless testing...and usually, we still missed some thing
in the end...

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

