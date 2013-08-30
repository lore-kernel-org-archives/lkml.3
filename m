Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320Ab3H3JrM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 05:47:12 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60724 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710Ab3H3JrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 05:47:11 -0400
Date: Fri, 30 Aug 2013 11:46:57 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Low <jason.low2@hp.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        pjt@google.com, preeti@linux.vnet.ibm.com, akpm@linux-foundation.org,
        mgorman@suse.de, riel@redhat.com, aswin@hp.com, scott.norton@hp.com,
        srikar@linux.vnet.ibm.com
Subject: Re: [PATCH v4 2/3] sched: Consider max cost of idle balance per
 sched domain
Message-ID: <20130830094657.GD10002@twins.programming.kicks-ass.net>
References: <1377806736-3752-1-git-send-email-jason.low2@hp.com>
 <1377806736-3752-3-git-send-email-jason.low2@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377806736-3752-3-git-send-email-jason.low2@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 01:05:35PM -0700, Jason Low wrote:
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
> +
> +			curr_cost += domain_cost;
>  		}
>  
>  		interval = msecs_to_jiffies(sd->balance_interval);

I did an s/smp_processor_id()/this_cpu/ on that.
