Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933528AbaJDAWu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:22:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9974 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756017AbaJDAWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 20:22:48 -0400
Date: Sat, 4 Oct 2014 02:19:23 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Anvin <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Chuck Ebbert <cebbert.lkml@gmail.com>
Subject: Re: [tip:x86/asm] x86: Speed up ___preempt_schedule*() by using
	THUNK helpers
Message-ID: <20141004001923.GA5539@redhat.com>
References: <20140921184153.GA23727@redhat.com> <tip-0ad6e3c5199be12c9745da8f8b9e3c9f8066c235@git.kernel.org> <542E2B05.5080607@oracle.com> <20141003232631.GA3439@redhat.com> <CA+55aFwT3KFkGMgWz9Gag+xMHD=5X3RNz-iMswGD88_wnUT-Eg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwT3KFkGMgWz9Gag+xMHD=5X3RNz-iMswGD88_wnUT-Eg@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03, Linus Torvalds wrote:
>
> On Fri, Oct 3, 2014 at 4:26 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > And I _think_ that preempt_schedule_context() should be fixed anyway,
> > although I am not sure there is no something else. It does:
> >
> >
> >         preempt_disable_notrace();
> >         prev_ctx = exception_enter();
> >         preempt_enable_no_resched_notrace();
> >
> >         preempt_schedule();
> >
> >         preempt_disable_notrace();
> >         exception_exit(prev_ctx);
> >         preempt_enable_notrace();
> >
> > but exception_exit() is heavy, it is quite possible that TIF_NEED_RESCHED
> > and thus set_preempt_need_resched() can be set again when we call
> > preempt_enable_notrace(). And in this case preempt_schedule_context()
> > will be called recursively.
>
> Why the hell is it using "preempt_enable_notrace()" in the first
> place? Shouldn't it use "preempt_enable_no_resched_notrace()",

Yes, this this is the main problem.

> > Frederic, how about the patch below?
>
> Why do it multiple times? The whole concept is fundamentally racy
> anyway, in it doesn't guarantee that any *new* "need_resched()" would
> be reacted to (since they could happen *after* the test),

But in this case we rely on scheduler_ipi() and return-from-irq path?

> The real fix would appear to be to use
> "preempt_enable_no_resched_notrace()", which your patch did, but
> without the loop.

Not sure... preempt_schedule() does the same and afaics for good reason.

But perhaps you are right. I am already sleeping, will try to recheck
tomorrow. And in fact I got lost in preempt.h files... I can't even
understand why __preempt_schedule_context() is only called by
preempt_enable_notrace().

Oleg.

