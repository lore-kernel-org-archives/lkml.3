Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187AbaKMJaE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 04:30:04 -0500
Received: from service87.mimecast.com ([91.220.42.44]:37494 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932102AbaKMJaA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 04:30:00 -0500
Message-ID: <54647A28.7080901@arm.com>
Date: Thu, 13 Nov 2014 09:30:16 +0000
From: Juri Lelli <juri.lelli@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Wanpeng Li <wanpeng.li@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
CC: Kirill Tkhai <ktkhai@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched/deadline: fix rq->dl.pushable_tasks bug in push_dl_task()
References: <1415258564-8573-1-git-send-email-wanpeng.li@linux.intel.com>
In-Reply-To: <1415258564-8573-1-git-send-email-wanpeng.li@linux.intel.com>
X-OriginalArrivalTime: 13 Nov 2014 09:29:56.0905 (UTC) FILETIME=[636D5990:01CFFF24]
X-MC-Unique: 114111309295702901
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 06/11/14 07:22, Wanpeng Li wrote:
> Do not call dequeue_pushable_dl_task() when failing to push an eligible
> task, as it remains pushable, merely not at this particular moment. 
> Actually the patch is the same behavior as commit 311e800e16f6 ("sched, 
> rt: Fix rq->rt.pushable_tasks bug in push_rt_task()" in -rt side.
> 
> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
> ---
>  kernel/sched/deadline.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
> index f3d7776..00324af 100644
> --- a/kernel/sched/deadline.c
> +++ b/kernel/sched/deadline.c
> @@ -1331,6 +1331,7 @@ static int push_dl_task(struct rq *rq)
>  {
>  	struct task_struct *next_task;
>  	struct rq *later_rq;
> +	int ret = 0;
>  
>  	if (!rq->dl.overloaded)
>  		return 0;
> @@ -1376,7 +1377,6 @@ retry:
>  			 * The task is still there. We don't try
>  			 * again, some other cpu will pull it when ready.
>  			 */
> -			dequeue_pushable_dl_task(rq, next_task);
>  			goto out;
>  		}
>  
> @@ -1392,6 +1392,7 @@ retry:
>  	deactivate_task(rq, next_task, 0);
>  	set_task_cpu(next_task, later_rq->cpu);
>  	activate_task(later_rq, next_task, 0);
> +	ret = 1;
>  
>  	resched_curr(later_rq);
>  
> @@ -1400,7 +1401,7 @@ retry:
>  out:
>  	put_task_struct(next_task);
>  
> -	return 1;
> +	return ret;
>  }
>  
>  static void push_dl_tasks(struct rq *rq)
> 

This looks good.

Acked-by: Juri Lelli <juri.lelli@arm.com>

Thanks,

- Juri

