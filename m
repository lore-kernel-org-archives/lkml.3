Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877AbaBTJPf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 04:15:35 -0500
Received: from mail-ve0-f178.google.com ([209.85.128.178]:40246 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162AbaBTJP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 04:15:27 -0500
MIME-Version: 1.0
In-Reply-To: <20140220085017.GL6835@laptop.programming.kicks-ass.net>
References: <1392787230-17986-1-git-send-email-leiwen@marvell.com>
	<20140219090415.GK27965@twins.programming.kicks-ass.net>
	<CALZhoSQpbJGSEaoOKO_sQQNFBU9UHYQ4bPCXEFfAz=iUm+D7_g@mail.gmail.com>
	<20140220085017.GL6835@laptop.programming.kicks-ass.net>
Date: Thu, 20 Feb 2014 17:15:26 +0800
Message-ID: <CALZhoSSOWE54X8rAz-2VMhYN-N_3rzthTfRvTQcA5_dQqgoA3w@mail.gmail.com>
Subject: Re: [PATCH] sched: keep quiescent cpu out of idle balance loop
From: Lei Wen <adrian.wenl@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Lei Wen <leiwen@marvell.com>, mingo@redhat.com, preeti.lkml@gmail.com,
        daniel.lezcano@linaro.org, viresh.kumar@linaro.org, xjian@marvell.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 4:50 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, Feb 20, 2014 at 10:42:51AM +0800, Lei Wen wrote:
>> >> -     int ilb = cpumask_first(nohz.idle_cpus_mask);
>> >> +     int ilb;
>> >> +     int cpu = smp_processor_id();
>> >> +     struct sched_domain *tmp;
>> >>
>> >> -     if (ilb < nr_cpu_ids && idle_cpu(ilb))
>> >> -             return ilb;
>> >> +     for_each_domain(cpu, tmp) {
>> >> +             ilb = cpumask_first_and(nohz.idle_cpus_mask,
>> >> +                             sched_domain_span(tmp));
>> >> +             if (ilb < nr_cpu_ids && idle_cpu(ilb))
>> >> +                     return ilb;
>> >> +     }
>> >
>> > The ILB code is bad; but you just made it horrible. Don't add pointless
>> > for_each_domain() iterations.
>> >
>> > I'm thinking something like:
>> >
>> >   ilb = cpumask_first_and(nohz.idle_cpus_mask, this_rq()->rd.span);
>> >
>> > Should work just fine, no?
>>
>> Yes, it has the same result as my previous patch did.
>>
>> >
>> > Better still would be to maybe not participate in the ILB in the first
>> > place and leave this selection loop alone.
>>
>> Not quitely get your point here...
>> Do you mean that you want idle cpu selection be put in earlier place
>> than current find_new_ilb is?
>
> I meant that if you stop an idle CPU setting its bit in
> nohz.idle_cpus_mask, you don't have to mask it out either.

Understand it.
I would reformat my previous patch according to your suggestion.

Thanks,
Lei
