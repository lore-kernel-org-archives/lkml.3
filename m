Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbaHMXwj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 19:52:39 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:49813 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbaHMXwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 19:52:37 -0400
MIME-Version: 1.0
In-Reply-To: <1407589454.5156.308.camel@marge.simpson.net>
References: <CA+80gGYVjprinWEJWbVq4VxjOLjQri8EvGAJ+sx+ihcOxdstCA@mail.gmail.com>
	<8738dm9t4z.fsf@tassilo.jf.intel.com>
	<1406532289.5133.223.camel@marge.simpson.net>
	<CA+80gGaohO-RaG0_tWZJEFzisrrBpgfiw-mxMrTfSK0N=k7gQA@mail.gmail.com>
	<1407059776.5156.108.camel@marge.simpson.net>
	<CA+80gGZJGX6PjzwptNJ5gU3SvCxaYT8v4id+4NqMAPwgAAS26Q@mail.gmail.com>
	<1407303693.5090.171.camel@marge.simpson.net>
	<CA+80gGYUohD617FcmtD5XyrFh2ENc2nXFA=91CmZ+8zFNOrzFQ@mail.gmail.com>
	<1407402199.5141.283.camel@marge.simpson.net>
	<CA+80gGZWSeoHFM-_uoGFCw4nJAkQGfTjEKfSyAaqTw6xmUVMvA@mail.gmail.com>
	<1407589454.5156.308.camel@marge.simpson.net>
Date: Wed, 13 Aug 2014 16:52:36 -0700
Message-ID: <CA+80gGYQypd7+DnQJgATrdAU4PZh7GKE6SAa1vsQS+0LZ35trQ@mail.gmail.com>
Subject: Re: [PATCH RFC] sched: deferred set priority (dprio)
From: Sergey Oboguev <oboguev.public@gmail.com>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        khalid.aziz@oracle.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 9, 2014 at 6:04 AM, Mike Galbraith <umgwanakikbuti@gmail.com> wrote:

> You are not going to convince me that it is cool to assign an imaginary
> priority to a SCHED_FIFO class task, and still call the resulting mutant
> a SCHED_FIFO class task. Those things have defines semantics. It is
> not ok for a SCHED_FIFO task of a lower priority to completely ignore a
> SCHED_FIFO task of a higher priority because it's part of an application
> which has one or more wild cards

I am not quite sure what you were trying to say by this, but I am grateful to
you for expressing your perspective and arguments in this discussion.

For one thing, it stimulated me to perform systematic review of the solution
space/tree, square inch by square inch, resulting in exhaustive logical
coverage of the solution space and thus an informal logical proof that there
is no any uncovered subspace that might hold any undiscovered yet solution.

Just so the results do not remain scattered, I will try to summarize and
categorize the findings about available solutions to the general "critical
section (or critical activity) preemption" problem category, and then draw
a conclusion stemming from this summary.

**********************

1) Post-preemption solutions.

(Such as priority inheritance or proxy execution, or even humble yield_to).

By the time a post-preemption solution is engaged, a cost had already been
paid, and further cost is paid to execute the solution. Sometimes this
aggregate cost can be small and acceptable within the overall context of an
application, sometimes it can be too high. Sometimes dependency chain cannot be
expressed and thus post-preemption solution is not possible at all (other than
just waiting for the scheduler to eventually resume the blocking thread and
keeping paying the cost in the meanwhile).

I won't be further enumerating this subcategory here and will focus instead on
the space of preemption avoidance/deferral solutions.

**********************

2) Reduction in the incidence of thread preemption.

There are chief ways to reduce the incidence of thread preemption.

One way is by enlarging the scheduling quantum. Its simplistic use however may
well backfire: if a lock holder is preempted while holding a lock (or thread
executing non-lock-related critical activity is preempted while inside this
activity) enlarged scheduling quantum would result in longer delay before the
thread will get resumed. Therefore this measure if employed should really be
coupled with one of post-preemption solutions.

