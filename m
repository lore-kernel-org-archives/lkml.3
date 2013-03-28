Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321Ab3C1Lk5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 07:40:57 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:19038 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754718Ab3C1Lkz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 07:40:55 -0400
X-Forefront-Antispam-Report: CIP:66.35.236.232;KIP:(null);UIP:(null);IPV:NLI;H:SJ-ITEXEDGE02.altera.priv.altera.com;RD:none;EFVD:NLI
X-SpamScore: -12
X-BigFish: VS-12(zz98dI9371I936eI148cI1432Iea8N1447Izz1f42h1fc6h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2fh2a8h668h839h93fhd24hd2bhf0ah107ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
Message-ID: <1364470847.2340.16.camel@thloh-virtual-machine>
Subject: Re: [PATCH 1/1] drivers/gpio: Altera soft IP GPIO driver
From: Tien Hock Loh <thloh@altera.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>
Date: Thu, 28 Mar 2013 19:40:47 +0800
In-Reply-To: <CACRpkdZY0sZUK_9ZX8rBOExVRPQL=UeoAWT=O1NZX2wTJGQLsA@mail.gmail.com>
References: <1363066655-17474-1-git-send-email-thloh@altera.com>
	 <CACRpkdZY0sZUK_9ZX8rBOExVRPQL=UeoAWT=O1NZX2wTJGQLsA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-27 at 12:58 +0100, Linus Walleij wrote:
> On Tue, Mar 12, 2013 at 6:37 AM,  <thloh@altera.com> wrote:
> 
> > From: Tien Hock Loh <thloh@altera.com>
> >
> > Adds a new driver for Altera soft GPIO IP. The driver is able to
> > do read/write and allows GPIO to be a interrupt controller.
> >
> > Tested on Altera GHRD on interrupt handling and IO.
> >
> > Signed-off-by: Tien Hock Loh <thloh@altera.com>
> > ---
> >  .../devicetree/bindings/gpio/gpio-altera.txt       |  37 +++
> 
> Patches containing device tree bindings shall be CC:ed to devicetree-discuss
> (added on CC here, remember at next posting).

Noted. Thanks for the info. 

> 
> (...)
> > diff --git a/Documentation/devicetree/bindings/gpio/gpio-altera.txt b/Documentation/devicetree/bindings/gpio/gpio-altera.txt
> > new file mode 100644
> > index 0000000..3bdb8b6
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/gpio/gpio-altera.txt
> > @@ -0,0 +1,37 @@
> > +Altera GPIO controller bindings
> > +
> > +Required properties:
> > +- compatible:
> > +  - "altr,pio-1.0"
> > +- reg: Physical base address and length of the controller's registers.
> > +- #gpio-cells : Should be two.
> > +  - first cell is the pin number
> 
> What does that mean? The GPIO subsystem is not referring
> to pins, it's about "gpios" which are just a handler or number.
> 
> It can be a local offset into the numberspace representiong
> the GPIO lines at this block, I guess that is what is meant
> here.

Yes that's what I was trying to describe. I'll fix this in the next
patch.

> 
> (...)
> > +Altera GPIO specific properties:
> > +- width: Width of the GPIO bank, range from 1-32
> > +- level_trigger: Specifies whether the GPIO interrupt is level trigger.
> > +  This field is required if the Altera GPIO controller used has IRQ enabled.
> 
> This is a configuration for the irc_chip portion of the driver
> I guess, isn't the usual custom that you don't set up
> things like this from the device tree, but instead use the
> kernels facilities on request_irq() such as:
> 
> #define IRQF_TRIGGER_NONE       0x00000000
> #define IRQF_TRIGGER_RISING     0x00000001
> #define IRQF_TRIGGER_FALLING    0x00000002
> #define IRQF_TRIGGER_HIGH       0x00000004
> #define IRQF_TRIGGER_LOW        0x00000008
> 
> ?
> 
> I.e. that this is something you do at runtime and not a static
> config from the device tree?
> 
> Or shall this be percieved as some kind of default setting?

The Altera GPIO IP cannot be software configurable. It is determined by
the tool that generates the hardware, and thus I've put this as device
tree parameter. If I understand correctly, if we implement using
irq_set_type, it should be software configurable.

Technically it can still be implemented in irq_set_type, I'm just not
sure if it is the correct way, because the trigger type cannot be "set"
in Altera GPIO. Please let me know if you think this should still be
implemented as irq_set_type.

> 
> (...)
> > +++ b/drivers/gpio/gpio-altera.c
> 
> > +struct altera_gpio_chip {
> > +       struct of_mm_gpio_chip mmchip;
> > +       struct irq_domain *irq; /* GPIO controller IRQ number */
> > +       spinlock_t gpio_lock;   /* Lock used for synchronization */
> > +       int level_trigger;
> 
> I doubt this member of the struct. The irq core shall keep track
> of stuff like this.
> 

We shouldn't be adding anything to the gpio chip struct and has to
follow exactly how the irq core defines it?

> > +       int hwirq;
> > +};
> 
> (then follows some real nice code using irqdomain in a professional
> way, thanks for doing this!)
> 
> > +static int altera_gpio_irq_set_type(struct irq_data *d,
> > +                               unsigned int type)
> > +{
> > +       if (type == IRQ_TYPE_NONE)
> > +               return 0;
> > +       return -EINVAL;
> > +}
> 
> So if the chip supports setting edge vs level trigging,
> this is where you implement it, not as device tree
> properties.

Discussed above

> 
> > +static void altera_gpio_irq_handler(unsigned int irq, struct irq_desc *desc)
> > +{
> > +       struct altera_gpio_chip *altera_gc = irq_desc_get_handler_data(desc);
> > +       struct irq_chip *chip = irq_desc_get_chip(desc);
> > +       struct of_mm_gpio_chip *mm_gc = &altera_gc->mmchip;
> > +       unsigned long status;
> > +
> > +       int base;
> > +       chip->irq_mask(&desc->irq_data);
> > +
> > +       if (altera_gc->level_trigger)
> > +               status = readl(mm_gc->regs + ALTERA_GPIO_DATA);
> 
> So on the level trigged variant you read the ALTERA_GPIO_DATA
> and discard the result? Is it some kind of latch register?

No, the status isn't discarded. It will be & with the peripheral's
interrupt mask to get the interrupts that needs to be handled. 

> 
> 
> > +       else {
> > +               status = readl(mm_gc->regs + ALTERA_GPIO_EDGE_CAP);
> > +               writel(status, mm_gc->regs + ALTERA_GPIO_EDGE_CAP);
> > +       }
> 
> So you need to get the affected register depending on the type set
> in the irq descriptor instead.

Yes you are correct. 

> 
> > +       status &= readl(mm_gc->regs + ALTERA_GPIO_IRQ_MASK);
> > +       for (base = 0; base < mm_gc->gc.ngpio; base++) {
> > +               if ((1 << base) & status) {
> > +                       generic_handle_irq(
> > +                               irq_linear_revmap(altera_gc->irq, base));
> > +               }
> > +       }
> 
> When we looked at this for some IRQ controllers we realized we
> had to write the loop like so:
> 
> while ((stat = readl_relaxed(vic->base + VIC_IRQ_STATUS))) {
> (...)
> }
> 
> Only to avoid missing transient IRQs occuring while we were
> processing another IRQ. (Like, you handle IRQ0, then IRQ4,
> and while you're handling IRQ4, IRQ0 triggers again and
> you miss it.
> 
> Make sure this does not apply to you...

Noted. Thanks for the info. I'll look into this.

> 
> > +       if (of_property_read_u32(node, "level_trigger", &reg)) {
> > +               ret = -EINVAL;
> > +               pr_err("%s: level_trigger value not set in device tree\n",
> > +                       node->full_name);
> > +               goto teardown;
> > +       }
> > +       altera_gc->level_trigger = reg;
> 
> So I'm suspicious about this.

Discussed above. 

> 
> Yours,
> Linus Walleij
> 

Thanks. 
Tien Hock Loh


