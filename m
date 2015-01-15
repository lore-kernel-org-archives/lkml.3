Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbbAONfw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 08:35:52 -0500
Received: from mail3.unitn.it ([193.205.206.24]:64189 "EHLO mail3.unitn.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752709AbbAONfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 08:35:51 -0500
Message-ID: <54B7C232.8060806@unitn.it>
Date: Thu, 15 Jan 2015 14:35:46 +0100
From: Luca Abeni <luca.abeni@unitn.it>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Kirill Tkhai <tkhai@yandex.ru>, Juri Lelli <juri.lelli@arm.com>,
        Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "juri.lelli@gmail.com" <juri.lelli@gmail.com>
Subject: Re: Another SCHED_DEADLINE bug (with bisection and possible fix)
References: <2629881420411885@web9m.yandex.ru> <54AAABFB.3060109@unitn.it> <1420499241.3361.14.camel@yandex.ru> <20150107080155.1d42d123@luca-1225C> <1420633741.12772.10.camel@yandex.ru> <54B4D2DF.9010308@arm.com> <4500351421141200@web2m.yandex.ru> <20150113140436.GI25256@twins.programming.kicks-ass.net> <4632021421239387@web25g.yandex.ru> <54B7A33F.20904@unitn.it> <20150115122323.GU23965@worktop.programming.kicks-ass.net>
In-Reply-To: <20150115122323.GU23965@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On 01/15/2015 01:23 PM, Peter Zijlstra wrote:
> On Thu, Jan 15, 2015 at 12:23:43PM +0100, Luca Abeni wrote:
>> There are some parts of the patch that I do not understand (for example:
>> if I understand well, if the task is not throttled you set dl_new to 1...
>> And if it is throttled you change its current runtime and scheduling deadline...
>> Why?)
>> Anyway, I tested the patch and I confirm that it fixes the hang I originally
>> reported.
>
> I'll go look at the patch in a wee bit. But Juri, Luca, could you
> describe the correct behaviour?
>
>>From what I understand we should either modify the tasks run/sleep stats
> when we change its parameters or we should schedule a delayed release of
> the bandwidth delta (when it reaches its 0-lag point, if thats in the
> future).
I suspect the correct behaviour can be difficult to implement:
- When a SCHED_DEADLINE task ends (or changes its scheduling policy to
   something different), its bandwidth cannot be released immediately,
   but should be released at the "0-lag time" (which reminds me about the
   GRUB patches... I had to implement a similar behaviour in those patches :)
- The same applies when the task changes its scheduling parameters decreasing
   its bandwidth. In this case, we also need to update the current runtime (if
   it is larger than the new runtime, set it to the new maximum value - I think
   this is the safest thing to do)
- When a task changes its parameters to increase its bandwidth, be do not
   have such problems.

As far as I can see, if we apply the runtime / deadline changes starting from
the next reservation period we are safe (because the "0-lag time" is always
smaller than the current scheduling deadline).
This might cause some transient overloads (because if I change the parameters
of a task at time t, the update takes action a little bit later - at the next
scheduling deadline), but guarantees that a task never consumes more than
expected (for example: if a task continuously changes its bandwidth between
0.4 and 0.3, it will never consume more than 0.4. I suspect that if we
immediately update dl_se->deadline and dl_se->runtime a task can arrive to
consume much more CPU time).


				Luca

>
> Doing neither will allow one to game the reservation system afaict.
>

