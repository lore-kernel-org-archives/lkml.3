Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760269Ab3DBFAS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 01:00:18 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:47094 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759120Ab3DBFAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 01:00:16 -0400
Message-ID: <515A65DB.8070803@linaro.org>
Date: Tue, 02 Apr 2013 07:00:11 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Jonghwa Lee <jonghwa3.lee@samsung.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, cpufreq@vger.kernel.org,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, sw0312.kim@samsung.com,
        m.szyprowski@samsung.com
Subject: Re: [RFC PATCH 1/2] cpuidle: Add idle enter/exit time stamp for notifying
 current idle state.
References: <1364804657-16590-1-git-send-email-jonghwa3.lee@samsung.com> <1364804657-16590-2-git-send-email-jonghwa3.lee@samsung.com>
In-Reply-To: <1364804657-16590-2-git-send-email-jonghwa3.lee@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2013 10:24 AM, Jonghwa Lee wrote:
> This patch adds idle state time stamp to cpuidle device structure to
> notify its current idle state. If last enter time is newer than last
> exit time, then it means that the core is in idle now.
> 
> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> ---

The patch description does not explain what problem you want to solve,
how to solve it and the patch itself shows nothing.

Could you elaborate ?

Thanks
  -- Daniel

>  drivers/cpuidle/cpuidle.c |    8 ++++----
>  include/linux/cpuidle.h   |    4 ++++
>  2 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
> index eba6929..1e830cc 100644
> --- a/drivers/cpuidle/cpuidle.c
> +++ b/drivers/cpuidle/cpuidle.c
> @@ -233,18 +233,18 @@ int cpuidle_wrap_enter(struct cpuidle_device *dev,
>  				int (*enter)(struct cpuidle_device *dev,
>  					struct cpuidle_driver *drv, int index))
>  {
> -	ktime_t time_start, time_end;
>  	s64 diff;
>  
> -	time_start = ktime_get();
> +	dev->last_idle_start = ktime_get();
>  
>  	index = enter(dev, drv, index);
>  
> -	time_end = ktime_get();
> +	dev->last_idle_end = ktime_get();
>  
>  	local_irq_enable();
>  
> -	diff = ktime_to_us(ktime_sub(time_end, time_start));
> +	diff = ktime_to_us(ktime_sub(dev->last_idle_end,
> +				dev->last_idle_start));
>  	if (diff > INT_MAX)
>  		diff = INT_MAX;
>  
> diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
> index 480c14d..d1af05f 100644
> --- a/include/linux/cpuidle.h
> +++ b/include/linux/cpuidle.h
> @@ -16,6 +16,7 @@
>  #include <linux/kobject.h>
>  #include <linux/completion.h>
>  #include <linux/hrtimer.h>
> +#include <linux/ktime.h>
>  
>  #define CPUIDLE_STATE_MAX	8
>  #define CPUIDLE_NAME_LEN	16
> @@ -74,6 +75,9 @@ struct cpuidle_device {
>  	struct kobject		kobj;
>  	struct completion	kobj_unregister;
>  
> +	ktime_t			last_idle_start;
> +	ktime_t			last_idle_end;
> +
>  #ifdef CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED
>  	int			safe_state_index;
>  	cpumask_t		coupled_cpus;
> 


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

