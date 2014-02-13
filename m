Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998AbaBMHqk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 02:46:40 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:41881 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783AbaBMHqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 02:46:39 -0500
Message-ID: <52FC7858.3070000@linaro.org>
Date: Thu, 13 Feb 2014 15:46:32 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>, peterz@infradead.org,
        mingo@kernel.org
CC: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH V2 2/3] sched: Fix race in idle_balance()
References: <1391728237-4441-1-git-send-email-daniel.lezcano@linaro.org> <1391728237-4441-3-git-send-email-daniel.lezcano@linaro.org>
In-Reply-To: <1391728237-4441-3-git-send-email-daniel.lezcano@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2014 07:10 AM, Daniel Lezcano wrote:
> The scheduler main function 'schedule()' checks if there are no more tasks
> on the runqueue. Then it checks if a task should be pulled in the current
> runqueue in idle_balance() assuming it will go to idle otherwise.
> 
> But the idle_balance() releases the rq->lock in order to lookup in the sched
> domains and takes the lock again right after. That opens a window where
> another cpu may put a task in our runqueue, so we won't go to idle but
> we have filled the idle_stamp, thinking we will.
> 
> This patch closes the window by checking if the runqueue has been modified
> but without pulling a task after taking the lock again, so we won't go to idle
> right after in the __schedule() function.
> 
> Cc: alex.shi@linaro.org
> Cc: peterz@infradead.org
> Cc: mingo@kernel.org
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> ---
>  kernel/sched/fair.c |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 428bc9d..5ebc681 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -6589,6 +6589,13 @@ void idle_balance(struct rq *this_rq)
>  
>  	raw_spin_lock(&this_rq->lock);
>  
> +	/*
> +	 * While browsing the domains, we released the rq lock.
> +	 * A task could have be enqueued in the meantime
> +	 */

Mind to move the following line up to here?

        if (curr_cost > this_rq->max_idle_balance_cost)
                this_rq->max_idle_balance_cost = curr_cost;

> +	if (this_rq->nr_running && !pulled_task)
> +		return;
> +
>  	if (pulled_task || time_after(jiffies, this_rq->next_balance)) {
>  		/*
>  		 * We are going idle. next_balance may be set based on
> 




-- 
Thanks
    Alex
