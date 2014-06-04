Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589AbaFDLQV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 07:16:21 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:50850 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294AbaFDLQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 07:16:20 -0400
MIME-Version: 1.0
In-Reply-To: <538EE9E9.7090605@arm.com>
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
 <1400860385-14555-5-git-send-email-vincent.guittot@linaro.org>
 <53888FF0.4020403@arm.com> <CAKfTPtB+2dsHjZw=KkYgbP4EnPebLjfdNeVDAStXFJ2h8wbm+g@mail.gmail.com>
 <538EE9E9.7090605@arm.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Wed, 4 Jun 2014 13:15:59 +0200
Message-ID: <CAKfTPtB9bh1_ZeQSFsC2eoBaytDBNcmn8ZZpY7Weqxui75Z2kA@mail.gmail.com>
Subject: Re: [PATCH v2 04/11] sched: Allow all archs to set the power_orig
To: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "efault@gmx.de" <efault@gmx.de>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 June 2014 11:42, Dietmar Eggemann <dietmar.eggemann@arm.com> wrote:
> [...]
>>> (1) We assume that the current way (update_cpu_power() calls
>>> arch_scale_freq_power() to get the avg power(freq) over the time period
>>> since the last call to arch_scale_freq_power()) is suitable
>>> for us. Do you have another opinion here?
>>
>> Using power (or power_freq as you mentioned below) is probably the
>> easiest and more straight forward solution. You can use it to scale
>> each element when updating entity runnable.
>> Nevertheless, I see to 2 potential issues:
>> - is power updated often enough to correctly follow the frequency
>> scaling ? we need to compare power update frequency with
>> runnable_avg_sum variation speed and the rate at which we will change
>> the CPU's frequency.
>> - the max value of runnable_avg_sum will be also scaled so a task
>> running on a CPU with less capacity could be seen as a "low" load even
>> if it's an always running tasks. So we need to find a way to reach the
>> max value for such situation
>
> I think I mixed two problems together here:
>
> Firstly, we need to scale cpu power in update_cpu_power() regarding
> uArch, frequency and rt/irq pressure.
> Here the freq related value we get back from arch_scale_freq_power(...,
> cpu) could be an instantaneous value (curr_freq(cpu)/max_freq(cpu)).
>
> Secondly, to be able to scale the runnable avg sum of a sched entity
> (se->avg->runnable_avg_sum), we preferable have a coefficient
> representing uArch diffs (cpu_power_orig(cpu)/cpu_power_orig(most
> powerful cpu in the system) and another coefficient (avg freq over 'now

AFAICT, the coefficient representing uArch diffs is already taken into
account into power_freq thanks to scale_cpu, isn't it ?

> - sa->last_runnable_update'(cpu)/max_freq(cpu). This value would have to
> be retrieved from the arch in __update_entity_runnable_avg().
>
>>> (2) Is the current layout of update_cpu_power() adequate for this, where
>>> we scale power_orig related to freq and then related to rt/(irq):
>>>
>>>   power_orig = scale_cpu(SCHED_POWER_SCALE)
>>>   power = scale_rt(scale_freq(power_orig))
>>>
>>> or do we need an extra power_freq data member on the rq and do:
>>>
>>>   power_orig = scale_cpu(SCHED_POWER_SCALE)
>>>   power_freq = scale_freq(power_orig))
>>>   power = scale_rt(power_orig))
>>
>> do you really mean power = scale_rt(power_orig) or power=scale_rt(power_freq) ?
>
> No, I also think that power=scale_rt(power_freq) is correct.
>
>>> In other words, do we consider rt/(irq) pressure when calculating freq
>>> scale invariant task load or not?
>>
>> we should take power_freq which implies a new field
> [...]
>
