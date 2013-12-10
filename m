Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751414Ab3LJVR0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 16:17:26 -0500
Received: from www.linutronix.de ([62.245.132.108]:51408 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086Ab3LJVRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 16:17:25 -0500
Date: Tue, 10 Dec 2013 22:17:22 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Dave Jones <davej@redhat.com>, Darren Hart <dvhart@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: process 'stuck' at exit.
In-Reply-To: <CA+55aFx3UkrX5Q5kL7mWOoEwd+cr3mTjmsZBw-ZRZ-OsU3i4pg@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1312102157230.28330@ionos.tec.linutronix.de>
References: <20131210154724.GA30020@redhat.com> <CA+55aFxgFAfcQKDoDhmJcCRb5pfxumxJ9OmpUhhNzs+CY_Yqqw@mail.gmail.com> <alpine.DEB.2.02.1312102001090.28330@ionos.tec.linutronix.de> <CA+55aFzLnheC6W+Db=-MVr6aR5UzP-c1Q1yk_aN-9gxSjUpANw@mail.gmail.com>
 <alpine.DEB.2.02.1312102130580.28330@ionos.tec.linutronix.de> <CA+55aFx3UkrX5Q5kL7mWOoEwd+cr3mTjmsZBw-ZRZ-OsU3i4pg@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Dec 2013, Linus Torvalds wrote:

> On Tue, Dec 10, 2013 at 12:33 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> >
> > The -EAGAIN is when the user value changed, simplified:
> 
> No it's not.
> 
> Thomas, stop this crap already. Look at the f*cking code carefully
> instead of just dismissing cases.
> 
> The worrisome EAGAIN case is
> 
>   futex_requeue
>     futex_proxy_trylock_atomic
>       futex_lock_pi_atomic
>         lookup_pi_state:
>           ret = (p->flags & PF_EXITPIDONE) ? -ESRCH : -EAGAIN;
> 
> and now futex_requeue() will do "goto repeat" for that EAGAIN case.
> 
> So, Christ, Thomas, you have now *twice* dismissed a real concern with
> totally bogus "that can never happen" by explaining some totally
> unrelated *simple* case rather than the much more complex case.
> 
> So please. Really. Truly look at the code and thing about it, or shut
> the f*ck up. No more of this shit where you glance at the code, find
> some simple case, and say "that can't happen", and dismiss the
> bug-report.

Well, I spent a fricking long time to work on that code and find the
absurdest bugs in it and I'm well aware of the exit issue.
 
> So far Dave's bug-reports have generally pretty much universally shown
> real bugs. Being dismissive about it is not helpful, quite the
> reverse.

I know and I used that information more than once to carefully track
down the real reason. I never dismissed a single report.
 
> Maybe the loop I'm pointing at cannot happen, but *your* explanation
> for why it couldn't happen was pure and utter garbage, and was clearly
> because you hadn't even bothered to look at all the cases.

I might have been sloppy and not really explaining why I think, that
the requeue_pi exit case is not likely.

To make that loop happen it requires the following:

1) An actual user of requeue_pi, which can only be the fuzzer as glibc
   does not support it. But Daves last fuzzed syscall was something
   else.

2) The report said, that the last fuzzing test was already done and
   the fuzzer app is about to exit.

   That involves futex_requeue from deep inside glibc thread
   library. And that is NOT using REQUEUE_PI.

3) So now even IF it would use requeue_pi then this would require,
   that the outer PI lock is already held by some other task which is
   already in the process of exiting. IOW, this lock would be held by
   something which did not release it before exit and already set
   PF_EXITING in exit_signals() and then got stuck for ever before
   reaching: tsk->flags |= PF_EXITPIDONE;

I still think, that it is highly unlikely, but to make sure I already
asked Dave before reading your rant to fire up the tracer, so we know
for sure where hell the thing is looping.

Thanks,

	tglx

