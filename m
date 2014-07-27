Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365AbaG0EC3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 00:02:29 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:48043 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbaG0EC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 00:02:28 -0400
Message-ID: <1406433735.5115.38.camel@marge.simpson.net>
Subject: Re: [PATCH RFC] sched: deferred set priority (dprio)
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Sergey Oboguev <oboguev.public@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>
Date: Sun, 27 Jul 2014 06:02:15 +0200
In-Reply-To: <CA+80gGZRxXfabODZoFMoBju=j+7+Ne8sUYaKBPzo4c9kTjL8_g@mail.gmail.com>
References: <CA+80gGYVjprinWEJWbVq4VxjOLjQri8EvGAJ+sx+ihcOxdstCA@mail.gmail.com>
	 <1406365137.5091.152.camel@marge.simpson.net>
	 <CA+80gGZRxXfabODZoFMoBju=j+7+Ne8sUYaKBPzo4c9kTjL8_g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-07-26 at 11:30 -0700, Sergey Oboguev wrote: 
> On Sat, Jul 26, 2014 at 1:58 AM, Mike Galbraith
> <umgwanakikbuti@gmail.com> wrote:
> > On Fri, 2014-07-25 at 12:45 -0700, Sergey Oboguev wrote:
> >> [This is a repost of the message from few day ago, with patch file
> >> inline instead of being pointed by the URL.]
> >>
> >> This patch is intended to improve the support for fine-grain parallel
> >> applications that may sometimes need to change the priority of their threads at
> >> a very high rate, hundreds or even thousands of times per scheduling timeslice.
> >>
> >> These are typically applications that have to execute short or very short
> >> lock-holding critical or otherwise time-urgent sections of code at a very high
> >> frequency and need to protect these sections with "set priority" system calls,
> >> one "set priority" call to elevate current thread priority before entering the
> >> critical or time-urgent section, followed by another call to downgrade thread
> >> priority at the completion of the section. Due to the high frequency of
> >> entering and leaving critical or time-urgent sections, the cost of these "set
> >> priority" system calls may raise to a noticeable part of an application's
> >> overall expended CPU time. Proposed "deferred set priority" facility allows to
> >> largely eliminate the cost of these system calls.
> >
> > So you essentially want to ship preempt_disable() off to userspace?
> >
> 
> Only to the extent preemption control is already exported to the userspace and
> a task is already authorized to control its preemption by its RLIMIT_RTPRIO,
> RLIMIT_NICE and capable(CAP_SYS_NICE).
> 
> DPRIO does not amplify a taks's capability to elevate its priority and block
> other tasks, it just reduces the computational cost of frequest
> sched_setattr(2) calls.

Exactly.  You are abusing realtime, and you are not the only guy out
there doing that.  What you want is control over a userspace critical
section, and you are willing to do whatever is necessary to get that.  I
think your code is a really good example of how far people are willing
to go, but I hope this goes nowhere beyond getting people to think about
what you and others want.

I would say cut to the chase, if what you want/need is a privileged
userspace lock, make one, and put _all_ of the ugliness inside it.
Forget about this "Hello Mr. kernel, here's what I would have done to
get what I want if I weren't such a cheap bastard, if you think about
preempting me, pretend I actually did that instead" business.  Forget
about all that RLIMIT_RTPRIO and access list stuff too, either you're
privileged or you're not, it's not like multiple users could coexist
peacefully anyway.  Maybe you could make a flavor of futex that makes
the owner non-preemptible, checks upon release or such.

Note: if you do touch futex.c, you'll definitely want to document that
you eliminated every last remote possibility of breaking anything, and
donning Nomex underwear before posting would not be a bad idea ;-)

-Mike