Another way is the reduction of thread preemption incidence due to another
thread being woken up. Currently existing schemes of this kind (use of
!WAKEUP_PREEMPTION or SCHED_BATCH) are indiscriminate and victimize woken up
thread for the sake of executing thread regardless of whether the latter is
inside a critical section or not, however means can be provided to refine this
behavior and victimize the wakee only in case if currently executing thread is
actually inside a critical section. (And also when the section is exited, to
switch over to the postponed wakee ASAP).

A variation on this theme is an attempt at mitigation of preemption effects via
LAST_BUDDY.

The extent to which this scheme will be effective or not is obviously
determined by the following factors.

First, the probability of thread preemption while it is holding a lock, which
in turn is determined by:

(a) Percentage of time a worker thread holds a lock (or executes non-lock
related critical activity). It does not matter too much whether a thread enters
a critical section one time, stays in it for a while and then exits or whether
the thread enters and exits a critical section many times in a row staying
within it each time only a for very short instant. What matters is the
aggregate percentage of execution time a thread spends while inside a critical
section. This yields a rough probability any random preemption of a thread
(either through natural expiration of scheduling timeslice or due to the
preemption by a wakee) will result in lock holder or other critical activity
preemption.

(b) To an extent, request handler execution time. Very short times (well under
typical scheduling quantum) separated by voluntary yielding (such as when
waiting on the queue to pick up the next processing request) would result in
reduced preemption probability due to end-of-quantum events, however I won't be
further considering this special case here. (It is also not a particularly good
idea to use FIFO ordering for dequeueing of events or requests from a queue by
worker threads, as opposed to LIFO ordering, as it negatively impacts cache
locality and increases context switch probability.)

(c) Reduction in preemption attempt frequency. That's where the impact of the
discussed scheme comes in. With the scheme on, thread gets chiefly preempted on
quantum expiration, but not intra-quantum in favor of wakee threads. The
product of probabilities (a) and (c) determines how likely the thread is to be
preempted while inside a critical section/activity.

Second factor is the contention rate on a lock a preempted thread is holding
(or dependency occurrence rate for non-lock-related critical activities). It
defines whether the preemption is important in the aftermath of the
pre-emption, i.e. how likely it is to lead to an actual blocking of other
threads forward progress by the preemptee.

Third factor is the cost of post-preemption recovery response, and whether such
response is possible at all (i.e. whether dependency chain can be expressed at
run time).

Factor (c) depends on the frequency of the wakeups.

If a worker thread performs multiple synchronous IO requests or other OS-level
blocking operations within a timeslice, then probability of those completing
within a buddy's timeslice is significant. Thus for example database engine
with low cache pool size and not utilizing async processing model (akin to
nginx or node.js models) may have high incidence of wakeups within a buddy's
timeslice due to the completion of synchronous IO requests or other blocking
waits.

However a worker thread on the same database but configured with larger cache
size (so IO rate is low), or a worker thread in in-memory database, or a worker
thread in conventional database but utilizing async execution model will have
low incidence of wakeups within a buddy's timeslice, and in those case the use
of the discussed scheme won't make much improvement since all the improvement
it could have produced is already "in".

