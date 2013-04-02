Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760750Ab3DBIzf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 04:55:35 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:63577 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759702Ab3DBIzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 04:55:32 -0400
MIME-Version: 1.0
In-Reply-To: <1364470847.2340.16.camel@thloh-virtual-machine>
References: <1363066655-17474-1-git-send-email-thloh@altera.com>
	<CACRpkdZY0sZUK_9ZX8rBOExVRPQL=UeoAWT=O1NZX2wTJGQLsA@mail.gmail.com>
	<1364470847.2340.16.camel@thloh-virtual-machine>
Date: Tue, 2 Apr 2013 10:55:32 +0200
Message-ID: <CACRpkdbF_CHmfbumKYf751wpW7dX=bF6cD-V3Y=jvsGQ21bPew@mail.gmail.com>
Subject: Re: [PATCH 1/1] drivers/gpio: Altera soft IP GPIO driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Tien Hock Loh <thloh@altera.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 28, 2013 at 12:40 PM, Tien Hock Loh <thloh@altera.com> wrote:

>> (...)
>> > +Altera GPIO specific properties:
>> > +- width: Width of the GPIO bank, range from 1-32
>> > +- level_trigger: Specifies whether the GPIO interrupt is level trigger.
>> > +  This field is required if the Altera GPIO controller used has IRQ enabled.
>>
>> This is a configuration for the irc_chip portion of the driver
>> I guess, isn't the usual custom that you don't set up
>> things like this from the device tree, but instead use the
>> kernels facilities on request_irq() such as:
>>
>> #define IRQF_TRIGGER_NONE       0x00000000
>> #define IRQF_TRIGGER_RISING     0x00000001
>> #define IRQF_TRIGGER_FALLING    0x00000002
>> #define IRQF_TRIGGER_HIGH       0x00000004
>> #define IRQF_TRIGGER_LOW        0x00000008
>>
>> ?
>>
>> I.e. that this is something you do at runtime and not a static
>> config from the device tree?
>>
>> Or shall this be percieved as some kind of default setting?
>
> The Altera GPIO IP cannot be software configurable. It is determined by
> the tool that generates the hardware, and thus I've put this as device
> tree parameter. If I understand correctly, if we implement using
> irq_set_type, it should be software configurable.
>
> Technically it can still be implemented in irq_set_type, I'm just not
> sure if it is the correct way, because the trigger type cannot be "set"
> in Altera GPIO. Please let me know if you think this should still be
> implemented as irq_set_type.

Hm I must be getting things wrong. It's correct that the driver
needs to keep track of if a certain IRQ line has a certain
trigger characteristic. So the member in this struct:

+struct altera_gpio_chip {
+       struct of_mm_gpio_chip mmchip;
+       struct irq_domain *irq; /* GPIO controller IRQ number */
+       spinlock_t gpio_lock;   /* Lock used for synchronization */
+       int level_trigger;

Is OK. But it should definately be a bool instead.

Then the irq_set_type() should check if the requested type is available.

You state that some interrupts are edge triggered, so this is
clearly wrong:

+static int altera_gpio_irq_set_type(struct irq_data *d,
+                               unsigned int type)
+{
+       if (type == IRQ_TYPE_NONE)
+               return 0;
+       return -EINVAL;
+}

I think it should rather be something like:

static int altera_gpio_irq_set_type(struct irq_data *d,
                               unsigned int type)
{
       struct altera_gpio_chip *a = irq_data_get_irq_chip_data(d);

       if (a->level_trigger) {
           if (type == IRQ_TYPE_LEVEL_HIGH)
              /* Configure the IRQ for high level */
           else if (type == IRQ_TYPE_LEVEL_LOW)
              /* Configure the IRQ for low level */
           else
             return -EINVAL;
       } else {
           /* assume it's edge triggered? */
           if (type == IRQ_TYPE_EDGE_RISING)
              /* Configure for rising edge */
           else if (type == IRQ_TYPE_EDGE_FALLING)
              /* Configure for falling edge */
           else
                return -EINVAL;
       }
}

As you can see from above a few new questions arise.

When you say an IRQ is "level trigged" does it actually mean
it is high or low level triggered? Or is this somehow configurable?

If it is *not* edge triggered, is it then implicitly edge
triggered?

If it is then implicitly edge triggered, does it trigger on
rising or falling edges or is this configurable?

As you see, the .irq_set_type needs to reflect what the
hardware can actually react to, and return errors on the
rest.

The current implementation which states that the hardware
cannot react to any IRQ is clearly wrong.

Yours,
Linus Walleij
