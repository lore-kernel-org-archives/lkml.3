Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758069AbaKTU1Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 15:27:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48478 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756845AbaKTU1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 15:27:13 -0500
Date: Thu, 20 Nov 2014 15:27:06 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH block/for-next 3/4] cgroup, block: implement
 task_get_css() and use it in bio_associate_current()
Message-ID: <20141120202706.GD11595@redhat.com>
References: <20141117211321.GD23126@htj.dyndns.org>
 <20141117211357.GE23126@htj.dyndns.org>
 <20141117211546.GF23126@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141117211546.GF23126@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 04:15:46PM -0500, Tejun Heo wrote:
> bio_associate_current() currently open codes task_css() and
> css_tryget_online() to find and pin $current's blkcg css.  Abstract it
> into task_get_css() which is implemented from cgroup side.  As a task
> is always associated with an online css for every subsystem except
> while the css_set update is propagating, task_get_css() retries till
> css_tryget_online() succeeds.
> 
> This is a cleanup and shouldn't lead to noticeable behavior changes.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Li Zefan <lizefan@huawei.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Vivek Goyal <vgoyal@redhat.com>

Looks good to me.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek

> ---
> Hello,
> 
> This one can be routed through either cgroup or block tree but I think
> it'd be easier to route this through block as there will be more block
> changes in the area.
> 
> Thanks.
> 
>  block/bio.c            |   11 +----------
>  include/linux/cgroup.h |   25 +++++++++++++++++++++++++
>  2 files changed, 26 insertions(+), 10 deletions(-)
> 
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -1997,7 +1997,6 @@ EXPORT_SYMBOL(bioset_create_nobvec);
>  int bio_associate_current(struct bio *bio)
>  {
>  	struct io_context *ioc;
> -	struct cgroup_subsys_state *css;
>  
>  	if (bio->bi_ioc)
>  		return -EBUSY;
> @@ -2006,17 +2005,9 @@ int bio_associate_current(struct bio *bi
>  	if (!ioc)
>  		return -ENOENT;
>  
> -	/* acquire active ref on @ioc and associate */
>  	get_io_context_active(ioc);
>  	bio->bi_ioc = ioc;
> -
> -	/* associate blkcg if exists */
> -	rcu_read_lock();
> -	css = task_css(current, blkio_cgrp_id);
> -	if (css && css_tryget_online(css))
> -		bio->bi_css = css;
> -	rcu_read_unlock();
> -
> +	bio->bi_css = task_get_css(current, blkio_cgrp_id);
>  	return 0;
>  }
>  
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -748,6 +748,31 @@ static inline struct cgroup_subsys_state
>  }
>  
>  /**
> + * task_get_css - find and get the css for (task, subsys)
> + * @task: the target task
> + * @subsys_id: the target subsystem ID
> + *
> + * Find the css for the (@task, @subsys_id) combination, increment a
> + * reference on and return it.  This function is guaranteed to return a
> + * valid css.
> + */
> +static inline struct cgroup_subsys_state *
> +task_get_css(struct task_struct *task, int subsys_id)
> +{
> +	struct cgroup_subsys_state *css;
> +
> +	rcu_read_lock();
> +	while (true) {
> +		css = task_css(task, subsys_id);
> +		if (likely(css_tryget_online(css)))
> +			break;
> +		cpu_relax();
> +	}
> +	rcu_read_unlock();
> +	return css;
> +}
> +
> +/**
>   * task_css_is_root - test whether a task belongs to the root css
>   * @task: the target task
>   * @subsys_id: the target subsystem ID
