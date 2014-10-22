Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423AbaJVQS2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 12:18:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43838 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071AbaJVQS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 12:18:26 -0400
Date: Wed, 22 Oct 2014 18:14:50 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kirill Tkhai <tkhai@yandex.ru>, Kirill Tkhai <ktkhai@parallels.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Vladimir Davydov <vdavydov@parallels.com>, cl@linux.com
Subject: Re: [PATCH v3] sched/numa: fix unsafe get_task_struct() in
	task_numa_assign()
Message-ID: <20141022161450.GA27607@redhat.com>
References: <1413800145.19914.23.camel@tkhai> <20141020144757.GA10939@redhat.com> <20141020165614.GA16373@redhat.com> <20141020182748.GA20424@redhat.com> <54456E26.2000103@yandex.ru> <20141020205006.GA2500@redhat.com> <20141021094558.GQ23531@worktop.programming.kicks-ass.net> <20141021190335.GA12851@redhat.com> <20141022090954.GF12706@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141022090954.GF12706@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22, Peter Zijlstra wrote:
>
> So I worry about cache aliasing (not an issue on x86), so by touching
> 'random' pages that might be freed and reissued to back userspace, we
> could be accessing the one page through multiple virtual mappings which
> therefore result in aliases.

Or this page can be vmalloc'ed. Yes, but we do not care. Although this
was one of the reasons why the 2nd version of xxx() checks ->sighand at
the end, even if this is not needed correctness-wise.

Let's look at the code again,

	struct task_struct *xxx(struct task_struct **ptask)
	{
		struct task_struct *task;
		struct sighand_struct *sighand;

	retry:
		task = ACCESS_ONCE(*ptask);
		if (!task)
			return task;

		if (IS_ENABLED(CONFIG_DEBUG_PAGEALLOC)) {
			if (probe_kernel_read(&sighand, &task->sighand, sizeof(sighand)))
				goto retry;
		} else {
			sighand = task->sighand;
		}

(this if/else should go into a separare helper)

		/*
		 * Pairs with atomic_dec_and_test() in put_task_struct(task).
		 * If we have read the freed/reused memory, we must see that
		 * the pointer was updated.
		 */
		smp_rmb();
		if (unlikely(task != ACCESS_ONCE(*ptask)))
			goto retry;

At this point we know that task_struct was not freed. Otherwise, since
this function assumes that "*ptask" must be cleared or updated before
the final put_task_struct(), we must notice that *ptask differs.

This means that we have read the correct value of ->sighand and the check
below is correct too. Even if ->sighand is not stable and can be already
NULL right after probe_kernel_read(), this doesn't matter.

And this also means that aliasing is not a problem. If it was freed we
could read the random value, but in this case we are not even going to
look at result.

		/*
		 * release_task(task) was already called; potentially before
		 * the caller took rcu_read_lock() and in this case it can be
		 * freed before rcu_read_unlock().
		 */
		if (!sighand)
			return NULL;
		return task;
	}

> SDBR avoids this issue by guaranteeing the page is not reissued for
> another purpose.

Yes, this is true.

> I'm not sure I can convince myself SLUB is correct here. How do we avoid
> cache aliasing.

Hmm. so perhaps I misunderstood your concern...

Do you mean that on !x86 a plain LOAD can "corrupt" the memory as it seen
from another vaddr?

If yes, this is another argument for a helper which reads the potentially
freed freed slab memory. get_freepointer_safe() can use it too and it can
be reimplemented in arch/xxx/include if necessary.

Or I missed your point completely?

Oleg.

