Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164AbaAWIl2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 03:41:28 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:42906 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbaAWIlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 03:41:25 -0500
Message-ID: <52E0D46E.6040208@linux.vnet.ibm.com>
Date: Thu, 23 Jan 2014 14:05:58 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: rjw@rjwysocki.net, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>
Subject: Re: [PATCH v3] suspend: make sync() on suspend-to-RAM optional
References: <e616943c3b6e35c6e9bf192d66bef96bc6cdf75c.1390464544.git.len.brown@intel.com>
In-Reply-To: <e616943c3b6e35c6e9bf192d66bef96bc6cdf75c.1390464544.git.len.brown@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14012308-0260-0000-0000-000004404163
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2014 01:40 PM, Len Brown wrote:
> From: Len Brown <len.brown@intel.com>
> 
> Linux suspend-to-RAM was unreliable when first developed,
> and so sys_sync() was invoked inside the kernel at the
> start of every suspend flow.
> 
> Today, many devices invoke suspend with
> high reliability and high frequency.
> They may not want to be forced to pay
> the performance cost of sync() on every suspend.
> 
> So here we make the file system sync() optional.
> De-select CONFIG_SUSPEND_FS_SYNC to delete the call.
> Keep CONFIG_SUSPEND_FS_SYNC keept the call, and also
> includes the new sysfs attribte,
> /sys/power/suspend_fs_sync
> which can be cleared to disable the file-system sync.
> 
> As we have had this call for a long time,
> the default remains to keep the call, and to
> invoke it on every suspend.
> 
> Signed-off-by: Len Brown <len.brown@intel.com>

Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Regards,
Srivatsa S. Bhat

> ---
>  kernel/power/Kconfig   | 11 +++++++++++
>  kernel/power/main.c    | 33 +++++++++++++++++++++++++++++++++
>  kernel/power/power.h   |  1 +
>  kernel/power/suspend.c | 10 +++++++---
>  4 files changed, 52 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
> index 2fac9cc..244c2d9 100644
> --- a/kernel/power/Kconfig
> +++ b/kernel/power/Kconfig
> @@ -102,6 +102,17 @@ config PM_SLEEP_SMP
>  	depends on PM_SLEEP
>  	select HOTPLUG_CPU
> 
> +config SUSPEND_FS_SYNC
> +	bool "Suspend to RAM includes file-system sync()"
> +	default y
> +	depends on SUSPEND
> +	---help---
> +	Include a file system sync() at the start of every suspend to RAM flow.
> +	Disable this option to exclude that capability.
> +
> +	If included, the sync can still be skipped
> +	by clearing /sys/power/suspend_fs_sync.
> +
>  config PM_AUTOSLEEP
>  	bool "Opportunistic sleep"
>  	depends on PM_SLEEP
> diff --git a/kernel/power/main.c b/kernel/power/main.c
> index 1d1bf63..bce7807 100644
> --- a/kernel/power/main.c
> +++ b/kernel/power/main.c
> @@ -71,6 +71,36 @@ static ssize_t pm_async_store(struct kobject *kobj, struct kobj_attribute *attr,
> 
>  power_attr(pm_async);
> 
> +#ifdef CONFIG_SUSPEND_FS_SYNC
> +
> +/* If set, sync file systems at start of suspend flow */
> +int suspend_fs_sync_enabled = 1;
> +
> +static ssize_t suspend_fs_sync_show(struct kobject *kobj, struct kobj_attribute *attr,
> +			     char *buf)
> +{
> +	return sprintf(buf, "%d\n", suspend_fs_sync_enabled);
> +}
> +
> +static ssize_t suspend_fs_sync_store(struct kobject *kobj, struct kobj_attribute *attr,
> +			      const char *buf, size_t n)
> +{
> +	unsigned long val;
> +
> +	if (kstrtoul(buf, 10, &val))
> +		return -EINVAL;
> +
> +	if (val > 1)
> +		return -EINVAL;
> +
> +	suspend_fs_sync_enabled = val;
> +	return n;
> +}
> +
> +power_attr(suspend_fs_sync);
> +
> +#endif /* CONFIG_SUSPEND_FS_SYNC */
> +
>  #ifdef CONFIG_PM_DEBUG
>  int pm_test_level = TEST_NONE;
> 
> @@ -592,6 +622,9 @@ static struct attribute * g[] = {
>  #ifdef CONFIG_PM_SLEEP
>  	&pm_async_attr.attr,
>  	&wakeup_count_attr.attr,
> +#ifdef CONFIG_SUSPEND_FS_SYNC
> +	&suspend_fs_sync_attr.attr,
> +#endif
>  #ifdef CONFIG_PM_AUTOSLEEP
>  	&autosleep_attr.attr,
>  #endif
> diff --git a/kernel/power/power.h b/kernel/power/power.h
> index 7d4b7ff..3d86f09 100644
> --- a/kernel/power/power.h
> +++ b/kernel/power/power.h
> @@ -200,6 +200,7 @@ static inline void suspend_test_finish(const char *label) {}
>  #ifdef CONFIG_PM_SLEEP
>  /* kernel/power/main.c */
>  extern int pm_notifier_call_chain(unsigned long val);
> +extern int suspend_fs_sync_enabled;
>  #endif
> 
>  #ifdef CONFIG_HIGHMEM
> diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
> index 62ee437..e7eb2ba 100644
> --- a/kernel/power/suspend.c
> +++ b/kernel/power/suspend.c
> @@ -333,9 +333,13 @@ static int enter_state(suspend_state_t state)
>  	if (state == PM_SUSPEND_FREEZE)
>  		freeze_begin();
> 
> -	printk(KERN_INFO "PM: Syncing filesystems ... ");
> -	sys_sync();
> -	printk("done.\n");
> +#ifdef CONFIG_SUSPEND_FS_SYNC
> +	if (suspend_fs_sync_enabled) {
> +		printk(KERN_INFO "PM: Syncing filesystems ... ");
> +		sys_sync();
> +		printk("done.\n");
> +	}
> +#endif /* CONFIG_SUSPEND_FS_SYNC */
> 
>  	pr_debug("PM: Preparing system for %s sleep\n", pm_states[state]);
>  	error = suspend_prepare(state);
> 

