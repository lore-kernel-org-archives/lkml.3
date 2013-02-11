Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168Ab3BKRNg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 12:13:36 -0500
Received: from relay3.sgi.com ([192.48.152.1]:59160 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757740Ab3BKRNd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 12:13:33 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: "viresh.kumar@linaro.org" <viresh.kumar@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>
Subject: RE: [PATCH v2 linux-next 2/2] cpufreq: Convert the
 cpufreq_driver_lock to use the rcu
Thread-Topic: [PATCH v2 linux-next 2/2] cpufreq: Convert the
 cpufreq_driver_lock to use the rcu
Thread-Index: AQHOBA5rBQ8ceIvOaEijZLr8F17MgphvcnMAgAVr1KY=
Date: Mon, 11 Feb 2013 17:13:30 +0000
Message-ID: <74F10842A85F514CA8D8C487E74474BB2D30DC9E@P-EXMB1-DC21.corp.sgi.com>
References: <74F10842A85F514CA8D8C487E74474BB2D2F925E@P-EXMB1-DC21.corp.sgi.com>
 <1360116290-23849-1-git-send-email-nzimmer@sgi.com>
 <1360116290-23849-3-git-send-email-nzimmer@sgi.com>,<16615226.2vj4EkkIZJ@vostro.rjw.lan>
In-Reply-To: <16615226.2vj4EkkIZJ@vostro.rjw.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [198.149.23.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are some spots that I need to give a much deeper review, cpufreq_register_driver for example.

But I believe 
> @@ -196,7 +195,7 @@ static void __cpufreq_cpu_put(struct cpufreq_policy *data, bool sysfs)
>  {
>       if (!sysfs)
>               kobject_put(&data->kobj);
> -     module_put(cpufreq_driver->owner);
> +     module_put(rcu_dereference(cpufreq_driver)->owner);
>  }
would be ok.  In the documentation whatisRCU.txt they give a very similar example.



________________________________________
From: Rafael J. Wysocki [rjw@sisk.pl]
Sent: Thursday, February 07, 2013 5:29 PM
To: Nathan Zimmer
Cc: viresh.kumar@linaro.org; linux-kernel@vger.kernel.org; linux-pm@vger.kernel.org; cpufreq@vger.kernel.org
Subject: Re: [PATCH v2 linux-next 2/2] cpufreq: Convert the cpufreq_driver_lock to use the rcu

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
>       struct cpufreq_policy *data;
> -     unsigned long flags;
> +     struct cpufreq_driver *driver;
>
>       if (cpu >= nr_cpu_ids)
>               goto err_out;
>
>       /* get the cpufreq driver */
> -     read_lock_irqsave(&cpufreq_driver_lock, flags);
> -
> -     if (!cpufreq_driver)
> +     rcu_read_lock();
> +     driver = rcu_dereference(cpufreq_driver);
> +     if (!driver)
>               goto err_out_unlock;
>
> -     if (!try_module_get(cpufreq_driver->owner))
> +     if (!try_module_get(driver->owner))
>               goto err_out_unlock;
>
> -
>       /* get the CPU */
>       data = per_cpu(cpufreq_cpu_data, cpu);
>
> @@ -167,13 +166,13 @@ static struct cpufreq_policy *__cpufreq_cpu_get(unsigned int cpu, bool sysfs)
>       if (!sysfs && !kobject_get(&data->kobj))
>               goto err_out_put_module;
>
> -     read_unlock_irqrestore(&cpufreq_driver_lock, flags);
> +     rcu_read_unlock();
>       return data;
>
>  err_out_put_module:
> -     module_put(cpufreq_driver->owner);
> +     module_put(driver->owner);
>  err_out_unlock:
> -     read_unlock_irqrestore(&cpufreq_driver_lock, flags);
> +     rcu_read_unlock();
>  err_out:
>       return NULL;
>  }
> @@ -196,7 +195,7 @@ static void __cpufreq_cpu_put(struct cpufreq_policy *data, bool sysfs)
>  {
>       if (!sysfs)
>               kobject_put(&data->kobj);
> -     module_put(cpufreq_driver->owner);
> +     module_put(rcu_dereference(cpufreq_driver)->owner);
>  }
>
>  void cpufreq_cpu_put(struct cpufreq_policy *data)
> @@ -267,13 +266,16 @@ static inline void adjust_jiffies(unsigned long val, struct cpufreq_freqs *ci)
>  void cpufreq_notify_transition(struct cpufreq_freqs *freqs, unsigned int state)
>  {
>       struct cpufreq_policy *policy;
> +     struct cpufreq_driver *driver;
>
>       BUG_ON(irqs_disabled());
>
>       if (cpufreq_disabled())
>               return;
>
> -     freqs->flags = cpufreq_driver->flags;
> +     driver = rcu_dereference(cpufreq_driver);

Pardon me for not asking that question earlier, but what sense does it make
to use rcu_dereference() outside of an rcu_read_lock()/rcu_read_unlock()
scope?  Here and in the other places?

Rafael


--
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.