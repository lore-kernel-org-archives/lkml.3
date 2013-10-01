Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901Ab3JARkk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 13:40:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47724 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077Ab3JARki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 13:40:38 -0400
Date: Tue, 1 Oct 2013 19:33:37 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] introduce prepare_to_wait_event()
Message-ID: <20131001173337.GA16890@redhat.com>
References: <20130930152242.207382649@infradead.org> <20131001170137.GA8560@redhat.com> <20131001172504.GV3657@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131001172504.GV3657@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01, Peter Zijlstra wrote:
>
> On Tue, Oct 01, 2013 at 07:01:37PM +0200, Oleg Nesterov wrote:
> > 		if (exclusive)							\
> > 			__wait.flags = WQ_FLAG_EXCLUSIVE;			\
> > 		else								\
> > 			__wait.flags = 0;					\
>
> 		__wait.flags = exclusive * WQ_FLAG_EXCLUSIVE;
>
> or is that too obscure? ;-)

I do not mind ;) The generated code should be the same.

> > 		for (;;) {							\
> > 			long intr = prepare_to_wait_event(&wq, &__wait, state);	\
>
> 			int __intr = ...;
>
> The interruptible bit doesn't actually need long;

Yes, it can be even "bool", but see below.

> and local variables
> have __ prefixes in this context.

Yes, yes, will fix.

> > 			if (condition)						\
> > 				break;						\
> > 										\
> > 			if (___wait_is_interruptible(state) && intr) {		\
> > 				__ret = intr;					\

Since typeof(__ret) == typeof(intr) gcc can (likely) simply do "mov r1, r2",
so "long intr" make the code better.

I am not saying that "int intr" can make it worse, but to me "long" looks
better in this context. But I wouldn't mind to change this.

> > Compiler should optimize out "long intr" if !interruptible/killable.
>
> Yeah, and I think even the if (0 && __intr) would suffice for the unused
> check; otherwise we'd have to adorn the thing with __maybe_unused.

Hmm yes, I didn't see any warning during the compilation, but perhaps
__maybe_unused is needed, thanks.

> > What do you think?
>
> That would actually work I think.. the ___wait_is_interruptible() nicely
> does away with the unused code; the only slightly more expensive thing
> would be the prepare_to_wait_event() thing.
>
> And if that really turns out to be a problem we could even re-use
> ___wait_is_interruptible() to call prepare_to_wait() instead.

OK, thanks.

So I'll wait until your series is applied the resend it officially.

Oleg.

