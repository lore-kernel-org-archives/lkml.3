Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759222Ab3EBNVr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 09:21:47 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48896 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757786Ab3EBNVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 09:21:45 -0400
Date: Thu, 2 May 2013 15:19:55 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alex Shi <alex.shi@intel.com>
Cc: mingo@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org,
        arjan@linux.intel.com, bp@alien8.de, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, len.brown@intel.com,
        rafael.j.wysocki@intel.com, jkosina@suse.cz, clark.williams@gmail.com,
        tony.luck@intel.com, keescook@chromium.org, mgorman@suse.de,
        riel@redhat.com
Subject: Re: [PATCH v4 6/6] sched: consider runnable load average in
 effective_load
Message-ID: <20130502131954.GH13837@dyad.programming.kicks-ass.net>
References: <1367040344-14485-1-git-send-email-alex.shi@intel.com>
 <1367040344-14485-7-git-send-email-alex.shi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367040344-14485-7-git-send-email-alex.shi@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -3120,6 +3124,7 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
>  	struct task_group *tg;
>  	unsigned long weight;
>  	int balanced;
> +	int runnable_avg;
>  
>  	idx	  = sd->wake_idx;
>  	this_cpu  = smp_processor_id();
> @@ -3135,13 +3140,19 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
>  	if (sync) {
>  		tg = task_group(current);
>  		weight = current->se.load.weight;
> +		runnable_avg = current->se.avg.runnable_avg_sum * NICE_0_LOAD
> +				/ (current->se.avg.runnable_avg_period + 1);
>  
> -		this_load += effective_load(tg, this_cpu, -weight, -weight);
> -		load += effective_load(tg, prev_cpu, 0, -weight);
> +		this_load += effective_load(tg, this_cpu, -weight, -weight)
> +				* runnable_avg >> NICE_0_SHIFT;
> +		load += effective_load(tg, prev_cpu, 0, -weight)
> +				* runnable_avg >> NICE_0_SHIFT;
>  	}


I'm fairly sure this is wrong; but I haven't bothered to take pencil to paper.

I think you'll need to insert the runnable avg load and make sure
effective_load() uses the right sums itself.
