Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966255Ab3HHTXp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 15:23:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25064 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966218Ab3HHTXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 15:23:34 -0400
Date: Thu, 8 Aug 2013 21:17:49 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Long Gao <gaolong@kylinos.com.cn>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Patch for lost wakeups
Message-ID: <20130808191749.GA12062@redhat.com>
References: <tencent_26310211398C21034BD3B2F9@qq.com> <CA+55aFwAnWZGkXbyLmL3RxQGW-dX_jjDBPfA5PjxeVWn==a6tA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwAnWZGkXbyLmL3RxQGW-dX_jjDBPfA5PjxeVWn==a6tA@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08, Linus Torvalds wrote:
>
> As a result, doing a "recalc_sigpending_and_wake(()"

and btw it should die, I think.

> is definitely
> incorrect, because sigpending state cannot actually have changed.

Yes, if we need to wakeup in this case something is already wrong.

>  - somebody setting TASK_SLEEPING -> __schedule() testing the
> signal_pending_state()
>
> and as far as I can tell we have proper barriers for those (the
> scheduler gets the rq lock

Yes, but... ttwu() takse another lock, ->pi_lock to test ->state.

This looks racy, even if wmb() actually acts as mb(), we don't
have mb() on the other side and schedule() can miss SIGPENDING?

Unless the task does set_current_state(TASK_INTERRUPTIBLE) which
adds mb(). But, just for example, sigsuspend() relies on schedule().

>         smp_wmb();
>         raw_spin_lock_irqsave(&p->pi_lock, flags);
>         if (!(p->state & state))
>
> before it tests the task state. And the wmb() *together* with the
> spinlock really should be a full memory barrier (nothing can get out
> from the spinlock, and any writes before this had better be serialized
> by the wmb and the write inherent in the spinlock itself). But this is
> definitely some subtle stuff.

So perhaps it makes sense to re-test after s/smp_wmb/smp_mb/ ?

And perhaps we can add smp_mb__before_lock(), we alredy have
smp_mb__after_lock().

And of course, there could be another bug. I just did
"grep recalc_sigpending" and immediately found at least one buggy
user, fs/dlm/user.c which calls it lockless.

> >  Every time Xorg hangs up,  the status of Xorg is read as following(cat /proc/2597/status):

Gao, could you show /proc/pid/stack just in case?

Oleg.

