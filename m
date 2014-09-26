Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022AbaIZJHp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:07:45 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:57152 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbaIZJHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:07:41 -0400
MIME-Version: 1.0
In-Reply-To: <54244243.3090904@ti.com>
References: <1410251533-4990-1-git-send-email-LW@KARO-electronics.de>
	<CACRpkdbTXtx+EU4Dw1fxeThRUG4s5XvcJnAJ9PJd8i4KKGC65A@mail.gmail.com>
	<5421670D.10200@ti.com>
	<CACRpkdYCsdMcJY7Y0gK4_zPxiWRFKkzi2TaZUi1Vn7Kp0Cbgzg@mail.gmail.com>
	<5422B8F0.9060803@ti.com>
	<CACRpkdYtjQC_hCiqSB7fidct6CjJ5kMbj0PegW3MEuouBajv+g@mail.gmail.com>
	<54244243.3090904@ti.com>
Date: Fri, 26 Sep 2014 11:07:41 +0200
Message-ID: <CACRpkdahDFpP_3eJuAweYua4Cp2iJAd1BDUQHJ90O_bU3cuheg@mail.gmail.com>
Subject: Re: [PATCH] gpio: pca953x: Fix warning when HW interrupts are
 rescheduled by the softirq tasklet
From: Linus Walleij <linus.walleij@linaro.org>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: =?UTF-8?Q?Lothar_Wa=C3=9Fmann?= <LW@karo-electronics.de>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 6:26 PM, Grygorii Strashko
<grygorii.strashko@ti.com> wrote:
> On 09/25/2014 11:07 AM, Linus Walleij wrote:
>> On Wed, Sep 24, 2014 at 2:28 PM, Grygorii Strashko
>> <grygorii.strashko@ti.com> wrote:
>>> On 09/24/2014 02:17 PM, Linus Walleij wrote:
>>
>>>> So PCA cannot use gpiochip_set_chained_irqchip()?
>>>
>>> Yes. It can't - pca is i2c device.
>>
>> ? I don't get this statement.
>>
>> Why does the fact that it is an I2C device matter?
>> We have several devices that are in fact on top of
>> I2C (albeit as MFD cells) like gpio-tc3589x.c.
>
> gpio-tc3589x.c doesn't call gpiochip_set_chained_irqchip()

Ah yeah you're right of course. I considered adding a separate
registration function for the sleeping handlers, like
gpiochip_set_threaded_irqchip() that would handle
setting up the nested case.

>> Yes, but the .map function isn't called until a client
>> wants to use an IRQ. And that won't happen until after
>> we exit the whole .probe() function.
>
> .map function is called from irq_create_mapping() which,
> in turn, can be called as from irq_domain_add_simple() -
> as result .map will be always called from gpiochip_irqchip_add().

Ah yeah you're right, I was just wrong here :-/

>> Well it happens in one single driver, and was done by me.
>> Maybe I should either disallow that, as that means we're adding
>> multiple parents (which is what you want, right?) or actually
>> implement it in a way so that multiple parents can be handled
>> by the helpers, by adding the parents to a list or something.
>
> Sorry, but It seems the simplest way is to allow drivers to manage
> parent IRQs for the complex cases. So, I vote for custom .map()
> callback, but It could be not too simple to implement it, because
> private driver data need to be passed as parameter to this callback
> somehow.

Yeah. Well what I'm thinking as subsystem maintainer, is that
when I added the generic GPIOlib irqchip helpers we managed to
smoke out a large:ish set of subtle bugs that different drivers
had created independently of each other.

So centralizing code is very important if at all possible to bring
down the maintainer burden.

So for that reason I'm looking a second and a third time at these
things before going ahead with custom code in drivers...

> === Simple one - driver need to set parent_irq before adding gpiochip ===
>
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index 8aa84d5..292840b 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -447,8 +447,11 @@ static int gpiochip_irq_map(struct irq_domain *d, unsigned int irq,
>         irq_set_lockdep_class(irq, &gpiochip_irq_lock_class);
>         irq_set_chip_and_handler(irq, chip->irqchip, chip->irq_handler);
>         /* Chips that can sleep need nested thread handlers */
> -       if (chip->can_sleep)
> +       if (chip->can_sleep) {
>                 irq_set_nested_thread(irq, 1);
> +               if (chip->parent_irq)
> +                       irq_set_parent(irq, chip->parent_irq);
> +       }

Yeah I need to think of something like this...

Yours,
Linus Walleij
