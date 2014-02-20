Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895AbaBTHr3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 02:47:29 -0500
Received: from mail-ea0-f170.google.com ([209.85.215.170]:33691 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbaBTHr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 02:47:28 -0500
Message-ID: <5305B31C.7060508@gmail.com>
Date: Thu, 20 Feb 2014 08:47:40 +0100
From: Juri Lelli <juri.lelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] sched/deadline: Fix overflow to handle period==0 and
 deadline!=0
References: <20140218215659.2a3ddd8f@gandalf.local.home> <20140219135335.7e74abd4@gandalf.local.home>
In-Reply-To: <20140219135335.7e74abd4@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2014 07:53 PM, Steven Rostedt wrote:
> While debugging the crash with the bad nr_running accounting, I hit
> another bug where, after running my sched deadline test, I was getting
> failures to take a CPU offline. It was giving me a -EBUSY error.
> 
> Adding a bunch of trace_printk()s around, I found that the cpu
> notifier that called sched_cpu_inactive() was returning a failure. The
> overflow value was coming up negative?
> 
> Talking this over with Juri, the problem is that the total_bw update was
> suppose to be made by dl_overflow() which, during my tests, seemed to
> not be called. Adding more trace_printk()s, it wasn't that it wasn't
> called, but it exited out right away with the check of new_bw being
> equal to p->dl.dl_bw. The new_bw calculates the ratio between period and
> runtime. The bug is that if you set a deadline, you do not need to set
> a period if you plan on the period being equal to the deadline. That
> is, if period is zero and deadline is not, then the system call should
> set the period to be equal to the deadline. This is done elsewhere in
> the code.
> 
> The fix is easy, check if period is set, and if it is not, then use the
> deadline.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index b46131e..2491448 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -1952,7 +1952,7 @@ static int dl_overflow(struct task_struct *p, int policy,
>  {
>  
>  	struct dl_bw *dl_b = dl_bw_of(task_cpu(p));
> -	u64 period = attr->sched_period;
> +	u64 period = attr->sched_period ?: attr->sched_deadline;
>  	u64 runtime = attr->sched_runtime;
>  	u64 new_bw = dl_policy(policy) ? to_ratio(period, runtime) : 0;
>  	int cpus, err = -1;
> 

Thanks!

- Juri
