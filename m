Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758AbaG0JJl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 05:09:41 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:41250 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbaG0JJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 05:09:37 -0400
MIME-Version: 1.0
In-Reply-To: <1406433735.5115.38.camel@marge.simpson.net>
References: <CA+80gGYVjprinWEJWbVq4VxjOLjQri8EvGAJ+sx+ihcOxdstCA@mail.gmail.com>
	<1406365137.5091.152.camel@marge.simpson.net>
	<CA+80gGZRxXfabODZoFMoBju=j+7+Ne8sUYaKBPzo4c9kTjL8_g@mail.gmail.com>
	<1406433735.5115.38.camel@marge.simpson.net>
Date: Sun, 27 Jul 2014 02:09:36 -0700
Message-ID: <CA+80gGZ=raShFq9du3a_67=eLgx8DdEW+hUY377MiLHtKW23ZQ@mail.gmail.com>
Subject: Re: [PATCH RFC] sched: deferred set priority (dprio)
From: Sergey Oboguev <oboguev.public@gmail.com>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 26, 2014 at 9:02 PM, Mike Galbraith
<umgwanakikbuti@gmail.com> wrote:
> On Sat, 2014-07-26 at 11:30 -0700, Sergey Oboguev wrote:
>> On Sat, Jul 26, 2014 at 1:58 AM, Mike Galbraith
>> <umgwanakikbuti@gmail.com> wrote:
>> > On Fri, 2014-07-25 at 12:45 -0700, Sergey Oboguev wrote:
>> >> [This is a repost of the message from few day ago, with patch file
>> >> inline instead of being pointed by the URL.]
>> >>
>> >> This patch is intended to improve the support for fine-grain parallel
>> >> applications that may sometimes need to change the priority of their threads at
>> >> a very high rate, hundreds or even thousands of times per scheduling timeslice.
>> >>
>> >> These are typically applications that have to execute short or very short
>> >> lock-holding critical or otherwise time-urgent sections of code at a very high
>> >> frequency and need to protect these sections with "set priority" system calls,
>> >> one "set priority" call to elevate current thread priority before entering the
>> >> critical or time-urgent section, followed by another call to downgrade thread
>> >> priority at the completion of the section. Due to the high frequency of
>> >> entering and leaving critical or time-urgent sections, the cost of these "set
>> >> priority" system calls may raise to a noticeable part of an application's
>> >> overall expended CPU time. Proposed "deferred set priority" facility allows to
>> >> largely eliminate the cost of these system calls.
>> >
>> > So you essentially want to ship preempt_disable() off to userspace?
>> >
>>
>> Only to the extent preemption control is already exported to the userspace and
>> a task is already authorized to control its preemption by its RLIMIT_RTPRIO,
>> RLIMIT_NICE and capable(CAP_SYS_NICE).
>>
>> DPRIO does not amplify a taks's capability to elevate its priority and block
>> other tasks, it just reduces the computational cost of frequest
>> sched_setattr(2) calls.

> You are abusing realtime

I am unsure why you would label priority ceiling for locks and priority
protection for other forms of time-urgent sections as an "abuse".

It would appear you start from a presumption that the sole valid purpose for
ranging task priorities should ever be only hard real-time applications such as
plant process control etc., but that's not a valid or provable presumption, but
rather an article of faith -- a faith, as you acknowledge, a lot of developers
do not share, and a rational argument to the contrary of this faith is that
there are no all-fitting satisfactory and practical alternative solutions to
the problems that are being solved with those tools, that's the key reason why
they are used. The issue then distills to a more basic question of whether this
faith should be imposed on the dissenting application developers, and whether
Linux should provide a mechanism or a policy.

As for DPRIO specifically, while it may encourage somewhat the use of priority
ceiling and priority protection, but it does not provide an additional basic
mechanism beyond one already exported by the kernel (i.e. "set priority"), it
just makes this pre-existing basic mechanism cheaper to use in certain use
cases.

> if what you want/need is a privileged userspace lock

The problem is not reducible to locks. Applications also have time-urgent
critical section that arise from wait and interaction chains not expressible
via locking notation.

> you could make a flavor of futex that makes the owner non-preemptible

Lock owner should definitely be preemptible by more time-urgent tasks.

> it's not like multiple users could coexist peacefully anyway

It depends. A common sense suggests not to run an air traffic control system on
the same machine as an airline CRM database system, but perhaps one might
co-host CRM and ERP database instances on the same machine.

Indeed, applications that are installed with the rights granting them an access
to an elevated priority are generally those that are important for the purpose
of the system they are deployed on. The machine they are installed on may
either be dedicated to running this particular application, or it may be used
for running a set of primary-importance applications that can coexist.

As an obvious rule of thumb, applications using elevated priorities for the
sake of deterministic response time should not be combined "on equal footing"
with non-deterministic applications using elevated priorities for the reasons of
better overall system throughput and responsiveness. If they are ever combined
at all, the former category should use priority levels about the latter. It is
however may often be possible -- as far as priority use is concerned -- to
combine multiple applications of the latter (non-deterministic) category, as
long as their critical sections combined take less than a total of CPU time.

If applications are fundamentally incompatible by their aggregate demand for
resources exceeding available system resources, be it CPU or memory resources,
then of course they cannot be successfully combined.

It is undoubtful one can easily construct a mix of applications that are not
compatible with each other (as an airline example mentioned earlier
exemplifies) or overcommit the system beyond the acceptable service
level terms, but that's self-obvious, so what this should be a point to?

As far as DPRIO is concerned, it just gives some CPU time that otherwise
would have been expended essentially wastefully back and thus adds some
margin to available system resources, not less, not more.

The purpose of DPRIO is not to instruct system owners what applications they
should or should not combine, these decisions are completely independent of
DPRIO and the latter is irrelevant for these decisions.

Nor to instruct application developers as to how they should structure their
applications -- these decisions are normally driven by factors of much greater
magnitude and force than petty factors such as available system calls.

Its only purpose is to let a developer make an application somewhat more
performant once the decision on the structure has been made, or even forced on
the developer a priori as the only fitting solution by the sheer nature of the
task being solved.

> getting people to think about what you and others want

It's not like anything of this is really very new.
The thiking on these matters has been going on since the 1980's.

- Sergey


P.S. As a related non-technical consideration from the real world...
I have a friend who makes living as a scalability expert for one of two
companies in Russia that provide Oracle support. Oracle installations
in Russia are typically high-end, larger than installations in comparable
industry sectors in the U.S., and some of the largest Oracle installations
in the world are in Russia (for unhealthy economic reasons unfortunately).
They are deployed and serviced by the company my friend works for, and
once upon a time we have been going with him over various scalability
issues and stories. Their customers generally prefer Solaris or AIX,
rather than Linux or Windows. There is a multitude of reasons for this,
of course. But one technical reason on the list (I would not exagerate
its importance, it's a long list, and then there are business factors
that matter even more, but it is on the list) is that Solaris and AIX provide
a form of preemption control for critical sections that translates to a
better performance and cheaper cost per transaction, let us say may be 3-5%
better at high load, which in turn translates to ROI better by may be 2%.
People who make business decisions may not understand system calls, but
they do understand ROI. The question then is, is it favorable for Linux
to have "minus" on such lists?
