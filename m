Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400AbaHSSsc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 14:48:32 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:50273 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751460AbaHSSsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 14:48:30 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: xiaoming wang <xiaoming.wang@intel.com>
Cc: len.brown@intel.com, pavel@ucw.cz, gregkh@linuxfoundation.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chuansheng Liu <chuansheng.liu@intel.com>
Subject: Re: [PATCH 1/2] PM / sleep: Asynchronous threads for dpm_prepare
Date: Tue, 19 Aug 2014 21:07:27 +0200
Message-ID: <704261740.Kr1vECyShm@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1408480169-18090-1-git-send-email-xiaoming.wang@intel.com>
References: <1408480169-18090-1-git-send-email-xiaoming.wang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 19, 2014 04:29:28 PM xiaoming wang wrote:
> In analogy with commits 5af84b82701a and 97df8c12995,
> using asynchronous threads can improve the overall
> suspend time significantly.
> 
> This patch is for dpm_prepare phase.

I don't want to do that here and in ->complete() too.

Do you have any case where it actually helps?


> Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
> Signed-off-by: xiaoming wang <xiaoming.wang@intel.com>
> ---
>  drivers/base/power/main.c |   57 +++++++++++++++++++++++++++++++++++++++++----
>  1 files changed, 52 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
> index b67d9ae..f9fe1b3 100644
> --- a/drivers/base/power/main.c
> +++ b/drivers/base/power/main.c
> @@ -1531,15 +1531,24 @@ int dpm_suspend(pm_message_t state)
>   * Execute the ->prepare() callback(s) for given device.  No new children of the
>   * device may be registered after this function has returned.
>   */
> -static int device_prepare(struct device *dev, pm_message_t state)
> +static int __device_prepare(struct device *dev, pm_message_t state, bool async)
>  {
>  	int (*callback)(struct device *) = NULL;
>  	char *info = NULL;
>  	int ret = 0;
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
> +	dpm_wait_for_children(dev, async);
>  	/*
>  	 * If a device's parent goes into runtime suspend at the wrong time,
>  	 * it won't be possible to resume the device.  To prevent this we
> @@ -1582,7 +1591,7 @@ static int device_prepare(struct device *dev, pm_message_t state)
>  	if (ret < 0) {
>  		suspend_report_result(callback, ret);
>  		pm_runtime_put(dev);
> -		return ret;
> +		goto Complete;
>  	}
>  	/*
>  	 * A positive return value from ->prepare() means "this device appears
> @@ -1594,9 +1603,40 @@ static int device_prepare(struct device *dev, pm_message_t state)
>  	spin_lock_irq(&dev->power.lock);
>  	dev->power.direct_complete = ret > 0 && state.event == PM_EVENT_SUSPEND;
>  	spin_unlock_irq(&dev->power.lock);
> -	return 0;
> +
> +Complete:
> +	complete_all(&dev->power.completion);
> +	if (ret)
> +		async_error = ret;
> +
> +	return ret;
> +}
> +
> +static void async_prepare(void *data, async_cookie_t cookie)
> +{
> +	struct device *dev = (struct device *)data;
> +	int error;
> +
> +	error = __device_prepare(dev, pm_transition, true);
> +	if (error) {
> +		dpm_save_failed_dev(dev_name(dev));
> +		pm_dev_err(dev, pm_transition, " async", error);
> +	}
> +	put_device(dev);
> +}
> +
> +static int device_prepare(struct device *dev)
> +{
> +	reinit_completion(dev->power.completion);
> +	if (pm_async_enabled && dev->power.async_suspend) {
> +		get_device(dev);
> +		async_schedule(async_prepare, dev);
> +		return 0;
> +	}
> +	return __device_prepare(dev, pm_transition, false);
>  }
>  
> +
>  /**
>   * dpm_prepare - Prepare all non-sysdev devices for a system PM transition.
>   * @state: PM transition of the system being carried out.
> @@ -1611,13 +1651,15 @@ int dpm_prepare(pm_message_t state)
>  	might_sleep();
>  
>  	mutex_lock(&dpm_list_mtx);
> +	pm_transition = state;
> +	async_error = 0;
>  	while (!list_empty(&dpm_list)) {
>  		struct device *dev = to_device(dpm_list.next);
>  
>  		get_device(dev);
>  		mutex_unlock(&dpm_list_mtx);
>  
> -		error = device_prepare(dev, state);
> +		error = device_prepare(dev);
>  
>  		mutex_lock(&dpm_list_mtx);
>  		if (error) {
> @@ -1636,8 +1678,13 @@ int dpm_prepare(pm_message_t state)
>  		if (!list_empty(&dev->power.entry))
>  			list_move_tail(&dev->power.entry, &dpm_prepared_list);
>  		put_device(dev);
> +		if (async_error)
> +			break;
>  	}
>  	mutex_unlock(&dpm_list_mtx);
> +	async_synchronize_full();
> +	if (!error)
> +		error = async_error;
>  	trace_suspend_resume(TPS("dpm_prepare"), state.event, false);
>  	return error;
>  }
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
