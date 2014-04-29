Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374AbaD2NKH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 09:10:07 -0400
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:57791 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400AbaD2NKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 09:10:03 -0400
Date: Tue, 29 Apr 2014 16:09:59 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
cc: rjw@rjwysocki.net, viresh.kumar@linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] cpufreq: Catch double invocations of
 cpufreq_freq_transition_begin/end
In-Reply-To: <20140429130506.7052.54268.stgit@srivatsabhat.in.ibm.com>
Message-ID: <alpine.SOC.1.00.1404291609220.3349@math.ut.ee>
References: <20140429130506.7052.54268.stgit@srivatsabhat.in.ibm.com>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> ---
> 
> v2: Removed the coverage of ASYNC_NOTIFICATION drivers, in order to avoid
> false-positives.

I am confused - on top of what patches should I test it?



> 
>  drivers/cpufreq/cpufreq.c |    7 +++++++
>  include/linux/cpufreq.h   |    1 +
>  2 files changed, 8 insertions(+)
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index abda660..afcac67 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -354,6 +354,11 @@ static void cpufreq_notify_post_transition(struct cpufreq_policy *policy,
>  void cpufreq_freq_transition_begin(struct cpufreq_policy *policy,
>  		struct cpufreq_freqs *freqs)
>  {
> +
> +	/* Catch double invocations of _begin() which lead to self-deadlock */
> +	WARN_ON(!(cpufreq_driver->flags & CPUFREQ_ASYNC_NOTIFICATION)
> +				&& current == policy->transition_task);
> +
>  wait:
>  	wait_event(policy->transition_wait, !policy->transition_ongoing);
>  
> @@ -365,6 +370,7 @@ wait:
>  	}
>  
>  	policy->transition_ongoing = true;
> +	policy->transition_task = current;
>  
>  	spin_unlock(&policy->transition_lock);
>  
> @@ -381,6 +387,7 @@ void cpufreq_freq_transition_end(struct cpufreq_policy *policy,
>  	cpufreq_notify_post_transition(policy, freqs, transition_failed);
>  
>  	policy->transition_ongoing = false;
> +	policy->transition_task = NULL;
>  
>  	wake_up(&policy->transition_wait);
>  }
> diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
> index 5ae5100..8f44d79 100644
> --- a/include/linux/cpufreq.h
> +++ b/include/linux/cpufreq.h
> @@ -110,6 +110,7 @@ struct cpufreq_policy {
>  	bool			transition_ongoing; /* Tracks transition status */
>  	spinlock_t		transition_lock;
>  	wait_queue_head_t	transition_wait;
> +	struct task_struct	*transition_task; /* Task which is doing the transition */
>  };
>  
>  /* Only for ACPI */
> 

-- 
Meelis Roos (mroos@linux.ee)
