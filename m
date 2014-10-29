Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471AbaJ2W52 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 18:57:28 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:51881 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756697AbaJ2W51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 18:57:27 -0400
Message-ID: <545170D1.8030603@gmail.com>
Date: Thu, 30 Oct 2014 06:57:21 +0800
From: Wanpeng Li <kernellwp@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Wanpeng Li <wanpeng.li@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
CC: Juri Lelli <juri.lelli@arm.com>, linux-kernel@vger.kernel.org,
        Kirill Tkhai <tkhai@yandex.ru>, Kirill Tkhai <ktkhai@parallels.com>
Subject: Re: [PATCH 1/6] sched/rt: check if curr can be pushed/pulled somewhere
 else in advance
References: <1414374067-7209-1-git-send-email-wanpeng.li@linux.intel.com>
In-Reply-To: <1414374067-7209-1-git-send-email-wanpeng.li@linux.intel.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc Kirill,
2014/10/27 9:41, Wanpeng Li:
> This patch checks if current can be pushed/pulled somewhere else
> in advance to make logic clear.
>
> - If current can't be migrated, useless to reschedule, let's hope
>    task can move out.
> - If task is migratable, so let's not schedule it and see if it
>    can be pushed or pulled somewhere else.
>
> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
> ---
>   kernel/sched/rt.c | 14 ++++++++++----
>   1 file changed, 10 insertions(+), 4 deletions(-)
>
> diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
> index 87ea5bf..ca1b7c7 100644
> --- a/kernel/sched/rt.c
> +++ b/kernel/sched/rt.c
> @@ -1351,16 +1351,22 @@ out:
>   
>   static void check_preempt_equal_prio(struct rq *rq, struct task_struct *p)
>   {
> -	if (rq->curr->nr_cpus_allowed == 1)
> +	/*
> +	 * Current can't be migrated, useless to reschedule,
> +	 * let's hope p can move out.
> +	 */
> +	if (rq->curr->nr_cpus_allowed == 1 ||
> +		!cpupri_find(&rq->rd->cpupri, rq->curr, NULL))
>   		return;
>   
> +	/*
> +	 * p is migratable, so let's not schedule it and
> +	 * see if it is pushed or pulled somewhere else.
> +	 */
>   	if (p->nr_cpus_allowed != 1
>   	    && cpupri_find(&rq->rd->cpupri, p, NULL))
>   		return;
>   
> -	if (!cpupri_find(&rq->rd->cpupri, rq->curr, NULL))
> -		return;
> -
>   	/*
>   	 * There appears to be other cpus that can accept
>   	 * current and none to run 'p', so lets reschedule

