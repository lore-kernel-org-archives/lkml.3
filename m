Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751671AbaDQP17 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 11:27:59 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:52256 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbaDQP1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 11:27:48 -0400
Date: Thu, 17 Apr 2014 11:27:44 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] workqueue: rescuer_thread() processes all pwqs
 before exit
Message-ID: <20140417152744.GM15326@htj.dyndns.org>
References: <20140416165052.GK1257@htj.dyndns.org>
 <1397691258-11639-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397691258-11639-1-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Apr 17, 2014 at 07:34:08AM +0800, Lai Jiangshan wrote:
> Before the rescuer is picked to running, the works of the @pwq
> may be processed by some other workers, and destroy_workqueue()
> may called at the same time. This may result a nasty situation
> that rescuer may exit with non-empty mayday list.
> 
> It is no harm currently, destroy_workqueue() can safely to free
> them all(workqueue&pwqs) togerther, since the rescuer is stopped.
> No rescuer nor mayday-timer can access the mayday list.
> 
> But it is nasty and error-prone in future develop. Fix it.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
>  kernel/workqueue.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 0ee63af..832125f 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -2409,12 +2409,6 @@ static int rescuer_thread(void *__rescuer)
>  repeat:
>  	set_current_state(TASK_INTERRUPTIBLE);
>  
> -	if (kthread_should_stop()) {
> -		__set_current_state(TASK_RUNNING);
> -		rescuer->task->flags &= ~PF_WQ_WORKER;
> -		return 0;
> -	}
> -
>  	/* see whether any pwq is asking for help */
>  	spin_lock_irq(&wq_mayday_lock);
>  
> @@ -2459,6 +2453,12 @@ repeat:
>  
>  	spin_unlock_irq(&wq_mayday_lock);
>  
> +	if (kthread_should_stop()) {
> +		__set_current_state(TASK_RUNNING);
> +		rescuer->task->flags &= ~PF_WQ_WORKER;
> +		return 0;
> +	}
> +

I don't think this is reliable.  What if mayday requests take place
between wq_mayday_lock and kthread_should_stop() check?  We'll
probably need to run through mayday list after checking should_stop.

Thanks.

-- 
tejun
