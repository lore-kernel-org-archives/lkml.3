Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968AbaIYIf0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 04:35:26 -0400
Received: from mail-oi0-f49.google.com ([209.85.218.49]:41113 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbaIYIfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 04:35:24 -0400
MIME-Version: 1.0
In-Reply-To: <542303DF.8010606@arm.com>
References: <1411488485-10025-1-git-send-email-vincent.guittot@linaro.org>
 <1411488485-10025-6-git-send-email-vincent.guittot@linaro.org> <542303DF.8010606@arm.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Thu, 25 Sep 2014 10:35:03 +0200
Message-ID: <CAKfTPtB3-M+pXaurDeWkWGNJ3_mU-FN+EnshGE-eg_r41Hppag@mail.gmail.com>
Subject: Re: [PATCH v6 5/6] sched: replace capacity_factor by usage
To: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "riel@redhat.com" <riel@redhat.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "efault@gmx.de" <efault@gmx.de>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "pjt@google.com" <pjt@google.com>,
        "bsegall@google.com" <bsegall@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 September 2014 19:48, Dietmar Eggemann <dietmar.eggemann@arm.com> wrote:
> On 23/09/14 17:08, Vincent Guittot wrote:
>

[snip]

>
> This review (by PeterZ) during v5 of your patch-set recommended some
> renaming (e.g. s/group_has_free_capacity/group_has_capacity and
> s/group_out_of_capacity/group_no_capacity as well as reordering of the
> parameters which I agree with:
>
> https://lkml.org/lkml/2014/9/11/706

Ah... you're right, these changes have passed through my seance of renaming

>
>>
>> -/*

[snip]

>> -       if (sgs->group_capacity_factor > sgs->sum_nr_running)
>> -               sgs->group_has_free_capacity = 1;
>> +       sgs->group_type = group_classify(group, sgs, env);
>> +
>> +       sgs->group_out_of_capacity = group_is_overloaded(sgs, env);
>
> In case sgs->group_type is group_overloaded you could set
> sgs->group_out_of_capacity to 1 without calling group_is_overloaded again.

I prefer to keep sgs->group_out_of_capacity = group_is_overloaded(sgs,
env) and use it in group_classify in case of future changes in the
classification order

Regards,
Vincent
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 7cdf271e8e52..52d441c92a4f 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -6037,7 +6037,8 @@ static inline void update_sg_lb_stats(struct
> lb_env *env,
>
>         sgs->group_type = group_classify(group, sgs, env);
>
> -       sgs->group_out_of_capacity = group_is_overloaded(sgs, env);
> +       if (sgs->group_type == group_overloaded)
> +               sgs->group_out_of_capacity = 1;
>  }
>
>>  }
>>
>>  /**
>> @@ -6198,17 +6163,21 @@ static inline void update_sd_lb_stats(struct lb_env *env, struct sd_lb_stats *sd
>
> [...]
>
