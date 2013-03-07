Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760042Ab3CGXXP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 18:23:15 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:56002 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759938Ab3CGXXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 18:23:13 -0500
Date: Fri, 8 Mar 2013 07:16:40 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: john.stultz@linaro.org, toddpoynor@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] alarmtimer: add error prints when suspend failed
Message-ID: <20130307231640.GE4280@kroah.com>
References: <1362684457-32570-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362684457-32570-1-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 08, 2013 at 12:57:37AM +0530, Laxman Dewangan wrote:
> The alramtimer suspend failed when nearest alarm wakeup time is
> less than 2 sec or rtc timer can not start.
> 
> In suspend/resume stress testing, we found that sometimes alramtimer
> failed to suspend and hence it cancel the suspend ops. Add error prints
> in suspend failure to provide more info when failure occurs to help
> debugging.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
>  kernel/time/alarmtimer.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
> index f11d83b..eed5646 100644
> --- a/kernel/time/alarmtimer.c
> +++ b/kernel/time/alarmtimer.c
> @@ -249,6 +249,8 @@ static int alarmtimer_suspend(struct device *dev)
>  
>  	if (ktime_to_ns(min) < 2 * NSEC_PER_SEC) {
>  		__pm_wakeup_event(ws, 2 * MSEC_PER_SEC);
> +		dev_err(dev,
> +			"Nearest alarm wakeup time < 2sec, avoiding suspend\n");

What can userspace now do with this information?  How often is this now
going to spam the syslog and cause confusion?

>  		return -EBUSY;
>  	}
>  
> @@ -260,8 +262,10 @@ static int alarmtimer_suspend(struct device *dev)
>  
>  	/* Set alarm, if in the past reject suspend briefly to handle */
>  	ret = rtc_timer_start(rtc, &rtctimer, now, ktime_set(0, 0));
> -	if (ret < 0)
> +	if (ret < 0) {
>  		__pm_wakeup_event(ws, MSEC_PER_SEC);
> +		dev_err(dev, "RTC timer start failed, %d\n", ret);

Same here, you aren't changing any code paths, just annoying people who
can't do anything about this.

As you want to do this for debugging, make them debugging level messages
please.

thanks,

greg k-h
