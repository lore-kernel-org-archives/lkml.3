Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932991Ab3FQM07 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 08:26:59 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:63431 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932859Ab3FQM05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 08:26:57 -0400
MIME-Version: 1.0
In-Reply-To: <20130617092033.GL3204@twins.programming.kicks-ass.net>
References: <1370589652-24549-1-git-send-email-alex.shi@intel.com>
	<1370589652-24549-4-git-send-email-alex.shi@intel.com>
	<CALZhoSS=xMgW8sgjL4qS+LkqAucFptJnOa2Yt53rNwJPEpA0Hg@mail.gmail.com>
	<20130617092033.GL3204@twins.programming.kicks-ass.net>
Date: Mon, 17 Jun 2013 20:26:55 +0800
Message-ID: <CALZhoSTNg+QWY4VMH97oF8ReJx_nVY7Ux7iEM=66XvNmdbdH6w@mail.gmail.com>
Subject: Re: [patch v8 3/9] sched: set initial value of runnable avg for new
 forked task
From: Lei Wen <adrian.wenl@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alex Shi <alex.shi@intel.com>, mingo@redhat.com, tglx@linutronix.de,
        akpm@linux-foundation.org, bp@alien8.de, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org, mgorman@suse.de,
        riel@redhat.com, wangyun@linux.vnet.ibm.com,
        Jason Low <jason.low2@hp.com>,
        Changlong Xie <changlongx.xie@intel.com>, sgruszka@redhat.com,
        fweisbec@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Mon, Jun 17, 2013 at 5:20 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, Jun 14, 2013 at 06:02:45PM +0800, Lei Wen wrote:
>> Hi Alex,
>>
>> On Fri, Jun 7, 2013 at 3:20 PM, Alex Shi <alex.shi@intel.com> wrote:
>> > We need initialize the se.avg.{decay_count, load_avg_contrib} for a
>> > new forked task.
>> > Otherwise random values of above variables cause mess when do new task
>> > enqueue:
>> >     enqueue_task_fair
>> >         enqueue_entity
>> >             enqueue_entity_load_avg
>> >
>> > and make forking balancing imbalance since incorrect load_avg_contrib.
>> >
>> > Further more, Morten Rasmussen notice some tasks were not launched at
>> > once after created. So Paul and Peter suggest giving a start value for
>> > new task runnable avg time same as sched_slice().
>>
>> I am confused at this comment, how set slice to runnable avg would change
>> the behavior of "some tasks were not launched at once after created"?
>>
>> IMHO, I could only tell that for the new forked task, it could be run if current
>> task already be set as need_resched, and preempt_schedule or
>> preempt_schedule_irq
>> is called.
>>
>> Since the set slice to avg behavior would not affect this task's vruntime,
>> and hence cannot make current running task be need_sched, if
>> previously it cannot.
>
>
> So the 'problem' is that our running avg is a 'floating' average; ie. it
> decays with time. Now we have to guess about the future of our newly
> spawned task -- something that is nigh impossible seeing these CPU
> vendors keep refusing to implement the crystal ball instruction.

I am curious at this "crystal ball instruction" saying. :)
Could it be real? I mean what kind of hw mechanism could achieve such
magic power? What I see, for silicon vendor they could provide more
monitor unit, but to precise predict the sw's behavior, I don't think hw
also this kind of power...

>
> So there's two asymptotic cases we want to deal well with; 1) the case
> where the newly spawned program will be 'nearly' idle for its lifetime;
> and 2) the case where its cpu-bound.
>
> Since we have to guess, we'll go for worst case and assume its
> cpu-bound; now we don't want to make the avg so heavy adjusting to the
> near-idle case takes forever. We want to be able to quickly adjust and
> lower our running avg.
>
> Now we also don't want to make our avg too light, such that it gets
> decremented just for the new task not having had a chance to run yet --
> even if when it would run, it would be more cpu-bound than not.
>
> So what we do is we make the initial avg of the same duration as that we
> guess it takes to run each task on the system at least once -- aka
> sched_slice().
>
> Of course we can defeat this with wakeup/fork bombs, but in the 'normal'
> case it should be good enough.
>
>
> Does that make sense?

Thanks for your detailed explanation. Very useful indeed! :)

BTW, I have no question for the patch itself, but just confuse at the
patch's comment
"some tasks were not launched at once after created".

Thanks,
Lei
