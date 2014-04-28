Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531AbaD1LZR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 07:25:17 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:52331 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604AbaD1LZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 07:25:13 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-da-535e3a91b60f
Message-id: <535E3A95.6010206@samsung.com>
Date: Mon, 28 Apr 2014 13:25:09 +0200
From: Jacek Anaszewski <j.anaszewski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804
 Thunderbird/17.0.8
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        s.nawrocki@samsung.com, a.hajda@samsung.com, kyungmin.park@samsung.com
Subject: Re: [PATCH/RFC v3 5/5] media: Add registration helpers for V4L2 flash
 sub-devices
References: <1397228216-6657-1-git-send-email-j.anaszewski@samsung.com>
 <1397228216-6657-6-git-send-email-j.anaszewski@samsung.com>
 <20140416182141.GG8753@valkosipuli.retiisi.org.uk>
 <534F9044.6080508@samsung.com>
 <20140423152435.GJ8753@valkosipuli.retiisi.org.uk>
In-reply-to: <20140423152435.GJ8753@valkosipuli.retiisi.org.uk>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOLMWRmVeSWpSXmKPExsVy+t/xa7oTreKCDfZOULS4te4cq8X8I0Di
	bNMbdovLu+awWWx9s47RomfDVlaLw2/aWS3O7F/J5sDhcfjrQhaPvi2rGD0+b5ILYI7isklJ
	zcksSy3St0vgyng3extbwXGhitbJlxkbGJ/zdTFyckgImEjs3LeGFcIWk7hwbz1bFyMHh5DA
	UkaJl0xdjFxA5kdGicVHH4DFeQW0JOackQAxWQRUJY5uSgTpZBMwlPj54jUTiC0qECHx5/Q+
	sIm8AoISPybfYwGxRQTUJJ5uesgCMpJZ4CCjxIftF9hAEsICMRLLDv1ghNg1gUni89NbjCAJ
	TgF7iTnbnoFNZRawllg5aRsjhC0vsXnNW+YJjAKzkCyZhaRsFpKyBYzMqxhFU0uTC4qT0nMN
	9YoTc4tL89L1kvNzNzFCAvvLDsbFx6wOMQpwMCrx8K5QiAkWYk0sK67MPcQowcGsJMJ7zyQu
	WIg3JbGyKrUoP76oNCe1+BAjEwenVANjytS0nHsXP16OzNOdPVlX9mbmpBQT+ZoGD6Vd03Tj
	PgelqJ5VPbawUiL2uGUuU/7e2gUyZ+ZLx22Mqb26sW3JceX9QoJVvFyHNB71MUv7mB3ndRW8
	0vZt7YxmY7bgxROY9ZqMVPrDNt7+8Lxxbnm9ZqnlJs8tJ9l3v8kXPXjk17HPj7fKHChQYinO
	SDTUYi4qTgQAGEk2YkoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sakari,

On 04/23/2014 05:24 PM, Sakari Ailus wrote:
> Hi Jacek,
>
> On Thu, Apr 17, 2014 at 10:26:44AM +0200, Jacek Anaszewski wrote:
>> Hi Sakari,
>>
>> Thanks for the review.
>>
>> On 04/16/2014 08:21 PM, Sakari Ailus wrote:
>>> Hi Jacek,
>>>
>>> Thanks for the update!
>>>
>> [...]
>>>> +static inline enum led_brightness v4l2_flash_intensity_to_led_brightness(
>>>> +					struct led_ctrl *config,
>>>> +					u32 intensity)
>>>
>>> Fits on a single line.
>>>
>>>> +{
>>>> +	return intensity / config->step;
>>>
>>> Shouldn't you first decrement the minimum before the division?
>>
>> Brightness level 0 means that led is off. Let's consider following case:
>>
>> intensity - 15625
>> config->step - 15625
>> intensity / config->step = 1 (the lowest possible current level)
>
> In V4L2 controls the minimum is not off, and zero might not be a possible
> value since minimum isn't divisible by step.
>
> I wonder how to best take that into account.

I've assumed that in MODE_TORCH a led is always on. Switching
the mode to MODE_FLASH or MODE_OFF turns the led off.
This way we avoid the problem with converting 0 uA value to
led_brightness, as available torch brightness levels start from
the minimum current level value and turning the led off is
accomplished on transition to MODE_OFF or MODE_FLASH, by
calling brightness_set op with led_brightness = 0.

[...]

>>>> +/*
>>>> + * V4L2 subdev internal operations
>>>> + */
>>>> +
>>>> +static int v4l2_flash_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
>>>> +{
>>>> +	struct v4l2_flash *v4l2_flash = v4l2_subdev_to_v4l2_flash(sd);
>>>> +	struct led_classdev *led_cdev = v4l2_flash->led_cdev;
>>>> +
>>>> +	mutex_lock(&led_cdev->led_lock);
>>>> +	v4l2_call_flash_op(sysfs_lock, led_cdev);
>>>
>>> Have you thought about device power management yet?
>>
>> Having in mind that the V4L2 Flash sub-device is only a wrapper
>> for LED driver, shouldn't power management be left to the
>> drivers?
>
> How does the LED controller driver know it needs to power the device up in
> that case?
>
> I think an s_power() op which uses PM runtime to set the power state until
> V4L2 sub-device switches to it should be enough. But I'm fine leaving it out
> from this patchset.
>

This solution looks reasonable.

Regards,
Jacek Anaszewski


