Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496AbaBYU7h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 15:59:37 -0500
Received: from forward7l.mail.yandex.net ([84.201.143.140]:35544 "EHLO
	forward7l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbaBYU7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 15:59:36 -0500
X-Yandex-Uniq: 757c79e5-2eb6-4b7b-885a-25a5a4f5b11a
Authentication-Results: smtp17.mail.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <1393361805.12438.6.camel@HP-250-G1-Notebook-PC>
Subject: Re: [PATCH] sched/rt: fix rt timer activation/deactivation
From: Kirill Tkhai <tkhai@yandex.ru>
Reply-To: tkhai@yandex.ru
To: Juri Lelli <juri.lelli@gmail.com>
Cc: mingo@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org
Date: Wed, 26 Feb 2014 00:56:45 +0400
In-Reply-To: <1393344328-16653-1-git-send-email-juri.lelli@gmail.com>
References: <1393344328-16653-1-git-send-email-juri.lelli@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Вт, 2014-02-25 at 17:05 +0100, Juri Lelli wrote:
> Destroy rt bandwidth timer when rq has no more RT tasks, even when
> CONFIG_RT_GROUP_SCHED is not set.
> 
> Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
> ---
>  kernel/sched/rt.c |   10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
> index a2740b7..7dba25a 100644
> --- a/kernel/sched/rt.c
> +++ b/kernel/sched/rt.c
> @@ -86,12 +86,12 @@ void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq)
>  	raw_spin_lock_init(&rt_rq->rt_runtime_lock);
>  }
>  
> -#ifdef CONFIG_RT_GROUP_SCHED
>  static void destroy_rt_bandwidth(struct rt_bandwidth *rt_b)
>  {
>  	hrtimer_cancel(&rt_b->rt_period_timer);
>  }
>  
> +#ifdef CONFIG_RT_GROUP_SCHED
>  #define rt_entity_is_task(rt_se) (!(rt_se)->my_q)
>  
>  static inline struct task_struct *rt_task_of(struct sched_rt_entity *rt_se)
> @@ -1011,8 +1011,12 @@ inc_rt_group(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
>  	start_rt_bandwidth(&def_rt_bandwidth);
>  }
>  
> -static inline
> -void dec_rt_group(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq) {}
> +static void
> +dec_rt_group(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
> +{
> +	if (!rt_rq->rt_nr_running)
> +		destroy_rt_bandwidth(&def_rt_bandwidth);
> +}

The problem is bandwidth timer is not per-cpu. It's only for all
processors from the span (sched_rt_period_mask()). Other CPUs may
have enqueued RT tasks. So, it's not possible to do this.

>  
>  #endif /* CONFIG_RT_GROUP_SCHED */
>  


