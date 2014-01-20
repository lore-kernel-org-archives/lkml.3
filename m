Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921AbaATNji (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 08:39:38 -0500
Received: from mail2.unitn.it ([193.205.206.22]:53044 "EHLO mail2.unitn.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173AbaATNjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 08:39:36 -0500
Message-ID: <52DD2711.9080504@unitn.it>
Date: Mon, 20 Jan 2014 14:39:29 +0100
From: Luca Abeni <luca.abeni@unitn.it>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Henrik Austad <henrik@austad.us>, Juri Lelli <juri.lelli@gmail.com>
CC: peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
        rostedt@goodmis.org, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@gmail.com, liming.wang@windriver.com,
        jkacur@redhat.com, harald.gustafsson@ericsson.com,
        vincent.guittot@linaro.org, bruce.ashfield@windriver.com,
        rob@landley.net
Subject: Re: [PATCH] sched/deadline: Add sched_dl documentation
References: <1390214440-2711-1-git-send-email-juri.lelli@gmail.com> <20140120112442.GA8907@austad.us> <52DD1377.5090201@gmail.com> <20140120131616.GB8907@austad.us>
In-Reply-To: <20140120131616.GB8907@austad.us>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

On 01/20/2014 02:16 PM, Henrik Austad wrote:
[...]
>>>> + The typical -deadline task is composed of a computation phase (instance)
>>>> + which is activated on a periodic or sporadic fashion. The expected (maximum)
>>>> + duration of such computation is called the task's runtime; the time interval
>>>> + by which each instance needs to be completed is called the task's relative
>>>> + deadline. The task's absolute deadline is dynamically calculated as the
>>>> + time instant a task (or, more properly) activates plus the relative
>>>> + deadline.
>>>
>>> activates - released?
>>>
>>
>> I'd keep (modifying a bit):
>>
>> "time instant a task activates plus the relative deadline."
>>
>> This is probably the nearest thing to what is implemented that we can say
>> (without entering into the theory too much), a task that "activates" can mean
>> that it is first released, enqueued, woken-up, etc.
>
> So, if we look at release (yes, I'm avoiding activates for a little while)
> as the time at the *beginning* of a new period, then, and only then should
> the *absolute* deadline be computed.
>
> If you den move on to use 'activate' as a term for when a task becomes
> eligble to run, then 'release' becomes a subset of 'activate', and you
> should only compute the absolute deadline at that time. Did that make
> sense?
I think things are a little bit complex here, because there are 2 different
"deadlines" we can think about:
- the "jobs deadlines" (the absolute job deadline can be computed at job
   arrival, as the arrival time + the relative deadline). These are generally
   used for performance metrics, to see if a job is respecting its timing
   constraints or not
- the "scheduling deadlines", which are the ones used by the scheduler to
   schedule the tasks. These are computed at tasks' wake-up time - notice that
   for self-suspending jobs there can be wake-up times that are not job arrival
   times. And are assigned according to the rules described in the CBS paper.
I think this can easily become very confusing, so I currently have no concrete
proposals for improving the documentation... But I wanted to point out that
things here are more complex than in the "traditional" real-time task model.

Maybe a solution could be to simply describe scheduling deadlines (which are
what sched_deadline uses) without going into the details of jobs' deadlines.
So, the document could avoid talking about instances (or jobs), and can say
that a task is guaranteed to receive "runtime" time units every "period" time
units (and these "runtime" time units are available within "deadline" time
units from the beginning of the period). Every time the task wakes up, the
scheduler computes a scheduling deadline consistent with this constraint,
and tasks are scheduled using EDF on these scheduling deadlines.
Every time "runtime" time units are consumed in a period, the scheduling
deadline is postponed by a period.

This is of course an approximative description, but I think it can give an
intuitive idea of how the scheduler works, and about the meaning of the three
scheduling parameters.



				Luca
