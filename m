Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513Ab3IBGzP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 02:55:15 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:49417 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755613Ab3IBGzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 02:55:09 -0400
Date: Mon, 2 Sep 2013 12:24:46 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Jason Low <jason.low2@hp.com>
Cc: mingo@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org,
        efault@gmx.de, pjt@google.com, preeti@linux.vnet.ibm.com,
        akpm@linux-foundation.org, mgorman@suse.de, riel@redhat.com,
        aswin@hp.com, scott.norton@hp.com
Subject: Re: [PATCH v4 2/3] sched: Consider max cost of idle balance per
 sched domain
Message-ID: <20130902065446.GV1720@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <1377806736-3752-1-git-send-email-jason.low2@hp.com>
 <1377806736-3752-3-git-send-email-jason.low2@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1377806736-3752-3-git-send-email-jason.low2@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090206-9332-0000-0000-000001465EB5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jason Low <jason.low2@hp.com> [2013-08-29 13:05:35]:

> +	u64 curr_cost = 0;
> 
>  	this_rq->idle_stamp = rq_clock(this_rq);
> 
> -	if (this_rq->avg_idle < sysctl_sched_migration_cost)
> +	if (this_rq->avg_idle < this_rq->max_idle_balance_cost)
>  		return;
> 

Since max_idle_balance_cost includes the cost of balances across all
domains. Can the cost of balance at a higher domain being higher result
in not doing load balance at a lower level?

Shouldnt the check below for sd->max_newidle_lb_cost mean that we can
actually do away with this check.

>  	/*
> @@ -5299,14 +5300,29 @@ void idle_balance(int this_cpu, struct rq *this_rq)
>  	for_each_domain(this_cpu, sd) {
>  		unsigned long interval;
>  		int balance = 1;
> +		u64 t0, domain_cost, max = 5*sysctl_sched_migration_cost;
> 
>  		if (!(sd->flags & SD_LOAD_BALANCE))
>  			continue;
> 
> +		if (this_rq->avg_idle < curr_cost + sd->max_newidle_lb_cost)
> +			break;

I am referring to this check in my above comment.

> +
>  		if (sd->flags & SD_BALANCE_NEWIDLE) {
> +			t0 = sched_clock_cpu(smp_processor_id());
> +
>  			/* If we've pulled tasks over stop searching: */
>  			pulled_task = load_balance(this_cpu, this_rq,
>  						   sd, CPU_NEWLY_IDLE, &balance);
> +
> +			domain_cost = sched_clock_cpu(smp_processor_id()) - t0;
> +			if (domain_cost > max)
> +				domain_cost = max;
> +
> +			if (domain_cost > sd->max_newidle_lb_cost)
> +				sd->max_newidle_lb_cost = domain_cost;

If we face a runq lock contention, then domain_cost can go up.
The runq lock contention could be temporary, but we carry the domain
cost forever (i.e till the next reboot).  How about averaging the cost +
penalty for unsuccessful balance.

Something like 
			domain_cost = sched_clock_cpu(smp_processor_id()) - t0;
			if (!pulled_task)
				domain_cost *= 2;
		
			sd->max_newidle_lb_cost += domain_cost;
			sd->max_newidle_lb_cost /= 2;
				
				
Maybe the name could then change to avg_newidle_lb_cost.

> +
> +			curr_cost += domain_cost;
>  		}
> 
-- 
Thanks and Regards
Srikar Dronamraju

