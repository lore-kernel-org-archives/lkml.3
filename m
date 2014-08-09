Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538AbaHIIin (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 04:38:43 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:32800 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbaHIIij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 04:38:39 -0400
MIME-Version: 1.0
In-Reply-To: <1407402199.5141.283.camel@marge.simpson.net>
References: <CA+80gGYVjprinWEJWbVq4VxjOLjQri8EvGAJ+sx+ihcOxdstCA@mail.gmail.com>
	<8738dm9t4z.fsf@tassilo.jf.intel.com>
	<1406532289.5133.223.camel@marge.simpson.net>
	<CA+80gGaohO-RaG0_tWZJEFzisrrBpgfiw-mxMrTfSK0N=k7gQA@mail.gmail.com>
	<1407059776.5156.108.camel@marge.simpson.net>
	<CA+80gGZJGX6PjzwptNJ5gU3SvCxaYT8v4id+4NqMAPwgAAS26Q@mail.gmail.com>
	<1407303693.5090.171.camel@marge.simpson.net>
	<CA+80gGYUohD617FcmtD5XyrFh2ENc2nXFA=91CmZ+8zFNOrzFQ@mail.gmail.com>
	<1407402199.5141.283.camel@marge.simpson.net>
Date: Sat, 9 Aug 2014 01:38:38 -0700
Message-ID: <CA+80gGbcjHHWLW-ALaguc+HwhcK1H5NDC+OeiOk-MLEofe52VQ@mail.gmail.com>
Subject: Re: [PATCH RFC] sched: deferred set priority (dprio)
From: Sergey Oboguev <oboguev.public@gmail.com>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        khalid.aziz@oracle.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 7, 2014 at 2:03 AM, Mike Galbraith <umgwanakikbuti@gmail.com> wrote:

> I see subversion of a perfectly functional and specified mechanism

Just wondering if the following line of thinking would sound just as much an
anathema from your perspective or perhaps a bit less terrible...

Proceeding from the observations (e.g. https://lkml.org/lkml/2014/8/8/492) that
representative critical section information is not pragmatically expressible at
development time or dynamically collectable by the application at run time, the
option still remains to put the weight of managing such information on the
shoulders of the final link in the chain, the system administrator, providing
him with application-specific guidelines and also with monitoring tools.

It might look approximately like this.

It might be possible to define the scheduling class or some other kind of
scheduling data entity for the tasks utilizing preemption control. The tasks
belonging to this class and having critical section currently active are
preemptible by RT or DL tasks just like normal threads, however they are
granted a limited and controlled degree of protection against preemption by
normal threads, and also limited ability to urgently preempt normal threads on
a wakeup.

Tasks inside this class may belong to one of the groups somewhat akin to
cgroups (perhaps may be even implemented as an extension to cgroups).

The properties of a group are:

* Maximum critical section duration (ms). This is not based on actual duration
of critical sections for the application and may exceed it manyfold. The
purpose is merely to be a safeguard against the runaways. If a task stays
inside a critical section longer than the specified time limit, it loses the
protection against the preemption and becomes for practical purposes a normal
thread.  The group keeps a statistics of how often the tasks in the group
overstay in critical section and exceed the specified limit.

* Percentage of CPU time that members of the group can collectively spend
inside their critical sections over some sampling interval while enjoying the
protection from preemption. This is the critical parameter. If group members
collectively spend larger share of CPU time in their critical sections
exceeding the specified limit, they start losing protection from preemption by
normal threads, to keep their protected time within the quota.

For example the administrator may designate that threads in group "MyDB" can
spend no more than 20% of system CPU time combined in the state of being
protected from preemption, while threads in group "MyVideoEncoder" can spend
not more than 10% of system CPU time in preemption-protected state.

If actual aggregate critical-section time spent by threads in all the groups
and also by RT tasks starts pushing some system-wide limit (perhaps
rt_bandwidth), available group percentages are dynamically scaled down, to
reserve some breathing space for normal tasks, and to depress groups in some
proportional way. Scaling down can be either proportional to the group quotas,
or can be controlled by separate scale-down weights.

A monitoring tool can display how often the tasks in the group requesting
protection from preemption are not granted it or lose it because of
overdrafting the group quota. System administrator may then either choose to
enlarge the group's quota, or leave it be and accept the application running
sub-optimally.

An application can also monitor the statistics on rejection of preemption
protection for its threads (and also actual preemption frequency while inside a
declared critical section state) and if the rate is high then issue an advisory
message to the administrator.

Furthermore:

Threads within a group need to have relative priorities. There should be a
way for a thread processing a highly critical section to be favored over a
thread processing medium-significance critical section.

There should also be a way to change a thread's group-relative priority both
from the inside and from the outside of a thread. If thread A queues an
important request for processing by thread B, A should be able to bump B's
group-relative priority.

Thread having non-zero group-relative priority is considered to be within a
critical section.

If thread having non-zero group-relative priority is woken up, it preempts
normal thread, as long as the group's critical section time usage is within
the group's quota.

The tricky thing is how to correlate priority ranges of different groups. I.e.
suppose there is a thread T1 belonging to group APP1 with group-relative
priority 10 within APP1 and a thread T2 belonging to group APP2 with
group-relative priority 20 within APP2. Which thread is more important and
should run first? Perhaps this can be left to system administrator who can
adjust "base priority" property of a group thus sliding groups upwards or
downwards relative to each other (or, generally, using some form of intergroup
priority mapping control).

This is not suggest any particular interface of course, but just a crude sketch
of a basic approach. I am wondering if you would find it more agreeable within
your perspective than the use of RT priorities, or still fundamentally
disagreeable.

(Personally I am not particularly thrilled by the complexity that would have
to be added and managed.)

- Sergey
