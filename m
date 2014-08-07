Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825AbaHGB0l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 21:26:41 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:37749 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754366AbaHGB0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 21:26:39 -0400
MIME-Version: 1.0
In-Reply-To: <1407303693.5090.171.camel@marge.simpson.net>
References: <CA+80gGYVjprinWEJWbVq4VxjOLjQri8EvGAJ+sx+ihcOxdstCA@mail.gmail.com>
	<8738dm9t4z.fsf@tassilo.jf.intel.com>
	<1406532289.5133.223.camel@marge.simpson.net>
	<CA+80gGaohO-RaG0_tWZJEFzisrrBpgfiw-mxMrTfSK0N=k7gQA@mail.gmail.com>
	<1407059776.5156.108.camel@marge.simpson.net>
	<CA+80gGZJGX6PjzwptNJ5gU3SvCxaYT8v4id+4NqMAPwgAAS26Q@mail.gmail.com>
	<1407303693.5090.171.camel@marge.simpson.net>
Date: Wed, 6 Aug 2014 18:26:38 -0700
Message-ID: <CA+80gGYUohD617FcmtD5XyrFh2ENc2nXFA=91CmZ+8zFNOrzFQ@mail.gmail.com>
Subject: Re: [PATCH RFC] sched: deferred set priority (dprio)
From: Sergey Oboguev <oboguev.public@gmail.com>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        khalid.aziz@oracle.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 5, 2014 at 10:41 PM, Mike Galbraith
<umgwanakikbuti@gmail.com> wrote:

>> > SCHED_NORMAL where priority escalation does not work as preemption proofing
>>
>> Remember, DPRIO is not for lock holders only.
>>
>> Using DPRIO within SCHED_NORMAL policy would make sense for an application that
>> has "soft" time-urgent section where it believes strong protection
>> from preemption
>> is not really necessary, and just a greater claim to CPU time share would do,
>> in cases where the application does not know beforehand if the section will be
>> short or long, and in majority of cases is short (sub-millisecond), but
>> occasionally can take longer.
>
> Every single time that SCHED_NORMAL task boosts its priority (nice)
> during a preemption, the math has already been done, vruntime has
> already been adjusted.
> Sure, when it gets the CPU back, its usage will
> be weighed differently, it will become more resistant to preemption, but
> in no way immune.  There is nothing remotely deterministic about this,
> making it somewhat of an oxymoron when combined with critical section.

But you overlooked the point I was trying to convey in the paragraph you
are responding to.

Apart from SCHED_NORMAL being a marginal use case, if it is used at all, I do
not see it being used for lock-holding or similar critical section where an
application wants to avoid the preemption.

I can see DPRIO(SCHED_NORMAL) being used in the same cases as an application
would use nice for a temporary section, i.e. when it has a job that needs to be
processed relatively promptly over some time interval but not really
super-urgently and hard guarantees are not needed, i.e. when the application
simply wants to have an improved claim for CPU resources compared to normal
threads over let us say the next half-second or so. It is ok if the application
gets preempted, all it cares about is a longer timeframe ("next half-second")
rather than shorter and immediate timeframe ("next millisecond").

The only reason why anyone would want to use DPRIO instead of regular nice in
this case is because it might be unknown beforehand whether the job will be
short or might take a longer time, with majority of work items being very short
but occasionally taking longer. In this case using DPRIO would let to cut the
overhead for majority of section instances. To reiterate, this is a marginal
and most likely rare use case, but given the existence of uniform interface
I just do not see why to block it on purpose.

> If some kthread prioritizes _itself_ and mucks up application
> performance, file a bug report, that kthread is busted.  Anything a user
> or application does with realtime priorities is on them.

kthreads do not need RT, they just use spinlocks ;-)

On a serious note though, I am certainly not saying that injudicious use of RT
(or even nice) cannot disrupt the system, but is it reason enough to summarily
condemn the judicious use as well?

>> I disagree. The exact problem is that it is not a developer who initiates the
>> preemption, but the kernel or another part of application code that is unaware
>> of other thread's condition and doing it blindly, lacking the information about
>> the state of the thread being preempted and the expected cost of its preemption
>> in this state. DPRIO is a way to communicate this information.

> What DPRIO clearly does NOT do is to describe critical sections to the
> kernel.

First of all let's reflect that your argument is not with DPRIO as such. DPRIO
after all is not a separate scheduling mode, but just a method to reduce the
overhead of regular set_priority calls (i.e. sched_setattr & friends).

You argument is with the use of elevated priority as such, and you are saying
that using RT priority range (or high nice) does not convey to the kernel the
information about the critical section.

I do not agree with this, not wholly anyway. First of all, it is obvious that
set_priority does convey some information about the section, so perhaps a more
accurate re-formulation of your argument could be that it is imperfect,
insufficient information.

Let's try to imagine then what could make more perfect information. It
obviously should be some cost function describing the cost that would be
incurred if the task gets preempted. Something that would say (if we take the
simplest form) "if you preempt me within the next T microseconds (unless I
cancel or modify this mode), this preemption would incur cost X upfront further
accruing at a rate Y".

One issue I see with this approach is that in real life it might be very hard
for a developer to quantify the values for X, Y and T. Developer can easily
know that he wants to avoid the preemption in a given section, but actually
quantifying the cost of preemption (X, Y) would take a lot of effort
(benchmarking) and furthermore really cannot be assigned statically, as the
cost varies depending on the load pattern and site-specific configuration.
Furthermore, when dealing with multiple competing contexts, developer can
typically tell that task A is more important than task B, but quantifying the
measure of their relative importance might be quite difficult.

Likewise, quantifying "T" is likely to be similarly difficult.

(And then even suppose the developer knew that the section completes within let
us say 5 ms at three sigmas, is this reason good enough to preempt the task
at 6 ms for the sake of a normal timesharing thread? - I am uncertain.)

Thus it appears to me that even such an interface existed today, developers
would be daunted by it and prefer to use RT instead as something more
manageable/usable, controllable and predictable.

But then, suppose such an interface existed and task expressing their critical
section information through it were -- within their authorized quotas for T and
X/Y -- given precedence over normal threads but preemptible by RT or DL tasks.
Would not it pretty much amount to the existence of low-RT range sitting just
below regular RT range, low-RT range that tasks could enter for a time? Just
like they can enter regular RT range now with set_priority, also for a time.
Would it be really different from judicious use of existing RT, where tasks
controlling "chainsaws" run at prio range 50-90, while database engine threads
utilize prio range 1-10 in their critical sections?

(The only difference being that after the expiration of interval T task
priority is knocked down -- which a judiciously written application does
anyway, so the difference is just a protection against bugs and runaways -- and
then task becomes more subject to preemption, after which other threads are free
to use PI/PE to resolve the dependency when they know it, and if they
do not then
in a subset of those use cases when spinning of old or incoming waiters cannot
be shut off, it is either back to using plain RT or sustaining uncontrollable
losses.)

I would be most glad to see a usable interface providing information to the
scheduler about a task's critical sections emerge (other than RT), but for the
considerations outlined I am doubtful of the possibility.

Apart from this and coming back to DPRIO, even if solution more satisfactory
than judicious use of RT existed, how long might it take for it to be worked
out? If the history of EDF from ReTiS concept to merging into 3.14 mainline is
a guide, it may take quite a while, so stop-gap solution would have a value
even because of timing considerations until something better emerges... that
is, assuming it can and ever does.

- Sergey
