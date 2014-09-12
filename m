Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556AbaILGpK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 02:45:10 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:19462 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbaILGpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 02:45:07 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-1d-541296708b34
Message-id: <5412966F.9000309@samsung.com>
Date: Fri, 12 Sep 2014 08:45:03 +0200
From: Jacek Anaszewski <j.anaszewski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804
 Thunderbird/17.0.8
MIME-version: 1.0
To: Bryan Wu <cooloney@gmail.com>
Cc: Linux LED Subsystem <linux-leds@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>, b.zolnierkie@samsung.com,
        Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH/RFC v5 2/4] leds: implement sysfs interface locking
 mechanism
References: <1408542118-32723-1-git-send-email-j.anaszewski@samsung.com>
 <1408542118-32723-3-git-send-email-j.anaszewski@samsung.com>
 <CAK5ve-+Trcg+ZL5gBZmpY_Zcqk5VOhP7jowS8Liqcz0pO_UbBQ@mail.gmail.com>
In-reply-to: <CAK5ve-+Trcg+ZL5gBZmpY_Zcqk5VOhP7jowS8Liqcz0pO_UbBQ@mail.gmail.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHLMWRmVeSWpSXmKPExsVy+t/xy7oF04RCDHbN0bXYOGM9q8XRnROZ
	LOYfOcdqcbbpDbvF5V1z2Cy2vlnHaNGzYSurxe5dT1kdODx2zrrL7rFn/g9Wj74tqxg9Pm+S
	C2CJ4rJJSc3JLEst0rdL4MpYu0GnYJNIxaO/3awNjLsEuhg5OCQETCSOLlXqYuQEMsUkLtxb
	z9bFyMUhJLCUUeLpnJnMEM5HRolbB9YxglTxCmhJHNsxjwnEZhFQlTh5cwqYzSZgKPHzxWsw
	W1QgQuLP6X2sEPWCEj8m32MBsUUEFCUWvtnPBDKUWeAIk8Scy23MIAlhgWCJ7ytvMUJsO8co
	0XF/BlgHJ1BiXddisM3MAmYSj1rWMUPY8hKb17xlnsAoMAvJkllIymYhKVvAyLyKUTS1NLmg
	OCk911CvODG3uDQvXS85P3cTIyTMv+xgXHzM6hCjAAejEg8vxznBECHWxLLiytxDjBIczEoi
	vKlThUKEeFMSK6tSi/Lji0pzUosPMTJxcEo1MDrsep1+ajvHGc53Uc843Pwkv353CLYLEjGV
	n2Fjmp/DZys8LXS/ToxgWE5xTtJp1canPrnvje5f4bJs6l6+p007e50fz1WPCLsmtwMnn58W
	/hFw/MOtv+lCcnlf3z3dfKKfZcdlwzipt93zuW3a7hqUq7qc/luy5yYLn/vhijSLwI/ZDYIL
	lFiKMxINtZiLihMBveZE2VECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bryan,

Thanks for a review.

On 09/12/2014 03:11 AM, Bryan Wu wrote:
> On Wed, Aug 20, 2014 at 6:41 AM, Jacek Anaszewski
> <j.anaszewski@samsung.com> wrote:
>> Add a mechanism for locking LED subsystem sysfs interface.
>> This patch prepares ground for addition of LED Flash Class
>> extension, whose API will be integrated with V4L2 Flash API.
>> Such a fusion enforces introducing a locking scheme, which
>> will secure consistent access to the LED Flash Class device.
>>
>> The mechanism being introduced allows for disabling LED
>> subsystem sysfs interface by calling led_sysfs_lock function
>> and enabling it by calling led_sysfs_unlock. The functions
>> alter the LED_SYSFS_LOCK flag state and must be called
>> under mutex lock. The state of the lock is checked with use
>> of led_sysfs_is_locked function. Such a design allows for
>> providing immediate feedback to the user space on whether
>> the LED Flash Class device is available or is under V4L2 Flash
>> sub-device control.
>>
>> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> Cc: Bryan Wu <cooloney@gmail.com>
>> Cc: Richard Purdie <rpurdie@rpsys.net>
>> ---
>>   drivers/leds/led-class.c    |   23 ++++++++++++++++++++---
>>   drivers/leds/led-core.c     |   18 ++++++++++++++++++
>>   drivers/leds/led-triggers.c |   15 ++++++++++++---
>>   include/linux/leds.h        |   32 ++++++++++++++++++++++++++++++++
>>   4 files changed, 82 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
>> index 6f82a76..0bc0ba9 100644
>> --- a/drivers/leds/led-class.c
>> +++ b/drivers/leds/led-class.c
>> @@ -39,17 +39,31 @@ static ssize_t brightness_store(struct device *dev,
>>   {
>>          struct led_classdev *led_cdev = dev_get_drvdata(dev);
>>          unsigned long state;
>> -       ssize_t ret = -EINVAL;
>> +       ssize_t ret;
>> +
>> +#ifdef CONFIG_V4L2_FLASH_LED_CLASS
>
> Can we remove this #ifdef? Following code looks good to the common LED class.

Sure.

>> +       mutex_lock(&led_cdev->led_lock);
>
> Can we choose more meaningful name instead of led_lock here?
> Then use led_sysfs_enable() instead of led_sysfs_unlock()
> led_sysfs_disable instead of led_sysfs_lock()
> led_sysfs_is_disabled instead of led_sysfs_is_locked()
>
> And the flag LED_SYSFS_LOCK -> LED_SYSFS_DISABLE
>
> I was just confused by the name lock and unlock and mutex lock.
>
> The idea looks good to me.

Indeed, this naming will be more intuitive.

Regards,
Jacek

