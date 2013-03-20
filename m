Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317Ab3CTSQX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 14:16:23 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:44292 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab3CTSQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 14:16:21 -0400
Date: Wed, 20 Mar 2013 11:16:15 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/21] workqueue: simplify
 workqueue_cpu_up_callback(CPU_ONLINE)
Message-ID: <20130320181615.GB30484@htj.dyndns.org>
References: <1363721306-2030-1-git-send-email-laijs@cn.fujitsu.com>
 <1363721306-2030-18-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363721306-2030-18-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 03:28:17AM +0800, Lai Jiangshan wrote:
> If we have 4096 CPUs, workqueue_cpu_up_callback() will travel too much CPUs,
> to avoid it, we use for_each_cpu_worker_pool for the cpu pools and
> use unbound_pool_hash for unbound pools.
> 
> After it, for_each_pool() becomes unused, so we remove it.
>  	case CPU_DOWN_FAILED:
>  	case CPU_ONLINE:
> -		mutex_lock(&pools_mutex);
> -
> -		for_each_pool(pool, pi) {
> -			mutex_lock(&pool->manager_mutex);
> -
> -			if (pool->cpu == cpu) {
> -				associate_cpu_pool(pool);
> -			} else if (pool->cpu < 0) {
> -				restore_unbound_workers_cpumask(pool, cpu);
> -			}
> -
> -			mutex_unlock(&pool->manager_mutex);
> -		}
> +		for_each_cpu_worker_pool(pool, cpu)
> +			associate_cpu_pool(pool);
>  
> +		mutex_lock(&pools_mutex);
> +		hash_for_each(unbound_pool_hash, bkt, pool, hash_node)
> +			restore_unbound_workers_cpumask(pool, cpu);
>  		mutex_unlock(&pools_mutex);
>  		break;

Hmmm... can you add for_each_unbound_pool() with proper lockdep
assertion?  Also, don't shuffle locking and flag setting around.  It
doesn't make any functional difference and I kinda like global stuff
in the hotplug callback and actual worker handling in the helper
functions.

Thanks.

-- 
tejun
