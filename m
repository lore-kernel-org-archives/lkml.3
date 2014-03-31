Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563AbaCaOhZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 10:37:25 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:23903 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753289AbaCaOhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 10:37:21 -0400
X-IronPort-AV: E=Sophos;i="4.97,765,1389715200"; 
   d="scan'208";a="9800798"
Message-ID: <53397E6F.6050600@cn.fujitsu.com>
Date: Mon, 31 Mar 2014 22:40:47 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] workqueue: fix possible race condition when rescuer
 VS pwq-release
References: <1395937212-4103-1-git-send-email-laijs@cn.fujitsu.com> <5335661E.7030408@cn.fujitsu.com>
In-Reply-To: <5335661E.7030408@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/31 22:34:02,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/31 22:34:02,
	Serialize complete at 2014/03/31 22:34:02
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping

On 03/28/2014 08:07 PM, Lai Jiangshan wrote:
>>From 11af0cd0306309f0deaf3326cc26d3e7e517e3d1 Mon Sep 17 00:00:00 2001
> From: Lai Jiangshan <laijs@cn.fujitsu.com>
> Date: Fri, 28 Mar 2014 00:20:12 +0800
> Subject: [PATCH] workqueue: fix possible race condition when rescuer VS
>  pwq-release
> 
> There is a race condition between rescuer_thread() and
> pwq_unbound_release_workfn().
> 
> The works of the @pwq may be processed by some other workers,
> and @pwq is scheduled to release(due to its wq's attr is changed)
> before the rescuer starts to process. In this case
> pwq_unbound_release_workfn() will corrupt wq->maydays list,
> and rescuer_thead() will access to corrupted data.
> 
> Using get_unbound_pwq() when send_mayday() will keep @pwq's lifetime
> and avoid the race condition.
> 
> Changed from V1:
> 	1) Introduce get_unbound_pwq() for beter readibility. Since
> 	   get_pwq() is considerred no-op for percpu workqueue,
> 	   so the patch are the same behavior in functionality.
> 	2) More precise comments.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
>  kernel/workqueue.c |   30 ++++++++++++++++++++++++++++++
>  1 files changed, 30 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 0c74979..d845bdd 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -1050,6 +1050,12 @@ static void get_pwq(struct pool_workqueue *pwq)
>  	pwq->refcnt++;
>  }
>  
> +static inline void get_unbound_pwq(struct pool_workqueue *pwq)
> +{
> +	if (pwq->wq->flags & WQ_UNBOUND)
> +		get_pwq(pwq);
> +}
> +
>  /**
>   * put_pwq - put a pool_workqueue reference
>   * @pwq: pool_workqueue to put
> @@ -1075,6 +1081,12 @@ static void put_pwq(struct pool_workqueue *pwq)
>  	schedule_work(&pwq->unbound_release_work);
>  }
>  
> +static inline void put_unbound_pwq(struct pool_workqueue *pwq)
> +{
> +	if (pwq->wq->flags & WQ_UNBOUND)
> +		put_pwq(pwq);
> +}
> +
>  /**
>   * put_pwq_unlocked - put_pwq() with surrounding pool lock/unlock
>   * @pwq: pool_workqueue to put (can be %NULL)
> @@ -1908,6 +1920,19 @@ static void send_mayday(struct work_struct *work)
>  
>  	/* mayday mayday mayday */
>  	if (list_empty(&pwq->mayday_node)) {
> +		/*
> +		 * A pwq of an unbound wq may be released before wq's
> +		 * destruction when the wq's attr is changed. In this case,
> +		 * pwq_unbound_release_workfn() may execute earlier before
> +		 * rescuer_thread() and corrupt wq->maydays list.
> +		 *
> +		 * get_unbound_pwq() keeps the unbound pwq until the rescuer
> +		 * processes it and protects the pwq from being scheduled to
> +		 * release when someone else processes all the works before
> +		 * the rescuer starts to process.
> +		 */
> +		get_unbound_pwq(pwq);
> +
>  		list_add_tail(&pwq->mayday_node, &wq->maydays);
>  		wake_up_process(wq->rescuer->task);
>  	}
> @@ -2424,6 +2449,7 @@ repeat:
>  		/* migrate to the target cpu if possible */
>  		worker_maybe_bind_and_lock(pool);
>  		rescuer->pool = pool;
> +		put_unbound_pwq(pwq);
>  
>  		/*
>  		 * Slurp in all works issued via this workqueue and
> @@ -4318,6 +4344,10 @@ void destroy_workqueue(struct workqueue_struct *wq)
>  		/*
>  		 * The base ref is never dropped on per-cpu pwqs.  Directly
>  		 * free the pwqs and wq.
> +		 *
> +		 * The wq->maydays list maybe still have some pwqs linked,
> +		 * but it is safe to free them all together since the rescuer
> +		 * is stopped.
>  		 */
>  		free_percpu(wq->cpu_pwqs);
>  		kfree(wq);

