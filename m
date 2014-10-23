Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404AbaJWSTf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 14:19:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5776 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752690AbaJWSTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 14:19:33 -0400
Date: Thu, 23 Oct 2014 20:15:56 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Kirill Tkhai <ktkhai@parallels.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Kirill Tkhai <tkhai@yandex.ru>
Subject: Re: introduce task_rcu_dereference?
Message-ID: <20141023181556.GA2740@redhat.com>
References: <1413962231.19914.130.camel@tkhai> <20141022213041.GA25467@redhat.com> <20141022222330.GA28423@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141022222330.GA28423@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23, Oleg Nesterov wrote:
>
> Damn.

Yes.

> On 10/22, Oleg Nesterov wrote:
> >
> > +struct task_struct *task_rcu_dereference(struct task_struct **ptask)
> > +{
> > +	struct task_struct *task;
> > +	struct sighand_struct *sighand;
> > +
> > +	task = rcu_dereference(*ptask);
> > +	if (!task)
> > +		return NULL;
> > +
> > +	/* If it fails the check below must fail too */
> > +	probe_slab_address(&task->sighand, sighand);
> > +	/*
> > +	 * Pairs with atomic_dec_and_test() in put_task_struct(task).
> > +	 * If we have read the freed/reused memory, we must see that
> > +	 * the pointer was updated. The caller might want to retry in
> > +	 * this case.
> > +	 */
> > +	smp_rmb();
> > +	if (unlikely(task != ACCESS_ONCE(*ptask)))
> > +		return ERR_PTR(-EAGAIN);
>
> This is not exactly right. task == *ptask can be false positive.
>
> It can be freed, then resused (so that sighand != NULL can be false
> positive), then freed again, and then reused again as task_struct.
>
> This is not that bad, we still can safely use this task_struct, but
> the comment should be updated. Plus -EINVAL below can be wrong in
> this case although this minor.

Yes.

> Yeees, SLAB_DESTTROY_BY_RCU closes this race. Not sure why I'd like
> to avoid it, but I do ;)

Argh. I only meant that SLAB_DESTTROY_BY_RCU can make the comments
simpler. "closes this race" applies too "check below must fail too"
too. Sorry if I confused you.

"task == *ptask can be false positive" is true with or without
SLAB_DESTTROY_BY_RCU, and this needs a good comment. Yes, it can't
be reused twice, but still we can't 100% trust the "sighand != NULL"
check.

So let me repeat, SDBR can only turn probe_slab_address() into a plain
load.

But I can't think properly today, will try to recheck tomorrow and send
v2.

Oleg.

