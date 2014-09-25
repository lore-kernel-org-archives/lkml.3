Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553AbaIYQ07 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 12:26:59 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:43481 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753094AbaIYQ06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 12:26:58 -0400
Message-ID: <54244243.3090904@ti.com>
Date: Thu, 25 Sep 2014 19:26:43 +0300
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: =?UTF-8?B?TG90aGFyIFdhw59tYW5u?= <LW@karo-electronics.de>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>
Subject: Re: [PATCH] gpio: pca953x: Fix warning when HW interrupts are rescheduled
 by the softirq tasklet
References: <1410251533-4990-1-git-send-email-LW@KARO-electronics.de>	<CACRpkdbTXtx+EU4Dw1fxeThRUG4s5XvcJnAJ9PJd8i4KKGC65A@mail.gmail.com>	<5421670D.10200@ti.com>	<CACRpkdYCsdMcJY7Y0gK4_zPxiWRFKkzi2TaZUi1Vn7Kp0Cbgzg@mail.gmail.com>	<5422B8F0.9060803@ti.com> <CACRpkdYtjQC_hCiqSB7fidct6CjJ5kMbj0PegW3MEuouBajv+g@mail.gmail.com>
In-Reply-To: <CACRpkdYtjQC_hCiqSB7fidct6CjJ5kMbj0PegW3MEuouBajv+g@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2014 11:07 AM, Linus Walleij wrote:
> On Wed, Sep 24, 2014 at 2:28 PM, Grygorii Strashko
> <grygorii.strashko@ti.com> wrote:
>> On 09/24/2014 02:17 PM, Linus Walleij wrote:
> 
>>> So PCA cannot use gpiochip_set_chained_irqchip()?
>>
>> Yes. It can't - pca is i2c device.
> 
> ? I don't get this statement.
> 
> Why does the fact that it is an I2C device matter?
> We have several devices that are in fact on top of
> I2C (albeit as MFD cells) like gpio-tc3589x.c.

gpio-tc3589x.c doesn't call gpiochip_set_chained_irqchip()

Chained IRQ handler replaces High level HW IRQ handler
(in case of ARM+GIC it replaces handle_fasteoi_irq() with custom handler)

The I2C devices require their IRQ handler to be interruptible and
allow to sleep, so Threaded IRQ handler should be used there.

By the way, gpiochip_set_chained_irqchip() has a blocking check inside:
	if (gpiochip->can_sleep) {
		chip_err(gpiochip, "you cannot have chained interrupts on a chip that may sleep\n");
		return;
	}

Actually, this issue can occur only with Nested IRQs (not chained). 

> 
>>> Anyway I feel I should fix this as per above for all
>>> chips using that function, right?
>>
>> Pls note, the gpiochip_irqchip_add() is called before
>> gpiochip_set_chained_irqchip() in all places now.
> 
> Yes, but the .map function isn't called until a client
> wants to use an IRQ. And that won't happen until after
> we exit the whole .probe() function.

.map function is called from irq_create_mapping() which,
in turn, can be called as from irq_domain_add_simple() -
as result .map will be always called from gpiochip_irqchip_add().

> 
>> Also seems, we should assume that
>> gpiochip_set_chained_irqchip() can be called
>> few times and it could be unsafe to use it for storing parent_irq.
> 
> Well it happens in one single driver, and was done by me.
> Maybe I should either disallow that, as that means we're adding
> multiple parents (which is what you want, right?) or actually
> implement it in a way so that multiple parents can be handled
> by the helpers, by adding the parents to a list or something.


Sorry, but It seems the simplest way is to allow drivers to manage
parent IRQs for the complex cases. So, I vote for custom .map()
callback, but It could be not too simple to implement it, because
private driver data need to be passed as parameter to this callback
somehow.

Of course, final decision is up to you and may be it would be ok
to fix just simple case (one parent IRQ) in short term perspective. 

=== Simple one - driver need to set parent_irq before adding gpiochip ===

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 8aa84d5..292840b 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -447,8 +447,11 @@ static int gpiochip_irq_map(struct irq_domain *d, unsigned int irq,
        irq_set_lockdep_class(irq, &gpiochip_irq_lock_class);
        irq_set_chip_and_handler(irq, chip->irqchip, chip->irq_handler);
        /* Chips that can sleep need nested thread handlers */
-       if (chip->can_sleep)
+       if (chip->can_sleep) {
                irq_set_nested_thread(irq, 1);
+               if (chip->parent_irq)
+                       irq_set_parent(irq, chip->parent_irq);
+       }
 #ifdef CONFIG_ARM
        set_irq_flags(irq, IRQF_VALID);
 #else
diff --git a/include/linux/gpio/driver.h b/include/linux/gpio/driver.h
index 976276a..88486c7 100644
--- a/include/linux/gpio/driver.h
+++ b/include/linux/gpio/driver.h
@@ -112,6 +112,7 @@ struct gpio_chip {
        struct irq_domain       *irqdomain;
        irq_flow_handler_t      irq_handler;
        unsigned int            irq_default_type;
+       int                     parent_irq;
 #endif
 
 #if defined(CONFIG_OF_GPIO)


> 
>> So maybe it would be enough to just adding field for parent_irq
>> in struct gpio_chip + fix for gpiochip_irq_map() to re-use it
>> (to fix simple cases :).
> 
> Yes for the simple case. But maybe it's better to patch
> gpiochip_set_chained_irqchip() to handle also the complex
> case per above?

As I mentioned above gpiochip_set_chained_irqchip() can't be
used for GPIO chips which set .can_sleep = true.

Regards,
-grygorii

