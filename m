Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203Ab3JARZR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 13:25:17 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55502 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616Ab3JARZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 13:25:12 -0400
Date: Tue, 1 Oct 2013 19:25:04 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] introduce prepare_to_wait_event()
Message-ID: <20131001172504.GV3657@laptop.programming.kicks-ass.net>
References: <20130930152242.207382649@infradead.org>
 <20131001170137.GA8560@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131001170137.GA8560@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 01, 2013 at 07:01:37PM +0200, Oleg Nesterov wrote:
> This patch moves the signal-pending checks and part of DEFINE_WAIT's
> code into the new helper: prepare_to_wait_event().
> 
> Yes, sure, prepare_to_wait_event() becomes a little bit slower than
> prepare_to_wait/prepare_to_wait_exclusive. But this is the slow path
> anyway, we are likely going to sleep. IMO, it is better to shrink
> .text, and on my build the difference is
> 
> 	- 5124686 2955056 10117120        18196862        115a97e vmlinux
> 	+ 5123212 2955088 10117120        18195420        115a3dc vmlinux
> 
> The code with the patch is
> 
> 	#define ___wait_is_interruptible(state)					\
> 		(!__builtin_constant_p(state) ||				\
> 			state == TASK_INTERRUPTIBLE || state == TASK_KILLABLE)	\
> 
> 	#define ___wait_event(wq, condition, state, exclusive, ret, cmd)	\
> 	({									\
> 		__label__ __out;						\
> 		wait_queue_t __wait;						\
> 		long __ret = ret;						\
> 										\
> 		INIT_LIST_HEAD(&__wait.task_list);				\
> 		if (exclusive)							\
> 			__wait.flags = WQ_FLAG_EXCLUSIVE;			\
> 		else								\
> 			__wait.flags = 0;					\

		__wait.flags = exclusive * WQ_FLAG_EXCLUSIVE;

or is that too obscure? ;-)

> 										\
> 		for (;;) {							\
> 			long intr = prepare_to_wait_event(&wq, &__wait, state);	\

			int __intr = ...;

The interruptible bit doesn't actually need long; and local variables
have __ prefixes in this context.

> 										\
> 			if (condition)						\
> 				break;						\
> 										\
> 			if (___wait_is_interruptible(state) && intr) {		\
> 				__ret = intr;					\
> 				if (exclusive) {				\
> 					abort_exclusive_wait(&wq, &__wait, 	\
> 							     state, NULL); 	\
> 					goto __out;				\
> 				}						\
> 				break;						\
> 			}							\
> 										\
> 			cmd;							\
> 		}								\
> 		finish_wait(&wq, &__wait);					\
> 	__out:	__ret;								\
> 	})
> 
> Compiler should optimize out "long intr" if !interruptible/killable.

Yeah, and I think even the if (0 && __intr) would suffice for the unused
check; otherwise we'd have to adorn the thing with __maybe_unused.

> What do you think?

That would actually work I think.. the ___wait_is_interruptible() nicely
does away with the unused code; the only slightly more expensive thing
would be the prepare_to_wait_event() thing.

And if that really turns out to be a problem we could even re-use
___wait_is_interruptible() to call prepare_to_wait() instead.
