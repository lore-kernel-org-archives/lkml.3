Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab3FNQpM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 12:45:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45174 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943Ab3FNQpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 12:45:10 -0400
Date: Fri, 14 Jun 2013 09:45:46 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: pavel@ucw.cz, rjw@sisk.pl, len.brown@intel.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Subject: Re: [PATCH] power: Include additional information in pm_print_times
Message-ID: <20130614164546.GA26107@kroah.com>
References: <1371227625-3141-1-git-send-email-shuah.kh@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371227625-3141-1-git-send-email-shuah.kh@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 10:33:45AM -0600, Shuah Khan wrote:
> Change __device_suspend() path to include driver name and the ops that
> get run for a device. This additional information helps associate driver
> and the type of pm_ops the device uses in suspend path very quickly and
> aid in debugging problems in suspend and resume paths. Added the additional
> information at the end of the original message.
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
> [  317.295499] calling 1-1+ @ 71, parent: usb1 driver: usb type pm ops
> [  317.297671] call 1-1+ returned 0 after 2117 usecs
> 
> [  318.134469] calling 00:0a+ @ 2941, parent: pnp0 driver: system legacy bus
> [  318.134476] call 00:0a+ returned 0 after 5 usecs
> 
> [  317.292894] calling 00:09+ @ 2941, parent: pnp0 driver: tpm_tis legacy bus pm ops
> [  317.397315] call 00:09+ returned 0 after 101967 usecs
> 
> [  317.397353] calling 00:05+ @ 2941, parent: pnp0 driver: rtc_cmos legacy bus pm ops
> [  317.397369] call 00:05+ returned 0 after 13 usecs
> 
> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
> CC: Shuah Khan <shuahkhan@gmail.com>
> ---
>  drivers/base/power/main.c |   35 ++++++++++++++++++++---------------
>  1 file changed, 20 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
> index 5a9b656..900266d 100644
> --- a/drivers/base/power/main.c
> +++ b/drivers/base/power/main.c
> @@ -157,14 +157,15 @@ void device_pm_move_last(struct device *dev)
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
> +		pr_info("calling %s+ @ %i, parent: %s driver: %s %s\n",
>  			dev_name(dev), task_pid_nr(current),

As we have a 'struct device' here, why aren't we just using dev_info()
instead?  That will get us the "proper" structured logging information,
and the needed information that you are looking for as well, right?

thanks,

greg k-h
