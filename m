Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814AbaFZXuI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 19:50:08 -0400
Received: from www.linutronix.de ([62.245.132.108]:46039 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbaFZXuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 19:50:06 -0400
Date: Fri, 27 Jun 2014 01:50:03 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Subbaraman Narayanamurthy <subbaram@codeaurora.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kthread: Fix the race condition when kthread is parked
In-Reply-To: <53AC9114.9070106@codeaurora.org>
Message-ID: <alpine.DEB.2.10.1406270035360.5170@nanos>
References: <53AB2643.8050901@codeaurora.org> <alpine.DEB.2.10.1406260004110.5170@nanos> <53AC9114.9070106@codeaurora.org>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2014, Subbaraman Narayanamurthy wrote:
> On 06/25/14 17:43, Thomas Gleixner wrote:
> > The kthread park/unpark logic has the following issue:
> > 
> > Task   CPU 0				CPU 1
> > 
> > T1     unplug cpu1
> >         kthread_park(T2)
> >         set_bit(KTHREAD_SHOULD_PARK);
> > 	  wait_for_completion()
> > T2					parkme(X)
> > 				   	  __set_current_state(TASK_PARKED);
> > 				   	  while
> > (test_bit(KTHREAD_SHOULD_PARK)) {
> > 				     	    if
> > (!test_and_set_bit(KTHREAD_IS_PARKED))
> > 				              complete();
> > 			             	    schedule();
> > T1   plug cpu1
> > 
> > --> premature wakeup of T2, i.e. before unpark, so T2 gets scheduled on
> >      CPU 0

> I understood the explanation above. But still I don't understand how this
> premature wakeup of T2 is happening/possible?

Come on. You have a machine which reproduces the issue. So some
moderate tracing should tell you that ...

Without using my lost crystal ball, I bet that it's a premature per
cpu timer interrupt.

> Also, what will happen if the task state is not in TASK_PARKED when
> __kthread_unpark is called?  __kthread_bind will fail silently
> causing the same problem.

Right you are, but thinking more about it:

Nothing is supposed to wakeup a parked thread except the unpark
machinery. So the real question is: What causes the premature wakeup?

Darn, I should have thought about that before, but you tricked my
overloaded brain into believing that this is a real issue.

No, it's not.

The parked state is not any different from creating a new kthread,
advertise the thread to possible wakers and then do the bind.

So yes, the code is fine and the BUG_ON() is rightfully asserting
here.

> Thanks for the patch. I've tested (running hotplug tests) it for sometime and
> looks good so far. Can you please submit it?

So you have a legitimate question about the correctness of the patch
and then you ask me to apply it?

Again, we do not apply patches which "fix" an issue just because we do
not observe it anymore. We apply them when the problem at hand is
fully understood and the solution solves all aspects.

Thanks,

	tglx


