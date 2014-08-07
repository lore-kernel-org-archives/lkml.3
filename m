Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400AbaHGJD0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 05:03:26 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:53474 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757268AbaHGJDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 05:03:23 -0400
Message-ID: <1407402199.5141.283.camel@marge.simpson.net>
Subject: Re: [PATCH RFC] sched: deferred set priority (dprio)
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Sergey Oboguev <oboguev.public@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        khalid.aziz@oracle.com
Date: Thu, 07 Aug 2014 11:03:19 +0200
In-Reply-To: <CA+80gGYUohD617FcmtD5XyrFh2ENc2nXFA=91CmZ+8zFNOrzFQ@mail.gmail.com>
References: <CA+80gGYVjprinWEJWbVq4VxjOLjQri8EvGAJ+sx+ihcOxdstCA@mail.gmail.com>
	 <8738dm9t4z.fsf@tassilo.jf.intel.com>
	 <1406532289.5133.223.camel@marge.simpson.net>
	 <CA+80gGaohO-RaG0_tWZJEFzisrrBpgfiw-mxMrTfSK0N=k7gQA@mail.gmail.com>
	 <1407059776.5156.108.camel@marge.simpson.net>
	 <CA+80gGZJGX6PjzwptNJ5gU3SvCxaYT8v4id+4NqMAPwgAAS26Q@mail.gmail.com>
	 <1407303693.5090.171.camel@marge.simpson.net>
	 <CA+80gGYUohD617FcmtD5XyrFh2ENc2nXFA=91CmZ+8zFNOrzFQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-08-06 at 18:26 -0700, Sergey Oboguev wrote: 
> On Tue, Aug 5, 2014 at 10:41 PM, Mike Galbraith
> <umgwanakikbuti@gmail.com> wrote:

(ok, seems you're not addressing the reasonable, rather me;)

> The only reason why anyone would want to use DPRIO instead of regular nice in
> this case is because it might be unknown beforehand whether the job will be
> short or might take a longer time, with majority of work items being very short
> but occasionally taking longer. In this case using DPRIO would let to cut the
> overhead for majority of section instances. To reiterate, this is a marginal
> and most likely rare use case, but given the existence of uniform interface
> I just do not see why to block it on purpose.

Hey, if I had a NAK stamp handy, your patch would be wearing one ;-)

> > If some kthread prioritizes _itself_ and mucks up application
> > performance, file a bug report, that kthread is busted.  Anything a user
> > or application does with realtime priorities is on them.
> 
> kthreads do not need RT, they just use spinlocks ;-)

That's wrong if kthreads feed your load in any way, but your saying that
implies to me that your argument that the kernel is the initiator is
void.  You are not fighting a kernel issue, you have userspace issues.

The prioritization mechanism works fine, but you want to subvert it to
do something other than what it is designed and specified to do.

Whereas you wrote this patch, see "enhancement", I see "subversion" when
I read it.  Here lies our disagreement.

> On a serious note though, I am certainly not saying that injudicious use of RT
> (or even nice) cannot disrupt the system, but is it reason enough to summarily
> condemn the judicious use as well?

Bah, if Joe Users decides setiathome is worthy of SCHED_FIFO:99, it is
by definition worthy of SCHED_FIFO:99.  I couldn't care less, it's none
of my business what anybody tells their box to do. 

> >> I disagree. The exact problem is that it is not a developer who initiates the
> >> preemption, but the kernel or another part of application code that is unaware
> >> of other thread's condition and doing it blindly, lacking the information about
> >> the state of the thread being preempted and the expected cost of its preemption
> >> in this state. DPRIO is a way to communicate this information.
> 
> > What DPRIO clearly does NOT do is to describe critical sections to the
> > kernel.
> 
> First of all let's reflect that your argument is not with DPRIO as such. DPRIO
> after all is not a separate scheduling mode, but just a method to reduce the
> overhead of regular set_priority calls (i.e. sched_setattr & friends).

I see subversion of a perfectly functional and specified mechanism.

> You argument is with the use of elevated priority as such, and you are saying
> that using RT priority range (or high nice) does not convey to the kernel the
> information about the critical section.

