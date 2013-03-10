Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921Ab3CJM60 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 08:58:26 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:51607 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab3CJM6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 08:58:25 -0400
Date: Sun, 10 Mar 2013 05:58:21 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, jmoyer@redhat.com,
        zab@redhat.com
Subject: Re: [PATCH 17/31] workqueue: implement attribute-based unbound
 worker_pool management
Message-ID: <20130310125821.GG24522@htj.dyndns.org>
References: <1362194662-2344-1-git-send-email-tj@kernel.org>
 <1362194662-2344-18-git-send-email-tj@kernel.org>
 <513C5BB9.7030305@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513C5BB9.7030305@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 10, 2013 at 06:08:57PM +0800, Lai Jiangshan wrote:
> > @@ -3185,12 +3250,133 @@ static int init_worker_pool(struct worker_pool *pool)
> >  	mutex_init(&pool->assoc_mutex);
> >  	ida_init(&pool->worker_ida);
> >  
> > +	INIT_HLIST_NODE(&pool->hash_node);
> > +	atomic_set(&pool->refcnt, 1);
> 
> We should document: the code before "atomic_set(&pool->refcnt, 1);" should not failed.
> (In case we add failable code before it when we forget this requirement in future".
> reason: when get_unbound_pool() fails, we expected ->refcnt = 1)

Yeap, comments added.

> > +/**
> > + * put_unbound_pool - put a worker_pool
> > + * @pool: worker_pool to put
> > + *
> > + * Put @pool.  If its refcnt reaches zero, it gets destroyed in sched-RCU
> > + * safe manner.
> > + */
> > +static void put_unbound_pool(struct worker_pool *pool)
> > +{
> > +	struct worker *worker;
> > +
> > +	if (!atomic_dec_and_test(&pool->refcnt))
> > +		return;
> 
> if get_unbound_pool() happens here, it will get a destroyed pool.
> so we need to move "spin_lock_irq(&workqueue_lock);" before above statement.
> (and ->refcnt don't need atomic after moved)

Hmmm... right.  Nice catch.  Updating...

> > +	if (WARN_ON(pool->nr_workers != pool->nr_idle))
> > +		return;
> 
> This can be false-negative. we should remove this WARN_ON().

How would the test fail spuriously?  Can you please elaborate?

Thanks.

-- 
tejun
