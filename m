Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760103Ab3EBOtX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 10:49:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5244 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751611Ab3EBOtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 10:49:22 -0400
Date: Thu, 2 May 2013 10:49:12 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: Re: [PATCH 07/31] blk-throttle: removed deferred config application
 mechanism
Message-ID: <20130502144912.GE30020@redhat.com>
References: <1367455189-6957-1-git-send-email-tj@kernel.org>
 <1367455189-6957-8-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367455189-6957-8-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 01, 2013 at 05:39:25PM -0700, Tejun Heo wrote:

[..]
> @@ -1023,9 +975,27 @@ static int tg_set_conf(struct cgroup *cgrp, struct cftype *cft, const char *buf,
>  	else
>  		*(unsigned int *)((void *)tg + cft->private) = ctx.v;
>  
> -	/* XXX: we don't need the following deferred processing */
> -	xchg(&tg->limits_changed, true);
> -	xchg(&td->limits_changed, true);
> +	throtl_log_tg(td, tg, "limit change rbps=%llu wbps=%llu riops=%u wiops=%u",
> +		      tg->bps[READ], tg->bps[WRITE],
> +		      tg->iops[READ], tg->iops[WRITE]);
> +
> +	/*
> +	 * We're already holding queue_lock and know @tg is valid.  Let's
> +	 * apply the new config directly.
> +	 *
> +	 * Restart the slices for both READ and WRITES. It might happen
> +	 * that a group's limit are dropped suddenly and we don't want to
> +	 * account recently dispatched IO with new low rate.
> +	 */
> +	throtl_start_new_slice(td, tg, 0);
> +	throtl_start_new_slice(td, tg, 1);
> +
> +	if (throtl_tg_on_rr(tg)) {
> +		tg_update_disptime(td, tg);
> +		throtl_schedule_next_dispatch(td);
> +	}
> +
> +	/* kick dispatch in case disptime got shortened */
>  	throtl_schedule_delayed_work(td, 0);

Hi Tejun,

Do we need above throtl_schedule_delayed_work() now?
throtl_schedule_next_dispatch() should take care of it. And if group
is not on service tree at the time of limit change, then anyway, we don't
have to schedule any work.

Thanks
Vivek
