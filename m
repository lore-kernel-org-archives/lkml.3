Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903Ab3BGG5z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 01:57:55 -0500
Received: from mail-ia0-f169.google.com ([209.85.210.169]:64662 "EHLO
	mail-ia0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab3BGG5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 01:57:53 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdbib-+pvMiLQN=f6d-1dhK2OK3znJeGoL7rDxDQYuJRuA@mail.gmail.com>
References: <1359822572-26009-1-git-send-email-acourbot@nvidia.com>
 <1359822572-26009-8-git-send-email-acourbot@nvidia.com> <CACRpkdbib-+pvMiLQN=f6d-1dhK2OK3znJeGoL7rDxDQYuJRuA@mail.gmail.com>
From: Alexandre Courbot <acourbot@nvidia.com>
Date: Thu, 7 Feb 2013 15:57:32 +0900
X-Google-Sender-Auth: 7QKCingGU_nRw7GQXE3K1q7RmrY
Message-ID: <CAAVeFu+phNtzzj7rw96g9iH8sj9gGqd5SfAqtkDHvu3PeL_oQA@mail.gmail.com>
Subject: Re: [PATCH 6/9] gpiolib: use descriptors internally
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 6, 2013 at 2:53 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Sat, Feb 2, 2013 at 5:29 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:
>
>> Make sure gpiolib works internally with descriptors and (chip, offset)
>> pairs instead of using the global integer namespace. This prepares the
>
> Its a numberspace not a namespace right?

Yes, absolutely.

>> +/*
>> + * Internal gpiod_* API using descriptors instead of the integer namespace.
>> + * Most of this should eventually go public.
>> + */
>> +static int gpiod_request(struct gpio_desc *desc, const char *label);
>> +static void gpiod_free(struct gpio_desc *desc);
>> +static int gpiod_direction_input(struct gpio_desc *desc);
>> +static int gpiod_direction_output(struct gpio_desc *desc, int value);
>> +static int gpiod_set_debounce(struct gpio_desc *desc, unsigned debounce);
>> +static int gpiod_get_value_cansleep(struct gpio_desc *desc);
>> +static void gpiod_set_value_cansleep(struct gpio_desc *desc, int value);
>> +static int gpiod_get_value(struct gpio_desc *desc);
>> +static void gpiod_set_value(struct gpio_desc *desc, int value);
>> +static int gpiod_cansleep(struct gpio_desc *desc);
>> +static int gpiod_to_irq(struct gpio_desc *desc);
>> +static int gpiod_export(struct gpio_desc *desc, bool direction_may_change);
>> +static int gpiod_export_link(struct device *dev, const char *name,
>> +                            struct gpio_desc *desc);
>> +static int gpiod_sysfs_set_active_low(struct gpio_desc *desc, int value);
>> +static void gpiod_unexport(struct gpio_desc *desc);
>
> Usually I don't like these upfrons forward-declarations, but in this
> case I *do* because they are here for a reason, to later become
> extern. So I like it!

Yeah, you know how the movie is going to end already. ;) Maybe it
would make sense to append the gpiod patches to this series and not
end up with these declarations?

>> +/*
>> + * Return the GPIO number of the passed descriptor relative to its chip
>> + */
>> +static int gpio_chip_hwgpio(const struct gpio_desc *desc)
>> +{
>> +       return (desc - &gpio_desc[0]) - desc->chip->base;
>> +}
>
> That was a scary method. But it works as long as the
> descriptors are in a static array I guess...

Yes, and it's becomes less scary when the static array goes away.

