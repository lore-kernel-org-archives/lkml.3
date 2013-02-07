Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759511Ab3BGXXT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 18:23:19 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:60013 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759456Ab3BGXXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 18:23:16 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nathan Zimmer <nzimmer@sgi.com>
Cc: viresh.kumar@linaro.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, cpufreq@vger.kernel.org
Subject: Re: [PATCH v2 linux-next 2/2] cpufreq: Convert the cpufreq_driver_lock to use the rcu
Date: Fri, 08 Feb 2013 00:29:36 +0100
Message-ID: <16615226.2vj4EkkIZJ@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc6; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1360116290-23849-3-git-send-email-nzimmer@sgi.com>
References: <74F10842A85F514CA8D8C487E74474BB2D2F925E@P-EXMB1-DC21.corp.sgi.com> <1360116290-23849-1-git-send-email-nzimmer@sgi.com> <1360116290-23849-3-git-send-email-nzimmer@sgi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 05, 2013 08:04:50 PM Nathan Zimmer wrote:
> In general rwlocks are discourged so we are moving it to use the rcu instead.
> 
> Cc: Viresh Kumar <viresh.kumar@linaro.org>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
> ---
>  drivers/cpufreq/cpufreq.c | 173 +++++++++++++++++++++++++---------------------
>  1 file changed, 96 insertions(+), 77 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index ef25244..a04ceb9 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -39,13 +39,13 @@
>   * level driver of CPUFreq support, and its spinlock. This lock
>   * also protects the cpufreq_cpu_data array.
>   */
> -static struct cpufreq_driver *cpufreq_driver;
> +static struct cpufreq_driver __rcu *cpufreq_driver;
>  static DEFINE_PER_CPU(struct cpufreq_policy *, cpufreq_cpu_data);
>  #ifdef CONFIG_HOTPLUG_CPU
>  /* This one keeps track of the previously set governor of a removed CPU */
>  static DEFINE_PER_CPU(char[CPUFREQ_NAME_LEN], cpufreq_cpu_governor);
>  #endif
> -static DEFINE_RWLOCK(cpufreq_driver_lock);
> +static DEFINE_SPINLOCK(cpufreq_driver_lock);
>  
>  /*
>   * cpu_policy_rwsem is a per CPU reader-writer semaphore designed to cure
> @@ -143,21 +143,20 @@ static DEFINE_MUTEX(cpufreq_governor_mutex);
>  static struct cpufreq_policy *__cpufreq_cpu_get(unsigned int cpu, bool sysfs)
>  {
>  	struct cpufreq_policy *data;
> -	unsigned long flags;
> +	struct cpufreq_driver *driver;
>  
>  	if (cpu >= nr_cpu_ids)
>  		goto err_out;
>  
>  	/* get the cpufreq driver */
> -	read_lock_irqsave(&cpufreq_driver_lock, flags);
> -
> -	if (!cpufreq_driver)
> +	rcu_read_lock();
> +	driver = rcu_dereference(cpufreq_driver);
> +	if (!driver)
>  		goto err_out_unlock;
>  
> -	if (!try_module_get(cpufreq_driver->owner))
> +	if (!try_module_get(driver->owner))
>  		goto err_out_unlock;
>  
> -
>  	/* get the CPU */
>  	data = per_cpu(cpufreq_cpu_data, cpu);
>  
> @@ -167,13 +166,13 @@ static struct cpufreq_policy *__cpufreq_cpu_get(unsigned int cpu, bool sysfs)
>  	if (!sysfs && !kobject_get(&data->kobj))
>  		goto err_out_put_module;
>  
> -	read_unlock_irqrestore(&cpufreq_driver_lock, flags);
> +	rcu_read_unlock();
>  	return data;
>  
>  err_out_put_module:
> -	module_put(cpufreq_driver->owner);
> +	module_put(driver->owner);
>  err_out_unlock:
> -	read_unlock_irqrestore(&cpufreq_driver_lock, flags);
> +	rcu_read_unlock();
>  err_out:
>  	return NULL;
>  }
> @@ -196,7 +195,7 @@ static void __cpufreq_cpu_put(struct cpufreq_policy *data, bool sysfs)
>  {
>  	if (!sysfs)
>  		kobject_put(&data->kobj);
> -	module_put(cpufreq_driver->owner);
> +	module_put(rcu_dereference(cpufreq_driver)->owner);
>  }
>  
>  void cpufreq_cpu_put(struct cpufreq_policy *data)
> @@ -267,13 +266,16 @@ static inline void adjust_jiffies(unsigned long val, struct cpufreq_freqs *ci)
>  void cpufreq_notify_transition(struct cpufreq_freqs *freqs, unsigned int state)
>  {
>  	struct cpufreq_policy *policy;
> +	struct cpufreq_driver *driver;
>  
>  	BUG_ON(irqs_disabled());
>  
>  	if (cpufreq_disabled())
>  		return;
>  
> -	freqs->flags = cpufreq_driver->flags;
> +	driver = rcu_dereference(cpufreq_driver);

Pardon me for not asking that question earlier, but what sense does it make
to use rcu_dereference() outside of an rcu_read_lock()/rcu_read_unlock()
scope?  Here and in the other places?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
