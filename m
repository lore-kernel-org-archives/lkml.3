Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543Ab3A3NfV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 08:35:21 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6994 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754379Ab3A3NfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 08:35:18 -0500
X-Authority-Analysis: v=2.0 cv=bJmU0YCZ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=44gi5GaMPBMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=lw-8Zmdb1FwA:10 a=vaJtXVxTAAAA:8 a=VwQbUJbxAAAA:8 a=JfrnYn6hAAAA:8 a=7QlygLpgY-DUBW25seUA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=LI9Vle30uBYA:10 a=3Rfx1nUSh_UA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1359552916.17639.93.camel@gandalf.local.home>
Subject: Re: [PATCH]sched/rt: Do not account zero delta_exec in
 update_curr_rt()
From: Steven Rostedt <rostedt@goodmis.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Date: Wed, 30 Jan 2013 08:35:16 -0500
In-Reply-To: <931541359550236@web1g.yandex.ru>
References: <931541359550236@web1g.yandex.ru>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-30 at 16:50 +0400, Kirill Tkhai wrote:
> There are several places of consecutive calls of dequeue_task_rt()
> and put_prev_task_rt() in the scheduler. For example, function
> rt_mutex_setprio() does it.
> 
> The both calls lead to update_curr_rt(), the second of it receives
> zeroed delta_exec. The only effective action in this case is call of
> sched_rt_avg_update(), which can change rq->age_stamp and rq->rt_avg.
> But it is possible in case of ""floating"" rq->clock. This fact is
> not reasonable to be accounted. Another actions do nothing.
> 
> Signed-off-by: Kirill V Tkhai <tkhai@yandex.ru>

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> CC: Ingo Molnar <mingo@kernel.org>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: linux-rt-users <linux-rt-users@vger.kernel.org>
> ---
>  kernel/sched/rt.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
> index 4e8f0f4..c6d7993 100644
> --- a/kernel/sched/rt.c
> +++ b/kernel/sched/rt.c
> @@ -925,8 +925,8 @@ static void update_curr_rt(struct rq *rq)
>  		return;
>  
>  	delta_exec = rq->clock_task - curr->se.exec_start;
> -	if (unlikely((s64)delta_exec < 0))
> -		delta_exec = 0;
> +	if (unlikely((s64)delta_exec <= 0))
> +		return;
>  
>  	schedstat_set(curr->se.statistics.exec_max,
>  		      max(curr->se.statistics.exec_max, delta_exec));


