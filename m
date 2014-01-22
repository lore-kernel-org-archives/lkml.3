Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592AbaAVNDa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 08:03:30 -0500
Received: from mail2.unitn.it ([193.205.206.22]:53486 "EHLO mail2.unitn.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755153AbaAVND2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 08:03:28 -0500
Message-ID: <52DFC196.7020301@unitn.it>
Date: Wed, 22 Jan 2014 14:03:18 +0100
From: Luca Abeni <luca.abeni@unitn.it>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Henrik Austad <henrik@austad.us>, Juri Lelli <juri.lelli@gmail.com>,
        tglx@linutronix.de, mingo@redhat.com, rostedt@goodmis.org,
        oleg@redhat.com, fweisbec@gmail.com, darren@dvhart.com,
        johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@gmail.com, liming.wang@windriver.com,
        jkacur@redhat.com, harald.gustafsson@ericsson.com,
        vincent.guittot@linaro.org, bruce.ashfield@windriver.com,
        rob@landley.net
Subject: Re: [PATCH] sched/deadline: Add sched_dl documentation
References: <1390214440-2711-1-git-send-email-juri.lelli@gmail.com> <20140120112442.GA8907@austad.us> <52DD1377.5090201@gmail.com> <20140120131616.GB8907@austad.us> <52DD2711.9080504@unitn.it> <20140121102016.GA12002@austad.us> <52DE5B7F.8020900@unitn.it> <20140121123334.GJ30183@twins.programming.kicks-ass.net> <52DE6D21.1080602@unitn.it> <20140121135559.GK30183@twins.programming.kicks-ass.net>
In-Reply-To: <20140121135559.GK30183@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 01/21/2014 02:55 PM, Peter Zijlstra wrote:
> On Tue, Jan 21, 2014 at 01:50:41PM +0100, Luca Abeni wrote:
>> On 01/21/2014 01:33 PM, Peter Zijlstra wrote:
>
>>>> - During the execution of a job, the task might invoke a blocking system call,
>>>>    and block... When it wakes up, it is still in the same job (decoding the same
>>>>    video frame), and not in a different one.
>>>> This is (IMHO) where all the confusion comes from.
>>>
>>> I would strongly urge you not to use that as an example, because its
>>> dead wrong design. An RT thread (be it RR,FIFO or DL) should _NEVER_ do
>>> blocking IO.
>> Well, but it does happen in reality :)
>
> Yeah, I know, my point was more about not encouraging people to do this
> by explicitly mentioning it.
Ok, got the point. I was not planning to add this example to the documentation
anyway, so I think there is no problem :)


>> On the other hand, I agree with you that a hard real-time task should be designed
>> not to do things like this. But SCHED_DEADLINE is flexible enough to be used on
>> many different kinds of tasks (hard real-time, soft real-time, etc...).
>
> At which point I feel obliged to mention the work Jim did on statistical
> bounded tardiness and a potential future option:
> SCHED_FLAG_DL_AVG_RUNTIME, where we would allow tasks to somewhat exceed
> their runtime budget provided that they meet their budget on average.
I think I read the paper your refer to, and if I remember well it was about
an analysis technique (using some math from queuing theory to get estimations
of the average response time, and then using Tchebysheff to transform this result
in a probabilistic real-time guarantee)... If I understand well, it does not
require modifications to the scheduling algorithm (the paper presents a multiprocessor
reservation-based scheduling algorithm, but the presented analysis applies to every
reservation-based algorithm, including SCHED_DEADLINE without modifications).
Am I misunderstanding something?

Anyway, I'll propose a documentation patch adding this paper to the references
(and if you agree I can also add some other references to probabilistic guarantees).

The SCHED_FLAG_DL_AVG_RUNTIME idea also looks interesting.

> Another possibly extension; one proposed by Ingo; is to demote tasks to
> SCHED_OTHER once they exceed their budget instead of the full block they
> get now -- we could possibly call this SCHED_FLAG_DL_CBS_SOFT or such.
I think something similar to this was mentioned in the original "resource kernels"
paper by Rajkumar and others... It is in general very useful.

Another extension I implemented "locally" (but I never submitted patches because
it is "dangerous" and potentially controversial) is the original CBS behaviour:
when a task is depleted, do not make it unschedulable, but just postpone its
scheduling deadline (decreasing its priority) and immediately recharge the
runtime. This still preserves temporal isolation between SCHED_DEADLINE tasks,
but can cause starvation of non-SCHED_DEADLINE tasks (and this is why I say this
is dangerous and can be controversial), but can be useful in some situations.


> And of course SCHED_FLAG_DL_CBS_SIGNAL, where the task gets a signal
> delivered if it exceeded the runtime -- I think some of the earlier
> patches had things like this, no?
I've seen this in some patchset, but I do not remember when. I think some of
the "advanced features" have been removed from the first submission.


>>> On the other subject; I wouldn't actually mind if it grew into a proper
>>> (academic or not) summary of deadline scheduling theory and how it
>>> applies.
>>>
>>> Sure, refer to actual papers for all the proofs and such, but it would
>>> be very good to go over all the bits and pieces that make up the system.
>>>
>>> So cover the periodic, sporadic and aperiodic model like henr_k
>>> suggested, please do cover the job/instance idiom as it is used all over
>>> the place.
>> Ok... My point was that it would be better (IMHO) to first explain how
>> sched_deadline works (and no notion of job/instance, etc is needed for this),
>> and then explain how this applies to the real-time task model (and here, of
>> course all the formal notation can be introduced).
>>
>> Do you think this can be reasonable?
>
> Sure, I think that's reasonable.
Ok, good. I am already working on this together with Juri.



			Thanks,
				Luca
