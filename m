Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429AbaEUHZA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 03:25:00 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:19849 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750865AbaEUHY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 03:24:59 -0400
X-IronPort-AV: E=Sophos;i="4.98,878,1392134400"; 
   d="scan'208";a="30806698"
Message-ID: <537C55C4.70706@cn.fujitsu.com>
Date: Wed, 21 May 2014 15:29:08 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <cl@linux.com>,
        Kevin Hilman <khilman@linaro.org>,
        Mike Galbraith <bitbucket@online.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>, Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 1/5] workqueue: Allow changing attributions of ordered
 workqueues
References: <1400257015-28222-1-git-send-email-fweisbec@gmail.com> <1400257015-28222-2-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1400257015-28222-2-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2014 12:16 AM, Frederic Weisbecker wrote:

> @@ -3708,6 +3712,13 @@ static void rcu_free_pwq(struct rcu_head *rcu)
>  			container_of(rcu, struct pool_workqueue, rcu));
>  }
>  
> +static struct pool_workqueue *oldest_pwq(struct workqueue_struct *wq)
> +{
> +	return list_last_entry(&wq->pwqs, struct pool_workqueue, pwqs_node);
> +}
> +
> +static void pwq_adjust_max_active(struct pool_workqueue *pwq);


Hi, Tejun,

Should we reorder the pwq_adjust_max_active() to avoid this declare?
(Move pwq_adjust_max_active() to the place just before rcu_free_pwq())

Thanks,
Lai

> +
>  /*
>   * Scheduled on system_wq by put_pwq() when an unbound pwq hits zero refcnt
>   * and needs to be destroyed.
> @@ -3723,14 +3734,12 @@ static void pwq_unbound_release_workfn(struct work_struct *work)
>  	if (WARN_ON_ONCE(!(wq->flags & WQ_UNBOUND)))
>  		return;
>  
> -	/*
> -	 * Unlink @pwq.  Synchronization against wq->mutex isn't strictly
> -	 * necessary on release but do it anyway.  It's easier to verify
> -	 * and consistent with the linking path.
> -	 */
>  	mutex_lock(&wq->mutex);
>  	list_del_rcu(&pwq->pwqs_node);
>  	is_last = list_empty(&wq->pwqs);
> +	/* try to activate the oldest pwq when needed */
> +	if (!is_last && (wq->flags & __WQ_ORDERED))
> +		pwq_adjust_max_active(oldest_pwq(wq));
>  	mutex_unlock(&wq->mutex);
>  
>  	mutex_lock(&wq_pool_mutex);
