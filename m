Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123AbaKDM1e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 07:27:34 -0500
Received: from out21.biz.mail.alibaba.com ([205.204.114.132]:55515 "EHLO
	out21.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750866AbaKDM1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 07:27:33 -0500
X-Greylist: delayed 323 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Nov 2014 07:27:32 EST
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;FP=0|-1|-1|-1|0|-1|-1|-1;HT=r41g08144;MF=hillf.zj@alibaba-inc.com;PH=DS;RN=6;RT=6;SR=0;
Reply-To: "Hillf Danton" <hillf.zj@alibaba-inc.com>
From: "Hillf Danton" <hillf.zj@alibaba-inc.com>
To: "'pang.xunlei'" <pang.xunlei@linaro.org>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "'Ingo Molnar'" <mingo@redhat.com>,
        "'Peter Zijlstra'" <peterz@infradead.org>,
        "'Steven Rostedt'" <rostedt@goodmis.org>,
        "'Juri Lelli'" <juri.lelli@gmail.com>
Subject: Re: [PATCH v2 2/6] sched/rt: Optimize select_task_rq_rt() for non-RT curr task
Date: Tue, 04 Nov 2014 20:21:37 +0800
Message-ID: <011501cff829$e1a26e60$a4e74b20$@alibaba-inc.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: Ac/4KVxFThArGhaQRK2FCl2G0QbaxA==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> When selecting the cpu for a waking RT task, if curr is a non-RT
> task which is bound only on this cpu, then we can give it a chance
> to select a different cpu(definitely an idle cpu if existing) for
> the RT task to avoid curr starving.
> 
> Signed-off-by: pang.xunlei <pang.xunlei@linaro.org>
> ---
>  kernel/sched/rt.c |   10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
> index da6922e..dc1f7f0 100644
> --- a/kernel/sched/rt.c
> +++ b/kernel/sched/rt.c
> @@ -1340,6 +1340,11 @@ select_task_rq_rt(struct task_struct *p, int cpu, int sd_flag, int flags)
>  	 * runqueue. Otherwise simply start this RT task
>  	 * on its current runqueue.
>  	 *
> +	 * If the current task on @p's runqueue is a non-RT task,
> +	 * and this task is bound on current runqueue, then try to
> +	 * see if we can wake this RT task up on a different runqueue,
> +	 * we will definitely find an idle cpu if there is any.
> +	 *
>  	 * We want to avoid overloading runqueues. If the woken
>  	 * task is a higher priority, then it will stay on this CPU
>  	 * and the lower prio task should be moved to another CPU.
> @@ -1356,9 +1361,8 @@ select_task_rq_rt(struct task_struct *p, int cpu, int sd_flag, int flags)
>  	 * This test is optimistic, if we get it wrong the load-balancer
>  	 * will have to sort it out.
>  	 */
> -	if (curr && unlikely(rt_task(curr)) &&
> -	    (curr->nr_cpus_allowed < 2 ||
> -	     curr->prio <= p->prio)) {
> +	if (curr && unlikely(curr->nr_cpus_allowed < 2 ||
> +				curr->prio <= p->prio)) {

Nack, it is no meaning to compare apple against orange.

Hillf
>  		int target = find_lowest_rq(p);
> 
>  		if (target != -1)
> --
> 1.7.9.5

