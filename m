Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901AbaHCAnH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 20:43:07 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:41698 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbaHCAnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 20:43:05 -0400
MIME-Version: 1.0
In-Reply-To: <1406532289.5133.223.camel@marge.simpson.net>
References: <CA+80gGYVjprinWEJWbVq4VxjOLjQri8EvGAJ+sx+ihcOxdstCA@mail.gmail.com>
	<8738dm9t4z.fsf@tassilo.jf.intel.com>
	<1406532289.5133.223.camel@marge.simpson.net>
Date: Sat, 2 Aug 2014 17:43:03 -0700
Message-ID: <CA+80gGaohO-RaG0_tWZJEFzisrrBpgfiw-mxMrTfSK0N=k7gQA@mail.gmail.com>
Subject: Re: [PATCH RFC] sched: deferred set priority (dprio)
From: Sergey Oboguev <oboguev.public@gmail.com>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        khalid.aziz@oracle.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 12:24 AM, Mike Galbraith
<umgwanakikbuti@gmail.com> wrote:
> On Sun, 2014-07-27 at 18:19 -0700, Andi Kleen wrote:
>> Sergey Oboguev <oboguev.public@gmail.com> writes:
>>
>> > [This is a repost of the message from few day ago, with patch file
>> > inline instead of being pointed by the URL.]
>>
>> Have you checked out the preemption control that was posted some time
>> ago? It did essentially the same thing, but somewhat simpler than your
>> patch.
>>
>> http://lkml.iu.edu/hypermail/linux/kernel/1403.0/00780.html
>>
>> Yes I agree with you that lock preemption is a serious issue that needs solving.
>
> Yeah, it's a problem, and well known.
>
> One mitigation mechanism that exists in the stock kernel today is the
> LAST_BUDDY scheduler feature.  That took pgsql benchmarks from "shite"
> to "shiny", and specifically targeted this issue.
>
> Another is SCHED_BATCH, which can solve a lot of the lock problem by
> eliminating wakeup preemption within an application.  One could also
> create an extended batch class which is not only immune from other
> SCHED_BATCH and/or SCHED_IDLE tasks, but all SCHED_NORMAL wakeup
> preemption.  Trouble is that killing wakeup preemption precludes very
> fast very light tasks competing with hogs for CPU time.  If your load
> depends upon these performing well, you have a problem.
>
> Mechanism #3 is use of realtime scheduler classes.  This one isn't
> really a mitigation mechanism, it's more like donning a super suit.
>
> So three mechanisms exist, the third being supremely effective, but high
> frequency usage is expensive, ergo huge patch.
>
> The lock holder preemption problem being identical to the problem RT
> faces with kernel locks...
>
> A lazy preempt implementation ala RT wouldn't have the SCHED_BATCH
> problem, but would have a problem in that should critical sections not
> be as tiny as it should be, every time you dodge preemption you're
> fighting the fair engine, may pay heavily in terms of scheduling
> latency.  Not a big hairy deal, if it hurts, don't do that.  Bigger
> issue is that you have to pop into the kernel on lock acquisition and
> release to avoid jabbering with the kernel via some public phone.
> Popping into the kernel, if say some futex were victimized, also erases
> the "f" in futex, and restricting cost to consumer won't be any easier.
>
> The difference wrt cost acceptability is that the RT issue is not a
> corner case, it's core issue resulting from the nature of the RT beast
> itself, so the feature not being free is less annoying.  A corner case
> fix OTOH should not impact the general case at all.


When reasoning about concurrency management it may be helpful to keep in mind
the fundamental perspective that the problem space and solution space in this
area are fragmented -- just as your message exemplifies as well, but it also
applies across the board to all other solution techniques. There is no
all-unifying solution that works in all use cases and for all purposes.

This applies even to seemingly well-defined problems such as lock holder
preemption avoidance.

One of the divisions on a broad scale is between cases when wait/dependency
chain can be made explicit at run time (e.g. application/system can tell that
thread A is waiting on thread B which is waiting on thread C) and those cases
when the dependency cannot be explicitly expressed and information on the
dependency is lacking.

In the former case some form of priority inheritance or proxy execution might
often (but not always) work well.

In the latter case PI/PE cannot be applied. This case occurs when a component
needs to implement time-urgent section acting on behalf of (e.g. in response to
an event in) another component in the application and the latter is not (or
often cannot practically be) instrumented with the code that expresses its
inner dependencies and thus the information about the dependencies is lacking.

(One example might be virtual machine that runs guest operating system that is
not paravirtualized or can be paravirtualized only to a limited extent. The VM
might guess that preemption of VCPU thread that is processing events such as
IPI interrupts, clock interrupts or certain device interrupts is likely to
cause overall performance degradation due to other VCPUs spinning for an IPI
response or spinning waiting for a spinlock, and thought the general kinds of
these dependencies may be foreseen, but actual dependency chains between VCPUs
cannot be established at run time.)

In cases when dependency information is lacking, priority protection remains
the only effective recourse.

Furthermore, even in cases when dependency information is available, PI/PE per
se is not always a satisfactory or sufficient solution. Consider for instance a
classic case of a userspace spinlock or hybrid spin-then-block lock that is
highly contended and often requested by the threads, and a running thread
spends a notable part of a timeslice holding the lock (not necessarily grabbing
and holding it, the thread may grab and release it many times during a
timeslice, but the total of holding time is a notable fraction of a timeslice
-- notable being anywhere from a fraction of a percent and up). The probability
of a thread being preempted while holding the lock may thus be significant. In
a simple classic scheme the waiters will then continue to spin [*] and
subsequently some of them start entering blocking wait after a timeout, at this
point releasing the CPU(s) and letting the lock holder to continue, but by that
time the incurred cost would involve several context switches and scheduler
calculation cycles and the waste due to spinning... and all the while this is
happening and takes time, new contenders arrive and start spinning, wasting
CPU resources. What was supposed to be a short critical section turns into
something very else. Yes, eventually the scheme based on PI/PE or some form of
yield_to will push the holder through, but by the time this happens a high cost
had already been paid.

    [*] Unless the kernel provides a facility that will write "holder preempted"
        flag into the lock structure when the thread is being preempted so the
        spinners can spot this flag and transition to blocking wait. I am not
        aware of any OS that actually provides such a facility, but even if it
        were available, it would only partially reduce the overall incurred
        cost described above.

Furthermore, if preempted lock holder and the task that was willing to yield
were executing on different CPUs (as is likely), then with per-CPU scheduling
queues (as opposed to single global queue) it may be quite a while -- around the
queues rebalancing interval -- before the preempted holder would get a chance
to run and release the lock (all the while arriving waiters are spinning),
and on top of that the cost of task cross-CPU migration may have to be paid.

The wisdom of these observations is that problem and solution space is
fragmented and there is no "holy grail" solution that would cover all use
cases. Solutions are specific to use cases and their priorities.

Given this, the best OS can do is to provide a range of solutions --
instruments -- and let an application developer (and/or system owner) pick
those that are most fitting for the given application's purposes.

- Sergey
