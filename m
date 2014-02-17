Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683AbaBQRKW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 12:10:22 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:58919 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753444AbaBQRKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 12:10:19 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Chuansheng Liu <chuansheng.liu@intel.com>
Cc: gregkh@linuxfoundation.org, len.brown@intel.com, pavel@ucw.cz,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        zhuangzhi.li@intel.com
Subject: Re: [PATCH v3 3/5] PM / sleep: Asynchronous threads for resume_early
Date: Mon, 17 Feb 2014 18:25:06 +0100
Message-ID: <1502413.rEZQFoyGgP@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1392617954-5292-4-git-send-email-chuansheng.liu@intel.com>
References: <1392617954-5292-4-git-send-email-chuansheng.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 17, 2014 02:19:12 PM Chuansheng Liu wrote:
> In analogy with commits 5af84b82701a and 97df8c12995, using
> asynchronous threads can improve the overall resume_early
> time significantly.
> 
> This patch is for resume_early phase.
> 
> Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
> ---
>  drivers/base/power/main.c | 55 +++++++++++++++++++++++++++++++++++++----------
>  1 file changed, 44 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
> index 89172aa..2f2d110 100644
> --- a/drivers/base/power/main.c
> +++ b/drivers/base/power/main.c
> @@ -595,7 +595,7 @@ static void dpm_resume_noirq(pm_message_t state)
>   *
>   * Runtime PM is disabled for @dev while this function is being executed.
>   */
> -static int device_resume_early(struct device *dev, pm_message_t state)
> +static int device_resume_early(struct device *dev, pm_message_t state, bool async)
>  {
>  	pm_callback_t callback = NULL;
>  	char *info = NULL;
> @@ -607,6 +607,8 @@ static int device_resume_early(struct device *dev, pm_message_t state)
>  	if (dev->power.syscore)
>  		goto Out;
>  
> +	dpm_wait(dev->parent, async);
> +

If power.is_late_suspended is unset, you don't have to wait.

>  	if (!dev->power.is_late_suspended)
>  		goto Out;
>  
> @@ -636,38 +638,69 @@ static int device_resume_early(struct device *dev, pm_message_t state)
>  	TRACE_RESUME(error);
>  
>  	pm_runtime_enable(dev);
> +	complete_all(&dev->power.completion);
>  	return error;
>  }
>  
> +static void async_resume_early(void *data, async_cookie_t cookie)
> +{
> +	struct device *dev = (struct device *)data;
> +	int error;
> +
> +	error = device_resume_early(dev, pm_transition, true);
> +	if (error)
> +		pm_dev_err(dev, pm_transition, " async", error);
> +
> +	put_device(dev);
> +}
> +
>  /**
>   * dpm_resume_early - Execute "early resume" callbacks for all devices.
>   * @state: PM transition of the system being carried out.
>   */
>  static void dpm_resume_early(pm_message_t state)
>  {
> +	struct device *dev;
>  	ktime_t starttime = ktime_get();
>  
>  	mutex_lock(&dpm_list_mtx);
> -	while (!list_empty(&dpm_late_early_list)) {
> -		struct device *dev = to_device(dpm_late_early_list.next);
> -		int error;
> +	pm_transition = state;
> +
> +	/*
> +	 * Advanced the async threads upfront,
> +	 * in case the starting of async threads is
> +	 * delayed by non-async resuming devices.
> +	 */
> +	list_for_each_entry(dev, &dpm_late_early_list, power.entry) {
> +		reinit_completion(&dev->power.completion);
> +		if (is_async(dev)) {
> +			get_device(dev);
> +			async_schedule(async_resume_early, dev);
> +		}
> +	}
>  
> +	while (!list_empty(&dpm_late_early_list)) {
> +		dev = to_device(dpm_late_early_list.next);
>  		get_device(dev);
>  		list_move_tail(&dev->power.entry, &dpm_suspended_list);
>  		mutex_unlock(&dpm_list_mtx);
>  
> -		error = device_resume_early(dev, state);
> -		if (error) {
> -			suspend_stats.failed_resume_early++;
> -			dpm_save_failed_step(SUSPEND_RESUME_EARLY);
> -			dpm_save_failed_dev(dev_name(dev));
> -			pm_dev_err(dev, state, " early", error);
> -		}
> +		if (!is_async(dev)) {
> +			int error;
>  
> +			error = device_resume_early(dev, state, false);
> +			if (error) {
> +				suspend_stats.failed_resume_early++;
> +				dpm_save_failed_step(SUSPEND_RESUME_EARLY);
> +				dpm_save_failed_dev(dev_name(dev));
> +				pm_dev_err(dev, state, " early", error);
> +			}
> +		}
>  		mutex_lock(&dpm_list_mtx);
>  		put_device(dev);
>  	}
>  	mutex_unlock(&dpm_list_mtx);
> +	async_synchronize_full();
>  	dpm_show_time(starttime, state, "early");
>  }
>  
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
