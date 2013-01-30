Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab3A3NDp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 08:03:45 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:32838 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752382Ab3A3NDn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 08:03:43 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: fli24 <fei.li@intel.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, chuansheng.liu@intel.com
Subject: Re: [PATCH V2] suspend: enable freeze timeout configuration through sys
Date: Wed, 30 Jan 2013 14:09:53 +0100
Message-ID: <2335103.cho0vcBPUK@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc5; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1359527019.26790.3.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
References: <1359428300.3211.3.camel@fli24-HP-Compaq-8100-Elite-CMT-PC> <1359527019.26790.3.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, January 30, 2013 02:23:39 PM fli24 wrote:
> 
> At present, the timeout value for freezing tasks is fixed as 20s,
> which is too long for handheld device usage, especially for mobile
> phone.
> 
> In order to improve user experience, we enable freeze timeout
> configuration through sys, so that we can tune the value easily
> for concrete usage, such as smaller value for handheld device such
> as mobile phone.

As I said, I'd like to know what's the exact problem you need to work around
using this.

Thanks,
Rafael


> Signed-off-by: Liu Chuansheng <chuansheng.liu@intel.com>
> Signed-off-by: Li Fei <fei.li@intel.com>
> ---
>  Documentation/power/freezing-of-tasks.txt |    5 +++++
>  include/linux/freezer.h                   |    5 +++++
>  kernel/power/main.c                       |   27 +++++++++++++++++++++++++++
>  kernel/power/process.c                    |    4 ++--
>  4 files changed, 39 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/power/freezing-of-tasks.txt b/Documentation/power/freezing-of-tasks.txt
> index 6ec291e..85894d8 100644
> --- a/Documentation/power/freezing-of-tasks.txt
> +++ b/Documentation/power/freezing-of-tasks.txt
> @@ -223,3 +223,8 @@ since they ask the freezer to skip freezing this task, since it is anyway
>  only after the entire suspend/hibernation sequence is complete.
>  So, to summarize, use [un]lock_system_sleep() instead of directly using
>  mutex_[un]lock(&pm_mutex). That would prevent freezing failures.
> +
> +V. Miscellaneous
> +/sys/power/pm_freeze_timeout controls how long it will cost at most to freeze
> +all user space processes or all freezable kernel threads, in unit of millisecond.
> +The default value is 20000, with range of unsigned integer.
> diff --git a/include/linux/freezer.h b/include/linux/freezer.h
> index e4238ce..5a24a33 100644
> --- a/include/linux/freezer.h
> +++ b/include/linux/freezer.h
> @@ -13,6 +13,11 @@ extern bool pm_freezing;		/* PM freezing in effect */
>  extern bool pm_nosig_freezing;		/* PM nosig freezing in effect */
>  
>  /*
> + * Timeout for stopping processes
> + */
> +extern unsigned int sys_freeze_process_timeout_msecs;
> +
> +/*
>   * Check if a process has been frozen
>   */
>  static inline bool frozen(struct task_struct *p)
> diff --git a/kernel/power/main.c b/kernel/power/main.c
> index 1c16f91..453ead1 100644
> --- a/kernel/power/main.c
> +++ b/kernel/power/main.c
> @@ -553,6 +553,30 @@ power_attr(pm_trace_dev_match);
>  
>  #endif /* CONFIG_PM_TRACE */
>  
> +#ifdef CONFIG_FREEZER
> +static ssize_t pm_freeze_timeout_show(struct kobject *kobj,
> +				      struct kobj_attribute *attr, char *buf)
> +{
> +	return sprintf(buf, "%u\n", sys_freeze_process_timeout_msecs);
> +}
> +
> +static ssize_t pm_freeze_timeout_store(struct kobject *kobj,
> +				       struct kobj_attribute *attr,
> +				       const char *buf, size_t n)
> +{
> +	unsigned long val;
> +
> +	if (kstrtoul(buf, 10, &val))
> +		return -EINVAL;
> +
> +	sys_freeze_process_timeout_msecs = val;
> +	return n;
> +}
> +
> +power_attr(pm_freeze_timeout);
> +
> +#endif	/* CONFIG_FREEZER*/
> +
>  static struct attribute * g[] = {
>  	&state_attr.attr,
>  #ifdef CONFIG_PM_TRACE
> @@ -576,6 +600,9 @@ static struct attribute * g[] = {
>  	&pm_print_times_attr.attr,
>  #endif
>  #endif
> +#ifdef CONFIG_FREEZER
> +	&pm_freeze_timeout_attr.attr,
> +#endif
>  	NULL,
>  };
>  
> diff --git a/kernel/power/process.c b/kernel/power/process.c
> index d5a258b..ba45a26 100644
> --- a/kernel/power/process.c
> +++ b/kernel/power/process.c
> @@ -21,7 +21,7 @@
>  /* 
>   * Timeout for stopping processes
>   */
> -#define TIMEOUT	(20 * HZ)
> +unsigned int __read_mostly sys_freeze_process_timeout_msecs = 20000;
>  
>  static int try_to_freeze_tasks(bool user_only)
>  {
> @@ -36,7 +36,7 @@ static int try_to_freeze_tasks(bool user_only)
>  
>  	do_gettimeofday(&start);
>  
> -	end_time = jiffies + TIMEOUT;
> +	end_time = jiffies + msecs_to_jiffies(sys_freeze_process_timeout_msecs);
>  
>  	if (!user_only)
>  		freeze_workqueues_begin();
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
