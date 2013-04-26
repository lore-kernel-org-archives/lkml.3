Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909Ab3DZNrh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 09:47:37 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:40188 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529Ab3DZNrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 09:47:35 -0400
MIME-Version: 1.0
In-Reply-To: <20130426124931.GC13464@dyad.programming.kicks-ass.net>
References: <1366910611-20048-1-git-send-email-vincent.guittot@linaro.org>
	<1366910611-20048-5-git-send-email-vincent.guittot@linaro.org>
	<20130426124931.GC13464@dyad.programming.kicks-ass.net>
Date: Fri, 26 Apr 2013 15:47:33 +0200
Message-ID: <CAKfTPtB0B8gM7C75D6EwWxQV_PRYpo+q48ywY26k8KVHx+oiqA@mail.gmail.com>
Subject: Re: [PATCH 04/14] sched: pack the idle load balance
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Ingo Molnar <mingo@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Paul Turner <pjt@google.com>, Santosh <santosh.shilimkar@ti.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Chander Kashyap <chander.kashyap@linaro.org>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Len Brown <len.brown@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Lukasz Majewski <l.majewski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 April 2013 14:49, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, Apr 25, 2013 at 07:23:20PM +0200, Vincent Guittot wrote:
>> Look for an idle CPU close to the pack buddy CPU whenever possible.
>> The goal is to prevent the wake up of a CPU which doesn't share the power
>> domain of the pack buddy CPU.
>>
>> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
>> Reviewed-by: Morten Rasmussen <morten.rasmussen@arm.com>
>> ---
>>  kernel/sched/fair.c |   19 +++++++++++++++++++
>>  1 file changed, 19 insertions(+)
>>
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index 6adc57c..a985c98 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -5469,7 +5469,26 @@ static struct {
>>
>>  static inline int find_new_ilb(int call_cpu)
>>  {
>> +     struct sched_domain *sd;
>>       int ilb = cpumask_first(nohz.idle_cpus_mask);
>> +     int buddy = per_cpu(sd_pack_buddy, call_cpu);
>> +
>> +     /*
>> +      * If we have a pack buddy CPU, we try to run load balance on a CPU
>> +      * that is close to the buddy.
>> +      */
>> +     if (buddy != -1) {
>> +             for_each_domain(buddy, sd) {
>> +                     if (sd->flags & SD_SHARE_CPUPOWER)
>> +                             continue;
>> +
>> +                     ilb = cpumask_first_and(sched_domain_span(sd),
>> +                                     nohz.idle_cpus_mask);
>> +
>> +                     if (ilb < nr_cpu_ids)
>> +                             break;
>> +             }
>> +     }
>>
>>       if (ilb < nr_cpu_ids && idle_cpu(ilb))
>>               return ilb;
>
> Ha! and here you hope people won't put multiple big-little clusters in a single
> machine? :-)

yes, we will probably face this situation sooner or later but the
other little clusters will probably be not less close than the local
big cluster from a power domain point of view.
That's why i look for the small sched_domain level to the largest one

>
>
>
