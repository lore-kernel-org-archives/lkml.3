Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932859AbaESUPh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 16:15:37 -0400
Received: from mail-qg0-f50.google.com ([209.85.192.50]:52574 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803AbaESUPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 16:15:36 -0400
Date: Mon, 19 May 2014 16:15:31 -0400
From: Tejun Heo <tj@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Christoph Lameter <cl@linux.com>, Kevin Hilman <khilman@linaro.org>,
        Mike Galbraith <bitbucket@online.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 1/5] workqueue: Allow changing attributions of ordered
 workqueues
Message-ID: <20140519201531.GC27506@mtj.dyndns.org>
References: <1400257015-28222-1-git-send-email-fweisbec@gmail.com>
 <1400257015-28222-2-git-send-email-fweisbec@gmail.com>
 <20140516201225.GL5379@htj.dyndns.org>
 <20140517134151.GA32371@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140517134151.GA32371@localhost.localdomain>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, May 17, 2014 at 03:41:55PM +0200, Frederic Weisbecker wrote:
> > > -	last_pool = get_work_pool(work);
> > > +	last_pool = wq->flags & __WQ_ORDERED ? NULL : get_work_pool(work);
> > >  	if (last_pool && last_pool != pwq->pool) {
> > >  		struct worker *worker;
> > 
> > I'm not a big fan of the fact that ordered queues need to be handled
> > differently when queueing, but as the code is currently written, this
> > is pretty much necessary to maintain execution order, right?
> >
> > Otherwise, you end up with requeueing work items targeting the pwq it
> > was executing on and new ones targeting the newest one screwing up the
> > ordering.  I think that'd be a lot more important to note in the
> > comment.  This is a correctness measure.  Back-to-back requeueing
> > being affected by this is just a side-effect.
> 
> In the case of ordered workqueues it actually doesn't matter much in
> term of ordering. But it's needed when pwqs are replaced (as it happens
> in apply_workqueue_attrs(). We must make sure works requeueing themselves
> don't always requeue to the old pwq otherwise it will never be able to
> switch and be released. Also the next work items will be queued on the next

But that's the same for other pwqs too.  Back-to-back requeueing will
hold back pwq switching on any workqueue.

> pwq but this one will never be able to run due to the old workqueue still
> being used by the item requeing itself. So we also risk starvation on the
> new workqueue.
> 
> But the ordering itself is actually fine for ordered workqueue. It's actually
> enforced by the fact that only one pwq can run at a time for a given workqueue.

Maybe I'm confused but I don't think it'd be.  Let's say there was an
attribute change with one work item, A, which is performing
back-to-back requeueing and another one, B, which queues itself
intermittently.  If B is queued while A is executing, followed by A
requeueing itself, the expected execution order is A - B - A; however,
without the above exception for ordered workqueues, it'd end up A - A
- B because B will end up on the new pwq while A on the older one and
max_active won't be transferred to the new pwq before it becomes
empty.

> > Just collapse it into the calling function.  This obfuscates more than
> > helps.
> 
> Yeah but the condition is already big. Lets hope the result won't be too ugly.

I didn't mean that the condition should be encoded in the if
conditional.  It's fine to break it out using a separate variable or
whatever.  I just don't think breaking it out to a separate function
is helping anything.

Thanks.

-- 
tejun
