Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177AbaDPMNp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 08:13:45 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56852 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756063AbaDPMNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 08:13:43 -0400
Date: Wed, 16 Apr 2014 14:13:30 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alex Shi <alex.shi@linaro.org>
Cc: mingo@redhat.com, morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        daniel.lezcano@linaro.org, efault@gmx.de, chris.redpath@arm.com,
        wangyun@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] sched: let task migration destination cpu do active
 balance
Message-ID: <20140416121329.GO26782@laptop.programming.kicks-ass.net>
References: <1397648069-6462-1-git-send-email-alex.shi@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397648069-6462-1-git-send-email-alex.shi@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 07:34:29PM +0800, Alex Shi wrote:
> Chris Redpath found an issue on active balance: 
> We let the task source cpu, the busiest cpu, do the active balance,
> while the destination cpu maybe idle. thus we take the busiest cpu
> time, but left the idlest cpu wait. That is not good for performance.
> 
> This patch let the destination cpu do active balance. It will give tasks
> more running time.
> 
> Signed-off-by: Alex Shi <alex.shi@linaro.org>
> ---
>  kernel/sched/fair.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 9b4c4f3..cccee76 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -6308,7 +6308,7 @@ more_balance:
>  			raw_spin_unlock_irqrestore(&busiest->lock, flags);
>  
>  			if (active_balance) {
> -				stop_one_cpu_nowait(cpu_of(busiest),
> +				stop_one_cpu_nowait(busiest->push_cpu,
>  					active_load_balance_cpu_stop, busiest,
>  					&busiest->active_balance_work);
>  			}

This doesn't make sense, the whole point of active balance is that we're
going to move current, for that to work we have to interrupt the CPU
current is running on and make sure another task (the stopper task in
this case) is running, so that the previous current is now a !running
task and we can move it around.
