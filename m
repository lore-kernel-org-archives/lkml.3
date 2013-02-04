Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323Ab3BDVe2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 16:34:28 -0500
Received: from mail-vb0-f50.google.com ([209.85.212.50]:43786 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755011Ab3BDVe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 16:34:27 -0500
Date: Mon, 4 Feb 2013 13:34:22 -0800
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/13] workqueue: add lock_pool_executing_work()
Message-ID: <20130204213422.GD27963@mtj.dyndns.org>
References: <1359657696-2767-1-git-send-email-laijs@cn.fujitsu.com>
 <1359657696-2767-9-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359657696-2767-9-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Feb 01, 2013 at 02:41:31AM +0800, Lai Jiangshan wrote:
> +static struct worker_pool *lock_pool_executing_work(struct work_struct *work,
> +						    struct worker **worker)
> +{
> +	unsigned long pool_id = offq_work_pool_id(work);
> +	struct worker_pool *pool;
> +	struct worker *exec;
> +
> +	if (pool_id == WORK_OFFQ_POOL_NONE)
> +		return NULL;
> +
> +	pool = worker_pool_by_id(pool_id);
> +	if (!pool)
> +		return NULL;
> +
> +	spin_lock(&pool->lock);
> +	exec = find_worker_executing_work(pool, work);
> +	if (exec) {
> +		BUG_ON(pool != exec->pool);
> +		*worker = exec;
> +		return pool;
> +	}
> +	spin_unlock(&pool->lock);
> +
> +	return NULL;
> +}

So, if a work item is queued on the same CPU and it isn't being
executed, it will lock, look up the hash, unlock and then lock again?
If this is something improved by later patch, please explain so.
There gotta be a better way to do this, right?

Thanks.

-- 
tejun
