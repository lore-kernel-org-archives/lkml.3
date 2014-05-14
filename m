Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529AbaENWyr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 18:54:47 -0400
Received: from www.linutronix.de ([62.245.132.108]:48720 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbaENWyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 18:54:46 -0400
Date: Thu, 15 May 2014 00:54:53 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Carlos O'Donell" <carlos@redhat.com>
cc: Darren Hart <dvhart@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Darren Hart <darren@dvhart.com>,
        Davidlohr Bueso <davidlohr@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Clark Williams <williams@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Roland McGrath <roland@hack.frob.com>,
        Jakub Jelinek <jakub@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [patch 0/3] futex/rtmutex: Fix issues exposed by trinity
In-Reply-To: <5373D94E.5030800@redhat.com>
Message-ID: <alpine.DEB.2.02.1405150025360.6261@ionos.tec.linutronix.de>
References: <20140512190438.314125476@linutronix.de> <20140513035404.GA68181@dvhart-mac01.local> <alpine.DEB.2.02.1405131100510.6261@ionos.tec.linutronix.de> <53731608.3010803@redhat.com> <alpine.DEB.2.02.1405141155260.6261@ionos.tec.linutronix.de>
 <5373D94E.5030800@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2014, Carlos O'Donell wrote:
> On 05/14/2014 06:26 AM, Thomas Gleixner wrote:
> > On Wed, 14 May 2014, Carlos O'Donell wrote:
> >> On 05/13/2014 05:08 AM, Thomas Gleixner wrote:
> >>> So anything else than ESRCH and EDEADLK is ignored and then the thing
> >>> happily returns 0 at the end. Unlock is the same:
> >>
> >> The code is valid so long as you expect only ESRCH and EDEADLK
> >> to be the only errors the kernel returns.
> > 
> > Brilliant assumption, really. So we rather return 0 to the user than
> > having a catch for that case?
> 
> That's correct. At the time the argument was that performance of
> the hot path was the only thing that mattered. For each additional
> error code we add the hot path instruction length is enlarged.
> I'm not arguing for or against, but simply stating the design
> criteria that I know were part of the original work. Thus it would
> have been perfectly valid to ignore all error codes except those
> that mattered to the implementation, leaving failures like ENOMEM
> to bubble up elsewhere instead of slowing down threads.

Why are you even trying to excuse these design decisions which are
outright stupid or worse?

1) Ignoring return vales which were already known at the time when the
   code was implemented is either complete incompetence or malice.

2) Ignoring return values in general is a brainwrecked idea. If the
   other party returns something you cannot deal with, whether caused
   by typo/stupidity or the need to introduce a new one does not
   matter.
  
   Simply because a glibc based test case for an interface will not
   expose that typo/brainfart or the new real requirement to return
   something different.

> I will make my personal opinion clear:
> 
> - Internal defects should raise immediate assertions.
> 
> - Real problems like resource availability, deadlocks, and
>   other recoverable errors should result in the API returning
>   an appropriate error code that must not diverge from the POSIX
>   definitions for those codes (when such a definition exists).
> 
> I'm not a believer in "only the hot path matters", there are such
> things as robustness and error detection, and they matter.

We are on the same page then.
  
> Awesome. I like the direction this conversation is taking, since this is
> actionable for me to fix the implementation.

Same here.
 
> >> Are those other errors actionable by the user?
> > 
> > Define actionable. Most of them are in my opinion.
> > 
> > Some of them like -EWOULDBLOCK for non PI or -EAGAIN are for glibc
> > internal consumption.
> 
> That's what I mean. Can the user do anything useful with the error?

I completely understand what you mean. Just our interpretations might
differ here and there, but that's a pure technical problem as long as
we agree that ignoring stuff is not the way to go :)
 
> However, if glibc detects an inconsistency between the kernel and
> glibc, I am not excited about returning EINVAL to the user, I would
> rather abort or assert that the data structures have been corrupted.
> The principal here being to abort or assert as close to the point at
> which the corruption occurred to help the developer debug the problem.
> I would argue that returning EINVAL to a library or application that
> already manged to corrupt state is unlikely to know how to properly
> handle the error anyway.
> 
> Would you agree?

I personally would prefer the return value, so I might be able to shut
down at least parts of my app gracefully, but that's more a
philosophical problem.

Putting my personal preference aside, I agree that it's better to
assert as 99% of callers will just ignore the return value anyway

> > We return EPERM, EFAULT and EINVAL on unlock.
> > 
> >    EPERM    Tells you that the user space / kernel state is
> > 	    inconsistent, because kernel thinks the owner is not current.
> 
> I would assert on that.

Fair enough.
     	    
> >    EINVAL   That would be a glibc bug calling unlock pi for a non futex,
> >    	    which has non pi waiters in the kernel.
> > 
> > 	    That one was explicitely there from the very beginning.
> 
> I would also assert on this.

Of course. There's nothing the user can do about it.
 
> > And as I demonstrated in the other mail, it's easy to corrupt state
> > w/o glibc even being able to notice. So you better handle that
> > gracefully instead of making utterly stupid assumptions.
> 
> The assumptions are predicated on a particular design that doesn't
> seem to match your expectations. I accept that in this case you're
> correct. We should be catching state corruption and asserting. It's
> useful and prevents the program from continuing to corrupt other
> potentially more important program state.

Agreed.
 
> As I mentioned before I'm not overly worried about a few extra
> instructions in the hot path. I am worried about programs that run
> as if they were correct but in fact are corrupting state. Debugging
> this is both costly and painful.

It's extremly painful for someone who is not familiar with the guts of
the kernel and the glibc details. Probably leading to very creative
"workarounds" ...
 
> Nobody has looked at this code in years, likely because all parties
> thought they were done, but had in fact agreed to distinct expectations
> and assumptions about the implementation.
> 
> I want it fix, and I'm in a position to move resources to fix it.

Great. If you need any help on particular details what the kernel side
is expecting and returning, I'm happy to help.

Thanks,

	tglx
