Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757620AbaJ2WuB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 18:50:01 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:61832 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756039AbaJ2Wt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 18:49:58 -0400
Message-ID: <54516F0F.7000901@gmail.com>
Date: Thu, 30 Oct 2014 06:49:51 +0800
From: Wanpeng Li <kernellwp@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Juri Lelli <juri.lelli@arm.com>, Wanpeng Li <wanpeng.li@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/6] sched/dl: fix yield task artificial overrun
References: <1414374067-7209-1-git-send-email-wanpeng.li@linux.intel.com> <1414374067-7209-2-git-send-email-wanpeng.li@linux.intel.com> <545116F7.7080607@arm.com>
In-Reply-To: <545116F7.7080607@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Juri,
2014/10/30 0:33, Juri Lelli:
> Hi,
>
> On 27/10/14 01:41, Wanpeng Li wrote:
>> The yield semantic of deadline class is to reduce remaining runtime to
>> zero, and then update_curr_dl() will stop it. However, comsumed bandwidth
>> is reduced from the budget of yield task again even if it has already been
>> set to zero which leads to artificial overrun. This patch fix it by reduce
>> remaining runtime to zero if there is still remaining runtime after comsumed
>> bandwidth is accumulated.
>>
> Oh, right. But, how about what below instead (with a proper comment
> and changelog)?
>
> Thanks,
>
> - Juri
>
>  From 108ecdff52b154ea2c79d4aac552ddf1ead871c7 Mon Sep 17 00:00:00 2001
> From: Juri Lelli <juri.lelli@arm.com>
> Date: Wed, 29 Oct 2014 16:09:06 +0000
> Subject: [PATCH] sched/deadline: fix artificial overrun introduced by
>   yield_task_dl
>
> Signed-off-by: Juri Lelli <juri.lelli@arm.com>
> ---
>   kernel/sched/deadline.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
> index 2e31a30..db6ad38 100644
> --- a/kernel/sched/deadline.c
> +++ b/kernel/sched/deadline.c
> @@ -633,7 +633,7 @@ static void update_curr_dl(struct rq *rq)
>   
>   	sched_rt_avg_update(rq, delta_exec);
>   
> -	dl_se->runtime -= delta_exec;
> +	dl_se->runtime -= dl_se->dl_yielded ? 0 : delta_exec;

+	if (dl_se->dl_yielded && dl_se->runtime > 0)
+		dl_se->runtime = 0;

Maybe this can be moved to update_curr_dl().

I think the consumed bandwidth still should be reduced from remaining 
runtime even if yield, then the remaining runtime will be reset to 0 if 
there is still remaining runtime as what my patch do. What's your option?

Regards,
Wanpeng Li

>   	if (dl_runtime_exceeded(rq, dl_se)) {
>   		__dequeue_task_dl(rq, curr, 0);
>   		if (likely(start_dl_timer(dl_se, curr->dl.dl_boosted)))

