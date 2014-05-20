Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207AbaETHxV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 03:53:21 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:51454 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034AbaETHxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 03:53:19 -0400
Date: Tue, 20 May 2014 09:53:15 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: Juri Lelli <juri.lelli@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] sched/dl: Fix race between dl_task_timer() and
 sched_setaffinity()
Message-ID: <20140520075315.GQ2485@laptop.programming.kicks-ass.net>
References: <20140516213003.10384.7946.stgit@localhost>
 <20140519151233.5043b749361e1b384f1e5562@gmail.com>
 <783871400527879@web2j.yandex.ru>
 <20140520000026.GD11096@twins.programming.kicks-ass.net>
 <1413311400562533@web30m.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1413311400562533@web30m.yandex.ru>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 09:08:53AM +0400, Kirill Tkhai wrote:
> 
> 
> 20.05.2014, 04:00, "Peter Zijlstra" <peterz@infradead.org>:
> > On Mon, May 19, 2014 at 11:31:19PM +0400, Kirill Tkhai wrote:
> >
> >>  @@ -513,9 +513,17 @@ static enum hrtimer_restart dl_task_timer(struct hrtimer *timer)
> >>                                                        struct sched_dl_entity,
> >>                                                        dl_timer);
> >>           struct task_struct *p = dl_task_of(dl_se);
> >>  - struct rq *rq = task_rq(p);
> >>  + struct rq *rq;
> >>  +again:
> >>  + rq = task_rq(p);
> >>           raw_spin_lock(&rq->lock);
> >>
> >>  + if (unlikely(rq != task_rq(p))) {
> >>  + /* Task was moved, retrying. */
> >>  + raw_spin_unlock(&rq->lock);
> >>  + goto again;
> >>  + }
> >>  +
> >
> > That thing is called: rq = __task_rq_lock(p);
> 
> But p->pi_lock is not held. The problem is __task_rq_lock() has lockdep assert.
> Should we change it?

Ok, so now that I'm awake ;-)

So the trivial problem as described by your initial changelog isn't
right, because we cannot call sched_setaffinity() on deadline tasks, or
rather we can, but we can't actually change the affinity mask.

Now I suppose the problem can still actually happen when you change the
root domain and trigger a effective affinity change that way.

That said, no leave it as you proposed, adding a *task_rq_lock() variant
without lockdep assert in will only confuse things, as normally we
really should be also taking ->pi_lock.

The only reason we don't strictly need ->pi_lock now is because we're
guaranteed to have p->state == TASK_RUNNING here and are thus free of
ttwu races.
