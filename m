Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345Ab3H2KYR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 06:24:17 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:44615 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755524Ab3H2KYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 06:24:16 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdYTytiOd=Lhb84XTKZpOWe20sqFxzwNf_0U8hvoy5deUA@mail.gmail.com>
References: <1377370108-2867-1-git-send-email-daniel.santos@pobox.com>
 <1377377305-11695-1-git-send-email-daniel.santos@pobox.com> <CACRpkdYTytiOd=Lhb84XTKZpOWe20sqFxzwNf_0U8hvoy5deUA@mail.gmail.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Thu, 29 Aug 2013 19:23:55 +0900
Message-ID: <CAAVeFuKtP_NGOTfgcHmGwr36d2VuRQ3Aq2gQu-Jom2P1C=Gn=A@mail.gmail.com>
Subject: Re: [PATCH] gpiolib: Fix crash when exporting non-existant gpio
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Daniel Santos <daniel.santos@pobox.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 6:52 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Sat, Aug 24, 2013 at 10:48 PM,  <danielfsantos@att.net> wrote:
>
>> [  222.961384] Unable to handle kernel NULL pointer dereference at
>> virtual address 00000044
>> [  222.969486] pgd = d97d0000
>> [  222.972190] [00000044] *pgd=1aaca831, *pte=00000000, *ppte=00000000
>> [  222.978483] Internal error: Oops: 17 [#1] PREEMPT ARM
>> ---
>>  drivers/gpio/gpiolib.c | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
>> index d6413b2..db7c6bb 100644
>> --- a/drivers/gpio/gpiolib.c
>> +++ b/drivers/gpio/gpiolib.c
>> @@ -123,7 +123,8 @@ static int gpio_chip_hwgpio(const struct gpio_desc *desc)
>>   */
>>  static struct gpio_desc *gpio_to_desc(unsigned gpio)
>>  {
>> -       if (WARN(!gpio_is_valid(gpio), "invalid GPIO %d\n", gpio))
>> +       if (WARN(!gpio_is_valid(gpio) || !gpio_desc[gpio].chip,
>> +                       "invalid GPIO %d\n", gpio))
>>                 return NULL;
>>         else
>>                 return &gpio_desc[gpio];
>> @@ -1406,8 +1407,7 @@ static int gpiod_request(struct gpio_desc *desc, const char *label)
>>         spin_lock_irqsave(&gpio_lock, flags);
>>
>>         chip = desc->chip;
>> -       if (chip == NULL)
>> -               goto done;
>> +       BUG_ON(!chip);
>
> It'd be good if Alexandre took a look at this.
>
> BUG_ON() is pretty nasty, atleast replace it with
> a warning.

Agreed - that's a cheap way to crash the kernel. desc_to_gpio()
assumes a valid descriptor, so we should not call it from contexts
where we know the descriptor may be invalid. How about having the
initial "if (!desc)" changed into "if (!desc || !desc->chip)" instead?
That way an error would be returned immediatly and we would know we
have a valid descriptor after that.

Having gpio_to_desc() return NULL if the descriptor does not have a
chip associated also seems to make sense - otherwise the caller should
check it itself. I'd even go as far as saying the check should be done
in gpio_is_valid itself.

There is probably a lot more potential to improve error handling in
gpiolib. Generally speaking, moving safety checks to a lower-level and
propagating error codes accordingly should be the right approach, as
long as it doesn't clutter performance. We want to be able to assume
that GPIO descriptors are valid in most of the code.

Alex.