I maintain that task priority does not contain any critical section
information whatsoever.  Trying to use priority to delineate critical
sections is a FAIL, you must HAVE the CPU to change your priority.

"Time for me to boost my<POW>self.. hey, wtf happened to the time!?!"

That's why you subverted the mechanism to not perform the specified
action.. at all, not merely not at this precise instant, because task
priority cannot be used by any task to describe a critical section.

> I do not agree with this, not wholly anyway. First of all, it is obvious that
> set_priority does convey some information about the section, so perhaps a more
> accurate re-formulation of your argument could be that it is imperfect,
> insufficient information.

I assert that is that there is _zero_ critical section information
present.  Create a task, you create a generic can, giving it a priority
puts that can on a shelf.  Can content is invisible to the kernel, it
can't see a critical section of the content, or whether the content as a
whole is a nicely wrapped up critical section of a larger whole.  There
is no section anything about this, what you have is a generic can of FOO
on a shelf BAR.

If you need a way to describe userspace critical sections, make a way to
identify userspace critical sections.  IMHO, task priority ain't it,
that's taken, and has specified semantics.

> Let's try to imagine then what could make more perfect information. It
> obviously should be some cost function describing the cost that would be
> incurred if the task gets preempted. Something that would say (if we take the
> simplest form) "if you preempt me within the next T microseconds (unless I
> cancel or modify this mode), this preemption would incur cost X upfront further
> accruing at a rate Y".

You can build something more complex, but the basic bit of missing
information appears to me to be is plain old enter/exit.

> One issue I see with this approach is that in real life it might be very hard
> for a developer to quantify the values for X, Y and T. Developer can easily
> know that he wants to avoid the preemption in a given section, but actually
> quantifying the cost of preemption (X, Y) would take a lot of effort
> (benchmarking) and furthermore really cannot be assigned statically, as the
> cost varies depending on the load pattern and site-specific configuration.
> Furthermore, when dealing with multiple competing contexts, developer can
> typically tell that task A is more important than task B, but quantifying the
> measure of their relative importance might be quite difficult.
> 
> Likewise, quantifying "T" is likely to be similarly difficult.
> 
> (And then even suppose the developer knew that the section completes within let
> us say 5 ms at three sigmas, is this reason good enough to preempt the task
> at 6 ms for the sake of a normal timesharing thread? - I am uncertain.)
> 
> Thus it appears to me that even such an interface existed today, developers
> would be daunted by it and prefer to use RT instead as something more
> manageable/usable, controllable and predictable.
> 
> But then, suppose such an interface existed and task expressing their critical
> section information through it were -- within their authorized quotas for T and
> X/Y -- given precedence over normal threads but preemptible by RT or DL tasks.
> Would not it pretty much amount to the existence of low-RT range sitting just
> below regular RT range, low-RT range that tasks could enter for a time? Just
> like they can enter regular RT range now with set_priority, also for a time.
> Would it be really different from judicious use of existing RT, where tasks
> controlling "chainsaws" run at prio range 50-90, while database engine threads
> utilize prio range 1-10 in their critical sections?

I still see the deferred preemption thing as possibly being useful, or,
some completely new scheduling class could do whatever you want it to.

> (The only difference being that after the expiration of interval T task
> priority is knocked down -- which a judiciously written application does
> anyway, so the difference is just a protection against bugs and runaways -- and
> then task becomes more subject to preemption, after which other threads are free
> to use PI/PE to resolve the dependency when they know it, and if they
> do not then
> in a subset of those use cases when spinning of old or incoming waiters cannot
> be shut off, it is either back to using plain RT or sustaining uncontrollable
> losses.)
> 
> I would be most glad to see a usable interface providing information to the
> scheduler about a task's critical sections emerge (other than RT), but for the
> considerations outlined I am doubtful of the possibility.
> 
> Apart from this and coming back to DPRIO, even if solution more satisfactory
> than judicious use of RT existed, how long might it take for it to be worked
> out? If the history of EDF from ReTiS concept to merging into 3.14 mainline is
> a guide, it may take quite a while, so stop-gap solution would have a value
> even because of timing considerations until something better emerges... that
> is, assuming it can and ever does.

Lord knows.

-Mike 

