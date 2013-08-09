Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758255Ab3HINKq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 09:10:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48189 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757990Ab3HINKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 09:10:45 -0400
Date: Fri, 9 Aug 2013 15:04:57 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Long Gao <gaolong@kylinos.com.cn>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Patch for lost wakeups
Message-ID: <20130809130457.GA27493@redhat.com>
References: <tencent_26310211398C21034BD3B2F9@qq.com> <CA+55aFwAnWZGkXbyLmL3RxQGW-dX_jjDBPfA5PjxeVWn==a6tA@mail.gmail.com> <20130808191749.GA12062@redhat.com> <CA+55aFw+vEp6+q+QUZm5rf+sKR9z76HWzEqWjoiLtataym5uwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw+vEp6+q+QUZm5rf+sKR9z76HWzEqWjoiLtataym5uwA@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08, Linus Torvalds wrote:
>
> On Thu, Aug 8, 2013 at 12:17 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> >> and as far as I can tell we have proper barriers for those (the
> >> scheduler gets the rq lock
> >
> > Yes, but... ttwu() takse another lock, ->pi_lock to test ->state.
>
> The lock is different, but for task_state, the main thing we need to
> worry abotu is memory ordering, not locks.

Yes sure. However, afaics in this particular case the locking does
matter.

Because:

>    The case of signals is special, in that the "wakeup criteria" is
> inside the scheduler itself, but conceptually the rule is the same.

yes, and because the waiter lacks mb().

IOW. The code like

	__set_current_state(STATE);
	if (!CONDITION)
		schedule();

is obviously racy, it doesn't have mb().

But the code like

	__set_current_state(TASK_INTERRUPTIBLE);
	schedule();

was always considered as correct, it relies on try_to_wake_up/schedule
interaction. But after try_to_wake_up() was changed to use task->pi_lock
this becomes racy in theory. Afaics.

This __set_current_state(TASK_INTERRUPTIBLE) can leak into the critical
section protected by rq->lock, it can be reordered with the CONDITION
check, and in this case CONDITION == signal_pending().

No?

> > we don't
> > have mb() on the other side and schedule() can miss SIGPENDING?
>
> But we do have the mb, at least on x86. The "set_tsk_thread_flag()" is
> a memory barrier there.

Sorry for confusion, I meant "other side", see above.

> But that's why I suggested adding a
> smp_mb__after_clear_bit() to after setting the bit,

Agreed. Or, once again, we can change try_to_wake_up() to do mb()
rather then wmb().

And compared to the theoretical race above this looks more likely
to me (although still unlikely).

But probably we should start with another debugging patch, I'll send
it in a minute.

Oleg.

