Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945930Ab3FVAP2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 20:15:28 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:46082 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423420Ab3FVAP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 20:15:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: pavel@ucw.cz, len.brown@intel.com, gregkh@linuxfoundation.org,
        joe@perches.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Subject: Re: [PATCHv v3] power: Include additional information in pm_print_times
Date: Sat, 22 Jun 2013 02:24:48 +0200
Message-ID: <2534796.mOHH0DCD2A@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1371497795-20084-1-git-send-email-shuah.kh@samsung.com>
References: <1371497795-20084-1-git-send-email-shuah.kh@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 17, 2013 01:36:35 PM Shuah Khan wrote:
> Change __device_suspend() path to include driver name and the ops that
> get run for a device. This additional information helps associate the
> driver and the type of pm_ops the device uses in the suspend path very
> quickly, which will aid in debugging problems in suspend and resume paths.
> Changed both start and end debug messages to include pm_ops information
> and use dev_info() instead of pr_info(). Changed the end message to include
> parent device information and have the same format as the start message.
> 
> dmesg output before the change:
> 
> [  164.390032] calling  1-1+ @ 69, parent: usb1
> [  164.390035] call 1-1+ returned 0 after 0 usecs
> 
> [  164.390352] calling  00:0a+ @ 2457, parent: pnp0
> [  164.390357] call 00:0a+ returned 0 after 3 usecs
> 
> [  164.390361] calling  00:09+ @ 2457, parent: pnp0
> [  164.496458] call 00:09+ returned 0 after 103500 usecs
> 
> [  164.496494] calling  00:05+ @ 2457, parent: pnp0
> [  164.496511] call 00:05+ returned 0 after 14 usecs
> 
> dmesg output after the change:
> 
> [  545.985394] usb 1-1: Start: type pm ops @ 68, parent: usb1
> [  545.987650] usb 1-1: End  : type pm ops @ 68, parent: usb1 time(2184 usecs) err(0)
> 
> [  545.982544] system 00:0a: Start: legacy bus pm ops @ 2391, parent: pnp0
> [  545.982554] system 00:0a: End  : legacy bus pm ops @ 2391, parent: pnp0 time(4 usecs) err(0)
> 
> [  545.982569] tpm_tis 00:09: Start: legacy bus pm ops @ 2391, parent: pnp0
> [  546.087017] tpm_tis 00:09: End  : legacy bus pm ops @ 2391, parent: pnp0 time(101936 usecs) err(0)
> 
> [  546.087069] rtc_cmos 00:05: Start: legacy bus pm ops @ 2391, parent: pnp0
> [  546.087084] rtc_cmos 00:05: End  : legacy bus pm ops @ 2391, parent: pnp0 time(11 usecs) err(0)
> 

I was about to apply your patch, but then I noticed something that might cause
problems to happen.

Namely, there are tools that use these messages to create suspend/resume time
charts and they will stop working after the proposed changes.

Please keep the existing formatting the way it is and only append the additional
information at the end of each line.

Thanks,
Rafael


> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
> ---
> 
> v2: Change to use dev_info() instead of pr_info()
> v3: Change to add parent info to debug_report and make start and end messages
>     look similar have a tighter association.
> 
>  drivers/base/power/main.c |   49 +++++++++++++++++++++++++++------------------
>  1 file changed, 29 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
> index 5a9b656..c2132b8 100644
> --- a/drivers/base/power/main.c
> +++ b/drivers/base/power/main.c
> @@ -157,13 +157,14 @@ void device_pm_move_last(struct device *dev)
>  	list_move_tail(&dev->power.entry, &dpm_list);
>  }
>  
> -static ktime_t initcall_debug_start(struct device *dev)
> +static ktime_t initcall_debug_start(struct device *dev, char *info)
>  {
>  	ktime_t calltime = ktime_set(0, 0);
>  
>  	if (pm_print_times_enabled) {
> -		pr_info("calling  %s+ @ %i, parent: %s\n",
> -			dev_name(dev), task_pid_nr(current),
> +		/* string in info has an extra space at the end */
> +		dev_info(dev, "Start: %s@ %i, parent: %s\n",
> +			info, task_pid_nr(current),
>  			dev->parent ? dev_name(dev->parent) : "none");
>  		calltime = ktime_get();
>  	}
> @@ -172,15 +173,19 @@ static ktime_t initcall_debug_start(struct device *dev)
>  }
>  
>  static void initcall_debug_report(struct device *dev, ktime_t calltime,
> -				  int error)
> +				  int error, char *info)
>  {
>  	ktime_t delta, rettime;
>  
>  	if (pm_print_times_enabled) {
>  		rettime = ktime_get();
>  		delta = ktime_sub(rettime, calltime);
> -		pr_info("call %s+ returned %d after %Ld usecs\n", dev_name(dev),
> -			error, (unsigned long long)ktime_to_ns(delta) >> 10);
> +		/* string in info has an extra space at the end */
> +		dev_info(dev,
> +			"End  : %s@ %i, parent: %s time(%llu usecs) err(%d)\n",
> +			info, task_pid_nr(current),
> +			dev->parent ? dev_name(dev->parent) : "none",
> +			(unsigned long long)ktime_to_ns(delta) >> 10, error);
>  	}
>  }
>  
> @@ -373,13 +378,13 @@ static int dpm_run_callback(pm_callback_t cb, struct device *dev,
>  	if (!cb)
>  		return 0;
>  
> -	calltime = initcall_debug_start(dev);
> +	calltime = initcall_debug_start(dev, info);
>  
>  	pm_dev_dbg(dev, state, info);
>  	error = cb(dev);
>  	suspend_report_result(cb, error);
>  
> -	initcall_debug_report(dev, calltime, error);
> +	initcall_debug_report(dev, calltime, error, info);
>  
>  	return error;
>  }
> @@ -1027,17 +1032,19 @@ EXPORT_SYMBOL_GPL(dpm_suspend_end);
>   * @cb: Suspend callback to execute.
>   */
>  static int legacy_suspend(struct device *dev, pm_message_t state,
> -			  int (*cb)(struct device *dev, pm_message_t state))
> +			  int (*cb)(struct device *dev, pm_message_t state),
> +			  char *info)
>  {
>  	int error;
>  	ktime_t calltime;
>  
> -	calltime = initcall_debug_start(dev);
> +	calltime = initcall_debug_start(dev, info);
>  
> +	pm_dev_dbg(dev, state, info);
>  	error = cb(dev, state);
>  	suspend_report_result(cb, error);
>  
> -	initcall_debug_report(dev, calltime, error);
> +	initcall_debug_report(dev, calltime, error, info);
>  
>  	return error;
>  }
> @@ -1079,43 +1086,45 @@ static int __device_suspend(struct device *dev, pm_message_t state, bool async)
>  	device_lock(dev);
>  
>  	if (dev->pm_domain) {
> -		info = "power domain ";
> +		info = "power domain pm ops ";
>  		callback = pm_op(&dev->pm_domain->ops, state);
>  		goto Run;
>  	}
>  
>  	if (dev->type && dev->type->pm) {
> -		info = "type ";
> +		info = "type pm ops ";
>  		callback = pm_op(dev->type->pm, state);
>  		goto Run;
>  	}
>  
>  	if (dev->class) {
>  		if (dev->class->pm) {
> -			info = "class ";
> +			info = "class pm ops ";
>  			callback = pm_op(dev->class->pm, state);
>  			goto Run;
>  		} else if (dev->class->suspend) {
> -			pm_dev_dbg(dev, state, "legacy class ");
> -			error = legacy_suspend(dev, state, dev->class->suspend);
> +			info = "legacy class pm ops ";
> +			error = legacy_suspend(dev, state, dev->class->suspend,
> +				info);
>  			goto End;
>  		}
>  	}
>  
>  	if (dev->bus) {
>  		if (dev->bus->pm) {
> -			info = "bus ";
> +			info = "bus pm ops ";
>  			callback = pm_op(dev->bus->pm, state);
>  		} else if (dev->bus->suspend) {
> -			pm_dev_dbg(dev, state, "legacy bus ");
> -			error = legacy_suspend(dev, state, dev->bus->suspend);
> +			info = "legacy bus pm ops ";
> +			error = legacy_suspend(dev, state, dev->bus->suspend,
> +				info);
>  			goto End;
>  		}
>  	}
>  
>   Run:
>  	if (!callback && dev->driver && dev->driver->pm) {
> -		info = "driver ";
> +		info = "driver pm ops ";
>  		callback = pm_op(dev->driver->pm, state);
>  	}
>  
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
