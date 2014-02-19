Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583AbaBSDhK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 22:37:10 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:40260 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751557AbaBSDhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 22:37:08 -0500
X-IronPort-AV: E=Sophos;i="4.97,503,1389715200"; 
   d="scan'208";a="9557215"
Message-ID: <5304277E.4040705@cn.fujitsu.com>
Date: Wed, 19 Feb 2014 11:39:42 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH wq/for-3.14-fixes] workqueue: ensure @task is valid across
 kthread_stop()
References: <1392472948-2486-1-git-send-email-laijs@cn.fujitsu.com> <20140218213713.GC31892@mtj.dyndns.org>
In-Reply-To: <20140218213713.GC31892@mtj.dyndns.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/19 11:34:54,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/19 11:34:55,
	Serialize complete at 2014/02/19 11:34:55
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2014 05:37 AM, Tejun Heo wrote:
> Hello, Lai.
> 
> I massaged the patch a bit and applied it to wq/for-3.14-fixes.
> 
> Thanks.
> -------- 8< --------
>>From 5bdfff96c69a4d5ab9c49e60abf9e070ecd2acbb Mon Sep 17 00:00:00 2001
> From: Lai Jiangshan <laijs@cn.fujitsu.com>
> Date: Sat, 15 Feb 2014 22:02:28 +0800
> 
> When a kworker should die, the kworkre is notified through WORKER_DIE
> flag instead of kthread_should_stop().  This, IIRC, is primarily to
> keep the test synchronized inside worker_pool lock.  WORKER_DIE is
> first set while holding pool->lock, the lock is dropped and
> kthread_stop() is called.
> 
> Unfortunately, this means that there's a slight chance that the target
> kworker may see WORKER_DIE before kthread_stop() finishes and exits
> and frees the target task before or during kthread_stop().
> 
> Fix it by pinning the target task before setting WORKER_DIE and
> putting it after kthread_stop() is done.
> 
> tj: Improved patch description and comment.  Moved pinning above
>     WORKER_DIE for better signify what it's protecting.
> 
> CC: stable@vger.kernel.org

I think no one hit this bug. So I add this stable TAG?

(Jason's bug-report drives me to review the workqueue harder,
and I found this possible bug, but I think it is irrespective
with Jason's bug-report.)

> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  kernel/workqueue.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 82ef9f3..193e977 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -1851,6 +1851,12 @@ static void destroy_worker(struct worker *worker)
>  	if (worker->flags & WORKER_IDLE)
>  		pool->nr_idle--;
>  
> +	/*
> +	 * Once WORKER_DIE is set, the kworker may destroy itself at any
> +	 * point.  Pin to ensure the task stays until we're done with it.
> +	 */
> +	get_task_struct(worker->task);
> +
>  	list_del_init(&worker->entry);
>  	worker->flags |= WORKER_DIE;
>  
> @@ -1859,6 +1865,7 @@ static void destroy_worker(struct worker *worker)
>  	spin_unlock_irq(&pool->lock);
>  
>  	kthread_stop(worker->task);
> +	put_task_struct(worker->task);
>  	kfree(worker);
>  
>  	spin_lock_irq(&pool->lock);

