Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855AbaBQRM6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 12:12:58 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:58691 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752436AbaBQRM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 12:12:56 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Chuansheng Liu <chuansheng.liu@intel.com>
Cc: gregkh@linuxfoundation.org, len.brown@intel.com, pavel@ucw.cz,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        zhuangzhi.li@intel.com
Subject: Re: [PATCH v3 5/5] PM / sleep: Asynchronous threads for suspend_late
Date: Mon, 17 Feb 2014 18:27:44 +0100
Message-ID: <10253072.9TaPuJL1lG@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1392617954-5292-6-git-send-email-chuansheng.liu@intel.com>
References: <1392617954-5292-6-git-send-email-chuansheng.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 17, 2014 02:19:14 PM Chuansheng Liu wrote:
> In analogy with commits 5af84b82701a and 97df8c12995, using
> asynchronous threads can improve the overall suspend_late
> time significantly.
> 
> This patch is for suspend_late phase.
> 
> Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
> ---
>  drivers/base/power/main.c | 66 ++++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 54 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
> index 72b4c9c..c031050 100644
> --- a/drivers/base/power/main.c
> +++ b/drivers/base/power/main.c
> @@ -1127,16 +1127,26 @@ static int dpm_suspend_noirq(pm_message_t state)
>   *
>   * Runtime PM is disabled for @dev while this function is being executed.
>   */
> -static int device_suspend_late(struct device *dev, pm_message_t state)
> +static int __device_suspend_late(struct device *dev, pm_message_t state, bool async)
>  {
>  	pm_callback_t callback = NULL;
>  	char *info = NULL;
> -	int error;
> +	int error = 0;
> +
> +	dpm_wait_for_children(dev, async);
>  

Like in patch [4/5], all of the "goto Complete" statements can go before
the waiting.

>  	__pm_runtime_disable(dev, false);
>  
> +	if (async_error)
> +		goto Complete;
> +
> +	if (pm_wakeup_pending()) {
> +		async_error = -EBUSY;
> +		goto Complete;
> +	}
> +
>  	if (dev->power.syscore)
> -		return 0;
> +		goto Complete;
>  
>  	if (dev->pm_domain) {
>  		info = "late power domain ";
> @@ -1160,10 +1170,40 @@ static int device_suspend_late(struct device *dev, pm_message_t state)
>  	error = dpm_run_callback(callback, dev, state, info);
>  	if (!error)
>  		dev->power.is_late_suspended = true;
> +	else
> +		async_error = error;
>  
> +Complete:
> +	complete_all(&dev->power.completion);
>  	return error;
>  }
>  
> +static void async_suspend_late(void *data, async_cookie_t cookie)
> +{
> +	struct device *dev = (struct device *)data;
> +	int error;
> +
> +	error = __device_suspend_late(dev, pm_transition, true);
> +	if (error) {
> +		dpm_save_failed_dev(dev_name(dev));
> +		pm_dev_err(dev, pm_transition, " async", error);
> +	}
> +	put_device(dev);
> +}
> +
> +static int device_suspend_late(struct device *dev)
> +{
> +	reinit_completion(&dev->power.completion);
> +
> +	if (pm_async_enabled && dev->power.async_suspend) {
> +		get_device(dev);
> +		async_schedule(async_suspend_late, dev);
> +		return 0;
> +	}
> +
> +	return __device_suspend_late(dev, pm_transition, false);
> +}
> +
>  /**
>   * dpm_suspend_late - Execute "late suspend" callbacks for all devices.
>   * @state: PM transition of the system being carried out.
> @@ -1174,19 +1214,20 @@ static int dpm_suspend_late(pm_message_t state)
>  	int error = 0;
>  
>  	mutex_lock(&dpm_list_mtx);
> +	pm_transition = state;
> +	async_error = 0;
> +
>  	while (!list_empty(&dpm_suspended_list)) {
>  		struct device *dev = to_device(dpm_suspended_list.prev);
>  
>  		get_device(dev);
>  		mutex_unlock(&dpm_list_mtx);
>  
> -		error = device_suspend_late(dev, state);
> +		error = device_suspend_late(dev);
>  
>  		mutex_lock(&dpm_list_mtx);
>  		if (error) {
>  			pm_dev_err(dev, state, " late", error);
> -			suspend_stats.failed_suspend_late++;
> -			dpm_save_failed_step(SUSPEND_SUSPEND_LATE);
>  			dpm_save_failed_dev(dev_name(dev));
>  			put_device(dev);
>  			break;
> @@ -1195,17 +1236,18 @@ static int dpm_suspend_late(pm_message_t state)
>  			list_move(&dev->power.entry, &dpm_late_early_list);
>  		put_device(dev);
>  
> -		if (pm_wakeup_pending()) {
> -			error = -EBUSY;
> +		if (async_error)
>  			break;
> -		}
>  	}
>  	mutex_unlock(&dpm_list_mtx);
> -	if (error)
> +	async_synchronize_full();
> +	if (error) {
> +		suspend_stats.failed_suspend_late++;
> +		dpm_save_failed_step(SUSPEND_SUSPEND_LATE);
>  		dpm_resume_early(resume_event(state));
> -	else
> +	} else {
>  		dpm_show_time(starttime, state, "late");
> -
> +	}
>  	return error;
>  }
>  
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
