Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779AbaFPJBd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 05:01:33 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:64337 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351AbaFPJBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 05:01:30 -0400
MIME-Version: 1.0
In-Reply-To: <53903169.3030404@arm.com>
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
 <1400860385-14555-5-git-send-email-vincent.guittot@linaro.org>
 <53888FF0.4020403@arm.com> <CAKfTPtB+2dsHjZw=KkYgbP4EnPebLjfdNeVDAStXFJ2h8wbm+g@mail.gmail.com>
 <538EE9E9.7090605@arm.com> <CAKfTPtB9bh1_ZeQSFsC2eoBaytDBNcmn8ZZpY7Weqxui75Z2kA@mail.gmail.com>
 <53903169.3030404@arm.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Mon, 16 Jun 2014 11:01:10 +0200
Message-ID: <CAKfTPtDLkpYaiC0HFxc=1STt4VWujUYk16ZhcFLxsB1gb2yGKg@mail.gmail.com>
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
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        Mike Turquette <mturquette@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 June 2014 10:59, Dietmar Eggemann <dietmar.eggemann@arm.com> wrote:
> [...]
>>> Firstly, we need to scale cpu power in update_cpu_power() regarding
>>> uArch, frequency and rt/irq pressure.
>>> Here the freq related value we get back from arch_scale_freq_power(...,
>>> cpu) could be an instantaneous value (curr_freq(cpu)/max_freq(cpu)).
>>>
>>> Secondly, to be able to scale the runnable avg sum of a sched entity
>>> (se->avg->runnable_avg_sum), we preferable have a coefficient
>>> representing uArch diffs (cpu_power_orig(cpu)/cpu_power_orig(most
>>> powerful cpu in the system) and another coefficient (avg freq over 'now
>>
>> AFAICT, the coefficient representing uArch diffs is already taken into
>> account into power_freq thanks to scale_cpu, isn't it ?
>
> True, but I can't see how the current signature of
> arch_scale_cpu_power() and arch_scale_freq_power() fit into this uArch
> and freq invariant updating of se->avg->runnable_avg_sum business.

My 1st assumption is that the update of rq->cpu_power (or
rq->cpu_power_freq as we discussed earlier) is fast enough compare to
frequency scaling so that it can be used to scale the load without
major error. In this case, you can use the cpu_power_orig, cpu_power
fields. The update period of cpu_power is equal balance_interval
which is initialized with the weight of the sched_domain (less or
equal to 4ms for most of ARM platform). Most of ARM platforms use a
100 HZ jiffies so the update period will be aligned to 10ms (1 tick).

If this update is not fast enough, the second possibility could be to
directly access to current frequency (or something that represent it).
This might be possible once the cpufreq will have been consolidated
into the scheduler similarly to what is going with cpuidle

Vincent

>
>>> - sa->last_runnable_update'(cpu)/max_freq(cpu). This value would have to
>>> be retrieved from the arch in __update_entity_runnable_avg().
>>>
> [...]
>
