Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273Ab3AaQIS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 11:08:18 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7328 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666Ab3AaQIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 11:08:13 -0500
X-Authority-Analysis: v=2.0 cv=W/m6pGqk c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=4f-7QChvy6YA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=d6yz6j7gusgA:10 a=vaJtXVxTAAAA:8 a=VwQbUJbxAAAA:8 a=JfrnYn6hAAAA:8 a=RHTLVTpuBGyj3RWuzokA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=LI9Vle30uBYA:10 a=3Rfx1nUSh_UA:10 a=w-U1ociBthauhLTm:21 a=kxrvclA6HJn1iQnt:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1359648490.17639.107.camel@gandalf.local.home>
Subject: Re: [PATCH] sched/rt: Decrease number of calls of push_rt_task() in
 push_rt_tasks()
From: Steven Rostedt <rostedt@goodmis.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Date: Thu, 31 Jan 2013 11:08:10 -0500
In-Reply-To: <2016751359330408@web20f.yandex.ru>
References: <2016751359330408@web20f.yandex.ru>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-28 at 03:46 +0400, Kirill Tkhai wrote:
> The patch aims to decrease the number of calls of push_rt_task()
> in push_rt_tasks().
> 
> It's not necessary to push more than 'num_online_cpus() - 1' tasks.
> If just pushed task doesn't leave its new CPU during our local call
> of push_rt_tasks() than we won't push another task to the CPU.
> If it leave or change priority than it will pull new task by itself.

I'm curious. Have you hit situations where this was an issue? Or was
this just discovered by code review?

-- Steve

> 
> Signed-off-by: Kirill V Tkhai <tkhai@yandex.ru>
> CC: Steven Rostedt <rostedt@goodmis.org>
> CC: Ingo Molnar <mingo@kernel.org>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: linux-rt-users <linux-rt-users@vger.kernel.org>
> ---
>  kernel/sched/rt.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
> index 4e8f0f4..edf046d 100644
> --- a/kernel/sched/rt.c
> +++ b/kernel/sched/rt.c
> @@ -1703,8 +1703,10 @@ out:
>  
>  static void push_rt_tasks(struct rq *rq)
>  {
> +	int num_cpus = num_online_cpus() - 1;
> +
>  	/* push_rt_task will return true if it moved an RT */
> -	while (push_rt_task(rq))
> +	while (push_rt_task(rq) && --num_cpus > 0)
>  		;
>  }
>  


