Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848Ab3DVLB5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 07:01:57 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:57760 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198Ab3DVLBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 07:01:55 -0400
MIME-Version: 1.0
In-Reply-To: <1366623052.2721.6.camel@laptop>
References: <1366377044-23989-1-git-send-email-vincent.guittot@linaro.org>
	<1366623052.2721.6.camel@laptop>
Date: Mon, 22 Apr 2013 13:01:54 +0200
Message-ID: <CAKfTPtBMG6KPSZsMFnJqEAajg2qjRXowKSfrWHED-EhUCLB2+Q@mail.gmail.com>
Subject: Re: [PATCH v6] sched: fix init NOHZ_IDLE flag
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Ingo Molnar <mingo@kernel.org>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Paul Turner <pjt@google.com>, Steven Rostedt <rostedt@goodmis.org>,
        Mike Galbraith <efault@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 April 2013 11:30, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2013-04-19 at 15:10 +0200, Vincent Guittot wrote:
>> As suggested by Frederic Weisbecker, another solution is to have the
>> same
>> rcu lifecycle for both NOHZ_IDLE and sched_domain struct. I have
>> introduce
>> a new sched_domain_rq struct that is the entry point for both
>> sched_domains
>> and objects that must follow the same lifecycle like NOHZ_IDLE flags.
>> They
>> will share the same RCU lifecycle and will be always synchronized.
>>
>> The synchronization is done at the cost of :
>>  - an additional indirection for accessing the first sched_domain
>> level
>>  - an additional indirection and a rcu_dereference before accessing to
>> the
>>    NOHZ_IDLE flag.
>
>> diff --git a/include/linux/sched.h b/include/linux/sched.h
>> index d35d2b6..61ad5f1 100644
>> --- a/include/linux/sched.h
>> +++ b/include/linux/sched.h
>> @@ -959,6 +959,18 @@ struct sched_domain {
>>         unsigned long span[0];
>>  };
>>
>> +/*
>> + * Some flags must stay synchronized with fields of sched_group_power
>> and as a
>> + * consequence they must follow the same lifecycle for the lockless
>> scheme.
>> + * sched_domain_rq encapsulates those flags and sched_domains in one
>> RCU
>> + * object.
>> + */
>> +struct sched_domain_rq {
>> +       struct sched_domain *sd;
>> +       unsigned long flags;
>> +       struct rcu_head rcu;    /* used during destruction */
>> +};
>
> I'm not quite getting things.. what's wrong with adding this flags
> thing to sched_domain itself? That's already RCU destroyed so why add a
> second RCU layer?

We need one flags for all sched_domain so if we add it into
sched_domain struct, we have to define which one will handle the flags
for all other and find it in the sched_domain tree when we need it. In
addition, the flags in other sched_domain will be a waste of space.
The RCU in sched_domain might become useless as it is protected by the
one that is in sched_domain_rq


>
> We also have the root_domain for things that don't need to go in a
> hierarchy but are once per cpu -- it sounds like this is one of those
> things; iirc the root_domain life-time is the same as the entire
> sched_domain tree so adding it to the root_domain is also an option.

AFAICT, it doesn't share the same RCU object and as a result the same
lifecycle than sched_domain so there is a time window where
sched_domain and flags could lost their synchronization.
Nevertheless, i'm going to have a look at root_domain

>
