Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706AbaJDOOu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 10:14:50 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:49779 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbaJDOOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 10:14:49 -0400
Message-ID: <54300232.8020809@gmail.com>
Date: Sat, 04 Oct 2014 22:20:34 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: rjw@rjwysocki.net, pavel@ucw.cz, len.brown@intel.com,
        gregkh@linuxfoundation.org, ulf.hansson@linaro.org, khilman@linaro.org,
        geert+renesas@glider.be, tomasz.figa@gmail.com, richard@nod.at
CC: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: base: power: domain: Use 'pm_cpu_data' instead
 of 'cpu_data' for compiling break
References: <54300206.3020206@gmail.com>
In-Reply-To: <54300206.3020206@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After this patch, our um can pass allmodconfig compiling.

Thanks.

On 10/4/14 22:19, Chen Gang wrote:
> 'cpu_data' is too common to be already used by some architectures (e.g.
> um, m32r, and mn10300), so need use 'pm_cpu_data' instead of, or cause
> compiling break. The related error (with allmodconfig under um):
> 
>     CC      drivers/base/platform.o
>   In file included from ./arch/x86/um/asm/processor.h:31:0,
>                    from ./arch/um/include/asm/uaccess.h:16,
>                    from ./arch/um/include/asm/thread_info.h:13,
>                    from include/linux/thread_info.h:54,
>                    from include/asm-generic/current.h:4,
>                    from arch/um/include/generated/asm/current.h:1,
>                    from include/linux/mutex.h:13,
>                    from include/linux/kernfs.h:13,
>                    from include/linux/sysfs.h:15,
>                    from include/linux/kobject.h:21,
>                    from include/linux/device.h:17,
>                    from include/linux/platform_device.h:14,
>                    from drivers/base/platform.c:14:
>   ./arch/um/include/asm/processor-generic.h:107:19: error: expected identifier or '(' before '&' token
>    #define cpu_data (&boot_cpu_data)
>                      ^
>   include/linux/pm_domain.h:74:23: note: in expansion of macro 'cpu_data'
>     struct gpd_cpu_data *cpu_data;
>                        ^
> 
> Also need notice about 80 columns boundary.
> 
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>  drivers/base/power/domain.c | 54 ++++++++++++++++++++++-----------------------
>  include/linux/pm_domain.h   |  2 +-
>  2 files changed, 28 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
> index 18cc68d..d8d2739 100644
> --- a/drivers/base/power/domain.c
> +++ b/drivers/base/power/domain.c
> @@ -142,13 +142,13 @@ static void genpd_recalc_cpu_exit_latency(struct generic_pm_domain *genpd)
>  {
>  	s64 usecs64;
>  
> -	if (!genpd->cpu_data)
> +	if (!genpd->pm_cpu_data)
>  		return;
>  
>  	usecs64 = genpd->power_on_latency_ns;
>  	do_div(usecs64, NSEC_PER_USEC);
> -	usecs64 += genpd->cpu_data->saved_exit_latency;
> -	genpd->cpu_data->idle_state->exit_latency = usecs64;
> +	usecs64 += genpd->pm_cpu_data->saved_exit_latency;
> +	genpd->pm_cpu_data->idle_state->exit_latency = usecs64;
>  }
>  
>  /**
> @@ -188,9 +188,9 @@ static int __pm_genpd_poweron(struct generic_pm_domain *genpd)
>  		return 0;
>  	}
>  
> -	if (genpd->cpu_data) {
> +	if (genpd->pm_cpu_data) {
>  		cpuidle_pause_and_lock();
> -		genpd->cpu_data->idle_state->disabled = true;
> +		genpd->pm_cpu_data->idle_state->disabled = true;
>  		cpuidle_resume_and_unlock();
>  		goto out;
>  	}
> @@ -513,17 +513,17 @@ static int pm_genpd_poweroff(struct generic_pm_domain *genpd)
>  		}
>  	}
>  
> -	if (genpd->cpu_data) {
> +	if (genpd->pm_cpu_data) {
>  		/*
> -		 * If cpu_data is set, cpuidle should turn the domain off when
> -		 * the CPU in it is idle.  In that case we don't decrement the
> -		 * subdomain counts of the master domains, so that power is not
> -		 * removed from the current domain prematurely as a result of
> -		 * cutting off the masters' power.
> +		 * If pm_cpu_data is set, cpuidle should turn the domain off
> +		 * when the CPU in it is idle.  In that case we don't decrement
> +		 * the subdomain counts of the master domains, so that power is
> +		 * not removed from the current domain prematurely as a result
> +		 * of cutting off the masters' power.
>  		 */
>  		genpd->status = GPD_STATE_POWER_OFF;
>  		cpuidle_pause_and_lock();
> -		genpd->cpu_data->idle_state->disabled = false;
> +		genpd->pm_cpu_data->idle_state->disabled = false;
>  		cpuidle_resume_and_unlock();
>  		goto out;
>  	}
> @@ -1698,7 +1698,7 @@ int pm_genpd_remove_subdomain(struct generic_pm_domain *genpd,
>  int pm_genpd_attach_cpuidle(struct generic_pm_domain *genpd, int state)
>  {
>  	struct cpuidle_driver *cpuidle_drv;
> -	struct gpd_cpu_data *cpu_data;
> +	struct gpd_cpu_data *pm_cpu_data;
>  	struct cpuidle_state *idle_state;
>  	int ret = 0;
>  
> @@ -1707,12 +1707,12 @@ int pm_genpd_attach_cpuidle(struct generic_pm_domain *genpd, int state)
>  
>  	genpd_acquire_lock(genpd);
>  
> -	if (genpd->cpu_data) {
> +	if (genpd->pm_cpu_data) {
>  		ret = -EEXIST;
>  		goto out;
>  	}
> -	cpu_data = kzalloc(sizeof(*cpu_data), GFP_KERNEL);
> -	if (!cpu_data) {
> +	pm_cpu_data = kzalloc(sizeof(*pm_cpu_data), GFP_KERNEL);
> +	if (!pm_cpu_data) {
>  		ret = -ENOMEM;
>  		goto out;
>  	}
> @@ -1730,9 +1730,9 @@ int pm_genpd_attach_cpuidle(struct generic_pm_domain *genpd, int state)
>  		ret = -EAGAIN;
>  		goto err;
>  	}
> -	cpu_data->idle_state = idle_state;
> -	cpu_data->saved_exit_latency = idle_state->exit_latency;
> -	genpd->cpu_data = cpu_data;
> +	pm_cpu_data->idle_state = idle_state;
> +	pm_cpu_data->saved_exit_latency = idle_state->exit_latency;
> +	genpd->pm_cpu_data = pm_cpu_data;
>  	genpd_recalc_cpu_exit_latency(genpd);
>  
>   out:
> @@ -1743,7 +1743,7 @@ int pm_genpd_attach_cpuidle(struct generic_pm_domain *genpd, int state)
>  	cpuidle_driver_unref();
>  
>   err_drv:
> -	kfree(cpu_data);
> +	kfree(pm_cpu_data);
>  	goto out;
>  }
>  
> @@ -1766,7 +1766,7 @@ int pm_genpd_name_attach_cpuidle(const char *name, int state)
>   */
>  int pm_genpd_detach_cpuidle(struct generic_pm_domain *genpd)
>  {
> -	struct gpd_cpu_data *cpu_data;
> +	struct gpd_cpu_data *pm_cpu_data;
>  	struct cpuidle_state *idle_state;
>  	int ret = 0;
>  
> @@ -1775,20 +1775,20 @@ int pm_genpd_detach_cpuidle(struct generic_pm_domain *genpd)
>  
>  	genpd_acquire_lock(genpd);
>  
> -	cpu_data = genpd->cpu_data;
> -	if (!cpu_data) {
> +	pm_cpu_data = genpd->pm_cpu_data;
> +	if (!pm_cpu_data) {
>  		ret = -ENODEV;
>  		goto out;
>  	}
> -	idle_state = cpu_data->idle_state;
> +	idle_state = pm_cpu_data->idle_state;
>  	if (!idle_state->disabled) {
>  		ret = -EAGAIN;
>  		goto out;
>  	}
> -	idle_state->exit_latency = cpu_data->saved_exit_latency;
> +	idle_state->exit_latency = pm_cpu_data->saved_exit_latency;
>  	cpuidle_driver_unref();
> -	genpd->cpu_data = NULL;
> -	kfree(cpu_data);
> +	genpd->pm_cpu_data = NULL;
> +	kfree(pm_cpu_data);
>  
>   out:
>  	genpd_release_lock(genpd);
> diff --git a/include/linux/pm_domain.h b/include/linux/pm_domain.h
> index 9004743..a73b825 100644
> --- a/include/linux/pm_domain.h
> +++ b/include/linux/pm_domain.h
> @@ -71,7 +71,7 @@ struct generic_pm_domain {
>  	s64 max_off_time_ns;	/* Maximum allowed "suspended" time. */
>  	bool max_off_time_changed;
>  	bool cached_power_down_ok;
> -	struct gpd_cpu_data *cpu_data;
> +	struct gpd_cpu_data *pm_cpu_data;
>  	void (*attach_dev)(struct device *dev);
>  	void (*detach_dev)(struct device *dev);
>  };
> 

-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
