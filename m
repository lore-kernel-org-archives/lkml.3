Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082Ab3AWTvL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 14:51:11 -0500
Received: from mail-qe0-f50.google.com ([209.85.128.50]:57428 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab3AWTvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 14:51:08 -0500
Date: Wed, 23 Jan 2013 11:50:59 -0800
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
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
Message-ID: <20130123195059.GH2373@mtj.dyndns.org>
References: <CA+55aFyEsU-pkX557A-m+xoGkA_v+fXEyA8z8HbJ5J8K1jObeg@mail.gmail.com>
 <20130118185559.GA3773@redhat.com>
 <CA+55aFy=newnMbx53HipyWbRs2mUUPSqXXCpSfDLW78gkro37g@mail.gmail.com>
 <20130120192448.GA6771@redhat.com>
 <20130120192527.GC6771@redhat.com>
 <CA+55aFx1+hFSCa4nX80C30BkEOugXRvBZ=7LA+u+KOq_qSaJsg@mail.gmail.com>
 <20130121172151.GA4691@redhat.com>
 <CA+55aFwRkvEP5YJy+a=TFgDX==YuU7CJ+D_U+B2s4e1LX-nz3g@mail.gmail.com>
 <20130121194723.GA18775@redhat.com>
 <20130123191946.GA19101@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130123191946.GA19101@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.

On Wed, Jan 23, 2013 at 08:19:46PM +0100, Oleg Nesterov wrote:
> Let me remind the problem. To oversimplify, we have
> 
> 	try_to_wake_up(task, state)
> 	{
> 		lock(task->pi_lock);
> 
> 		if (task->state & state)
> 			task->state = TASK_RUNNING;
> 
> 		unlock(task->pi_lock);
> 	}
> 
> And this means that a task doing
> 
> 	current->state = STATE_1;
> 	// no schedule() in between
> 	current->state = STATE_2;
> 	schedule();
> 
> can be actually woken up by try_to_wake_up(STATE_1) even if it already
> sleeps in STATE_2.

Hmmm... nasty.

...
> and we have the same problem again. So _I think_ that we we need another
> mb() after unlock_wait() ?

Seems so, or, maybe we should add barrier semantics to unlock_wait()?
As it currently stands, it kinda invites misusages.

> And, afaics, in theory we can't simply move the current mb() down, after
> unlock_wait().  (again, only in theory, if nothing else we should have
> the implicit barrrers after we played with ->state in the past).
> 
> Or perhaps we should modify ttwu_do_wakeup() to not blindly set RUNNING,
> say, cmpxchg(old_state, RUNNING). But this is not simple/nice.

I personally think this is the right thing to do short of requiring
locking on current->state changes.  The situation is a bit muddy
because we're generally requiring sleepers to loop while still having
cases where things don't work that way.  It's a little scary that we
require looping to protect against stray wakeups, which can be very
rare, without any way to verify/test.

The waker would be acquiring the cacheline exclusively one way or the
other, so I don't think doing cmpxchg would add much overhead.  We
would definitely want to do comparisons tho.

Thanks.

-- 
tejun
