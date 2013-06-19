Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934991Ab3FSSBO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 14:01:14 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:61882 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933869Ab3FSSBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 14:01:11 -0400
Message-ID: <51C1F1E3.9010902@gmail.com>
Date: Wed, 19 Jun 2013 11:01:07 -0700
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Lukasz Majewski <l.majewski@samsung.com>
CC: Viresh Kumar <viresh.kumar@linaro.org>, "Rafael J. Wysocky" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>, dirk.brandewie@gmail.com
Subject: Re: [PATCH v4 5/7] cpufreq: Calculate number of busy CPUs
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com> <1371661969-7660-1-git-send-email-l.majewski@samsung.com> <1371661969-7660-6-git-send-email-l.majewski@samsung.com>
In-Reply-To: <1371661969-7660-6-git-send-email-l.majewski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2013 10:12 AM, Lukasz Majewski wrote:
> In the core governor code, per cpu load value is calculated. This patch
> uses it to mark processor as a "busy" one, when load value is higher than
> 90%.
>
> New cpufreq sysfs attribute is created (busy_cpus). It is read only
> and provides information about number of actually busy CPU.
>

What is the intended use of this interface?

For drivers that have internal governors it will be misleading/wrong

--Dirk
> Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
>
> Changes for v4:
> - New patch
> ---
>   drivers/cpufreq/cpufreq.c          |   31 ++++++++++++++++++++++++++++++-
>   drivers/cpufreq/cpufreq_governor.c |    1 +
>   include/linux/cpufreq.h            |    3 +++
>   3 files changed, 34 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 9141d33..f785273 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -48,6 +48,7 @@ static DEFINE_PER_CPU(char[CPUFREQ_NAME_LEN], cpufreq_cpu_governor);
>   #endif
>   static DEFINE_RWLOCK(cpufreq_driver_lock);
>   static LIST_HEAD(cpufreq_policy_list);
> +static cpumask_t cpufreq_busy_cpus;
>
>   /*
>    * cpu_policy_rwsem is a per CPU reader-writer semaphore designed to cure
> @@ -317,6 +318,13 @@ EXPORT_SYMBOL_GPL(cpufreq_notify_transition);
>   /*********************************************************************
>    *                          SYSFS INTERFACE                          *
>    *********************************************************************/
> +ssize_t show_busy_cpus(struct kobject *kobj,
> +				 struct attribute *attr, char *buf)
> +{
> +	return sprintf(buf, "%d\n", cpufreq_num_busy_cpu());
> +}
> +define_one_global_ro(busy_cpus);
> +
>   ssize_t show_boost(struct kobject *kobj,
>   				 struct attribute *attr, char *buf)
>   {
> @@ -1980,6 +1988,17 @@ int cpufreq_boost_enabled(void)
>   	return boost_enabled;
>   }
>
> +int cpufreq_num_busy_cpu(void)
> +{
> +	return cpumask_weight(&cpufreq_busy_cpus);
> +}
> +
> +void cpufreq_set_busy_cpu(int cpu, int val)
> +{
> +	val ? cpumask_set_cpu(cpu, &cpufreq_busy_cpus) :
> +		cpumask_clear_cpu(cpu, &cpufreq_busy_cpus);
> +}
> +
>   /*********************************************************************
>    *               REGISTER / UNREGISTER CPUFREQ DRIVER                *
>    *********************************************************************/
> @@ -2019,6 +2038,13 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
>   	cpufreq_driver = driver_data;
>   	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
>
> +	ret = cpufreq_sysfs_create_file(&(busy_cpus.attr));
> +	if (ret) {
> +		pr_err("%s: cannot register global busy_cpus sysfs file\n",
> +		       __func__);
> +		goto err_null_driver;
> +	}
> +
>   	if (!cpufreq_driver->boost_supported)
>   		boost.attr.mode = 0444;
>
> @@ -2026,7 +2052,7 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
>   	if (ret) {
>   		pr_err("%s: cannot register global boost sysfs file\n",
>   		       __func__);
> -		goto err_null_driver;
> +		goto err_busy_idle_unreg;
>   	}
>
>   	ret = subsys_interface_register(&cpufreq_interface);
> @@ -2058,6 +2084,8 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
>   	return 0;
>   err_if_unreg:
>   	subsys_interface_unregister(&cpufreq_interface);
> +err_busy_idle_unreg:
> +	cpufreq_sysfs_remove_file(&(busy_cpus.attr));
>   err_null_driver:
>   	write_lock_irqsave(&cpufreq_driver_lock, flags);
>   	cpufreq_driver = NULL;
> @@ -2086,6 +2114,7 @@ int cpufreq_unregister_driver(struct cpufreq_driver *driver)
>
>   	subsys_interface_unregister(&cpufreq_interface);
>
> +	cpufreq_sysfs_remove_file(&(busy_cpus.attr));
>   	cpufreq_sysfs_remove_file(&(boost.attr));
>   	unregister_hotcpu_notifier(&cpufreq_cpu_notifier);
>
> diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
> index 077cea7..3402533 100644
> --- a/drivers/cpufreq/cpufreq_governor.c
> +++ b/drivers/cpufreq/cpufreq_governor.c
> @@ -148,6 +148,7 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
>   			continue;
>
>   		load = 100 * (wall_time - idle_time) / wall_time;
> +		cpufreq_set_busy_cpu(j, load > 90 ? 1 : 0);
>
>   		if (dbs_data->cdata->governor == GOV_ONDEMAND) {
>   			int freq_avg = __cpufreq_driver_getavg(policy, j);
> diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
> index 4783c4c..536abfc 100644
> --- a/include/linux/cpufreq.h
> +++ b/include/linux/cpufreq.h
> @@ -436,6 +436,9 @@ int cpufreq_frequency_table_target(struct cpufreq_policy *policy,
>   int cpufreq_boost_trigger_state(int state);
>   int cpufreq_boost_supported(void);
>   int cpufreq_boost_enabled(void);
> +
> +void cpufreq_set_busy_cpu(int cpu, int val);
> +int cpufreq_num_busy_cpu(void);
>   /* the following 3 funtions are for cpufreq core use only */
>   struct cpufreq_frequency_table *cpufreq_frequency_get_table(unsigned int cpu);
>
>

