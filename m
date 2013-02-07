Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422683Ab3BGWCe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 17:02:34 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:35114 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161023Ab3BGWCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 17:02:33 -0500
Date: Thu, 7 Feb 2013 14:02:27 -0800
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/13] workqueue: record global worker ID instead of pool
 ID in work->data when off-queue
Message-ID: <20130207220227.GW2875@htj.dyndns.org>
References: <1359657696-2767-1-git-send-email-laijs@cn.fujitsu.com>
 <1359657696-2767-14-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359657696-2767-14-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, again.

On Fri, Feb 01, 2013 at 02:41:36AM +0800, Lai Jiangshan wrote:
> Every time, when we need to find the executing worker from work,
> we need 2 steps:
> 	find the pool from the idr by pool id.
> 	find the worker from the hash table of the pool.
> 
> Now we merge them as one step: find the worker directly from the idr by worker gwid.
> (lock_pool_executing_work(). If the work is onq, we still use hash table.)
> 
> It makes the code more straightforward.
> 
> In future, we may add percpu worker gwid <--> worker mapping cache when needed.
> 
> And we are planing to add non-std worker_pool, we still don't know how to
> implement worker_pool_by_id() for non-std worker_pool, this patch solves it.
> 
> This patch slows down the very-slow-path destroy_worker(), if it is blamed,
> we will move the synchronize_rcu() out.
> 
> This patch adds a small overhead(rcu_read_[un]lock) in fast path
> lock_pool_executing_work(). if it is blamed, we will use rcu_sched instead.
> (local_irq_disable() implies rcu_read_lock_sched(), so we can remove
> this overhead.)

So, I've been looking at the last six patches and am not really sure
whether I want this.  At least not in the current form.  We end up
locking, unlocking and then locking again the same thing in hot path.
Having a proper locking API is all nice and good *if* it actually can
support use case at hand.  The proposed one can't.

Also, if worker is RCU protected then pool should be too (otherwise
you can't do worker->pool->lock), so it doesn't really simplify that
aspect either.

I do like work items pointing back to workers instead of pools, so I
think I'll try that differently.

Thanks.

-- 
tejun
