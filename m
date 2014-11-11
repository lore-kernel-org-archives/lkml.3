Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600AbaKKHoZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 02:44:25 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:36103 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686AbaKKHoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 02:44:24 -0500
Message-ID: <5461BE46.307@gmail.com>
Date: Tue, 11 Nov 2014 15:44:06 +0800
From: Wanpeng Li <kernellwp@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Wanpeng Li <wanpeng.li@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@arm.com>
CC: Kirill Tkhai <ktkhai@parallels.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched/deadline: fix rq->dl.pushable_tasks bug in push_dl_task()
References: <1415258564-8573-1-git-send-email-wanpeng.li@linux.intel.com>
In-Reply-To: <1415258564-8573-1-git-send-email-wanpeng.li@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping Juri, could you review this one and other deadline patches of mine? 
;-)
On 14/11/6 下午3:22, Wanpeng Li wrote:
> Do not call dequeue_pushable_dl_task() when failing to push an eligible
> task, as it remains pushable, merely not at this particular moment.
> Actually the patch is the same behavior as commit 311e800e16f6 ("sched,
> rt: Fix rq->rt.pushable_tasks bug in push_rt_task()" in -rt side.
>
> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
> ---
>   kernel/sched/deadline.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
> index f3d7776..00324af 100644
> --- a/kernel/sched/deadline.c
> +++ b/kernel/sched/deadline.c
> @@ -1331,6 +1331,7 @@ static int push_dl_task(struct rq *rq)
>   {
>   	struct task_struct *next_task;
>   	struct rq *later_rq;
> +	int ret = 0;
>   
>   	if (!rq->dl.overloaded)
>   		return 0;
> @@ -1376,7 +1377,6 @@ retry:
>   			 * The task is still there. We don't try
>   			 * again, some other cpu will pull it when ready.
>   			 */
> -			dequeue_pushable_dl_task(rq, next_task);
>   			goto out;
>   		}
>   
> @@ -1392,6 +1392,7 @@ retry:
>   	deactivate_task(rq, next_task, 0);
>   	set_task_cpu(next_task, later_rq->cpu);
>   	activate_task(later_rq, next_task, 0);
> +	ret = 1;
>   
>   	resched_curr(later_rq);
>   
> @@ -1400,7 +1401,7 @@ retry:
>   out:
>   	put_task_struct(next_task);
>   
> -	return 1;
> +	return ret;
>   }
>   
>   static void push_dl_tasks(struct rq *rq)

