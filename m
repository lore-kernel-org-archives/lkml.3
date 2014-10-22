Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932608AbaJVJdK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 05:33:10 -0400
Received: from service87.mimecast.com ([91.220.42.44]:43884 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbaJVJdI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 05:33:08 -0400
Message-ID: <544779D1.4060309@arm.com>
Date: Wed, 22 Oct 2014 10:33:05 +0100
From: Juri Lelli <juri.lelli@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Wanpeng Li <wanpeng.li@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
CC: Kirill V Tkhai <tkhai@yandex.ru>, Steven Rostedt <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] sched/deadline: do not try to push tasks if pinned
 task switches to dl
References: <1413938203-224610-1-git-send-email-wanpeng.li@linux.intel.com>
In-Reply-To: <1413938203-224610-1-git-send-email-wanpeng.li@linux.intel.com>
X-OriginalArrivalTime: 22 Oct 2014 09:33:04.0824 (UTC) FILETIME=[2E590380:01CFEDDB]
X-MC-Unique: 114102210330600101
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/10/14 01:36, Wanpeng Li wrote:
> As Kirill mentioned(https://lkml.org/lkml/2013/1/29/118):
> | If rq has already had 2 or more pushable tasks and we try to add a 
> | pinned task then call of push_rt_task will just waste a time.
> 
> Just switched pinned task is not able to be pushed. If the rq has had
> several dl tasks before they have already been considered as candidates
> to be pushed (or pulled). This patch implements the same behavior as rt 
> class which introduced by commit 10447917551e ("sched/rt: Do not try to 
> push tasks if pinned task switches to RT"). 
> 
> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
> ---
> v2 -> v3:
>  * cleanup patch description
>  * align && to p->nr_cpus_allowed
> v1 -> v2:
>  * use 12 or more chars for the git commit ID
> 
>  kernel/sched/deadline.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
> index abfaf3d..bd5e479 100644
> --- a/kernel/sched/deadline.c
> +++ b/kernel/sched/deadline.c
> @@ -1603,7 +1603,8 @@ static void switched_to_dl(struct rq *rq, struct task_struct *p)
>  
>  	if (task_on_rq_queued(p) && rq->curr != p) {
>  #ifdef CONFIG_SMP
> -		if (rq->dl.overloaded && push_dl_task(rq) && rq != task_rq(p))
> +		if (p->nr_cpus_allowed > 1 && rq->dl.overloaded &&
> +			push_dl_task(rq) && rq != task_rq(p))
>  			/* Only reschedule if pushing failed */
>  			check_resched = 0;
>  #endif /* CONFIG_SMP */
> 

Looks good. Thanks!

Best,

- Juri

