Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757884AbbA0RHm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 12:07:42 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:58589 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498AbbA0RHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 12:07:40 -0500
Date: Tue, 27 Jan 2015 18:07:32 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jason Low <jason.low2@hp.com>, Michel Lespinasse <walken@google.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, linux-kernel@vger.kernel.org,
        Davidlohr Bueso <dbueso@suse.de>
Subject: Re: [PATCH 2/6] locking/rwsem: Document barrier need when waking
 tasks
Message-ID: <20150127170732.GI21418@twins.programming.kicks-ass.net>
References: <1422257769-14083-1-git-send-email-dave@stgolabs.net>
 <1422257769-14083-3-git-send-email-dave@stgolabs.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422257769-14083-3-git-send-email-dave@stgolabs.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 25, 2015 at 11:36:05PM -0800, Davidlohr Bueso wrote:
> The need for the smp_mb in __rwsem_do_wake should be
> properly documented. Applies to both xadd and spinlock
> variants.
> 
> Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
> ---
>  kernel/locking/rwsem-spinlock.c | 5 +++++
>  kernel/locking/rwsem-xadd.c     | 5 +++++
>  2 files changed, 10 insertions(+)
> 
> diff --git a/kernel/locking/rwsem-spinlock.c b/kernel/locking/rwsem-spinlock.c
> index 2555ae1..54f7a17 100644
> --- a/kernel/locking/rwsem-spinlock.c
> +++ b/kernel/locking/rwsem-spinlock.c
> @@ -85,6 +85,11 @@ __rwsem_do_wake(struct rw_semaphore *sem, int wakewrite)
>  
>  		list_del(&waiter->list);
>  		tsk = waiter->task;
> +		/*
> +		 * Ensure that all cores see the read before
> +		 * setting it to the waiter task to nil, as that
> +		 * grants the read lock to the next task.
> +		 */
>  		smp_mb();
>  		waiter->task = NULL;
>  		wake_up_process(tsk);

Could you enhance that comment by pointing at the pairing code? Is that
the wait loop in rwsem_down_read_failed()?

Also, the comment confuses, how can all cores observe a read into a
local variable?
