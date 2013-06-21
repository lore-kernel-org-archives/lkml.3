Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030355Ab3FUC5a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 22:57:30 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:40149 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030247Ab3FUC53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 22:57:29 -0400
MIME-Version: 1.0
In-Reply-To: <20130620102334.GI5460@e103034-lin>
References: <1370589652-24549-1-git-send-email-alex.shi@intel.com>
	<1370589652-24549-4-git-send-email-alex.shi@intel.com>
	<CALZhoSS=xMgW8sgjL4qS+LkqAucFptJnOa2Yt53rNwJPEpA0Hg@mail.gmail.com>
	<51BB21D8.6000109@intel.com>
	<CALZhoSTxKUD2oE7YUFvwASKqnpJBgPP6mnJG3KhFUre5OqYBFQ@mail.gmail.com>
	<20130620102334.GI5460@e103034-lin>
Date: Fri, 21 Jun 2013 10:57:27 +0800
Message-ID: <CALZhoSRTEdLGMazik87hHf9Zs+GhxABRWJMHGDi3-zkKPRAd9A@mail.gmail.com>
Subject: Re: [patch v8 3/9] sched: set initial value of runnable avg for new
 forked task
From: Lei Wen <adrian.wenl@gmail.com>
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: Alex Shi <alex.shi@intel.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "bp@alien8.de" <bp@alien8.de>, "pjt@google.com" <pjt@google.com>,
        "namhyung@kernel.org" <namhyung@kernel.org>,
        "efault@gmx.de" <efault@gmx.de>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "viresh.kumar@linaro.org" <viresh.kumar@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mgorman@suse.de" <mgorman@suse.de>,
        "riel@redhat.com" <riel@redhat.com>,
        "wangyun@linux.vnet.ibm.com" <wangyun@linux.vnet.ibm.com>,
        Jason Low <jason.low2@hp.com>,
        Changlong Xie <changlongx.xie@intel.com>,
        "sgruszka@redhat.com" <sgruszka@redhat.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Morten,

On Thu, Jun 20, 2013 at 6:23 PM, Morten Rasmussen
<morten.rasmussen@arm.com> wrote:
> On Sat, Jun 15, 2013 at 01:09:12PM +0100, Lei Wen wrote:
>> On Fri, Jun 14, 2013 at 9:59 PM, Alex Shi <alex.shi@intel.com> wrote:
>> > On 06/14/2013 06:02 PM, Lei Wen wrote:
>> >>> >         enqueue_entity
>> >>> >             enqueue_entity_load_avg
>> >>> >
>> >>> > and make forking balancing imbalance since incorrect load_avg_contrib.
>> >>> >
>> >>> > Further more, Morten Rasmussen notice some tasks were not launched at
>> >>> > once after created. So Paul and Peter suggest giving a start value for
>> >>> > new task runnable avg time same as sched_slice().
>> >> I am confused at this comment, how set slice to runnable avg would change
>> >> the behavior of "some tasks were not launched at once after created"?
>> >
>> > I also don't know the details on Morten's machine. but just guess, there
>> > are much tasks on in the run queue. the minimum load avg make the new
>> > task wait its time...
>>
>> Is there some possibility that since task structure is allocated without being
>> set to 0, and it cause the imbalance between runqueues. Then the new forked
>> is migrated to other cpus, so that it cause its execution being delayed?
>>
>> It is better for Morten to give us more details here. :)
>>
>
> I think Peter's reply pretty much covers it. The problem is when a task
> is not running (other task has lower vruntime or blocked for other
> reasons) shortly after the task was created. The runnable_avg_period is
> very small, so the load_contrib is very sensitive.
>
> Say if a task runs for 1 ms then is blocked for 1 ms and then runs
> again, the load_contrib will go from 100% to 50% instantly and then ramp
> back up again. So the task load may be quite different from the true
> load of the task depending on when you calculate the load_contrib.
>
> Preloading runnable_avg_period should make the load_contrib a little
> less sensitive to this behaviour.

Thanks for detailed explanation!
Now I could understand the preloading value prevent entity's load change quickly
at its beginning.
But I cannot see why this could explain "some tasks were not launched at
once after created"

Or should I understand the previous words as:
"If without preloading value, the new created task's contributed load may vary
too quickly at its beginning. Like if a task runs for 1 ms then is
blocked for 1 ms
and then runs again, the load_contrib will go from 100% to 50% instantly."


Thanks,
Lei

>
> Morten
>
>> Thanks,
>> Lei
>>
>> >>
>> >> IMHO, I could only tell that for the new forked task, it could be run if current
>> >> task already be set as need_resched, and preempt_schedule or
>> >> preempt_schedule_irq
>> >> is called.
>> >>
>> >> Since the set slice to avg behavior would not affect this task's vruntime,
>> >> and hence cannot make current running task be need_sched, if
>> >> previously it cannot.
>> >>
>> >> Could you help correct if I am wrong at somewhere? ....
>> >>
>> >> Thanks,
>> >
>> >
>> > --
>> > Thanks
>> >     Alex
>>
>