After any possible improvement yield from the discussed scheme is factored in,
the residual remains about the preemption at the end of timeslice, with
performance impact defined by the probability of preempted thread holding a
lock or executing other critical activity, i.e. factor (a), contention rate
(factor 2) and the cost of post-preemption recovery response (factor 3), and
whether such response is possible at all. This situation can essentially be
exemplified by a classic case of user-mode spinlock or hybrid spin-then-block
lock discussed earlier (https://lkml.org/lkml/2014/8/2/130). If the product of
listed factors is significant then the solution that attempts to reduce the
incidence of preemption may be effective in this goal or not, but the residual
cost still remains high and system responsiveness possibly choppy.

If reliance on post-preemption solution [*] is impossible because the structure
of the application does not allow to express the dependency chain at run time
(due to the use of 3rd party components, legacy components, or components out
of the scope of the project etc.), the inflicted cost may be particularly high.

    [*] Or in LAST_BUDDY case, if the wakee thread does not yield voluntarily
        very fast.

The discussed solution (reduction in the incidence of thread preemption) also
does not address those applications that have critical section of different
importance, some highly critical and others moderately critical or of low
criticality. Within the discussed solution scheme, there is no provisioning for
multiple levels of protection of application threads relative to each other,
nor relative to other threads in the system.

This solution also does not support "urgent handoff" scenario, in which thread
A sends to thread B a message requiring urgent processing, and thus a critical
section in thread  B is effectively initiated from the outside of the thread.
(An example is virtual machine application in which VCPU thread sends an IPI
interrupt to another VCPU thread, or virtual device handler sends an interrupt
to a VCPU thread, an interrupt that requires prompt processing or a cost will
be incurred.)

**********************

3) schedctl / preempt_delay / remaining_timeslice

This solution allows a thread to get a temporary reprieve from preemption by
another thread of similar scheduling policy. Protection interval can be
specified explicitly (in proposed prempt_delay patch) or defaulted to a
scheduling quantum (in Solaris/AIX schedctl), the purpose of the latter being
to avoid a preemption of a critical section of sub-timeslice duration that was
started close to the end of the timeslice.

Another variation of the same theme is to let a thread know how much time it
has before the expiration of the current timeslice. If the remaining time is
insufficient to complete a critical section, thread can yield and execute the
section when yield(...) returns, starting at the beginning of a new timeslice.
(The obvious drawbacks of this latter approach being more frequent yields,
scheduler calculations and context switches, more heavy reliance on the
estimate of the critical section duration, and more difficult management of
nested critical sections.)

Three shared drawbacks/limitations of this kind of solutions:

a) They do not support applications having critical sections with multiple
levels of criticality, i.e. capability for section priority ranging relative to
the context of the whole application nor other processes in the system.

b) They do not support "urgent handoff" scenarios.

c) An application may need to perform time-urgent processing without knowing in
advance how long it will take. In the majority of cases the processing may be
very short (a fraction of a scheduling timeslice), but occasionally may take
longer (several timeslices). Preempt_delay does provide a way to address it,
but schedctl and remaining_timeslice do not.

**********************

4) Conventional old-fashioned priority protection.

Drawbacks:

Potentially stronger interference with other tasks than in the solutions
discussed earlier, but more importantly not confined to a "jail"
well-manageable by system owner/administrator.

Strengths:

- efficient and well-defined intra-application preemption control
- support for multiple levels of criticality for locks or time-urgent sections
- support for urgent handoff

**********************

5) Scheduling based on a cost function expressing critical section information
assigned at development time or dynamically collected at run time and
representative of actual cost of preemption

https://lkml.org/lkml/2014/8/6/593
https://lkml.org/lkml/2014/8/8/492

As discussed, not pragmatically attainable.

**********************

6) Using a scheduling class with the properties and controls matching the
demands of the problem and relying on manual tuning of the system by its
owner/administrator to balance the interference between multiple application to
a relative degree desired by the administrator, while at the same time
maintaining the applications inopportune preemption frequency (displayed in
system statistics) within the bounds of an acceptable for the administrator.
The system provides control and monitoring tools, but it is left up to the
administrator to strike the balance between the applications which seems best
to him.

The description here
https://lkml.org/lkml/2014/8/9/37
summarizes the requirements and outlines a comprehensive solution, but as
formulated there (based on the assumption of adding a new scheduling class --
which is not really necessary, see below), requires high added complexity.

**********************

This exhausts the solution space. Everything logically possible has been
covered, and no other solution not falling into one of described categories can
logically exist.

There are certainly cases that can be satisfactorily addressed with options
(1), (2) or (3), but there are also those that cannot. For those, the remaining
options are (4) or (6) or do nothing.

