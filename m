Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002AbaHFFlj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 01:41:39 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:57938 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbaHFFlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 01:41:37 -0400
Message-ID: <1407303693.5090.171.camel@marge.simpson.net>
Subject: Re: [PATCH RFC] sched: deferred set priority (dprio)
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Sergey Oboguev <oboguev.public@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        khalid.aziz@oracle.com
Date: Wed, 06 Aug 2014 07:41:33 +0200
In-Reply-To: <CA+80gGZJGX6PjzwptNJ5gU3SvCxaYT8v4id+4NqMAPwgAAS26Q@mail.gmail.com>
References: <CA+80gGYVjprinWEJWbVq4VxjOLjQri8EvGAJ+sx+ihcOxdstCA@mail.gmail.com>
	 <8738dm9t4z.fsf@tassilo.jf.intel.com>
	 <1406532289.5133.223.camel@marge.simpson.net>
	 <CA+80gGaohO-RaG0_tWZJEFzisrrBpgfiw-mxMrTfSK0N=k7gQA@mail.gmail.com>
	 <1407059776.5156.108.camel@marge.simpson.net>
	 <CA+80gGZJGX6PjzwptNJ5gU3SvCxaYT8v4id+4NqMAPwgAAS26Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-08-05 at 16:28 -0700, Sergey Oboguev wrote: 
> On Sun, Aug 3, 2014 at 2:56 AM, Mike Galbraith <umgwanakikbuti@gmail.com> wrote:
> 
> > SCHED_NORMAL where priority escalation does not work as preemption proofing
> 
> Remember, DPRIO is not for lock holders only.
> 
> Using DPRIO within SCHED_NORMAL policy would make sense for an application that
> has "soft" time-urgent section where it believes strong protection
> from preemption
> is not really necessary, and just a greater claim to CPU time share would do,
> in cases where the application does not know beforehand if the section will be
> short or long, and in majority of cases is short (sub-millisecond), but
> occasionally can take longer.

Every single time that SCHED_NORMAL task boosts its priority (nice)
during a preemption, the math has already been done, vruntime has
already been adjusted.  The boat has already sailed, and your task is
waving from the dock.  All this does is waste cycles and add yet more
math to the done deal.  Sure, when it gets the CPU back, its usage will
be weighed differently, it will become more resistant to preemption, but
in no way immune.  There is nothing remotely deterministic about this,
making it somewhat of an oxymoron when combined with critical section.

Add group scheduling to the mix, and this becomes even more pointless.

> > what I see is a programmer using a mechanism designed
> > to initiate preemption arming his tasks with countermeasures to the very
> > thing he initiates.
> 
> I disagree. The exact problem is that it is not a developer who initiates the
> preemption, but the kernel or another part of application code that is unaware
> of other thread's condition and doing it blindly, lacking the information about
> the state of the thread being preempted and the expected cost of its preemption
> in this state. DPRIO is a way to communicate this information.

Nope, I'm still not buying.  It's a bad idea to play with realtime
classes/priorities blindly, if someone does that, tough titty.

What DPRIO clearly does NOT do is to describe critical sections to the
kernel.  If some kthread prioritizes _itself_ and mucks up application
performance, file a bug report, that kthread is busted.  Anything a user
or application does with realtime priorities is on them.

Stuffing a priority card up selected tasks sleeves does not describe
critical sections to the kernel, it only lets the programmer stymie
himself, some other programmer... or perhaps the user.

> > Deferred preempt seems to be what you want, but you
> > invented something very different.
> 
> "Simple" deferred preempt is one use case.
> 
> More complex case is "ranked" deferred preemption, when there are multiple
> contending contexts, and there is a need to express relative costs of
> victimizing one vs. another.

You didn't invent either of those.

Hm.  I don't even recall seeing the task pulling a card from its sleeve
checking to see if the other player didn't have a joker up its sleeve.

> > I'm just not seeing the beauty in your patch.
> 
> Perhaps I might have a dissenting sense of beauty.
> But then, it is not only about the beauty (which is subjective anyway), but
> even more so about the pudding.
> 
> Seriously though, it's really simple: the whole range of available remedies is
> divided across post-preemption solutions and preemption-avoidance solutions
> (and of course designing app structure for minimizing the contention in the
> first place, but for the sake of this discussion we can assume this had been
> done to the extent possible). Post-preemption solutions unavoidably incur cost
> (and a part of this cost is incurred even before the solution can be engaged).
> If this cost can be maintained insignificant for the given use case, great.
> However what do you propose to do with those use cases where it cannot? To tell
> a developer (or IT manager) "we do not care about your 5% or 20% losses, and if
> you do not like it, use another OS that would work better for you"? This would
> not sound too productive to me.

I didn't suggest ignoring of any problems.  I know full well that folks
doing Oracle/SAP stuff can in fact make prettier numbers using realtime
class.  I also know they can get themselves into trouble, those troubles
having inspired bugzilla to pull my chain.  I didn't say "go away", I
created a hack to _enable_ them to turn their pet piggies loose in god
mode.  I didn't try to disarm or dissuade them from aiming the rt pistol
at their own toes, I gave them toe-seeking bullets.

You're reading me entirely wrong, I'm not trying to discourage you from
inventing a better bullet, I just think this particular bullet is a dud.

-Mike

