Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397Ab3AXSv2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 13:51:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61864 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975Ab3AXSvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 13:51:25 -0500
Date: Thu, 24 Jan 2013 19:50:26 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Yasunori Goto <y-goto@jp.fujitsu.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Michael Davidson <md@google.com>,
        Suleiman Souhlal <suleiman@google.com>, Julien Tinnes <jln@google.com>,
        Aaron Durbin <adurbin@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Roland McGrath <roland@hack.frob.com>,
        Alexander Gordeev <agordeev@redhat.com>
Subject: Re: TASK_DEAD && ttwu() again (Was: ensure
	arch_ptrace/ptrace_request can never race with SIGKILL)
Message-ID: <20130124185026.GA18814@redhat.com>
References: <20130118185559.GA3773@redhat.com> <CA+55aFy=newnMbx53HipyWbRs2mUUPSqXXCpSfDLW78gkro37g@mail.gmail.com> <20130120192448.GA6771@redhat.com> <20130120192527.GC6771@redhat.com> <CA+55aFx1+hFSCa4nX80C30BkEOugXRvBZ=7LA+u+KOq_qSaJsg@mail.gmail.com> <20130121172151.GA4691@redhat.com> <CA+55aFwRkvEP5YJy+a=TFgDX==YuU7CJ+D_U+B2s4e1LX-nz3g@mail.gmail.com> <20130121194723.GA18775@redhat.com> <20130123191946.GA19101@redhat.com> <20130123195059.GH2373@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130123195059.GH2373@mtj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On 01/23, Tejun Heo wrote:
> Hello, Oleg.
>
> On Wed, Jan 23, 2013 at 08:19:46PM +0100, Oleg Nesterov wrote:
> >
> > And this means that a task doing
> >
> > 	current->state = STATE_1;
> > 	// no schedule() in between
> > 	current->state = STATE_2;
> > 	schedule();
> >
> > can be actually woken up by try_to_wake_up(STATE_1) even if it already
> > sleeps in STATE_2.
>
> Hmmm... nasty.
>
> ...
> > and we have the same problem again. So _I think_ that we we need another
> > mb() after unlock_wait() ?
>
> Seems so, or, maybe we should add barrier semantics to unlock_wait()?
> As it currently stands, it kinda invites misusages.

Perhaps, I am not sure. I agree, unlock_wait() without a barrier at
least on one side probably never makes sense.

> > And, afaics, in theory we can't simply move the current mb() down, after
> > unlock_wait().  (again, only in theory, if nothing else we should have
> > the implicit barrrers after we played with ->state in the past).
> >
> > Or perhaps we should modify ttwu_do_wakeup() to not blindly set RUNNING,
> > say, cmpxchg(old_state, RUNNING). But this is not simple/nice.
>
> I personally think this is the right thing to do short of requiring
> locking on current->state changes.  The situation is a bit muddy
> because we're generally requiring sleepers to loop while still having
> cases where things don't work that way.  It's a little scary that we
> require looping to protect against stray wakeups, which can be very
> rare, without any way to verify/test.
>
> The waker would be acquiring the cacheline exclusively one way or the
> other, so I don't think doing cmpxchg would add much overhead.  We
> would definitely want to do comparisons tho.

Still cmpxchg() is not free, Peter argued that ttwu() is the very hot
path and I understand his concern. And in fact this change doesn't look
very simple...

And this can not eliminate the spurious wakeups in general. Plus in
this particular case (I mean the race described by the comment above
spin_unlock_wait in do_exit) we could equally blame rw_semaphore, not
try_to_wake_up().

So I leave this to scheduler people.

Oleg.

