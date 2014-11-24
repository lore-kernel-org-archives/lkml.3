Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338AbaKXOlw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 09:41:52 -0500
Received: from mail-oi0-f41.google.com ([209.85.218.41]:50440 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909AbaKXOlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 09:41:49 -0500
MIME-Version: 1.0
In-Reply-To: <20141121123719.GH23177@e105550-lin.cambridge.arm.com>
References: <1415033687-23294-1-git-send-email-vincent.guittot@linaro.org>
 <1415033687-23294-9-git-send-email-vincent.guittot@linaro.org> <20141121123719.GH23177@e105550-lin.cambridge.arm.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Mon, 24 Nov 2014 15:41:28 +0100
Message-ID: <CAKfTPtBtdnHUYjbrUiqED7Mr2d4HGB1YcyARED6Zx+rskZRsBw@mail.gmail.com>
Subject: Re: [PATCH v9 08/10] sched: replace capacity_factor by usage
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "kamalesh@linux.vnet.ibm.com" <kamalesh@linux.vnet.ibm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "riel@redhat.com" <riel@redhat.com>, "efault@gmx.de" <efault@gmx.de>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 November 2014 at 13:37, Morten Rasmussen <morten.rasmussen@arm.com> wrote:
> On Mon, Nov 03, 2014 at 04:54:45PM +0000, Vincent Guittot wrote:

[snip]

>>                  */
>>                 if (prefer_sibling && sds->local &&
>> -                   sds->local_stat.group_has_free_capacity)
>> -                       sgs->group_capacity_factor = min(sgs->group_capacity_factor, 1U);
>> +                   group_has_capacity(env, &sds->local_stat) &&
>> +                   (sgs->sum_nr_running > 1)) {
>> +                       sgs->group_no_capacity = 1;
>> +                       sgs->group_type = group_overloaded;
>> +               }
>
> I'm still a bit confused about SD_PREFER_SIBLING. What is the flag
> supposed to do and why?

The goal is to spread tasks across the group even if the the latter is
not overloaded. for SMT level, the goal is to have 1 task per core
before 1 task per HW thread

>
> It looks like a weak load balancing bias attempting to consolidate tasks
> on domains with spare capacity. It does so by marking non-local groups
> as overloaded regardless of their actual load if the local group has
> spare capacity. Correct?
>
> In patch 9 this behaviour is enabled for SMT level domains, which
> implies that tasks will be consolidated in MC groups, that is we prefer
> multiple tasks on sibling cpus (hw threads). I must be missing something
> essential. I was convinced that we wanted to avoid using sibling cpus on
> SMT systems as much as possible?
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
