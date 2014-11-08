Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531AbaKHBj1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 20:39:27 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:51844 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752442AbaKHBj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 20:39:26 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, robert.schoene@tu-dresden.de,
        sboyd@codeaurora.org, Viresh Kumar <viresh.kumar@linaro.org>,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH 5/5] cpufreq, add BUG() messages in critical paths to aid debugging failures
Date: Sat, 08 Nov 2014 03:00:15 +0100
Message-ID: <1908314.5SSPFg5MrY@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1415199239-19019-6-git-send-email-prarit@redhat.com>
References: <1415199239-19019-1-git-send-email-prarit@redhat.com> <1415199239-19019-6-git-send-email-prarit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 05, 2014 09:53:59 AM Prarit Bhargava wrote:
> Add some additional debug to capture failures in the locking scheme for
> cpufreq.  Instead of just a NULL pointer, these warnings will capture failure
> points if the locking scheme for cpufreq is broken.
> 
> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> Cc: Viresh Kumar <viresh.kumar@linaro.org>
> Cc: linux-pm@vger.kernel.org
> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
> ---
>  drivers/cpufreq/cpufreq_governor.c |   32 +++++++++++++++++++++++++++-----
>  1 file changed, 27 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
> index b1ee597..f158882 100644
> --- a/drivers/cpufreq/cpufreq_governor.c
> +++ b/drivers/cpufreq/cpufreq_governor.c
> @@ -161,9 +161,18 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
>  EXPORT_SYMBOL_GPL(dbs_check_cpu);
>  
>  static inline void __gov_queue_work(int cpu, struct dbs_data *dbs_data,
> -		unsigned int delay)
> +				    unsigned int delay,
> +				    struct cpufreq_policy *policy)
>  {
> -	struct cpu_dbs_common_info *cdbs = dbs_data->cdata->get_cpu_cdbs(cpu);
> +	struct cpu_dbs_common_info *cdbs;
> +
> +	if (!dbs_data->cdata) {
> +		pr_emerg("common_dbs_data is NULL for %s but initialized = %d",
> +			 policy->governor->name,
> +			 atomic_read(&policy->governor->initialized));
> +		BUG();

Is it necessary to crash the kernel here?

> +	}
> +	cdbs = dbs_data->cdata->get_cpu_cdbs(cpu);
>  
>  	mod_delayed_work_on(cpu, system_wq, &cdbs->work, delay);
>  }
> @@ -185,10 +194,11 @@ void gov_queue_work(struct dbs_data *dbs_data, struct cpufreq_policy *policy,
>  		 * those works are canceled during CPU_DOWN_PREPARE so they
>  		 * can't possibly run on any other CPU.
>  		 */
> -		__gov_queue_work(raw_smp_processor_id(), dbs_data, delay);
> +		__gov_queue_work(raw_smp_processor_id(), dbs_data, delay,
> +				 policy);
>  	} else {
>  		for_each_cpu(i, policy->cpus)
> -			__gov_queue_work(i, dbs_data, delay);
> +			__gov_queue_work(i, dbs_data, delay, policy);
>  	}
>  
>  out_unlock:
> @@ -258,7 +268,13 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
>  	else
>  		dbs_data = cdata->gdbs_data;
>  
> -	WARN_ON(!dbs_data && (event != CPUFREQ_GOV_POLICY_INIT));
> +	if (!dbs_data && (event != CPUFREQ_GOV_POLICY_INIT)) {
> +		pr_emerg("governor_data is NULL but governor %s is initialized = %d [governor_enabled = %d event = %u]\n",
> +			 policy->governor->name,
> +			 atomic_read(&policy->governor->initialized),
> +			 policy->governor_enabled, event);
> +		BUG();

And here?

> +	}
>  
>  	switch (event) {
>  	case CPUFREQ_GOV_POLICY_INIT:
> @@ -329,6 +345,12 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
>  	case CPUFREQ_GOV_POLICY_EXIT:
>  		mutex_lock(&dbs_data->usage_count_mutex);
>  		if (atomic_dec_and_test(&dbs_data->usage_count)) {
> +			if (atomic_read(&policy->governor->initialized) > 1) {
> +				pr_emerg("Removing governor %s but initialized = %d, dbs_data->usage_count = 0\n",
> +					 policy->governor->name,
> +				   atomic_read(&policy->governor->initialized));
> +				BUG();
> +			}
>  			sysfs_remove_group(get_governor_parent_kobj(policy),
>  					get_sysfs_attr(dbs_data));
>  
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
