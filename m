Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139AbbALIwo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 03:52:44 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:23159 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbbALIwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 03:52:41 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-5b-54b38b587974
Message-id: <54B38B55.7080503@samsung.com>
Date: Mon, 12 Jan 2015 09:52:37 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804
 Thunderbird/17.0.8
MIME-version: 1.0
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        cooloney@gmail.com, rpurdie@rpsys.net, sakari.ailus@iki.fi,
        s.nawrocki@samsung.com, Andrzej Hajda <a.hajda@samsung.com>,
        Lee Jones <lee.jones@linaro.org>, Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [PATCH/RFC v10 08/19] leds: Add support for max77693 mfd flash cell
References: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
 <1420816989-1808-9-git-send-email-j.anaszewski@samsung.com>
 <20150109184606.GJ18076@amd>
In-reply-to: <20150109184606.GJ18076@amd>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFLMWRmVeSWpSXmKPExsVy+t/xa7oR3ZtDDB5e4LK4te4cq8XGGetZ
	LY7unMhkcf3Lc1aL+UeAYmeb3rBb3P96lNHi8q45bBZb36xjtOjZsJXV4u6po2wWu3c9ZbU4
	/Kad1eLM/pVsDnweO2fdZfc4/HUhi8eda3vYPPbM/8Hq0bdlFaPHitXf2T0+b5ILYI/isklJ
	zcksSy3St0vgymi59JOlYBVfxa7/7A2Ma7m7GDk5JARMJDrv72eEsMUkLtxbz9bFyMUhJLCU
	UeLU1B3MEM5HRonrPXOBqjg4eAW0JH5MMgBpYBFQlfj27igriM0mYCjx88VrJhBbVCBC4s/p
	fWBxXgFBiR+T77GA2CIC8hJb+1aAzWQW+Mok0dSyjw0kISwQIHFk6jqozUsYJZoXzmYBWcYp
	oCmxc00ISA2zgLXEyknbGCFseYnNa94yT2AUmIVkxywkZbOQlC1gZF7FKJpamlxQnJSea6RX
	nJhbXJqXrpecn7uJERI/X3cwLj1mdYhRgINRiYfXUmpziBBrYllxZe4hRgkOZiURXtcyoBBv
	SmJlVWpRfnxRaU5q8SFGJg5OqQbGLK9T/44ZFz2X4LG2PrtgU9PP+4wOK1o3NDQkHFP1lpVd
	Oa03/86FqzNv//OvKNzgmjrNbfO2wrui56c2Pf+7v9hn97zzf/907XD7XXynQNhSXG/b8p8i
	BsUOxQ9SmjhindawyqrNij162eRPb4lQaEH/Jqa70/2u+czJn7y60a9A5l7MGZ7HSizFGYmG
	WsxFxYkA30VLn30CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

Thanks for the review.

On 01/09/2015 07:46 PM, Pavel Machek wrote:
> On Fri 2015-01-09 16:22:58, Jacek Anaszewski wrote:
>> This patch adds led-flash support to Maxim max77693 chipset.
>> A device can be exposed to user space through LED subsystem
>> sysfs interface. Device supports up to two leds which can
>> work in flash and torch mode. The leds can be triggered
>> externally or by software.
>>
>
>> +struct max77693_sub_led {
>> +	/* related FLED output identifier */
>
> ->flash LED, about 4x.
>
>> +/* split composite current @i into two @iout according to @imax weights */
>> +static void __max77693_calc_iout(u32 iout[2], u32 i, u32 imax[2])
>> +{
>> +	u64 t = i;
>> +
>> +	t *= imax[1];
>> +	do_div(t, imax[0] + imax[1]);
>> +
>> +	iout[1] = (u32)t / FLASH_IOUT_STEP * FLASH_IOUT_STEP;
>> +	iout[0] = i - iout[1];
>> +}
>
> Is 64-bit arithmetics neccessary here? Could we do the FLASH_IOUT_STEP
> divisons before t *=, so that 64-bit division is not neccessary?

It is required. All these operations allow for splitting the composite
current into both outputs according to weights given in the imax array.

>> +static int max77693_led_flash_strobe_get(
>> +				struct led_classdev_flash *fled_cdev,
>> +				bool *state)
>> +{
>> +	struct max77693_sub_led *sub_led = flcdev_to_sub_led(fled_cdev);
>> +	struct max77693_led_device *led = sub_led_to_led(sub_led);
>> +	int ret;
>> +
>> +	if (!state)
>> +		return -EINVAL;
>> +
>> +	mutex_lock(&led->lock);
>> +
>> +	ret = max77693_strobe_status_get(led, state);
>> +
>> +	*state = !!(*state && (led->strobing_sub_led_id == sub_led->fled_id));
>> +
>> +
>> +	mutex_unlock(&led->lock);
>> +
>> +	return ret;
>> +}
>
> Maybe remove some empty lines?
>

Of course.

-- 
Best Regards,
Jacek Anaszewski
