Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304AbaFIVWM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 17:22:12 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:41229 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbaFIVWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 17:22:08 -0400
MIME-Version: 1.0
In-Reply-To: <CAAVeFu+ZWy1He1CxTh+GmHtwow0P=vX_9u0P67-p_ntpqDQGtg@mail.gmail.com>
References: <CAAVeFuLMLfa-1RhcdSrKDUz7=eLqZurBSFSsN7N0x-0S+_btJA@mail.gmail.com>
	<1401906155-10543-1-git-send-email-berthe.ab@gmail.com>
	<1401906155-10543-3-git-send-email-berthe.ab@gmail.com>
	<CAAVeFu+ZWy1He1CxTh+GmHtwow0P=vX_9u0P67-p_ntpqDQGtg@mail.gmail.com>
Date: Mon, 9 Jun 2014 23:22:06 +0200
Message-ID: <CABprByZ0Y3ZxpEwjTUL8hkOrzT6uJoSg+eGRZfjtMjizXfO6fw@mail.gmail.com>
Subject: Re: [PATCH 2/2] gpio: gpiolib: set gpiochip_remove retval to void
From: abdoulaye berthe <berthe.ab@gmail.com>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, m@bues.ch,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

How about using the interface tracker described in the link bellow ?
https://lkml.org/lkml/2014/5/5/55
Abdoulaye.



On Sun, Jun 8, 2014 at 2:12 PM, Alexandre Courbot <gnurou@gmail.com> wrote:
> On Thu, Jun 5, 2014 at 3:22 AM, abdoulaye berthe <berthe.ab@gmail.com> wrote:
>> This avoids handling gpiochip remove error in device
>> remove handler.
>>
>> Signed-off-by: abdoulaye berthe <berthe.ab@gmail.com>
>> ---
>>  drivers/gpio/gpiolib.c      | 24 +++++++-----------------
>>  include/linux/gpio/driver.h |  2 +-
>>  2 files changed, 8 insertions(+), 18 deletions(-)
>>
>> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
>> index f48817d..022543f 100644
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
>> +                       panic("gpio: removing gpiochip with gpios still requested\n");
>
> Really, really I don't think we should panic here. Apparently if you
> don't do this things are going to crash later on some platforms. Could
> you detail what the problem is exactly so we can try and come with a
> solution?
>
> Event if we crash later with a more obscure reason, using pr_err()
> here to provide some information should be helpful enough.
>
> Alex.
