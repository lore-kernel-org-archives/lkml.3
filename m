Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364AbaJIOSb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 10:18:31 -0400
Received: from mail-oi0-f51.google.com ([209.85.218.51]:34963 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbaJIOSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 10:18:23 -0400
MIME-Version: 1.0
In-Reply-To: <20141009121643.GQ4750@worktop.programming.kicks-ass.net>
References: <1412684017-16595-1-git-send-email-vincent.guittot@linaro.org>
 <1412684017-16595-7-git-send-email-vincent.guittot@linaro.org> <20141009121643.GQ4750@worktop.programming.kicks-ass.net>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Thu, 9 Oct 2014 16:18:02 +0200
Message-ID: <CAKfTPtCX687FkGgxLO7spfGvDxhDWeFDERLRZ-NakO2Jrpmnhw@mail.gmail.com>
Subject: Re: [PATCH v7 6/7] sched: replace capacity_factor by usage
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 October 2014 14:16, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Oct 07, 2014 at 02:13:36PM +0200, Vincent Guittot wrote:
>> +static inline bool
>> +group_has_capacity(struct lb_env *env, struct sg_lb_stats *sgs)
>>  {
>> +     if ((sgs->group_capacity * 100) >
>> +                     (sgs->group_usage * env->sd->imbalance_pct))
>> +             return true;
>
> Why the imb_pct there? We're looking for 100% utilization, not 130 or
> whatnot, right?

Having exactly 100% is quite difficult because of various rounding.
So i have added a margin/threshold to prevent any excessive change of the state.
I have just to use the same margin/threshold than in other place in
load balance.

so the current threshold depends of the sched_level. it's around 14% at MC level

>
>> +     if (sgs->sum_nr_running < sgs->group_weight)
>> +             return true;
>
> With the code as it stands, this is the cheaper test (no mults) so why
> is it second?
>
>> +     return false;
>> +}
>>
>> +static inline bool
>> +group_is_overloaded(struct lb_env *env, struct sg_lb_stats *sgs)
>> +{
>> +     if (sgs->sum_nr_running <= sgs->group_weight)
>> +             return false;
>> +
>> +     if ((sgs->group_capacity * 100) <
>> +                     (sgs->group_usage * env->sd->imbalance_pct))
>> +             return true;
>>
>> +     return false;
>>  }
>
> Same thing here wrt imb_pct
