Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab3IVREW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 13:04:22 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:64663 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434Ab3IVREV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 13:04:21 -0400
Date: Sun, 22 Sep 2013 13:04:17 -0400
From: Tejun Heo <tj@kernel.org>
To: Tomoki Sekiyama <tomoki.sekiyama@hds.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, seiji.aguchi@hds.com,
        vgoyal@redhat.com, majianpeng@gmail.com
Subject: Re: [PATCH v2 1/2] elevator: Fix a race in elevator switching and md
 device initialization
Message-ID: <20130922170417.GF30946@htj.dyndns.org>
References: <20130830224707.21812.63516.stgit@hds.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130830224707.21812.63516.stgit@hds.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 06:47:07PM -0400, Tomoki Sekiyama wrote:
> @@ -739,9 +739,17 @@ blk_init_allocated_queue(struct request_queue *q, request_fn_proc *rfn,
>  
>  	q->sg_reserved_size = INT_MAX;
>  
> +	/* Protect q->elevator from elevator_change */
> +	mutex_lock(&q->sysfs_lock);
> +
>  	/* init elevator */
> -	if (elevator_init(q, NULL))
> +	if (elevator_init(q, NULL)) {
> +		mutex_unlock(&q->sysfs_lock);
>  		return NULL;
> +	}
> +
> +	mutex_unlock(&q->sysfs_lock);
> +
>  	return q;
>  }
>  EXPORT_SYMBOL(blk_init_allocated_queue);
> diff --git a/block/elevator.c b/block/elevator.c
> index 668394d..02d4390 100644
> --- a/block/elevator.c
> +++ b/block/elevator.c
> @@ -186,6 +186,12 @@ int elevator_init(struct request_queue *q, char *name)
>  	struct elevator_type *e = NULL;
>  	int err;
>  
> +	/*
> +	 * q->sysfs_lock must be held to provide mutual exclusion between
> +	 * elevator_switch() and here.
> +	 */
> +	lockdep_assert_held(&q->sysfs_lock);
> +
>  	if (unlikely(q->elevator))
>  		return 0;

Hmm... why aren't we just changing elevator_init() to grab sysfs_lock
where necessary?  It'd be more consistent with elevator_exit() that
way.

Thanks.

-- 
tejun
