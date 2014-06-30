Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709AbaF3XGr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 19:06:47 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:61109 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563AbaF3XGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 19:06:45 -0400
MIME-Version: 1.0
In-Reply-To: <CAKdAkRSaurygSeXdt09MpLGaXojJ1YW3SzTn1pBz2076hF514Q@mail.gmail.com>
References: <1403716136-32694-1-git-send-email-johan@kernel.org>
 <1403716136-32694-12-git-send-email-johan@kernel.org> <CAKdAkRSaurygSeXdt09MpLGaXojJ1YW3SzTn1pBz2076hF514Q@mail.gmail.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Mon, 30 Jun 2014 16:06:23 -0700
Message-ID: <CAK5ve-+BhzZG01_zg=XJzkvrgcO0RzfYjEZ9dV7tJgGMROjBLg@mail.gmail.com>
Subject: Re: [PATCH 11/13] input: lm8323: fix attribute-creation race
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Johan Hovold <johan@kernel.org>, Richard Purdie <rpurdie@rpsys.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        Janne Kanniainen <janne.kanniainen@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 11:50 AM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Wed, Jun 25, 2014 at 10:08 AM, Johan Hovold <johan@kernel.org> wrote:
>> Use the attribute groups of the led-class to create the time attribute
>> during probe in order to avoid racing with userspace.
>>
>> Signed-off-by: Johan Hovold <johan@kernel.org>
>
> Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
>

Good, I merged this patch with others into my for-next branch.

-Bryan

>> ---
>>  drivers/input/keyboard/lm8323.c | 22 +++++++++-------------
>>  1 file changed, 9 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/input/keyboard/lm8323.c b/drivers/input/keyboard/lm8323.c
>> index 0b42118cbf8f..cb32e2b506b7 100644
>> --- a/drivers/input/keyboard/lm8323.c
>> +++ b/drivers/input/keyboard/lm8323.c
>> @@ -558,6 +558,12 @@ static ssize_t lm8323_pwm_store_time(struct device *dev,
>>  }
>>  static DEVICE_ATTR(time, 0644, lm8323_pwm_show_time, lm8323_pwm_store_time);
>>
>> +static struct attribute *lm8323_pwm_attrs[] = {
>> +       &dev_attr_time.attr,
>> +       NULL
>> +};
>> +ATTRIBUTE_GROUPS(lm8323_pwm);
>> +
>>  static int init_pwm(struct lm8323_chip *lm, int id, struct device *dev,
>>                     const char *name)
>>  {
>> @@ -580,16 +586,11 @@ static int init_pwm(struct lm8323_chip *lm, int id, struct device *dev,
>>         if (name) {
>>                 pwm->cdev.name = name;
>>                 pwm->cdev.brightness_set = lm8323_pwm_set_brightness;
>> +               pwm->cdev.groups = lm8323_pwm_groups;
>>                 if (led_classdev_register(dev, &pwm->cdev) < 0) {
>>                         dev_err(dev, "couldn't register PWM %d\n", id);
>>                         return -1;
>>                 }
>> -               if (device_create_file(pwm->cdev.dev,
>> -                                       &dev_attr_time) < 0) {
>> -                       dev_err(dev, "couldn't register time attribute\n");
>> -                       led_classdev_unregister(&pwm->cdev);
>> -                       return -1;
>> -               }
>>                 pwm->enabled = true;
>>         }
>>
>> @@ -753,11 +754,8 @@ fail3:
>>         device_remove_file(&client->dev, &dev_attr_disable_kp);
>>  fail2:
>>         while (--pwm >= 0)
>> -               if (lm->pwm[pwm].enabled) {
>> -                       device_remove_file(lm->pwm[pwm].cdev.dev,
>> -                                          &dev_attr_time);
>> +               if (lm->pwm[pwm].enabled)
>>                         led_classdev_unregister(&lm->pwm[pwm].cdev);
>> -               }
>>  fail1:
>>         input_free_device(idev);
>>         kfree(lm);
>> @@ -777,10 +775,8 @@ static int lm8323_remove(struct i2c_client *client)
>>         device_remove_file(&lm->client->dev, &dev_attr_disable_kp);
>>
>>         for (i = 0; i < 3; i++)
>> -               if (lm->pwm[i].enabled) {
>> -                       device_remove_file(lm->pwm[i].cdev.dev, &dev_attr_time);
>> +               if (lm->pwm[i].enabled)
>>                         led_classdev_unregister(&lm->pwm[i].cdev);
>> -               }
>>
>>         kfree(lm);
>>
>> --
>> 1.8.5.5
>>
>
> Thanks.
>
> --
> Dmitry
