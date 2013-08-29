Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850Ab3H2SdU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 14:33:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8684 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754315Ab3H2SdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 14:33:18 -0400
Date: Thu, 29 Aug 2013 14:33:10 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tomoki Sekiyama <tomoki.sekiyama@hds.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, seiji.aguchi@hds.com,
        majianpeng@gmail.com, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] elevator: Fix a race in elevator switching and md device
 initialization
Message-ID: <20130829183310.GB6171@redhat.com>
References: <20130826134515.2298.55571.stgit@outback>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130826134515.2298.55571.stgit@outback>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 09:45:15AM -0400, Tomoki Sekiyama wrote:
> The soft lockup below happes at the boot time of the system using dm
> multipath and automated elevator switching udev rules.
> 
> [  356.127001] BUG: soft lockup - CPU#3 stuck for 22s! [sh:483]
> [  356.127001] RIP: 0010:[<ffffffff81072a7d>]  [<ffffffff81072a7d>] lock_timer_base.isra.35+0x1d/0x50
> ...
> [  356.127001] Call Trace:
> [  356.127001]  [<ffffffff81073810>] try_to_del_timer_sync+0x20/0x70
> [  356.127001]  [<ffffffff8118b08a>] ? kmem_cache_alloc_node_trace+0x20a/0x230
> [  356.127001]  [<ffffffff810738b2>] del_timer_sync+0x52/0x60
> [  356.127001]  [<ffffffff812ece22>] cfq_exit_queue+0x32/0xf0
> [  356.127001]  [<ffffffff812c98df>] elevator_exit+0x2f/0x50
> [  356.127001]  [<ffffffff812c9f21>] elevator_change+0xf1/0x1c0
> [  356.127001]  [<ffffffff812caa50>] elv_iosched_store+0x20/0x50
> [  356.127001]  [<ffffffff812d1d09>] queue_attr_store+0x59/0xb0
> [  356.127001]  [<ffffffff812143f6>] sysfs_write_file+0xc6/0x140
> [  356.127001]  [<ffffffff811a326d>] vfs_write+0xbd/0x1e0
> [  356.127001]  [<ffffffff811a3ca9>] SyS_write+0x49/0xa0
> [  356.127001]  [<ffffffff8164e899>] system_call_fastpath+0x16/0x1b
> 

Tokomi, 

As you noticed, there is a fedora bug open with similar signature. May
be this patch will fix that issue also.

https://bugzilla.redhat.com/show_bug.cgi?id=902012


> This is caused by a race between md device initialization and sysfs knob
> to switch the scheduler.
> 
> * multipathd:
>  SyS_ioctl -> do_vfs_ioctl -> dm_ctl_ioctl -> ctl_ioctl ->  table_load
>   -> dm_setup_md_queue -> blk_init_allocated_queue -> elevator_init:
> 
>     q->elevator = elevator_alloc(q, e); // not yet initialized
> 
> * sh -c 'echo deadline > /sys/$DEVPATH/queue/scheduler'
>  SyS_write -> vfs_write -> sysfs_write_file -> queue_attr_store
>      ( mutex_lock(&q->sysfs_lock) here. )
>   -> elv_iosched_store -> elevator_change:
> 
>   elevator_exit(old); // try to de-init uninitialized elevator and hang up
> 
> This patch adds acquisition of q->sysfs_lock in blk_init_allocated_queue().
> This also adds the lock into elevator_change() to ensure locking from the
> other path, as it is exposed function (and queue_attr_store will uses
> __elevator_change() now, the non-locking version of elevator_change()).

I think introducing __elevator_change() is orthogonal to this problem.
May be keep that in a separate patch.

>  block/blk-core.c |    6 +++++-
>  block/elevator.c |   16 ++++++++++++++--
>  2 files changed, 19 insertions(+), 3 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 93a18d1..2323ec3 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -739,9 +739,13 @@ blk_init_allocated_queue(struct request_queue *q, request_fn_proc *rfn,
>  
>  	q->sg_reserved_size = INT_MAX;
>  
> +	/* Protect q->elevator from elevator_change */
> +	mutex_lock(&q->sysfs_lock);
>  	/* init elevator */
>  	if (elevator_init(q, NULL))
> -		return NULL;
> +		q = NULL;
> +	mutex_unlock(&q->sysfs_lock);
> +

So core of the problem is, what's the locking semantics to make sure
that we are not trying to switch elevator while it is still initializing.
IOW, should we allow multiple parallel calls of elevator_init_fn() on a
queue and is it safe?

I would argue that it is easier to read and maintain the code if we
provide explicit locking around. So I like the idea of introducing
some locking around elevator_init().

Because we are racing against elevator switch path which takes
q->sysfs_lock, it makes sense to provide mutual exlusion using 
q->sysfs_lock.

What I don't know is that can we take mutex in queue init path. Generally
drivers call it and do they expect that they can call this function
while holding a spin lock.

I am CCing Tejun also to the thread. He also might have some ideas here.

Thanks
Vivek

>  	return q;
>  }
>  EXPORT_SYMBOL(blk_init_allocated_queue);
> diff --git a/block/elevator.c b/block/elevator.c
> index 668394d..5232565 100644
> --- a/block/elevator.c
> +++ b/block/elevator.c
> @@ -959,7 +959,7 @@ fail_init:
>  /*
>   * Switch this queue to the given IO scheduler.
>   */
> -int elevator_change(struct request_queue *q, const char *name)
> +static int __elevator_change(struct request_queue *q, const char *name)
>  {
>  	char elevator_name[ELV_NAME_MAX];
>  	struct elevator_type *e;
> @@ -981,6 +981,18 @@ int elevator_change(struct request_queue *q, const char *name)
>  
>  	return elevator_switch(q, e);
>  }
> +
> +int elevator_change(struct request_queue *q, const char *name)
> +{
> +	int ret;
> +
> +	/* Protect q->elevator from blk_init_allocated_queue() */
> +	mutex_lock(&q->sysfs_lock);
> +	ret = __elevator_change(q, name);
> +	mutex_unlock(&q->sysfs_lock);
> +
> +	return ret;
> +}
>  EXPORT_SYMBOL(elevator_change);
>  
>  ssize_t elv_iosched_store(struct request_queue *q, const char *name,
> @@ -991,7 +1003,7 @@ ssize_t elv_iosched_store(struct request_queue *q, const char *name,
>  	if (!q->elevator)
>  		return count;
>  
> -	ret = elevator_change(q, name);
> +	ret = __elevator_change(q, name);
>  	if (!ret)
>  		return count;
>  
