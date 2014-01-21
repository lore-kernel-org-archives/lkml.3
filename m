Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594AbaAULfj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 06:35:39 -0500
Received: from mail3.unitn.it ([193.205.206.24]:49690 "EHLO mail3.unitn.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754042AbaAULff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 06:35:35 -0500
Message-ID: <52DE5B7F.8020900@unitn.it>
Date: Tue, 21 Jan 2014 12:35:27 +0100
From: Luca Abeni <luca.abeni@unitn.it>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Henrik Austad <henrik@austad.us>
CC: Juri Lelli <juri.lelli@gmail.com>, peterz@infradead.org,
        tglx@linutronix.de, mingo@redhat.com, rostedt@goodmis.org,
        oleg@redhat.com, fweisbec@gmail.com, darren@dvhart.com,
        johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@gmail.com, liming.wang@windriver.com,
        jkacur@redhat.com, harald.gustafsson@ericsson.com,
        vincent.guittot@linaro.org, bruce.ashfield@windriver.com,
        rob@landley.net
Subject: Re: [PATCH] sched/deadline: Add sched_dl documentation
References: <1390214440-2711-1-git-send-email-juri.lelli@gmail.com> <20140120112442.GA8907@austad.us> <52DD1377.5090201@gmail.com> <20140120131616.GB8907@austad.us> <52DD2711.9080504@unitn.it> <20140121102016.GA12002@austad.us>
In-Reply-To: <20140121102016.GA12002@austad.us>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2014 11:20 AM, Henrik Austad wrote:
> On Mon, Jan 20, 2014 at 02:39:29PM +0100, Luca Abeni wrote:
>> Hi all,
>>
>> On 01/20/2014 02:16 PM, Henrik Austad wrote:
>> [...]
>>>>>> + The typical -deadline task is composed of a computation phase (instance)
>>>>>> + which is activated on a periodic or sporadic fashion. The expected (maximum)
>>>>>> + duration of such computation is called the task's runtime; the time interval
>>>>>> + by which each instance needs to be completed is called the task's relative
>>>>>> + deadline. The task's absolute deadline is dynamically calculated as the
>>>>>> + time instant a task (or, more properly) activates plus the relative
>>>>>> + deadline.
>>>>>
>>>>> activates - released?
>>>>>
>>>>
>>>> I'd keep (modifying a bit):
>>>>
>>>> "time instant a task activates plus the relative deadline."
>>>>
>>>> This is probably the nearest thing to what is implemented that we can say
>>>> (without entering into the theory too much), a task that "activates" can mean
>>>> that it is first released, enqueued, woken-up, etc.
>>>
>>> So, if we look at release (yes, I'm avoiding activates for a little while)
>>> as the time at the *beginning* of a new period, then, and only then should
>>> the *absolute* deadline be computed.
>>>
>>> If you den move on to use 'activate' as a term for when a task becomes
>>> eligble to run, then 'release' becomes a subset of 'activate', and you
>>> should only compute the absolute deadline at that time. Did that make
>>> sense?
>
>> I think things are a little bit complex here, because there are 2 different
>> "deadlines" we can think about:
>> - the "jobs deadlines" (the absolute job deadline can be computed at job
>>    arrival, as the arrival time + the relative deadline). These are generally
>>    used for performance metrics, to see if a job is respecting its timing
>>    constraints or not
>>
>> - the "scheduling deadlines", which are the ones used by the scheduler to
>>    schedule the tasks. These are computed at tasks' wake-up time - notice that
>>    for self-suspending jobs there can be wake-up times that are not job arrival
>>    times. And are assigned according to the rules described in the CBS paper.
>>
>> I think this can easily become very confusing, so I currently have no concrete
>> proposals for improving the documentation... But I wanted to point out that
>> things here are more complex than in the "traditional" real-time task model.
>
> Traditional real-time as in the current real-time model used in Linux, or
> traditional as in EDF terminology used by Liu & Layland?
Sorry, by traditional real-time task model I meant the Liu & Layland one
(which is similar to what is describe above "... a task is composed of
a computation phase (instance) which is activated on a periodic or sporadic
fashion"...). I just wanted to say that things in reality are more complex
than this.


>> Maybe a solution could be to simply describe scheduling deadlines (which are
>> what sched_deadline uses) without going into the details of jobs' deadlines.
>
> Huh?
>
> We definately need a short dictionary. In fact, I'd like to have a
> paragraph describing what deadline driven scheduling is.
>
> For instance, I'm getting *Really* confused wrt to arrival time - you seem
> to wrap several types of arrival into the same name,  yet treat it
> differently.
>
> - arrival: when a job gets ready to run for the first time
> - arrival: when a job unblocks on some resource
>
> Or did I misunderstand?
Well, my point was (but I might be wrong) that describing all of these details
in this document might be confusing, so it might make sense to describe only
the relevant things (leaving all of the theoretical details to other documents,
like the papers and technical reports cited in this document).
You are right: there are different concepts of "arrival" and "arrival time": the
"job arrival" (when some activity - for example decoding a video frame - starts)
and the "task wake up". But I think in this document it is not important to mention
jobs (or task instances) and job arrivals: the only relevant things are task
wake-ups.

> So, the terminology I'm used to, an attempt to write up something to
> clear up the terminology and establish common grounds. Please
> edit/elaborate or shoot down as appropriate:
>
> """
> N. Crashcourse in deadline-terminology:
>
> In a system, we typically look at a set of tasks. In Linux-kernel
> terminology, a particular task is normally a thread. When a thread is
> ready to run, we say that a *job* of that task is running.
This would be true in the original Liu&Layland model (where a task blocks
only when a job finishes), but I do not think it is correct in a real system...
For example: (notice: this discussion might be slightly off-topic, and I do not
think this should go in the document... I am writing just to clarify my point
of view)
- Let's consider a (over simplified) video decoder as an example of task
- The task periodically read a video frame (from disk or network), decodes it,
   and displays it
- So, each job starts when the frame is read, and finishes when the frame is
   displayed. And jobs are (in this case) activated periodically
- During the execution of a job, the task might invoke a blocking system call,
   and block... When it wakes up, it is still in the same job (decoding the same
   video frame), and not in a different one.
This is (IMHO) where all the confusion comes from.

> It is
> perhaps easiest to grasp this if one think only of periodic tasks, i.e. a
> thread that need to run for 2ms every 10ms. Normally, we want one job to
> finish before a new (of the same task) start, which implies that the
> deadline for this task is also 10ms. Once this is clear, expanding one's
> mind to aperiodic and/or sporadic tasks is easier.
>
> * Periodic task: a task that needs to run for a while every N us.
> * Sporadic task: a tasks that needs tor un for a while at most every N us
>    (jobs start no closer than N us apart)
> * Aperiodic task: a task that have no particular period, but once
>    released, needs to complete before a given deadline.
This is all correct, but I think it is not needed to understand how sched_deadline
works


> * Set of all deadline-tasks in the system: \tau
> * One particluar task: \tau_i
> * The j'th job of task i: \tau_{i,j}
> * The (relative) deadline of task i: D_i
> * The (periodic, relative) release time of task i: R_i
> * Required execution time a tasks's job needs to complete. C_i
> * Absolute release-time, the time when a new job is ready (when a thread is
>    woken up for a new period).
> * The absolute deadline of a job, the actual point in time where a job
>    needs to be finished. This is what the scheduler looks at when it picks
>    the next thread to run.
This is not completely correct... The scheduler does not use this deadline, but
uses a "scheduling deadline". The difference is, for example, that the scheduling
deadline is postponed when the task tries to execute for more than the runtime...
And this is why I think (but I might be wrong) that the concepts above do not need
to be introduced in this document.
Notice that if runtime >= C_i and if the sched_deadline period is >= "R_i", then
the scheduling deadlines and the absolute deadlines you mention above coincide, so
the task is guaranteed to respect the jobs' absolute deadlines (this is what is
called "hard schedulability property" in the CBS paper).

> We can now construct a 3-tuple describing a perioic and sporadic tasks:
>
>            (C_i, R_i, D_i).
>
> These 3 items is what you can use to describe your task to the scheduler.
> """
>
>> So, the document could avoid talking about instances (or jobs), and can say
>> that a task is guaranteed to receive "runtime" time units every "period" time
>> units (and these "runtime" time units are available within "deadline" time
>> units from the beginning of the period). Every time the task wakes up, the
>> scheduler computes a scheduling deadline consistent with this constraint,
>> and tasks are scheduled using EDF on these scheduling deadlines.
>> Every time "runtime" time units are consumed in a period, the scheduling
>> deadline is postponed by a period.
>
> What is wrong with using the CORRECT TERMINOLOGY?
Well, what I mentioned above could be "correct terminology" :).
I just avoided talking about the two different kinds of deadlines
(jobs' deadlines and scheduling deadlines), because this could be confusing.
And about jobs, in order to avoid talking about self-suspending jobs, and
having to make a distinction about job arrivals and other task wake ups...

> People looking at using
> sched_deadline _need_ to understand what a _deadline_ scheduler is.
I think the sentence I wrote above gives an idea about what sched_deadline does,
and how to use the three parameters. I can be extended by clarifying that "using
EDF on these scheduling deadlines" means "scheduling the task with the smallest
scheduling deadline".


> If the only goal of sched_deadline is to act as a bandwidth-gauge, then
> fine, but *I* want to use sched_deadline for systems that HAVE DEADLINES.
Ok, so this is a more advanced usage. A section about the "hard schedulability
property" mentioned above can be added (later in the document, I think) to explain
how sched_deadline can be used to provide guarantees to real-time tasks (so,
the real-time task model you mentioned can be described later, and the condition
I mentioned above can be explained).
My point is: first explain what sched_deadline is and how it works (something about
my paragraph above), then, later explain what a real-time task is and how sched_deadline
can be used to properly schedule it.

> I do NOT want to mess around with mapping deadlines to priorities in order to
> meet my deadlines.
I agree, this is not needed.

> I suspect others would like to use sched_deadline for the same.
Again, I might be wrong... But once the "runtime time units every period, served
within a specified deadline" idea is clear, it is easier to understand how to use
sched_deadline.


>> This is of course an approximative description, but I think it can give an
>> intuitive idea of how the scheduler works, and about the meaning of the three
>> scheduling parameters.
>
> Look, I'm not in favour of turning sched_deadline.txt into an academic
> paper, but it is clear that we need to establish a baseline here, and then
> we need to include tasks, instances/jobs, deadline, arrival/release and so
> on.
See above... IMHO, this is not needed to understand how sched_deadline works.
But once the sched_deadline behaviour is defined, these concepts can be introduced
and it can be explained how to use sched_deadline to respect the jobs' deadlines...




				Luca
