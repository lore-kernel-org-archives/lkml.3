Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422824AbaGRWxW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 18:53:22 -0400
Received: from mail-qg0-f45.google.com ([209.85.192.45]:39528 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762629AbaGRWxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 18:53:21 -0400
Date: Fri, 18 Jul 2014 18:53:17 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] workqueue: remove unneeded test before wake up next
 worker
Message-ID: <20140718225317.GC5739@htj.dyndns.org>
References: <1405505409-12058-1-git-send-email-laijs@cn.fujitsu.com>
 <20140718220514.GC1819@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140718220514.GC1819@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 06:05:14PM -0400, Tejun Heo wrote:
> On Wed, Jul 16, 2014 at 06:09:58PM +0800, Lai Jiangshan wrote:
> > In this code:
> > 	if ((worker->flags & WORKER_UNBOUND) && need_more_worker(pool))
> > 		wake_up_worker(pool);
> > 
> > the first test is unneeded. Even the first test is removed, it doesn't affect
> > the wake-up logic when WORKER_UNBOUND. And it will not introduce any useless
> > wake-up when !WORKER_UNBOUND since the nr_running >= 1 except only one case.
> > It will introduce useless/redundant wake-up when cpu_intensive, but this
> > case is rare and next patch will also remove this redundant wake-up.
> > 
> > Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> > ---
> >  kernel/workqueue.c |    7 ++-----
> >  1 files changed, 2 insertions(+), 5 deletions(-)
> > 
> > diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> > index f8d54c1..6d11b9a 100644
> > --- a/kernel/workqueue.c
> > +++ b/kernel/workqueue.c
> > @@ -2047,11 +2047,8 @@ __acquires(&pool->lock)
> >  	if (unlikely(cpu_intensive))
> >  		worker_set_flags(worker, WORKER_CPU_INTENSIVE, true);
> >  
> > -	/*
> > -	 * Unbound pool isn't concurrency managed and work items should be
> > -	 * executed ASAP.  Wake up another worker if necessary.
> > -	 */
> > -	if ((worker->flags & WORKER_UNBOUND) && need_more_worker(pool))
> > +	/* Wake up another worker if necessary. */
> > +	if (need_more_worker(pool))
> >  		wake_up_worker(pool);
> 
> What does this buy us?  Sure, it may achieve about the same operation
> but it's a lot more confusing.  need_more_worker() is specifically for
> concurrency management.  Applying it to unmanaged workers could lead
> to okay behavior but conflating the two to save one test on worker
> flags doesn't seem like a good trade-off to me.

I take this back.  We do guarantee that need_more_worker() returns
%true for unbound pools and make use of that fact but I'd like it to
retain the comment about unbound pools.

Thanks.

-- 
tejun
