Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959AbaHEXD1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 19:03:27 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:45483 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbaHEXD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 19:03:26 -0400
MIME-Version: 1.0
In-Reply-To: <20140803083006.GA1758@amd.pavel.ucw.cz>
References: <CA+80gGYVjprinWEJWbVq4VxjOLjQri8EvGAJ+sx+ihcOxdstCA@mail.gmail.com>
	<20140730130238.GE13965@amd.pavel.ucw.cz>
	<CA+80gGbOx9istV4UG7PF+qam81u+HzJyjznE5sjVV82jjWa=MQ@mail.gmail.com>
	<20140803083006.GA1758@amd.pavel.ucw.cz>
Date: Tue, 5 Aug 2014 16:03:25 -0700
Message-ID: <CA+80gGawMhRxtnbGddphj-hGzqNBmizEuqA9TevvNn47DjLAEw@mail.gmail.com>
Subject: Re: [PATCH RFC] sched: deferred set priority (dprio)
From: Sergey Oboguev <oboguev.public@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 3, 2014 at 1:30 AM, Pavel Machek <pavel@ucw.cz> wrote:

> it seems to be a security issue to me.
> If root renices the application to high nice value, application should
> not be able to work around it by the DPRIO interface.

There is no such issue.

Since 2.6.12, Linux does allow a task that had been renice'd to increase its
priority back as long as it is within RLIMIT_NICE. See see man page for nice(2)
and the reference there under EPERM to RLIMIT_NICE. Or sys_nice(...) and
can_nice(...) in kernel/sched/core.c.

If the administrator wants to clamp down the task in a way it would be unable
to come back, he should change the task's rlimit for RLIMIT_NICE.

DPRIO does honor the change in RLIMIT_NICE (as well as in RLIMIT_RTPRIO) and
won't let a task cross those limits.

> You mean "we rely on applications handling the situation they can't and will
not handle"?

Not really.

There are two different cases to be considered.

One is when an application's thread priority is changed from inside the
application, in a coordinated code, and the code is specifically set up to
handle asynchronous thread priority changes.

(For example, if the application is a VM, and a virtual device sends an
interrupt to a VCPU, the device handler may want to bump up the VCPU thread
priority so the interrupt gets processed promptly. When VCPU notices and
dequeues the sent interrupt, it reevaluates the thread priority based on the
totality of synchronous intra-VCPU conditions and currently visible
asynchronous conditions such as a set of pending interrupts and sets new thread
priority accordingly.)

Another case is when an application's thread priority is changed from the
outside of the application in an arbitrary way. There is no radical difference
in this case between DPRIO and regular set_priority.

Such an external priority change can indeed be disruptive for an application,
but it is disruptive for an application that uses regular set_priority aw well.
Suppose the thread was running some critical tasks and/or holding some critical
locks, and used regular set_priority to that end, and then was knocked down.
This would be disruptive for an application using regular set_priority just as
it would be for one using DPRIO. The exact mechanics of the disruption would be
somewhat different, but the disruption would be present in both cases.

Likewise, an application has means for recovery both in regular set_priority
and DPRIO cases. In the case of an application using regular set_priority the
recovery will automatically happen on the next set_priority call. In DPRIO case
it may take a bunch of dprio_set calls, but given that they are meant to be
used in high-frequency invocation case, the recovery is likely to happen pretty
fast as well, and after a certain number of cycles the "writeback" priority
change cached in the userspace is likely to get "written through" to the
kernel, albeit this process is somewhat "stochastic" and sequences can be
constructed when it won't be for quite a while. If the application wished to
give it some guaranteed predictability, it could use dprio_setnow(prio,
DPRIO_FORCE) in every N-th invocation instead of dprio_set(prio).

Nevertheless this indirection is one reason why I do not think making regular
set_priority a wrapper around DPRIO is a good idea. It would strip application
developer of direct control. unless DPRIO_FORCE flag was used, but then it
becomes regular set_priority again.

Another reason is that error reporting in DPRIO case is delayed (e.g. via a
callback in DPRIO library implementation), and that's different from the
semantics of regular set_priority interface.

To summarize it, regular sety_priority (e.g. sched_setattr) defines the
interface that is immediate (synchronous) and uncached, whereas DPRIO is
deferred (asynchronous) and cached. Semantics is really different to let the
former be wrapped around the latter without a distortion of the semantics.

- Sergey
