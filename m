Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934193AbaE3Uum (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 16:50:42 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:38275 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756251AbaE3Uuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 16:50:40 -0400
MIME-Version: 1.0
In-Reply-To: <53888FF0.4020403@arm.com>
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
 <1400860385-14555-5-git-send-email-vincent.guittot@linaro.org> <53888FF0.4020403@arm.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Fri, 30 May 2014 22:50:20 +0200
Message-ID: <CAKfTPtB+2dsHjZw=KkYgbP4EnPebLjfdNeVDAStXFJ2h8wbm+g@mail.gmail.com>
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

On 30 May 2014 16:04, Dietmar Eggemann <dietmar.eggemann@arm.com> wrote:
> On 23/05/14 16:52, Vincent Guittot wrote:
>> power_orig is only changed for system with a SMT sched_domain level in order to
>> reflect the lower capacity of CPUs. Heterogenous system also have to reflect an
>> original capacity that is different from the default value.
>>
>> Create a more generic function arch_scale_cpu_power that can be also used by
>> non SMT platform to set power_orig.
>>
>> The weak behavior of arch_scale_cpu_power is the previous SMT one in order to
>> keep backward compatibility in the use of power_orig.
>>
>> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
>
> As you know, besides uarch scaled cpu power for HMP, freq scaled cpu
> power is important for energy-aware scheduling to achieve freq scale
> invariance for task load.
>
> I know that your patch-set is not about introducing freq scaled cpu
> power, but we were discussing how this can be achieved w/ your patch-set
> in place, so maybe you can share your opinion regarding the easiest way
> to achieve freq scale invariance with us?
>
> (1) We assume that the current way (update_cpu_power() calls
> arch_scale_freq_power() to get the avg power(freq) over the time period
> since the last call to arch_scale_freq_power()) is suitable
> for us. Do you have another opinion here?

Using power (or power_freq as you mentioned below) is probably the
easiest and more straight forward solution. You can use it to scale
each element when updating entity runnable.
Nevertheless, I see to 2 potential issues:
- is power updated often enough to correctly follow the frequency
scaling ? we need to compare power update frequency with
runnable_avg_sum variation speed and the rate at which we will change
the CPU's frequency.
- the max value of runnable_avg_sum will be also scaled so a task
running on a CPU with less capacity could be seen as a "low" load even
if it's an always running tasks. So we need to find a way to reach the
max value for such situation

>
> (2) Is the current layout of update_cpu_power() adequate for this, where
> we scale power_orig related to freq and then related to rt/(irq):
>
>   power_orig = scale_cpu(SCHED_POWER_SCALE)
>   power = scale_rt(scale_freq(power_orig))
>
> or do we need an extra power_freq data member on the rq and do:
>
>   power_orig = scale_cpu(SCHED_POWER_SCALE)
>   power_freq = scale_freq(power_orig))
>   power = scale_rt(power_orig))

do you really mean power = scale_rt(power_orig) or power=scale_rt(power_freq) ?

>
> In other words, do we consider rt/(irq) pressure when calculating freq
> scale invariant task load or not?

we should take power_freq which implies a new field

Thanks,
Vincent
>
> Thanks,
>
> -- Dietmar
> [...]
>