Which brings us back to option (6) ...

At a closer look, option (6) as formulated in the original message is
tantamount to creation of RT-like range sitting just below regular RT range but
"caged" and better controllable, i.e. having additional controls vs. impact on
other applications and also additional statistics. The creation of such range
is where most of the complexity would have to come from if it were to be
created indeed.

The obvious question however is why to create separate "low RT-like" range
instead of simply using low part of existing RT range, but with added controls
and statistics.

The most important control -- a limit on the aggregate time application's
threads can spend in preemption-protected mode as the share (percentage) of
overall system time -- is already implemented by RT, as rt_bandwidth of a task
group.

The following pieces are missing, but can be provided:

a) Dynamic proportional scale-down of the bandwidths of multiple groups when
their aggregate demand starts to exceed system-wide limit.

b) When a group's RT use limit is exceeded, perhaps group's RT threads should
be allowed to continue as SCHED_NORMAL threads, rather than being stalled till
the next bandwidth period.

c) Per-group statistics on denial of set_priority(RT) to the group's threads
and on throttling of the group's threads because of the group exceeding its
quota of RT use. This statistics should be accessible to administrative tools
and to the application itself.

d) [Non-essential:] Maximum duration a thread within a group can stay at
elevated priority. This is merely a safeguard against the runaways threads and
is not essential, as group's RT bandwidth control allows an administrator to
take a corrective action.

e) Finally, the last issue is how priority range of APP1 can be stacked against
the priority range of APP2 and the latter against the priority range of APP3
and so on. The decision about their relative positioning is, by the definition
of (6), a judgment call of a system administrator/owner. Making such judgment
may be hard, but this difficulty is inherent in co-running multiple
applications each further possibly having critical section of multiple levels
of criticality. Option (5) would have helped to address this ranging/balancing
issue but unfortunately it is not pragmatically/economically attainable. Thus
the only recourse is to lay the decision on the shoulders of a system
administrator, however there is a question of the supporting mechanisms an
administrator can employ in making and implementing his decision.

One instrument is monitoring tools as outlined in (c).

The other is some way of fitting applications' priority ranges together.  One
possible approach could be to define cgroup-specific priority map mapping task
priority levels between group-relative level scale and system-wide level scale.
However maintaining multiple scales can be confusing and also cause ambiguity
during reverse translation when performing get_priority(), so perhaps an easier
and more straightforward way would be a requirement that a compliant
application should simply define its priority levels in an editable
configuration file, and perhaps also provide a method to reload this file if an
administrator wants to perform a dynamic adjustment without restarting the
application.

**********************

Conclusion:

I disagree with blanket indictment of the use of RT priority for the sake of
managing critical or time-urgent sections as "subversion" of RT mechanism -- I
do not see a rational argument for such a blanket indictment.  The judicious
use of RT matches the primary express purpose of the facilities intended to
support the execution of critical sections: temporarily victimize
lower-importance threads for the sake of higher-importance threads (with their
relative importance being dynamic).

However I do agree that a better controlled (including better
manageable/tunable by system owner), "caged" use of "tamed" RT would be
desirable. That's what option (6) would provide if implemented, and what can
now be partially provided by option (4) + per-cgroup quota on rt_bandwidth.

General conclusion of this overview is that solutions space for the overall
issue of executing critical/time-urgent sections is fragmented (and even
problem space itself is fragmented too). There is no single "holy grail"
solution that would address all use cases and use modes.

Given this, the right approach for an operating system would be to provide a
set of alternative mechanisms that expose various solutions (some of which may
also happen to be complementary in certain use cases) that in their entirety
address the whole space of use cases, and then let an application developer and
system owner decide between themselves which exact mechanisms are most suitable
for a particular purpose.

As for DPRIO in this context, DPRIO is a supplementary cost-reduction mechanism
usable with options (4) and (6) in high-frequency scenarios.

- Sergey
