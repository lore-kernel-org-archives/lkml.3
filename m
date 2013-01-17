Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083Ab3AQFrW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 00:47:22 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:47096 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754859Ab3AQFrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 00:47:19 -0500
X-AuditID: 9c930197-b7b76ae000000e7d-94-50f7906427c4
From: Namhyung Kim <namhyung@kernel.org>
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: Alex Shi <alex.shi@intel.com>, "mingo\@redhat.com" <mingo@redhat.com>,
        "peterz\@infradead.org" <peterz@infradead.org>,
        "tglx\@linutronix.de" <tglx@linutronix.de>,
        "akpm\@linux-foundation.org" <akpm@linux-foundation.org>,
        "arjan\@linux.intel.com" <arjan@linux.intel.com>,
        "bp\@alien8.de" <bp@alien8.de>, "pjt\@google.com" <pjt@google.com>,
        "efault\@gmx.de" <efault@gmx.de>,
        "vincent.guittot\@linaro.org" <vincent.guittot@linaro.org>,
        "gregkh\@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "preeti\@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 16/22] sched: add power aware scheduling in fork/exec/wake
References: <1357375071-11793-1-git-send-email-alex.shi@intel.com>
	<1357375071-11793-17-git-send-email-alex.shi@intel.com>
	<20130110150108.GF2046@e103034-lin> <50EFBA7D.5070907@intel.com>
	<20130114160934.GA8528@e103034-lin> <50F6426D.7030201@intel.com>
	<20130116142730.GA30805@e103034-lin>
Date: Thu, 17 Jan 2013 14:47:16 +0900
In-Reply-To: <20130116142730.GA30805@e103034-lin> (Morten Rasmussen's message
	of "Wed, 16 Jan 2013 14:27:30 +0000")
Message-ID: <87fw20l5sr.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jan 2013 14:27:30 +0000, Morten Rasmussen wrote:
> On Wed, Jan 16, 2013 at 06:02:21AM +0000, Alex Shi wrote:
>> On 01/15/2013 12:09 AM, Morten Rasmussen wrote:
>> > On Fri, Jan 11, 2013 at 07:08:45AM +0000, Alex Shi wrote:
>> >> On 01/10/2013 11:01 PM, Morten Rasmussen wrote:
>> >> For power consideration scenario, it ask task number less than Lcpu
>> >> number, don't care the load weight, since whatever the load weight, the
>> >> task only can burn one LCPU.
>> >>
>> > 
>> > True, but you miss the opportunities for power saving when you have many
>> > light tasks (> LCPU). Currently, the sd_utils < threshold check will go
>> > for SCHED_POLICY_PERFORMANCE if the number tasks (sd_utils) is greater
>> > than the domain weight/capacity irrespective of the actual load caused
>> > by those tasks.
>> > 
>> > If you used tracked task load weight for sd_utils instead you would be
>> > able to go for power saving in scenarios with many light tasks as well.
>> 
>> yes, that's right on power consideration. but for performance consider,
>> it's better to spread tasks on different LCPU to save CS cost. And if
>> the cpu usage is nearly full, we don't know if some tasks real want more
>> cpu time.
>
> If the cpu is nearly full according to its tracked load it should not be
> used for packing more tasks. It is the nearly idle scenario that I am
> more interested in. If you have lots of task with tracked load <10% then
> why not pack them. The performance impact should be minimal.
>
> Furthermore, nr_running is just a snapshot of the current runqueue
> status. The combination of runnable and blocked load should give a
> better overall view of the cpu loads.

I have a feeling that power aware scheduling policy has to deal only
with the utilization.  Of course it only works under a certain threshold
and if it's exceeded must be changed to other policy which cares the
load weight/average.  Just throwing an idea. :)

>
>> Even in the power sched policy, we still want to get better performance
>> if it's possible. :)
>
> I agree if it comes for free in terms of power. In my opinion it is
> acceptable to sacrifice a bit of performance to save power when using a
> power sched policy as long as the performance regression can be
> justified by the power savings. It will of course depend on the system
> and its usage how trade-off power and performance. My point is just that
> with multiple sched policies (performance, balance and power as you
> propose) it should be acceptable to focus on power for the power policy
> and let users that only/mostly care about performance use the balance or
> performance policy.

Agreed.

>
>> > 
>> >>>> +
>> >>>> +		if (sched_policy == SCHED_POLICY_POWERSAVING)
>> >>>> +			threshold = sgs.group_weight;
>> >>>> +		else
>> >>>> +			threshold = sgs.group_capacity;
>> >>>
>> >>> Is group_capacity larger or smaller than group_weight on your platform?
>> >>
>> >> Guess most of your confusing come from the capacity != weight here.
>> >>
>> >> In most of Intel CPU, a cpu core's power(with 2 HT) is usually 1178, it
>> >> just bigger than a normal cpu power - 1024. but the capacity is still 1,
>> >> while the group weight is 2.
>> >>
>> > 
>> > Thanks for clarifying. To the best of my knowledge there are no
>> > guidelines for how to specify cpu power so it may be a bit dangerous to
>> > assume that capacity < weight when capacity is based on cpu power.
>> 
>> Sure. I also just got them from code. and don't know other arch how to
>> different them.
>> but currently, seems this cpu power concept works fine.
>
> Yes, it seems to work fine for your test platform. I just want to
> highlight that the assumption you make might not be valid for other
> architectures. I know that cpu power is not widely used, but that may
> change with the increasing focus on power aware scheduling.

AFAIK on ARM big.LITTLE, a big cpu will have a cpu power more than
1024.  I'm sure Morten knows way more than me on this. :)

Thanks,
Namhyung
