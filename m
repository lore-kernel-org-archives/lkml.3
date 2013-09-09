Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab3IIOOf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 10:14:35 -0400
Received: from mail-yh0-f49.google.com ([209.85.213.49]:56578 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237Ab3IIOOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 10:14:34 -0400
Date: Mon, 9 Sep 2013 10:14:30 -0400
From: Tejun Heo <tj@kernel.org>
To: Libin <huawei.libin@huawei.com>
Cc: linux-kernel@vger.kernel.org, wangyijing@huawei.com, guohanjun@huawei.com
Subject: Re: [PATCH] workqueue: fix potential reentrancy issue
Message-ID: <20130909141430.GD25434@htj.dyndns.org>
References: <1378703534-4496-1-git-send-email-huawei.libin@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378703534-4496-1-git-send-email-huawei.libin@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 01:12:14PM +0800, Libin wrote:
> From: Li Bin <huawei.libin@huawei.com>
> 
> When one work starts execution, the high bits of work's data contain
> pool ID. It can represent a maximum of WORK_OFFQ_POOL_NONE. Pool ID
> is assigned WORK_OFFQ_POOL_NONE when the work being initialized
> indicating that no pool is associated and get_work_pool() uses it to
> check the associated pool. So if worker_pool_assign_id() assigns a
> ID greater than or equal WORK_OFFQ_POOL_NONE to a pool, it may break
> the non-reentrance guarantee.
> 
> This patch fix this issue by modifying the worker_pool_assign_id()
> function to add the WORK_OFFQ_POOL_NONE check condition.
> 
> Signed-off-by: Li Bin <huawei.libin@huawei.com>
> ---
>  kernel/workqueue.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 41019b1..97d9ff7 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -518,7 +518,14 @@ static inline void debug_work_activate(struct work_struct *work) { }
>  static inline void debug_work_deactivate(struct work_struct *work) { }
>  #endif
>  
> -/* allocate ID and assign it to @pool */
> +/**
> + * worker_pool_assign_id - allocate ID and assing it to @pool
> + * @pool: the pool pointer of interest
> + *
> + * Return 0 if ID assigned successful.
> + * Return non-zero if the allocation fails or the ID number out of
> + * %WORK_OFFQ_POOL_NONE range.
> + */
>  static int worker_pool_assign_id(struct worker_pool *pool)
>  {
>  	int ret;
> @@ -526,6 +533,8 @@ static int worker_pool_assign_id(struct worker_pool *pool)
>  	lockdep_assert_held(&wq_pool_mutex);
>  
>  	ret = idr_alloc(&worker_pool_idr, pool, 0, 0, GFP_KERNEL);
> +	if (ret >= WORK_OFFQ_POOL_NONE)
> +		return ret;

Hmmm.... this would leak the allocated ID.  Just setting @end param to
idr_alloc to WORK_OFFQ_POOL_NONE would work, right?

Thanks.

-- 
tejun
