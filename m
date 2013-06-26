Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279Ab3FZVfd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 17:35:33 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:49583 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074Ab3FZVfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 17:35:30 -0400
Message-ID: <51CB5E6B.109@ahsoftware.de>
Date: Wed, 26 Jun 2013 23:34:35 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: rtc-linux@googlegroups.com
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [rtc-linux] Re: [PATCH 3/9 v2] rtc: rtc-hid-sensor-time: delay
 registering as rtc into a work
References: <1371228732-5749-4-git-send-email-holler@ahsoftware.de> <1371724776-5572-1-git-send-email-holler@ahsoftware.de> <20130626125501.3d64408309a6f63100cc7d08@linux-foundation.org>
In-Reply-To: <20130626125501.3d64408309a6f63100cc7d08@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 26.06.2013 21:55, schrieb Andrew Morton:
> On Thu, 20 Jun 2013 12:39:36 +0200 Alexander Holler <holler@ahsoftware.de> wrote:
> 
>> rtc_device_register() might want to read the clock which doesn't work
>> before the hid device is registered. Therefor we delay the registration of
>> the rtc driver by moving it to a work.
>>
> 
> 
>> --- a/drivers/rtc/rtc-hid-sensor-time.c
>> +++ b/drivers/rtc/rtc-hid-sensor-time.c
>> @@ -37,6 +37,11 @@ enum hid_time_channel {
>>  	TIME_RTC_CHANNEL_MAX,
>>  };
>>  
>> +struct hid_time_workts {
> 	
> Strange name.  I can't work out what the "ts" means.

It's just a name

> 	
>> +	struct work_struct work;
>> +	struct hid_time_state *time_state;
>> +};

and stands for work + time_state. Peronally I would use
hid_time_work_time_state, but then I would get even more problems to go
conform with CGA restrictions on line widths.

>> +
>>  struct hid_time_state {
>>  	struct hid_sensor_hub_callbacks callbacks;
>>  	struct hid_sensor_common common_attributes;
>>
>> ...
>>
>> @@ -237,6 +243,36 @@ static const struct rtc_class_ops hid_time_rtc_ops = {
>>  	.read_time = hid_rtc_read_time,
>>  };
>>  
>> +static void hid_time_register_rtc_work(struct work_struct *work)
>> +{
>> +	struct hid_time_state *time_state =
>> +		container_of(work, struct hid_time_workts, work)
>> +			->time_state;
>> +	struct platform_device *pdev = time_state->callbacks.pdev;
> 
> Ick.  When the initialisers overflow 80 cols, the fix is easy: don't
> use initalisers:
> 
> 	struct hid_time_state *time_state;
> 	struct platform_device *pdev;
> 
> 	time_state = container_of(work, struct hid_time_workts, work)->time_state;
> 	pdev = time_state->callbacks.pdev;
> 

Sorry, but it's long ago since I had to use a DOS machine and I still
don't use a phone to write source, therefor I'm not very skilled in
writing readable source with meaningfull names in max. 72 (80-8) chars
per line. But I will work hard to relearn those long forgotten skills,
they might become handy again, when PCs with monitors got finally
replaced by phones and tablets with small screens. ;)

>> +	time_state->rtc = devm_rtc_device_register(&pdev->dev,
>> +					"hid-sensor-time", &hid_time_rtc_ops,
>> +					THIS_MODULE);
>> +	if (IS_ERR_OR_NULL(time_state->rtc)) {
>> +		struct hid_sensor_hub_device *hsdev = pdev->dev.platform_data;
> 
> Newline after end-of-definitions and before start-of-code, please.
> 
>> +		sensor_hub_remove_callback(hsdev, HID_USAGE_SENSOR_TIME);
>> +		time_state->rtc = NULL;
>> +		dev_err(&pdev->dev, "rtc device register failed!\n");
>> +		/*
>> +		 *  I haven't a found a way to remove only this device from
>> +		 *  hid-sensor-hub. Removing the device a level above (the
>> +		 *  complete HID device) doesn't work, because a sensor-hub
>> +		 *  might provide more than just a time-sensor and thus we
>> +		 *  would remove all sensors not just this one.
>> +		 *  So we just leave this driver idling around until I or
>> +		 *  someone else has figured out how to remove this device
>> +		 *  from hid-sensor-hub.
>> +		 */
>> +	}
>> +	time_state->workts = NULL;
>> +	kfree(work);
>> +}
>> +
>>  static int hid_time_probe(struct platform_device *pdev)
>>  {
>>  	int ret = 0;
>> @@ -279,22 +315,34 @@ static int hid_time_probe(struct platform_device *pdev)
>>  		return ret;
>>  	}
>>  
>> -	time_state->rtc = devm_rtc_device_register(&pdev->dev,
>> -					"hid-sensor-time", &hid_time_rtc_ops,
>> -					THIS_MODULE);
>> -
>> -	if (IS_ERR(time_state->rtc)) {
>> -		dev_err(&pdev->dev, "rtc device register failed!\n");
>> -		return PTR_ERR(time_state->rtc);
>> +	/*
>> +	 * The HID device has to be registered to read the clock.
>> +	 * Because rtc_device_register() might read the time, we have to delay
>> +	 * rtc_device_register() to a work in order to finish the probe before.
>> +	 */
>> +	time_state->workts = kmalloc(sizeof(struct hid_time_workts),
>> +		GFP_KERNEL);
>> +	if (time_state->workts == NULL) {
>> +		sensor_hub_remove_callback(hsdev, HID_USAGE_SENSOR_TIME);
>> +		return -ENOMEM;
>>  	}
>> +	time_state->workts->time_state = time_state;
>> +	INIT_WORK(&time_state->workts->work,
>> +			hid_time_register_rtc_work);
>> +	schedule_work(&time_state->workts->work);
> 
> This seems unreliable.  The scheduled work can run one nanosecond
> later, on this or a different CPU.  What guarantees that the HID device
> will then be fully registered?

Nothing, but schedule_delayed_work() is as unreliable as without delay
and I don't know of any callback after registration has happened. I have
to dig through the hid-(sensor-)code, maybe I will find a callback I can
(mis)use to register the rtc driver after the hid driver was registered.

I will write a v3 if I've found something.

Regards,

Alexander Holler
