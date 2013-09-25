Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477Ab3IYWEn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 18:04:43 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:62926 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049Ab3IYWEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 18:04:42 -0400
Message-ID: <52435DF7.8040307@linaro.org>
Date: Thu, 26 Sep 2013 00:04:39 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>, rjw@sisk.pl
CC: linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/21] cpuidle: call cpuidle_get_driver() from after taking
 cpuidle_driver_lock
References: <cover.1379779777.git.viresh.kumar@linaro.org> <193825f6c2fb70462f6da2cc60e7c6c02682d6c5.1379779777.git.viresh.kumar@linaro.org>
In-Reply-To: <193825f6c2fb70462f6da2cc60e7c6c02682d6c5.1379779777.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2013 03:21 AM, Viresh Kumar wrote:
> cpuidle_driver_lock is taken correctly at most of the places but at few places
> calls to cpuidle_get_driver() are done from outside of this lock.
> 
> Fix them by calling cpuidle_get_driver() after taking cpuidle_driver_lock.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>

> ---
>  drivers/cpuidle/driver.c | 3 ++-
>  drivers/cpuidle/sysfs.c  | 3 ++-
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/cpuidle/driver.c b/drivers/cpuidle/driver.c
> index 6279e1c..7b2510a 100644
> --- a/drivers/cpuidle/driver.c
> +++ b/drivers/cpuidle/driver.c
> @@ -340,10 +340,11 @@ struct cpuidle_driver *cpuidle_driver_ref(void)
>   */
>  void cpuidle_driver_unref(void)
>  {
> -	struct cpuidle_driver *drv = cpuidle_get_driver();
> +	struct cpuidle_driver *drv;
>  
>  	spin_lock(&cpuidle_driver_lock);
>  
> +	drv = cpuidle_get_driver();
>  	if (drv && !WARN_ON(drv->refcnt <= 0))
>  		drv->refcnt--;
>  
> diff --git a/drivers/cpuidle/sysfs.c b/drivers/cpuidle/sysfs.c
> index 8739cc0..a022393 100644
> --- a/drivers/cpuidle/sysfs.c
> +++ b/drivers/cpuidle/sysfs.c
> @@ -52,9 +52,10 @@ static ssize_t show_current_driver(struct device *dev,
>  				   char *buf)
>  {
>  	ssize_t ret;
> -	struct cpuidle_driver *cpuidle_driver = cpuidle_get_driver();
> +	struct cpuidle_driver *cpuidle_driver;
>  
>  	spin_lock(&cpuidle_driver_lock);
> +	cpuidle_driver = cpuidle_get_driver();
>  	if (cpuidle_driver)
>  		ret = sprintf(buf, "%s\n", cpuidle_driver->name);
>  	else
> 


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

