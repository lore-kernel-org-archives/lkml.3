Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab3HMIjX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 04:39:23 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48362 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815Ab3HMIjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 04:39:20 -0400
Date: Tue, 13 Aug 2013 10:39:06 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Galbraith <bitbucket@online.de>, Andi Kleen <ak@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        arjan@linux.intel.com
Subject: Re: [RFC] per-cpu preempt_count
Message-ID: <20130813083906.GT27162@twins.programming.kicks-ass.net>
References: <20130812115113.GE27162@twins.programming.kicks-ass.net>
 <CA+55aFznj9WqGa_Qa0B4=5iTio2br54uJG7xkm6otN2sG2P=8w@mail.gmail.com>
 <520920AF.1050407@zytor.com>
 <CA+55aFwP0nXWJ3-YXCxZC3kCJ-5nVG7dEbqqJa-HF5pdEc+xsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwP0nXWJ3-YXCxZC3kCJ-5nVG7dEbqqJa-HF5pdEc+xsg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 11:53:25AM -0700, Linus Torvalds wrote:
> On Mon, Aug 12, 2013 at 10:51 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> >
> > So we would have code looking something like:
> >
> >         decl %fs:preempt_count
> >         jnz 1f
> >         cmpb $0,%fs:need_resched
> >         je 1f
> >         call __preempt_schedule
> > 1:
> >
> > It's a nontrivial amount of code, but would seem a fair bit better than
> > what we have now, at least.
> 
> Well, we currently don't even bother checking the preempt count at
> all, and we just optimistically assume that we don't nest in the
> common case. The preempt count is then re-checked in
> __preempt_schedule, I think.
> 
> Which sounds like a fair approach.
> 
> So the code would be simplified to just
> 
>          decl %fs:preempt_count
>          cmpb $0,%fs:need_resched
>          jne .. unlikely branch that calls __preempt_schedule
> 
> which is not horrible. Not *quite* as nice as just doing a single
> "decl+js", but hey, certainly better than what we have now.

OK, so doing per-cpu need_resched is a trivial patch except for the
mwait side of things. Then again, Arjan already asked for per-cpu
need_resched specifically for mwait so we might as well do that.

The only complication is that IIRC Arjan wants to stagger the mwait
cache-lines and we would very much like our preempt_count and
need_resched (and possible some other __switch_to related things) in the
same cacheline.

Afaict that'll yield a double indirect again :/
