Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbaHEX2s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 19:28:48 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:47952 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbaHEX2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 19:28:46 -0400
MIME-Version: 1.0
In-Reply-To: <1407059776.5156.108.camel@marge.simpson.net>
References: <CA+80gGYVjprinWEJWbVq4VxjOLjQri8EvGAJ+sx+ihcOxdstCA@mail.gmail.com>
	<8738dm9t4z.fsf@tassilo.jf.intel.com>
	<1406532289.5133.223.camel@marge.simpson.net>
	<CA+80gGaohO-RaG0_tWZJEFzisrrBpgfiw-mxMrTfSK0N=k7gQA@mail.gmail.com>
	<1407059776.5156.108.camel@marge.simpson.net>
Date: Tue, 5 Aug 2014 16:28:45 -0700
Message-ID: <CA+80gGZJGX6PjzwptNJ5gU3SvCxaYT8v4id+4NqMAPwgAAS26Q@mail.gmail.com>
Subject: Re: [PATCH RFC] sched: deferred set priority (dprio)
From: Sergey Oboguev <oboguev.public@gmail.com>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        khalid.aziz@oracle.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 3, 2014 at 2:56 AM, Mike Galbraith <umgwanakikbuti@gmail.com> wrote:

> SCHED_NORMAL where priority escalation does not work as preemption proofing

Remember, DPRIO is not for lock holders only.

Using DPRIO within SCHED_NORMAL policy would make sense for an application that
has "soft" time-urgent section where it believes strong protection
from preemption
is not really necessary, and just a greater claim to CPU time share would do,
in cases where the application does not know beforehand if the section will be
short or long, and in majority of cases is short (sub-millisecond), but
occasionally can take longer.

> what I see is a programmer using a mechanism designed
> to initiate preemption arming his tasks with countermeasures to the very
> thing he initiates.

I disagree. The exact problem is that it is not a developer who initiates the
preemption, but the kernel or another part of application code that is unaware
of other thread's condition and doing it blindly, lacking the information about
the state of the thread being preempted and the expected cost of its preemption
in this state. DPRIO is a way to communicate this information.

> Deferred preempt seems to be what you want, but you
> invented something very different.

"Simple" deferred preempt is one use case.

More complex case is "ranked" deferred preemption, when there are multiple
contending contexts, and there is a need to express relative costs of
victimizing one vs. another.

> I'm just not seeing the beauty in your patch.

Perhaps I might have a dissenting sense of beauty.
But then, it is not only about the beauty (which is subjective anyway), but
even more so about the pudding.

Seriously though, it's really simple: the whole range of available remedies is
divided across post-preemption solutions and preemption-avoidance solutions
(and of course designing app structure for minimizing the contention in the
first place, but for the sake of this discussion we can assume this had been
done to the extent possible). Post-preemption solutions unavoidably incur cost
(and a part of this cost is incurred even before the solution can be engaged).
If this cost can be maintained insignificant for the given use case, great.
However what do you propose to do with those use cases where it cannot? To tell
a developer (or IT manager) "we do not care about your 5% or 20% losses, and if
you do not like it, use another OS that would work better for you"? This would
not sound too productive to me.

This leaves then preemption-avoidance solutions which are about communicating
the cost of the preemption to the kernel in one way or another. DPRIO is one of
such solutions, and I believe is as good or better than the others (I explained
earlier in which cases it is better than schedctl).

(Seemingly transcending this divide may only be the delegation of scheduling
decisions from the kernel to the userspace via mechanisms attempted in a number
of experimental OSes and likely to see the light of the day again with the
expected raise of library OSes/unikernels, but at the end of the day this is
still a set of preemption-avoidance vs. post-preemption solutions, just boxed
differently, and utilizing greater application state knowledge bandwidth
available within the single address space.)

I hear you dislike, but I think it is misplaced.

I am unsure about the exact origins of your outlook, but I suspect it might
possibly be arising at least in part from an aspiration for finding a "holy
grail" solution that would cover all the cases (after all, kernel developers
tend to be psychologically perfectionists, at least within this little hobby of
kernel development), and while such an aspiration is admirable per se, but
unfortunately this holy grail just does not exist.

Likewise, an aspiration to make sure that everything "mixes and matches" with
absolutely everything else in all cases while it may be admirable but is
futile in its absolutistic form because there are obvious limits to it, and
furthermore applications that need to rely on preemption-avoidance are most
often primary-importance applications for the installation, and as such
mixing and matching with absolutely everything else is not essential and
definitely not a priority compared to letting the primary application to run
better. Furthermore, many if not most of primary-importance applications
deployments today are already single-purposed, and with continued VM sprawl
this trend would only grow, and with it the emphasis on letting a primary
application or practical well-defined application set run better over an
absolutistic arbitrary mixing and matching will grow as well. This of course
certainly not to deny the importance of mix-and-match environments such as
desktop systems or personal devices, but it is important to recognize the
difference in requirements/priorities between the environments.

- Sergey
