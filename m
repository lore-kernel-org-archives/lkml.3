Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446Ab3LBKut (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 05:50:49 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:3365 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198Ab3LBKup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 05:50:45 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 02 Dec 2013 02:47:55 -0800
Message-ID: <529C6601.8050105@nvidia.com>
Date: Mon, 2 Dec 2013 19:50:41 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Andy Shevchenko <andy.shevchenko@gmail.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Rhyland Klein <rklein@nvidia.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gpio: better lookup method for platform GPIOs
References: <1385628388-23827-1-git-send-email-acourbot@nvidia.com> <CAHp75VcHa7cxAt_utwMVp7j+YeKcqa0_N5B=7-ZmTMD_6AV1Lw@mail.gmail.com>
In-Reply-To: <CAHp75VcHa7cxAt_utwMVp7j+YeKcqa0_N5B=7-ZmTMD_6AV1Lw@mail.gmail.com>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2013 12:54 AM, Andy Shevchenko wrote:
> On Thu, Nov 28, 2013 at 10:46 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:
>> Change the format of the platform GPIO lookup tables to make them less
>> confusing and improve lookup efficiency.
>>
>> The previous format was a single linked-list that required to compare
>> the device name and function ID of every single GPIO defined for each
>> lookup. Switch that to a list of per-device tables, so that the lookup
>> can be done in two steps, omitting the GPIOs that are not relevant for a
>> particular device.
>>
>> The matching rules are now defined as follows:
>> - The device name must match *exactly*, and can be NULL for GPIOs not
>>    assigned to a particular device,
>> - If the function ID in the lookup table is NULL, the con_id argument of
>>    gpiod_get() will not be used for lookup. However, if it is defined, it
>>    must match exactly.
>> - The index must always match.
>
> Thanks for that, since I'm also was a bit confused of those dev_id/con_id stuff.
> Few comments below (mostly about style).
>
>
>> --- a/Documentation/gpio/board.txt
>> +++ b/Documentation/gpio/board.txt
>
>> @@ -88,16 +89,20 @@ Note that GPIO_LOOKUP() is just a shortcut to GPIO_LOOKUP_IDX() where idx = 0.
>>
>>   A lookup table can then be defined as follows:
>>
>> -       struct gpiod_lookup gpios_table[] = {
>> -       GPIO_LOOKUP_IDX("gpio.0", 15, "foo.0", "led", 0, GPIO_ACTIVE_HIGH),
>> -       GPIO_LOOKUP_IDX("gpio.0", 16, "foo.0", "led", 1, GPIO_ACTIVE_HIGH),
>> -       GPIO_LOOKUP_IDX("gpio.0", 17, "foo.0", "led", 2, GPIO_ACTIVE_HIGH),
>> -       GPIO_LOOKUP("gpio.0", 1, "foo.0", "power", GPIO_ACTIVE_LOW),
>> -       };
>> +struct gpiod_lookup_table gpios_table = {
>> +       .dev_id = "foo.0",
>> +       .size = 4,
>> +       .table = {
>> +       GPIO_LOOKUP_IDX("gpio.0", 15, "led", 0, GPIO_ACTIVE_HIGH),
>> +       GPIO_LOOKUP_IDX("gpio.0", 16, "led", 1, GPIO_ACTIVE_HIGH),
>> +       GPIO_LOOKUP_IDX("gpio.0", 17, "led", 2, GPIO_ACTIVE_HIGH),
>> +       GPIO_LOOKUP("gpio.0", 1, "power", GPIO_ACTIVE_LOW),
>
> Can you use deeper indentation for GPIO_* lines here?

Fixed.

>> --- a/drivers/gpio/gpiolib.c
>> +++ b/drivers/gpio/gpiolib.c
>
>> @@ -2326,72 +2322,77 @@ static struct gpio_desc *acpi_find_gpio(struct device *dev, const char *con_id,
>>          return desc;
>>   }
>>
>> -static struct gpio_desc *gpiod_find(struct device *dev, const char *con_id,
>> -                                   unsigned int idx,
>> -                                   enum gpio_lookup_flags *flags)
>> +static struct gpiod_lookup_table *gpiod_find_lookup_table(struct device *dev)
>>   {
>>          const char *dev_id = dev ? dev_name(dev) : NULL;
>> -       struct gpio_desc *desc = ERR_PTR(-ENODEV);
>> -       unsigned int match, best = 0;
>> -       struct gpiod_lookup *p;
>> +       struct gpiod_lookup_table *table;
>>
>>          mutex_lock(&gpio_lookup_lock);
>>
>> -       list_for_each_entry(p, &gpio_lookup_list, list) {
>> -               match = 0;
>> +       list_for_each_entry(table, &gpio_lookup_list, list) {
>> +               if (table->dev_id && dev_id && strcmp(table->dev_id, dev_id))
>
> Maybe check !dev_id outside of loop?

And create two loops, one for each case? Might complicate the code for 
little benefit IMHO, but please elaborate if I missed your point.

>
>> +                       continue;
>>
>> -               if (p->dev_id) {
>> -                       if (!dev_id || strcmp(p->dev_id, dev_id))
>> -                               continue;
>> +               if (dev_id != table->dev_id)
>> +                       continue;
>>
>> -                       match += 2;
>> -               }
>> +               return table;
>
> What  about
>
> if (dev_id == table->dev_id)
>   return table;
>
> ?

Actually my algorithm is broken to start with - and dangerous, as the 
missed mutex_unlock() you spotted later testifies. I will rewrite it in 
a (hopefully) sounder way.

>> +static struct gpio_desc *gpiod_find(struct device *dev, const char *con_id,
>> +                                   unsigned int idx,
>> +                                   enum gpio_lookup_flags *flags)
>> +{
>> +       struct gpio_desc *desc = ERR_PTR(-ENODEV);
>> +       struct gpiod_lookup_table *table;
>> +       int i;
>>
>> -               if (match > best) {
>> -                       struct gpio_chip *chip;
>>
>
> Looks like redundant empty line.

Fixed.

>
>> -                       chip = find_chip_by_name(p->chip_label);
>> +       table = gpiod_find_lookup_table(dev);
>> +       if (!table)
>> +               return desc;
>>
>> -                       if (!chip) {
>> -                               dev_warn(dev, "cannot find GPIO chip %s\n",
>> -                                        p->chip_label);
>> -                               continue;
>> -                       }
>> +       for (i = 0; i < table->size; i++) {
>> +               struct gpio_chip *chip;
>> +               struct gpiod_lookup *p = &table->table[i];
>>
>> -                       if (chip->ngpio <= p->chip_hwnum) {
>> -                               dev_warn(dev, "GPIO chip %s has %d GPIOs\n",
>> -                                        chip->label, chip->ngpio);
>> +               if (p->idx != idx)
>> +                       continue;
>> +
>> +               if (p->con_id) {
>> +                       if (!con_id || strcmp(p->con_id, con_id))
>
> Could be one 'if' and moreover !con_id check might be outside a loop.

Again, wouldn't that require two separate loops?


