Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbaKXKQb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 05:16:31 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:56866 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347AbaKXKQa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 05:16:30 -0500
MIME-Version: 1.0
In-Reply-To: <54713254.9020601@gmail.com>
References: <1412684017-16595-1-git-send-email-vincent.guittot@linaro.org>
 <1412684017-16595-7-git-send-email-vincent.guittot@linaro.org>
 <20141009121643.GQ4750@worktop.programming.kicks-ass.net> <CAKfTPtCX687FkGgxLO7spfGvDxhDWeFDERLRZ-NakO2Jrpmnhw@mail.gmail.com>
 <54713254.9020601@gmail.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Mon, 24 Nov 2014 11:16:09 +0100
Message-ID: <CAKfTPtDspf4ozpejACB8Lrc2B7vmF1sN28+H+iGnCsQs_k3L4w@mail.gmail.com>
Subject: Re: [PATCH v7 6/7] sched: replace capacity_factor by usage
To: Wanpeng Li <kernellwp@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Rik van Riel <riel@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Paul Turner <pjt@google.com>, Benjamin Segall <bsegall@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 November 2014 at 02:03, Wanpeng Li <kernellwp@gmail.com> wrote:
> Hi Vincent,
> On 10/9/14, 10:18 PM, Vincent Guittot wrote:
>>
>> On 9 October 2014 14:16, Peter Zijlstra <peterz@infradead.org> wrote:
>>>
>>> On Tue, Oct 07, 2014 at 02:13:36PM +0200, Vincent Guittot wrote:
>>>>
>>>> +static inline bool
>>>> +group_has_capacity(struct lb_env *env, struct sg_lb_stats *sgs)
>>>>   {
>>>> +     if ((sgs->group_capacity * 100) >
>>>> +                     (sgs->group_usage * env->sd->imbalance_pct))
>>>> +             return true;
>>>
>>> Why the imb_pct there? We're looking for 100% utilization, not 130 or
>>> whatnot, right?
>>
>> Having exactly 100% is quite difficult because of various rounding.
>
>
> Could you give some examples about the various rounding？

As an example while I was monitoring the runnable_load_sum and the
runnable_load_period, they were varying a bit around the max value but
was not always the same which can change the load_avg_contrib by few
unit

Regards,
Vincent

>
> Regards,
> Wanpeng Li
>
>> So i have added a margin/threshold to prevent any excessive change of the
>> state.
>> I have just to use the same margin/threshold than in other place in
>> load balance.
>>
>> so the current threshold depends of the sched_level. it's around 14% at MC
>> level
>>
>>>> +     if (sgs->sum_nr_running < sgs->group_weight)
>>>> +             return true;
>>>
>>> With the code as it stands, this is the cheaper test (no mults) so why
>>> is it second?
>>>
>>>> +     return false;
>>>> +}
>>>>
>>>> +static inline bool
>>>> +group_is_overloaded(struct lb_env *env, struct sg_lb_stats *sgs)
>>>> +{
>>>> +     if (sgs->sum_nr_running <= sgs->group_weight)
>>>> +             return false;
>>>> +
>>>> +     if ((sgs->group_capacity * 100) <
>>>> +                     (sgs->group_usage * env->sd->imbalance_pct))
>>>> +             return true;
>>>>
>>>> +     return false;
>>>>   }
>>>
>>> Same thing here wrt imb_pct
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
>
