Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358AbaG1EQN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 00:16:13 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:46832 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbaG1EQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 00:16:12 -0400
MIME-Version: 1.0
In-Reply-To: <8738dm9t4z.fsf@tassilo.jf.intel.com>
References: <CA+80gGYVjprinWEJWbVq4VxjOLjQri8EvGAJ+sx+ihcOxdstCA@mail.gmail.com>
	<8738dm9t4z.fsf@tassilo.jf.intel.com>
Date: Sun, 27 Jul 2014 21:16:11 -0700
Message-ID: <CA+80gGaxy5z89skqY3B2160hXo_5q4EaNSsbO2vDwDnePp0Vsw@mail.gmail.com>
Subject: Re: [PATCH RFC] sched: deferred set priority (dprio)
From: Sergey Oboguev <oboguev.public@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, khalid.aziz@oracle.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 27, 2014 at 6:19 PM, Andi Kleen <andi@firstfloor.org> wrote:
>> [This is a repost of the message from few day ago, with patch file
>> inline instead of being pointed by the URL.]
>
> Have you checked out the preemption control that was posted some time
> ago? It did essentially the same thing, but somewhat simpler than your
> patch.
>
> http://lkml.iu.edu/hypermail/linux/kernel/1403.0/00780.html

Yes, I have seen this discussion. The patch suggested by Khalid implements a
solution very much resembling Solaris/AIX schedctl. Schedctl is less generic
and powerful than dprio. I compared dprio vs. schedctl in the write-up
https://raw.githubusercontent.com/oboguev/dprio/master/dprio.txt

To quote from there,

[--- Quote ---]

The Solaris schedctl [...]
does not provide a way to associate a priority with the resource
whose lock is being held (or, more generally, with thread application-specific
logical state; see the footnote below). An application is likely to have a
range of locks with different criticality levels and different needs for
holder protection [*]. For some locks, holder preemption may be tolerated
somewhat, while other locks are highly critical, furthermore for some lock
holders preemption by a high-priority thread is acceptable but not a preemption
by a low-priority thread. The Solaris/AIX schedctl does not provide a
capability for priority ranging relative to the context of the whole
application and other processes in the system.

    [*] We refer just to locks here for simplicity, but the need of a thread
        for preemption control does not reduce to locks held alone, and may
        result from other intra-application state conditions, such as executing
        a time-urgent fragment of code in response to a high-priority event
        (that may potentially be blocking for other threads) or other code
        paths that can lead to wait chains unless completed promptly.

Second, in some cases application may need to perform time-urgent processing
without knowing in advance how long it will take. In the majority of cases the
processing may be very short (a fraction of a scheduling timeslice), but
occasionally may take much longer (such as a fraction of a second). Since
schedctl  would not be effective in the latter case, an application would have
to resort to system calls for thread priority control in all cases [*], even
in the majority of "short processing" cases, with all the overhead of this
approach.

    [*] Or introduce extra complexity, most likely very cumbersome, by trying
        to gauge and monitor the accumulated duration of the processing, with
        the intention to transition from schedctl to thread priority elevation
        once a threshold has been reached.

[--- End of quote ---]

Even so, I felt somewhat puzzled by the response to Khalid's
delay-preempt patch.
While some arguments put forth against it were certainly valid in their own
right, but somehow their focus seemed to be that the solution won't interoperate
well with all the conceivable setups and application mixes, won't solve all the
concurrency issues, and the worst of all won't slice bread either. Whereas my
perception (perhaps incorrectly) was that this patch was not meant to solve a
whole range of problems and to be a feature enabled by default in a generic
system, but rather a specialized  feature configurable in special-purpose
systems (e.g. database servers, Khalid was doing it for Oracle, and his JVM
use case I believe is also in this context) dedicated to running a
primary-importance application that utilizes this mechanism and meant to solve
a very particular problem of this specific category of system deployment cases.
It appeared to me that the participants to delay-preempt patch discussion
might have had different idea of the implied use scope of the suggested
feature, and it might have influenced the direction of the discussion.

- Sergey
