Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323AbaILVGU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 17:06:20 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:36505 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbaILVGS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 17:06:18 -0400
MIME-Version: 1.0
In-Reply-To: <CAK5ve-K1tu8dRwF2cqdVesZUT+VWp-NnD3ZQh6mXtnXSRJ3hPA@mail.gmail.com>
References: <1408542118-32723-1-git-send-email-j.anaszewski@samsung.com>
 <1408542118-32723-2-git-send-email-j.anaszewski@samsung.com> <CAK5ve-K1tu8dRwF2cqdVesZUT+VWp-NnD3ZQh6mXtnXSRJ3hPA@mail.gmail.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Fri, 12 Sep 2014 14:05:55 -0700
Message-ID: <CAK5ve-LTXTzV3v_5o5jPVDE_C=RP5+B5OtCUachiy9E8siP6+w@mail.gmail.com>
Subject: Re: [PATCH/RFC v5 1/4] leds: Improve and export led_update_brightness
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: Linux LED Subsystem <linux-leds@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>, b.zolnierkie@samsung.com,
        Richard Purdie <rpurdie@rpsys.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 5, 2014 at 2:03 PM, Bryan Wu <cooloney@gmail.com> wrote:
> On Wed, Aug 20, 2014 at 6:41 AM, Jacek Anaszewski
> <j.anaszewski@samsung.com> wrote:
>> led_update_brightness helper function used to be exploited only locally
>> in the led-class.c module, where its result was being passed to the
>> brightness_show sysfs callback. With the introduction of v4l2-flash
>> subdevice the same functionality becomes required for reading current
>> brightness from a LED device. This patch adds checking of return value
>> of the brightness_get callback and moves the led_update_brightness()
>> function to the LED subsystem public API.
>>
>
> This one looks good to me.
> Thanks,
> -Bryan
>

Merged， no need to update this patch then.

-Bryan

>> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> Cc: Bryan Wu <cooloney@gmail.com>
>> Cc: Richard Purdie <rpurdie@rpsys.net>
>> ---
>>  drivers/leds/led-class.c |    6 ------
>>  drivers/leds/led-core.c  |   16 ++++++++++++++++
>>  include/linux/leds.h     |   10 ++++++++++
>>  3 files changed, 26 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
>> index f4e5bb4..6f82a76 100644
>> --- a/drivers/leds/led-class.c
>> +++ b/drivers/leds/led-class.c
>> @@ -23,12 +23,6 @@
>>
>>  static struct class *leds_class;
>>
>> -static void led_update_brightness(struct led_classdev *led_cdev)
>> -{
>> -       if (led_cdev->brightness_get)
>> -               led_cdev->brightness = led_cdev->brightness_get(led_cdev);
>> -}
>> -
>>  static ssize_t brightness_show(struct device *dev,
>>                 struct device_attribute *attr, char *buf)
>>  {
>> diff --git a/drivers/leds/led-core.c b/drivers/leds/led-core.c
>> index 8380eb7..466ce5a 100644
>> --- a/drivers/leds/led-core.c
>> +++ b/drivers/leds/led-core.c
>> @@ -127,3 +127,19 @@ void led_set_brightness(struct led_classdev *led_cdev,
>>         __led_set_brightness(led_cdev, brightness);
>>  }
>>  EXPORT_SYMBOL(led_set_brightness);
>> +
>> +int led_update_brightness(struct led_classdev *led_cdev)
>> +{
>> +       int ret = 0;
>> +
>> +       if (led_cdev->brightness_get) {
>> +               ret = led_cdev->brightness_get(led_cdev);
>> +               if (ret >= 0) {
>> +                       led_cdev->brightness = ret;
>> +                       return 0;
>> +               }
>> +       }
>> +
>> +       return ret;
>> +}
>> +EXPORT_SYMBOL(led_update_brightness);
>> diff --git a/include/linux/leds.h b/include/linux/leds.h
>> index bc221d11..cc85b16 100644
>> --- a/include/linux/leds.h
>> +++ b/include/linux/leds.h
>> @@ -139,6 +139,16 @@ extern void led_blink_set_oneshot(struct led_classdev *led_cdev,
>>   */
>>  extern void led_set_brightness(struct led_classdev *led_cdev,
>>                                enum led_brightness brightness);
>> +/**
>> + * led_update_brightness - update LED brightness
>> + * @led_cdev: the LED to query
>> + *
>> + * Get an LED's current brightness and update led_cdev->brightness
>> + * member with the obtained value.
>> + *
>> + * Returns: 0 on success or negative error value on failure
>> + */
>> +extern int led_update_brightness(struct led_classdev *led_cdev);
>>
>>  /*
>>   * LED Triggers
>> --
>> 1.7.9.5
>>
