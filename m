Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894Ab3FZTzF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 15:55:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54615 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694Ab3FZTzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 15:55:03 -0400
Date: Wed, 26 Jun 2013 12:55:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexander Holler <holler@ahsoftware.de>
Cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [PATCH 3/9 v2] rtc: rtc-hid-sensor-time: delay registering as
 rtc into a work
Message-Id: <20130626125501.3d64408309a6f63100cc7d08@linux-foundation.org>
In-Reply-To: <1371724776-5572-1-git-send-email-holler@ahsoftware.de>
References: <1371228732-5749-4-git-send-email-holler@ahsoftware.de>
	<1371724776-5572-1-git-send-email-holler@ahsoftware.de>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Jun 2013 12:39:36 +0200 Alexander Holler <holler@ahsoftware.de> wrote:

> rtc_device_register() might want to read the clock which doesn't work
> before the hid device is registered. Therefor we delay the registration of
> the rtc driver by moving it to a work.
> 


> --- a/drivers/rtc/rtc-hid-sensor-time.c
> +++ b/drivers/rtc/rtc-hid-sensor-time.c
> @@ -37,6 +37,11 @@ enum hid_time_channel {
>  	TIME_RTC_CHANNEL_MAX,
>  };
>  
> +struct hid_time_workts {
	
Strange name.  I can't work out what the "ts" means.
	
> +	struct work_struct work;
> +	struct hid_time_state *time_state;
> +};
> +
>  struct hid_time_state {
>  	struct hid_sensor_hub_callbacks callbacks;
>  	struct hid_sensor_common common_attributes;
>
> ...
>
> @@ -237,6 +243,36 @@ static const struct rtc_class_ops hid_time_rtc_ops = {
>  	.read_time = hid_rtc_read_time,
>  };
>  
> +static void hid_time_register_rtc_work(struct work_struct *work)
> +{
> +	struct hid_time_state *time_state =
> +		container_of(work, struct hid_time_workts, work)
> +			->time_state;
> +	struct platform_device *pdev = time_state->callbacks.pdev;

Ick.  When the initialisers overflow 80 cols, the fix is easy: don't
use initalisers:

	struct hid_time_state *time_state;
	struct platform_device *pdev;

	time_state = container_of(work, struct hid_time_workts, work)->time_state;
	pdev = time_state->callbacks.pdev;

> +	time_state->rtc = devm_rtc_device_register(&pdev->dev,
> +					"hid-sensor-time", &hid_time_rtc_ops,
> +					THIS_MODULE);
> +	if (IS_ERR_OR_NULL(time_state->rtc)) {
> +		struct hid_sensor_hub_device *hsdev = pdev->dev.platform_data;

Newline after end-of-definitions and before start-of-code, please.

> +		sensor_hub_remove_callback(hsdev, HID_USAGE_SENSOR_TIME);
> +		time_state->rtc = NULL;
> +		dev_err(&pdev->dev, "rtc device register failed!\n");
> +		/*
> +		 *  I haven't a found a way to remove only this device from
> +		 *  hid-sensor-hub. Removing the device a level above (the
> +		 *  complete HID device) doesn't work, because a sensor-hub
> +		 *  might provide more than just a time-sensor and thus we
> +		 *  would remove all sensors not just this one.
> +		 *  So we just leave this driver idling around until I or
> +		 *  someone else has figured out how to remove this device
> +		 *  from hid-sensor-hub.
> +		 */
> +	}
> +	time_state->workts = NULL;
> +	kfree(work);
> +}
> +
>  static int hid_time_probe(struct platform_device *pdev)
>  {
>  	int ret = 0;
> @@ -279,22 +315,34 @@ static int hid_time_probe(struct platform_device *pdev)
>  		return ret;
>  	}
>  
> -	time_state->rtc = devm_rtc_device_register(&pdev->dev,
> -					"hid-sensor-time", &hid_time_rtc_ops,
> -					THIS_MODULE);
> -
> -	if (IS_ERR(time_state->rtc)) {
> -		dev_err(&pdev->dev, "rtc device register failed!\n");
> -		return PTR_ERR(time_state->rtc);
> +	/*
> +	 * The HID device has to be registered to read the clock.
> +	 * Because rtc_device_register() might read the time, we have to delay
> +	 * rtc_device_register() to a work in order to finish the probe before.
> +	 */
> +	time_state->workts = kmalloc(sizeof(struct hid_time_workts),
> +		GFP_KERNEL);
> +	if (time_state->workts == NULL) {
> +		sensor_hub_remove_callback(hsdev, HID_USAGE_SENSOR_TIME);
> +		return -ENOMEM;
>  	}
> +	time_state->workts->time_state = time_state;
> +	INIT_WORK(&time_state->workts->work,
> +			hid_time_register_rtc_work);
> +	schedule_work(&time_state->workts->work);

This seems unreliable.  The scheduled work can run one nanosecond
later, on this or a different CPU.  What guarantees that the HID device
will then be fully registered?


