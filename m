Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932661AbaJVTqP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 15:46:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29875 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932575AbaJVTqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 15:46:11 -0400
Date: Wed, 22 Oct 2014 21:42:28 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: peterz@infradead.org, cl@linux.com, tkhai@yandex.ru, ktkhai@parallels.com,
        linux-kernel@vger.kernel.org, mingo@redhat.com, vdavydov@parallels.com
Subject: Re: introduce probe_slab_address?
Message-ID: <20141022194228.GA10995@redhat.com>
References: <20141022161450.GA27607@redhat.com> <20141022163743.GI21513@worktop.programming.kicks-ass.net> <20141022181412.GA8159@redhat.com> <20141022.145950.1585224138048242923.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141022.145950.1585224138048242923.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22, David Miller wrote:
>
> From: Oleg Nesterov <oleg@redhat.com>
> Date: Wed, 22 Oct 2014 20:14:12 +0200
>
> > So perhaps something like this makes sense?
> >
> > If some arch has problems with D-cache aliasing (because the freed page
> > can be already mapped by user-space or vmalloc'ed), it can redefine this
> > helper.
> >
> > Do you think we can use it to access rq->curr? (although let me repeat
> > that I won't really argue with SLAB_DESTROY_BY_RCU).
>
> Do we really need this?

Sorry, I was not clear. let me first explain why do we want this helper,
(although we can avoid it if we make task_struct_cachep SLAB_DESTROY_BY_RCU).

To simplify the discussion, lets ignore the actuall problem we are
trying to solve. Suppose that we want a trivial function, say,

	int pid_of_curr_task_on_cpu(int cpu)
	{
		 struct rq *rq = cpu_rq(cpu);
		 int pid;

		 rcu_read_lock();
		 pid = rq->curr->pid;
		 rcu_read_unlock();
	}

and we do not really care if it returns the wrong/random result.

The problem is that rcu_read_lock() can not help (unless we add
SLAB_DESTROY_BY_RCU), rq->curr is not protected by RCU. So rq->curr can
be freed. Again, we do not care, but CONFIG_DEBUG_PAGEALLOC can ummap
this page.

So we can use ifdef(CONFIG_DEBUG_PAGEALLOC) but it would be better to
have a helper to hide this ugliness, and (at least) slub can use it too.

Now the question: is this LOAD is safe in case when this (freed) page
already has another mapping? This is black magic to me, I do not know.
And Peter has some concerns.

And, say, copy_from_user_page() on sparc does

	flush_cache_page();
	memcpy();
	flush_ptrace_access();

Again, I simply do not know if this is relevant or not, probably this
is because "illegal alias" was created by kmap() which can use the
same vaddr to access different pages.

> We fully initialize and read from the area using the same virtual
> address, there is no possiblity for corruption from SLAB's
> perspective.
>
> It's when you store at vaddr X then read at vaddr Y and expect to see
> what you wrote at X that you have problems.
>
> That is very much not what is happening here.
>
> The lifetime is contained to SLAB's usage at one single virtual
> address.

OK, so iiuc this should be safe.

Thanks!

Oleg.

