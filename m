Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649Ab3CERJl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 12:09:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30846 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752622Ab3CERJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 12:09:40 -0500
Date: Tue, 5 Mar 2013 18:06:42 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Michel Lespinasse <walken@google.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        paulmck@linux.vnet.ibm.com, Rusty Russell <rusty@rustcorp.com.au>,
        rostedt@goodmis.org, tglx@linutronix.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/2] lockdep: introduce lock_acquire_exclusive/shared
	helper macros
Message-ID: <20130305170642.GA5012@redhat.com>
References: <1362449845-7492-1-git-send-email-walken@google.com> <1362449845-7492-2-git-send-email-walken@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362449845-7492-2-git-send-email-walken@google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04, Michel Lespinasse wrote:
>
> In lockdep.h, the spinlock/mutex/rwsem/rwlock/lock_map acquire macros
> have different definitions based on the value of CONFIG_PROVE_LOCKING.
> We have separate ifdefs for each of these definitions, which seems
> redundant.

You know, I should not even try to comment this patch. I never really
understood this magic, and I forgot everything I knew.

But I like this patch because it makes lockdep.h more readable to me,
so I hope it is correct ;)

One question,

> +#ifdef CONFIG_PROVE_LOCKING
> + #define lock_acquire_exclusive(l, s, t, n, i)		lock_acquire(l, s, t, 0, 2, n, i)
> + #define lock_acquire_shared(l, s, t, n, i)		lock_acquire(l, s, t, 1, 2, n, i)
> + #define lock_acquire_shared_recursive(l, s, t, n, i)	lock_acquire(l, s, t, 2, 2, n, i)
>  #else
> -# define spin_acquire(l, s, t, i)		do { } while (0)
> -# define spin_release(l, n, i)			do { } while (0)
> + #define lock_acquire_exclusive(l, s, t, n, i)		lock_acquire(l, s, t, 0, 1, n, i)
> + #define lock_acquire_shared(l, s, t, n, i)		lock_acquire(l, s, t, 1, 1, n, i)
> + #define lock_acquire_shared_recursive(l, s, t, n, i)	lock_acquire(l, s, t, 2, 1, n, i)
>  #endif

Do we really need this ifdef? Can't we pass check == 2 unconditionally?

__lock_acquire() does:

	if (!prove_locking)
		check = 1;

anyway, and without CONFIG_PROVE_LOCKING prove_locking == 0.

And every time I need to look into lockdep.h these hardcoded constants
confuse me, and of course it is not possible to remember if this particular
"1" means "read" or "check". Imho it would be nice to add some symbolic
names. But this is offtopic.

Oleg.

