Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693AbaJNGEy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 02:04:54 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:40773 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753672AbaJNGEw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 02:04:52 -0400
MIME-Version: 1.0
In-Reply-To: <6c5c08b2a2924366ac79837e89d3a0ed@BL2FFO11FD056.protection.gbl>
References: <1409853506-26279-1-git-send-email-soren.brinkmann@xilinx.com>
 <CAAVeFuJdCd9Wx+Fq3_9okcnyva70zhZJ5njOho8pmPfgWG3+nA@mail.gmail.com> <6c5c08b2a2924366ac79837e89d3a0ed@BL2FFO11FD056.protection.gbl>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Tue, 14 Oct 2014 15:04:31 +0900
Message-ID: <CAAVeFuJJ8TGNDKA-MQa1_5sigvWXfOeBDsujmZ4GDBpkHDe+dw@mail.gmail.com>
Subject: Re: [PATCH RESEND] gpio: lib-sysfs: Add 'wakeup' attribute
To: =?UTF-8?Q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 8:47 AM, Sören Brinkmann
<soren.brinkmann@xilinx.com> wrote:
> Hi Alexandre,
>
> On Sat, 2014-10-11 at 01:54PM +0900, Alexandre Courbot wrote:
>> On Fri, Sep 5, 2014 at 2:58 AM, Soren Brinkmann
>> <soren.brinkmann@xilinx.com> wrote:
>> > Add an attribute 'wakeup' to the GPIO sysfs interface which allows
>> > marking/unmarking a GPIO as wake IRQ.
>> > The file 'wakeup' is created in each exported GPIOs directory, if an IRQ
>> > is associated with that GPIO and the irqchip implements set_wake().
>> > Writing 'enabled' to that file will enable wake for that GPIO, while
>> > writing 'disabled' will disable wake.
>> > Reading that file will return either 'disabled' or 'enabled' depening on
>> > the currently set flag for the GPIO's IRQ.
>> >
>> > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
>> > ---
>> > Hi all,
>> >
>> > I originally submitted this patch with a few fixes for Zynq's GPIO driver
>> > (https://lkml.org/lkml/2014/8/29/391). Since this change is not just
>> > Zynq-related and has broader impact, Linus asked me to post this again, separate
>> > from the Zynq series.
>> >
>> > Let me just quote myself from the original submission:
>> > "I'm still not fully convinced that the gpio_keys are the best
>> > replacement for the sysfs interface when it comes to inputs. For that
>> > reason and to have a way to do some quick wake testing, I'd like to
>> > propose adding the ability to control wake through the sysfs interface
>> > (patch 3)."
>>
>> I'm really sorry that I did not provide feedback sooner.  This is the
>> kind of area (IRQ) where I am not too confident and typically like to
>> hear what Linus has to say first. But I also have a few questions that
>> you could maybe answer for my own education. :)
>>
>> >
>> >         Thanks,
>> >         Sören
>> >
>> >  drivers/gpio/gpiolib-sysfs.c | 75 ++++++++++++++++++++++++++++++++++++++++----
>> >  1 file changed, 69 insertions(+), 6 deletions(-)
>> >
>> > diff --git a/drivers/gpio/gpiolib-sysfs.c b/drivers/gpio/gpiolib-sysfs.c
>> > index 5f2150b619a7..aaf021eaaff5 100644
>> > --- a/drivers/gpio/gpiolib-sysfs.c
>> > +++ b/drivers/gpio/gpiolib-sysfs.c
>> > @@ -286,6 +286,56 @@ found:
>> >
>> >  static DEVICE_ATTR(edge, 0644, gpio_edge_show, gpio_edge_store);
>> >
>> > +static ssize_t gpio_wakeup_show(struct device *dev,
>> > +               struct device_attribute *attr, char *buf)
>> > +{
>> > +       ssize_t                 status;
>> > +       const struct gpio_desc  *desc = dev_get_drvdata(dev);
>> > +       int                     irq = gpiod_to_irq(desc);
>> > +       struct irq_desc         *irq_desc = irq_to_desc(irq);
>> > +
>> > +       mutex_lock(&sysfs_lock);
>> > +
>> > +       if (irqd_is_wakeup_set(&irq_desc->irq_data))
>> > +               status = sprintf(buf, "enabled\n");
>> > +       else
>> > +               status = sprintf(buf, "disabled\n");
>> > +
>> > +       mutex_unlock(&sysfs_lock);
>> > +
>> > +       return status;
>> > +}
>> > +
>> > +static ssize_t gpio_wakeup_store(struct device *dev,
>> > +               struct device_attribute *attr, const char *buf, size_t size)
>> > +{
>> > +       int                     ret;
>> > +       unsigned int            on;
>> > +       struct gpio_desc        *desc = dev_get_drvdata(dev);
>> > +       int                     irq = gpiod_to_irq(desc);
>> > +
>> > +       mutex_lock(&sysfs_lock);
>> > +
>> > +       if (sysfs_streq("enabled", buf))
>> > +               on = true;
>> > +       else if (sysfs_streq("disabled", buf))
>> > +               on = false;
>> > +       else
>> > +               return -EINVAL;
>>
>> You forgot to release sysfs_lock before returning here.
>
> Right, I will fix this and send a v2. Good catch.
>
>>
>> > +
>> > +       ret = irq_set_irq_wake(irq, on);
>>
>> Just wondering: is it always safe to set the wake property of an IRQ
>> even if the direction of its associated GPIO is output? Does it make
>> sense at all to have the "wakeup" attribute file visible if the GPIO
>> is an output one?
>>
>> > +
>> > +       mutex_unlock(&sysfs_lock);
>> > +
>> > +       if (ret)
>> > +               pr_warn("%s: failed to %s wake\n", __func__,
>> > +                               on ? "enable" : "disable");
>> > +
>> > +       return size;
>> > +}
>> > +
>> > +static DEVICE_ATTR(wakeup, 0644, gpio_wakeup_show, gpio_wakeup_store);
>> > +
>> >  static int sysfs_set_active_low(struct gpio_desc *desc, struct device *dev,
>> >                                 int value)
>> >  {
>> > @@ -526,7 +576,7 @@ static struct class gpio_class = {
>> >  int gpiod_export(struct gpio_desc *desc, bool direction_may_change)
>> >  {
>> >         unsigned long           flags;
>> > -       int                     status;
>> > +       int                     status, irq;
>> >         const char              *ioname = NULL;
>> >         struct device           *dev;
>> >         int                     offset;
>> > @@ -582,11 +632,24 @@ int gpiod_export(struct gpio_desc *desc, bool direction_may_change)
>> >                         goto fail_unregister_device;
>> >         }
>> >
>> > -       if (gpiod_to_irq(desc) >= 0 && (direction_may_change ||
>> > -                                      !test_bit(FLAG_IS_OUT, &desc->flags))) {
>> > -               status = device_create_file(dev, &dev_attr_edge);
>> > -               if (status)
>> > -                       goto fail_unregister_device;
>> > +       irq = gpiod_to_irq(desc);
>> > +       if (irq >= 0) {
>> > +               struct irq_desc *irq_desc = irq_to_desc(irq);
>> > +               struct irq_chip *irqchip = irq_desc_get_chip(irq_desc);
>> > +
>> > +               if (direction_may_change ||
>> > +                               !test_bit(FLAG_IS_OUT, &desc->flags)) {
>> > +                       status = device_create_file(dev, &dev_attr_edge);
>> > +                       if (status)
>> > +                               goto fail_unregister_device;
>> > +               }
>> > +
>> > +               if (irqchip->flags & IRQCHIP_SKIP_SET_WAKE ||
>> > +                               irqchip->irq_set_wake) {
>> > +                       status = device_create_file(dev, &dev_attr_wakeup);
>> > +                       if (status)
>> > +                               goto fail_unregister_device;
>> > +               }
>>
>> Ok, I guess that answers my question. The edge property is always
>> visible so it probably doesn't hurt if the wakeup property also is.
>
> Right, it is probably not optimal, but serves the purpose. Users still
> might have to turn on their brain. But in general, setting those
> properties should be safe, IMHO.
> I think being able to mess with GPIO's direction and value is a much
> bigger risk since they might be used for something more critical than
> just LEDs :)
> So, this does not really add a lot of more potential to break things :)

Good point.

>
>>
>> The only thing that bothers me a little bit is that both "edge" and
>> "wakeup" are not very explicit names, but I guess it can't be helped.
>
> I guess edge is ABI and that ship has sailed. For 'wakeup' we can still
> discuss the name. But wakeup is the standard property that is exposed in
> sysfs for other devices that support wake and choose to expose
> user-space control for it. So, I thought 'wakeup' would be appropriate
> here as well.

... and another good point.

Let's see what Linus thinks about this, but as far as I'm concerned
your v2 looks ok.

Cheers,
Alex.
