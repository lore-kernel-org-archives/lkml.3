Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751056AbaEYQks (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 12:40:48 -0400
Received: from mail-qg0-f42.google.com ([209.85.192.42]:59326 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbaEYQkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 12:40:46 -0400
MIME-Version: 1.0
In-Reply-To: <CAAVeFu+A7=51KqJNxc2LirZVc5zfBv_tny4_vCFaLaUsQqEnGA@mail.gmail.com>
References: <1400865144-27970-1-git-send-email-berthe.ab@gmail.com>
	<CAAVeFu+A7=51KqJNxc2LirZVc5zfBv_tny4_vCFaLaUsQqEnGA@mail.gmail.com>
Date: Sun, 25 May 2014 18:40:45 +0200
Message-ID: <CABprBybqJvXU0dbXiq15GtUTjeLsxDyvyKmCEbZPJwq4sgcyZA@mail.gmail.com>
Subject: Re: [PATCH] gpio: gpiolib: set gpiochip_remove retval to void
From: abdoulaye berthe <berthe.ab@gmail.com>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, ignoring the return value as it is done in gpio-bt8xx makes the
compiler complain and display a warning message. The problem with
false warning is that it might distract you. I think that the patch
will makes things consistent once completed
Thanks a lot for the review.

On Sun, May 25, 2014 at 9:46 AM, Alexandre Courbot <gnurou@gmail.com> wrote:
> On Sat, May 24, 2014 at 2:12 AM, abdoulaye berthe <berthe.ab@gmail.com> wrote:
>> This avoids handling gpiochip remove error in device
>> remove handler.
>
> Be aware that at the moment many callers of gpiochip_remove() read its
> return value. So applying your patch as-is would break compilation.
>
> This patch should therefore be the last of a series that first
> modifies all callers of gpiochip_remove() to ignore its return value,
> then neutralizes the function itself.
>
> I am not sure whether the world would really be a better place after
> this though. Callers that don't need the return value of
> gpiochip_remove() can simply ignore it...
>
>>
>> Signed-off-by: abdoulaye berthe <berthe.ab@gmail.com>
>> ---
>>  drivers/gpio/gpiolib.c      | 24 +++++++-----------------
>>  include/linux/gpio/driver.h |  2 +-
>>  2 files changed, 8 insertions(+), 18 deletions(-)
>>
>> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
>> index f48817d..4878980 100644
>> --- a/drivers/gpio/gpiolib.c
>> +++ b/drivers/gpio/gpiolib.c
>> @@ -1263,10 +1263,9 @@ static void gpiochip_irqchip_remove(struct gpio_chip *gpiochip);
>>   *
>>   * A gpio_chip with any GPIOs still requested may not be removed.
>>   */
>> -int gpiochip_remove(struct gpio_chip *chip)
>> +void gpiochip_remove(struct gpio_chip *chip)
>>  {
>>         unsigned long   flags;
>> -       int             status = 0;
>>         unsigned        id;
>>
>>         acpi_gpiochip_remove(chip);
>> @@ -1278,24 +1277,15 @@ int gpiochip_remove(struct gpio_chip *chip)
>>         of_gpiochip_remove(chip);
>>
>>         for (id = 0; id < chip->ngpio; id++) {
>> -               if (test_bit(FLAG_REQUESTED, &chip->desc[id].flags)) {
>> -                       status = -EBUSY;
>> -                       break;
>> -               }
>> -       }
>> -       if (status == 0) {
>> -               for (id = 0; id < chip->ngpio; id++)
>> -                       chip->desc[id].chip = NULL;
>> -
>> -               list_del(&chip->list);
>> +               if (test_bit(FLAG_REQUESTED, &chip->desc[id].flags))
>> +                       panic("gpiolib.c: gpiochip is still requested\n");
>
> panic() sounds a little harsh here. Maybe a dev_err() would be enough?
>
>>         }
>> +       for (id = 0; id < chip->ngpio; id++)
>> +               chip->desc[id].chip = NULL;
>>
>> +       list_del(&chip->list);
>>         spin_unlock_irqrestore(&gpio_lock, flags);
>> -
>> -       if (status == 0)
>> -               gpiochip_unexport(chip);
>> -
>> -       return status;
>> +       gpiochip_unexport(chip);
>>  }
>>  EXPORT_SYMBOL_GPL(gpiochip_remove);
>>
>> diff --git a/include/linux/gpio/driver.h b/include/linux/gpio/driver.h
>> index 1827b43..72ed256 100644
>> --- a/include/linux/gpio/driver.h
>> +++ b/include/linux/gpio/driver.h
>> @@ -138,7 +138,7 @@ extern const char *gpiochip_is_requested(struct gpio_chip *chip,
>>
>>  /* add/remove chips */
>>  extern int gpiochip_add(struct gpio_chip *chip);
>> -extern int __must_check gpiochip_remove(struct gpio_chip *chip);
>> +void gpiochip_remove(struct gpio_chip *chip);
>
> "extern" should be preserved here for style consistency.
