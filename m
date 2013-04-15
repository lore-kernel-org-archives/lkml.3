Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933266Ab3DOMjE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 08:39:04 -0400
Received: from vsp-authed02.binero.net ([195.74.38.226]:20890 "HELO
	vsp-authed-03-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753638Ab3DOMjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 08:39:00 -0400
Message-ID: <516BF4DA.6000204@gaisler.com>
Date: Mon, 15 Apr 2013 14:38:50 +0200
From: Andreas Larson <andreas@gaisler.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        software@gaisler.com
Subject: Re: [PATCH v5 3/3] gpio: grgpio: Add irq support
References: <1363355140-28216-1-git-send-email-andreas@gaisler.com> <1363355140-28216-4-git-send-email-andreas@gaisler.com> <CACRpkdZ4AK=3PGQ-3+ffWsH9B-ywrDkMxnePWat1=P7WoqgJWA@mail.gmail.com>
In-Reply-To: <CACRpkdZ4AK=3PGQ-3+ffWsH9B-ywrDkMxnePWat1=P7WoqgJWA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-04-10 21:25, Linus Walleij wrote:
> On Fri, Mar 15, 2013 at 2:45 PM, Andreas Larsson <andreas@gaisler.com> wrote:
>
>> The drivers sets up an irq domain and hands out unique virqs to irq
>> capable gpio lines regardless of which underlying irqs maps to which gpio
>> line.
>>
>> Signed-off-by: Andreas Larsson <andreas@gaisler.com>
> (...)
>> +- irqmap : An array with an index for each gpio line. An index is either a valid
>> +       index into the interrupts property array, or 0xffffffff that indicates
>> +       no irq for that line. Driver provides no interrupt support if not
>> +       present.
>
> This looks really complicated.
>
> Can't you just do this with a flag instead?
>
> irq-enabled-mask = <0xf0f0f0f0>;
>
> Like 0xf0f0f0f0 would indicate that lines 0-3, 8-11, 16-19 and 24-27
> have no IRQ, lines 4-7, 12-15, 20-23 and 28-31 does have IRQ.
>
> Then supply the resulting 16 IRQs in the interrupts property.
>
> But you should double-check this with some more DT-aware person
> I guess, there may be precedents. Did you get this idea from
> some other binding?
>
>> +struct grgpio_uirq {
>> +       u8 refcnt; /* Reference counter to manage requesting/freeing of uirq */
>> +       u8 uirq; /* Underlying virq of the gpio driver */
>
> This looks very complicated. But well, maybe there are no
> other ways...

The reason for the complex handling is that any line can any one irq of
the irqs of the gpio core or no irq at all - completely independenly of
each other.

E.g. we can have a a system where:
- line 0 has no irq
- line 1 has irq 7
- line 2 has irq 9
- line 3 has irq 7
- line 4 has no irq
- line 5 has irq 4
- etc.

That is the reason why the "imap" of property (originating from the
PROM) contains an index that maps a line to one of the irqs of the core
or indicates no irq at all.


> If you do this you will need some spinlock to protect the refcount,
> or make it an atomic type. Another way is to use <linux/kref.h>
> if you refactor around that.

Yes, I use the bgpio-lock for that but I missed using it in the irq 
handler - added.


>
>> +};
>> +
>> +struct grgpio_lirq {
>> +       s8 index; /* Index into struct grgpio_priv's uirqs, or -1 */
>> +       u8 virq; /* virq for the gpio line */
>
> Just call it irq. These are Linux irqs, they are not "virtual".

Sure

>
>> +       u32 imask; /* irq mask shadow register */
>> +
>> +       /* The grgpio core can have multiple irqs. Severeal gpio lines can
>> +        * potentially be mapped to the same irq. This driver sets up an
>> +        * irq domain and hands out separate virqs to each gpio line
>> +        */
>
> This is very common. Most GPIO controller have something like
> one IRQ line per 32 GPIO lines. It's a bit odd that it can have
> an arbitrary number of non-irq capable GPIOs though.
>
> Note:
>
> /*
>   * I really prefer this comment style, where ther is no text on the
>   * first line of the comment.
>   */

Sure

>> +       struct irq_domain *domain;
>> +
>> +       /* This array contains information on each underlying irq, each
>> +        * irq of the grgpio core itself.
>> +        */
>> +       struct grgpio_uirq uirqs[GRGPIO_MAX_NGPIO];
>
> So "u" is for "underlying"?

Yes

>> +
>> +       /* This array contains information for each gpio line on the
>> +        * virtual irqs obtains from this driver. An index value of -1 for
>> +        * a certain gpio line indicates that the line has no
>> +        * irq. Otherwise the index connects the virq to the underlying
>> +        * irq by pointing into the uirqs array.
>> +        */
>> +       struct grgpio_lirq lirqs[GRGPIO_MAX_NGPIO];
>
> Hm, very complex...
>
>> +static void grgpio_set_imask(struct grgpio_priv *priv, unsigned int offset,
>> +                            int val)
>> +{
>> +       struct bgpio_chip *bgc = &priv->bgc;
>> +       unsigned long mask = bgc->pin2mask(bgc, offset);
>> +       unsigned long flags;
>> +
>> +       spin_lock_irqsave(&bgc->lock, flags);
>> +
>> +       if (val)
>> +               priv->imask |= mask;
>> +       else
>> +               priv->imask &= ~mask;
>> +       bgc->write_reg(&priv->regs->imask, priv->imask);
>
> I prefer:
>
> #define GRGPIO_IMASK 0xnn
>
> bgc->write_reg(priv->base + GRGPIO_IMASK, priv->imask);
>
> (...)
>
>> +       ipol = priv->bgc.read_reg(&priv->regs->ipol) & ~mask;
>> +       iedge = priv->bgc.read_reg(&priv->regs->iedge) & ~mask;
>> +
>> +       priv->bgc.write_reg(&priv->regs->ipol, ipol | pol);
>> +       priv->bgc.write_reg(&priv->regs->iedge, iedge | edge);
>
> Dito on all these.
>
>> +static irqreturn_t grgpio_irq_handler(int irq, void *dev)
>> +{
>> +       struct grgpio_priv *priv = dev;
>> +       int ngpio = priv->bgc.gc.ngpio;
>> +       int i;
>> +
>> +       for (i = 0; i < ngpio; i++) {
>> +               struct grgpio_lirq *lirq = &priv->lirqs[i];
>> +
>> +               if (priv->imask & BIT(i) && lirq->index >= 0 &&
>> +                   priv->uirqs[lirq->index].uirq == irq) {
>> +                       generic_handle_irq(lirq->virq);
>> +               }
>
> Should there not be an else clause here handling invalid
> interrupts or printing an error or something?

Not an else clause per se, as we need to loop through all the lines and
only treat the ones that should be triggered by the given underlying
irq. I'll add a comment on what it is all about.

On the other hand, if no line whatsoever matches it might be good to add
a warning about it. I am not sure if it could legitimately happen on an
SMP system if the irq is unmapped at one CPU at the same time as another
after another CPU has entered this interrupt handler but before taking
the lock protecting the uirq structure.

>
>> +       }
>> +
>> +       return IRQ_HANDLED;
>> +}
>
>
> (...)
>> +
>> +/* This function will be called as a consequence of the call to
>> + * irq_create_mapping in grgpio_to_irq
>> + */
>> +int grgpio_irq_map(struct irq_domain *d, unsigned int virq,
>> +                  irq_hw_number_t hwirq)
>> +{
>> +       struct grgpio_priv *priv = d->host_data;
>> +       struct grgpio_lirq *lirq;
>> +       struct grgpio_uirq *uirq;
>> +       unsigned long flags;
>> +       int offset = hwirq;
>> +       int ret = 0;
>> +
>> +       if (!priv)
>> +               return -EINVAL;
>> +
>> +       lirq = &priv->lirqs[offset];
>> +       if (lirq->index < 0)
>> +               return -EINVAL;
>> +
>> +       dev_dbg(priv->dev, "Mapping virq %d for gpio line %d\n",
>> +               virq, offset);
>> +
>> +       spin_lock_irqsave(&priv->bgc.lock, flags);
>> +
>> +       /* Request underlying irq if not already requested */
>> +       lirq->virq = virq;
>> +       uirq = &priv->uirqs[lirq->index];
>> +       if (uirq->refcnt == 0) {
>> +               ret = request_irq(uirq->uirq, grgpio_irq_handler, 0,
>> +                                 dev_name(priv->dev), priv);
>
>
> No, please request all present uirqs in probe() before creating the
> irqdomain.


The reason for doing it at irq_map and not in probe is that one
typical hardware setup for this core is that it has irqs that are shared
with pretty much all other cores in the system. Therefore, if this
drivers requests all its irqs in the probe function, pretty much all the
drivers for the other cores in the system that were not lucky enough to
request their irq before this driver will fail their probes in such a
hardware setup. This driver can not share irq:s so even if the other
drivers can handle shared irqs they are out of luck if this driver is
probed first.

That is why only the irqs that are actually used should be requested and
thus why the driver does it on demand instead of in the probe.


> And use devm_request_irq() for that.
>
>> +               if (ret) {
>> +                       dev_err(priv->dev,
>> +                               "Could not request underlying irq %d\n",
>> +                               uirq->uirq);
>> +
>> +                       spin_unlock_irqrestore(&priv->bgc.lock, flags);
>> +
>> +                       return ret;
>> +               }
>> +       }
>> +       uirq->refcnt++;
>> +
>> +       spin_unlock_irqrestore(&priv->bgc.lock, flags);
>> +
>> +       /* Setup virq  */
>> +       irq_set_chip_data(virq, priv);
>> +       irq_set_chip_and_handler(virq, &grgpio_irq_chip,
>> +                                handle_simple_irq);
>> +       irq_clear_status_flags(virq, IRQ_NOREQUEST);
>> +#ifdef CONFIG_ARM
>> +       set_irq_flags(virq, IRQF_VALID);
>> +#else
>> +       irq_set_noprobe(virq);
>> +#endif
>> +
>> +       return ret;
>> +}
>> +
>> +void grgpio_irq_unmap(struct irq_domain *d, unsigned int virq)
>> +{
>> +       struct grgpio_priv *priv = d->host_data;
>> +       int index;
>> +       struct grgpio_lirq *lirq;
>> +       struct grgpio_uirq *uirq;
>> +       unsigned long flags;
>> +       int ngpio = priv->bgc.gc.ngpio;
>> +       int i;
>> +
>> +#ifdef CONFIG_ARM
>> +       set_irq_flags(virq, 0);
>> +#endif
>> +       irq_set_chip_and_handler(virq, NULL, NULL);
>> +       irq_set_chip_data(virq, NULL);
>> +
>> +       spin_lock_irqsave(&priv->bgc.lock, flags);
>> +
>> +       /* Free underlying irq if last user unmapped */
>> +       index = -1;
>> +       for (i = 0; i < ngpio; i++) {
>> +               lirq = &priv->lirqs[i];
>> +               if (lirq->virq == virq) {
>> +                       grgpio_set_imask(priv, i, 0);
>> +                       lirq->virq = 0;
>> +                       index = lirq->index;
>> +                       break;
>> +               }
>> +       }
>> +       WARN_ON(index < 0);
>> +
>> +       if (index >= 0) {
>> +               uirq = &priv->uirqs[lirq->index];
>> +               uirq->refcnt--;
>> +               if (uirq->refcnt == 0)
>> +                       free_irq(uirq->uirq, priv);
>> +       }
>
>
> Don't do that either. devm_request_irq() will free the
> IRQ when the driver unloads. No need for messy code
> trying to cover it up.
>
>> +       spin_unlock_irqrestore(&priv->bgc.lock, flags);
>>   }
>>
>> +static struct irq_domain_ops grgpio_irq_domain_ops = {
>> +       .map    = grgpio_irq_map,
>> +       .unmap  = grgpio_irq_unmap,
>> +};
>> +
>> +/* ------------------------------------------------------------ */
>> +
>>   static int grgpio_probe(struct platform_device *ofdev)
>>   {
>>          struct device_node *np = ofdev->dev.of_node;
>> @@ -75,6 +329,9 @@ static int grgpio_probe(struct platform_device *ofdev)
>>          struct resource *res;
>>          int err;
>>          u32 prop;
>> +       s32 *irqmap;
>> +       int size;
>> +       int i;
>>
>>          priv = devm_kzalloc(&ofdev->dev, sizeof(*priv), GFP_KERNEL);
>>          if (!priv)
>> @@ -94,6 +351,7 @@ static int grgpio_probe(struct platform_device *ofdev)
>>          }
>>
>>          priv->regs = regs;
>> +       priv->imask = bgc->read_reg(&regs->imask);
>>          priv->dev = &ofdev->dev;
>>
>>          gc = &bgc->gc;
>> @@ -119,6 +377,49 @@ static int grgpio_probe(struct platform_device *ofdev)
>>                  gc->ngpio = prop;
>>          }
>>
>> +       /* The irqmap contains the index values indicating which underlying irq,
>> +        * if anyone, is connected to that line
>> +        */
>> +       irqmap = (s32 *)of_get_property(np, "irqmap", &size);
>> +       if (irqmap) {
>> +               if (size < gc->ngpio) {
>> +                       dev_err(&ofdev->dev,
>> +                               "irqmap shorter than ngpio (%d < %d)\n",
>> +                               size, gc->ngpio);
>> +                       return -EINVAL;
>> +               }
>
>
> So devm_request all uirqs somehere like here.
>
>> +               priv->domain = irq_domain_add_linear(np, gc->ngpio,
>> +                                                    &grgpio_irq_domain_ops,
>> +                                                    priv);
>
> Then move this below the loop, so you know you have all uirqs
> when you create the domain.
>
>> +               if (!priv->domain) {
>> +                       dev_err(&ofdev->dev, "Could not add irq domain\n");
>> +                       return -EINVAL;
>> +               }
>> +
>> +               for (i = 0; i < gc->ngpio; i++) {
>> +                       struct grgpio_lirq *lirq;
>> +                       int ret;
>> +
>> +                       lirq = &priv->lirqs[i];
>> +                       lirq->index = irqmap[i];
>> +
>> +                       if (lirq->index < 0)
>> +                               continue;
>> +
>> +                       ret = platform_get_irq(ofdev, lirq->index);
>> +                       if (ret <= 0) {
>> +                               /* Continue without irq functionality for that
>> +                                * gpio line
>> +                                */
>> +                               dev_err(priv->dev,
>> +                                       "Failed to get irq for offset %d\n", i);
>> +                               continue;
>> +                       }
>> +                       priv->uirqs[lirq->index].uirq = ret;
>> +               }
>> +       }
>> +
>>          platform_set_drvdata(ofdev, priv);
>>
>>          err = gpiochip_add(gc);
>> @@ -127,8 +428,8 @@ static int grgpio_probe(struct platform_device *ofdev)
>>                  return err;
>>          }
>>
>> -       dev_info(&ofdev->dev, "regs=0x%p, base=%d, ngpio=%d\n",
>> -                priv->regs, gc->base, gc->ngpio);
>> +       dev_info(&ofdev->dev, "regs=0x%p, base=%d, ngpio=%d, irqs=%s\n",
>> +                priv->regs, gc->base, gc->ngpio, priv->domain ? "on" : "off");
>>
>>          return 0;
>>   }
> (...)

Thanks for the feedback!

Cheers,
Andreas Larsson

