Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932364Ab3BSLfR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 06:35:17 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:39033 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756827Ab3BSLfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 06:35:16 -0500
MIME-Version: 1.0
In-Reply-To: <511CE1AB.5020503@intel.com>
References: <1358996820-23036-1-git-send-email-alex.shi@intel.com>
 <1358996820-23036-8-git-send-email-alex.shi@intel.com> <1360664784.4485.17.camel@laptop>
 <511BADE3.4050009@intel.com> <CAPM31RJw7a-+QNRwwukg3h3bHCQs++cnT3DgCyHaJTZY7qDsXA@mail.gmail.com>
 <511CE1AB.5020503@intel.com>
From: Paul Turner <pjt@google.com>
Date: Wed, 20 Feb 2013 00:34:44 +1300
Message-ID: <CAPM31RKf6Gint-fPxfuFkXxxbpJfkk=5=5v3W0uxvTnnvOoM-A@mail.gmail.com>
Subject: Re: [patch v4 07/18] sched: set initial load avg of new forked task
To: Alex Shi <alex.shi@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, torvalds@linux-foundation.org,
        mingo@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org,
        arjan@linux.intel.com, bp@alien8.de, namhyung@kernel.org,
        efault@gmx.de, vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2013 at 2:07 AM, Alex Shi <alex.shi@intel.com> wrote:
>
>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> index 1dff78a..9d1c193 100644
>> --- a/kernel/sched/core.c
>> +++ b/kernel/sched/core.c
>> @@ -1557,8 +1557,8 @@ static void __sched_fork(struct task_struct *p)
>>   * load-balance).
>>   */
>>  #if defined(CONFIG_SMP) && defined(CONFIG_FAIR_GROUP_SCHED)
>> -       p->se.avg.runnable_avg_period = 0;
>> -       p->se.avg.runnable_avg_sum = 0;
>> +       p->se.avg.runnable_avg_period = 1024;
>> +       p->se.avg.runnable_avg_sum = 1024;
>
> It can't work.
> avg.decay_count needs to be set to 0 before enqueue_entity_load_avg(), then
> update_entity_load_avg() can't be called, so, runnable_avg_period/sum
> are unusable.

Well we _could_ also use a negative decay_count here and treat it like
a migration; but the larger problem is the visibility of p->on_rq;
which is gates whether we account the time as runnable and occurs
after activate_task() so that's out.

>
> Even we has chance to call __update_entity_runnable_avg(),
> avg.last_runnable_update needs be set before that, usually, it needs to
> be set as 'now', that cause __update_entity_runnable_avg() function
> return 0, then update_entity_load_avg() still can not reach to
> __update_entity_load_avg_contrib().
>
> If we embed a simple new task load initialization to many functions,
> that is too hard for future reader.

This is my concern about making this a special case with the
introduction ENQUEUE_NEWTASK flag; enqueue jumps through enough hoops
as it is.

I still don't see why we can't resolve this at init time in
__sched_fork(); your patch above just moves an explicit initialization
of load_avg_contrib into the enqueue path.  Adding a call to
__update_task_entity_contrib() to the previous alternate suggestion
would similarly seem to resolve this?

>
>>  #endif
>>  #ifdef CONFIG_SCHEDSTATS
>>         memset(&p->se.statistics, 0, sizeof(p->se.statistics));
>>
>>
>>
>>>
>>>
>>> --
>>> Thanks
>>>     Alex
>
>
> --
> Thanks
>     Alex
