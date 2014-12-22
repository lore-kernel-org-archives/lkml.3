Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196AbaLVSl5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 13:41:57 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:33112 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598AbaLVSl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 13:41:56 -0500
From: Gabriele Mazzotta <gabriele.mzt@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: System automatically wakes up because of Intel Rapid Start Technology
Date: Mon, 22 Dec 2014 19:41:52 +0100
Message-ID: <2403684.tbaxlpZUxO@xps13>
User-Agent: KMail/4.14.2 (Linux/3.18.0+; KDE/4.14.2; x86_64; ; )
In-Reply-To: <20141222180254.GA13985@srcf.ucam.org>
References: <9927036.n7iZq92iLW@xps13> <3142141.XpVRfRv0Jy@xps13> <20141222180254.GA13985@srcf.ucam.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 December 2014 18:02:54 Matthew Garrett wrote:
> Getting this right is a little bit annoying - if the timer would have 
> expired during the time we were suspended, we don't want to re-enable 
> it. I *think* this covers all cases, and does it in generic code rather 
> than special-casing it. Any chance you can give it a test?

I've done a quick test. has_persistent_clock() is false on my system,
so this patch has no effect as it is.

> diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
> index 472a5ad..4e3a2a1 100644
> --- a/drivers/rtc/class.c
> +++ b/drivers/rtc/class.c
> @@ -91,6 +91,8 @@ static int rtc_suspend(struct device *dev)
>  		old_system = timespec64_sub(old_system, delta_delta);
>  	}
>  
> +	rtc->valid_alarm = !rtc_read_alarm(rtc, &rtc->alarm);
> +
>  	return 0;
>  }
>  
> @@ -145,6 +147,29 @@ static int rtc_resume(struct device *dev)
>  	if (sleep_time.tv_sec >= 0)
>  		timekeeping_inject_sleeptime64(&sleep_time);
>  	rtc_hctosys_ret = 0;
> +
> +	/*
> +	 * If there was an alarm set before suspend, make sure that the
> +	 * platform hasn't overwritten it
> +	 */
> +	if (rtc->valid_alarm) {
> +		struct rtc_time tm;
> +		long now, scheduled;
> +
> +		rtc_read_time(rtc, &tm);
> +		rtc_tm_to_time(&rtc->alarm.time, &scheduled);
> +		rtc_tm_to_time(&tm, &now);
> +
> +		/* Clear the alarm if it went off during suspend */
> +		if (scheduled <= now) {
> +			rtc_time_to_tm(0, &rtc->alarm.time);
> +			rtc->alarm.enabled = 0;
> +		}
> +
> +		if (rtc->ops && rtc->ops->set_alarm)
> +			rtc->ops->set_alarm(rtc->dev.parent, &rtc->alarm);
> +	}
> +
>  	return 0;
>  }
>  
> diff --git a/include/linux/rtc.h b/include/linux/rtc.h
> index 6d6be09..bc805ff 100644
> --- a/include/linux/rtc.h
> +++ b/include/linux/rtc.h
> @@ -133,6 +133,10 @@ struct rtc_device
>  	/* Some hardware can't support UIE mode */
>  	int uie_unsupported;
>  
> +#ifdef CONFIG_PM_SLEEP
> +	struct rtc_wkalrm alarm;
> +	bool valid_alarm;
> +#endif
>  #ifdef CONFIG_RTC_INTF_DEV_UIE_EMUL
>  	struct work_struct uie_task;
>  	struct timer_list uie_timer;
> 
> 
> 

