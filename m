Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765AbaBJKGQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 05:06:16 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:32395 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752312AbaBJKGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 05:06:12 -0500
X-IronPort-AV: E=Sophos;i="4.95,816,1384272000"; 
   d="scan'208";a="9498252"
Message-ID: <52F8A51F.4090909@cn.fujitsu.com>
Date: Mon, 10 Feb 2014 18:08:31 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Zoran Markovic <zoran.markovic@linaro.org>
CC: linux-kernel@vger.kernel.org, Shaibal Dutta <shaibal.dutta@broadcom.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dipankar Sarma <dipankar@in.ibm.com>
Subject: Re: [RFC PATCH] rcu: move SRCU grace period work to power efficient
 workqueue
References: <1391197986-12774-1-git-send-email-zoran.markovic@linaro.org>
In-Reply-To: <1391197986-12774-1-git-send-email-zoran.markovic@linaro.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/10 18:04:12,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/10 18:04:12,
	Serialize complete at 2014/02/10 18:04:12
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Lai Jiangshan <laijs@cn.fujitsu.com>

On 02/01/2014 03:53 AM, Zoran Markovic wrote:
> From: Shaibal Dutta <shaibal.dutta@broadcom.com>
> 
> For better use of CPU idle time, allow the scheduler to select the CPU
> on which the SRCU grace period work would be scheduled. This improves
> idle residency time and conserves power.
> 
> This functionality is enabled when CONFIG_WQ_POWER_EFFICIENT is selected.
> 
> Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
> Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> Cc: Dipankar Sarma <dipankar@in.ibm.com>
> Signed-off-by: Shaibal Dutta <shaibal.dutta@broadcom.com>
> [zoran.markovic@linaro.org: Rebased to latest kernel version. Added commit
> message. Fixed code alignment.]
> ---
>  kernel/rcu/srcu.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/rcu/srcu.c b/kernel/rcu/srcu.c
> index 3318d82..a1ebe6d 100644
> --- a/kernel/rcu/srcu.c
> +++ b/kernel/rcu/srcu.c
> @@ -398,7 +398,7 @@ void call_srcu(struct srcu_struct *sp, struct rcu_head *head,
>  	rcu_batch_queue(&sp->batch_queue, head);
>  	if (!sp->running) {
>  		sp->running = true;
> -		schedule_delayed_work(&sp->work, 0);
> +		queue_delayed_work(system_power_efficient_wq, &sp->work, 0);
>  	}
>  	spin_unlock_irqrestore(&sp->queue_lock, flags);
>  }
> @@ -674,7 +674,8 @@ static void srcu_reschedule(struct srcu_struct *sp)
>  	}
>  
>  	if (pending)
> -		schedule_delayed_work(&sp->work, SRCU_INTERVAL);
> +		queue_delayed_work(system_power_efficient_wq,
> +				   &sp->work, SRCU_INTERVAL);
>  }
>  
>  /*

