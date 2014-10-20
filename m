Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123AbaJTQ7t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 12:59:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31873 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935AbaJTQ7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 12:59:48 -0400
Date: Mon, 20 Oct 2014 18:56:14 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Kirill Tkhai <ktkhai@parallels.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Kirill Tkhai <tkhai@yandex.ru>
Subject: Re: [PATCH v3] sched/numa: fix unsafe get_task_struct() in
	task_numa_assign()
Message-ID: <20141020165614.GA16373@redhat.com>
References: <1413800145.19914.23.camel@tkhai> <20141020144757.GA10939@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141020144757.GA10939@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20, Oleg Nesterov wrote:
>
> Again, perhaps we will need to change the lifetime rules for task_struct
> anyway, if we have more problems like this. But until then this looks like
> an overkill to me. Plus rq_curr_if_not_put() looks too subtle, and it is
> not generic.

Yes... otoh, perhaps we can do something more generic? Something like

	struct task_struct *xxx(struct task_struct **ptask)
	{
		struct task_struct *task;
		void *sighand;
	retry:
		task = ACCESS_ONCE(*ptask);
		if (!task)
			return NULL;

		if (IS_ENABLED(CONFIG_DEBUG_PAGEALLOC)) {
			if (probe_kernel_read(&sighand, &task->sighand, sizeof(sighand)))
				goto retry;
		} else {
			sighand = task->sighand;
		}

		if (!sighand)
			return NULL;
		/*
		 * Pairs with atomic_dec_and_test() in put_task_struct(task).
		 * If we have read the freed/reused memory, we must see that
		 * the pointer was updated.
		 */
		smp_rmb();
		if (task != ACCESS_ONCE(*ptask))
			goto retry;

		return task;
	}

task_numa_compare() can do cur = xxx(&rc->curr), but this helper can work
with any "task_struct *" pointer assuming that somehow this pointer is
cleared or changed before the final put_task_struct().

What do you think? Peter?

Oleg.

