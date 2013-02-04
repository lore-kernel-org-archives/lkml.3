Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401Ab3BDVlD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 16:41:03 -0500
Received: from mail-ve0-f181.google.com ([209.85.128.181]:37132 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754448Ab3BDVlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 16:41:01 -0500
Date: Mon, 4 Feb 2013 13:40:57 -0800
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/13] workqueue: record global worker ID instead of pool
 ID in work->data when off-queue
Message-ID: <20130204214057.GG27963@mtj.dyndns.org>
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

Hello,

On Fri, Feb 01, 2013 at 02:41:36AM +0800, Lai Jiangshan wrote:
> -	pool = worker_pool_by_id(pool_id);
> -	if (!pool)
> -		return NULL;
> +	rcu_read_lock();
> +	exec = idr_find(&worker_gwid_idr, worker_gwid);
>  
> -	spin_lock(&pool->lock);
> -	exec = find_worker_executing_work(pool, work);
>  	if (exec) {
> -		BUG_ON(pool != exec->pool);
> -		*worker = exec;
> -		return pool;
> +		pool = exec->pool;
> +		spin_lock(&pool->lock);
> +		if (exec->current_work == work &&
> +		    exec->current_func == work->func) {
> +			*worker = exec;
> +			rcu_read_unlock();
> +			return pool;
> +		}
> +		spin_unlock(&pool->lock);
>  	}
> -	spin_unlock(&pool->lock);
> +	rcu_read_unlock();

We're guaranteed to have irq disabled, why not use sched_rcu in
combination with synchronize_sched()?

Thanks.

-- 
tejun
