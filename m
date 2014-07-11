Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184AbaGKPC6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 11:02:58 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:63582 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931AbaGKPC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 11:02:56 -0400
Date: Fri, 11 Jul 2014 11:02:52 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] workqueue: remove the guarantee and the retrying of
 maybe_create_worker()
Message-ID: <20140711150252.GE27706@htj.dyndns.org>
References: <1405008074-11031-1-git-send-email-laijs@cn.fujitsu.com>
 <1405008074-11031-3-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405008074-11031-3-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 12:01:04AM +0800, Lai Jiangshan wrote:
> maybe_create_worker() has a strong guarantee that there has at least
> one idle worker on return from this function.  This guarantee is guaranteed
> via the check and the retrying in this function.
> 
> But the caller (worker_thread()) also has the same check and retrying,
> so the guarantee is not really required and the check and the retrying in
> maybe_create_worker() are unnecessary and redundant.
> 
> So we remove the guarantee as well as the check and the retrying.  The caller
> takes responsibility to retry when needed.
> 
> The only trade-off is that the mayday timer will be removed and re-added
> across retrying. Since retrying is expected as rare case, the trade-off
> is acceptible.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
>  kernel/workqueue.c |   49 ++++++++++++++++++-------------------------------
>  1 files changed, 18 insertions(+), 31 deletions(-)
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 92f7ea0c..4fdd6d0 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -1875,14 +1875,17 @@ static void pool_mayday_timeout(unsigned long __pool)
>   * @pool: pool to create a new worker for
>   *
>   * Create a new worker for @pool if necessary.  @pool is guaranteed to
> - * have at least one idle worker on return from this function.  If
> - * creating a new worker takes longer than MAYDAY_INTERVAL, mayday is
> + * make some progresses on return from this function.

Hmmm.... not really.

> + *   1) success to create a new idle worker.  Or

Another work item can race and occupy that worker before this worker
regrabs pool->lock, which is safe because

> + *   2) cool down a while after it failed.  Or
> + *   3) condition changed (no longer need to create worker) after it failed.
> + * In any case, the caller will recheck the condition and retry when needed,
> + * so this function doesn't need to retry.

the caller checks the condition again but the above 1/2/3 are
confusing at best.

...
> +	worker = create_worker(pool);
> +	if (worker) {
> +		del_timer_sync(&pool->mayday_timer);
> +		spin_lock_irq(&pool->lock);
> +		start_worker(worker);
> +		return;
> +	}
>  
> +	if (need_to_create_worker(pool))
>  		schedule_timeout_interruptible(CREATE_COOLDOWN);

Ugh, so we're now inserting delay in the inner function and looping
from the outside?  That's messy.  I'd prefer removing the outer loop
instead.

Thanks.

-- 
tejun
