Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751670AbaG1Szn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 14:55:43 -0400
Received: from mail-qg0-f54.google.com ([209.85.192.54]:56685 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbaG1Szk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 14:55:40 -0400
Date: Mon, 28 Jul 2014 14:55:36 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] workqueue: use dedicated creater kthread for all
 pools
Message-ID: <20140728185536.GG7462@htj.dyndns.org>
References: <1406343900-32423-1-git-send-email-laijs@cn.fujitsu.com>
 <1406343900-32423-3-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406343900-32423-3-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Lai.

On Sat, Jul 26, 2014 at 11:04:50AM +0800, Lai Jiangshan wrote:
> There are some problems with the managers:
>   1) The last idle worker prefer managing to processing.
>      It is better that the processing of work items should be the first
>      priority to make the whole system make progress earlier.
>   2) managers among different pools can be parallel, but actually
>      their major work are serialized on the kernel thread "kthreadd".
>      These managers are sleeping and wasted when the system is lack
>      of memory.

It's a bit difficult to get excited about this patchset given that
this is mostly churn without many actual benefits.  Sure, it
consolidates one-per-pool managers into one kthread_worker but it was
one-per-pool already.  That said, I don't hate it and it may be
considered an improvement.  I don't know.

> This patch introduces a dedicated creater kthread which offloads the
> managing from the workers, thus every worker makes effort to process work
> rather than create worker, and there is no manager wasting on sleeping
> when the system is lack of memory.  This dedicated creater kthread causes
> a little more work serialized than before, but it is acceptable.

I do dislike the idea of creating this sort of hard serialization
among separate worker pools.  It's probably acceptable but why are we
doing this?  To save one thread per pool and shed 30 lines of code
while adding 40 lines to kthread_worker?

>   1) the creater_work
> Every pool has a struct kthread_work creater_work to create worker, and
> the dedicated creater kthread processes all these creater_works of
> all pools. struct kthread_work has itself execution exclusion, so we don't
> need the manager_arb to handle the creating exclusion any more.

This explanation can be a bit misleading, I think.  We just don't have
multiple workers trying to become managers anymore.

> put_unbound_pool() uses the flush_kthread_work() to synchronize with
> the creating rather than uses the manager_arb.
> 
>   2) the cooldown timer
> The cooldown timer is introduced to implement the cool-down mechanism
> rather than to causes the creater to sleep.  When the create_worker()
> fails, the cooldown timer is requested and it will restart the creater_work.

Why?  Why doesn't the creator sleep?

...
>   5) the routine of the creater_work
> The creater_work creates a worker in these two conditions:
>   A) pool->nr_idle == 0
>      A new worker is needed to be created obviously even there is no
>      work item pending.  The busy workers may sleep and the pool can't
>      serves the future new work items if no new worker is standby or
>      being created.

This is kinda silly when the duty of worker creation is served by an
external entity.  Why would a pool need any idle worker?
insert_work() may as well just queue worker creation on demand.

>   8) init_workqueues()
> The struct kthread_worker kworker_creater is initialized earlier than
> worker_pools in init_workqueues() so that kworker_creater_thread is
> created than all early kworkers.  Although the early kworkers are not
> depends on kworker_creater_thread, but this initialization order makes
> the pid of kworker_creater_thread smaller than kworkers which
> seems more smooth.

Just don't create idle workers?

Overall, I don't know.  I like some aspects of it but there's nothing
really convincing about this change.  It sure is different.  Maybe
this is more straight-forward but I'm not sure this is worth the
changes.

Thanks.

-- 
tejun