>> +/**
>> + * Convert a GPIO number to its descriptor
>> + */
>> +static struct gpio_desc *gpio_to_desc(unsigned gpio)
>> +{
>> +       if (WARN(!gpio_is_valid(gpio), "invalid GPIO %d\n", gpio))
>> +               return NULL;
>
> Don't we want to return ERR_PTR(-EINVAL); here?
>
> Then you can use IS_ERR() on the pointers later.
>
> This is the approach taken by the external API for clk
> and pins.

Yes, that completely makes sense.

>>  /* caller holds gpio_lock *OR* gpio is marked as requested */
>
> That comment should be above the *next* function right?
>
> Strictly speaking it does not apply to gpiod_to_chip() if
> I read it right.

That's right. On a related topic there are actually a whole set of
comments that are not in the right place (because the function that
follows them has been switched to the gpiod prefix). I left them here
because once the gpiod interface becomes public they will be updated
to apply to them, and moving comments back and forth in such a short
time would only make the patches confusing.

>>  static ssize_t gpio_direction_show(struct device *dev,
>>                 struct device_attribute *attr, char *buf)
>>  {
>> -       const struct gpio_desc  *desc = dev_get_drvdata(dev);
>> -       unsigned                gpio = desc - gpio_desc;
>> +       struct gpio_desc        *desc = dev_get_drvdata(dev);
>
> Why not const anymore?
>
> (Applies to all these similar cases in the patch.)
>
> consting is nice. Especially in subsystem code.
> I know it is hard to get compilation right without warnings
> at times. But it pays off.
>
> In the pinctrl subsystem I spend endless hours reading this
> wiki page:
>
> http://en.wikipedia.org/wiki/Const-correctness
>
> I still don't quite get it. And it also wears off. But I like to use it.

Oh I do share your love for const-correctness (look at the parameters
for gpio_chip_hwgpio() and desc_to_gpio()). Only here I could not
preserve it AFAICT.

The previous version of the function was only using desc locally and
relied on GPIO numbers to do the dirty job. Here however, we pass desc
to gpiod_get_direction(). So you will tell me, that as it only returns
the direction its parameter could also be const and that's true -
excepted when it tries to clear some bits in desc->flags, there we
definitely cannot claim it is const anymore. Maybe we could cast the
pointer given to clear_bit/set_bit, but I'm not sure that's more
elegant. Ideally gpiod_get_direction() should not modify its parameter
at all.

>> @@ -594,29 +647,32 @@ static ssize_t export_store(struct class *class,
>> +       desc = gpio_to_desc(gpio);
>
> I hope you have tested this hunk of the patch from userspace?
>
>> @@ -637,17 +694,18 @@ static ssize_t unexport_store(struct class *class,
>
> This too?
>
> (etc for the userspace interfaces)

Yes. Side-question: should I explicitly add my "Tested-by" in this
cases? I thought that the author's Signed-off implied that the patch
has been properly tested, but your question tend to suggest it's not
*that* obvious... ;)

>> +       if (status) {
>> +               int gpio = -1;
>> +               if (desc)
>> +                       gpio = desc_to_gpio(desc);
>>                 pr_debug("%s: gpio-%d status %d\n",
>>                         __func__, gpio, status);
>> +       }
>>         return status;
>>  }
>
> So using ERR_PTR/PTR_ERR helps you propagate
> errors in situations like these.
>
> Just:
>
> if (IS_ERR(desc))
>     status = PTR_ERR(desc);

Yes, that would make these blocks look much better.

>>         /* Open drain pin should not be driven to 1 */
>>         if (value && test_bit(FLAG_OPEN_DRAIN,  &desc->flags))
>> -               return gpio_direction_input(gpio);
>> +               return gpiod_direction_input(desc);
>>
>>         /* Open source pin should not be driven to 0 */
>>         if (!value && test_bit(FLAG_OPEN_SOURCE,  &desc->flags))
>> -               return gpio_direction_input(gpio);
>> +               return gpiod_direction_input(desc);
>>
>>         spin_lock_irqsave(&gpio_lock, flags);
>>
>> -       if (!gpio_is_valid(gpio))
>> +       if (!desc)
>
> if (IS_ERR(desc)) ?

It's worse actually, we potentially access desc right before checking
it it's not NULL... Makes no sense at all. Thanks for pointing this.

>> +       offset = gpio_chip_hwgpio(desc);
>
> Maybe rename to hwgpio? Or is that done later?
>
> We should stick with either hwgpio or offset everywhere or
> it will be a mess.

Will replace all these "offset" by "hwgpio" for consistency.

> Basically the patch is very nice but I'd like you to iron out and proofread
> as per above so we have strong consistency, strong const:ing,
> and stringent naming (offset vs hwgpio come to mind).

Yes, there are some inconsistencies (and "inconstistencies") that
remains, e.g. automatically converting calls to gpio_is_valid() into a
check that the descriptor is not NULL was not the best idea. I will
fix the patch according to your comments and then check the whole file
to make sure I have not missed anything. Might do some random
unrelated catches in the process.

Thanks for the review!
Alex.
