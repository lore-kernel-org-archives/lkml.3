Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530AbaDXKUo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 06:20:44 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:33896 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755211AbaDXKTD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 06:19:03 -0400
Message-ID: <5358E417.8090503@linux.vnet.ibm.com>
Date: Thu, 24 Apr 2014 15:44:47 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Jason Low <jason.low2@hp.com>
CC: mingo@kernel.org, peterz@infradead.org, linux-kernel@vger.kernel.org,
        daniel.lezcano@linaro.org, alex.shi@linaro.org, efault@gmx.de,
        vincent.guittot@linaro.org, morten.rasmussen@arm.com, aswin@hp.com,
        chegu_vinod@hp.com
Subject: Re: [PATCH 1/3] sched, balancing: Update rq->max_idle_balance_cost
 whenever newidle balance is attempted
References: <1398303035-18255-1-git-send-email-jason.low2@hp.com> <1398303035-18255-2-git-send-email-jason.low2@hp.com>
In-Reply-To: <1398303035-18255-2-git-send-email-jason.low2@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042410-0320-0000-0000-000003153785
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

On 04/24/2014 07:00 AM, Jason Low wrote:
> Commit e5fc6611 can potentially cause rq->max_idle_balance_cost to not be
> updated, even when load_balance(NEWLY_IDLE) is attempted and the per-sd
> max cost value is updated.
> 
> In this patch, we update the rq->max_idle_balance_cost regardless of
> whether or not a task has been enqueued while browsing the domains.
> 
> Signed-off-by: Jason Low <jason.low2@hp.com>
> ---
>  kernel/sched/fair.c |    9 +++++----
>  1 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 43232b8..3e3ffb8 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -6658,6 +6658,7 @@ static int idle_balance(struct rq *this_rq)
>  	int this_cpu = this_rq->cpu;
> 
>  	idle_enter_fair(this_rq);
> +
>  	/*
>  	 * We must set idle_stamp _before_ calling idle_balance(), such that we
>  	 * measure the duration of idle_balance() as idle time.
> @@ -6710,9 +6711,12 @@ static int idle_balance(struct rq *this_rq)
> 
>  	raw_spin_lock(&this_rq->lock);
> 
> +	if (curr_cost > this_rq->max_idle_balance_cost)
> +		this_rq->max_idle_balance_cost = curr_cost;
> +
>  	/*

What about the update of next_balance field? See the code snippet below.
This will also be skipped as a consequence of the commit e5fc6611 right?

if (pulled_task || time_after(jiffies, this_rq->next_balance)) {
               /*
                  * We are going idle. next_balance may be set based on
                  * a busy processor. So reset next_balance.
                  */
                 this_rq->next_balance = next_balance;
         }

Also the comment in the above snippet does not look right to me.
It says "we are going idle" but the condition checks for pulled_task.


Regards
Preeti U Murthy

>  	 * While browsing the domains, we released the rq lock.
> -	 * A task could have be enqueued in the meantime
> +	 * A task could have been enqueued in the meantime.
>  	 */
>  	if (this_rq->cfs.h_nr_running && !pulled_task) {
>  		pulled_task = 1;
> @@ -6727,9 +6731,6 @@ static int idle_balance(struct rq *this_rq)
>  		this_rq->next_balance = next_balance;
>  	}
> 
> -	if (curr_cost > this_rq->max_idle_balance_cost)
> -		this_rq->max_idle_balance_cost = curr_cost;
> -
>  out:
>  	/* Is there a task of a high priority class? */
>  	if (this_rq->nr_running != this_rq->cfs.h_nr_running)
> 

