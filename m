Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712Ab3GNPq4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 11:46:56 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:42233 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752497Ab3GNPqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 11:46:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@alien8.de>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [LOCKDEP] cpufreq: possible circular locking dependency detected
Date: Sun, 14 Jul 2013 17:56:45 +0200
Message-ID: <1575632.O15l1yqZOt@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <51DE1BE1.3090707@linux.vnet.ibm.com>
References: <20130625211544.GA2270@swordfish> <20130710231305.GA4046@swordfish> <51DE1BE1.3090707@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 11, 2013 10:43:45 AM Michael Wang wrote:
> Hi, Sergey
> 
> On 07/11/2013 07:13 AM, Sergey Senozhatsky wrote:
> [snip]
> > 
> > 
> > Please kindly review the following patch.
> > 
> > 
> > 
> > Remove cpu device only upon succesful cpu down on CPU_POST_DEAD event,
> > so we can kill off CPU_DOWN_FAILED case and eliminate potential extra
> > remove/add path:
> > 	
> > 	hotplug lock
> > 		CPU_DOWN_PREPARE: __cpufreq_remove_dev
> > 		CPU_DOWN_FAILED: cpufreq_add_dev
> > 	hotplug unlock
> > 
> > Since cpu still present on CPU_DEAD event, cpu stats table should be
> > kept longer and removed later on CPU_POST_DEAD as well.
> > 
> > Because CPU_POST_DEAD action performed with hotplug lock released, CPU_DOWN
> > might block existing gov_queue_work() user (blocked on get_online_cpus())
> > and unblock it with one of policy->cpus offlined, thus cpu_is_offline()
> > check is performed in __gov_queue_work().
> > 
> > Besides, existing gov_queue_work() hotplug guard extended to protect all
> > __gov_queue_work() calls: for both all_cpus and !all_cpus cases.
> > 
> > CPUFREQ_GOV_START performs direct __gov_queue_work() call because hotplug
> > lock already held there, opposing to previous gov_queue_work() and nested
> > get/put_online_cpus().
> 
> Nice to know you have some idea on solving the issue ;-)
> 
> I'm not sure whether I catch the idea, but seems like you are trying
> to re-organize the timing of add/remove device.
> 
> I'm sure that we have more than one way to solve the issues, but what
> we need is the cure of root...
> 
> As Srivatsa discovered, the root issue may be:
> 	gov_cancel_work() failed to stop all the work after it's return.
> 
> And Viresh also confirmed that this is not by-designed.
> 
> Which means gov_queue_work() invoked by od_dbs_timer() is supposed to
> never happen after CPUFREQ_GOV_STOP notify, the whole policy should
> stop working at that time.
> 
> But it failed to, and the work concurrent with cpu dying caused the
> first problem.
> 
> Thus I think we should focus on this and suggested below fix, I'd like
> to know your opinions :)
> 
> Regards,
> Michael Wang
> 
> diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
> index dc9b72e..a64b544 100644
> --- a/drivers/cpufreq/cpufreq_governor.c
> +++ b/drivers/cpufreq/cpufreq_governor.c
> @@ -178,13 +178,14 @@ void gov_queue_work(struct dbs_data *dbs_data, struct cpufreq_policy *policy,
>  {
>  	int i;
>  
> +	if (dbs_data->queue_stop)
> +		return;
> +
>  	if (!all_cpus) {
>  		__gov_queue_work(smp_processor_id(), dbs_data, delay);
>  	} else {
> -		get_online_cpus();
>  		for_each_cpu(i, policy->cpus)
>  			__gov_queue_work(i, dbs_data, delay);
> -		put_online_cpus();
>  	}
>  }
>  EXPORT_SYMBOL_GPL(gov_queue_work);
> @@ -193,12 +194,27 @@ static inline void gov_cancel_work(struct dbs_data *dbs_data,
>  		struct cpufreq_policy *policy)
>  {
>  	struct cpu_dbs_common_info *cdbs;
> -	int i;
> +	int i, round = 2;
>  
> +	dbs_data->queue_stop = 1;
> +redo:
> +	round--;
>  	for_each_cpu(i, policy->cpus) {
>  		cdbs = dbs_data->cdata->get_cpu_cdbs(i);
>  		cancel_delayed_work_sync(&cdbs->work);
>  	}
> +
> +	/*
> +	 * Since there is no lock to prvent re-queue the
> +	 * cancelled work, some early cancelled work might
> +	 * have been queued again by later cancelled work.
> +	 *
> +	 * Flush the work again with dbs_data->queue_stop
> +	 * enabled, this time there will be no survivors.
> +	 */
> +	if (round)
> +		goto redo;

Well, what about doing:

	for (round = 2; round; round--)
	  	for_each_cpu(i, policy->cpus) {
	  		cdbs = dbs_data->cdata->get_cpu_cdbs(i);
	  		cancel_delayed_work_sync(&cdbs->work);
	  	}

instead?

> +	dbs_data->queue_stop = 0;
>  }
>  
>  /* Will return if we need to evaluate cpu load again or not */
> diff --git a/drivers/cpufreq/cpufreq_governor.h b/drivers/cpufreq/cpufreq_governor.h
> index e16a961..9116135 100644
> --- a/drivers/cpufreq/cpufreq_governor.h
> +++ b/drivers/cpufreq/cpufreq_governor.h
> @@ -213,6 +213,7 @@ struct dbs_data {
>  	unsigned int min_sampling_rate;
>  	int usage_count;
>  	void *tuners;
> +	int queue_stop;
>  
>  	/* dbs_mutex protects dbs_enable in governor start/stop */
>  	struct mutex mutex;
> 


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
