Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216AbaKJQB5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 11:01:57 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:45738 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbaKJQBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 11:01:55 -0500
Date: Mon, 10 Nov 2014 17:01:48 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Kirill Tkhai <ktkhai@parallels.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Kirill Tkhai <tkhai@yandex.ru>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH v4] sched/numa: fix unsafe get_task_struct() in
 task_numa_assign()
Message-ID: <20141110160148.GZ10501@worktop.programming.kicks-ass.net>
References: <1413962231.19914.130.camel@tkhai>
 <545D928B.2070508@oracle.com>
 <1415542020.474.22.camel@tkhai>
 <20141110100328.GF29390@twins.programming.kicks-ass.net>
 <5460DE4C.6050306@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5460DE4C.6050306@oracle.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 10:48:28AM -0500, Sasha Levin wrote:
> On 11/10/2014 05:03 AM, Peter Zijlstra wrote:
> > --- a/kernel/sched/fair.c
> > +++ b/kernel/sched/fair.c
> > @@ -1268,6 +1268,13 @@ static void task_numa_compare(struct tas
> >  	raw_spin_unlock_irq(&dst_rq->lock);
> >  
> >  	/*
> > +	 * Because we have preemption enabled we can get migrated around and
> > +	 * end try selecting ourselves (current == env->p) as a swap candidate.
> > +	 */
> > +	if (cur == env->p)
> > +		goto unlock;
> 
> This is too late though, because currently the lockup happens couple of lines
> above that at:
> 
>         raw_spin_lock_irq(&dst_rq->lock); <=== here
>         cur = dst_rq->curr;
> 
> Which got me a bit stuck trying to use your old patch since we can't access '->curr'
> without locking dst_rq, but locking dst_rq is causing a lockup.

confused... how can we lock up there. We should not be holding _any_
lock there.

That a different problem that the originally reported one.
