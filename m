Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439AbaHDMfd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 08:35:33 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:64082 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbaHDMfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 08:35:31 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-81-53df7e0f7364
Message-id: <53DF7E0E.2060705@samsung.com>
Date: Mon, 04 Aug 2014 14:35:26 +0200
From: Jacek Anaszewski <j.anaszewski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804
 Thunderbird/17.0.8
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH/RFC v4 06/21] leds: add API for setting torch brightness
References: <1405087464-13762-1-git-send-email-j.anaszewski@samsung.com>
 <1405087464-13762-7-git-send-email-j.anaszewski@samsung.com>
 <20140716215444.GK16460@valkosipuli.retiisi.org.uk>
In-reply-to: <20140716215444.GK16460@valkosipuli.retiisi.org.uk>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsVy+t/xy7r8dfeDDZ4tl7fYOGM9q8XRnROZ
	LOYfOcdqcbbpDbvF5V1z2Cy2vlnHaNGzYSurxe5dT1ktzuxfyebA6bFz1l12j8NfF7J47Jn/
	g9Wjb8sqRo/Pm+QCWKO4bFJSczLLUov07RK4MubfEim4L1nx5pJpA+M34S5GDg4JAROJnSfq
	uxg5gUwxiQv31rN1MXJxCAksZZRY37eDEcL5yCgx+/RzVpAGXgEtiXlzrUAaWARUJc4sWs4M
	YrMJGEr8fPGaCcQWFYiQ+HN6HyuIzSsgKPFj8j0WEFtEQE3i6aaHLCAzmQU+M0osfzwJrFlY
	wEdi8cxVYLaQwF5GidbjUSA2p4CDxJKJ78HizALWEisnbWOEsOUlNq95yzyBUWAWkh2zkJTN
	QlK2gJF5FaNoamlyQXFSeq6hXnFibnFpXrpecn7uJkZI0H/Zwbj4mNUhRgEORiUeXoPTd4OF
	WBPLiitzDzFKcDArifBml90PFuJNSaysSi3Kjy8qzUktPsTIxMEp1cDIpzI3RZ/JOebG0Uie
	W/OuFD1hlro280lvfd4t84tXLUXrYyd9k/Ba8fu9fg7nqXkHfSQk/28w/Ra+xoU1IvLAozOs
	29cb5zAW19r7tG5jdEwtMm9SD14T9OrlU76WeKXkpLdL6jpcOFruxnqcjY1TfN4gYxxzM2hb
	7BTrlPBPTLsq9l9OX67EUpyRaKjFXFScCADK4WWTWAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sakari,

On 07/16/2014 11:54 PM, Sakari Ailus wrote:
> Hi Jacek,
>
> Jacek Anaszewski wrote:
> ...
>> diff --git a/include/linux/leds.h b/include/linux/leds.h
>> index 1a130cc..9bea9e6 100644
>> --- a/include/linux/leds.h
>> +++ b/include/linux/leds.h
>> @@ -44,11 +44,21 @@ struct led_classdev {
>>   #define LED_BLINK_ONESHOT_STOP    (1 << 18)
>>   #define LED_BLINK_INVERT    (1 << 19)
>>   #define LED_SYSFS_LOCK        (1 << 20)
>> +#define LED_DEV_CAP_TORCH    (1 << 21)
>>
>>       /* Set LED brightness level */
>>       /* Must not sleep, use a workqueue if needed */
>>       void        (*brightness_set)(struct led_classdev *led_cdev,
>>                         enum led_brightness brightness);
>> +    /*
>> +     * Set LED brightness immediately - it is required for flash led
>> +     * devices as they require setting torch brightness to have
>> immediate
>> +     * effect. brightness_set op cannot be used for this purpose because
>> +     * the led drivers schedule a work queue task in it to allow for
>> +     * being called from led-triggers, i.e. from the timer irq context.
>> +     */
>
> Do we need to classify actual devices based on this? I think it's rather
> a different API behaviour between the LED and the V4L2 APIs.
>
> On devices that are slow to control, the behaviour should be asynchronous
> over the LED API and synchronous when accessed through the V4L2 API. How
> about implementing the work queue, as I have suggested, in the
> framework, so
> that individual drivers don't need to care about this and just implement
> the
> synchronous variant of this op? A flag could be added to distinguish
> devices
> that are fast so that the work queue isn't needed.
>
> It'd be nice to avoid individual drivers having to implement multiple
> ops to
> do the same thing, just for differing user space interfacs.
>

It is not only the matter of a device controller speed. If a flash
device is to be made accessible from the LED subsystem, then it
should be also compatible with led-triggers. Some of led-triggers
call brightness_set op from the timer irq context and thus no
locking in the callback can occur. This requirement cannot be
met i.e. if i2c bus is to be used. This is probably the primary
reason for scheduling work queue tasks in brightness_set op.

Having the above in mind, setting a brightness in a work queue
task must be possible for all LED Class Flash drivers, regardless
whether related devices have fast or slow controller.

Let's recap the cost of possible solutions then:

1) Moving the work queues to the LED framework

   - it would probably require extending led_set_brightness and
     __led_set_brightness functions by a parameter indicating whether it
     should call brightness_set op in the work queue task or directly;
   - all existing triggers would have to be updated accordingly;
   - work queues would have to be removed from all the LED drivers;

2) adding led_set_torch_brightness API

   - no modifications in existing drivers and triggers would be required
   - instead, only the modifications from the discussed patch would
     be required

Solution 1 looks cleaner but requires much more modifications.

Best Regards,
Jacek Anaszewski
